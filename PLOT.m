%a=csvread('E:\GLACIER\HMA\SRTM_270\DH\Tien_SHAN2011.csv');
dh=TienSHAN2011(:,6);
time=TienSHAN2011(:,3);
plot(time,dh,'.')