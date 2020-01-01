
function [trend,diff,xx,yy,yyy,rDsai] = yyqx_SeasonalFit2data_both(x1,y1,x2,y2)
    x = [x1;x2];
    y = [y1;y2];
% A matrix
    col1 = x;
    col2 = [ones(size(x))];
    col3 = [zeros(size(x1)); ones(size(x2))];
    col4 = [sin(2*pi*x)];
    col5 = [cos(2*pi*x)];
    Amatrix = [col1 col2 col3 col4 col5]; % design matrix  

    sai = inv(Amatrix'*Amatrix)*(Amatrix'*y); % compute [a b], y = ax+b
    estimate_y = Amatrix*sai;
    e = y-estimate_y;
    sigma0s = (e'*e)/(size(Amatrix,1)-rank(Amatrix)); %sigma.not
    Dsai = sigma0s*(inv(Amatrix'*Amatrix));
    rDsai = Dsai(1,1)^0.5;
    new_y2 = y2-sai(3);
    xx = (min(x):0.01:max(x))';
    yy = [xx ones(size(xx)) sin(2*pi*xx) cos(2*pi*xx)]*sai([1:2,4:5]);
    yyy = [xx ones(size(xx))]*sai([1:2]);
    
    trend = sai(1);
    diff = sai(3);    
end