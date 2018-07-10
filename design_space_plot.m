% Figure of initial design space

function design_space_plot(datatable, rows)
% datatable is the file read in from read_database

% rows is a cell array that contains a vector for each set of points that
% you would like to plot (with different colors)
    
    sz = length(rows);
    
    col = {'b','r','g','k'};
    leg = {'Set 1', 'Set 2', 'Set 3', 'Set 4'};
    
    figure
    ax = gca;
    hold on
    grid on
    ax.XLabel.String = 'Weight Fraction DPP';
    ax.YLabel.String = 'Blade Velocity (mm/s)';
    ax.ZLabel.String = 'Stage Temperature (C)';
    ax.Title.String = 'Design Space';
    view(60,15)
    for i = 1:sz
    scatter3(datatable{rows{i},1},datatable{rows{i},2},datatable{rows{i},3},...
        40,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor',col{i})
    end
    
    legend(leg{1:sz},'Location','northwestoutside')
    
    set(gcf,'Position',[100,100,1000,700])
    
    % figure
    % hold on
    % scatter3(speed,wtp,temp,'filled')
    % for i = 1:15
    %     text(speed(i),wtp(i),temp(i),cellstr(num2str(i)));
    % end
    %
    % pairs = [3 5;5 14;14 12;12 3;2 3;2 4;4 5;2 11;11 13;13 4;11 12;13 14;12 14];
    %
    % for i = 1:length(pairs)
    %    plot3(speed(pairs(i,:)),wtp(pairs(i,:)),temp(pairs(i,:)));
    % end
    
end