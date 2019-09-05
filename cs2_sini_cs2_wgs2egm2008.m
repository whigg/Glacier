function cs2_sini_cs2_wgs2egm2008(ipparameter, turn)
% EGM2008 Geopotential Model to degree and order 2159. This model uses a 2.5-minute 
% grid of point values in the tide-free system. This function calculates geoid 
% heights to an accuracy of 0.001 m for this model.
% The geoid undulations are relative to the WGS84 ellipsoid.

%--------------------------------------------------------------------------
if strcmp(turn, 'off'); return; end;
path_dir_from1=ipparameter.path_dir_from1; %cryosat ??
path_dir_from2=ipparameter.path_dir_from2; %egm
path_dir_to=ipparameter.path_dir_to; 
fx_mkdir(path_dir_to);

%--------------------------------------------------------------------------
% read EGM2008
path_egm_read=fullfile(path_dir_from2, 'egm.mat');
egm=fx_load(path_egm_read);
F=TriScatteredInterp(egm.lon_vct, egm.lat_vct, egm.N2008_vct, 'linear');

%--------------------------------------------------------------------------
% WGS-84 to EGM2008
[filenamelist, nfile]=fx_dir(path_dir_from1, '*.mat');
for ifile=1:nfile
    % path
    filename_read=filenamelist(ifile).name;
    path_file_read=fullfile(path_dir_from, filename_read);
    % read
    cs2=fx_load(path_file_read);
    % convertion
    N2008 = F(cs2.lon, cs2.lat);
    cs2.elev_egm208=cs2.elev-N2008;
    % save
    path_file_save=fullfile(path_dir_to, filename_read);
    save(path_file_save,'cs2');

end

end
