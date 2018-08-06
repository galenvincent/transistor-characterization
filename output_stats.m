% Galen Vincent - Summer 2018
% Function to output stats files into csv for copying into the DPP_database

function output_stats(fileName,stats_list)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% filename = the filepath + filename for the csv file you would like to
% output this data to

% stats_list = list of objects from calc_avg that you would like to output

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

len = length(stats_list);

out = zeros(len,46);

for i = 1:len
    %Mobility
    out(i,1) = stats_list(i).mob.forVertMean;
    out(i,2) = stats_list(i).mob.forVertSTD;
    out(i,3) = stats_list(i).mob.forHorizMean;
    out(i,4) = stats_list(i).mob.forHorizSTD;
    
    out(i,5) = stats_list(i).mob.backVertMean;
    out(i,6) = stats_list(i).mob.backVertSTD;
    out(i,7) = stats_list(i).mob.backHorizMean;
    out(i,8) = stats_list(i).mob.backHorizSTD;
    
    %Vt
    out(i,9) = stats_list(i).vt.forVertMean;
    out(i,10) = stats_list(i).vt.forVertSTD;
    out(i,11) = stats_list(i).vt.forHorizMean;
    out(i,12) = stats_list(i).vt.forHorizSTD;
    
    out(i,13) = stats_list(i).vt.backVertMean;
    out(i,14) = stats_list(i).vt.backVertSTD;
    out(i,15) = stats_list(i).vt.backHorizMean;
    out(i,16) = stats_list(i).vt.backHorizSTD;
    
    %VtNorm
    out(i,17) = stats_list(i).vtnorm.forVertMean;
    out(i,18) = stats_list(i).vtnorm.forVertSTD;
    out(i,19) = stats_list(i).vtnorm.forHorizMean;
    out(i,20) = stats_list(i).vtnorm.forHorizSTD;
    
    out(i,21) = stats_list(i).vtnorm.backVertMean;
    out(i,22) = stats_list(i).vtnorm.backVertSTD;
    out(i,23) = stats_list(i).vtnorm.backHorizMean;
    out(i,24) = stats_list(i).vtnorm.backHorizSTD;
    
    %Hyst
    out(i,25) = stats_list(i).hyst.VertMean;
    out(i,26) = stats_list(i).hyst.VertSTD;
    
    out(i,27) = stats_list(i).hyst.HorizMean;
    out(i,28) = stats_list(i).hyst.HorizSTD;
    
    %Curve
    out(i,29) = stats_list(i).curv.forVertMean;
    out(i,30) = stats_list(i).curv.forVertSTD;
    out(i,31) = stats_list(i).curv.forHorizMean;
    out(i,32) = stats_list(i).curv.forHorizSTD;
    
    out(i,33) = stats_list(i).curv.backVertMean;
    out(i,34) = stats_list(i).curv.backVertSTD;
    out(i,35) = stats_list(i).curv.backHorizMean;
    out(i,36) = stats_list(i).curv.backHorizSTD;
    
    %R
    out(i,37) = stats_list(i).r.forVertMean;
    out(i,38) = stats_list(i).r.forVertSTD;
    out(i,39) = stats_list(i).r.forHorizMean;
    out(i,40) = stats_list(i).r.forHorizSTD;
    
    out(i,41) = stats_list(i).r.backVertMean;
    out(i,42) = stats_list(i).r.backVertSTD;
    out(i,43) = stats_list(i).r.backHorizMean;
    out(i,44) = stats_list(i).r.backHorizSTD;
    
    %Anisotropy
    out(i,45) = stats_list(i).aniFor;
    out(i,46) = stats_list(i).aniBack;
end

csvwrite(fileName,out);

end