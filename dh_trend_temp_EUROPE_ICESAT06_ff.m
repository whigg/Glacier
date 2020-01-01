function dh_trend_temp_EUROPE_ICESAT06_ff(ipparameter)
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
mdh1=[];
mtime1=[];
mdh0=[];
mtime0=[];
%slope=[];
% lat=[];
% lon=[];

[f1,~]=fx_dir(path_dir_from1,'.xlsx');
a=xlsread(fullfile(path_dir_from1,f1.name));
LAT=a(:,1);
LON=a(:,2);
TIME=a(:,3);
GEOID=a(:,6);
ELE_C=a(:,5);
% %temp
% ELE_C= ELE_C-GEOID;
% %
ELE_S=a(:,9);
DH_90=ELE_C-ELE_S;


%ELE_S_90=a(:,8);
%DH_90=ELE_C-ELE_S_90;

%[f2,~]=fx_dir(path_dir_from2,'.mat');

%load(fullfile(path_dir_from2,f2.name));
%cs.dh_t=cs.elev_a-cs2.SRTM_min;
%cs.dh_t=cs.elev_a-cs2.SRTM_min;

I2=find(abs(DH_90)<150);
LAT=LAT(I2);
LON=LON(I2);
TIME=TIME(I2);
ELE_C=ELE_C(I2);
ELE_S=ELE_S(I2);
%DH=DH(I2);
DH_90=DH_90(I2);
GEOID=GEOID(I2);
%DH=DH+10;
DH_90=DH_90-3;

n = datestr(datenum(TIME,1,0));
year=str2num(n(:,8:11));
month=string(n(:,4:6));
monthlist=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
month_AUT=["Jul","Aug","Sep","Oct"];
count=1;
    dhf=[];
    srtmf=[];
    csatf=[];
    latf=[];
    lonf=[];
    timef=[];
for iy=2003:2009
    dh=[];
    srtm=[];
    csat=[];
    lat=[];
    lon=[];
    time=[];
    for im=1:4
        
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
    
    name=strcat('EUROPE',num2str(iy),'.csv');
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
dh_90_wint=[];
dh_90_summ=[];
time_wint=[];
time_summ=[];

for iy=2003:2009
    
    for im=1:6
        
    I2=find(year==iy & strcmp(month,monthlist(im)));
    if isempty(I2); continue;end
          
          %temp11=median(DH_90(I1));
          %if (abs(temp11)>18) continue;end
          dh_90_wint=DH_90(I2);
          %temp22=median(TIME(I1));
          time_wint=TIME(I2);
    end
          mdh0=[mdh0;median(dh_90_wint)];
          mtime0=[mtime0;min(time_wint)];
end

for iy=2003:2009
    
    for im=7:12
        
    I3=find(year==iy & strcmp(month,monthlist(im)));
    if isempty(I3); continue;end
          
          %temp11=median(DH_90(I1));
          %if (abs(temp11)>18) continue;end
          dh_90_summ=DH_90(I3);
          %temp22=median(TIME(I1));
          time_summ=TIME(I3);
    end
          mdh1=[mdh1;median(dh_90_summ)];
          mtime1=[mtime1;min(time_summ)];
end

mdh=[mdh0;mdh1];
mtime=[mtime0;mtime1];

[mtime, sortIndex] = sort(mtime);
mdh = mdh(sortIndex);
          
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
end
         
    