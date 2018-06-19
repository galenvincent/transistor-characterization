% Function to average the important metrics from the analysis function

function dd_stats = calc_avg(dd,rows)
% rows = vector holding the row numbers you would like to average
% rows = 0 in order to average the whole thing

dd = metric_map(dd);

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

dd_stats.mob.posMean = mean([dd(indToAvg).posMaxMob]);
dd_stats.mob.posSTD = std([dd(indToAvg).posMaxMob]);
dd_stats.mob.negMean = mean([dd(indToAvg).negMaxMob]);
dd_stats.mob.negSTD = std([dd(indToAvg).negMaxMob]);

dd_stats.vt.posMean = mean([dd(indToAvg).posVt]);
dd_stats.vt.posSTD = std([dd(indToAvg).posVt]);
dd_stats.vt.negMean = mean([dd(indToAvg).negVt]);
dd_stats.vt.negSTD = std([dd(indToAvg).negVt]);

dd_stats.curv.posMean = mean([dd(indToAvg).posCurveFactor]);
dd_stats.curv.posSTD = std([dd(indToAvg).posCurveFactor]);
dd_stats.curv.negMean = mean([dd(indToAvg).negCurveFactor]);
dd_stats.curv.negSTD = std([dd(indToAvg).negCurveFactor]);

dd_stats.hyst.Mean = mean([dd(indToAvg).hystFactor]);
dd_stats.hyst.STD = std([dd(indToAvg).hystFactor]);

dd_stats.r.posMean = mean([dd(indToAvg).posRFactor]);
dd_stats.r.posSTD = std([dd(indToAvg).posRFactor]);
dd_stats.r.negMean = mean([dd(indToAvg).negRFactor]);
dd_stats.r.negSTD = std([dd(indToAvg).negRFactor]);


end