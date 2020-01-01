    function convert_gis_ICESAT_14(ipparameter)
    path_dir_from1=ipparameter.path_dir_from1;
    path_dir_save=ipparameter.path_dir_to;
    [f1,~]=fx_dir(path_dir_from1,'.mat');
    load(fullfile(path_dir_from1,f1.name));
    T = [s.lat,s.lon,s.time, s.elev_a, s.elev_b, s.Geoid, s.SRTM30_elev,s.geoid_diff'];
    cHeader = {'LAT' 'LON' 'TIME' 'ELE_A' 'ELE_B' 'GEOID', 'SRTM' 'GEOID_DIFF'}; %dummy header
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    
    filename = fullfile(path_dir_save,'ALASKA.csv');
    
    %write header to file
    fid = fopen(filename,'w'); 
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);
    
    %write data to end of file
    
    dlmwrite(filename,T,'-append');
    
    
    T1=[s.deltaEllip, s.d_erElv, s.d_ldElv, s.d_eqElv, s.sat_corr_flg, s.sat_corr_flg, s.d_dTrop, s.d_wTrop];
    cHeader2 = {'deltaEllip' 'd_erElv' 'd_ldElv' 'd_eqElv' 'sat_corr_flg', 'sat_corr_flg'}; %dummy header
    commaHeader2 = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader2 = commaHeader2(:)';
    textHeader2 = cell2mat(commaHeader2); %cHeader in text with commas
    
    filename2 = fullfile(path_dir_save,'access.csv');
    
    fid2 = fopen(filename2,'w'); 
    fprintf(fid2,'%s\n',textHeader);
    fclose(fid2);
    
    
    
    %write data to end of file
    
    dlmwrite(filename2,T1,'-append');
    end