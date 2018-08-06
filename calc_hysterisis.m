% Galen Vincent - Summer 2018
% Calculate the hysteresis factor for each channel in a chip

% Hysteresis factor is the ratio of areas between the forward and reverse
% sweep sqrt transfer curves (ratio of small area/big area).

function dd = calc_hysterisis(dd)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%dd is the output from the calc_dual_max_mob function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nchan = length(dd);

% Sweep the chip, calculating hysteresis factor for each channel
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
    
    dd(i).hystFactor = area_ratio;
end

end
