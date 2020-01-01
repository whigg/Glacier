    function convert_gis3(ipparameter)
    path_dir_from1=ipparameter.path_dir_from1;
    path_dir_save=ipparameter.path_dir_to;
    [f1,~]=fx_dir(path_dir_from1,'.mat');
    load(fullfile(path_dir_from1,f1.name));
    T = [cryosat2.lat,cryosat2.lon,cryosat2.time,cryosat2.elev_a, cryosat2.Geoid];
    
    cHeader = {'LAT' 'LON' 'TIME' 'ELE_C' 'GEOID'}; %dummy header
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    
    filename = fullfile(path_dir_save,'Svalbard.csv');
    
    %write header to file
    fid = fopen(filename,'w'); 
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);
    
    %write data to end of file
    
    dlmwrite(filename,T,'-append');
    
    %csvwrite(filename,T);
    %writetable(T,filename2,'Sheet',1)
    end