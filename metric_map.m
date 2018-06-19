% Function to compare the different 5 metrics across each of the channels
% of each wafer. Looking at both forward and reverse sweeps

function dd = metric_map(dd)
metric_map_help(dd);
nchan = length(dd);

numdeleted = 0;

while true
    row = input('Enter row # (1 to re-plot, 0 to exit): ');
    if row == 0
        break
    end
    if row == 1
       close;
       metric_map_help(dd);
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

function metric_map_help(dd)
nchan = length(dd);

MMpos = zeros(9,9);
MMneg = zeros(9,9);

VTpos = zeros(9,9);
VTneg = zeros(9,9);

Hyst = zeros(9,9);

Cpos = zeros(9,9);
Cneg = zeros(9,9);

Rpos = zeros(9,9);
Rneg = zeros(9,9);

for i = 1:nchan
    MMpos(dd(i).ChanRow,dd(i).ChanCol) = dd(i).posMaxMob;
    MMneg(dd(i).ChanRow,dd(i).ChanCol) = dd(i).negMaxMob;
    
    VTpos(dd(i).ChanRow,dd(i).ChanCol) = dd(i).posVt;
    VTneg(dd(i).ChanRow,dd(i).ChanCol) = dd(i).negVt;
    
    Hyst(dd(i).ChanRow,dd(i).ChanCol) = dd(i).hystFactor;
    
    Cpos(dd(i).ChanRow,dd(i).ChanCol) = dd(i).posCurveFactor;
    Cneg(dd(i).ChanRow,dd(i).ChanCol) = dd(i).negCurveFactor;
    
    Rpos(dd(i).ChanRow,dd(i).ChanCol) = dd(i).posRFactor;
    Rneg(dd(i).ChanRow,dd(i).ChanCol) = dd(i).negRFactor;
end

max_mob_pos = max(max(MMpos));
max_mob_neg = max(max(MMneg));
max_mob = max([max_mob_pos max_mob_neg]);

max_vt_pos = max(max(VTpos));
max_vt_neg = max(max(VTneg));
min_vt_pos = min(min(VTpos));
min_vt_neg = min(min(VTneg));
max_vt = max([max_vt_pos max_vt_neg]);
min_vt = min([min_vt_pos min_vt_neg]);

max_hyst = max(max(Hyst));
min_hyst = min(Hyst(Hyst>0));

max_c_pos = max(max(Cpos));
max_c_neg = max(max(Cneg));
min_c_pos = min(Cpos(Cpos>0));
min_c_neg = min(Cneg(Cneg>0));
max_c = max([max_c_pos max_c_neg]);
min_c = min([min_c_pos min_c_neg]);

max_r_pos = max(max(Rpos));
max_r_neg = max(max(Rneg));
min_r_pos = min(Rpos(Rpos>0));
min_r_neg = min(Rneg(Rneg>0));
max_r = max([max_r_pos max_r_neg]);
min_r = min([min_r_pos min_r_neg]);

if isempty(strfind('ABCDEFGHIJ',dd(1).ChanLetter))
    xticks = 1:9;
    xlabels = {'K','L','M','N','P','Q','R','S','T'};
else
    xticks = 1:9;
    xlabels = {'A','B','C','D','E','F','G','H','J'};
end

% Generate Heat Map
figure('Name','Metric Map','Units', 'Normalized', 'OuterPosition', [0 0 1 1])%,'position', [0, 250, 800, 650])
subplot(3,3,1)
imagesc(MMpos,[0 max_mob]);
  ax = gca;
  set(ax, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');
colorbar()
ax.YDir='reverse';
ax.Title.String = 'Mobility - Positive';
ax.FontSize=10;

subplot(3,3,2)
imagesc(MMneg,[0 max_mob]);
  ax = gca;
  set(ax, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');
colorbar()
ax.YDir='reverse';
ax.Title.String = 'Mobility - Negative';
ax.FontSize=10;

subplot(3,3,3)
imagesc(VTpos,[min_vt max_vt]);
  ax = gca;
  set(ax, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');
colorbar()
ax.YDir='reverse';
ax.Title.String = 'Vt - Positive';
ax.FontSize=10;

subplot(3,3,4)
imagesc(VTneg,[min_vt max_vt]);
  ax = gca;
  set(ax, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');
colorbar()
ax.YDir='reverse';
ax.Title.String = 'Vt - Negative';
ax.FontSize=10;

subplot(3,3,5)
imagesc(Hyst,[min_hyst max_hyst]);
  ax = gca;
  set(ax, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');
colorbar()
ax.YDir='reverse';
ax.Title.String = 'Hysterisis (1 = good)';
ax.FontSize=10;

subplot(3,3,6)
imagesc(Cpos,[min_c max_c]);
  ax = gca;
  set(ax, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');
colorbar()
ax.YDir='reverse';
ax.Title.String = 'Curve - Positive (1 = good)';
ax.FontSize=10;

subplot(3,3,7)
imagesc(Cneg,[min_c max_c]);
  ax = gca;
  set(ax, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');
colorbar()
ax.YDir='reverse';
ax.Title.String = 'Curve - Negative (1 = good)';
ax.FontSize=10;

subplot(3,3,8)
imagesc(Rpos,[min_r max_r]);
  ax = gca;
  set(ax, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');
colorbar()
ax.YDir='reverse';
ax.Title.String = 'R Factor - Positive (1 = good)';
ax.FontSize=10;

subplot(3,3,9)
imagesc(Rpos,[min_r max_r]);
  ax = gca;
  set(ax, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');
colorbar()
ax.YDir='reverse';
ax.Title.String = 'R Factor - Negative (1 = good)';
ax.FontSize=10;
end