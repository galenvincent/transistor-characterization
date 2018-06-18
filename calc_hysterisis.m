% Calculate the degree that hysterisis is impacting the data by looking at
% the area between the forward and reverse sweep curves

%dd is the output from the calc_dual_max_mob function

function dd = calc_hysterisis(dd)

nchan = length(dd);

for i = 1:nchan
   vg_pos = dd(i).posSweep_vg{:,1};
   vg_neg = dd(i).negSweep_vg{:,1};
   id_pos_sqrt = sqrt(abs(dd(i).posSweep_id{:,1}));
   id_neg_sqrt = sqrt(abs(dd(i).negSweep_id{:,1}));

    neg_area = abs(trapz(vg_neg,id_neg_sqrt));  
    pos_area = abs(trapz(vg_pos,id_pos_sqrt));

    big_area = max([neg_area pos_area]);
    small_area = min([neg_area pos_area]);

    area_ratio = small_area/big_area;
    
    %area_diff = big_area-small_area;

    %perc_area_diff = area_diff/big_area;
    
    dd(i).hystFactor = area_ratio;
end

end
