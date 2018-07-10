% Import the data that we need from the database file

function fitdata = read_database(filePath,rows)
% rows = array of rows that you want to focus on (the gbvs probably)

fulldata = readtable(filePath);

cutdata = fulldata(rows,{'x___Author','wfSemiPoly','SubsTreat','BladeVel','StageTemp','RTMobForVert',...
    'RTMobForVertSTD','RTMobForHoriz','RTMobForHorizSTD','RTMobBackVert','RTMobBackVertSTD',...
    'RTMobBackHoriz','RTMobBackHorizSTD','VtForVert','VtForVertSTD','VtForHoriz','VtForHorizSTD',...
    'VtBackVert','VtBackVertSTD','VtBackHoriz','VtBackHorizSTD','HystFactorVert','HystFactorVertSTD',...
    'HystFactorHoriz','HystFactorHorizSTD','CurveFactorForVert','CurveFactorForVertSTD',...
    'CurveFactorForHoriz','CurveFactorForHorizSTD','CurveFactorBackVert','CurveFactorBackVertSTD',...
    'CurveFactorBackHoriz','CurveFactorBackHorizSTD','RFactorForVert','RFactorForVertSTD',...
    'RFactorForHoriz','RFactorForHorizSTD','RFactorBackVert','RFactorBackVertSTD',...
    'RFactorBackHoriz','RFactorBackHorizSTD','AnisotropyFor','AnisotropyBack'});

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

% Find out which channel direction (vertical or horizontal) has the best
% mobility stats for each device, and take that data in the forward direction

% initialize the data
fitdata = array2table(zeros(height(cutdata_OTS),11));
% Rename the columns to the standard names, so that the surface fitting can
% work the same
fitdata.Properties.VariableNames = {'wfSemiPoly','BladeVel','StageTemp','RTMobFor',...
    'RTMobForSTD','VtFor','VtForSTD','HystFactor','HystFactorSTD',...
    'CurveFactorFor','CurveFactorForSTD'};

for i = 1:height(cutdata_OTS)
    ani = cutdata_OTS{i,'AnisotropyFor'};
    if ani > 1
        toKeep = {'wfSemiPoly','BladeVel','StageTemp','RTMobForVert',...
            'RTMobForVertSTD','VtForVert','VtForVertSTD','HystFactorVert','HystFactorVertSTD',...
            'CurveFactorForVert','CurveFactorForVertSTD'};
        fitdata.Anisotropy(i) = {'Vertical'};
        fitdata{i,1:end-1} = cutdata_OTS{i,toKeep};
    elseif ani < 1 && ani > 0
        toKeep = {'wfSemiPoly','BladeVel','StageTemp','RTMobForHoriz',...
            'RTMobForHorizSTD','VtForHoriz','VtForHorizSTD','HystFactorHoriz','HystFactorHorizSTD',...
            'CurveFactorForHoriz','CurveFactorForHorizSTD'};
        fitdata.Anisotropy(i) = {'Horizontal'};
        fitdata{i,1:end-1} = cutdata_OTS{i,toKeep};
    elseif ani == 1 || ani == 0
        toKeep = {'wfSemiPoly','BladeVel','StageTemp','RTMobForVert',...
            'RTMobForVertSTD','VtForVert','VtForVertSTD','HystFactorVert','HystFactorVertSTD',...
            'CurveFactorForVert','CurveFactorForVertSTD'};
        fitdata.Anisotropy(i) = {'Unknown - Used all data'};
        fitdata{i,1:end-1} = cutdata_OTS{i,toKeep};
    else
        toKeep = {'wfSemiPoly','BladeVel','StageTemp','RTMobForHoriz',...
            'RTMobForHorizSTD','VtForHoriz','VtForHorizSTD','HystFactorHoriz','HystFactorHorizSTD',...
            'CurveFactorForHoriz','CurveFactorForHorizSTD'};
        fitdata.Anisotropy(i) = {'Unknown - No data'};
        fitdata{i,1:end-1} = cutdata_OTS{i,toKeep};
    end
end

fitdata.Properties.RowNames = cutdata_OTS.Properties.RowNames;

end


