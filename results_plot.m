% Function to get an idea for what each of the points we have
% desirabilities are

function results_plot(datatabin)

% Individual desirability functions
% Mobility - Maximize - d1
L1 = 0;
T1 = 1.5;
s1 = 1;

d1 = @(m)((m - L1)./(T1-L1)).^s1;

% Vt - Target zero (abs value) - d2
U2 = .5;
T2 = 0;
s2 = 1;

d2 = @(vt)((abs(vt) - U2)./(T2 - U2)).^s2;

% Hyst - Maximize to 1 - d3
L3 = 0.4;
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

results = [datatabin{:,'RTMobFor'} datatabin{:,'VtNormFor'} datatabin{:,'HystFactor'} datatabin{:,'CurveFactorFor'}];
desirability = zeros(height(datatabin),1);

for i = 1:length(desirability)
   desirability(i) = dtot(results(i,:)); 
end
dmax = max(desirability);
dmin = min(desirability);
scale = 1/(dmax-dmin);

col = [(desirability-dmin)*scale, 1-(desirability-dmin)*scale, zeros(height(datatabin),1)];

% Plot
figure
ax = gca;
hold on
grid on
ax.XLabel.String = 'Weight Fraction DPP';
ax.YLabel.String = 'Blade Velocity (mm/s)';
ax.ZLabel.String = 'Stage Temperature (C)';
view(60,15)

scatter3(datatabin{:,'wfSemiPoly'},datatabin{:,'BladeVel'},datatabin{:,'StageTemp'},...
    100,desirability,'filled')

%colorMap = [linspace(0,1,1000)' linspace(1,0,1000)' zeros(1000,1)];
colormap('parula');
colorbar;

end



