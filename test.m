lms.mob = fitlm(data2d,'RTMobFor~wfSemiPoly + BladeVel + wfSemiPoly^2+BladeVel^2 + wfSemiPoly*BladeVel');

% Individual desirability functions
% Mobility - Maximize - d1
L1 = 0;
T1 = 1.5;
s1 = 1;

d1 = @(m)((m - L1)./(T1-L1)).^s1;

% Vt - Target zero (abs value) - d2
U2 = 1;
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

% Total desirability
% x = [mobility, vt, hysteresis, curvature]
dtot = @(x)(d1(x(1)).*d2(x(2)).*d3(x(3)).*d4(x(4))).^(1/4);

results = [data2d{:,'RTMobFor'} data2d{:,'VtNormFor'} data2d{:,'HystFactor'} data2d{:,'CurveFactorFor'}];
desirability = zeros(height(data2d),1);

for i = 1:length(desirability)
   desirability(i) = dtot(results(i,:)); 
end
