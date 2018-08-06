% Galen Vincent - Summer 2018
% Figure of initial design space

function design_space_plot(datatable, rows)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% datatable is the file read in from read_database

% rows is a cell array that contains a vector for each set of points that
% you would like to plot (with different colors)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sz = length(rows);
col = {'b','r','g','k'};
leg = {'Set 1', 'Set 2', 'Set 3', 'Set 4'};

figure
ax = gca;
hold on
grid on
set(ax,'fontsize',15)
ax.XLabel.String = 'Weight Fraction DPP';
ax.YLabel.String = 'Blade Velocity (mm/s)';
ax.ZLabel.String = 'Stage Temperature (C)';
ax.Title.String = 'Design Space';
view(60,15)
scatter3(datatable{rows{1},1},datatable{rows{1},2},datatable{rows{1},3},...
    200,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','b')

scatter3(datatable{rows{2},1},datatable{rows{2},2},datatable{rows{2},3},...
    200,'d',...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','r')

set(gcf,'Position',[100,100,1000,700])


%% Drawing lines between the points

% Un-comment this to see the index associated with each point
%     figure
%     hold on
%     scatter3(datatable{[1:17],1},datatable{[1:17],2},datatable{[1:17],3})
%     for i = 1:17
%         text(datatable{i,1},datatable{i,2},datatable{i,3},cellstr(num2str(i)));
%     end

% Use the index to match up the points that you would like connected with
% lines
pairs = [1 2;2 3;3 4;4 1;6 8;8 7;7 5;5 6;4 7; 1 5;2 6; 3 8];
pairs2 = [10 16;16 11;15 16;16 14;13 16;16 12];

% Comment these in to connect these points with lines
for i = 1:length(pairs)
    plot3(datatable{pairs(i,:),'wfSemiPoly'},datatable{pairs(i,:),'BladeVel'},datatable{pairs(i,:),'StageTemp'},'k--');
end
for i = 1:length(pairs2)
    plot3(datatable{pairs2(i,:),'wfSemiPoly'},datatable{pairs2(i,:),'BladeVel'},datatable{pairs2(i,:),'StageTemp'},'k');
end

end