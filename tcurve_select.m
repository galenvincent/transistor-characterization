function [dd, mob_stats, vt_stats] = tcurve_select(folderPath,type,chiptype,vg_lims)
% Loop through each of the mobiliy fits for each channel, decide if it is
% good or not, then find the average mobility for the good channels

% type is either 'n' or 'p'
% chiptype is either 1 or 2 - 1 is common width of 1000 um, 2 is increasing
% width by column

if exist('vg_lims')~=1
    vg_lims = [-20,20];
end

if type == 'n'
    disp('Come back later...');
elseif type == 'p'
    dd = mobility_map_p(folderPath,chiptype,vg_lims);
end

nchan = length(dd);
allgood = input('All good/Enter bad position/go through all (1/2/3): ');

switch allgood
    case 1
        for i = 1:nchan
            dd(i).good = 1;
        end
        
    case 2
        for i = 1:nchan
            dd(i).good = 1;
        end
        while true
            row = input('Enter row # (0 to exit): ');
            if row == 0
                break
            end
            
            col = input('Enter col #: ');
            
            for i = 1:nchan
                if dd(i).ChanCol == col && dd(i).ChanRow == row
                    dd(i).good = 0;
                    dd(i).mob = 0;
                    dd(i).vt = 0;
                    fprintf('Row %i col %i deleted. \n',row,col);
                    break
                end
            end
        end
        close; close;
        
        MM = zeros(9,9);
        VT_mat = zeros(9,9);
        for i = 1:nchan 
            MM(dd(i).ChanRow,dd(i).ChanCol) = dd(i).mob;
            VT_mat(dd(i).ChanRow,dd(i).ChanCol) = dd(i).vt;
        end
        
        mob_mat(MM,VT_mat);
        
        
    case 3
        for i = 1:nchan
            plot_tcurve_fit(dd,i,type);
            movegui('northwest')
            commandwindow;
            dd(i).good = input('good/bad (1/0): ');
            close
        end
        
    otherwise
        disp('Enter valid input')
end

mob = zeros(nchan,1);
vt = zeros(nchan,1);
tot = 0;
for i = 1:nchan
    if dd(i).good
        tot = tot + 1;
        mob(tot) = dd(i).mob;
        vt(tot) = dd(i).vt;
    end
end

vt_f = vt(1:tot);
mob_f = mob(1:tot);

mob_stats = [mean(mob_f) std(mob_f) tot];
vt_stats = [mean(vt_f) std(vt_f) tot];

        
%% Mobility map function
function mob_mat(MM,VT_mat)
% Generate Heat Map

max_mob = max(max(MM));
max_vt = max(max(VT_mat));

figure('Name','Mob')
ax=gca;
imagesc(MM,[0 max_mob]);

colorbar()
ax.YDir='reverse';
ax.Visible='off';
ax.FontSize=20;

VT_mat = abs(VT_mat);
figure('Name','abs(vt)')
ax2=gca;
imagesc(VT_mat,[0 max_vt]);

colorbar()
ax2.YDir='reverse';
ax2.Visible='off';
ax2.FontSize=20;


