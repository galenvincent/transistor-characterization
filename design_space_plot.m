% Figure of initial design space

temp = [70,50,90,50,90,70,40,70,104,70,50,90,50,90,70];
wtp = [65,30,30,100,100,10,65,65,65,100,30,30,100,100,65];
speed = [.2,.5,.5,.5,.5,5.25,5.25,5.25,5.25,5.25,10,10,10,10,13.25];

ax = yscatter3([speed',wtp'],temp);
ax.XLabel.String = 'Blade Speed (mm/s)';
ax.YLabel.String = 'Weight % DPP';
ax.ZLabel.String = 'Stage Temperature (C)';

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
