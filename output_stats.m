% Function to output stats files into a very helpful csv file
% should be correct for p type devices

function output_stats(fileName,stats_list)
len = length(stats_list);

out = zeros(len,38);

for i = 1:len
    % forward sweep first
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
    %Hyst
    out(i,17) = stats_list(i).hyst.VertMean;
    out(i,18) = stats_list(i).hyst.VertSTD;
    
    out(i,19) = stats_list(i).hyst.HorizMean;
    out(i,20) = stats_list(i).hyst.HorizSTD;
    %Curve
    out(i,21) = stats_list(i).curv.forVertMean;
    out(i,22) = stats_list(i).curv.forVertSTD;
    out(i,23) = stats_list(i).curv.forHorizMean;
    out(i,24) = stats_list(i).curv.forHorizSTD;
    
    out(i,25) = stats_list(i).curv.backVertMean;
    out(i,26) = stats_list(i).curv.backVertSTD;
    out(i,27) = stats_list(i).curv.backHorizMean;
    out(i,28) = stats_list(i).curv.backHorizSTD;
    %R
    out(i,29) = stats_list(i).r.forVertMean;
    out(i,30) = stats_list(i).r.forVertSTD;
    out(i,31) = stats_list(i).r.forHorizMean;
    out(i,32) = stats_list(i).r.forHorizSTD;
    
    out(i,33) = stats_list(i).r.backVertMean;
    out(i,34) = stats_list(i).r.backVertSTD;
    out(i,35) = stats_list(i).r.backHorizMean;
    out(i,36) = stats_list(i).r.backHorizSTD;
    %Ani
    out(i,37) = stats_list(i).aniFor;
    out(i,38) = stats_list(i).aniBack;
end

csvwrite(fileName,out);

end