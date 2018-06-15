% Function to average the important metrics from the analysis function

function [mob_stats, vt_stats, curv_stats, hyst_stats, r_stats] = calc_avg(dd)

mobility_map_dual(dd);
nchan = length(dd);

while true
    row = input('Enter row # (0 to exit): ');
    if row == 0
        break
    end
    
    col = input('Enter col #: ');
    
    for i = 1:nchan
        if dd(i).ChanCol == col && dd(i).ChanRow == row
            dd(i) = [];
            fprintf('Row %i col %i deleted. \n',row,col);
            break
        end
    end
end
close; close; close; close;

mobility_map_dual(dd);

mob_stats.posMean = mean([dd.posMaxMob]);
mob_stats.posSTD = std([dd.posMaxMob]);
mob_stats.negMean = mean([dd.negMaxMob]);
mob_stats.negSTD = std([dd.negMaxMob]);

vt_stats.posMean = mean([dd.posVt]);
vt_stats.posSTD = std([dd.posVt]);
vt_stats.negMean = mean([dd.negVt]);
vt_stats.negSTD = std([dd.negVt]);

curv_stats.posMean = mean([dd.posCurveFactor]);
curv_stats.posSTD = std([dd.posCurveFactor]);
curv_stats.negMean = mean([dd.negCurveFactor]);
curv_stats.negSTD = std([dd.negCurveFactor]);

hyst_stats.Mean = mean([dd.hystFactor]);
hyst_stats.STD = std([dd.hystFactor]);

r_stats.posMean = mean([dd.posRFactor]);
r_stats.posSTD = std([dd.posRFactor]);
r_stats.negMean = mean([dd.negRFactor]);
r_stats.negSTD = std([dd.negRFactor]);


end