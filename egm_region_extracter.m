function egm_region_extracter(ipparameter, turn)
% EGM96 Geopotential Model to degree and order 360. This model uses a 15-minute 
% grid of point values in the tide-free system. This function calculates geoid 
% heights to an accuracy of 0.01 m for this model.

% EGM2008 Geopotential Model to degree and order 2159. This model uses a 2.5-minute 
% grid of point values in the tide-free system. This function calculates geoid 
% heights to an accuracy of 0.001 m for this model.

% The geoid undulations for the EGM96 and EGM2008 models are relative to the WGS84 ellipsoid.
% ----------------------------------------------------------------------
% INPUT ARGUMENTS
% ----------------
% ipparameter.lim_lon: Limits of Latitude nad longitude
% ipparameter.lim_lat
% ipparameter.bin      The spacing of the EGM grid (e.g. 0.0001) 
% ipparameter.path_dir_to: % path to save the resultant EGM.mat file
% ---------------------------------------------------------------------
% OUTPUT FILE
% -------------
% 'egm' : EGM model file for thye selected region 
%---------------------------------------------------------------------
% Reference : 
% Author: Contact Vibhor Agarwal (agarwal.282@osu.edu) 

%--------------------------------------------------------------------------
if strcmp(turn, 'off'); return; end;
path_dir_to=ipparameter.path_dir_to; 
fx_mkdir(path_dir_to);
lim_lon=ipparameter.lim_lon; %PASS THEESE INPUTS and YOU WILL HAVE EGM
lim_lat=ipparameter.lim_lat;
bin=ipparameter.bin;  

%--------------------------------------------------------------------------
% grid
lon_ary=min(lim_lon)-bin:bin:max(lim_lon)+bin; %bin Used for craeting the grid
lat_ary=min(lim_lat)-bin:bin:max(lim_lat)+bin;
[lon_grd, lat_grd]=meshgrid(lon_ary, lat_ary); 
%USAGE [X,Y] = meshgrid(x,y) returns 2-D grid coordinates based on the coordinates contained in vectors x and y.
%X is a matrix where each row is a copy of x, and Y is a matrix where each column is a copy of y. 
%The grid represented by the coordinates X and Y has length(y) rows and length(x) columns.
lon_vct=lon_grd(:); %vector
lat_vct=lat_grd(:);

% geoid height relative to WGS-84 ellipsoid
N1996 = geoid_height(lat_vct, lon_vct, 'egm96-5'); %Compute the height of the geoid above the ellipsoid
N2008 = geoid_height(lat_vct, lon_vct, 'egm2008-1');
[nrow, ncol]=size(lon_grd); %returns number of rows and columns
N1996_grd=reshape(N1996, nrow, ncol); 
N2008_grd=reshape(N2008, nrow, ncol);                                      %usage
                                         %B = reshape(A,sz) reshapes A using the size vector, sz, to define size(B). 
                                         %For example, reshape(A,[2,3]) reshapes A into a 2-by-3 matrix. 
% output
egm.lon_grd=lon_grd;
egm.lat_grd=lat_grd;
egm.N1996_grd=N1996_grd;
egm.N2008_grd=N2008_grd;
egm.dN_grd=egm.N2008_grd-egm.N1996_grd;
egm.lon_vct=lon_vct;
egm.lat_vct=lat_vct;
egm.N1996_vct=egm.N1996_grd(:);
egm.N2008_vct=egm.N2008_grd(:);
egm.dN_vct=egm.dN_grd(:);

% save
path_file_save=fullfile(path_dir_to, 'egm.mat'); %save the file as egm.mat
save(path_file_save, 'egm');

end