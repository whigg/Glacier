clear;
close all;

% Example data set
%x = randn(1000,1);
load('E:\GLACIER\SRTM_TRY.mat');
srtm=double(srtm);
figure;
subplot(2,1,1);
h1=histogram(srtm);
h1.BinWidth=200;
h1.BinLimits=[3000 8000];
title('Histogram');
xlabel('Values');
ylabel('Number of Observations');

subplot(2,1,2);
histogramPercentage(srtm,8);
title('Histogram Percentage')
xlabel('Values');
ylabel('Number of Observations');