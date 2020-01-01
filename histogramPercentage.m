% Helps to display percantages on histogram bars

function histogramPercentage(x,fontSize)

h =  histogram(x,'Visible', 'off');
h.BinWidth=200;
h.BinLimits=[3000 8000];
[nelements,centers]= hist(x,h.NumBins);
percantages = 100 * nelements / sum(nelements);
bar(centers,nelements,'Facecolor',[0.4,0.7,0.9],'BarWidth',1);

for k = 1:numel(centers)
    if percantages(k) ~= 0
        text(centers(k),nelements(k),[sprintf('%.f',(percantages(k))) '%'],'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',fontSize);
    end
end