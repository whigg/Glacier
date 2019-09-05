function year_dec=cs2_sini_ymdhms2decyear(s)
year=s.year;
month=s.month;
day=s.day;
hour=s.hour;
minute=s.minute;
second=s.second;

doy = datenummx(year,month,day,hour,minute,second)-datenummx(year, 1, 1,0,0,0);
year_frac=doy./fx_yeardays(year);
year_dec=year+year_frac;

end