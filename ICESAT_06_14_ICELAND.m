function ICESAT_06_14_ICELAND(ipparameter)
%Function to compute dh (CRyosat-SRTM) and save those footprints where dh<100
%Referenced by providing the following values

% INPUT ARGUMENTS
% ipparameter.path_dir_from: %path to (corrected) cryosat home directory
% ipparameter.path_dir_from2: % path to SRTM (glacier) 30 m 
% ipparameter.path_dir_to: % path to save the resultant Cryosat file

% OUTPUT FILE
% 'cs2' : a structure with fields

path_dir_from1=ipparameter.path_dir_from1; %path to list of structures to be merged
path_dir_from2=ipparameter.path_dir_from2;
%path_dir_rgi=ipparameter.path_dir_rgi;
path_dir_save=ipparameter.path_dir_to; %path to directory where structures have to be stored


[f1,~]=fx_dir(path_dir_from1,'.csv');
filename=fullfile(path_dir_from1,f1.name);

T2=readtable(filename);
%T22=table2array(T2);

LAT=T2.LAT;
LON=T2.LON;
GEOID=T2.GEOID;
TIME=T2.TIME;

%ELE_C=T22(:,4);
ELE_C=T2.ELE_A;
%ELE_CB=T2.ELE_B;
%GEOID_DIFF=T22(:,8);
GEOID_DIFF=T2.GEOID_DIFF;
ELE_C=ELE_C+GEOID_DIFF;
ELE_S=T2.SRTM_m;
% ELE_S=T22(:,9);



[f2,~]=fx_dir(path_dir_from2,'.csv');
filename2=fullfile(path_dir_from2,f2.name);

T2=readtable(filename2);


% T2=readtable(filename2);
% T22=table2array(T2);

LAT2=T2.LAT;
LON2=T2.LON;
GEOID2=T2.GEOID;
TIME2=T2.TIME;

%ELE_C=T22(:,4);
ELE_C2=T2.ELE_A;
%ELE_CB=T2.ELE_B;
%GEOID_DIFF=T22(:,8);
GEOID_DIFF2=T2.GEOID_DIFF;
ELE_C2=ELE_C2+GEOID_DIFF2;
ELE_S2=T2.EUROPE;

% LAT2=T22(:,1);
% LON2=T22(:,2);
% GEOID2=T22(:,5);
% TIME2=T22(:,3);
% % LAT2=T2.LAT;
% % LON2=T2.LON;
% % GEOID2=T2.GEOID;
% % TIME2=T2.TIME;
% ELE_C2=T22(:,4);
% %ELE_CB=T2.ELE_B;
% %GEOID_DIFF2=T22(:,8);
% GEOID_DIFF2=T22(:,7);
% ELE_C2=ELE_C2+GEOID_DIFF2;
% ELE_S2=T22(:,6);
% %ELE_S2=T2.SRTM;
% 
% 
% 



 s.lat=[LAT; LAT2];
 s.lon=[LON; LON2];
 s.elev_a=[ELE_C; ELE_C2];
 s.SRTM=[ELE_S; ELE_S2];
 s.Geoid=[GEOID; GEOID2];
 s.time=[TIME; TIME2];
 s.geoid_diff=[GEOID_DIFF; GEOID_DIFF2];
%  s.lat=[TIME, TIME2];
%  s.

T = [s.lat,s.lon,s.time, s.elev_a, s.Geoid, s.SRTM,s.geoid_diff];
    cHeader = {'LAT' 'LON' 'TIME' 'ELE_C' 'GEOID', 'SRTM' 'GEOID_DIFF'}; %dummy header
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    
filename = fullfile(path_dir_save,'ANDES.csv');
    
    %write header to file
    fid = fopen(filename,'w'); 
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);
    
    %write data to end of file
    
    dlmwrite(filename,T,'-append');
end
    