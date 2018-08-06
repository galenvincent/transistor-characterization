% Galen Vincent - Summer 2018
% Dont use this for anything. Moved past this idea.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Bootstrap surface model fits to the data points based on their standard
% deviations. Come up with the mean model and also the mean model's error
% for each predictor.

% Possibly add errors in quadrature and caclulate an overall error for the
% dtot plot. 

function [fitparams, fitparamstats] = fit_res_surf_bootstrap(datatabin,n)

%datatab is the table returned from read_database
% n is the number of bootstrap re-samplings that you would like to perform

% For all values that are NaN, or weren't able to be measured becasue of
% device failure, change the metrics to be 25% worse than the worst metric
% actually measured.

datatab = datatabin(:,1:end-1);

%Is this cool for vt?? maybe not because it could be positive or negative
    %Answer - yes it is because we end up fitting absolute value of vt
for i = [4,8,10]
    datatab{isnan(datatab{:,'RTMobForSTD'}),:}(:,i) = min(datatab{:,i})*.75;
end
datatab{isnan(datatab{:,'RTMobForSTD'}),:}(:,6) = max(abs(datatab{:,6}))*1.25;

% Make the standatd deviation equal to zero for these points (we know
% they're bad. They need to stay bad).
for i = [5,7,9,11]
    datatab{isnan(datatab{:,'CurveFactorForSTD'}),:}(:,i) = 0;
end

% Turn all vt values into positives for the fit.
datatab{:,'VtFor'} = abs(datatab{:,'VtFor'});

% Do the actual bootstrapping
% Create a temporary matrix
sample_tab = datatab(:,[1,2,3,4,6,8,10]);

% Create an empty table to hold the fit parameters of each sample
fitparams.mob = zeros(n,10);
fitparams.vt = zeros(n,10);
fitparams.hyst = zeros(n,10);
fitparams.curve = zeros(n,10);

for i = 1:n
sample_tab{:,'RTMobFor'} = normrnd(datatab{:,'RTMobFor'},datatab{:,'RTMobForSTD'});
sample_tab{:,'VtFor'} = normrnd(datatab{:,'VtFor'},datatab{:,'VtForSTD'});
sample_tab{:,'HystFactor'} = normrnd(datatab{:,'HystFactor'},datatab{:,'HystFactorSTD'});
sample_tab{:,'CurveFactorFor'} = normrnd(datatab{:,'CurveFactorFor'},datatab{:,'CurveFactorForSTD'});

% Do a linear model fit
lms.mob = fitlm(sample_tab,'RTMobFor~wfSemiPoly + BladeVel + StageTemp + wfSemiPoly^2+BladeVel^2+StageTemp^2 + wfSemiPoly*BladeVel + BladeVel*StageTemp + wfSemiPoly*StageTemp');
lms.vt = fitlm(sample_tab,'VtFor~wfSemiPoly + BladeVel + StageTemp + wfSemiPoly^2+BladeVel^2+StageTemp^2 + wfSemiPoly*BladeVel + BladeVel*StageTemp + wfSemiPoly*StageTemp');
lms.hyst = fitlm(sample_tab,'HystFactor~wfSemiPoly + BladeVel + StageTemp + wfSemiPoly^2+BladeVel^2+StageTemp^2 + wfSemiPoly*BladeVel + BladeVel*StageTemp + wfSemiPoly*StageTemp');
lms.curve = fitlm(sample_tab,'CurveFactorFor~wfSemiPoly + BladeVel + StageTemp + wfSemiPoly^2+BladeVel^2+StageTemp^2 + wfSemiPoly*BladeVel + BladeVel*StageTemp + wfSemiPoly*StageTemp');

fitparams.mob(i,:) = lms.mob.Coefficients{:,'Estimate'};
fitparams.vt(i,:) = lms.vt.Coefficients{:,'Estimate'};
fitparams.hyst(i,:) = lms.hyst.Coefficients{:,'Estimate'};
fitparams.curve(i,:) = lms.curve.Coefficients{:,'Estimate'};
end

fitparamstats.mob.mean = mean(fitparams.mob);
fitparamstats.mob.std = std(fitparams.mob);
fitparamstats.vt.mean = mean(fitparams.vt);
fitparamstats.vt.std = std(fitparams.vt);
fitparamstats.hyst.mean = mean(fitparams.hyst);
fitparamstats.hyst.std = std(fitparams.hyst);
fitparamstats.curve.mean = mean(fitparams.curve);
fitparamstats.curve.std = std(fitparams.curve);

%print('done')

end