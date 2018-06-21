% function to analyze how to mobility changes over the course of a full
% transfer curve, and how the threshold voltage changes with it

function DD = mob_dual_analysis(folderPath,vg_limit,chanType,semiType)

% chanType 1 = 180613gbv, 180619gbv1,2,3,4,5
% chanType 2 = 180606gbv1,4,5, 180619gbv6
% chanType 3 = 180606gbv2

% semiType is either 'p' or 'n'

%% Enter constants
ad=pwd;
cd(folderPath)
DD=dir('*.iv');
cd(ad);

% DE = 3.9; % Dielectric constant of SiO2
DE = 2.1;

% below is in um
switch chanType
    case 2
        L_vec = [1,2,5,10,20,25,50,80,100]; % Vector of channel lengths
        W_vec = [400,400,400,500,500,800,800,1000,1000]; % Vector of channel widths
        d_gate = 200E-9; %(180606gbv);
        
    case 3
        L_vec = [1,2,5,10,20,25,50,80,100]; % Vector of channel lengths
        W_vec = [1000,1000,1000,1000,1000,1000,1000,1000,1000]; % Vector of channel widths
        d_gate = 200E-9; %(180606gbv);
        
    case 1
        L_vec = [1,5,5,10,20,25,50,80,100]; % Vector of channel lengths
        W_vec = [1000,1000,1000,1000,1000,1000,1000,1000,1000]; % Vector of channel widths
        d_gate = 57E-9; %(180613gbv);
        
    case 4
        L_vec = fliplr([50,100,50,100,50,100,50,100]);
        W_vec = [1000,1000,1000,1000,1000,1000,1000,1000,1000]; % Vector of channel widths
        d_gate = 650E-9; %(180613gbv);
        
    otherwise
        print('Enter valid type');
end

cap = DE * 8.854e-12 / d_gate / (100^2); % capacitance w/ correct units

L2N = struct('A',1,...
    'B',2,...
    'C',3,...
    'D',4,...
    'E',5,...
    'F',6,...
    'G',7,...
    'H',8,...
    'J',9,...
    'K',1,...
    'L',2,...
    'M',3,...
    'N',4,...
    'P',5,...
    'Q',6,...
    'R',7,...
    'S',8,...
    'T',9);

%% Upload data from file into struct & Break into forward and backward sweeps
for i =1:length(DD)
    DD(i).path= fullfile(folderPath, DD(i).name);
    DD(i).semiType = semiType;
end

for i = 1:length(DD)
    
    DD(i).ChanRow = str2num(DD(i).name(end-3));
    DD(i).ChanLetter = DD(i).name(end-4);
    DD(i).ChanCol = L2N.(DD(i).ChanLetter); % This is a wizard-level MATLAB trick to get around the lack of dictionaries
    DD(i).ChanLen = L_vec(DD(i).ChanRow)*1E-6;% ^Nils is a wizard
    DD(i).ChanWid = W_vec(DD(i).ChanCol)*1E-6;
    
    ivtable = readtable(DD(i).path,'filetype','text');
    DD(i).vg = ivtable(:,end-1);
    DD(i).id = ivtable(:,end-4);
    % Split the data into forward and backward sweep
    vgdiff = diff(table2array(DD(i).vg));
    start = sign(vgdiff(1));
    current = start;
    index = 1;
    while current == start;
        index = index + 1;
        current = sign(vgdiff(index));
    end
    
    if (start == 1 && semiType == 'p') || (start == -1 && semiType == 'n')
        DD(i).backward_vg = ivtable(1:index,end-1);
        DD(i).forward_vg = ivtable(index:end,end-1);
        DD(i).backward_id = ivtable(1:index,end-4);
        DD(i).forward_id = ivtable(index:end,end-4);
        
    elseif (start == 1 && semiType == 'n') || (start == -1 && semiType == 'p')
        DD(i).forward_vg = ivtable(1:index,end-1);
        DD(i).backward_vg = ivtable(index:end,end-1);
        DD(i).forward_id = ivtable(1:index,end-4);
        DD(i).backward_id = ivtable(index:end,end-4);
    end
end

%% Calculate Mobility Sweep & Maximum Mobility
nchan = length(DD);
for i = 1:nchan    
    
    % Search for when the drain current goes negative, as an indication that we
    % have left the region of interest for mobility calculations
    back_diff = diff(table2array(DD(i).backward_id));
    for_diff = diff(table2array(DD(i).forward_id));
    for_sign = sign(for_diff(end));
    back_sign = sign(back_diff(1));
    current_sign = sign(DD(i).forward_id{round(height(DD(i).forward_id)/2),1});
    
    for j = 1:length(back_diff)
        if ((sign(back_diff(j)) ~= back_sign) || (sign(DD(i).backward_id{j,1}) ~= current_sign)) && (j > vg_limit)
            back_stop = j;
            break
        end
    end
    for j = length(for_diff):-1:1
        if ((sign(for_diff(j)) ~= for_sign) || (sign(DD(i).forward_id{j,1}) ~= current_sign)) && (length(for_diff)-j) > vg_limit
            for_stop = j;
            break
        end
    end
    
    back_loop_stop = back_stop-vg_limit+1;
    for_loop_stop = for_stop+vg_limit-1;
    
    %Set up matrices to hold sweep values
    DD(i).backMobSweep = zeros(back_loop_stop,1);
    DD(i).backVtSweep = zeros(back_loop_stop,1);
    
    % Set the search values to zero to start
    DD(i).backMaxMob = 0;
    
    for j = 1:back_loop_stop
        vgRange = DD(i).backward_vg{j:(j+vg_limit-1),1};
        idRange = DD(i).backward_id{j:(j+vg_limit-1),1};
        [mob, vt, mfun, M] = fitSatMob(vgRange, idRange, cap, DD(i).ChanWid, DD(i).ChanLen);
        DD(i).backMobSweep(j) = mob;
        DD(i).backVtSweep(j) = vt;
        if mob > DD(i).backMaxMob
            DD(i).backMaxMob = mob;
            DD(i).backVt = vt;
            DD(i).backFun = mfun;
            DD(i).backM = M;
        end
    end
    
    DD(i).forMobSweep = zeros(length(length(DD(i).forward_vg{:,1}):-1:for_loop_stop),1);
    DD(i).forVtSweep = zeros(length(length(DD(i).forward_vg{:,1}):-1:for_loop_stop),1);
    
    DD(i).forMaxMob = 0;
    
    index = 1;
    for j = length(DD(i).forward_vg{:,1}):-1:for_loop_stop
        vgRange = DD(i).forward_vg{j:-1:(j-vg_limit+1),1};
        idRange = DD(i).forward_id{j:-1:(j-vg_limit+1),1};
        [mob, vt, mfun, M] = fitSatMob(vgRange, idRange, cap, DD(i).ChanWid, DD(i).ChanLen);
        DD(i).forMobSweep(index) = mob;
        DD(i).forVtSweep(index) = vt;
        index = index + 1;
        if mob > DD(i).forMaxMob
            DD(i).forMaxMob = mob;
            DD(i).forVt = vt;
            DD(i).forFun = mfun;
            DD(i).forM = M;
        end
    end
end

%% Calculate Curve Factor for each channel
for i = 1:nchan
    back_ideal_area = DD(i).backMaxMob*length(DD(i).backMobSweep);
    for_ideal_area = DD(i).forMaxMob*length(DD(i).forMobSweep);
    
    back_area = sum(DD(i).backMobSweep);
    for_area = sum(DD(i).forMobSweep);
    
    DD(i).backCurveFactor = back_area/back_ideal_area;
    DD(i).forCurveFactor = for_area/for_ideal_area; 
end

%% Calculate the Hysterisis factor for each channel
DD = calc_hysterisis(DD);

%% Calculate the r factor (Hyun Ho Choi paper)
for i = 1:nchan
    vgmax = DD(i).forward_vg{end,1};
    idmax = DD(i).forward_id{end,1};
    
    for j = 1:length(DD(i).forward_vg{:,1})
        if DD(i).forward_vg{j,1} == 0
            for_zero_ind = j;
            break
        end
    end
    for j = 1:length(DD(i).backward_vg{:,1})
        if DD(i).backward_vg{j,1} == 0
            back_zero_ind = j;
            break
        end
    end
    
    back_id_0 = abs(DD(i).backward_id{back_zero_ind,1});
    for_id_0 = abs(DD(i).forward_id{for_zero_ind,1});
    
    DD(i).backRFactor=(((sqrt(abs(idmax))-sqrt(back_id_0))/vgmax)^2)/(DD(i).backM^2);
    DD(i).forRFactor=(((sqrt(abs(idmax))-sqrt(for_id_0))/vgmax)^2)/(DD(i).forM^2);  
end

end

% Next... create the perfect data set and see what happens.

function [Mobility,VT,mfun,M] = fitSatMob(VGRange,IDRange,Cap,W,L)

Y= sqrt(abs(IDRange));
K = (W*Cap)/(2*L);
X = VGRange;
% disp(X')
% disp(Y')
reg = MultiPolyRegress(X,Y,1);
M = reg.Coefficients(2);
B = reg.Coefficients(1);
Mobility = M^2/K;
VT = -B/M;

mfun = @(x) -(x.*M + B).^2;

end
