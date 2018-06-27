% Fit data with some kind of response surface


function lms = fit_res_surf(datatab)
%datatab is the table returned from read_database
%model_fun is the equation for the model that you would like to use.
    % Ex. model_fun = 'RTMobFor~

% For all values that are NaN, or weren't able to be measured becasue of
% device failure, change the metrics to be 25% worse than the worst metric
% actually measured.

%Is this cool for vt?? maybe not because it could be positive or negative
for i = [4,8,10]
    datatab{isnan(datatab{:,'RTMobForSTD'}),:}(:,i) = min(datatab{:,i})*.75;
end
datatab{isnan(datatab{:,'RTMobForSTD'}),:}(:,6) = max(abs(datatab{:,6}))*1.25;

% Make the standatd deviation equal to the mean of the standard deviations
for i = [5,7,9,11]
    datatab{isnan(datatab{:,'CurveFactorForSTD'}),:}(:,i) = nanmean(datatab{~isnan(datatab{:,'CurveFactorForSTD'}),i});
end

% First, find the weights for each data point for each response variable,
% based on inverse varience weighting
datatab.RTMobForW = find_weights(datatab.RTMobForSTD);
datatab.VtForW = find_weights(datatab.VtForSTD);
datatab.HystFactorW = find_weights(datatab.HystFactorSTD);
datatab.CurveFactorForW = find_weights(datatab.CurveFactorForSTD);

% Do a weighted linear model fit
lms.mob = fitlm(datatab,'RTMobFor~wfSemiPoly + BladeVel + StageTemp + wfSemiPoly^2+BladeVel^2+StageTemp^2 + wfSemiPoly*BladeVel + BladeVel*StageTemp + wfSemiPoly*StageTemp','Weights',datatab.RTMobForW);
lms.vt = fitlm(datatab,'VtFor~wfSemiPoly + BladeVel + StageTemp + wfSemiPoly^2+BladeVel^2+StageTemp^2 + wfSemiPoly*BladeVel + BladeVel*StageTemp + wfSemiPoly*StageTemp','Weights',datatab.VtForW);
lms.hyst = fitlm(datatab,'HystFactor~wfSemiPoly + BladeVel + StageTemp + wfSemiPoly^2+BladeVel^2+StageTemp^2 + wfSemiPoly*BladeVel + BladeVel*StageTemp + wfSemiPoly*StageTemp','Weights',datatab.HystFactorW);
lms.curve = fitlm(datatab,'CurveFactorFor~wfSemiPoly + BladeVel + StageTemp + wfSemiPoly^2+BladeVel^2+StageTemp^2 + wfSemiPoly*BladeVel + BladeVel*StageTemp + wfSemiPoly*StageTemp','Weights',datatab.CurveFactorForW);

end

function weights = find_weights(STDdata)
%data is a table column with standard deviation for the response variable

% un-normalized weights
weights_un = 1./(STDdata.^2);

% normalize the weights so that they add to 1
total = sum(weights_un(~isnan(weights_un)));
weights = weights_un./total;

end