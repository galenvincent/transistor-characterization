% Galen Vincent - Summer 2018 
% plots full transistor charachterization surface based on CASCADE data

% Need to set this to read in data for whatever chip number you want, given
% a folder (see the other code to do this)
ivtable = readtable('Z:\data\20180606gbv5\20180606gbv5_sep-42_S9.iv','filetype','text');

ivtablesize = size(ivtable);
% Find the number of sweeps in vd & number of sweeps in vg
nvdsweeps = ivtablesize(2)/6;
nvgsweeps = ceil(ivtablesize(1)/2);

% Get out Id matrix (two, becasue of hysteresis)
tosample = 4:6:ivtablesize(2);
id_up = ivtable{1:nvgsweeps,tosample};
id_down = ivtable{nvgsweeps:end,tosample};

% Get out vg matrices
tosample = 5:6:ivtablesize(2);
vg_up = ivtable{1:nvgsweeps,tosample};
vg_down = ivtable{nvgsweeps:end,tosample};

% Get out vd matrices
tosample = 3:6:ivtablesize(2);
vd_up = ivtable{1:nvgsweeps,tosample};
vd_down = ivtable{nvgsweeps:end,tosample};

%id needs to be positive
id_up = id_up .* -1;
id_down = id_down .* -1;

figure
ax = gca
surf(vd_up,vg_up,id_up)
set(ax,'Zscale','log')
ax.XLabel.String = 'V_d'
ax.YLabel.String = 'V_g'
ax.ZLabel.String = 'I_d'