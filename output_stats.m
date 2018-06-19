% Function to output stats files into a very helpful csv file
% should be correct for p type devices

function output_stats(fileName,stats_list)
len = length(stats_list);

out = zeros(18,len);

for i = 1:len
    % negative first becasue negative = forward sweep for p devices
   out(1,i) = stats_list(i).mob.negMean;
   out(2,i) = stats_list(i).mob.posMean;
   out(3,i) = stats_list(i).mob.negSTD;
   out(4,i) = stats_list(i).mob.posSTD;
   
   out(5,i) = stats_list(i).vt.negMean;
   out(6,i) = stats_list(i).vt.posMean;
   out(7,i) = stats_list(i).vt.negSTD;
   out(8,i) = stats_list(i).vt.posSTD;
   
   out(9,i) = stats_list(i).hyst.Mean;
   out(10,i) = stats_list(i).hyst.STD;
   
   out(11,i) = stats_list(i).curv.negMean;
   out(12,i) = stats_list(i).curv.posMean;
   out(13,i) = stats_list(i).curv.negSTD;
   out(14,i) = stats_list(i).curv.posSTD;
   
   out(15,i) = stats_list(i).r.negMean;
   out(16,i) = stats_list(i).r.posMean;
   out(17,i) = stats_list(i).r.negSTD;
   out(18,i) = stats_list(i).r.posSTD;
end

csvwrite(fileName,out);

end