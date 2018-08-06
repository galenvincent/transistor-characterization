% Galen Vincent - Summer 2018
% Function to optimize the desirability function found in fit_res_surf

function des_op = optimize_desirability(lms)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% lms = linear fit object from fit_res_surf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Individual desirability functions
% Mobility - Maximize - d1
L1 = 0;
T1 = 1.5;
s1 = 1;

d1 = @(m)((m - L1)./(T1-L1)).^s1;

% Vt - Target zero (abs value) - d2
U2 = .6;
T2 = 0;
s2 = 1;

d2 = @(vt)((abs(vt) - U2)./(T2 - U2)).^s2;

% Hyst - Maximize to 1 - d3
L3 = 0.7;
T3 = 1;
s3 = 1;

d3 = @(hyst)((hyst - L3)./(T3 - L3)).^s3;

% Curve - Maximize to 1 - d4
L4 = 0.5;
T4 = 1;
s4 = 1;

d4 = @(curv)((curv - L4)./(T4 - L4)).^s4;

% x = [wtp,speed,temp]
m = @(x)feval(lms.mob,x);
v = @(x)feval(lms.vt,x);
h = @(x)feval(lms.hyst,x);
c = @(x)feval(lms.curve,x);

% D = (d1*d2*d3*d4)^(1/4)
dtot = @(x)(-1)*(d1(m(x)).*d2(v(x)).*d3(h(x)).*d4(c(x))).^(1/4);

% Applying the minimization function
lb = [0,0,40]; %lower search bound
ub = [1,15,130]; %upper bound for search
A = [];
b = [];
Aeq = [];
beq = [];

% Sweep various input parameters to see if different results come out
wtpSweep = linspace(0,1,3);
speedSweep = linspace(0,10,3);
tempSweep = linspace(40,100,3);
xin = zeros(27,3);
xout = zeros(27,3);
valout = zeros(27,1);
cnt = 1;

for i = 1:length(wtpSweep)
    for j = 1:length(speedSweep)
        for k = 1:length(tempSweep)
            x0 = [wtpSweep(i),speedSweep(j),tempSweep(k)];
            xin(cnt,:) = x0;
            [xout(cnt,:),valout(cnt)] = fmincon(dtot,x0,A,b,Aeq,beq,lb,ub);
            disp(cnt);
            cnt = cnt+1;
        end
    end
end

des_op.x0 = xin;
des_op.xout = xout;
des_op.valout = valout;

des_op.maxval = max(abs(des_op.valout));
des_op.xmax = des_op.xout(abs(des_op.valout) == des_op.maxval,:);

end
    