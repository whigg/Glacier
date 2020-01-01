function dh_trend_ANDES(ipparameter)
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
[f1,~]=fx_dir(path_dir_from1,'.mat');
[f2,~]=fx_dir(path_dir_from2,'.mat');
load(fullfile(path_dir_from1,f1.name));
load(fullfile(path_dir_from2,f2.name));
cs.dh_t=cs.elev_a+cs.Geoid-cs2.SRTM_min+10;
%cs.dh_t=cs.elev_a-cs2.SRTM_min;
n = datestr(datenum(cs.time,1,0));
year=str2num(n(:,8:11));
month=string(n(:,4:6));
monthlist=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
count=1;
for iy=2010:2017
    for im=6:8
        
    I=find(year==iy & strcmp(month,monthlist(im)));
    if isempty(I); continue;end        
          
%           tempo1=s1.lat(I);
%           lat=[lat;tempo1];
%           tempo2=s1.lon(I);
%           lon=[lon;tempo2];
%           temp1=s1.dh(I);
%           %temp1=temp1+38;
%           dh=[dh; temp1];
%           %temp12=mean((s1.dh+25));
          temp12=median((cs.dh_t(I)));
           num(count)=numel((cs.dh_t(I)));
          count=count+1;
          mdh=[mdh; temp12];
%           try
%           temp3=s1.slope(I);
%           slope=[slope;temp3];
%           end
%           temp2=s1.time(I);
%           time=[time; temp2];
          temp22=median(cs.time(I));
          mtime=[mtime; temp22];
         end
    end

%filename_plot='ALASKA2.tif';
%path_file_plot1=fullfile(path_dir_save,filename_plot);
%[rgi_name,~]=fx_dir(path_dir_rgi,'.mat');
%path_rgi=fullfile(path_dir_rgi,rgi_name.name);
%rgi_c=fx_load(path_rgi);
%hold on;
%h=figure('visible', 'off');
%set(h, 'Position', [1 1 600 300]);
% for i=1:length(rgi_c)
%     rgi=rgi_c{i};
%     plot(rgi.lon,rgi.lat);
% end
%scatter(lon,lat);
% xlabel('Longitude');
% ylabel('Latitude');
% box on;
% print(h, '-dtiff', '-r600', path_file_plot1);
% robustfit
%     s.time=time;
%     try
%     s.slope=slope;
%     end
%     s.dh=dh;
%     s.lat=lat;
%     s.lon=lon;
    try
    T = table(cs.lat,cs.lon,cs.time,cs.dh_t,cs2.slope);
    catch
    T = table(cs.lat,cs.lon,cs.time,cs.dh_t);
    end
    filename2 = fullfile(path_dir_save,'EUROPE.xlsx');
    writetable(T,filename2,'Sheet',1)
    [b,stats] = robustfit(cs.time, cs.dh_t);
    % output
    filename_file='WHOLE2.mat';
    st.dh_x=cs.time;                      %x axis: Time
    st.dh_y=cs.dh_t;                        %y axis: Elevation difference
    st.dh_mx=mtime;                    %x axis: Median Time
    st.dh_my=mdh;                      %y axis: Median Elevation difference
    st.dh_myy=b(1)+st.dh_mx*b(2); %trend
    st.dh_tr=b(2); %trend rate??
    st.dh_se=stats.se(2); % Standard error of coefficient estimates
    st.dh_p=stats.p(2); % p-values for t
    st.dh_sigma=sqrt(st.dh_se^2+0.06^2+0.06^2+0.06^2+0.06^2);
    st.num=num';
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
    I=find((abs(st.dh_my))<20);
    X=st.dh_mx(I);
    Y=st.dh_my(I);
    Z=st.dh_myy(I);
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

         
    