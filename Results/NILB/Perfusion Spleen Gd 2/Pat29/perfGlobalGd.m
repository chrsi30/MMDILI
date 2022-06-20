function perfGlobalGd(pid,toPlot,toSave)


if nargin == 0
    pid    = 'SS48';
    toSave = false;
    toPlot = true;
end

%% Fix Data

addpath('../sim and cost')
addpath('../plot')
addpath('../../Common Code')
modelName = 'perfConvSpleen';

load(['../../../Data/NILB/' pid  '/data.mat'])
data = data.deltaR1;
% Time in seconds
data.time = data.time*60;
% Convert deltaR1 to Gd conc, assmuing ralaxivity = 6.9 1/mMs
data = deltaR12Conc(data,6.9,10.7);


%% Prepare Optim

Fp    = 0.9/60;                % Plasma blood flow [l/(s*l)]
fa    = 0.1;                   % Arterial flow fraction
ve    = 0.25;                  % Extracellular volume fraction
ki    = 3e-3;                  % Plasma -> Hepatocyte [s-1]
kef   = 3e-4;                  % Hep -> Bile [s-1]


% Do optim in log-space
x0 =  log([Fp,   fa,   ve,   ki,   kef]);
lb =  log([1e-3, 1e-2, 1e-2, 1e-5, 1e-6]);
ub =  log([0.5,  0.5,  0.5,  8e-2, 8e-3]);

fun = @(param)perfChiCost(param,data,modelName);

% Plot Start Guess
if toPlot
    perfPlotFitSE(exp(x0),data,modelName)
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

fprintf('\n\nFp          fa          ve          ki          kef\n');
fprintf('%0.1d     %0.1d     %0.1d     %0.1d     %0.1d\n\n\n', param);

if toPlot
    perfPlotFitSE(param,data,modelName)
    title(pid)
end

%% Save stuff

if toSave
    saveFolder = ['../../../Results/NILB/Perfusion Spleen Gd 2/' pid];
    mkdir(saveFolder)
    saveas(figure(1),[saveFolder filesep 'optimFit'],'jpg')
    save([saveFolder filesep 'param_cost.mat'], 'param', 'x0', 'ub', 'lb','fval','pid','data','modelName')
    copyfile([mfilename '.m'], [saveFolder filesep mfilename '.m']);
    close(figure(1))
end

%}



