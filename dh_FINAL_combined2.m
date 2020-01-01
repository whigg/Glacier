function dh_FINAL_combined2 (ipparameter)
    path_dir_from1=ipparameter.path_dir_from1; %ICESAT
    path_dir_from2=ipparameter.path_dir_from2; %CS2
    path_dir_save=ipparameter.path_dir_to;
    

%% ------------------READING THE DATA------------------------------------------------    
[f1,~]=fx_dir(path_dir_from1,'.csv');
filename=fullfile(path_dir_from1,f1.name);

T2=readtable(filename);
T22=table2array(T2); 
LAT=T2.LAT;
LON=T2.LON;
TIME=T2.TIME;
ELE_C=T22(:,4);
GEOID_DIFF=T22.GD;
SRTM=T22(:,6);

DH_ICE=ELE_C + GEOID_DIFF -SRTM;


%% ------------------READING THE DATA------------------------------------------------    
[f2,~]=fx_dir(path_dir_from1,'.csv');
filename2=fullfile(path_dir_from1,f2.name);

T2=readtable(filename2);
T22=table2array(T2); 
LAT2=T2.LAT;
LON2=T2.LON;
TIME2=T2.TIME;
ELE_C2=T22(:,4);
%GEOID_DIFF=T22.GD;
SRTM2=T22(:,6);

DH_CS2=ELE_C2-SRTM2;

LATT=round(LAT,4);
LATT2=round(LAT2,4);
LONN=round(LON,4);
LONN2=round(LON2,4);

I=find(LATT==LATT2 & LONN==LONN2)
DH=ELE_C2-ELE_C;
TIM1=TIME2;
TIM2=TIME;
dh_TIME=TIME2-TIME1;
dem1=SRTM2;
dem2=SRTM;


    
    t_ice = unique(TIME); %finds all unique months
    %Find mean for each month
    for k = 1:length(t_ice)
        ind = find(TIME==t_ice(k));
        dh_time = (DH_ICE(ind));
        mean_dh_time=nanmean(dh_time);
        std_dh_time=std(dh_time);
        I= find(dh_time>mean_dh_time-2*std_dh_time & dh_time< mean_dh_time+2*std_dh_time);
        med_ice(k)=median(dh_time(I)); %Median of values of a moimnth
    end
    %Filter out the elevations
     mmh_ice = mean(med_ice);
    std_mh_ice = std(med_ice);
    ind = find(med_ice>mmh_ice-std_mh_ice*2 & med_ice<mmh_ice+std_mh_ice*2);
    mh_ice_filter = med_ice(ind);
    t_ice_filter = t_ice(ind);
    
    t_cs2 = unique(TIME2);
    for k = 1:length(t_cs2)
        ind = find(TIME2==t_cs2(k));
        dh_time=(DH_CS2(ind));
        mean_dh_time=nanmean(dh_time);
        std_dh_time=std(dh_time);
        I= find(dh_time>mean_dh_time-2*std_dh_time & dh_time< mean_dh_time+2*std_dh_time);
        med_cs2(k)=median(dh_time(I));
    end
    mmh_cs2 = mean(med_cs2);
    std_mh_cs2 = std(med_cs2);
    ind = find(med_cs2>mmh_cs2-std_mh_cs2*threshold & med_cs2<mmh_cs2+std_mh_cs2*threshold); % 1 and 13 use 3, others use 2
    mh_cs2_filter = med_cs2(ind);
    t_cs2_filter = t_cs2(ind);
    
    x1 = (t_ice_filter);
    y1 = movmean(mh_ice_filter,3);
    x2 = decyear(t_cs2_filter);
    y2 = movmean(mh_cs2_filter,3);
    [trend,diff,xx,yy,yyy,rDsai] = yyqx_SeasonalFit2data_both(x1,y1,x2,y2);
    new_y2 = y2-diff; 
    
    plot(x1,y1,'k+','MarkerFace','black','LineWidth',2,'MarkerSize',10);hold on
    plot(x2,new_y2,'bx-','MarkerFace','blue','LineWidth',2)
    plot(xx,yy,'g-','LineWidth',2)
    plot(xx,yyy,'r-','LineWidth',2)
    ylabel('\Delta H [m]');
    legend('ICESat','CryoSat-2');
    legend('Location','southwest')