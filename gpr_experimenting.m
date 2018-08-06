% Galen Vincent - Summer 2018
% Experimenting with multivariate GPR modeling

x1 = [datanew{:,'BladeVel'}];
x2 = [datanew{:,'StageTemp'}];
y = [datanew{:,'RTMobFor'}];

gprMdl = fitrgp([x1, x2],y);
sigma0 = std(y)*10;
sigmaF0 = sigma0;
d = 2;
sigmaM0 = 10*ones(d,1);
gprMdl2 = fitrgp([x1 x2],y,'Basis','constant','FitMethod','exact',...
'PredictMethod','exact','KernelFunction','ardsquaredexponential',...
'KernelParameters',[sigmaM0;sigmaF0],'Sigma',sigma0,'Standardize',1);

n = 20;

X = zeros(n^2,2);
count = 1;
x1c = linspace(0,15,n);
x2c = linspace(40,110,n);
X1 = zeros(n,n);
X2 = zeros(n,n);
Y = zeros(n,n);

for i = 1:n
    for j = 1:n
        X(count,1) = x1c(i);
        X(count,2) = x2c(j);
        X1(i,j) = x1c(i);
        X2(i,j) = x2c(j);
        count = count+1;
    end
end

[ypred,ysd,yint] = predict(gprMdl,X);
[ypred2,ysd2,yint2] = predict(gprMdl2,X);

Ypred = zeros(n,n);
Ysd = zeros(n,n);
Yint = zeros(n,n,2);
Ypred2 = zeros(n,n);
Ysd2 = zeros(n,n);
Yint2 = zeros(n,n,2);

count = 1;
for i = 1:n
    for j = 1:n
        Ypred(i,j) = ypred(count);
        Ysd(i,j) = ysd(count);
        Yint(i,j,:) = yint(count,:);
        Ypred2(i,j) = ypred2(count);
        Ysd2(i,j) = ysd2(count);
        Yint2(i,j,:) = yint2(count,:);
        
        count = count + 1;
    end
end

figure;
scatter3(x1,x2,y,75,'r.');
hold on
%surf(X1,X2,Ypred);
surf(X1,X2,Ypred2);
alpha .5
surf(X1,X2,Ypred2+Ysd2);
surf(X1,X2,Ypred2-Ysd2);

