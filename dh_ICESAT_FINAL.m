function dh_ICESAT_FINAL
    path_dir_from1=ipparameter.path_dir_from1; %ICESAT
    path_dir_from2=ipparameter.path_dir_from2; %CS2
    path_dir_save=ipparameter.path_dir_to;
    
    [f1,~]=fx_dir(path_dir_from1,'.xlsx');
    a=xlsread(fullfile(path_dir_from1,f1.name));
    LAT=a(:,1);
    LON=a(:,2);
    TIME=a(:,3);
    ELE_C=a(:,5);
    ELE_S=a(:,9);
    DH_90=ELE_C-ELE_S;
    GEOID=a(:,6);
    
    t_ice = unique(TIME); %finds all unique months
    %Find mean for each month
    for k = 1:length(t_ice)
        ind = find(TIME==t_ice(k));
        dh_time = (DH_ICE(ind));
        mean_dh_time=nanmean(dh_time);
        std_dh_time=std(dh_time)
        find(dh_time>
    end
    %Filter out the elevations
    ind = find(mh_ice>mmh_ice-std_mh_ice*2&mh_ice<mmh_ice+std_mh_ice*2);
    mh_ice_filter = mh_ice(ind);
    t_ice_filter = t_ice(ind);
    x1 = decyear(t_ice_filter);
    y1 = movmean(mh_ice_filter,3);
    x2 = decyear(t_cs2_filter);
    y2 = movmean(mh_cs2_filter,3);
    [trend,diff,xx,yy,yyy,rDsai] = yyqx_SeasonalFit2data_both(x1,y1,x2,y2);
    new_y2 = y2-diff; 