% VHF_print_mission_info
%
% Displays mission info for all flight missions and passes 
% for the VHF SAR image data set. 
% Uses the funtion VHF_get_mission_info(). 


Mission = VHF_get_mission_info;

disp(' ');
disp('Mission Information')
disp('**********************************************************');

for mission_i = 1:4
    
    disp(' ');
    disp('----------------------------------------------------------');
    disp(['Mission nr: ', num2str(mission_i)]);
    disp(['Mission Name: ', Mission(mission_i).Name]);
    disp(['Deployment: ', Mission(mission_i).Deployment]);
    disp(' ');
    
    for pass_i = 1:6
        disp(['Pass nr: ', num2str(pass_i)]);
        disp(['Heading: ', num2str(Mission(mission_i).Pass(pass_i).heading)]);
        disp(['Incidence angle: ', num2str(Mission(mission_i).Pass(pass_i).incidence_angle)]);
        disp(['RFI level: ', num2str(Mission(mission_i).Pass(pass_i).RFI)]);
        disp(['File name: ', num2str(Mission(mission_i).Pass(pass_i).fn)]);
        disp(' ');
    end
    
    disp('----------------------------------------------------------');
    disp(' ');
    
end

disp('**********************************************************');
disp(' ');