function plotCorrelationAZ_Individual

%% Parameters
patName = 'G1.M5';
axesSize = [0.34,0.34];
posA = [0.01,0.59]; posB = [0.33,0.59]; posC = [0.65,0.59];
posD = [0.01,0.08]; posE = [0.33,0.08]; posF = [0.65,0.08];


%% Load Data and Param For Simulation
load(['./Results/AZ/Perfusion Liver Spleen/' patName '/param_cost.mat'],'data')

% Perfusion Param
load(['./Results/AZ/Perfusion Liver Blood/' patName '/param_cost.mat'],'param')
perfBloodParam = param;
clear param
load(['./Results/AZ/Perfusion Liver Spleen 2/' patName '/param_cost.mat'],'param')
perfSpleenParam = param;
clear param

% Rat Param
load(['./Results/AZ/Rat Liver Spleen/' patName '/param_cost.mat'],'param')
ratSpleenParam = param;
clear param

% Whole-Body Param
load(['./Results/AZ/Whole-Body Liver Spleen/' patName '/param_cost.mat'],'param')
wbSpleenParam = param;
clear param

%% Plot Simulation
figA = figure('outerposition',[100,200,470,580]);
ax = gca; hold on

%%%%% Plot Data %%%%%
plot(ax, data.time, data.liver, 'ko', 'markerfacecolor','k', 'markersize',8); hold on

%%%%% Simulate Perfusion %%%%%
addpath('./CODE/Perfusion/sim and cost'); addpath('./CODE/Common Code');
simInput       = [data.time' data.vif' data.vif'];
perfBloodSim   = perfConv(perfBloodParam,simInput);
simInput       = [data.time' data.spleen' data.spleen'];
perfSpleenSim  = perfConvSpleenRat(perfSpleenParam,simInput);

%%%%% Simulate Rat %%%%%
addpath('./CODE/Ulloa/sim and cost')
simInput      = [data.time' data.spleen'];
ratSpleenSim  = ratConvRat(ratSpleenParam,simInput,'Liver');

%%%%% Simulate Whole-Body %%%%%
addpath('./CODE/Whole-Body/sim and cost'); addpath('./CODE/Whole-Body/models')
modelName = 'forsgren_Rat';
optModel = SBmodel([modelName '.txt']);
SBPDmakeMEXmodel(optModel,modelName);
[wbSpleenSim,~] = wholeBodySimLiverConc(wbSpleenParam,data.time',modelName,true);

%%%%% Plot Simulations %%%%%
plot(ax, data.time, ratSpleenSim,  '-', 'color',[ 0 1 1], 'linewidth',3);
plot(ax, data.time, perfSpleenSim, '-', 'color',[ 0 1 0], 'linewidth',3);
plot(ax, data.time, wbSpleenSim,   '-', 'color',[ 0 0 1], 'linewidth',3);


%%%%% Make Fugire Pretty %%%%%
set(ax,'fontsize',25);
xlabel('Time (min)', 'fontsize',25)
ylabel('Gadoxetate Concentration (mM)', 'fontsize',25)
legend('Data','Rat Spleen','Perfusion Spleen','Whole-Body Spleen','location','northeast'); legend('boxoff')
axis square
% title('Model Fits', 'fontsize',25, 'FontWeight','Bold')
ylim([0 0.5]); xlim([0 61*60]);
ax.TickDir = 'out'; ax.LineWidth = 3;
ax.XColor = 'black'; ax.YColor = 'black';
ax.FontName = 'Arial'; ax.FontWeight = 'Bold';
text(-370,0.46,'A', 'fontsize',35, 'FontWeight','Bold')
set(ax,'xtick',(0:10:60)*60, 'xticklabel',{'0','10','20','30','40','50','60'});



%% Load Param For Correlation

% Perfusion Blood Param
perfBloodKi = log(readAllKi('./Results/AZ/Perfusion Liver Blood/',4));

% Perfusion Spleen Param
perfSpleenKi  = log(readAllKi('./Results/AZ/Perfusion Liver Spleen 2/',4));
perfSpleenKi2 = perfSpleenKi; perfSpleenKi2([14,22]) = [];

% Rat Spleen Param
ratKi  = log(readAllKi('./Results/AZ/Rat Liver Spleen/',1));
ratKi2 = ratKi; ratKi2([14,22]) = [];

% Whole-Body Spleen Param
wbKi  = log(readAllKi('./Results/AZ/Whole-Body Liver Spleen/',3));
wbKi2 = wbKi; wbKi2([14,22]) = [];

%% Plot Correlation

axisLimit = [-8 1];

%%%%% Rat vs Whole-Body %%%%%
figB = figure('outerposition',[100,200,470,580]);
ax = gca; hold on
plot(axisLimit,axisLimit,'-','color','k','linewidth',3)
scatterPlotCorrelation(ax,ratKi,wbKi,'Patlak ln(k_i) (s^{-1})','Whole-Body ln(k_i) (s^{-1})', ...
    'doSquare', 'markerSize',13,...
    'fontSize',25, 'limX',axisLimit, 'limY',axisLimit)
%    'fontSize',25, 'limX',[0 axisLimit], 'limY',[0 axisLimit])
text(-5,-7,'R = 0.96', 'fontsize',25, 'FontWeight','Bold')
% text(-8.5,-3.45,'D', 'fontsize',35, 'FontWeight','Bold')
ax.TickDir = 'out'; ax.LineWidth = 3;
ax.XColor = 'black'; ax.YColor = 'black';
ax.FontName = 'Arial'; ax.FontWeight = 'Bold';
% title({'Patlak vs','Whole-Body'}, 'fontsize',25, 'FontWeight','Bold')

%%%%% Perf Spleen vs Rat %%%%%
figC = figure('outerposition',[100,200,470,580]);
ax = gca; hold on
plot(axisLimit,axisLimit,'-','color','k','linewidth',3)
scatterPlotCorrelation(ax,perfSpleenKi,ratKi,'Perfusion ln(k_i) (s^{-1})','Patlak ln(k_i) (s^{-1})', ...
    'doSquare', 'markerSize',13,...
    'fontSize',25, 'limX',axisLimit, 'limY',axisLimit)
text(-5,-7,'R = 0.91', 'fontsize',25, 'FontWeight','Bold')
% text(-8.5,-3.45,'E', 'fontsize',35, 'FontWeight','Bold')
ax.TickDir = 'out'; ax.LineWidth = 3;
ax.XColor = 'black'; ax.YColor = 'black';
ax.FontName = 'Arial'; ax.FontWeight = 'Bold';
% title({'Perfusion Spleen Input','vs Patlak'}, 'fontsize',25, 'FontWeight','Bold')

%%%%% Perf Spleen vs Whole-Body %%%%%
figD = figure('outerposition',[100,200,470,580]);
ax = gca; hold on
plot(axisLimit,axisLimit,'-','color','k','linewidth',3)
scatterPlotCorrelation(ax,perfSpleenKi,wbKi,'Perfusion ln(k_i) (s^{-1})','Whole-Body ln(k_i) (s^{-1})', ...
    'doSquare', 'markerSize',13,...
    'fontSize',25, 'limX',axisLimit, 'limY',axisLimit)
text(-5,-7,'R = 0.87', 'fontsize',25, 'FontWeight','Bold')
% text(-8.5,-3.45,'F', 'fontsize',35, 'FontWeight','Bold')
ax.TickDir = 'out'; ax.LineWidth = 3;
ax.XColor = 'black'; ax.YColor = 'black';
ax.FontName = 'Arial'; ax.FontWeight = 'Bold';
% title({'Perfusion Spleen Input','vs Whole-Body'}, 'fontsize',25, 'FontWeight','Bold')


%% Save figures
% figure(figA);
% print('Figure 4/Fig 4A', '-dtiff', '-r300');
% figure(figB);
% print('Figure 4/Fig 4B', '-dtiff', '-r300');
% figure(figC);
% print('Figure 4/Fig 4C', '-dtiff', '-r300');
% figure(figD);
% print('Figure 4/Fig 4D', '-dtiff', '-r300');




function ki = readAllKi(resultFolder,idx)

patFolders = dir(resultFolder); patFolders = patFolders(3:end);

for i  = 1:length(patFolders)
    if patFolders(i).isdir
        path = [resultFolder patFolders(i).name '/param_cost.mat'];
        load(path,'param')
        ki(i) = param(idx);
    end
end



