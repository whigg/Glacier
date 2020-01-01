function [slope1,intercept1,slope2,intercept2] = yyqx_LinearFit2data(x1,y1,x2,y2)
y = [y1;y2];
% A matrix
Amatrix = [x1 ones(size(x1)) zeros(size(x1)) zeros(size(x1));
    zeros(size(x2)) zeros(size(x2)) x2 ones(size(x2))];
Nmatrix = Amatrix'*Amatrix;
cmatrix = Amatrix'*y;
% sai
sai = inv(Nmatrix)*(cmatrix);
slope1 = sai(1);
intercept1 = sai(2);
slope2 = sai(3);
intercept2 = sai(4);

% e = y-Amatrix*sai;
% sigma02 = e'*e/(length(e)-2);
% uncertain = (sigma02*(inv(Nmatrix)));
% uncertainty = uncertain(1,1)^0.5;
end