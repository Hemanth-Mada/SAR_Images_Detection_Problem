function out = VHF_get_image_info()

% out = VHF_get_image_info()
%
% Returns image size and coordinate info
%
% out - Structure holding information on image size and 
%       geographic coordinates
%
% out.n_rows   - Number of rows of the image
% out.n_rows   - Number of cols of the image
% out.east_min - minimum east coordinate of the image 
% out.east_max - maximum east coordinate of the image
% out.north_min - minimum north coordinate of the image 
% out.north_max - maximum north coordinate of the image
% Coordinates are given in Swedish reference system RR92

out.east_min = 1653166;
out.east_max = 1655165;
out.north_min = 7367489;
out.north_max = 7370488;
out.n_rows = 3000;
out.n_cols = 2000;
