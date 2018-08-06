% Function to get an idea for what each of the points we have
% desirabilities are

function data_w_des = results_plot(datatabin)

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

% Total desirability
% x = [mobility, vt, hysteresis, curvature]
dtot = @(x)(d1(x(1)).*d2(x(2)).*d3(x(3)).*d4(x(4))).^(1/4);

results = [datatabin{:,'RTMobFor'} datatabin{:,'VtNormFor'} datatabin{:,'HystFactor'} datatabin{:,'CurveFactorFor'}];
desirability = zeros(height(datatabin),1);

data_w_des = datatabin;

for i = 1:length(desirability)
   desirability(i) = dtot(results(i,:)); 
   data_w_des{i,'desirability'}= desirability(i);
end

data_nan = data_w_des(isnan(data_w_des{:,'desirability'}),:);
data_good = data_w_des(~isnan(data_w_des{:,'desirability'}),:);

% Plot
figure('Position',[0,0,1000,800])
ax = gca;
hold on
grid on
ax.XLabel.String = 'Weight Fraction DPP';
ax.YLabel.String = 'Blade Velocity (mm/s)';
ax.ZLabel.String = 'Stage Temperature (C)';
set(ax,'fontsize',20);
view(60,15)

scatter3(data_good{:,'wfSemiPoly'},data_good{:,'BladeVel'},data_good{:,'StageTemp'},...
    300,data_good{:,'desirability'},'filled')
scatter3(data_nan{:,'wfSemiPoly'},data_nan{:,'BladeVel'},data_nan{:,'StageTemp'},300,'k');

colormap(flipud(hot));
%colormap(flipud(parula));
caxis([.2 .7])
%colormap('jet');
colorbar;

% for i = 1:length(desirability)
%    text(datatabin{i,'wfSemiPoly'},datatabin{i,'BladeVel'},datatabin{i,'StageTemp'},num2str(i)) 
% end

pairs = [1 2;2 3;3 4;4 1;6 8;8 7;7 5;5 6;4 7; 1 5;2 6; 3 8];
pairs2 = [10 16;16 11;15 16;16 14;13 16;16 12];
pairs3 = [18 20; 20 22;22 19;19 18];
% 
% for i = 1:length(pairs)
%     plot3(datatabin{pairs(i,:),'wfSemiPoly'},datatabin{pairs(i,:),'BladeVel'},datatabin{pairs(i,:),'StageTemp'},'k--');
% end
% for i = 1:length(pairs2)
%     plot3(datatabin{pairs2(i,:),'wfSemiPoly'},datatabin{pairs2(i,:),'BladeVel'},datatabin{pairs2(i,:),'StageTemp'},'k');
% end
% for i = 1:length(pairs3)
%     plot3(datatabin{pairs3(i,:),'wfSemiPoly'},datatabin{pairs3(i,:),'BladeVel'},datatabin{pairs3(i,:),'StageTemp'},'k--');
% end

view(24,13);

end



