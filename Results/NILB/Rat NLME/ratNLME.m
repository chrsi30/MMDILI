function ratNLME


uberDataFolder = '../../../Data/NILB/';
resultsFolder = '../../../Results/NILB/Rat NLME/';

toSave = false;
toPlot = true;

allPat = dir(uberDataFolder); allPat = allPat(3:end);
nPat = length(allPat);


signalType = 'Liver';
modelName = 'ratConv';
addpath('../sim and cost')
addpath('../plot')
addpath('../models')
addpath('../../Common Code')



%% Set up data

X = []; Y = []; group = [];
for pat = 1:nPat
    
    pid = allPat(pat).name;
    load(['../../../Data/NILB/' pid  '/data.mat'])
    
    % Load data
    data = data.deltaR1;
    % Time in seconds
    data.time = data.time*60;
    % Convert deltaR1 to Gd conc, assmuing ralaxivity = 6.9 1/mMs and 10.7
    % 1/mMs
    data = deltaR12Conc(data,6.9,10.7);
    % Remove a-fas and v-fas
%     idx = (data.time == 30 | data.time == 38 | data.time == 46);% | data.time == 60);
%     data.time(idx)   = [];
%     data.liver(idx)  = []; data.liverSE(idx)  = [];
%     data.spleen(idx) = []; data.spleenSE(idx) = [];
    
    % Build Matrices for NLME
    Y = [Y; data.liver'];
    X = [X; [data.time', data.spleen']];
    group = [group; repmat(pat,numel(data.time),1)];
    
end



%% Prepare Optim

ki    = 3.8e-3;                  % Plasma -> Hepatocyte [s-1]
kef   = 3e-4;                  % Hep -> Bile [s-1]

% Start Guess
x0 =  [ki,   kef];
ParamTransform = [1 1];

fun = @(param,simInput)ratConv(param,simInput,signalType);


%% Optimization

options = statset;
options.Display = 'iter';
options.FunValCheck = 'off';

logx0 = log(x0);
[BETA,PSI,STATS,B] = nlmefitsa(X,Y,group,[],fun,logx0, 'ErrorModel','constant',...
    'ParamTransform',ParamTransform, 'Vectorization','SinglePhi', 'options',options,...
    'NIterations',[50 50 20]);
allParam = exp(repmat(BETA', nPat, 1)+B');


%% Ploting & Saving

IDs = unique(group);
for i = 1:length(IDs)
    
    pid = allPat(i).name;
    param = allParam(i,:);
    load(['../../../Data/NILB/' pid  '/data.mat'])
    
    % Load data
    data = data.deltaR1;
    % Time in seconds
    data.time = data.time*60;
    % Convert deltaR1 to Gd conc, assmuing ralaxivity = 6.9 1/mMs and 10.7
    % 1/mMs
    data = deltaR12Conc(data,6.9,10.7);
    % Remove a-fas and v-fas
%     idx = (data.time == 30 | data.time == 38 | data.time == 46);% | data.time == 60);
%     data.time(idx)   = [];
%     data.liver(idx)  = []; data.liverSE(idx)  = [];
%     data.spleen(idx) = []; data.spleenSE(idx) = [];
    
    % Plot
    ratPlotFit(param,data,modelName,signalType)
    title(pid)
    
    savePath = [resultsFolder pid '/'];
    mkdir(savePath);
    saveFile = [savePath 'param_cost.mat'];
    save(saveFile,'param','x0','modelName','BETA','PSI','STATS','B','data')
    saveas(gcf,[savePath 'optimFit'],'jpg')
    close(gcf);
    
end

copyfile([mfilename '.m'], [resultsFolder mfilename '.m']);



