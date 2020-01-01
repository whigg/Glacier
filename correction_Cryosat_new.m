function correction_Cryosat_new(ipparameter)
% FUNCTION DESCRIPTION
% --------------------
% the height correction is based on section 8.1.3 and 8.1.4 from Cryosat-2
% hand book. There are two types of correction, which are ranged and
% environmental corrections. 
% -------------------------------------------------------------------------
%    - dry tropospheric correction (ranged)
%    - wet Tropospheric correction (ranged)
%    Inverse Barometric Correction
%    x dynamic atmospheric correction (environmental): an IB correction 
%       developed by CLS, assuming a static response of the
%       ocean to atmospheric forcing, and neglecting wind effects for low frequency
%    - GIM ionospheric correction (ranged)
%    x Model_Iono
%    x total geocentric ocean tide (environmental)
%    x long period equilibrium ocean tide (not in handbook): Long-Period tides are gravitational tides
%    - Ocean Tide Loading (not in handbook)
%    - solid earth tide height (environmental)
%    - geocentric polar tide (environmental)
%    x sea state bias correction (ranged)
%    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% Referenced by providing the following input values
%----------------------------------------------------
% ipparameter.path_dir_from1 : path to cryosat '.mat' files
% ipparameter.path_dir_to    : path to Corrected Cryosat files

% Output
% cs2-> sstructure with fields lat, lon, elevtion before and after (with
% respect to egm 1996) correction; height of geoid
%--------------------------------------------------------------------------
%if strcmp(turn, 'off'); return; end;
path_dir_from1=ipparameter.path_dir_from1; %read CS2
%path_dir_from2=ipparameter.path_dir_from2; % read EGM
path_dir_to=ipparameter.path_dir_to; 
fx_mkdir(path_dir_to);

%--------------------------------------------------------------------------
% correction
[yearnamelist, nyear]=fx_dir(path_dir_from1); %read CS2 saved in region_extracter
for i=1:nyear
    % path
    yearname=yearnamelist(i).name;
    path_dir_year=fullfile(path_dir_from1,yearname,filesep);
    [monthnamelist, nmonth]=fx_dir(path_dir_year);
    for j=1:nmonth
        monthname=monthnamelist(j).name;
        %path_file_read=fullfile(path_dir_year, monthname);
        %path_file_save=fullfile(path_dir_to, yearname);
        % time
        path_dir_month=fullfile(path_dir_year, monthname,filesep); %month
        % pass
        [filenamelist, nfile]=fx_dir(path_dir_month, '.mat'); %searches all files
        for ifile=1:nfile
            %disp([num2str(ifile),'processed'])
            filename_read=filenamelist(ifile).name; %check 
            filename_save=fx_reext(filename_read, '.mat'); %will be replacing with .mat extension
             path_file_read=fullfile(path_dir_month, filename_read);
             s=fx_load(path_file_read);%to get the value in a field
             s.decyear=cs2_sini_ymdhms2decyear(s);
             % elev
              s.elev=s.Height_over_surface;
              % flag (0:no, 1:corrected)
            % dry tropospheric correction
                 I=s.Dry_Tropo_flag==0;
               s.elev(I)=s.elev(I)-s.Dry_Tropo(I);
                % wet Tropospheric correction
               I=s.Wet_Tropo_flag==0; 
               s.elev(I)=s.elev(I)-s.Wet_Tropo(I);
               % GIM ionospheric correction
               I=s.GIM_Iono_flag==0; 
               s.elev(I)=s.elev(I)-s.GIM_Iono(I);
               % Ocean Tide Loading
               I=s.Ocean_Loading_Tide_flag==0; 
               s.elev(I)=s.elev(I)-s.Ocean_Loading_Tide(I);
               % solid earth tide height
                I=s.Solid_Earth_Tide_flag==0; 
               s.elev(I)=s.elev(I)-s.Solid_Earth_Tide(I);
               % geocentric polar tide
                I=s.Geoc_Polar_Tide_flag==0; 
                s.elev(I)=s.elev(I)-s.Geoc_Polar_Tide(I);
                %Inverse Barometric correction (If applicable)
                %I=s.Inv_Baro_flag==0;
                %s.elev(I)=s.elev(I)-s.Inv_Baro(I);
                 %WGS84-EGM2008
%                  s.elev_b=s.Height_over_surface;
                 %s.elev=s.elev-F(s.lon, s.lat); %For conversion of elevation
                 %s.elev_b=s.Height_over_surface;
                 s.elev=s.elev-s.Geoid;
                % save
                cs2.time=s.decyear;
                cs2.lon=s.lon;
                cs2.lat=s.lat;
                cs2.elev_a=s.elev;
                cs2.elev_b=s.Height_over_surface;
                cs2.Geoid=s.Geoid;
                path_file_save=fullfile(path_dir_to,sprintf('%04d',str2num(yearname)),filesep,sprintf('%02d',str2num(monthname)),filesep);
                fx_mkdir(path_file_save);
                file_save=fullfile(path_file_save, filename_save);
                save(file_save, 'cs2');
                clear s cs2;
         end
        end
    end

end
