function comet_delay(varargin)
%COMET_DELAY  Comet-like trajectory.
%   COMET(Y) displays an animated comet plot of the vector Y.
%   COMET(X,Y) displays an animated comet plot of vector Y vs. X.
%   COMET(X,Y,p) uses a comet of length p*length(Y).  Default is p = 0.10.
%
%   COMET(AX,...) plots into AX instead of GCA.
%
%   Example:
%       t = -pi:pi/200:pi;
%       comet(t,tan(sin(t))-sin(tan(t)))
%
%   See also COMET3.

%   Charles R. Denham, MathWorks, 1989.
%   Revised 2-9-92, LS and DTP; 8-18-92, 11-30-92 CBM.
%   Copyright 1984-2007 The MathWorks, Inc.

% MODIFIED by John W. Miller, to allow for a slowed-down display
% 2014

% Parse possible Axes input
[ax,args,nargs] = axescheck(varargin{:});

error(nargchk(1,4,nargs,'struct'));

% Parse the rest of the inputs
if nargs < 2, x = args{1}; y = x; x = 1:length(y); end
if nargs == 2, [x,y] = deal(args{:}); end
if nargs < 3, p = 0.10; end
if nargs == 3, [x,y,p] = deal(args{:}); end
    %% ADDED, JWM - allows for a plot delay
if nargs < 4, delay = 0; end
if nargs == 4, [x,y,p,delay] = deal(args{:}); end 

if ~isscalar(p) || ~isreal(p) ||  p < 0 || p >= 1
    error(message('MATLAB:comet:InvalidP'));
end

ax = newplot(ax);
if ~ishold(ax)
    [minx,maxx] = minmax(x);
    [miny,maxy] = minmax(y);
    axis(ax,[minx maxx miny maxy])
end
co = get(ax,'colororder');

m = length(x);
k = round(p*m);

if size(co,1)>=3
    colors = [ co(1,:);co(2,:);co(3,:)];
    lstyle = '-';
else
    colors = repmat(co(1,:),3,1);
    lstyle = '--';
end


    % 'head' is the blue marker
head = line('parent',ax,'color',colors(1,:),'marker','.','linestyle','none','erase','none', ...
            'xdata',x(1),'ydata',y(1),'Tag','head');

if 1
% if matlab.graphics.internal.isGraphicsVersion1
    % GraphicsVersion1 implementation %
    
    % Choose first three colors for head, body, and tail
    set(head,'erase','none');
    body = line('parent',ax,'color',colors(2,:),'linestyle',lstyle,'erase','xor', ...
        'xdata',[],'ydata',[],'tag','body','linewidth',3);
            
        % 'tail' is the red trace that lags behind the current drawing
    tail = line('parent',ax,'color',colors(3,:),'linestyle','-','erase','xor', ...
        'xdata',[],'ydata',[],'tag','tail');
    
    n_sources = size(x,1); % Corresponds to n_makers being displayed from kinematic data
    
    % This try/catch block allows the user to close the figure gracefully
    % during the comet animation.
    try
        % Grow the body
        for i = 2:k+1
            j = i-1:i;
            set(head,'xdata',x(i),'ydata',y(i))
            if mod(i,n_sources) ~= 1
                set(body,'xdata',x(j),'ydata',y(j))
                drawnow
                pause(delay)
            end
            if mod(i,10) == 1
                pause(delay)
            end
        end
        
        % Primary loop -- adds the red 'tail' to the comet
        for i = k+2:m
            j = i-1:i;
            set(head,'xdata',x(i),'ydata',y(i))
            if mod(i,n_sources) ~= 1
                set(body,'xdata',x(j),'ydata',y(j))
%                 set(tail,'xdata',x(j-k),'ydata',y(j-k))
                drawnow
                pause(delay)
            end
            if mod(i,10) == 1
                pause(delay)
            end
        end
        
        % Clean up the tail
        for i = m+1:m+k
            j = i-1:i;
%             set(tail,'xdata',x(j-k),'ydata',y(j-k))
            drawnow
            pause(delay)
        end
    catch E
        if ~strcmp(E.identifier, 'MATLAB:class:InvalidHandle')
            rethrow(E);
        end
    end
    
else
    % ~GraphicsVersion1 implementation
    body = matlab.graphics.animation.AnimatedLine('color',colors(2,:),...
        'linestyle',lstyle,...
        'Parent',ax,...
        'MaximumNumPoints',max(1,k),'tag','body');
    tail = matlab.graphics.animation.AnimatedLine('color',colors(3,:),...
        'linestyle','-',...
        'Parent',ax,...
        'MaximumNumPoints',1+m,'tag','tail'); %Add 1 for any extra points
    
    if ( length(x) < 2000 )
        updateFcn = @()drawnow;
    else
        updateFcn = @()drawnow('update');
    end
    
    % Grow the body
    for i = 1:k
        set(head,'xdata',x(i),'ydata',y(i));
        if  ~( body.isvalid() )
            return
        end
        addpoints(body,x(i),y(i));
        updateFcn();
        
    end
    % Add a drawnow to capture any events / callbacks
    drawnow;
    % Primary loop
    for i = k+1:m
        set(head,'xdata',x(i),'ydata',y(i));
        if ~( body.isvalid() )
            return
        end
        addpoints(body,x(i),y(i));
        addpoints(tail,x(i-k),y(i-k));
        updateFcn();
    end
    drawnow;
    % Clean up the tail
    for i = m+1:m+k
        if  ~( body.isvalid() )
            return
        end
        addpoints(tail,x(i-k),y(i-k));
        updateFcn();
    end
    drawnow;
end

end

function [minx,maxx] = minmax(x)
minx = min(x(isfinite(x)));
maxx = max(x(isfinite(x)));
if minx == maxx
    minx = maxx-1;
    maxx = maxx+1;
end
end