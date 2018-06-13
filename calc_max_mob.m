function DD = calc_max_mob(folderPath,vg_limit)
% de = dielectric constant
% vg_limit = # of vg measurements that must be included in the mobility
% calculation

% Build directory of txt files
ad=pwd;
cd(folderPath)
DD=dir('*.iv');
cd(ad);

for i =1:length(DD)
    DD(i).path= fullfile(folderPath, DD(i).name);
end

% Map channel lengths and positions to directory and calculate mobilities
MM = zeros(9,9);
VT_mat = zeros(9,9);

% below in um
L_vec = [1,2,5,10,20,25,50,80,100];
W_vec = [400,400,400,500,500,800,800,1000,1000];
d_gate = 200E-9;
DE = 3.9; % Dielectric constant of SiO2

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

% capacitance in F/cm^2
cap = DE * 8.854e-12 / d_gate / (100^2);

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
    vgsize = size(DD(i).vg);
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
    
    DD(i).posMaxMob = 0;
    for j = 1:2:(length(DD(i).posSweep_vg{:,1})-vg_limit+1)
        vgRange = DD(i).posSweep_vg{j:(j+vg_limit-1),1};
        idRange = DD(i).posSweep_id{j:(j+vg_limit-1),1};
        [mob, vt, mfun] = fitSatMob(vgRange, idRange, cap, DD(i).ChanWid, DD(i).ChanLen);
        if mob > DD(i).posMaxMob
            DD(i).posMaxMob = mob;
            DD(i).posVt = vt;
            DD(i).posFun = mfun;
            DD(i).posRange = [j (j+vg_limit-1)];
        end
    end
    
    DD(i).negMaxMob = 0;
    for j = 1:2:(length(DD(i).negSweep_vg{:,1})-vg_limit+1)
        vgRange = DD(i).negSweep_vg{j:(j+vg_limit-1),1};
        idRange = DD(i).negSweep_id{j:(j+vg_limit-1),1};
        [mob, vt, mfun] = fitSatMob(vgRange, idRange, cap, DD(i).ChanWid, DD(i).ChanLen);
        if mob > DD(i).negMaxMob
            DD(i).negMaxMob = mob;
            DD(i).negVt = vt;
            DD(i).negFun = mfun;
            DD(i).negRange = [j (j+vg_limit-1)];
        end
    end

end
plot_tcurve_fit_special(DD,25,'p')

end



function [Mobility,VT,mfun] = fitSatMob(VGRange,IDRange,Cap,W,L)

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

function [ax, ax2] = plot_tcurve_fit_special(dd,devNums,type)
%type = 'p' or 'n' based on the device type

if abs(dd(devNums).posVt) > 1000
    fprintf('SD Short - Cannot plot for dev #%i \n',devNums);
elseif abs(dd(devNums).negVt) > 1000
    fprintf('SD Short - Cannot plot for dev #%i \n',devNums);
else
    f=figure;
    ax=gca;
    hold(ax,'on')
    
    for d = devNums
        
        posfit = dd(d).posFun;
        negfit = dd(d).negFun;
        
        vg = dd(d).vg{:,1};
        id = dd(d).id{:,1};
        
        ax2 = plotyy(vg,sqrt(abs(id)),vg,abs(id),'plot','semilogy');
        if type == 'n'
            fplot(ax,@(x) sqrt(-posfit(x)),[dd(d).posVt,max(vg)],'--k','LineWidth',1);
            fplot(ax,@(x) sqrt(-negfit(x)),[dd(d).negVt,max(vg)],'--k','LineWidth',1);
        elseif type == 'p'
            fplot(ax,@(x) sqrt(-posfit(x)),[min(vg),dd(d).posVt],'--k','LineWidth',1);
            fplot(ax,@(x) sqrt(-negfit(x)),[min(vg),dd(d).negVt],'--k','LineWidth',1);
        end
    end
    
    ax.FontSize = 14;
    ax.Box = 'on';
    ax.LineWidth = 1;
    f.Position = [770 355 700 500];
    ax.Position = [0.15 0.15 0.7 0.8];
    
    xlabel('Gate Voltage (Volts)')
    ylabel(ax2(1),'(Drain Current)^{1/2} (A^{1/2})')
    ylabel(ax2(2),'Drain Current (A)')
    
    lin_bounds = [0, round(max(sqrt(abs(id)))*1.1,2,'significant')];
    log_bounds = [10^floor(log10(min(abs(id)))), 10^ceil(log10(max(abs(id))))];
    %disp(log_bounds)
    set(ax2(1),'YLim',lin_bounds);
    set(ax2(1),'ytick',linspace(lin_bounds(1),lin_bounds(2),5));
    set(ax2(2),'YLim',log_bounds);
    if min(abs(id))==0
        set(ax2(2),'ytick',10.^(floor(log10(min(abs(id))+1E-10)):ceil(log10(max(abs(id))))));
    else
        set(ax2(2),'ytick',10.^(floor(log10(min(abs(id)))):ceil(log10(max(abs(id))))));
    end
    ytl = {};
    for i = 1:length(ax2(2).YTick)
        ytl{i} = num2str(ax2(2).YTick(i));
    end
    set(ax2(2),'yticklabels',ytl);
    set(ax2(2),'FontSize',14);
    set(ax2(2),'LineWidth',1);
    ax.Children(2).LineWidth=1;
    ax2(2).Children(1).LineWidth=1;
end

end
