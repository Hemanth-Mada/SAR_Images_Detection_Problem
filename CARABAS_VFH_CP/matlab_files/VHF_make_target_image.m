function [timage, tlist] = VHF_make_target_image(tlist_fn,info,radius)

% [timage, tlist] = VHF_make_target_image(tlist_fn,info,radius)
%
% Make a target ground truth image using a target list. 
% 
% tlist_fn - Filename of target list to be used 
%           (e.g. 'C:\VHF_CD_challenge\target_positions\Fredrik.Targets.txt')
% info - Structure holding the image size and coordinates of an image. 
%        This is the structure returned from the function
%        VHF_get_image_info. 
%        (e.g.)
%        info.n_rows   - Number of rows of the image stored in file filename
%        info.n_rows   - Number of cols of the image stored in file filename
%        info.east_min - minimum east coordinate of the image 
%        info.east_max - maximum east coordinate of the image
%        info.north_min - minimum north coordinate of the image 
%        info.north_max - maximum north coordinate of the image
%        Coordinates are given in Swedish reference system RR92. 
% radius - Radius of target object in resulting image. 
%
% timage - Array holding the target image. This image will have the size
%          and coordinates specified by the info structure. For each target in
%          the target list a circle with a radius specified by radius will be placed
%          at the right position in the target image. The circle will be filled by
%          the value corresponding to the target index in the file. 
% tlist - Structure holding information of each target in the target list file. 
%         (e.g.)
%         tlist.N_targets - Number of targets in the list
%         tlist.N_coord(i) - Northern coordinate for target i (Swedish RT90 coordinates)
%         tlist.E_coord(i) - Eastern coordinate for target i (Swedish RT90 coordinates)
%         tlist.target(i) - Target type for target i
%         In the above: 1 <= i <= tlist.N_targets

% Read target list
tlist = VHF_read_target_list(tlist_fn);

% Initiate image data
N_rows = info.north_max - info.north_min + 1;
N_cols = info.east_max - info.east_min + 1;
timage = zeros(N_rows,N_cols);

for target_i = 1:length(tlist.target)
    
    r = info.north_max - round(tlist.N_coord(target_i)) + 1;
    c = round(tlist.E_coord(target_i)) - info.east_min + 1;
    if (r>=1) & (r<=N_rows) & (c>=1) & (c<=N_cols)
        timage(r,c) = target_i;
    end
    
end

if radius > 1
    [x,y] = meshgrid(-radius:radius,-radius:radius);
    kern = sqrt(x.^2 + y.^2);
    kern = kern <= radius;
    timage = conv2(timage,kern*1.0,'same');
end
