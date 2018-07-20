% Fit data with some kind of response surface


function [lms, datatab] = fit_res_surf(datatabin, n, out, fix)
%datatabin is the table returned from read_database
%n is the number of bootstrappings you would like to perform

%out = 1 means output the coefficiants (for mathematica usage)
%out = 0 means do not output the coefficients

%fix = 1 means fix the bad data points
%fix = 0 means get rid of the bad data points

if fix == 0
    datatab = datatabin(:,1:end-1);
    datatab = datatab(~isnan(datatab{:,'RTMobFor'}),:);
elseif fix == 1
    datatab = fix_bad_data(datatabin);
end

% Do a linear model fit
lms.mob = fitlm(datatab,'RTMobFor~wfSemiPoly + BladeVel + StageTemp + wfSemiPoly^2+BladeVel^2+StageTemp^2 + wfSemiPoly*BladeVel + BladeVel*StageTemp + wfSemiPoly*StageTemp');
lms.vt = fitlm(datatab,'VtNormFor~wfSemiPoly + BladeVel + StageTemp + wfSemiPoly^2+BladeVel^2+StageTemp^2 + wfSemiPoly*BladeVel + BladeVel*StageTemp + wfSemiPoly*StageTemp');
lms.hyst = fitlm(datatab,'HystFactor~wfSemiPoly + BladeVel + StageTemp + wfSemiPoly^2+BladeVel^2+StageTemp^2 + wfSemiPoly*BladeVel + BladeVel*StageTemp + wfSemiPoly*StageTemp');
lms.curve = fitlm(datatab,'CurveFactorFor~wfSemiPoly + BladeVel + StageTemp + wfSemiPoly^2+BladeVel^2+StageTemp^2 + wfSemiPoly*BladeVel + BladeVel*StageTemp + wfSemiPoly*StageTemp');

% Find the uncertainty in coefficients using bootstrap method
% Create a temporary matrix
sample_tab = datatab(:,[1,2,3,4,6,8,10]);

% Create an empty table to hold the fit parameters of each sample
fitparams.mob = zeros(n,10);
fitparams.vt = zeros(n,10);
fitparams.hyst = zeros(n,10);
fitparams.curve = zeros(n,10);

for i = 1:n
sample_tab{:,'RTMobFor'} = normrnd(datatab{:,'RTMobFor'},datatab{:,'RTMobForSTD'});
sample_tab{:,'VtNormFor'} = normrnd(datatab{:,'VtNormFor'},datatab{:,'VtNormForSTD'});
sample_tab{:,'HystFactor'} = normrnd(datatab{:,'HystFactor'},datatab{:,'HystFactorSTD'});
sample_tab{:,'CurveFactorFor'} = normrnd(datatab{:,'CurveFactorFor'},datatab{:,'CurveFactorForSTD'});

temp.mob = fitlm(sample_tab,'RTMobFor~wfSemiPoly + BladeVel + StageTemp + wfSemiPoly^2+BladeVel^2+StageTemp^2 + wfSemiPoly*BladeVel + BladeVel*StageTemp + wfSemiPoly*StageTemp');
temp.vt = fitlm(sample_tab,'VtNormFor~wfSemiPoly + BladeVel + StageTemp + wfSemiPoly^2+BladeVel^2+StageTemp^2 + wfSemiPoly*BladeVel + BladeVel*StageTemp + wfSemiPoly*StageTemp');
temp.hyst = fitlm(sample_tab,'HystFactor~wfSemiPoly + BladeVel + StageTemp + wfSemiPoly^2+BladeVel^2+StageTemp^2 + wfSemiPoly*BladeVel + BladeVel*StageTemp + wfSemiPoly*StageTemp');
temp.curve = fitlm(sample_tab,'CurveFactorFor~wfSemiPoly + BladeVel + StageTemp + wfSemiPoly^2+BladeVel^2+StageTemp^2 + wfSemiPoly*BladeVel + BladeVel*StageTemp + wfSemiPoly*StageTemp');

fitparams.mob(i,:) = temp.mob.Coefficients{:,'Estimate'};
fitparams.vt(i,:) = temp.vt.Coefficients{:,'Estimate'};
fitparams.hyst(i,:) = temp.hyst.Coefficients{:,'Estimate'};
fitparams.curve(i,:) = temp.curve.Coefficients{:,'Estimate'};
end

lms.mob_boot.mean = mean(fitparams.mob);
lms.mob_boot.std = std(fitparams.mob);
lms.vt_boot.mean = mean(fitparams.vt);
lms.vt_boot.std = std(fitparams.vt);
lms.hyst_boot.mean = mean(fitparams.hyst);
lms.hyst_boot.std = std(fitparams.hyst);
lms.curve_boot.mean = mean(fitparams.curve);
lms.curve_boot.std = std(fitparams.curve);

switch out
    case 0
        
    case 1
        output = zeros(4,10);
        output(1,:) = lms.mob.Coefficients{:,'Estimate'};
        output(2,:) = lms.vt.Coefficients{:,'Estimate'};
        output(3,:) = lms.hyst.Coefficients{:,'Estimate'};
        output(4,:) = lms.curve.Coefficients{:,'Estimate'};
        
        csvwrite('Z:\data\coefficients.csv',output);
end
end