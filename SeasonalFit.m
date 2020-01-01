function [trend,xx,yy,yyy,rDsai] = SeasonalFit(x,y)
% A matrix
%What is x and y ? Time and 'dh' ??

    col1 = x;
    col2 = [ones(size(x))];
    col3 = [sin(2*pi*x)];
    col4 = [cos(2*pi*x)];
    Amatrix = [col1 col2 col3 col4]; % design matrix  

    sai = inv(Amatrix'*Amatrix)*(Amatrix'*y); % compute [a b], y = ax+b
    estimate_y = Amatrix*sai;
    e = y-estimate_y;
    sigma0s = (e'*e)/(size(Amatrix,1)-rank(Amatrix));
    Dsai = sigma0s*(inv(Amatrix'*Amatrix));
    rDsai = Dsai(1,1)^0.5;

    xx = (min(x):0.01:max(x))';
    yy = [xx ones(size(xx)) sin(2*pi*xx) cos(2*pi*xx)]*sai;
    yyy = [xx ones(size(xx))]*sai([1:2]);
    
    trend = sai(1);   
    end