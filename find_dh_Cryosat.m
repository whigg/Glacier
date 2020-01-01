function find_dh_Cryosat(ipparameter)
path_dir_from1=ipparameter.path_dir_from1;
path_dir_save=ipparameter.path_dir_to;
% read higher year file
% read lower year file
%sort the two according to latitude
%[f1,~]=fx_dir(path_dir_from1,'.xlsx');
year2=[2010, 2011, 2012, 2013, 2014, 2015];
year1=[2011, 2012, 2013, 2014, 2015, 2016];
for l=1:6
temp=1;
q=year1(l)-2010;
while temp <= q
f1.name=strcat('HMA',num2str(year1(l)),'.csv');
f2.name=strcat('HMA',num2str(year2(temp)),'.csv');
a=csvread(fullfile(path_dir_from1,f1.name),1,0);
b=csvread(fullfile(path_dir_from1,f2.name),1,0);
lat1=a(:,1);
lon1=a(:,2);
time=a(:,3);
elev1=a(:,4);
lat2=b(:,1);
lon2=b(:,2);
time2=b(:,3);
elev2=b(:,4);


[lat1, sortIndex] = sort(lat1,'descend');
lon1 = lon1(sortIndex);
time=time(sortIndex);
elev1=elev1(sortIndex);
lat1_utm=lat1_utm(sortIndex);
lon1_utm=lon1_utm(sortIndex);

[lat2, sortIndex2] = sort(lat2,'descend');
lon2 = lon2(sortIndex2);
time2=time2(sortIndex2);
elev2=elev2(sortIndex2);
lat2_utm=lat2_utm(sortIndex2);
lon2_utm=lon2_utm(sortIndex2);

for i=int(min(lat1)):1:(int(max(lat1))-1)
    for k=1:length(lat1)
    if lat1(k)>=i && lat1(k)<i+1
    lat_1(count)=lat1(k);
    lon_1(count)=lat1(k);
    elev_1(count)=elev1(k);
    time_1(count)=time1(k);
    end
    end
end
    
dh_f=NaN(length(lat1),1);
time_f2=NaN(length(lat1),1);
lat22=NaN(length(lat1),1);
lon22=NaN(length(lat1),1);
sum_a=[];
for i=1:length(lat1)
p_dh=[];
p_time=[];
p_lat=[];
p_lon=[];
for j=1:length(lat2)
    a=pdist([lat1_utm(i),lon1_utm(i);lat2_utm(j),lon2_utm(j)]);
    sum_a=[sum_a;a];
    if a > 500 && a<=1000   %taking nearby pixels with a definite characteristic
        dh= elev1(i)-elev2(j);
        if abs(dh) < 30
            p_dh=[p_dh;dh];
            p_time=[p_time;time2(j)];
            p_lat=[p_lat;lat2(j)];
            p_lon=[p_lon;lon2(j)];
        end
    end
     if (abs(lat1(i)-lat2(j)) > 1)
         break 
       
    end
end
if isempty(p_dh)
    dh_f(i)=NaN;
    time_f2(i)=NaN;
    lat22(i)=NaN;
    lon22(i)=NaN;
else
[dh_f(i),I]=min((p_dh));
time_f2(i)= p_time(I);
lat22(i)=p_lat(I);
lon22(i)=p_lon(I);
end
end
I=~isnan(dh_f);
dhf=dh_f(I);
latf=lat1(I);
lonf=lon1(I);
csatf=elev1(I);
timef=time(I);
timef2=time_f2(I);
lat22=lat22(I);
lon22=lon22(I);
%filter out those values

    filename4=strcat('FINAL_',num2str(year1(l)),'_',num2str(year2(temp)),'.csv');
    file4=fullfile(path_dir_save,filename4);
    csvwrite(file4,[]);
    M=[latf,lonf,timef,csatf,dhf,timef2,lat22,lon22];
    cHeader = {'LAT' 'LON' 'TIME' 'ELE_C' 'DH','TIME2','LAT2','LON2'}; %dummy header
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    
    %write header to file
    fid = fopen(file4,'w'); 
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);
    
    %write data to end of file
    dlmwrite(file4,M,'precision',10,'-append');    
    
%     I6=find(sum_a<500);
%     disp(I6);
    temp=temp+1;       
end

end
end
