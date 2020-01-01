function cs2=cs2_sini_reader2(path_file_read)
% longitude: 0~360

%--------------------------------------------------------------------------
% read the file
[~, CS]=Cryo_L2I_read(path_file_read);

%--------------------------------------------------------------------------
% RECORD_TAI_TIME
Start_Time=CS.GEO.Start_Time;
Elapsed_Time=CS.GEO.Elapsed_Time;
dayn_2010=datenummx(2000, 1, 1, 0, 0, 0);
dayn=dayn_2010+(Start_Time+Elapsed_Time)/86400;
[s.year, s.month, s.day, s.hour, s.minute, s.second]=datevecmx(dayn); %datevec Convert date 
                                                                      %and time to vector of components
% the difference between STOP_RECORD_TAI_TIME and SENSING_STOP time
% dif1=(09*60+21.824330)-(08*60+47.726361); % 34.0980 seconds
% dif2=(12*60+37.067275)-(12*60+03.155828); % 33.9114 seconds

% geolocation and height
s.lon=CS.GEO.LON; 
% for i=1:length(lon); 
% if lon(i)<0; 
%     lon(i)=lon(i)+360; end; end; % WGS84; -180~180 to 0~360
% s.lon=lon;
s.lat=CS.GEO.LAT;
s.Height_over_surface=CS.MEA.Height_over_surface_r1; % surface height w.r.t. WGS84 by retracker 1 (unit:m)
% Sigma0=CS.MEA.Sigma0_r1; 
% s.SWH=CS.MEA.SWH; 

% correction (unit:m)
s.Dry_Tropo=CS.COR.Dry_Tropo;
s.Wet_Tropo=CS.COR.Wet_Tropo;
s.Inv_Baro=CS.COR.Inv_Baro; % Inverse Barometric Correction, only for ocean surface
s.DAC=CS.COR.DAC; % Dynamic Atmospheric Correction from Mog2D
s.GIM_Iono=CS.COR.GIM_Iono; % computed from the concurrent GIM data (Global Ionospheric Map)
s.Model_Iono=CS.COR.Model_Iono; % computed from a ionospheric model
s.Ocean_Tide=CS.COR.Ocean_Tide; % total geocentric ocean tide, the total effect of ocean tides
s.LPE_Ocean_Tide=CS.COR.LPE_Ocean_Tide; % long period equilibrium ocean tide, the effect of the oceanic response ot the single tidal forcing
s.Ocean_Loading_Tide=CS.COR.Ocean_Loading_Tide; % local distortion to the Earth crust caused bt increasing weight of ocean as local water tide rises
s.Solid_Earth_Tide=CS.COR.Solid_Earth_Tide; % local tidal distortion in the Earth's crust
s.Geoc_Polar_Tide=CS.COR.Geoc_Polar_Tide; % geocentric polar tide, caused by variation in centrifugal force as the Earth's rotational azis moves it geographic location
s.SSB=CS.COR.SSB; % Sea state bias (EM bias)
% s.COR_Status_Flag=CS.COR.COR_Status_Flag; % this field contains a bit that indicates if there corrections that are interpoltaed at 1 Hz
% s.Surf_type=CS.COR.SURF_TYPE; % 0:open ocean, 1:closed sea, 2:continental ice, 3:land, 4-7:currently unused

% flag
Height_Status_Flag=CS.MEA.Height_Status_Flag; % 0=no;1=corrected;
s.Dry_Tropo_flag=Height_Status_Flag.Corrected_for_Dry_Troposphere;
s.Wet_Tropo_flag=Height_Status_Flag.Corrected_for_Wet_Troposphere;
s.Inv_Baro_flag=Height_Status_Flag.Corrected_for_Inverse_Barometer; 
s.DAC_flag=Height_Status_Flag.Corrected_for_DAC; 
s.GIM_Iono_flag=Height_Status_Flag.Corrected_for_Iono_GIM; 
s.Model_Iono_flag=Height_Status_Flag.Corrected_for_Iono_Model; 
s.Ocean_Tide_flag=Height_Status_Flag.Corrected_for_Ocean_Tide; 
s.LPE_Ocean_Tide_flag=Height_Status_Flag.Corrected_for_Ocean_Tide_Long_Period; 
s.Ocean_Loading_Tide_flag=Height_Status_Flag.Corrected_for_Ocean_Tide_Loading; 
s.Solid_Earth_Tide_flag=Height_Status_Flag.Corrected_for_Solid_Earth_Tide; 
s.Geoc_Polar_Tide_flag=Height_Status_Flag.Corrected_for_Geocentric_Polar_Tide; 
s.SSB_flag=Height_Status_Flag.Applied_Sea_State_Bias; 

% Auxiliary
s.Snow_Depth=CS.AUX.Snow_Depth; % mm
s.Snow_Density=CS.AUX.Snow_Density; % kg/m3
s.Geoid=CS.AUX.Geoid; % The	Geoid given	in level2 comes	from the model EGM2008
% s.Ice_Concentration=CS.AUX.Ice_Concentration; % %/1000
% s.MSS=CS.AUX.MSS;

%--------------------------------------------------------------------------
% output
cs2=s;

end
