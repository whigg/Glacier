function onrgi_Cryosat_mask2(ipparameter)
%--------------------------------------------------------------------------
%Function to create Cryosat glacier mask. 
%Referenced by providing the following values
% INPUT ARGUMENTS
% ----------------
% ipparameter.path_dir_from1: %path to Cryosat .mat files
% ipparameter.path_dir_from2: % path to RGI .mat files
% ipparameter.path_dir_to: % path to save the Cryosat mask files 
% ---------------------------------------------------------------------
% OUTPUT FILE
% -------------
% 'cryosat2' 
%---------------------------------------------------------------------
% Reference : 
% Author: Contact Vibhor Agarwal (agarwal.282@osu.edu) 
%---------------------------------------------------------------------
path_dir_from1=ipparameter.path_dir_from1; %Cryosat after correction
path_dir_from2=ipparameter.path_dir_from2; %Subregion RGI
path_dir_to=ipparameter.path_dir_to; %where to save
%fx_mkdir(path_dir_to);
%from1='C:\CORRECTED_Autumn\'
%from2='C:\subregions\subA\subB\'
%to='C:\CORRECTED_Autumn\ON_RGI\SUB B\'
 path_file_read2=fullfile(path_dir_from2, 'rgiA.mat');
 rgi_c=fx_load(path_file_read2);
%--------------------------------------------------------------------------
% read CrysSat2
%[cs2_c, ~]=fx_dir2cell(path_dir_from1);
%cs2_s=fx_cell2struct(cs2_c);
%clear cs2_c;

%--------------------------------------------------------------------------
% rescale cs2      %I dont understand much of the processes here
[yearnamelist, nyear]=fx_dir(path_dir_from1); %read CS2 saved in region_extracter
for i=1:nyear
    % path
    yearname=yearnamelist(i).name;
    path_dir_year=fullfile(path_dir_from1,yearname,filesep);
    [monthnamelist, nmonth]=fx_dir(path_dir_year);
    for j=1:nmonth
        monthname=monthnamelist(j).name;
        path_dir_month=fullfile(path_dir_year, monthname,filesep); %month
        [file,nfile]=fx_dir(path_dir_month, '.mat'); %Read RGI file defined according to SRTM
        for i=1:nfile
        % path
        filename=file(i).name;
        path_file_read1=fullfile(path_dir_month,filename);
        cs2=fx_load(path_file_read1);
       
        path_dir_save=fullfile(path_dir_to, sprintf('%04d',str2num(yearname)),filesep,sprintf('%02d',str2num(monthname)),filesep);
        fx_mkdir(path_dir_save);
        path_file_save=fullfile(path_dir_save,filename);
        
         c=cell(1,1);
         idx=1;
         for k=1:length(rgi_c)
            rgi=rgi_c{k};
            if isempty(rgi); continue;end;
            I2=inpolygon(cs2.lon, cs2.lat, rgi.lon, rgi.lat); %check which tracks are in RGI limits
               if isempty(find(I2)); continue; end;
                     c{idx,1}=fx_rescale_struct(cs2, I2);%rescalke the CS2 cell based on rgi mask
                     idx=idx+1;
         end
         % save
         if idx==1; continue; end;
          cryosat2=fx_cell2struct(c);      % converts cell to structure
          save(path_file_save, 'cryosat2'); %rescaled Crysoat saved as 's'. 

       end

end
end
