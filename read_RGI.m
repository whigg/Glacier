function read_RGI(fname)
%Function to read RGI from a .shp to .mat.  
%Referenced by providing the following values
% INPUT ARGUMENTS
% ----------------
% fname   = Filename and path for RGI 
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
M=m_shaperead(fname);
field=fieldnames(M); 
% names = fieldnames(s) returns a cell array of character vectors 
% containing the names of the fields in structure s.
rgi_c=cell(1,1);
value=getfield(M, field{10});    %the value of coordinates
Glac_ID=getfield(M, field{18});
for i=1:length(value)           
entry=value{i,1};
lon=entry(:,1);                     
lat=entry(:,2);
s.lat=lat;                       % Latitude
s.lon=lon;                       % Longitude
ID=Glac_ID(i);
s.Glac_ID=ID;                    % Glacier ID
rgi_c{i,1}=s;
end
save('E:\STORAGE_COEFF\CALIFORNIA\ojha\ANASIA.mat','rgi_c');
   
end
