function out = VHF_show_marks(ax, row, col, c, m);

% out = VHF_show_marks(ax, row, col, c, m);
% 
% Shows marks in an (image) axes at positions specified by row and col. 
% 
% ax - handle to axes
% row - array with row indexes (same length as col)
% col - array with column indexes (same length as row)
% c - color of marks ('r'-red, 'b'-blue, 'g'-green, 'k'-black, etc.)
% m - symbol used to mark ('o'-rings, 'x'-crosses, etc.)
% out - handle to current axes
% 
% For more info look in the documentation of the function scatter. 

axes(ax);
hold on;
scatter(col,row,c,m);

out = ax;
