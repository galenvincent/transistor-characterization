% Galen Vincent - Summer 2018 
% Function to plot only the sqrt transfer curves with mobility fits.

function [ax, ax2, f] = plot_sqrt_id(dd,devNums)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dd = struct from mob_dual_analysis 

% devNums = index in the dd onject of the channel to plot

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If the threshold voltage is too large, indicate a fault and do not plot
if abs(dd(devNums).backVt) > 1000
    fprintf('SD Short - Cannot plot for dev #%i \n',devNums);
elseif abs(dd(devNums).backVt) > 1000
    fprintf('SD Short - Cannot plot for dev #%i \n',devNums);
else
    f=figure;
    ax=gca;
    hold(ax,'on')
    
    for d = devNums
        
        backfit = dd(d).backFun;
        forfit = dd(d).forFun;
        
        vg = dd(d).vg{:,1};
        id = dd(d).id{:,1};
        
        %ax2 = plotyy(vg,sqrt(abs(id)),vg,abs(id),'plot','semilogy');
        ax2 = plot(vg,sqrt(abs(id)),'LineWidth',2);
        if dd(devNums).semiType == 'n'
            fplot(ax,@(x) sqrt(-backfit(x)),[dd(d).backVt,max(vg)],'--k','LineWidth',2);
            fplot(ax,@(x) sqrt(-forfit(x)),[dd(d).forVt,max(vg)],'--k','LineWidth',2);
        elseif dd(devNums).semiType == 'p'
            fplot(ax,@(x) sqrt(-backfit(x)),[min(vg),dd(d).backVt],'--k','LineWidth',2);
            fplot(ax,@(x) sqrt(-forfit(x)),[min(vg),dd(d).forVt],'--k','LineWidth',2);
        end
    end
    
    ax.FontSize = 14;
    ax.Box = 'on';
    %ax.LineWidth = 1;
    f.Position = [770 355 700 500];
    ax.Position = [0.15 0.15 0.7 0.8];
    
    xlabel('Gate Voltage (Volts)')
    %     ylabel(ax2(1),'(Drain Current)^{1/2} (A^{1/2})')
    %     ylabel(ax2(2),'Drain Current (A)')
    ylabel('(Drain Current)^{1/2} (A^{1/2})');
    
    lin_bounds = [0, round(max(sqrt(abs(id)))*1.1,2,'significant')];
    log_bounds = [10^floor(log10(min(abs(id)))), 10^ceil(log10(max(abs(id))))];
    %disp(log_bounds)
    %     set(ax2(1),'YLim',lin_bounds);
    %     set(ax2(1),'ytick',linspace(lin_bounds(1),lin_bounds(2),5));
    %     set(ax2(2),'YLim',log_bounds);
    
    %set(ax2,'YLim',lin_bounds);
    %set(ax2,'ytick',linspace(lin_bounds(1),lin_bounds(2),5));
    
    %     if min(abs(id))==0
    %         set(ax2(2),'ytick',10.^(floor(log10(min(abs(id))+1E-10)):ceil(log10(max(abs(id))))));
    %     else
    %         set(ax2(2),'ytick',10.^(floor(log10(min(abs(id)))):ceil(log10(max(abs(id))))));
    %     end
    %     ytl = {};
    %     for i = 1:length(ax2(2).YTick)
    %         ytl{i} = num2str(ax2(2).YTick(i));
    %     end
    %     set(ax2(2),'yticklabels',ytl);
    %     set(ax2(2),'FontSize',14);
    %     set(ax2(2),'LineWidth',1);
    %     %ax.Children(2).LineWidth=1;
    %     ax2(2).Children(1).LineWidth=1;
    
end

end