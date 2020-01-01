  %di=oes correction in srtm geoid elevation data
function srtm_egm1996to2008(ipparameter, turn)
%--------------------------------------------------------------------------
%This function read SRTM.tiff files (EGM 96) and converts them to .mat SRTM
%in EGM 2008
%based on Limiting latitudes and longitudes
%Referenced by providing the following values
% INPUT ARGUMENTS
% ----------------
% ipparameter.path_dir_from1: %path to SRTM
% ipparameter.path_dir_from2; %path to egm
% ipparameter.path_dir_to: % path to save the resultant SRTM .mat file
% ---------------------------------------------------------------------
% OUTPUT FILE
% -------------
% 'srtm' : SRTM file  
%---------------------------------------------------------------------
% Reference : 
% Author: Contact Vibhor Agarwal (agarwal.282@osu.edu) 
% ----------------------------------------------------------------------
if strcmp(turn, 'off'); return; end;
path_dir_from1=ipparameter.path_dir_from1; %
path_dir_from2=ipparameter.path_dir_from2; %path to egm
path_dir_to=ipparameter.path_dir_to; 
% lim_lon=ipparameter.lim_lon; %Same inputs as in "cs2_sini_egm_region_extracter"
% lim_lat=ipparameter.lim_lat;
fx_mkdir(path_dir_to);

%--------------------------------------------------------------------------
% EGM
path_egm_read=fullfile(path_dir_from2, 'egm.mat'); %read EGM file
egm=fx_load(path_egm_read);
egm.dN_vct=egm.N2008_vct-egm.N1996_vct;
F=scatteredInterpolant(egm.lon_vct, egm.lat_vct, egm.dN_vct, 'linear'); %Scattered Interpolation

%--------------------------------------------------------------------------
% SRTM EGM1996 to EGM2008
[filenamelist, nfile]=fx_dir(path_dir_from1, '*.tif'); %SRTM is in .tif format
for ifile=1:nfile
    % path
    filename_read=filenamelist(ifile).name;
    filename_save=fx_reext(filename_read, '.mat'); %.tif to be replaced by .mat
    path_file_read=fullfile(path_dir_from1, filename_read);
    path_file_save=fullfile(path_dir_to, filename_save);
    % read
    s=icesat_srtm_reader(path_file_read);
    [nrow, ncol]=size(s.elev_grd);
%     I=min(s.lim_lon)>=min(lim_lon) & max(s.lim_lon)<=max(lim_lon) & ...
%         min(s.lim_lat)>=min(lim_lat) & max(s.lim_lat)<=max(lim_lat);
%     if ~I; continue; end;
    % transform
    srtm=s;
    srtm.elev_vct=s.elev_vct-F(s.lon_vct, s.lat_vct);
    srtm.elev_grd=reshape(srtm.elev_vct, nrow, ncol);
    % save
    
    save(path_file_save,'srtm'); %srtm variable to be saved to the .mat file named in Line 23
end

end