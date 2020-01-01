%Reader for ICESat data
%function icesat=icesat_mat(path_file_read)
function icesat_mat4(ipparameter)
path_dir_from1=ipparameter.path_dir_from;
lim_lon=ipparameter.lim_lon;
lim_lat=ipparameter.lim_lat;
path_dir_to=ipparameter.path_dir_to;
t=0;
%Examples
% ipparameter.path_dir_from='N:\ICESAT DATA\ICESAT\';
% ipparameter.path_dir_to='N:\ICESAT DATA\PROCESS1\';
% ipparameter.lim_lon=[75, 100];
% ipparameter.lim_lat=[25,40];

% [filenamelist, nfile]=fx_dir(ipparameter.path_dir_from, '*.H5');
[yearnamelist, nyear]=fx_dir(path_dir_from1); %read CS2 saved in region_extracter
for i=1:nyear
    % path
    yearname=yearnamelist(i).name;
    path_dir_year=fullfile(path_dir_from1,yearname,filesep);
    [monthnamelist, nmonth]=fx_dir(path_dir_year);
    for j=1:nmonth
        monthname=monthnamelist(j).name;
        path_dir_month=fullfile(path_dir_year, monthname,filesep); %month
        % pass
        [filenamelist, nfile]=fx_dir(path_dir_month, '.H5'); %searches all files
        for ifile=1:nfile
            %disp([num2str(ifile),'processed'])
            filename_read=filenamelist(ifile).name; %check 
            filename_save=fx_reext(filename_read, '.mat'); %will be replacing with .mat extension
             path_file_read=fullfile(path_dir_month, filename_read);
    
%     X,Y,Z and time
try
    fid = H5F.open(path_file_read);
    ELE_dset_id = H5D.open(fid,'/Data_40HZ/Elevation_Surfaces/d_elev');
    ele_data = H5D.read(ELE_dset_id);
    
    
    Y_dset_id = H5D.open(fid,'/Data_40HZ/Geolocation/d_lat');
    Y_data = H5D.read(Y_dset_id);
    X_dset_id = H5D.open(fid,'/Data_40HZ/Geolocation/d_lon');
    X_data = H5D.read(X_dset_id);
    time_dset_id = H5D.open(fid,'/Data_40HZ/Time/d_UTCTime_40');
    time_data = H5D.read(time_dset_id);
%     Saturation Correction Flag
    sat_corr_flg_id=H5D.open(fid,'/Data_40HZ/Quality/sat_corr_flg');
    sat_corr_flg=H5D.read(sat_corr_flg_id);
%    Saturation Elevation Correction
    satElevCorr_id=H5D.open(fid,'Data_40HZ/Elevation_Corrections/d_satElevCorr');
    sat_Elev_Corr=H5D.read(satElevCorr_id);
    
    d_dTrop_id=H5D.open(fid,'Data_40HZ/Elevation_Corrections/d_dTrop');
    d_dTrop=H5D.read(d_dTrop_id);
    
    d_wTrop_id=H5D.open(fid,'Data_40HZ/Elevation_Corrections/d_wTrop');
    d_wTrop=H5D.read(d_wTrop_id);
    
%   SRTM elevation
    SRTM_elev_ID=H5D.open(fid,'Data_40HZ/Geophysical/d_DEM_elv');
    SRTM30_elev=H5D.read(SRTM_elev_ID);

    Geoid_Height_ID=H5D.open(fid,'Data_40HZ/Geophysical/d_gdHt');
    Geoid_Height=H5D.read(Geoid_Height_ID);
        
    deltaEllip_ID=H5D.open(fid,'Data_40HZ/Geophysical/d_deltaEllip');
    deltaEllip=H5D.read(deltaEllip_ID);
    
    d_erElv_ID=H5D.open(fid,'Data_40HZ/Geophysical/d_erElv');
    d_erElv=H5D.read(d_erElv_ID);
    
    d_ldElv_ID=H5D.open(fid,'Data_40HZ/Geophysical/d_ldElv');
    d_ldElv=H5D.read(d_ldElv_ID);
    
    d_eqElv_ID=H5D.open(fid,'Data_40HZ/Geophysical/d_eqElv');
    d_eqElv=H5D.read(d_eqElv_ID);
    
    d_ElevBiasCorr_ID=H5D.open(fid,'Data_40HZ/Geophysical/d_ElevBiasCorr');
    d_ElevBiasCorr=H5D.read(d_ElevBiasCorr_ID);
    
%%     Assignment of values
    I=abs(Y_data)<90;
    icesat.elev=ele_data(I);
    icesat.lat=Y_data(I);
    longi=rem((X_data(I)+180),360)-180;
    icesat.lon=longi;
    icesat.time=time_data(I);
%     Flags
    icesat.sat_corr_flg=sat_corr_flg;
%     icseat.Dry_Trop_flg_ID=Dry_Trop_flg;
%     icesat.Wet_Trop_flg_ID=Wet_Trop_flg;
%     Elevation correction
    icesat.sat_elev_Corr=sat_Elev_Corr;
    icesat.d_dTrop=d_dTrop;
    icesat.d_wTrop=d_wTrop;
    icesat.SRTM30_elev=SRTM30_elev;
    icesat.Geoid_Height=Geoid_Height;
    %icesat.SRTM_HiRes_elev=SRTM_HiRes_elev';
    icesat.deltaEllip=deltaEllip;
    icesat.d_erElv=d_erElv; %Solid Earth Tide Elevation(geoid_height_above_reference_ellipsoid)
    icesat.d_ldElv=d_ldElv; %The load tide elevation applied to each shot.
    icesat.d_eqElv=d_eqElv; %Equilibrium Tide Elevation(sea_surface_height_amplitude_due_to_equilibrium_ocean_tide)
                            %The equilibrium (long period) tide at last valid shot over the ocean.
    icesat.d_ElevBiasCorr=d_ElevBiasCorr; %Correction to elevation based on post flight 
                                          %analysis for biases determined for each campaign. This bias
                                          %correction has not been applied 
                                          %to the data. .To apply the
                                          %correction to the elevations it
                                          %must be ADDED to the elevation estimates


    I=fx_inrectangle(icesat.lon, icesat.lat, lim_lon, lim_lat); %find out points lying inside
    t=t+1;
    disp(t)
    if isempty(I); continue; end;
    icesat_f=fx_rescale_struct(icesat,I); %Here if I=0, cs2 is empty
    path_dir_save=fullfile(path_dir_to,sprintf('%04d',str2num(yearname)),filesep,sprintf('%02d',str2num(monthname)),filesep);
    fx_mkdir(path_dir_save);
    path_file_save=fullfile(path_dir_save,filename_save);
    save(path_file_save,'icesat_f');
    end
        end
    end
end
end