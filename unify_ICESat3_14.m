function unify_ICESat3_14(ipparameter)
path_dir_from=ipparameter.path_dir_from;
path_dir_to=ipparameter.path_dir_to;
elev=[];
sat_elev_Corr=[];
Geoid_Height=[];
time=[];
lat=[];
lon=[];
sat_corr_flg=[];
%SRTM_HiRes_elev=[];

d_dTrop=[];
d_wTrop=[];

SRTM30_elev=[];
deltaEllip=[];
d_erElv=[];
d_ldElv=[];
d_eqElv=[];
%d_ElevBiasCorr=[];



[yearnamelist, nyear]=fx_dir(path_dir_from);
for iy=1:nyear
    yearname=yearnamelist(iy).name;
    path_dir_year=fullfile(path_dir_from, yearname,filesep); %year
    % month
    [monthnamelist, nmonth]=fx_dir(path_dir_year);
    for im=1:nmonth
        monthname=monthnamelist(im).name;
        path_dir_month=fullfile(path_dir_year, monthname,filesep); %month
        % pass
        [filenamelist, nfile]=fx_dir(path_dir_month, '.mat'); %searches all files
        for ifile=1:nfile
         filename=filenamelist(ifile).name;
         file_read=fullfile(path_dir_month,filename);
         s1=fx_load(file_read);
         tempo1=s1.lat;
         lat=[lat;tempo1];
         tempo2=s1.lon;
         lon=[lon;tempo2];
         
         tempo6=s1.time;
         time=[time;tempo6];
         tempo4=s1.elev;
         elev=[elev;tempo4];
         
         tempo5=s1.Geoid_Height;
         Geoid_Height=[Geoid_Height;tempo5];
         
         tempo3=s1.sat_corr_flg;
         sat_corr_flg=[sat_corr_flg;tempo3];
         tempo9=s1.sat_elev_Corr;
         sat_elev_Corr=[sat_elev_Corr;tempo9];
         
         
         tempo7=s1.SRTM30_elev;
         SRTM30_elev=[SRTM30_elev;tempo7];
         
         tempo10=s1.d_dTrop;
         d_dTrop=[d_dTrop;tempo10];
         tempo11=s1.d_wTrop;
         d_wTrop=[d_wTrop;tempo11];
         tempo12=s1.deltaEllip;
         deltaEllip=[deltaEllip;tempo12];
         
         tempo13=s1.d_erElv;
         d_erElv=[d_erElv;tempo13];
         tempo14=s1.d_ldElv;
         d_ldElv=[d_ldElv;tempo14];
         tempo15=s1.d_eqElv;
         d_eqElv=[d_eqElv;tempo15];
%          tempo16=s1.d_ElevBiasCorr;
%          d_ElevBiasCorr=[d_ElevBiasCorr;tempo16];
         
%          tempo8=s1.SRTM_HiRes_elev;
%          SRTM_HiRes_elev=[SRTM_HiRes_elev;tempo8];
         
        end
    end
end
    
    I=find(sat_corr_flg==2);
    s.time=time;
    %s.elev_a=elev_a;
    s.elev_b=elev;
    s.elev_a=elev;
    s.elev_a(I)=elev(I)+sat_elev_Corr(I);
    
    s.Geoid=Geoid_Height;
    s.elev_a=s.elev_a-s.Geoid; %converting elevation with respect to EGM 2008
    s.lat=lat;
    s.lon=lon;
    s.SRTM30_elev=SRTM30_elev;
    %s.SRTM_HiRes_elev=SRTM_HiRes_elev;
    s.sat_elev_Corr=sat_elev_Corr;
    s.sat_corr_flg=sat_corr_flg;
    s.d_erElv=d_erElv;
    s.d_eqElv=d_eqElv;
    s.d_ldElv=d_ldElv;
    %s.d_ElevBiasCorr=d_ElevBiasCorr;
    lon_wgs=mod(s.lon,360);
    s.geoid_diff=geoid_conv_egm(s.lat,lon_wgs);
    s.deltaEllip=deltaEllip;
    s.d_dTrop= d_dTrop;
    s.d_wTrop= d_wTrop;
    %s.elev_a=s.elev_a+s.Geoid;
    path_file_save=fullfile(path_dir_to,'CRYOSAT_combined.mat');
    save(path_file_save,'s');
end

          
         

