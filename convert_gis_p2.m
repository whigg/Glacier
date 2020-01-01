    function convert_gis_p2(ipparameter)
    path_dir_from1=ipparameter.path_dir_from1;
    path_dir_save=ipparameter.path_dir_to;
    [f1,~]=fx_dir(path_dir_from1,'.csv');
    csvread(fullfile(path_dir_from1,f1.name));
    for time= 2010:2017
        if time
        T = [s.lat,s.lon,s.time, s.elev_a, s.Geoid];
    
    filename2 = fullfile(path_dir_save,'HMA.csv');
    csvwrite(filename2,T)
    %writetable(T,filename2,'Sheet',1)
    end