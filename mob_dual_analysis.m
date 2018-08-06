% Nils Persson
% Additions by Galen Vincent - Summer 2018

% Function to analyze the maximum mobility, threshold voltage, curvature,
% hysterisis, and r factor for either p or n type transistors based on
% transfer curve data from the CASCADE machine.

function DD = mob_dual_analysis(folderPath,vg_limit,chanType,semiType)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% folderpath = path to the folder with the transfer curve data from the cascade

% vg_limit = the number of data points to use in each mobility calculation

% chanType = Changes based on chip type
    %1 = 180613gbv, 180619gbv1,2,3,4,5, 180625gbv, 180627gbv, 180702gbv
    %2 = 180606gbv1,4,5, 180619gbv6??(check)
    %3 = 180606gbv2, 180710gbv, 180717gbv
    %4 = Nils' data
    
%semiType = either 'p' or 'n' based on the semiconducting material

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Enter constants
ad=pwd;
cd(folderPath)
DD=dir('*.iv');
cd(ad);

% below is in um
switch chanType
    case 1
        L_vec = [1,5,5,10,20,25,50,80,100]; % Vector of channel lengths
        W_vec = [1000,1000,1000,1000,1000,1000,1000,1000,1000]; % Vector of channel widths
        d_gate = 57E-9;
        DE = 3.9;%SiO2
        for i = 1:length(DD)
            DD(i).chanType = 1;
        end
        
    case 2
        L_vec = [1,2,5,10,20,25,50,80,100]; % Vector of channel lengths
        W_vec = [400,400,400,500,500,800,800,1000,1000]; % Vector of channel widths
        d_gate = 200E-9;
        DE = 3.9; %SiO2
        for i = 1:length(DD)
            DD(i).chanType = 2;
        end
        
    case 3
        L_vec = [1,2,5,10,20,25,50,80,100]; % Vector of channel lengths
        W_vec = [1000,1000,1000,1000,1000,1000,1000,1000,1000]; % Vector of channel widths
        d_gate = 200E-9;
        DE = 3.9; %SiO2
        for i = 1:length(DD)
            DD(i).chanType = 3;
        end
        
    case 4
        L_vec = fliplr([50,100,50,100,50,100,50,100]);
        W_vec = [1000,1000,1000,1000,1000,1000,1000,1000,1000]; % Vector of channel widths
        d_gate = 650E-9;
        DE = 2.1; %Whatever Nils used
        for i = 1:length(DD)
            DD(i).chanType = 4;
        end
        
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

% Sweep through chip finding sweep directions for each channel
for i = 1:length(DD)
    
    DD(i).ChanRow = str2num(DD(i).name(end-3));
    DD(i).ChanLetter = DD(i).name(end-4);
    DD(i).ChanCol = L2N.(DD(i).ChanLetter); % This is a wizard-level MATLAB trick to get around the lack of dictionaries
    DD(i).ChanLen = L_vec(DD(i).ChanRow)*1E-6;% ^Nils is a wizard
    DD(i).ChanWid = W_vec(DD(i).ChanCol)*1E-6;
    
    ivtable = readtable(DD(i).path,'filetype','text');
    DD(i).vg = ivtable(:,end-1); % Note that these are from the last Vd sweep, whatever voltage that happened to be at
    DD(i).id = ivtable(:,end-4);
    
    % Split the data into forward and backward sweep
    vgdiff = diff(table2array(DD(i).vg)); % Difference between vg values
    start = sign(vgdiff(1)); % starting sweep direction
    current = start; % current sweep direction
    index = 1; % which vg index are we on
    
    while current == start; % count up until the sweep direction changes
        index = index + 1;
        current = sign(vgdiff(index)); %
    end
    
    % Sort which half of the sweep goes where based on starting sweep
    % direction and semiconductor type
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

% For each channel
for i = 1:nchan
    % Search for when the drain current goes negative, or when drain
    % current begins to increase as an indication that we have left the
    % region of interest for mobility calculations
    
    back_diff = diff(table2array(DD(i).backward_id));
    for_diff = diff(table2array(DD(i).forward_id));
    for_sign = sign(for_diff(end));
    back_sign = sign(back_diff(1));
    
    if semiType == 'n'
        current_sign = -1;
    elseif semiType == 'p'
        current_sign = 1;
    end
    
    % if nothing happens, these will hold and indicate error
    for_stop = -1;
    back_stop = -1;
    
    % Sweep through current data looking for where to stop
    % Need to at least make it to one vg_limit worth of data
    
    % backward sweep
    for j = 1:length(back_diff)
        if ((sign(back_diff(j)) ~= back_sign) || (sign(DD(i).backward_id{j,1}) ~= current_sign)) && (j > vg_limit)
            back_stop = j;
            break
        end
    end
    
    %forward sweep
    for j = length(for_diff):-1:1
        if ((sign(for_diff(j)) ~= for_sign) || (sign(DD(i).forward_id{j,1}) ~= current_sign)) && (length(for_diff)-j) > vg_limit
            for_stop = j;
            break
        end
    end
    
    % if there were no stopping points, set up the data to get thrown out
    % by metric_map function
    if for_stop == -1 || back_stop == -1
        DD(i).backMaxMob = 0;
        DD(i).backVt = 1000;
        DD(i).backM = 0;
        DD(i).forMaxMob = 0;
        DD(i).forVt = 1000;
        DD(i).forM = 0;
        DD(i).backMobSweep = 0;
        DD(i).forMobSweep = 0;
        continue
    end
    
    
    % Begin the mobility sweeping calculations
    back_loop_stop = back_stop-vg_limit+1;
    for_loop_stop = for_stop+vg_limit-1;
    
    %Set up matrices to hold sweep values
    DD(i).backMobSweep = zeros(back_loop_stop,1);
    DD(i).backVtSweep = zeros(back_loop_stop,1);
    
    % Set the search values to zero to start
    DD(i).backMaxMob = 0;
    
    % backward mobility sweep
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
    
    %Set up matrices to hold sweep values
    DD(i).forMobSweep = zeros(length(length(DD(i).forward_vg{:,1}):-1:for_loop_stop),1);
    DD(i).forVtSweep = zeros(length(length(DD(i).forward_vg{:,1}):-1:for_loop_stop),1);
    
    % Set the search values to zero to start
    DD(i).forMaxMob = 0;
    
    % forward mobility sweep
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

%% Calculate normalized vt for each channel
% This normalizes vt so that sweeps for different chip types, with
% different thicknesses of silicon, can be compared on more even footing

% Find the maximum vg value of the transfer curve data
switch semiType
    case 'p'
        vgmax = min(table2array(DD(1).vg));
    case 'n'
        vgmax = max(table2array(DD(1).vg));
end

% normalized vt is the ratio of vt to max vg
for i = 1:nchan
    DD(i).forVtFactor = abs(DD(i).forVt/vgmax);
    DD(i).backVtFactor = abs(DD(i).backVt/vgmax);
end

%% Calculate Curve Factor for each channel
% curve factor is a measure of the gate-bias-dependent mobility

% it is essentially a ratio of the sum of the mobility sweep performed
% (the actual data) to the maximum mobility summer as if it were found at
% each mobility sweep location (the ideal case).

for i = 1:nchan
    back_ideal_area = DD(i).backMaxMob*length(DD(i).backMobSweep); % Ideal case
    for_ideal_area = DD(i).forMaxMob*length(DD(i).forMobSweep); % Ideal case
    
    back_area = sum(DD(i).backMobSweep); % Actual data
    for_area = sum(DD(i).forMobSweep); % Actual data
    
    DD(i).backCurveFactor = back_area/back_ideal_area;
    DD(i).forCurveFactor = for_area/for_ideal_area;
end

%% Calculate the Hysterisis factor for each channel
DD = calc_hysterisis(DD);

%% Calculate the r factor (Hyun Ho Choi paper)
% this isn't paticularly useful information. It is essentially a
% combination of curvature and threshold voltage.


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

% Helper function to calculate mobility based on a set of voltage and current data
function [Mobility,VT,mfun,M] = fitSatMob(VGRange,IDRange,Cap,W,L)

Y= sqrt(abs(IDRange));
K = (W*Cap)/(2*L);
X = VGRange;
reg = MultiPolyRegress(X,Y,1);
M = reg.Coefficients(2);
B = reg.Coefficients(1);
Mobility = M^2/K;
VT = -B/M;

mfun = @(x) -(x.*M + B).^2;

end
