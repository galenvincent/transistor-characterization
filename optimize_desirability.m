
% To optimize the desirability approach, use fmincon()
    % see: https://www.mathworks.com/help/optim/ug/fmincon.html#busow0w-1
    % See bound constaints, and also fval output option
    % do a grid of sweeps across multiple initial points to see what the
    % global max in our design space is

% This function finds the minimum. Find the minimum of the negative of
% our desirability function in order to find the max.

function des_op = optimize_desirability(lms)
% Individual desirability functions
% Mobility - Maximize - d1
L1 = 0;
T1 = 10;
s1 = 1;

d1 = @(m)((m - L1)./(T1-L1)).^s1;

% Vt - Target zero (abs value) - d2
U2 = 100;
T2 = 0;
s2 = 1;

d2 = @(vt)((abs(vt) - U2)./(T2 - U2)).^s2;

% Hyst - Maximize to 1 - d3
L3 = 0;
T3 = 1;
s3 = 1;

d3 = @(hyst)((hyst - L3)./(T3 - L3)).^s3;

% Curve - Maximize to 1 - d4
L4 = 0;
T4 = 1;
s4 = 1;

d4 = @(curv)((curv - L4)./(T4 - L4)).^s4;


% this is where the fit for each individual response would come in
m = @(x)feval(lms.mob,x);
v = @(x)feval(lms.vt,x);
h = @(x)feval(lms.hyst,x);
c = @(x)feval(lms.curve,x);
% x = [wtp,speed,temp]

% D = (d1*d2*d3*d4)^(1/4)
dtot = @(x)(-1)*(d1(m(x)).*d2(v(x)).*d3(h(x)).*d4(c(x))).^(1/4);


% Applying the minimization function
lb = [0,0,30]; %lower search bound
ub = [1,20,150]; %upper bound for search
A = [];
b = [];
Aeq = [];
beq = [];

% Sweep various input parameters to see if different results come out
wtpSweep = linspace(0,1,3);
speedSweep = linspace(0,15,3);
tempSweep = linspace(40,100,3);
xout = zeros(27,3);
valout = zeros(27,1);
cnt = 1;

for i = 1:length(wtpSweep)
    for j = 1:length(speedSweep)
        for k = 1:length(tempSweep)
            x0 = [wtpSweep(i),speedSweep(j),tempSweep(k)];
            [xout(cnt,:),valout(cnt)] = fmincon(dtot,x0,A,b,Aeq,beq,lb,ub);
            cnt = cnt+1;
        end
    end
end

des_op.x0 = x0;
des_op.xout = xout;
des_op.valout = valout;
%des_op.fun = dtot;

end
    