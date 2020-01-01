%%

function gd_diff=geoid_conv_egm(lat,lon)

%CONVERT FROM EGM 2008 to EGM 1996
N1996 = geoidheight(lat, lon, 'EGM96'); %Compute the height of the geoid above the ellipsoid
N2008 = geoidheight(lat, lon, 'EGM2008');

gd_diff=N1996-N2008;

end

