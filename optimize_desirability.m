
% To optimize the desirability approach, use fmincon() 
% see: https://www.mathworks.com/help/optim/ug/fmincon.html#busow0w-1
    % See bound constaints, and also fval output option
    % do a grid of sweeps across multiple initial points to see what the
    % global max in our design space is
    
    % This function finds the minimum. Find the minimum of the negative of
    % our desirability function in order to find the max.
    
    
% Individual desirability functions
% Mobility - Maximize - d1
    L1 = 0;
    T1 = 10;
    s1 = 1;
    
 d1 = @(m)((m - L1)./(T1-L1)).^s1;

% Vt - Target zero (abs value) - d2
    U2 = 20;
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
    % m(x) = mob(x)
    % v(x) = vt(x)
    % h(x) = hyst(x)
    % c(x) = curv(x)
    % x = [wtp,speed,temp]
    
% D = (d1*d2*d3*d4)^(1/4)
dtot = @(x)d1(m(x)).*d2(v(x)).*d3(h(x)).*d4(c(x));
    

% Applying the minimization function
lb = [0,0,30]; %lower search bound
ub = [100,20,150]; %upper bound for search
A = [];
b = [];
Aeq = [];
beq = [];

% Sweep various input parameters to see if different results come out
wtpSweep = linspace(0,100,5);
speedSweep = linspace(0,15,5);
tempSweep = linspace(40,100,5);
xout = zeros(125,3);
valout = zeros(125,1);
cnt = 1;

for i = 1:5
    for j = 1:5
        for k = 1:5
            x0 = [wtpSweep(i),speedSweep(j),tempSweep(k)];
            [xout(cnt,:),valout(cnt)] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub);
        end
    end
end

    