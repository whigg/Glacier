
function Icesat_region_extracter(ipparameter)
%This function read Cryosat-2 .DBL files and then chooses Cryosat footprints 
%based on Limiting latitudes and longitudes
%Referenced by providing the following values
% INPUT ARGUMENTS
% ----------------
% ipparameter.path_dir_from: %path to cryosat directory containing .DBL
% files
% ipparameter.path_dir_to: % path to save the resultant Cryosat file
% ---------------------------------------------------------------------
% OUTPUT FILE
% -------------
% 'cs2' : a structure with many fields (Don't have to worry about all)%   
%---------------------------------------------------------------------
% Reference : 
% Author: Contact Vibhor Agarwal (agarwal.282@osu.edu) 
% ----------------------------------------------------------------------

path_dir_from=ipparameter.path_dir_from; 
path_dir_to=ipparameter.path_dir_to1; %suggest the directory where to save
%fx_mkdir(path_dir_to);
lim_lon=ipparameter.lim_lon; % We pass this to function as argument. 
lim_lat=ipparameter.lim_lat;
total=0;
%--------------------------------------------------------------------------
% extracter
% year
[yearnamelist, nyear]=fx_dir(path_dir_from);  %read name and no. of files
for iy=1:nyear
    yearname=yearnamelist(iy).name;
    path_dir_year=fullfile(path_dir_from, yearname,filesep); %year
    % month
    [monthnamelist, nmonth]=fx_dir(path_dir_year);
    for im=1:nmonth
        monthname=monthnamelist(im).name;
        path_dir_month=fullfile(path_dir_year, monthname,filesep); %month
        % pass
        [filenamelist, nfile]=fx_dir(path_dir_month, '*.mat'); %searches all files
        for ifile=1:nfile
            %disp([num2str(ifile),'processed'])
            filename_read=filenamelist(ifile).name; %check 
            filename_save=fx_reext(filename_read, '.mat'); %will be replacing with .mat extension
            path_file_read=fullfile(path_dir_month, filename_read);
            %path_file_save=fullfile(path_dir_to, filename_save); %where to save the .mat file
            path_file_save=fullfile(path_dir_to,sprintf('%04d',str2num(yearname)),filesep,sprintf('%02d',str2num(monthname)),filesep);
            fx_mkdir(path_file_save);
            file_save=fullfile(path_file_save, filename_save);
            try
            s=fx_load(path_file_read); %open the .DBL file
            % rescale
            I=fx_inrectangle(s.lon, s.lat, lim_lon, lim_lat); %find out points lying inside
            if isempty(I); continue; end;
            ICEsat=fx_rescale_struct(s,I); %Here if I=0, cs2 is empty
            % save
            save(file_save, 'ICEsat');
            %save(path_file_save,'cs2'); %save the variablecs2s2.mat file which has required info for each
            total=total+1;
            %catch
                %warning('Problem %03d',str2double(monthname));
            end
            
        end
    end
    disp(total); 
end

end