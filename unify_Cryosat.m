function unify_Cryosat(ipparameter)
path_dir_from=ipparameter.path_dir_from;
path_dir_to=ipparameter.path_dir_to;
elev_a=[];
elev_b=[];
Geoid=[];
time=[];
lat=[];
lon=[];
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
         tempo3=s1.elev_a;
         elev_a=[elev_a;tempo3];
         tempo4=s1.elev_b;
         elev_b=[elev_b;tempo4];
         tempo5=s1.Geoid;
         Geoid=[Geoid;tempo5];
         tempo6=s1.time;
         time=[time;tempo6];
        end
    end
end
        
    s.time=time;
    s.elev_a=elev_a;
    s.elev_b=elev_b;
    s.Geoid=Geoid;
    s.lat=lat;
    s.lon=lon;
    %s.elev_a=s.elev_a+s.Geoid;
    path_file_save=fullfile(path_dir_to,'CRYOSAT_combined.mat');
    save(path_file_save,'s');
end

          
         

