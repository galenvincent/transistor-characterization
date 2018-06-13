% NLM fit of transfer curve data

wid = dd(30).ChanWid;
len = dd(30).ChanLen;
vd = -60;
DE = 3.9;
x = dd(30).vg(30:61);
y = dd(30).id(30:61);

Cap = DE * 8.854e-12 / 200E-9 / (100^2);

%b(1) = mu_0
%b(2) = V_on
%b(3) = gamma
%b(4) = lambda
%b(5) = V_th
%b(6) = m
%b(7) = alpha

mod_fun = @(b,x)(wid/len).*b(1).*(abs(x-b(2)).^b(3)).*Cap.*(1+b(4).*abs(vd))...
    .*(((x-b(5)).*vd).^(-b(6))+b(7).*(.5.*(x-b(5)).^2).^(-b(6))).^(-1/b(6));
beta0 = [0.323,2,.01,0,2,1,1];

%model = fitnlm(x,y,mod_fun,beta0)

figure('Name','model')
hold on
scatter(x,y)
plot(x,mod_fun(beta0,x))
legend('data','model')
