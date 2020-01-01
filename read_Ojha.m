function read_Ojha(fname)
%Function to read RGI from a .shp to .mat.  
%Referenced by providing the following values
% INPUT ARGUMENTS
% ----------------
% fname   = Filename and path for Ojha
% UBR     = [XX_min, XX_max, YY_min,YY_max]
% ---------------------------------------------------------------------
% OUTPUT FILE
% -------------
% 's' : 
%---------------------------------------------------------------------
% Reference : 
% Author: Contact Vibhor Agarwal (agarwal.282@osu.edu) 
%--------------------------------------------------------------------------
% field name
% LAT1=[];
% LON1=[];
% SC_Sim_f=[];
% SC_f=[];
% ERROR1=[];
% SC_sim=zeros(5000,9);
% SC=zeros(5000,9);
% error=zeros(5000,9);
folder='E:\STORAGE_COEFF\CALIFORNIA\output\final\';
[name_folder,num]=fx_dir(folder);
for i=1:num
    nfolder=name_folder(i).name;
    subfolder_name=strcat(folder,nfolder,'\');
    [filename,~]=fx_dir(subfolder_name,'.csv');
    A=readtable(strcat(subfolder_name,filename.name));
    LAT1=A.Var2;
    %LAT1=[LAT1;lat];
    LON1=A.Var1;
    %LON1=[LON1;lon];
    SC_sim(:,i)=A.Var4;
    %SC_Sim_f=SC_sim';
    SC(:,i)=A.Var3;
    %SC_f=SC_sim';
    error(:,i)=A.Var5;
    %ERROR1=error';
end
    
M=m_shaperead(fname);
IN_SC=cell2mat(M.IN_SC);
field=fieldnames(M); 
% names = fieldnames(s) returns a cell array of character vectors 
% containing the names of the fields in structure s.
SC_s=cell(1,1);
SC_sim_s=cell(1,1);
for i=1:length(M.ncst) %till number of polygons
lon=M.ncst{i,1}(:,1);
lat=M.ncst{i,1}(:,2);


%for i=1:length(value)           
%entry=value{i,1};
% lon=entry(:,1);                     
% lat=entry(:,2);
% s.lat=lat;                       % Latitude of the polygons
% s.lon=lon;                       % Longitude
I2=inpolygon(LON1, LAT1, lon, lat); %check which points are in the polygon
 %if isempty(find(I2)); continue; end;
 SC_s{i,1}=SC(I2,:);
 SC_mean{i,1}=mean(mean(SC(I2,:)));
 SC_sim_s{i,1}=SC_sim(I2,:);
 SC_sim_mean{i,1}=mean(mean(SC_sim(I2,:)));
 SC_Ojha{i,1}=IN_SC(i);
end
save('E:\STORAGE_COEFF\CALIFORNIA\ojha\oja_final.mat','SC','SC_sim','SC_mean','SC_sim_mean','SC_Ojha');
   

end
