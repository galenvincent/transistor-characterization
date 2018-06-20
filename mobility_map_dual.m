% Function to create mobility maps for both the postive and negative
% direction voltage sweeps. Based on the output from the
% calc_dual_max_mob() function
function mobility_map_dual(dd)
mobility_map_help(dd);
nchan = length(dd);
numdeleted = 0;

while true
    row = input('Enter row # (0 to re-plot, -1 to exit): ');
    if row == -1
        break
    end
    if row == 0
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
MMback = zeros(9,9);
VTback = zeros(9,9);
MMfor = zeros(9,9);
VTfor = zeros(9,9);

for i = 1:nchan 
    MMback(dd(i).ChanRow,dd(i).ChanCol) = dd(i).backMaxMob;
    VTback(dd(i).ChanRow,dd(i).ChanCol) = dd(i).backVt;
    MMfor(dd(i).ChanRow,dd(i).ChanCol) = dd(i).forMaxMob;
    VTfor(dd(i).ChanRow,dd(i).ChanCol) = dd(i).forVt;
end

max_mob_back = max(max(MMback));
max_mob_for = max(max(MMfor));
max_vt_back = max(max(VTback));
max_vt_for = max(max(VTfor));
min_vt_back = min(min(VTback));
min_vt_for = min(min(VTfor));

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
imagesc(MMback,[0 max_mob_back]);
  ax = gca;
  set(ax, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');

colorbar()
ax.YDir='reverse';
ax.Title.String = 'Mobility - Backward'
%ax.Visible='off';
ax.FontSize=10;

subplot(2,2,2)
imagesc(MMfor,[0 max_mob_for]);
  ax1 = gca;
  set(ax1, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');

colorbar()
ax1.YDir='reverse';
ax1.Title.String = 'Mobility - Forward'
%ax.Visible='off';
ax1.FontSize=10;

%figure('Name','Vt - Positive')
subplot(2,2,3)
imagesc(VTback,[min_vt_back max_vt_back]);
  ax2 = gca;
  set(ax2, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');

colorbar()
ax2.YDir='reverse';
ax2.Title.String = 'Vt - Backward'
%ax.Visible='off';
ax2.FontSize=10;

%figure('Name','Vt - Negative')
subplot(2,2,4)
imagesc(VTfor,[min_vt_for max_vt_for]);
  ax3 = gca;
  set(ax3, 'XTick', xticks,'YTick',[1:9], 'XTickLabel', xlabels,'TickLength',[0 0],'XAxisLocation', 'top');

colorbar()
ax3.YDir='reverse';
ax3.Title.String = 'Vt - Forward'
%ax.Visible='off';
ax3.FontSize=10;


end

