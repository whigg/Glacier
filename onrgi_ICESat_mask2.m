function onrgi_ICESat_mask2(ipparameter)
%--------------------------------------------------------------------------
%if strcmp(turn, 'off'); return; end;
path_dir_from1=ipparameter.path_dir_from1; %Cryosat after correction
path_dir_from2=ipparameter.path_dir_from2; %Subregion RGI
path_dir_to=ipparameter.path_dir_to; %where to save
fx_mkdir(path_dir_to);
%from1='C:\CORRECTED_Autumn\'
%from2='C:\subregions\subA\subB\'
%to='C:\CORRECTED_Autumn\ON_RGI\SUB B\'
 path_file_read2=fullfile(path_dir_from2, 'rgiAndes.mat');
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
        s2.year=str2num(yearname)*ones(numel(cs2.lon),1);
        s2.month=str2num(monthname)*ones(numel(cs2.lon),1);
        s2.day=1*ones(numel(cs2.lon),1);
        s2.hour=12*ones(numel(cs2.lon),1);
        s2.minute=00*ones(numel(cs2.lon),1);
        s2.second=00*ones(numel(cs2.lon),1);
        cs2.time=cs2_sini_ymdhms2decyear(s2);
        path_dir_save=fullfile(path_dir_to, sprintf('%04d',str2num(yearname)),filesep,sprintf('%02d',str2num(monthname)),filesep);
        fx_mkdir(path_dir_save);
        path_file_save=fullfile(path_dir_save,filename);
          % rgi
             %RGI file loaded 
         % cs2 
         %[lim_lon, lim_lat]=cs2_tilename2lim(filename); %What does this function do??
         %I1=fx_inrectangle(cs2_s.lon, cs2_s.lat, lim_lon, lim_lat); %rescale Cryosat based on RGI limits
         %if isempty(I1); continue; end;
         %cs2=fx_rescale_struct(cs2_s, I1); %rescale Cryosat based on RGI
         % rescale the CS2 based on rgi mask poin by point
         c=cell(1,1);
         idx=1;
         for j=1:length(rgi_c)
            rgi=rgi_c{j};
            I2=inpolygon(cs2.lon, cs2.lat, rgi.lon, rgi.lat); %check which tracks are in RGI limits
               if isempty(find(I2)); continue; end;
                     c{idx,1}=fx_rescale_struct(cs2, I2);%rescalke the CS2 cell based on rgi mask
                     idx=idx+1;
         end
         % save
         if idx==1; continue; end;
          ICESat=fx_cell2struct(c);      % converts cell to structure
          save(path_file_save, 'ICESat'); %rescaled Crysoat saved as 's'. 

       end

end
end