function dh_trend_temp_Europe_seas_trend(ipparameter)
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
%path_dir_ob=ipparameter.path_dir_ob; %path to directory where graphs have to be stored
%lim_lon=ipparameter.lim_lon;
%lim_lat=ipparameter.lim_lat;
%dh=[];
%time=[];
mdh=[];
mtime=[];
slope=[];
lat=[];
lon=[];

[f1,~]=fx_dir(path_dir_from1,'.xlsx');
a=xlsread(fullfile(path_dir_from1,f1.name));
LAT=a(:,1);
LON=a(:,2);
TIME=a(:,3);
ELE_C=a(:,4);
ELE_S=a(:,6);
DH_90=ELE_C-ELE_S;
GEOID=a(:,5);
%ELE_S_90=a(:,8);
%DH_90=ELE_C-ELE_S_90;

%[f2,~]=fx_dir(path_dir_from2,'.mat');

%load(fullfile(path_dir_from2,f2.name));
%cs.dh_t=cs.elev_a-cs2.SRTM_min;
%cs.dh_t=cs.elev_a-cs2.SRTM_min;

I2=find(abs(DH_90)<100);
LAT=LAT(I2);
LON=LON(I2);
TIME=TIME(I2);
ELE_C=ELE_C(I2);
ELE_S=ELE_S(I2);
%DH=DH(I2);
DH_90=DH_90(I2);
GEOID=GEOID(I2);
%DH=DH+10;
DH_90=DH_90+8;

n = datestr(datenum(TIME,1,0));
year=str2num(n(:,8:11));
month=string(n(:,4:6));
monthlist=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
month_AUT=["Aug","Sep","Oct"];
count=1;
    dhf=[];
    srtmf=[];
    csatf=[];
    latf=[];
    lonf=[];
    timef=[];
for iy=2011:2016
    dh=[];
    srtm=[];
    csat=[];
    lat=[];
    lon=[];
    time=[];
    for im=1:3
        
    I=find(year==iy & strcmp(month,month_AUT(im)));
    if isempty(I); continue;end   
          t1=DH_90(I);
          dh=[dh;t1];
          t2=ELE_S(I);
          srtm=[srtm;t2];
          t3=ELE_C(I);
          csat=[csat;t3];
          t4=LAT(I);
          lat=[lat;t4];
          t5=LON(I);
          lon=[lon;t5];
          t6=TIME(I);
          time=[time;t6];
    end
    
    name=strcat('EUROPOPE',num2str(iy),'.csv');
    filename=fullfile(path_dir_save,name);
    csvwrite(filename,[]);
    
    M=[lat,lon,time,srtm,csat,dh];
    cHeader = {'LAT' 'LON' 'TIME' 'ELE_S' 'ELE_C' 'DH'}; %dummy header
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    
    %write header to file
    fid = fopen(filename,'w'); 
    fprintf(fid,'%s\n',textHeader)
    fclose(fid)
    
    %write data to end of file
    dlmwrite(filename,M,'-append');
    
    latf=[latf;lat];
    lonf=[lonf;lon];
    timef=[timef;time];
    srtmf=[srtmf;srtm];
    csatf=[csatf;csat];
    dhf=[dhf;dh];
   
end
   %dhf=flipud(dhf);  
for iy=2010:2016
    
    for im=8:10
        
    I1=find(year==iy & strcmp(month,monthlist(im)));
    if isempty(I1); continue;end
          
          temp11=median(DH_90(I1));
          %if (abs(temp11)>18) continue;end
          mdh=[mdh;temp11];
          temp22=median(TIME(I1));
          mtime=[mtime; temp22];
    end
end
          
%     if isfield(cs2,'slope')
%     T = table(cs.lat,cs.lon,cs.time,cs.dh_t,cs2.slope);
%     else
%     T = table(cs.lat,cs.lon,cs.time,cs.dh_t);
%     end
%     filename2 = fullfile(path_dir_save,'ALASKA.xlsx');
%     writetable(T,filename2,'Sheet',1)
    [b,stats] = robustfit(timef, dhf);
    % output
    filename_file='WHOLE2.mat';
    st.dh_x=timef;                      %x axis: Time
    st.dh_y=dhf;                        %y axis: Elevation difference
    st.dh_mx=mtime;                    %x axis: Median Time
    st.dh_my=mdh;                      %y axis: Median Elevation difference
    st.dh_myy=b(1)+st.dh_mx*b(2); %trend
    st.dh_tr=b(2); %trend rate??
    st.dh_se=stats.se(2); % Standard error of coefficient estimates
    st.dh_p=stats.p(2); % p-values for t
    st.dh_sigma=sqrt(st.dh_se^2+0.06^2+0.06^2+0.06^2+0.06^2);
    %st.num=num';
    % save
    path_file_save=fullfile(path_dir_save,filename_file);
    save(path_file_save, 'st') %save stats in 'st'
    %save(path_file_save2,'')
    
    
    %%
    
%     filename_plot1='WHOLE.tif'; %filename same as whhat was read .tif
%     path_file_plot1=fullfile(path_dir_save, filename_plot1); %path where file will be plotted
%     % plot
%     h=figure('visible', 'off');
%     set(h, 'Position', [1 1 600 300]);
%     hold on;
%     %I=
%     X=st.dh_mx;
%     Y=st.dh_my;
%     Z=st.dh_myy;
%     [sortedX, sortIndex] = sort(X);
%     sortedY = Y(sortIndex);
%     sortedZ=Z(sortIndex);
%     st.dh_mx=sortedX;
%     st.dh_my=sortedY;
%     st.dh_myy=sortedZ;
%     % errorbar
%      fx_errorbar(st.dh_mx, st.dh_my, st.dh_se, st.dh_se, 0.05, 0.1, 'k');
%     % median
%     plot(st.dh_mx, st.dh_my, '.-k', 'markersize', 10, 'linewidth', 0.1);
%     % trend
%     plot(st.dh_mx, st.dh_myy, '-r', 'linewidth', 2);
%     str=sprintf('%sH trend: %0.2f %s %0.2f [m/yr]',...
%         '\Delta', st.dh_tr, '\pm', st.dh_sigma);
%     title(str, 'FontSize',14);
%     xlabel('Decimal Year', 'fontsize', 14); 
%     ylabel('\DeltaH [m]', 'fontsize', 14);
%     set(gca, 'YMinorTick', 'on');
%     %xlim([2003.0, 2010.0]);
%     %ylim([-100 100]);
%     box on;
%     print(h, '-dtiff', '-r300', path_file_plot1);
    
    filename4='FINAL.csv';
    M=[latf,lonf,timef,srtmf,csatf,dhf];
    cHeader = {'LAT' 'LON' 'TIME' 'ELE_S' 'ELE_C' 'DH'}; %dummy header
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    
    %write header to file
    fid = fopen(filename4,'w'); 
    fprintf(fid,'%s\n',textHeader)
    fclose(fid)
    
    %write data to end of file
    dlmwrite(filename4,M,'-append');  
    
    [trend, xx,yy,yyy, rDsai] = SeasonalFir(timef,dhf);
    
    

 %%
    
    filename_plot1='WHOLE.tif'; %filename same as whhat was read .tif
    path_file_plot1=fullfile(path_dir_save, filename_plot1); %path where file will be plotted
    % plot
    h=figure('visible', 'off');
    set(h, 'Position', [1 1 600 300]);
    hold on;
    %I=
    X=st.dh_mx;
    Y=st.dh_my;
    Z=st.dh_myy;
    [sortedX, sortIndex] = sort(X);
    sortedY = Y(sortIndex);
    sortedZ=Z(sortIndex);
    st.dh_mx=sortedX;
    st.dh_my=sortedY;
    st.dh_myy=sortedZ;
    % errorbar
     fx_errorbar(st.dh_mx, st.dh_my, st.dh_se, st.dh_se, 0.05, 0.1, 'k');
    % median
    plot(st.dh_mx, st.dh_my, '.-k', 'markersize', 10, 'linewidth', 0.1);
    % trend
    plot(st.dh_mx, st.dh_myy, '-r', 'linewidth', 2);
    str=sprintf('%sH trend: %0.2f %s %0.2f [m/yr]',...
        '\Delta', st.dh_tr, '\pm', st.dh_sigma);
    title(str, 'FontSize',14);
    xlabel('Decimal Year', 'fontsize', 14); 
    ylabel('\DeltaH [m]', 'fontsize', 14);
    set(gca, 'YMinorTick', 'on');
    %xlim([2003.0, 2010.0]);
    %ylim([-100 100]);
    box on;
    print(h, '-dtiff', '-r300', path_file_plot1);