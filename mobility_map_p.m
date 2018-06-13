% Function to produce a mobility map for a full chip of channels

function [DD,ax] = mobility_map_p(folderPath,chiptype,vg_lims,max_mob)
% If chiptype = 2, this means you have the chip with increasing device width
% If chiptype = 1, then device width = 1000 um for the whole chip

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

DE = 3.9; % Dielectric constant of SiO2
if exist('vg_lims')~=1
    vg_lims = [-20,20];
end

L_vec = [1,2,5,10,20,25,50,80,100];

if chiptype == 2
    W_vec = [400,400,400,500,500,800,800,1000,1000];
else
    W_vec = [1000,1000,1000,1000,1000,1000,1000,1000,1000];
end

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

for i = 1:length(DD)
    
DD(i).ChanRow = str2num(DD(i).name(end-3));
DD(i).ChanLetter = DD(i).name(end-4);
DD(i).ChanCol = L2N.(DD(i).ChanLetter); % This is a wizard-level MATLAB trick to get around the lack of dictionaries
DD(i).ChanLen = L_vec(DD(i).ChanRow)*1E-6;
DD(i).ChanWid = W_vec(DD(i).ChanCol)*1E-6;

[mob, VT, vg_mat, id_mat, fit_fun] = calcMobIV_p(DD(i).path,200E-9,DD(i).ChanWid,DD(i).ChanLen,DE,vg_lims);

DD(i).mob=mob;
DD(i).vt=VT;
DD(i).vg=vg_mat;
DD(i).id=id_mat;
DD(i).fit_fun=fit_fun;

MM(DD(i).ChanRow,DD(i).ChanCol) = mob;
VT_mat(DD(i).ChanRow,DD(i).ChanCol) = VT;

end

% Check for colorbar scale

if exist('max_mob')~=1
    max_mob = max(max(MM));
end
max_vt = max(max(VT_mat));

% Generate Heat Map

figure('Name','Mob') 
ax=gca;
imagesc(MM,[0 max_mob]);

colorbar()
ax.YDir='reverse';
ax.Visible='off';
ax.FontSize=20;

VT_mat = abs(VT_mat);
max_vt = max(max(VT_mat));
figure('Name','abs(vt)')
ax2=gca;
imagesc(VT_mat,[0 max_vt]);

colorbar()
ax2.YDir='reverse';
ax2.Visible='off';
ax2.FontSize=20;