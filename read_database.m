% Import the data that we need from the database file

data = readtable('Z:\DPP_database.csv');
data.Properties.RowNames = data.Author;
data.Author = [];

%24-29
%wfSemiPoly
%SubsTreat
%BladeVel
%StageTemp
%RTMobFor
%RTMobBack
%RTMobForSTD
%RTMobBackSTD
%VtFor
%VtBack
%VtForSTD
%VtBackSTD
%HystFactor
%HystFactorSTD
%CurveFactorFor
%CurveFactorBack
%CurveFactorForSTD
%CurveFactorBackSTD
%RFactorFor
%RFactorBack
%RFactorForSTD
%RFactorBackSTD

cols = [24:29];
fitData = data({'wfSemiPoly','SubsTreat','BladeVel','StageTemp','RTMobFor',...
    'RTMobBack','RTMobForSTD','RTMobBackSTD','VtFor','VtBack','VtForSTD',...
    'VtBackSTD','HystFactor','HystFactorSTD','CurveFactorFor','CurveFactorBack',...
    'CurveFactorForSTD','CurveFactorBackSTD','RFactorFor','RFactorBack',...
    'RFactorForSTD','RFactorBackSTD'},cols);

for i = 1:length(cols)
    if strcmp(cell2mat(fitData{1,i}),'')
        fitData{1,i} = {'1'};
    end
end

