function combine_csv2(ipparameter)

path_dir_save=ipparameter.path_dir_to;
T1=readtable('E:\GLACIER\ARCTICCANADA_N\CS2\DEC\GIS\New folder\m1.csv');
m11=T1.m1;
lat11=T1.LAT;
lon11=T1.LON;
cs21=T1.ELE_C;
geoid11=T1.GEOID;
time11=T1.TIME;

I=find(~isnan(m11));
SRTM_C1=m11(I);
LAT1=lat11(I);
LON1=lon11(I);
GEOID1=geoid11(I);
TIME1=time11(I);
CS21=cs21(I);

T2=readtable('E:\GLACIER\ARCTICCANADA_N\CS2\DEC\GIS\New folder\m22.csv');
m21=T2.m22;
lat21=T2.LAT;
lon21=T2.LON;
cs22=T2.ELE_C;
geoid21=T2.GEOID;
time21=T2.TIME;

data = str2double(m21);
I1=find(~isnan(data));
SRTM_C2=data(I1);

LAT2=lat21(I1);
LON2=lon21(I1);
GEOID2=geoid21(I1);
TIME2=time21(I1);
CS22=cs22(I1);

T2=readtable('E:\GLACIER\ARCTICCANADA_N\CS2\DEC\GIS\New folder\Merged.csv');
m21=T2.Merged;
lat21=T2.LAT;
lon21=T2.LON;
cs22=T2.ELE_C;
geoid21=T2.GEOID;
time21=T2.TIME;

data = str2double(m21);
I1=find(~isnan(data));
SRTM_C3=data(I1);
LAT3=lat21(I1);
LON3=lon21(I1);
GEOID3=geoid21(I1);
TIME3=time21(I1);
CS23=cs22(I1);

% T2=readtable('E:\ICESAT_06_PROCESSED\ALASKA\DEC\GIS\New folder\al_ic_06_4.csv');
% m21=T2.Merged;
% lat21=T2.LAT;
% lon21=T2.LON;
% cs22=T2.ELE_A;
% geoid21=T2.GEOID;
% time21=T2.TIME;
% 
% data = str2double(m21);
% I1=find(~isnan(data));
% SRTM_C4=data(I1);
% LAT4=lat21(I1);
% LON4=lon21(I1);
% GEOID4=geoid21(I1);
% TIME4=time21(I1);
% CS24=cs22(I1);


% CS2=[CS21;CS22; CS23;CS24];
% TIME=[TIME1;TIME2; TIME3;TIME4];
% GEOID=[GEOID1;GEOID2; GEOID3;GEOID4];
% SRTM=[SRTM_C1;SRTM_C2; SRTM_C3;SRTM_C4];
% LAT=[LAT1;LAT2; LAT3;LAT4];
% LON=[LON1;LON2;LON3;LON4];

% CS2=[CS21;CS22];
% TIME=[TIME1;TIME2];
% GEOID=[GEOID1;GEOID2];
% SRTM=[SRTM_C1;SRTM_C2];
% LAT=[LAT1;LAT2];
% LON=[LON1;LON2];

CS2=[CS21;CS22; CS23];
TIME=[TIME1;TIME2; TIME3];
GEOID=[GEOID1;GEOID2; GEOID3];
SRTM=[SRTM_C1;SRTM_C2; SRTM_C3];
LAT=[LAT1;LAT2; LAT3];
LON=[LON1;LON2;LON3];



 T = [LAT,LON,TIME,CS2,GEOID,SRTM];
 T=sortrows(T,3);   
    cHeader = {'LAT' 'LON' 'TIME' 'ELE_C' 'GEOID','SRTM'}; %dummy header
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    
    filename = fullfile(path_dir_save,'ALASKA2.csv');
    
    %write header to file
    fid = fopen(filename,'w'); 
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);
    
    %write data to end of file
    
    dlmwrite(filename,T,'-append');

end
