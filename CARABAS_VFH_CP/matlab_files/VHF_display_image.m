function out = VHF_display_image(m,p,image_dir,tlist_dir,dlimits)

% out = VHF_display_image(m,p,image_dir,tlist_dir,dlimits)
% 
% Displays a VHF SAR image and adds marks where targets are placed
%
% m - flight mission number (1=v02_2, 2=v02_3, 3=v02_4, 4=v02_5)
% p - flight pass number within mission (1 <= p <= 6)
% image_dir - Directory where the image data set is stored (e.g. 'C:\VHF_CD_challenge\images\')
% tlist_dir - Directory where the target lists are stored (e.g. 'C:\VHF_CD_challenge\target_lists\')
% dlimits - Display limits (percent of max value) (e.g. dlimits = [0 0.4])
% out - handle to figure window

% Get image information
Mission = VHF_get_mission_info;
name = Mission(m).Name;
deployment = Mission(m).Deployment;
heading = Mission(m).Pass(p).heading;
inc = Mission(m).Pass(p).incidence_angle;
rfi = Mission(m).Pass(p).RFI;
fn = Mission(m).Pass(p).fn;

% Read image from file
imfn = [image_dir, fn];
info = VHF_get_image_info;
im = VHF_read_image(imfn,info.n_cols,info.n_rows,1,info.n_cols,1,info.n_rows);

% Display image
figure;
h = imagesc(im);
axis image;
colormap gray;

% Change figure display limits
if ~isempty(dlimits)
    if length(dlimits) == 2
        if (dlimits(1) <= dlimits(2)) & (dlimits(1) >= 0) & (dlimits(1) <= 1) & (dlimits(2) >= 0) & (dlimits(2) <= 1)
            lim1 = dlimits(1)*max(max(im));
            lim2 = dlimits(2)*max(max(im));
            set(get(h,'Parent'),'Clim', [lim1 lim2]);
        end
    else
        disp('ERROR in VHF_display_image: dlimits');
    end
end

% Add target marks to figure
if ~isempty(tlist_dir)
    tlist_fn = [tlist_dir,deployment,'.Targets.txt'];
    [timage tlist] = VHF_make_target_image(tlist_fn,VHF_get_image_info,0);
    [target_row,target_col] = find(timage>0);
    clear timage tlist;
    hp = VHF_show_marks(get(h,'Parent'), target_row, target_col, 'g', 'o');
end

% Put image info in figure title
titl = {strrep(fn,'_','\_'); ...
    ['Flight Heading: ', num2str(heading), '\circ', ...
    '  Incidence Angle: ', num2str(inc), '\circ', ...
    '  Deployment: ', strrep(deployment,'_','\_')]};
title(titl);

out = get(h,'Parent');
