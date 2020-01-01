function PLOT_HYPSOGRAPHY_HMA_ICESat(ipparameter)
path_dir_from1=ipparameter.path_dir_from1;
path_dir_from2=ipparameter.path_dir_from2;
path_dir_save=ipparameter.path_dir_to;


[file1,~]=fx_dir(path_dir_from1,'.mat');
%[file2,~]=fx_dir(path_dir_from2,'.mat');

%Tempoarry
cs2=[];
[file2,nfile]=fx_dir(path_dir_from2,'.mat');
for h=1:nfile
a=xlsread(fullfile(path_dir_from2,file2(h).name));
cs2=[cs2;a(:,4)];
end

srtm=fx_load(fullfile(path_dir_from1,file1.name));
% s2=fx_load(fullfile(path_dir_from2,file2.name));
% 
% cs2=s2.elev_a;
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
    x=3000:200:8000;
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

filename_plot1='HYPSOGRAPHY_DH_602.tif'; %filename same as whhat was read .tif
path_file_plot1=fullfile(path_dir_save, filename_plot1); %path where file will be plotted
% plot
h=figure('visible', 'off');
set(h, 'Position', [1 1 300 300]);

subplot(2,1,1);
bar(center,X,1);
title('Elevation Profile of SRTM');
xlabel('Elevation (m)');
ylabel('Fraction');
set(gca,'TickLength',[0.001, 0.01],'FontSize',5)
xticks([3000:1000:8000]);
text(7000,0.1,['n = ',num2str(t)],...
	'VerticalAlignment','middle',...
	'HorizontalAlignment','left',...
	'FontSize',5)
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];

subplot(2,1,2);
bar(center,Y,1);
title('Elevation Profile of Cryosat-2');
xlabel('Elevation (m)');
ylabel('Fraction');
set(gca,'TickLength',[0.001, 0.01],'FontSize',5)
xticks([3000:1000:8000]);
text(7000,0.1,['n = ',num2str(w)],...
	'VerticalAlignment','middle',...
	'HorizontalAlignment','left',...
	'FontSize',5)
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];


for k = 1:numel(center)
      text(center(k),Y(k),[sprintf('%.f',((Y(k)-X(k))*100)) '%'],'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',3);
end
%Decide the number of bins
%nbin
print(h, '-dtiff', '-r600', path_file_plot1);


