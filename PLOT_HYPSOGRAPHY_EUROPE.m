function PLOT_HYPSOGRAPHY_EUROPE(ipparameter)
path_dir_from1=ipparameter.path_dir_from1;
path_dir_from2=ipparameter.path_dir_from2;
path_dir_save=ipparameter.path_dir_to;


[file1,~]=fx_dir(path_dir_from1,'.mat');
%[file2,~]=fx_dir(path_dir_from2,'.mat');

%Tempoarry
cs2=[];
[file2,nfile]=fx_dir(path_dir_from2,'.csv');
for h=1:nfile
a=csvread(fullfile(path_dir_from2,file2(h).name),1,0);
cs2=[cs2;a(:,5)];

end
srtm=fx_load(fullfile(path_dir_from1,file1.name));
%s2=fx_load(fullfile(path_dir_from2,file2.name));

%cs2=s2.elev_a;
I=find(srtm>-1000);
srtm=srtm(I);
t=numel(srtm);
w=numel(cs2);


A=min(srtm);
B=max(srtm);

A1=min(cs2);
B1=max(cs2);

    
bar_min=A-rem(A,500);
bar_max=B-rem(B,500)+500;

number1=[];
number2=[];
    x=1500:200:4500;
    i=1;
    while i<=(numel(x)-1)
    I1=find(srtm >= x(i) & srtm <x(i+1));
    I2=find(cs2 >= x(i) & cs2 <x(i+1));
    number1=[number1;numel(I1)];
    number2=[number2;numel(I2)];
    i=i+1;
    end
    X=number1/t;
    Y=number2/w;


for l=1:(numel(x)-1)
    center(l)=mean(x(l),x(l+1));
end
%Drawing the bar graph as required.
%bar(center,proportion)

filename_plot1='HYPSOGRAPHY_DH.tif'; %filename same as whhat was read .tif
path_file_plot1=fullfile(path_dir_save, filename_plot1); %path where file will be plotted
% plot
h=figure('visible', 'off');
set(h, 'Position', [1 1 600 300]);

subplot(2,1,1);
bar(center,X,1);
title('ELevation Profile');
ylabel('Elevation (m)');
xlabel('Fraction');

subplot(2,1,2);
bar(center,Y,1);
title('ELevation Profile');
ylabel('Elevation (m)');
xlabel('Fraction');
%Decide the number of bins
%nbin
print(h, '-dtiff', '-r300', path_file_plot1);


