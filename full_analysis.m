% Script to run the full analysis for data

g61 = mob_dual_analysis('Z:\data\180606gbv1\transfer',10,2,'p');
g62 = mob_dual_analysis('Z:\data\180606gbv2\transfer',10,3,'p');
g64 = mob_dual_analysis('Z:\data\180606gbv4\transfer',10,2,'p');
g65 = mob_dual_analysis('Z:\data\180606gbv5\transfer',10,2,'p');
g131 = mob_dual_analysis('Z:\data\180613gbv1\transfer',10,1,'p');
g132 = mob_dual_analysis('Z:\data\180613gbv2\transfer',10,1,'p');
g133 = mob_dual_analysis('Z:\data\180613gbv3\transfer',10,1,'p');
g134 = mob_dual_analysis('Z:\data\180613gbv4\transfer',10,1,'p');
g135 = mob_dual_analysis('Z:\data\180613gbv5\transfer',10,1,'p');
g136 = mob_dual_analysis('Z:\data\180613gbv6\transfer',10,1,'p');
g191 = mob_dual_analysis('Z:\data\180619gbv1\transfer',10,1,'p');
g193 = mob_dual_analysis('Z:\data\180619gbv3\transfer',10,1,'p');
g195 = mob_dual_analysis('Z:\data\180619gbv5\transfer',10,1,'p');
g254 = mob_dual_analysis('Z:\data\180625gbv4\transfer',10,1,'p');
g271 = mob_dual_analysis('Z:\data\180627gbv1\transfer',10,1,'p');
g273 = mob_dual_analysis('Z:\data\180627gbv3\transfer',10,1,'p');
g274 = mob_dual_analysis('Z:\data\180627gbv4\transfer',10,1,'p');
g275 = mob_dual_analysis('Z:\data\180627gbv5\transfer',10,1,'p');
g23 = mob_dual_analysis('Z:\data\180702gbv3\transfer',10,1,'p');

g101 = mob_dual_analysis('Z:\data\180717gbv1\transfer',10,3,'p');
g102 = mob_dual_analysis('Z:\data\180717gbv2\transfer',10,3,'p');
g103 = mob_dual_analysis('Z:\data\180717gbv4\transfer',10,3,'p');
g104 = mob_dual_analysis('Z:\data\180717gbv4\transfer',10,3,'p');
g105 = mob_dual_analysis('Z:\data\180717gbv5\transfer',10,3,'p');

g171 = mob_dual_analysis('Z:\data\180717gbv1\transfer',10,3,'p');
g172 = mob_dual_analysis('Z:\data\180717gbv2\transfer',10,3,'p');
g174 = mob_dual_analysis('Z:\data\180717gbv4\transfer',10,3,'p');
g175 = mob_dual_analysis('Z:\data\180717gbv5\transfer',10,3,'p');

s61 = calc_avg(g61,[6,7,8,9]);
s62 = calc_avg(g62,[6,7,8,9]);
s64 = calc_avg(g64,[6,7,8,9]);
s65 = calc_avg(g65,[6,7,8,9]);
s131 = calc_avg(g131,[7,8,9]);
s132 = calc_avg(g132,[7,8,9]);
s133 = calc_avg(g133,[7,8,9]);
s134 = calc_avg(g134,[7,8,9]);
s135 = calc_avg(g135,[7,8,9]);
s136 = calc_avg(g136,[7,8,9]);
s191 = calc_avg(g191,[7,8,9]);
s193 = calc_avg(g193,[7,8,9]);
s195 = calc_avg(g195,[7,8,9]);
s254 = calc_avg(g254,[7,8,9]);
s271 = calc_avg(g271,[7,8,9]);
s273 = calc_avg(g273,[7,8,9]);
s274 = calc_avg(g274,[7,8,9]);
s275 = calc_avg(g275,[7,8,9]);
s23 = calc_avg(g23,[7,8,9]);

s101 = calc_avg(g171,[7,8,9]);
s102 = calc_avg(g172,[7,8,9]);
s103 = calc_avg(g172,[7,8,9]);
s104 = calc_avg(g174,[7,8,9]);
s105 = calc_avg(g175,[7,8,9]);

s171 = calc_avg(g171,[7,8,9]);
s172 = calc_avg(g172,[7,8,9]);
s174 = calc_avg(g174,[7,8,9]);
s175 = calc_avg(g175,[7,8,9]);

output_stats('Z:\data\180723_fullrecalc.csv',[s61 s62 s64 s65 s131 s132 s133 s134 s135 s136 s191 s193 s195 s254 s271 s273 s274 s275 s23 s101 s102 s103 s104 s105 s171 s172 s174 s175])

data = read_database('Z:\DPP_database_wanisotropy.csv',[24:62]);

[lms, datanew] = fit_res_surf(data,1,1,0);

des_op = optimize_desirability(lms);

results_plot(datanew);