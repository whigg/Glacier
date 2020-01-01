function I=fx_inrectangle(lon, lat, lim_lon, lim_lat)
%--------------------------------------------------------------------------
I=find(lon>=min(lim_lon) & lon<=max(lim_lon) & ...
    lat>=min(lim_lat) & lat<=max(lim_lat) );

end
