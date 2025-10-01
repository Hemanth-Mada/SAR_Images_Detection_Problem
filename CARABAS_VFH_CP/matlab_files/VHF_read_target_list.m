function out = VHF_read_target_list(fn)

% out = VHF_read_target_list(fn)
%
% Reads a target list (ground truth) and returns a structure with info for
% each target in the list. 
% 
% fn - Filename of target list file (e.g. 'C:\VHF_CD_challenge\target_positions\Fredrik.Targets.txt')
% out - Structure holding info on each target in the list
%       (e.g.)
%       out.N_targets - Number of targets in the list
%       out.N_coord(i) - Northern coordinate for target i (Swedish RT90 coordinates)
%       out.E_coord(i) - Eastern coordinate for target i (Swedish RT90 coordinates)
%       out.target(i) - Target type for target i
%       In the above: 1 <= i <= out.N_targets

fid = fopen(char(fn),'r');

tline = fgetl(fid);
ind = 0;
while (ischar(tline))
    
    ind = ind + 1;
    ind_ws = find(isspace(tline));
    if (length(tline) > 2)
        out.N_coord(ind) = str2num(tline(1:ind_ws(1)-1));
        out.E_coord(ind) = str2num(tline(ind_ws(1)+1:ind_ws(2)-1));
        out.target(ind) = {tline(ind_ws(2)+1:end)};
    end
    tline = fgetl(fid);
end
status = fclose(fid);

out.N_targets = length(out.N_coord);
