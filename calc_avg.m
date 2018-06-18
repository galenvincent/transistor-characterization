% Function to average the important metrics from the analysis function

function [mob_stats, vt_stats, curv_stats, hyst_stats, r_stats] = calc_avg(dd,rows)
% rows = vector holding the row numbers you would like to average
% rows = 0 in order to average the whole thing

metric_map(dd);

nchan = length(dd);
indToAvg = [];

if rows == 0
    rows = 1:9;
end

for i = 1:nchan
   if ismember(dd(i).ChanRow,rows)
      indToAvg = [indToAvg,i]; 
   end
end

mob_stats.posMean = mean([dd(indToAvg).posMaxMob]);
mob_stats.posSTD = std([dd(indToAvg).posMaxMob]);
mob_stats.negMean = mean([dd(indToAvg).negMaxMob]);
mob_stats.negSTD = std([dd(indToAvg).negMaxMob]);

vt_stats.posMean = mean([dd(indToAvg).posVt]);
vt_stats.posSTD = std([dd(indToAvg).posVt]);
vt_stats.negMean = mean([dd(indToAvg).negVt]);
vt_stats.negSTD = std([dd(indToAvg).negVt]);

curv_stats.posMean = mean([dd(indToAvg).posCurveFactor]);
curv_stats.posSTD = std([dd(indToAvg).posCurveFactor]);
curv_stats.negMean = mean([dd(indToAvg).negCurveFactor]);
curv_stats.negSTD = std([dd(indToAvg).negCurveFactor]);

hyst_stats.Mean = mean([dd(indToAvg).hystFactor]);
hyst_stats.STD = std([dd(indToAvg).hystFactor]);

r_stats.posMean = mean([dd(indToAvg).posRFactor]);
r_stats.posSTD = std([dd(indToAvg).posRFactor]);
r_stats.negMean = mean([dd(indToAvg).negRFactor]);
r_stats.negSTD = std([dd(indToAvg).negRFactor]);


end