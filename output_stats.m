% Function to output stats files into a very helpful csv file
% should be correct for p type devices

function output_stats(fileName,stats_list)
len = length(stats_list);

out = zeros(18,len);

for i = 1:len
    % forward sweep first
   out(1,i) = stats_list(i).mob.forMean;
   out(2,i) = stats_list(i).mob.backMean;
   out(3,i) = stats_list(i).mob.forSTD;
   out(4,i) = stats_list(i).mob.backSTD;
   
   out(5,i) = stats_list(i).vt.forMean;
   out(6,i) = stats_list(i).vt.backMean;
   out(7,i) = stats_list(i).vt.forSTD;
   out(8,i) = stats_list(i).vt.backSTD;
   
   out(9,i) = stats_list(i).hyst.Mean;
   out(10,i) = stats_list(i).hyst.STD;
   
   out(11,i) = stats_list(i).curv.forMean;
   out(12,i) = stats_list(i).curv.backMean;
   out(13,i) = stats_list(i).curv.forSTD;
   out(14,i) = stats_list(i).curv.backSTD;
   
   out(15,i) = stats_list(i).r.forMean;
   out(16,i) = stats_list(i).r.backMean;
   out(17,i) = stats_list(i).r.forSTD;
   out(18,i) = stats_list(i).r.backSTD;
end

csvwrite(fileName,out);

end