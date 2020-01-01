function TIME_SEPARATOR_2(ipparameter)
%Function to compute dh (CRyosat-SRTM) and save those footprints where dh<100
%Referenced by providing the following values

% INPUT ARGUMENTS
% ipparameter.path_dir_from: %path to (corrected) cryosat home directory
% ipparameter.path_dir_from2: % path to SRTM (glacier) 30 m 
% ipparameter.path_dir_to: % path to save the resultant Cryosat file

% OUTPUT FILE
% 'cs2' : a structure with fields

path_dir_from1=ipparameter.path_dir_from1; %path to list of structures to be merged
%path_dir_from2=ipparameter.path_dir_from2;
%path_dir_rgi=ipparameter.path_dir_rgi;
path_dir_save=ipparameter.path_dir_to; %path to directory where structures have to be stored
[f1,~]=fx_dir(path_dir_from1,'.mat');
cryosat2=fx_load(fullfile(path_dir_from1,f1.name));
LAT=cryosat2.lat;
LON=cryosat2.lon;
TIME=cryosat2.time;
ELE_C=cryosat2.elev_a;
GEOID=cryosat2.Geoid;
%DH_90=a(:,6);

n = datestr(datenum(TIME,1,0));
year=str2num(n(:,8:11));

for iy=2010:2016
%     dh=[];
%     srtm=[];
%     csat=[];
%     lat=[];
%     lon=[];
%     time=[];
%     for im=1:12
    I=find(year==iy); %strcmp(month,month_AUT(im)));
    if isempty(I); continue;end   
          %t1=DH_90(I);
          %dh=[dh;t1];
          t2=GEOID(I);
          %srtm=[srtm;t2];
          t3=ELE_C(I);
          %csat=[csat;t3];
          t4=LAT(I);
          %lat=[lat;t4];
          t5=LON(I);
          %lon=[lon;t5];
          t6=TIME(I);
          %time=[time;t6];

    
    name=strcat('HMA',num2str(iy),'.csv');
    filename=fullfile(path_dir_save,name);
    csvwrite(filename,[]);
    
    M=[t4,t5,t6,t3,t2];
    cHeader = {'LAT' 'LON' 'TIME' 'ELE_C' 'GEOID'}; %dummy header
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    
    %write header to file
    fid = fopen(filename,'w'); 
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);
    
    %write data to end of file
    dlmwrite(filename,M,'precision',10,'-append');
   
end
    