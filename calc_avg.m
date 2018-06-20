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

dd_stats.mob.backMean = mean([dd(indToAvg).backMaxMob]);
dd_stats.mob.backSTD = std([dd(indToAvg).backMaxMob]);
dd_stats.mob.forMean = mean([dd(indToAvg).forMaxMob]);
dd_stats.mob.forSTD = std([dd(indToAvg).forMaxMob]);

dd_stats.vt.backMean = mean([dd(indToAvg).backVt]);
dd_stats.vt.backSTD = std([dd(indToAvg).backVt]);
dd_stats.vt.forMean = mean([dd(indToAvg).forVt]);
dd_stats.vt.forSTD = std([dd(indToAvg).forVt]);

dd_stats.curv.backMean = mean([dd(indToAvg).backCurveFactor]);
dd_stats.curv.backSTD = std([dd(indToAvg).backCurveFactor]);
dd_stats.curv.forMean = mean([dd(indToAvg).forCurveFactor]);
dd_stats.curv.forSTD = std([dd(indToAvg).forCurveFactor]);

dd_stats.hyst.Mean = mean([dd(indToAvg).hystFactor]);
dd_stats.hyst.STD = std([dd(indToAvg).hystFactor]);

dd_stats.r.backMean = mean([dd(indToAvg).backRFactor]);
dd_stats.r.backSTD = std([dd(indToAvg).backRFactor]);
dd_stats.r.forMean = mean([dd(indToAvg).forRFactor]);
dd_stats.r.forSTD = std([dd(indToAvg).forRFactor]);


end