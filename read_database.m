% Import the data that we need from the database file

function fitdata = read_database(filePath,rows)
% rows = array of rows that you want to focus on (the gbvs probably)

fulldata = readtable(filePath);

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

cutdata = fulldata(rows,{'x___Author','wfSemiPoly','SubsTreat','BladeVel','StageTemp','RTMobFor',...
    'RTMobBack','RTMobForSTD','RTMobBackSTD','VtFor','VtBack','VtForSTD',...
    'VtBackSTD','HystFactor','HystFactorSTD','CurveFactorFor','CurveFactorBack',...
    'CurveFactorForSTD','CurveFactorBackSTD','RFactorFor','RFactorBack',...
    'RFactorForSTD','RFactorBackSTD'});

% Turn NaN values for wfSemiPoly into 1 (all DPP)
cutdata{isnan(cutdata{:,'wfSemiPoly'}),'wfSemiPoly'} = 1;

% Get rid of non OTS rows
goodrows = ones(length(rows),1);
for i = 1:length(rows)
    if isequal(cutdata{i,'SubsTreat'}{1},'')
       goodrows(i) = 0;
    end
end
cutdata_OTS = cutdata(logical(goodrows),:);

% Make the Authors the name of the rows
cutdata_OTS.Properties.RowNames = cutdata_OTS.x___Author;
cutdata_OTS.x___Author = [];

% Trim down the data once more to what we actually need to fit things
fitdata = cutdata_OTS(:,{'wfSemiPoly','BladeVel','StageTemp','RTMobFor',...
    'RTMobForSTD','VtFor','VtForSTD','HystFactor','HystFactorSTD',...
    'CurveFactorFor','CurveFactorForSTD'});


end


