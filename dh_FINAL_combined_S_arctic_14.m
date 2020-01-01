function dh_FINAL_combined_S_arctic_14(ipparameter)
    path_dir_from1=ipparameter.path_dir_from1; %ICESAT
    path_dir_from2=ipparameter.path_dir_from2; %CS2
    path_dir_save=ipparameter.path_dir_to;
% ipparameter.path_dir_from1='E:\ICESAT_14_PROCESSED\DEC\ARCTIC_CANADA_S\GIS\New folder\';
% ipparameter.path_dir_to='E:\C_ICE_CS2\arc_can_s\ice14\';  
% ipparameter.path_dir_from2='E:\GLACIER\ARCTICCANDA_S\04_ArcticCanada_S\DEC\GIS\New folder\';

threshold=2;
%% ------------------READING THE DATA------------------------------------------------    
[f1,~]=fx_dir(path_dir_from1,'.csv');
filename=fullfile(path_dir_from1,f1.name);

T2=readtable(filename);
%T22=table2array(T2); 
LAT=T2.LAT;
LON=T2.LON;
TIME=T2.TIME;
%ELE_C=T22(:,4);
ELE_C=T2.ELE_A;
GEOID_DIFF=T2.GEOID_DIFF;
SRTM=T2.dem;


%SRTM=T2.MOSAIC;
I=find(SRTM>-1000);
TIME=TIME(I);
DH_ICE=ELE_C(I) + GEOID_DIFF (I)-SRTM(I);


%% ------------------READING THE DATA------------------------------------------------    
[f2,~]=fx_dir(path_dir_from2,'.csv');
filename2=fullfile(path_dir_from2,f2.name);

T2=readtable(filename2);
T22=table2array(T2); 
%LAT2=T2.LAT;
LAT2=T22(:,1);
%LON2=T2.LON;
LON2=T22(:,2);
%TIME2=T2.TIME;
TIME2=T22(:,3);
ELE_C2=T22(:,4);

SRTM2=T22(:,6);
I2=find(SRTM2>-1000);
TIME2=TIME2(I2);
DH_CS2=ELE_C2(I2)-SRTM2(I2);

n = datestr(datenum(TIME,1,0));
year=str2num(n(:,8:11));
month=string(n(:,4:6));
%monthlist=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
%month_AUT=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
%month_AUT=["Nov","Dec","Jan","Feb"]; %for Southern H
month_AUT=["Aug","Sep","Oct"]; %for northern H

%I=find(strcmp(month,month_AUT(1)) | strcmp(month,month_AUT(2)) | strcmp(month,month_AUT(3)) | strcmp(month,month_AUT(4)));

I=find(strcmp(month,month_AUT(1)) | strcmp(month,month_AUT(2)) | strcmp(month,month_AUT(3)));

TIME=TIME(I);
DH_ICE=DH_ICE(I);

    t_ice = unique(TIME); %finds all unique months
    %Find mean for each month
    for k = 1:length(t_ice)
        ind = find(TIME==t_ice(k));
        dh_time = (DH_ICE(ind));
%         mean_dh_time=nanmean(dh_time);
%         std_dh_time=std(dh_time);
%         I= find(dh_time>mean_dh_time-2*std_dh_time & dh_time< mean_dh_time+2*std_dh_time);
        I2=find(abs(dh_time) < 150);
        dh_time=dh_time(I2);
        %med_ice(k)=median(dh_time(I)); %Median of values of a moimnth
        med_ice(k)=median(dh_time); %Median of values of a moimnth
    end
    %Filter out the elevations
     mmh_ice = mean(med_ice);
    std_mh_ice = std(med_ice);
    ind = find(med_ice>mmh_ice-std_mh_ice*2 & med_ice<mmh_ice+std_mh_ice*2);
    mh_ice_filter = med_ice(ind);
    t_ice_filter = t_ice(ind);
    %% NOTE
    I=find(TIME2 > 2009 & TIME2 <2017);
    TIME2=TIME2(I);
    DH_CS2=DH_CS2(I);
    %% 
    t_cs2 = unique(TIME2);
    for k = 1:length(t_cs2)
        ind = find(TIME2==t_cs2(k));
        dh_time=(DH_CS2(ind));
        mean_dh_time=nanmean(dh_time);
        std_dh_time=std(dh_time);
        I= find(dh_time>mean_dh_time-2*std_dh_time & dh_time< mean_dh_time+2*std_dh_time);
        %med_cs2(k)=mean(dh_time(I));
        med_cs2(k)=median(dh_time(I));
    end
    mmh_cs2 = mean(med_cs2); %Now mean of all monthly means
    std_mh_cs2 = std(med_cs2);
    ind = find(med_cs2>mmh_cs2-std_mh_cs2*threshold & med_cs2<mmh_cs2+std_mh_cs2*threshold); % 1 and 13 use 3, others use 2
    mh_cs2_filter = med_cs2(ind);
    t_cs2_filter = t_cs2(ind);
    %% Note
    mh_cs2_filter = med_cs2(ind);
    %% 
    
    x1 = (t_ice_filter);
    y1 = movmean(mh_ice_filter,3);
    y1=y1';
    x2 = t_cs2_filter;
    y2 = movmean(mh_cs2_filter,3);
    y2=y2';
    [trend,diff,xx,yy,yyy,rDsai] = yyqx_SeasonalFit2data_both(x1,y1,x2,y2);
    new_y2 = y2-diff; 
    %% nOTE
%     x = [TIME;TIME2];
%     y = [DH_ICE;DH_CS2];
%     [b,stats] = robustfit(x, y);
    %[b,stats] = robustfit(TIME2, DH_CS2);
    %[b,stats] = robustfit(TIME, DH_ICE);
    % new_y2=new_y2+10;
     %% 
    filename_plot1='Arc_Can_S.tif'; %filename same as whhat was read .tif
    path_file_plot1=fullfile(path_dir_save, filename_plot1); %path where file will be plotted
    % plot
    h=figure('visible', 'off');
    set(h, 'Position', [1 1 600 300]);
    
    plot(x1,y1,'k+-','MarkerFace','black','LineWidth',2,'MarkerSize',5);hold on %icesat
    plot(x2,new_y2,'bx-','MarkerFace','blue','LineWidth',2, 'MarkerSize',5) %Cryosat
    %plot(xx,yy,'y','LineWidth',2) %seasonal part
    plot(xx,yy,'y', 'LineWidth',2) %seasonal part
   
    %% try
%     tt=[t_ice;t_cs2];
%     yyyy=b(1)+tt*b(2);
%     plot(tt,yyyy,'r-','LineWidth',2);
    %% 
    plot(xx,yyy,'r','LineWidth',2) %linear part
    
    
    set(gca,'FontSize',10);
    xlim([2003 2018])
    
    %fx_errorbar(xx,yy,rDsai, rDsai, 0.05, 0.1, 'k')
       ylabel('\Delta H [m]', 'Fontsize', 6);
    xlabel('Time (decimal year)', 'Fontsize', 6);
    legend('ICESat','CryoSat-2', 'FontSize',10, 'Location','southwest');
%     ax = gca;
% outerpos = ax.OuterPosition;
% ti = ax.TightInset; 
% left = outerpos(1) + ti(1);
% bottom = outerpos(2) + ti(2);
% ax_width = outerpos(3) - ti(1) - ti(3);
% ax_height = outerpos(4) - ti(2) - ti(4);
% ax.Position = [left bottom ax_width ax_height];
    %axis tight
  
    %legend();
    %fx_errorbar(xx,yy,rDsai, rDsai, 0.05, 0.1, 'k');

%% try    
    %ftitle = ['Trend=',num2str(round(trend,2)),'\pm',num2str(round(rDsai,2)),'m/yr', 'A',num2str(b(2))];
%%
    ftitle = ['Trend=',num2str(round(trend,2)),'\pm',num2str(round(rDsai,2)),'m/yr'];
    
    title(ftitle, 'FontSize',14);
    set(gca,'FontSize',16)
    box on;
    print(h, '-dtiff', '-r300', path_file_plot1);
end
