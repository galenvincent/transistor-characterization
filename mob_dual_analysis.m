% function to analyze how to mobility changes over the course of a full
% transfer curve, and how the threshold voltage changes with it

function DD = mob_dual_analysis(folderPath,vg_limit)

%% Enter constants
ad=pwd;
cd(folderPath)
DD=dir('*.iv');
cd(ad);

% below is in um
L_vec = [1,2,5,10,20,25,50,80,100]; % Vector of channel lengths
W_vec = [400,400,400,500,500,800,800,1000,1000]; % Vector of channel widths
d_gate = 200E-9; % Thickness of the gate
DE = 3.9; % Dielectric constant of SiO2
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

%% Upload data from file into struct & Break into positive and negative sweeps
for i =1:length(DD)
    DD(i).path= fullfile(folderPath, DD(i).name);
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
    
    if start == 1
        DD(i).posSweep_vg = ivtable(1:index,end-1);
        DD(i).negSweep_vg = ivtable(index:end,end-1);
        DD(i).posSweep_id = ivtable(1:index,end-4);
        DD(i).negSweep_id = ivtable(index:end,end-4);
    elseif start == -1
        DD(i).negSweep_vg = ivtable(1:index,end-1);
        DD(i).posSweep_vg = ivtable(index:end,end-1);
        DD(i).negSweep_id = ivtable(1:index,end-4);
        DD(i).posSweep_id = ivtable(index:end,end-4);
    end
end

%% Calculate Mobility Sweep & Maximum Mobility
nchan = length(DD);
for i = 1:nchan    
    
    % Search for when the drain current goes negative, as an indication that we
    % have left the region of interest for mobility calculations
    pos_diff = diff(table2array(DD(i).posSweep_id));
    neg_diff = diff(table2array(DD(i).negSweep_id));
    
    for j = 1:length(pos_diff)
        if (pos_diff(j) > 0 || DD(i).posSweep_id{j,1} < 0) && j > vg_limit
            pos_stop = j;
            break
        end
    end
    for j = length(neg_diff):-1:1
        if (neg_diff(j) < 0 || DD(i).negSweep_id{j,1} < 0) && (length(neg_diff)-j) > vg_limit
            neg_stop = j;
            break
        end
    end
    
    pos_loop_stop = pos_stop-vg_limit+1;
    neg_loop_stop = neg_stop+vg_limit-1;
    
    %Set up matrices to hold sweep values
    DD(i).posMobSweep = zeros(pos_loop_stop,1);
    DD(i).posVtSweep = zeros(pos_loop_stop,1);
    
    % Set the search values to zero to start
    DD(i).posMaxMob = 0;
    
    for j = 1:pos_loop_stop
        vgRange = DD(i).posSweep_vg{j:(j+vg_limit-1),1};
        idRange = DD(i).posSweep_id{j:(j+vg_limit-1),1};
        [mob, vt, mfun, M] = fitSatMob(vgRange, idRange, cap, DD(i).ChanWid, DD(i).ChanLen);
        DD(i).posMobSweep(j) = mob;
        DD(i).posVtSweep(j) = vt;
        if mob > DD(i).posMaxMob
            DD(i).posMaxMob = mob;
            DD(i).posVt = vt;
            DD(i).posFun = mfun;
            DD(i).posM = M;
        end
    end
    
    DD(i).negMobSweep = zeros(length(length(DD(i).negSweep_vg{:,1}):-1:neg_loop_stop),1);
    DD(i).negVtSweep = zeros(length(length(DD(i).negSweep_vg{:,1}):-1:neg_loop_stop),1);
    
    DD(i).negMaxMob = 0;
    
    index = 1;
    for j = length(DD(i).negSweep_vg{:,1}):-1:neg_loop_stop
        vgRange = DD(i).negSweep_vg{j:-1:(j-vg_limit+1),1};
        idRange = DD(i).negSweep_id{j:-1:(j-vg_limit+1),1};
        [mob, vt, mfun, M] = fitSatMob(vgRange, idRange, cap, DD(i).ChanWid, DD(i).ChanLen);
        DD(i).negMobSweep(index) = mob;
        DD(i).negVtSweep(index) = vt;
        index = index + 1;
        if mob > DD(i).negMaxMob
            DD(i).negMaxMob = mob;
            DD(i).negVt = vt;
            DD(i).negFun = mfun;
            DD(i).negM = M;
        end
    end
end

%% Calculate Curve Factor for each channel
for i = 1:nchan
    pos_ideal_area = DD(i).posMaxMob*length(DD(i).posMobSweep);
    neg_ideal_area = DD(i).negMaxMob*length(DD(i).negMobSweep);
    
    pos_area = sum(DD(i).posMobSweep);
    neg_area = sum(DD(i).negMobSweep);
    
    DD(i).posCurveFactor = pos_area/pos_ideal_area;
    DD(i).negCurveFactor = neg_area/neg_ideal_area; 
end

%% Calculate the Hysterisis factor for each channel
DD = calc_hysterisis(DD);

%% Calculate the r factor (Hyun Ho Choi paper)
for i = 1:nchan
    vgmax = DD(i).negSweep_vg{end,1};
    idmax = DD(i).negSweep_id{end,1};
    
    for j = 1:length(DD(i).negSweep_vg{:,1})
        if DD(i).negSweep_vg{j,1} == 0
            neg_zero_ind = j;
            break
        end
    end
    for j = 1:length(DD(i).posSweep_vg{:,1})
        if DD(i).posSweep_vg{j,1} == 0
            pos_zero_ind = j;
            break
        end
    end
    
    pos_id_0 = abs(DD(i).posSweep_id{pos_zero_ind,1});
    neg_id_0 = abs(DD(i).negSweep_id{neg_zero_ind,1});
    
    DD(i).posRFactor=(((sqrt(idmax)-sqrt(pos_id_0))/vgmax)^2)/(DD(i).posM^2);
    DD(i).negRFactor=(((sqrt(idmax)-sqrt(neg_id_0))/vgmax)^2)/(DD(i).negM^2);  
end

end

% Next... create the perfect data set and see what happens.
% Also, think about differentiating between the right curvature and left
% curvature of the transfer curve

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
