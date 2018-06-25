% Function to output stats files into a very helpful csv file
% should be correct for p type devices

function output_stats(fileName,stats_list)
len = length(stats_list);

out = zeros(len,18);

for i = 1:len
    % forward sweep first
   out(i,1) = stats_list(i).mob.forMean;
   out(i,2) = stats_list(i).mob.backMean;
   out(i,3) = stats_list(i).mob.forSTD;
   out(i,4) = stats_list(i).mob.backSTD;
   
   out(i,5) = stats_list(i).vt.forMean;
   out(i,6) = stats_list(i).vt.backMean;
   out(i,7) = stats_list(i).vt.forSTD;
   out(i,8) = stats_list(i).vt.backSTD;
   
   out(i,9) = stats_list(i).hyst.Mean;
   out(i,10) = stats_list(i).hyst.STD;
   
   out(i,11) = stats_list(i).curv.forMean;
   out(i,12) = stats_list(i).curv.backMean;
   out(i,13) = stats_list(i).curv.forSTD;
   out(i,14) = stats_list(i).curv.backSTD;
   
   out(i,15) = stats_list(i).r.forMean;
   out(i,16) = stats_list(i).r.backMean;
   out(i,17) = stats_list(i).r.forSTD;
   out(i,18) = stats_list(i).r.backSTD;
end

csvwrite(fileName,out);

end