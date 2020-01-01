function nd = fx_yeardays(y)

% Next year values
next_y = y+1;

% Generate number of days in year.
nd=datenum(next_y, 1, 1)-datenum(y, 1, 1);

end