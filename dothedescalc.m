% Galen Vincent - Summer 2018
% Function to calculate desirability for each channel in a batch of chips

function dd = dothedescalc(ddcellarray)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ddcellarray = a cell array containing one or multiple dd objects (from
% mob_dual_abalysis) for which you would like to know the desirability for
% each channel

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dd = ddcellarray;

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
L3 = 0.55;
T3 = 1;
s3 = 1;

d3 = @(hyst)((hyst - L3)./(T3 - L3)).^s3;

% Curve - Maximize to 1 - d4
L4 = 0.4;
T4 = 1;
s4 = 1;

d4 = @(curv)((curv - L4)./(T4 - L4)).^s4;

% Total desirability
% x = [mobility, vt, hysteresis, curvature]
dtot = @(x)(d1(x(1)).*d2(x(2)).*d3(x(3)).*d4(x(4))).^(1/4);

% Sweep through the cell array of dd objects
for i = 1:length(dd)
    temp = dd{i};
    % Sweep through the channels of the dd object you are on and calculate
    % desirability of each
    for j = 1:length(dd{i})
        temp(j).mobnorm = d1(temp(j).forMaxMob);
        temp(j).vtnorm = d2(temp(j).forVtFactor);
        temp(j).hystnorm = d3(temp(j).hystFactor);
        temp(j).curvnorm = d4(temp(j).forCurveFactor);
        temp(j).desirability = dtot([temp(j).forMaxMob, temp(j).forVtFactor, temp(j).hystFactor, temp(j).forCurveFactor]);
    end
    
    dd{i} = temp;
end

end