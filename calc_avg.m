% Function to average the important metrics from the analysis function

function dd_stats = calc_avg(dd,rows)
% rows = vector holding the row numbers you would like to average
% rows = 0 in order to average the whole thing

dd = metric_map(dd);
close;
close;

nchan = length(dd);
indToAvgVert= [];
indToAvgHoriz = [];

if rows == 0
    rows = 1:9;
end

switch dd(1).chanType
    case 1
        for i = 1:nchan
            if ismember(dd(i).ChanRow,rows) && mod(dd(i).ChanCol,2) == 0
                indToAvgVert = [indToAvgVert,i];
            elseif ismember(dd(i).ChanRow,rows) && mod(dd(i).ChanCol,2) == 1
                indToAvgHoriz = [indToAvgHoriz,i];
            end
        end
    case {2,3,4}
        for i = 1:nchan 
           if ismember(dd(i).ChanRow,rows)
               indToAvgVert = [indToAvgVert,i];
           end
        end
end

switch dd(1).chanType
    case 1
        horizForMob = mean([dd(indToAvgHoriz).forMaxMob]);
        vertForMob = mean([dd(indToAvgVert).forMaxMob]);
        
        horizBackMob = mean([dd(indToAvgHoriz).backMaxMob]);
        vertBackMob =  mean([dd(indToAvgVert).backMaxMob]);
        
        forAni = vertForMob/horizForMob;
        backAni = vertBackMob/horizBackMob;
        
        for i = 1:nchan
            dd(i).chanType = 1;
            dd(i).anisotropyFor = forAni;
            dd(i).anisotropyBack = backAni;
        end
        
    case {2,3,4}
        for i = 1:nchan 
            dd(i).chanType = 2;
            dd(i).anisotropyFor = 0; % This is to indicate than all the channels are in the same direction. All values will be placed into the vertical data 
            dd(i).anisotropyBack = 0;
        end
end

 % Calculate means and standard deviation of the means
dd_stats.mob.backVertMean = mean([dd(indToAvgVert).backMaxMob]);
dd_stats.mob.backVertSTD = std([dd(indToAvgVert).backMaxMob])/sqrt(length(indToAvgVert));
dd_stats.mob.forVertMean = mean([dd(indToAvgVert).forMaxMob]);
dd_stats.mob.forVertSTD = std([dd(indToAvgVert).forMaxMob])/sqrt(length(indToAvgVert));

dd_stats.mob.backHorizMean = mean([dd(indToAvgHoriz).backMaxMob]);
dd_stats.mob.backHorizSTD = std([dd(indToAvgHoriz).backMaxMob])/sqrt(length(indToAvgHoriz));
dd_stats.mob.forHorizMean = mean([dd(indToAvgHoriz).forMaxMob]);
dd_stats.mob.forHorizSTD = std([dd(indToAvgHoriz).forMaxMob])/sqrt(length(indToAvgHoriz));
%
dd_stats.vt.backVertMean = mean([dd(indToAvgVert).backVt]);
dd_stats.vt.backVertSTD = std([dd(indToAvgVert).backVt])/sqrt(length(indToAvgVert));
dd_stats.vt.forVertMean = mean([dd(indToAvgVert).forVt]);
dd_stats.vt.forVertSTD = std([dd(indToAvgVert).forVt])/sqrt(length(indToAvgVert));

dd_stats.vt.backHorizMean = mean([dd(indToAvgHoriz).backVt]);
dd_stats.vt.backHorizSTD = std([dd(indToAvgHoriz).backVt])/sqrt(length(indToAvgHoriz));
dd_stats.vt.forHorizMean = mean([dd(indToAvgHoriz).forVt]);
dd_stats.vt.forHorizSTD = std([dd(indToAvgHoriz).forVt])/sqrt(length(indToAvgHoriz));
%
dd_stats.vtnorm.backVertMean = mean([dd(indToAvgVert).backVtFactor]);
dd_stats.vtnorm.backVertSTD = std([dd(indToAvgVert).backVtFactor])/sqrt(length(indToAvgVert));
dd_stats.vtnorm.forVertMean = mean([dd(indToAvgVert).forVtFactor]);
dd_stats.vtnorm.forVertSTD = std([dd(indToAvgVert).forVtFactor])/sqrt(length(indToAvgVert));

dd_stats.vtnorm.backHorizMean = mean([dd(indToAvgHoriz).backVtFactor]);
dd_stats.vtnorm.backHorizSTD = std([dd(indToAvgHoriz).backVtFactor])/sqrt(length(indToAvgHoriz));
dd_stats.vtnorm.forHorizMean = mean([dd(indToAvgHoriz).forVtFactor]);
dd_stats.vtnorm.forHorizSTD = std([dd(indToAvgHoriz).forVtFactor])/sqrt(length(indToAvgHoriz));
%
dd_stats.curv.backVertMean = mean([dd(indToAvgVert).backCurveFactor]);
dd_stats.curv.backVertSTD = std([dd(indToAvgVert).backCurveFactor])/sqrt(length(indToAvgVert));
dd_stats.curv.forVertMean = mean([dd(indToAvgVert).forCurveFactor]);
dd_stats.curv.forVertSTD = std([dd(indToAvgVert).forCurveFactor])/sqrt(length(indToAvgVert));

dd_stats.curv.backHorizMean = mean([dd(indToAvgHoriz).backCurveFactor]);
dd_stats.curv.backHorizSTD = std([dd(indToAvgHoriz).backCurveFactor])/sqrt(length(indToAvgHoriz));
dd_stats.curv.forHorizMean = mean([dd(indToAvgHoriz).forCurveFactor]);
dd_stats.curv.forHorizSTD = std([dd(indToAvgHoriz).forCurveFactor])/sqrt(length(indToAvgHoriz));
%
dd_stats.hyst.VertMean = mean([dd(indToAvgVert).hystFactor]);
dd_stats.hyst.VertSTD = std([dd(indToAvgVert).hystFactor])/sqrt(length(indToAvgVert));

dd_stats.hyst.HorizMean = mean([dd(indToAvgHoriz).hystFactor]);
dd_stats.hyst.HorizSTD = std([dd(indToAvgHoriz).hystFactor])/sqrt(length(indToAvgHoriz));
%
dd_stats.r.backVertMean = mean([dd(indToAvgVert).backRFactor]);
dd_stats.r.backVertSTD = std([dd(indToAvgVert).backRFactor])/sqrt(length(indToAvgVert));
dd_stats.r.forVertMean = mean([dd(indToAvgVert).forRFactor]);
dd_stats.r.forVertSTD = std([dd(indToAvgVert).forRFactor])/sqrt(length(indToAvgVert));

dd_stats.r.backHorizMean = mean([dd(indToAvgHoriz).backRFactor]);
dd_stats.r.backHorizSTD = std([dd(indToAvgHoriz).backRFactor])/sqrt(length(indToAvgHoriz));
dd_stats.r.forHorizMean = mean([dd(indToAvgHoriz).forRFactor]);
dd_stats.r.forHorizSTD = std([dd(indToAvgHoriz).forRFactor])/sqrt(length(indToAvgHoriz));

dd_stats.aniFor = dd(1).anisotropyFor;
dd_stats.aniBack = dd(1).anisotropyBack;


end