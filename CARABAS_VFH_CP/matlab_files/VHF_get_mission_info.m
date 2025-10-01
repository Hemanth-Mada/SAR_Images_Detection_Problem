function Mission = VHF_get_mission_info()

% Mission = VHF_get_mission_info();
%
% Returns a structure containing information of 
% each flight mission and the corresponding images 
% for the CARABAS VHF data set. 
% 
%
% The structure has the following fields: 
% Mission(i).Name - Name of mission i (e.g. 'v02_2')
% Mission(i).Deployment - Name of the target deployment for mission i
% Mission(i).Pass(j).heading - Flight heading of pass j in mission i
% Mission(i).Pass(j).incidence_angle - Incidence angle at aimpoint for mission i pass j
% Mission(i).Pass(j).RFI - Indicates whether the RFI level is 'High' or 'Low'
% Mission(i).Pass(j).fn - Filename of the image collected during mission i pass j
%
% There are 4 missions. Each mission have 6 passes. 
% Therefore 1 <= i <= 4, 1 <= j <= 6

image_fns = [{'v02_2_1_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_2_2_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_2_3_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_2_4_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_2_5_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_2_6_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_3_1_2.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_3_2_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_3_3_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_3_4_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_3_5_2.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_3_6_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_4_1_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_4_2_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_4_3_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_4_4_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_4_5_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_4_6_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_5_1_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_5_2_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_5_3_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_5_4_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_5_5_1.a.Fbp.RFcorr.Geo.Magn'}, ...
    {'v02_5_6_1.a.Fbp.RFcorr.Geo.Magn'}];

% Mission info
Mission(1).Name = 'v02_2';
Mission(1).Deployment = 'Sigismund';
Mission(1).Pass(1).heading = 225;
Mission(1).Pass(1).incidence_angle = 58;
Mission(1).Pass(1).RFI = 'High';
Mission(1).Pass(1).fn = image_fns{1};
Mission(1).Pass(2).heading = 135;
Mission(1).Pass(2).incidence_angle = 58;
Mission(1).Pass(2).RFI = 'Low';
Mission(1).Pass(2).fn = image_fns{2};
Mission(1).Pass(3).heading = 225;
Mission(1).Pass(3).incidence_angle = 58;
Mission(1).Pass(3).RFI = 'High';
Mission(1).Pass(3).fn = image_fns{3};
Mission(1).Pass(4).heading = 135;
Mission(1).Pass(4).incidence_angle = 58;
Mission(1).Pass(4).RFI = 'Low';
Mission(1).Pass(4).fn = image_fns{4};
Mission(1).Pass(5).heading = 230;
Mission(1).Pass(5).incidence_angle = 58;
Mission(1).Pass(5).RFI = 'High';
Mission(1).Pass(5).fn = image_fns{5};
Mission(1).Pass(6).heading = 230;
Mission(1).Pass(6).incidence_angle = 58;
Mission(1).Pass(6).RFI = 'High';
Mission(1).Pass(6).fn = image_fns{6};

Mission(2).Name = 'v02_3';
Mission(2).Deployment = 'Karl';
Mission(2).Pass(1).heading = 225;
Mission(2).Pass(1).incidence_angle = 58;
Mission(2).Pass(1).RFI = 'High';
Mission(2).Pass(1).fn = image_fns{7};
Mission(2).Pass(2).heading = 135;
Mission(2).Pass(2).incidence_angle = 58;
Mission(2).Pass(2).RFI = 'Low';
Mission(2).Pass(2).fn = image_fns{8};
Mission(2).Pass(3).heading = 225;
Mission(2).Pass(3).incidence_angle = 58;
Mission(2).Pass(3).RFI = 'High';
Mission(2).Pass(3).fn = image_fns{9};
Mission(2).Pass(4).heading = 135;
Mission(2).Pass(4).incidence_angle = 58;
Mission(2).Pass(4).RFI = 'Low';
Mission(2).Pass(4).fn = image_fns{10};
Mission(2).Pass(5).heading = 230;
Mission(2).Pass(5).incidence_angle = 58;
Mission(2).Pass(5).RFI = 'High';
Mission(2).Pass(5).fn = image_fns{11};
Mission(2).Pass(6).heading = 230;
Mission(2).Pass(6).incidence_angle = 58;
Mission(2).Pass(6).RFI = 'High';
Mission(2).Pass(6).fn = image_fns{12};

Mission(3).Name = 'v02_4';
Mission(3).Deployment = 'Fredrik';
Mission(3).Pass(1).heading = 225;
Mission(3).Pass(1).incidence_angle = 58;
Mission(3).Pass(1).RFI = 'High';
Mission(3).Pass(1).fn = image_fns{13};
Mission(3).Pass(2).heading = 135;
Mission(3).Pass(2).incidence_angle = 58;
Mission(3).Pass(2).RFI = 'Low';
Mission(3).Pass(2).fn = image_fns{14};
Mission(3).Pass(3).heading = 225;
Mission(3).Pass(3).incidence_angle = 58;
Mission(3).Pass(3).RFI = 'High';
Mission(3).Pass(3).fn = image_fns{15};
Mission(3).Pass(4).heading = 135;
Mission(3).Pass(4).incidence_angle = 58;
Mission(3).Pass(4).RFI = 'Low';
Mission(3).Pass(4).fn = image_fns{16};
Mission(3).Pass(5).heading = 230;
Mission(3).Pass(5).incidence_angle = 58;
Mission(3).Pass(5).RFI = 'High';
Mission(3).Pass(5).fn = image_fns{17};
Mission(3).Pass(6).heading = 230;
Mission(3).Pass(6).incidence_angle = 58;
Mission(3).Pass(6).RFI = 'High';
Mission(3).Pass(6).fn = image_fns{18};

Mission(4).Name = 'v02_5';
Mission(4).Deployment = 'Adolf_Fredrik';
Mission(4).Pass(1).heading = 225;
Mission(4).Pass(1).incidence_angle = 58;
Mission(4).Pass(1).RFI = 'High';
Mission(4).Pass(1).fn = image_fns{19};
Mission(4).Pass(2).heading = 135;
Mission(4).Pass(2).incidence_angle = 58;
Mission(4).Pass(2).RFI = 'Low';
Mission(4).Pass(2).fn = image_fns{20};
Mission(4).Pass(3).heading = 225;
Mission(4).Pass(3).incidence_angle = 58;
Mission(4).Pass(3).RFI = 'High';
Mission(4).Pass(3).fn = image_fns{21};
Mission(4).Pass(4).heading = 135;
Mission(4).Pass(4).incidence_angle = 58;
Mission(4).Pass(4).RFI = 'Low';
Mission(4).Pass(4).fn = image_fns{22};
Mission(4).Pass(5).heading = 230;
Mission(4).Pass(5).incidence_angle = 58;
Mission(4).Pass(5).RFI = 'High';
Mission(4).Pass(5).fn = image_fns{23};
Mission(4).Pass(6).heading = 230;
Mission(4).Pass(6).incidence_angle = 58;
Mission(4).Pass(6).RFI = 'High';
Mission(4).Pass(6).fn = image_fns{24};
