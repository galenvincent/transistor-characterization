% Figure of initial design space

function design_space_plot(datatable, initial_rows, final_rows)
% datatable is the file read in from read_database

% inital_rows are the rows of the data points that you would like to show
% in the design space, the first set of design space points

% final_rows are the second set of data points taken, once the first set had
% been taken into account

init_data = datatable{initial_rows, {'wfSemiPoly','BladeVel','StageTemp'}};
fin_data = datatable{final_rows, {'wfSemiPoly','BladeVel','StageTemp'}};

figure 
ax = gca;
hold on
grid on
ax.XLabel.String = 'Weight Fraction DPP';
ax.YLabel.String = 'Blade Velocity (mm/s)';
ax.ZLabel.String = 'Stage Temperature (C)';
ax.Title.String = 'Design Space';
view(60,15)
scatter3(init_data(:,1),init_data(:,2),init_data(:,3),...
    40,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','b')
scatter3(fin_data(:,1),fin_data(:,2),fin_data(:,3),...
    40,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','r')
legend('Primary Tests', 'Secondary Tests','Location','northwestoutside')

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