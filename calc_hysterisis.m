% Calculate the degree that hysterisis is impacting the data by looking at
% the area between the forward and reverse sweep curves

%dd is the output from the calc_dual_max_mob function

function dd = calc_hysterisis(dd)

nchan = length(dd);

for i = 1:nchan
   vg_back = dd(i).backward_vg{:,1};
   vg_for = dd(i).forward_vg{:,1};
   id_back_sqrt = sqrt(abs(dd(i).backward_id{:,1}));
   id_for_sqrt = sqrt(abs(dd(i).forward_id{:,1}));

    for_area = abs(trapz(vg_for,id_for_sqrt));  
    back_area = abs(trapz(vg_back,id_back_sqrt));

    big_area = max([for_area back_area]);
    small_area = min([for_area back_area]);

    area_ratio = small_area/big_area;
    
    %area_diff = big_area-small_area;

    %perc_area_diff = area_diff/big_area;
    
    dd(i).hystFactor = area_ratio;
end

end
