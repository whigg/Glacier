clc; clear all; close all;
save_path = strcat('plots');
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% GRACE
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% scale = 0.25;
% % for Alaska (region01)
% allgrace = [];
% grace = load('GRACE/JPL_mscn308.txt');
% allgrace = [allgrace;grace];
% grace = load('GRACE/JPL_mscn309.txt');
% allgrace = [allgrace;grace];
% grace = load('GRACE/JPL_mscn3994.txt');
% allgrace = [allgrace;grace];
% t = unique(allgrace(:,1));
% for i = 1:length(t)
%     ind = find(allgrace(:,1)==t(i));
%     obs(i,:) = sum(allgrace(ind,2));
% end
% t = 2002+t/365;%+datenum(2002,01,01);
% % for region 17
grace = load('GRACE/JPL_mscn307.txt');
t = 2002+grace(:,1)/365;
obs = grace(:,2);


[slope2,intercept2,uncertainty2] = yyqx_LinearFit(t,obs);
obsy = slope2*t+intercept2;
saiobs = [slope2,intercept2,uncertainty2]

f1 = figure
yyaxis right
x = t; y = obs; dy = 10;
h(1) = fill([x;flipud(x)],[y-dy;flipud(y+dy)],[0.5 .5 0.5],'linestyle','none');hold on
set(h(1),'facealpha',.5);
ylabel('Scaled TWS [cm]')
h(2) = plot(t,obs,'r-');
h(3) = plot(t,obsy,'r-','LineWidth',2);
% eqobs = 'GRACE: -0.6 \pm 0.08 cm/yr';
% text(2010,10,eqobs,'FontSize',20);
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
names = {'Alaska','WesternCanadaUS','ArcticCanadaNorth','ArcticCanadaSouth','GreenlandPeriphery',...
    'Iceland','Svalbard','Scandinavia','RussianArctic','NorthAsia',...
    'CentralEurope','CaucasusMiddleEast','HMA','SouthAsiaWest','SouthAsiaEast',...
    'LowLatitudes','SouthernAndes','NewZealand'};
autumn = [9 10 11; 3 4 5];
autumn_index = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ...
    2 2 2];
all_size = load('GlacierSize.mat');
for i = 17
    if i~=13
        regions = i;
    else
        regions = [13,14,15];
    end
    all_ice = [];all_cs2 = [];glacier_size = [];data_size = [];
    for j = 1:length(regions)
        if regions(j)<10
            region = strcat('0',num2str(regions(j)));
        else
            region = strcat(num2str(regions(j)));
        end
    region_name = names{regions(1)};
    glacier_size(j) = all_size.output(regions(j));
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% load ICESat and CS2 data
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<    
    file_path = strcat('all_filter/',region,'_ice.mat');
    data = load(file_path);
    ice = data.output;
    file_path = strcat('all_filter/',region,'_cs2.mat');
    data = load(file_path);
    cs2 = data.output;
    
    ice_size = 0;
    for k = 1:size(ice,1)
        t_ice(k,:) = ice{k,1};
        mh_ice(k,:) = nanmean(ice{k,2}(:,4));
        ice_size = ice_size+size(ice{k,2},1);
    end
    
    num = 0; cs2_size = 0;
    for k = 1:size(cs2,1)
        if ~isempty(cs2{k,2})
            num = num+1;
            t_cs2(num,:) = cs2{k,1};
            mh_cs2(num,:) = nanmean(cs2{k,2}(:,4));
            cs2_size = cs2_size+size(cs2{k,2},1);
        end
    end
    all_ice = [all_ice; t_ice mh_ice];
    all_cs2 = [all_cs2; t_cs2 mh_cs2];
    data_size(j,:) = [ice_size cs2_size]
    clear t_ice mh_ice t_cs2 mh_cs2
    end
    total_size = sum(glacier_size);   
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% filter cs2 and ice data
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<    
    t_ice = unique(all_ice(:,1));
    for k = 1:length(t_ice)
        ind = find(all_ice(:,1)==t_ice(k));
        mh_ice(k,:) = nanmean(all_ice(ind,2));
    end
    mmh_ice = mean(mh_ice);
    std_mh_ice = std(mh_ice);
    ind = find(mh_ice>mmh_ice-std_mh_ice*2&mh_ice<mmh_ice+std_mh_ice*2);
    mh_ice_filter = mh_ice(ind);
    t_ice_filter = t_ice(ind);
    t_cs2 = unique(all_cs2(:,1));
    for k = 1:length(t_cs2)
        ind = find(all_cs2(:,1)==t_cs2(k));
        mh_cs2(k,:) = nanmean(all_cs2(ind,2));
    end
    mmh_cs2 = mean(mh_cs2);
    std_mh_cs2 = std(mh_cs2);
    ind = find(mh_cs2>mmh_cs2-std_mh_cs2*3&mh_cs2<mmh_cs2+std_mh_cs2*3); % 1 and 13 use 3, others use 2
    mh_cs2_filter = mh_cs2(ind);
    t_cs2_filter = t_cs2(ind);
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% compute Autumn data trend & moving mean
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<     
    autumn_months = autumn(autumn_index(i),:);
    time_ice = datevec(datenum(t_ice_filter));
    yyyy = unique(time_ice(:,1));
    num = 0;
    for k = 1:length(yyyy)
        ind_yr = find(time_ice(:,1)==yyyy(k));
        ind_AU = find(time_ice(ind_yr,2)==autumn_months(1)|time_ice(ind_yr,2)==autumn_months(2)|time_ice(ind_yr,2)==autumn_months(3));
        if ~isempty(ind_AU)
            num = num+1;
            y1(num,:) = nanmean(mh_ice_filter(ind_yr(ind_AU)));
            x1(num,:) = decyear([yyyy(k) autumn_months(2) 15]);
        end
    end
    x2 = decyear(t_cs2_filter);
    y2 = movmean(mh_cs2_filter,3);
    [trend,diff,xx,yy,yyy,rDsai] = yyqx_SeasonalFit2data(x1,y1,x2,y2);
    new_y2 = y2-diff;
% %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% % plot final figures (height m)
% %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%     plot(x1,y1,'k+','MarkerFace','black','LineWidth',2,'MarkerSize',10);hold on
%     plot(x2,new_y2,'bx-','MarkerFace','blue','LineWidth',2)
%     plot(xx,yy,'g-','LineWidth',2)
%     plot(xx,yyy,'r-','LineWidth',2)
%     ylabel('\Delta H [m]');
%     legend('ICESat','CryoSat-2');
%     legend('Location','southwest')
%     if i==13
%         ftitle = ['region-13,14,15, Name:',region_name,', Trend=',num2str(trend),'\pm',num2str(rDsai),'m/yr'];
%     else
%     ftitle = ['region-',region,', Name:',region_name,', Trend=',num2str(trend),'\pm',num2str(rDsai),'m/yr'];
%     end
%     title(ftitle);
%     set(gca,'FontSize',16)
%     close(f1)      
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% Convert m to Gigaton (mass balance Gton)
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% Glacier: 900
% Alaska: 750 kg/m^3
% HMA: 850 kg/m^3
% 
    area = total_size*10^6; % km^2
    density = 900; % kg m^-3
    constant = area*density*10^(-12);
    save_path = strcat('plots');
    err = 0.3; % 0.3 m errorbar
    
    yyaxis left
    % plot(x1,y1*constant,'k+','MarkerFace','black','LineWidth',2,'MarkerSize',10);hold on
    h(4) = errorbar(x1,y1*constant,err*constant*ones(size(x1)),'kd-','MarkerSize',5,'MarkerFace','black','LineWidth',1); hold on
    % plot(x2,new_y2*constant,'bx-','MarkerFace','blue','LineWidth',2)
    h(5) = errorbar(x2,new_y2*constant,err*constant*ones(size(x2)),'bd-','MarkerSize',5,'MarkerFace','blue','LineWidth',1)
    h(6) = plot(xx,yy*constant,'g-','LineWidth',2)
    h(7) = plot(xx,yyy*constant,'r-','LineWidth',2)
    ylabel('\Delta Mass [Gt]');
    legend();
    legend(h([2,4,5]),'GRACE','ICESat','CryoSat-2'); %legend of 1,3
    legend('Location','southwest');
    if i==13
        ftitle = ['region-13,14,15, Name:',region_name,', Trend=',num2str(trend*constant),'\pm',num2str(rDsai*constant),'Gt/yr'];
    else
    ftitle = ['region-',region,', Name:',region_name,', Trend=',num2str(trend*constant),'\pm',num2str(rDsai*constant),'Gt/yr'];
    end
    title(ftitle);
    set(gca,'FontSize',16)
    % save figure
    set(f1,'PaperPosition',[0 0 15 5.5]);
    fname = strcat(save_path,'/',region,'_MassTimeSeries_wgrace.png');
    saveas(f1, fname);
    
    clear all_ice all_cs2 t_ice mh_ice t_cs2 mh_cs2 x1 y1 x2 y2 x y
end

