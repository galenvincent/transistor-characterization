% Function to compare the different 5 metrics across each of the channels
% of each wafer. Looking at both forward and reverse sweeps

function dd = metric_map(dd)
metric_map_help(dd);
nchan = length(dd);

numdeleted = 0;

while true
    row = input('Enter row # (0 to re-plot, -1 to exit): ');
    if row == -1
        break
    end
    if row == 0
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

MMback = zeros(9,9);
MMfor = zeros(9,9);

VTback = zeros(9,9);
VTfor = zeros(9,9);

Hyst = zeros(9,9);

Cback = zeros(9,9);
Cfor = zeros(9,9);

Rback = zeros(9,9);
Rfor = zeros(9,9);

for i = 1:nchan
    MMback(dd(i).ChanRow,dd(i).ChanCol) = dd(i).backMaxMob;
    MMfor(dd(i).ChanRow,dd(i).ChanCol) = dd(i).forMaxMob;
    
    VTback(dd(i).ChanRow,dd(i).ChanCol) = dd(i).backVt;
    VTfor(dd(i).ChanRow,dd(i).ChanCol) = dd(i).forVt;
    
    Hyst(dd(i).ChanRow,dd(i).ChanCol) = dd(i).hystFactor;
    
    Cback(dd(i).ChanRow,dd(i).ChanCol) = dd(i).backCurveFactor;
    Cfor(dd(i).ChanRow,dd(i).ChanCol) = dd(i).forCurveFactor;
    
    Rback(dd(i).ChanRow,dd(i).ChanCol) = dd(i).backRFactor;
    Rfor(dd(i).ChanRow,dd(i).ChanCol) = dd(i).forRFactor;
end

max_mob_back = max(max(MMback));
max_mob_for = max(max(MMfor));
max_mob = max([max_mob_back max_mob_for]);

max_vt_back = max(max(VTback));
max_vt_for = max(max(VTfor));
min_vt_back = min(min(VTback));
min_vt_for = min(min(VTfor));
max_vt = max([max_vt_back max_vt_for]);
min_vt = min([min_vt_back min_vt_for]);

max_hyst = max(max(Hyst));
min_hyst = min(Hyst(Hyst>0));

max_c_back = max(max(Cback));
max_c_for = max(max(Cfor));
min_c_back = min(Cback(Cback>0));
min_c_for = min(Cfor(Cfor>0));
max_c = max([max_c_back max_c_for]);
min_c = min([min_c_back min_c_for]);

max_r_back = max(max(Rback));
max_r_for = max(max(Rfor));
min_r_back = min(Rback(Rback>0));
min_r_for = min(Rfor(Rfor>0));
max_r = max([max_r_back max_r_for]);
min_r = min([min_r_back min_r_for]);

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
imagesc(MMback,[0 max_mob]);
  ax = gca;
  set(ax, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');
colorbar()
ax.YDir='reverse';
ax.Title.String = 'Mobility - Backward';
ax.FontSize=10;

subplot(3,3,2)
imagesc(MMfor,[0 max_mob]);
  ax = gca;
  set(ax, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');
colorbar()
ax.YDir='reverse';
ax.Title.String = 'Mobility - Forward';
ax.FontSize=10;

subplot(3,3,3)
imagesc(VTback,[min_vt max_vt]);
  ax = gca;
  set(ax, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');
colorbar()
ax.YDir='reverse';
ax.Title.String = 'Vt - Backward';
ax.FontSize=10;

subplot(3,3,4)
imagesc(VTfor,[min_vt max_vt]);
  ax = gca;
  set(ax, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');
colorbar()
ax.YDir='reverse';
ax.Title.String = 'Vt - Forward';
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
imagesc(Cback,[min_c max_c]);
  ax = gca;
  set(ax, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');
colorbar()
ax.YDir='reverse';
ax.Title.String = 'Curve - Backward (1 = good)';
ax.FontSize=10;

subplot(3,3,7)
imagesc(Cfor,[min_c max_c]);
  ax = gca;
  set(ax, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');
colorbar()
ax.YDir='reverse';
ax.Title.String = 'Curve - Forward (1 = good)';
ax.FontSize=10;

subplot(3,3,8)
imagesc(Rback,[min_r max_r]);
  ax = gca;
  set(ax, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');
colorbar()
ax.YDir='reverse';
ax.Title.String = 'R Factor - Backward (1 = good)';
ax.FontSize=10;

subplot(3,3,9)
imagesc(Rback,[min_r max_r]);
  ax = gca;
  set(ax, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');
colorbar()
ax.YDir='reverse';
ax.Title.String = 'R Factor - Forward (1 = good)';
ax.FontSize=10;
end