% function to fill the data points for which coating did not happen

function datatab = fix_bad_data(datatabin)
% For all values that are NaN, or weren't able to be measured becasue of
% device failure, change the metrics to be 25% worse than the worst metric
% actually measured.

datatab = datatabin(:,1:end-1);

for i = [4,8,10]
    datatab{isnan(datatab{:,'RTMobForSTD'}),:}(:,i) = min(datatab{:,i})*.75;
end
datatab{isnan(datatab{:,'RTMobForSTD'}),:}(:,6) = max(abs(datatab{:,6}))*1.25;

% Turn all vt values into positives for the fit.
% datatab{:,'VtFor'} = abs(datatab{:,'VtFor'});

% Make the standatd deviation equal to the min of the standard deviations
for i = [5,7,9,11]
    datatab{isnan(datatab{:,'CurveFactorForSTD'}),:}(:,i) = nanmin(datatab{~isnan(datatab{:,'CurveFactorForSTD'}),i});
end

end