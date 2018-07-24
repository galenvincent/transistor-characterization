
function [op,ind] = max_ci_bootstrap(datatabin, fix, n)

% fix = 0 means do not fix the bad data points
% fix = 1 means fix the bad data points

if fix == 0
    datatab = datatabin(:,1:end-1);
    datatab = datatab(~isnan(datatab{:,'RTMobFor'}),:);
elseif fix == 1
    datatab = fix_bad_data(datatabin);
end

% Create a temporary matrix
sample_tab = datatab(:,[1,2,3,4,6,8,10]);

% create matrix to hold the optimized locations and desirabilities
op.xout = zeros(n,3);
op.valout = zeros(n,1);

tic

for i = 1:n
    sample_tab{:,'RTMobFor'} = normrnd(datatab{:,'RTMobFor'},datatab{:,'RTMobForSTD'});
    sample_tab{:,'VtNormFor'} = normrnd(datatab{:,'VtNormFor'},datatab{:,'VtNormForSTD'});
    sample_tab{:,'HystFactor'} = normrnd(datatab{:,'HystFactor'},datatab{:,'HystFactorSTD'});
    sample_tab{:,'CurveFactorFor'} = normrnd(datatab{:,'CurveFactorFor'},datatab{:,'CurveFactorForSTD'});
    
    % Do a linear model fit
    lms.mob = fitlm(sample_tab,'RTMobFor~wfSemiPoly + BladeVel + StageTemp + wfSemiPoly^2+BladeVel^2+StageTemp^2 + wfSemiPoly*BladeVel + BladeVel*StageTemp + wfSemiPoly*StageTemp');
    lms.vt = fitlm(sample_tab,'VtNormFor~wfSemiPoly + BladeVel + StageTemp + wfSemiPoly^2+BladeVel^2+StageTemp^2 + wfSemiPoly*BladeVel + BladeVel*StageTemp + wfSemiPoly*StageTemp');
    lms.hyst = fitlm(sample_tab,'HystFactor~wfSemiPoly + BladeVel + StageTemp + wfSemiPoly^2+BladeVel^2+StageTemp^2 + wfSemiPoly*BladeVel + BladeVel*StageTemp + wfSemiPoly*StageTemp');
    lms.curve = fitlm(sample_tab,'CurveFactorFor~wfSemiPoly + BladeVel + StageTemp + wfSemiPoly^2+BladeVel^2+StageTemp^2 + wfSemiPoly*BladeVel + BladeVel*StageTemp + wfSemiPoly*StageTemp');
    
    % optimize the fit
    des_op = des_op_special(lms);
    op.xout(i,:) = des_op.xout;
    op.valout(i) = des_op.valout;
    disp(i);
end

disp('done');
toc

op.mean = mean(op.xout);
op.sorted = sort(op.xout);

% find the 95% AI around the mean
ind = (round((n-1)*(1-.95)/2));
op.lower = op.sorted(ind+1,:);
op.upper = op.sorted(n-ind,:);

end

function des_op = des_op_special(lms)
% if boot = 0: non bootstrap method - output from fit_res_surf is the input
% lms

% if boot = 1: bootstrap method - output statistics struct from
% fit_res_surf_bootstrap is the input lms

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


% this is where the fit for each individual response would come in
% x = [wtp,speed,temp]
%if boot == 0
    m = @(x)feval(lms.mob,x);
    v = @(x)feval(lms.vt,x);
    h = @(x)feval(lms.hyst,x);
    c = @(x)feval(lms.curve,x);

% D = (d1*d2*d3*d4)^(1/4)
dtot = @(x)(-1)*(d1(m(x)).*d2(v(x)).*d3(h(x)).*d4(c(x))).^(1/4);


% Applying the minimization function
lb = [0,0,40]; %lower search bound
ub = [1,20,130]; %upper bound for search
A = [];
b = [];
Aeq = [];
beq = [];

% Sweep various input parameters to see if different results come out

x0 = [.3,5,100];
[xout, valout] = fmincon(dtot,x0,A,b,Aeq,beq,lb,ub);

des_op.x0 = x0;
des_op.xout = xout;
des_op.valout = valout;

end
    