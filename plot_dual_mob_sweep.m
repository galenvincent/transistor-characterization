% Function to plot mobility sweep and associated vt sweep on the same plot
% for both the positive and negative voltage sweeps

function plot_dual_mob_sweep(DD,devnum)

figure('Name','Positive Sweep')
hold on
yyaxis left
ylabel('Mobility (cm^2 V^{-1} s^{-1})')
plot(DD(devnum).backMobSweep)
yyaxis right
plot(DD(devnum).backVtSweep)
ylabel('V_t (V)')
xlabel('Index')
legend('Mobility','Threshold Voltage')

figure('Name','Negative Sweep')
hold on
yyaxis left
plot(DD(devnum).forMobSweep)
ylabel('Mobility (cm^2 V^{-1} s^{-1})')
yyaxis right
plot(DD(devnum).forVtSweep)
ylabel('V_t (V)')
xlabel('Index')
legend('Mobility','Threshold Voltage')

end