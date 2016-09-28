function wordBar(allValues)
% WORDBAR plots a bar graph of the individual values (letters) in 'allValues'.
%
%   INPUT
%       allValues: A column vector of letters, (e.g. allValues = ['h';'g';'c';'h'])
%
% John W. Miller
% 2015-12-09

% Count the unique letters
allValues = sort(allValues);
letters = unique(allValues);
letterCounts = countmember(letters,allValues);
n_unique = length(letterCounts);

% Show the bar plot
figure, bar(letterCounts);
xlim(xlim + [-1 +1]), ylim(ylim + [0 1])
set(gca,'xtick',1:n_unique,'xticklabel',letters,'fontsize',12)

end % End of main