% Galen Vincent - Summer 2018
% Function to fix the inoperable data points for fit_res_surf

% For all values that are NaN, or weren't able to be measured becasue of
% device failure, change the metrics to be 25% worse than the worst metric
% actually measured

function datatab = fix_bad_data(datatabin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% datatabin = data table from read_database

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

datatab = datatabin(:,1:end-1);

% Make all metrics that are NaN 25% worse than the lowest measured
for i = [4,6,8,10]
    datatab{isnan(datatab{:,'RTMobForSTD'}),:}(:,i) = min(datatab{:,i})*.75;
end

% Make the standatd deviation for these metrics equal to the minimum of the
% standard deviations measured
for i = [5,7,9,11]
    datatab{isnan(datatab{:,'CurveFactorForSTD'}),:}(:,i) = nanmin(datatab{~isnan(datatab{:,'CurveFactorForSTD'}),i});
end

end