function [slope,intercept,uncertainty] = yyqx_LinearFit(x,y)

% A matrix
Amatrix = [x ones(size(x))];
Nmatrix = Amatrix'*Amatrix;
cmatrix = Amatrix'*y;
% sai
sai = inv(Nmatrix)*(cmatrix);
slope = sai(1);
intercept = sai(2);
e = y-Amatrix*sai;

sigma02 = e'*e/(length(e)-2);

uncertain = (sigma02*(inv(Nmatrix)));

uncertainty = uncertain(1,1)^0.5;
end