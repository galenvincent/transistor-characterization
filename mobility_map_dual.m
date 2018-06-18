% Function to create mobility maps for both the postive and negative
% direction voltage sweeps. Based on the output from the
% calc_dual_max_mob() function
function mobility_map_dual(dd)
mobility_map_help(dd);
nchan = length(dd);
numdeleted = 0;

while true
    row = input('Enter row # (1 to re-plot, 0 to exit): ');
    if row == 0
        break
    end
    if row == 1
       close;
       mobility_map_help(dd);
       continue
    end
    
    col = input('Enter col #: ');
    
    for i = 1:(nchan-numdeleted)
        if dd(i).ChanCol == col && dd(i).ChanRow == row
            dd(i) = [];
            fprintf('Row %i col %i deleted. \n',row,col);
            numdeleted = numdeleted + 1;
            break
        end
    end
end


end


function [ax, ax1, ax2, ax3] = mobility_map_help(dd)

nchan = length(dd);
MMpos = zeros(9,9);
VTpos = zeros(9,9);
MMneg = zeros(9,9);
VTneg = zeros(9,9);

for i = 1:nchan 
    MMpos(dd(i).ChanRow,dd(i).ChanCol) = dd(i).posMaxMob;
    VTpos(dd(i).ChanRow,dd(i).ChanCol) = dd(i).posVt;
    MMneg(dd(i).ChanRow,dd(i).ChanCol) = dd(i).negMaxMob;
    VTneg(dd(i).ChanRow,dd(i).ChanCol) = dd(i).negVt;
end

max_mob_pos = max(max(MMpos));
max_mob_neg = max(max(MMneg));
max_vt_pos = max(max(VTpos));
max_vt_neg = max(max(VTneg));
min_vt_pos = min(min(VTpos));
min_vt_neg = min(min(VTneg));

% Check if chip columns are A-J or K-T
if isempty(strfind('ABCDEFGHIJ',dd(1).ChanLetter))
    xticks = 1:9;
    xlabels = {'K','L','M','N','P','Q','R','S','T'};
else
    xticks = 1:9;
    xlabels = {'A','B','C','D','E','F','G','H','J'};
end


% Generate Heat Map
figure('Name','Mobility Map','position', [0, 250, 800, 650])
subplot(2,2,1)
imagesc(MMpos,[0 max_mob_pos]);
  ax = gca;
  set(ax, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');

colorbar()
ax.YDir='reverse';
ax.Title.String = 'Mobility - Positive'
%ax.Visible='off';
ax.FontSize=10;

%figure('Name','Mobility - Negative') 
subplot(2,2,2)
imagesc(MMneg,[0 max_mob_neg]);
  ax1 = gca;
  set(ax1, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');

colorbar()
ax1.YDir='reverse';
ax1.Title.String = 'Mobility - Negative'
%ax.Visible='off';
ax1.FontSize=10;

%figure('Name','Vt - Positive')
subplot(2,2,3)
imagesc(VTpos,[min_vt_pos max_vt_pos]);
  ax2 = gca;
  set(ax2, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');

colorbar()
ax2.YDir='reverse';
ax2.Title.String = 'Vt - Positive'
%ax.Visible='off';
ax2.FontSize=10;

%figure('Name','Vt - Negative')
subplot(2,2,4)
imagesc(VTneg,[min_vt_neg max_vt_neg]);
  ax3 = gca;
  set(ax3, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');

colorbar()
ax3.YDir='reverse';
ax3.Title.String = 'Vt - Negative'
%ax.Visible='off';
ax3.FontSize=10;


end

