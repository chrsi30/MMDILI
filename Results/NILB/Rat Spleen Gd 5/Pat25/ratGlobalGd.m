function ratGlobalGd(pid,toPlot,toSave)


if nargin == 0
    pid    = 'LP39';
    toSave = false;
    toPlot = true;
end

%% Fix Data

signalType = 'Liver';
modelName = 'ratConv';
addpath('../sim and cost')
addpath('../plot')
addpath('../../Common Code')

load(['../../../Data/NILB/' pid  '/data.mat'])
data = data.deltaR1;
% Time in seconds
data.time = data.time*60;
% Convert deltaR1 to Gd conc, assmuing ralaxivity = 6.9 1/mMs
data = deltaR12Conc(data,6.9,10.7);


%% Prepare Optim

ki  = 2e-3;         % Plasma -> Hepatocyte [s-1]
kef = 1.7e-4;       % Hep -> Bile [s-1]
vel = 0.23;         % Extracellular volume fraction


% Do optim in log-space
x0 =  log([ki,   kef]);%,  vel]);
lb =  log([1e-5, 1e-7]);%, 0.05]);
ub =  log([0.1,  0.1]);%,  0.60]);

fun = @(param)ratChiCost(param,data,signalType,modelName);

% Plot Start Guess
if toPlot
    ratPlotFitSE(exp(x0),data)
    close(figure(1))
end

%% Optimize
problem = createOptimProblem('fmincon',...
    'objective',fun,'x0',x0,'options',...
    optimoptions(@fmincon,'Display','off'), 'lb',lb, 'ub',ub);
gs = GlobalSearch('Display','iter');
[tmpParam,fval] = run(gs,problem);
param = exp(tmpParam);

%% Post Optim Stuff

fprintf('\n\nki          kef         vel\n');
fprintf('%0.1d     %0.1d     %0.2f\n\n\n', param);

if toPlot
    ratPlotFitSE(param,data,modelName,signalType)
    title(pid)
end

%% Save stuff
if toSave
    saveFolder = ['../../../Results/NILB/Rat Spleen Gd 5/' pid];
    mkdir(saveFolder)
    saveas(figure(1),[saveFolder filesep 'optimFit'],'jpg')
    save([saveFolder filesep 'param_cost.mat'], 'param', 'x0', 'ub', 'lb','fval','signalType','pid','modelName','data')
    copyfile([mfilename '.m'], [saveFolder filesep mfilename '.m']);
    close(figure(1))
end
%}

