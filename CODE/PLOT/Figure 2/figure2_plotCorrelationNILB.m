function plotCorrelationNILB

%% Parameters
patName = 'Pat4';
axesSize = [0.34,0.34];
posA = [0.01,0.59]; posB = [0.33,0.59]; posC = [0.65,0.59];
posD = [0.01,0.08]; posE = [0.33,0.08]; posF = [0.65,0.08];


%% Load Data and Param For Simulation
load(['./Results/NILB/Perfusion Blood Gd 3/' patName '/param_cost.mat'],'data')
% Perfusion Param
load(['./Results/NILB/Perfusion Blood Gd 3/' patName '/param_cost.mat'],'param')
perfBloodParam = param;
clear param
load(['./Results/NILB/Perfusion Spleen Gd 2/' patName '/param_cost.mat'],'param')
perfSpleenParam = param;
clear param

% Rat Param
load(['./Results/NILB/Rat Spleen Gd 5/' patName '/param_cost.mat'],'param')
ratSpleenParam = param;
clear param

% Whole-Body Param
load(['./Results/NILB/Whole-Body Spleen Gd 7/' patName '/param_cost.mat'],'param')
wbSpleenParam = param;
clear param

%% Plot Simulation
figure('outerposition',[100,200,1600,1200])

ax = axes('Position',[posA,axesSize]); hold on

%%%%% Plot Data %%%%%
errorbar(ax,data.time,data.liver,data.liverSE, 'o', 'color', 'k', 'markerfacecolor','k',...
    'markersize',13, 'linewidth',3, 'CapSize',13);

%%%%% Simulate Perfusion %%%%%
addpath('./CODE/Perfusion/sim and cost'); 
addpath('./CODE/Common Code');

simInput       = [data.time' data.aif' data.vif'];
perfBloodSim   = perfConv(perfBloodParam,simInput);
simInput       = [data.time' data.spleen' data.spleen'];
perfSpleenSim  = perfConvSpleen(perfSpleenParam,simInput);

%%%%% Simulate Rat %%%%%
addpath('./CODE/Ulloa/sim and cost')
simInput      = [data.time' data.spleen'];
ratSpleenSim  = ratConv(ratSpleenParam,simInput,'Liver');

%%%%% Simulate Whole-Body %%%%%
addpath('./CODE/Whole-Body/sim and cost'); 
addpath('./CODE/Whole-Body/models')

modelName = 'forsgren';
optModel = SBmodel([modelName '.txt']);
SBPDmakeMEXmodel(optModel,modelName);
[wbSpleenSim,~] = wholeBodySimLiverConc(wbSpleenParam,data.time,modelName,true);

%%%%% Plot Simulations %%%%%
plot(ax, data.time, ratSpleenSim,  '-', 'color',[ 0 0 1], 'linewidth',3);
plot(ax, data.time, perfBloodSim,  '-', 'color',[ 0 1 0], 'linewidth',3);
plot(ax, data.time, perfSpleenSim, '-', 'color',[ 0 1 0], 'linewidth',3);
plot(ax, data.time, wbSpleenSim,   '-', 'color',[ 1 0 0], 'linewidth',3);


%%%%% Make Fugire Pretty %%%%%
set(ax,'fontsize',25);
xlabel('Time (s)', 'fontsize',25)
ylabel('Gadoxetate Concentration (mM)', 'fontsize',25)
legend('Data','Patlak Spleen','2-2CUM Blood','2-2CUM Spleen','Whole-Body Spleen','location','southeast'); legend('boxoff')
axis square
title('Model Fits', 'fontsize',25, 'FontWeight','Bold')
ylim([0 0.35]); xlim([0 31*60]);
ax.TickDir = 'out'; ax.LineWidth = 3;
ax.XColor = 'black'; ax.YColor = 'black';
ax.FontName = 'Arial'; ax.FontWeight = 'Bold';
text(-250,0.34,'A', 'fontsize',35, 'FontWeight','Bold')
set(ax,'xtick',(0:10:30)*60, 'xticklabel',{'0','10','20','30'});
set(ax,'ytick',0:0.1:0.3);



%% Load Param For Correlation

% Perfusion Blood Param
perfBloodKi = readAllKi('./Results/NILB/Perfusion Blood Gd 3/',4);

% Perfusion Spleen Param
perfSpleenKi = readAllKi('./Results/NILB/Perfusion Spleen Gd 2/',4);

% Rat Spleen Param
ratKi = readAllKi('./Results/NILB/Rat Spleen Gd 5/',1);

% Whole-Body Spleen Param
wbKi = readAllKi('./Results/NILB/Whole-Body Spleen Gd 7/',3);

%% Plot Correlation

axisLimit  = 80e-4;
letterPosX = -12e-4; letterPosY = 77e-4;
RposX      = 15e-4;  RposY      = 7e-4;

%%%%% PerfBlood vs Rat %%%%%
ax = axes('Position',[posB,axesSize]); hold on
plot([0 axisLimit],[0 axisLimit],'-','color','k','linewidth',3)
scatterPlotCorrelation(ax,perfBloodKi,ratKi,'2-2CUM k_i (s^{-1})','Patlak k_i (s^{-1})', ...
    'doSquare', 'markerSize',13,...
    'fontSize',25, 'limX',[0 axisLimit], 'limY',[0 axisLimit])
text(RposX,RposY,'R = 0.50', 'fontsize',25, 'FontWeight','Bold')
text(letterPosX,letterPosY,'B', 'fontsize',35, 'FontWeight','Bold')
ax.TickDir = 'out'; ax.LineWidth = 3;
ax.XColor = 'black'; ax.YColor = 'black';
ax.FontName = 'Arial'; ax.FontWeight = 'Bold';
ax.YTick = (0:2:8)*1e-3;
title({'2-2CUM Blood Input','vs Patlak'}, 'fontsize',25, 'FontWeight','Bold')

%%%%% PerfBlood vs Whole-Body %%%%%
ax = axes('Position',[posC,axesSize]); hold on
plot([0 axisLimit],[0 axisLimit],'-','color','k','linewidth',3)
scatterPlotCorrelation(ax,perfBloodKi,wbKi,'2-2CUM k_i (s^{-1})','Whole-Body k_i (s^{-1})', ...
    'doSquare', 'markerSize',13,...
    'fontSize',25, 'limX',[0 axisLimit], 'limY',[0 axisLimit])
text(RposX,RposY,'R = 0.32', 'fontsize',25, 'FontWeight','Bold')
text(letterPosX,letterPosY,'C', 'fontsize',35, 'FontWeight','Bold')
ax.TickDir = 'out'; ax.LineWidth = 3;
ax.XColor = 'black'; ax.YColor = 'black';
ax.FontName = 'Arial'; ax.FontWeight = 'Bold';
ax.YTick = (0:2:8)*1e-3;
title({'2-2CUM Blood Input','vs Whole-Body'}, 'fontsize',25, 'FontWeight','Bold')

%%%%% Rat vs Whole-Body %%%%%
ax = axes('Position',[posD,axesSize]); hold on
plot([0 axisLimit],[0 axisLimit],'-','color','k','linewidth',3)
scatterPlotCorrelation(ax,ratKi,wbKi,'Patlak k_i (s^{-1})','Whole-Body k_i (s^{-1})', ...
    'doSquare', 'markerSize',13,...
    'fontSize',25, 'limX',[0 axisLimit], 'limY',[0 axisLimit])
text(RposX,RposY,'R = 0.81', 'fontsize',25, 'FontWeight','Bold')
text(letterPosX,letterPosY,'D', 'fontsize',35, 'FontWeight','Bold')
ax.TickDir = 'out'; ax.LineWidth = 3;
ax.XColor = 'black'; ax.YColor = 'black';
ax.FontName = 'Arial'; ax.FontWeight = 'Bold';
ax.YTick = (0:2:8)*1e-3;
title({'Patlak vs','Whole-Body'}, 'fontsize',25, 'FontWeight','Bold')

%%%%% PerfSpleen vs Rat %%%%%
ax = axes('Position',[posE,axesSize]); hold on
plot([0 axisLimit],[0 axisLimit],'-','color','k','linewidth',3)
scatterPlotCorrelation(ax,perfSpleenKi,ratKi,'2-2CUM k_i (s^{-1})','Patlak k_i (s^{-1})', ...
    'doSquare', 'markerSize',13,...
    'fontSize',25, 'limX',[0 axisLimit], 'limY',[0 axisLimit])
text(RposX,RposY,'R = 0.89', 'fontsize',25, 'FontWeight','Bold')
text(letterPosX,letterPosY,'E', 'fontsize',35, 'FontWeight','Bold')
ax.TickDir = 'out'; ax.LineWidth = 3;
ax.XColor = 'black'; ax.YColor = 'black';
ax.FontName = 'Arial'; ax.FontWeight = 'Bold';
ax.YTick = (0:2:8)*1e-3;
title({'2-2CUM Spleen Input','vs Patlak'}, 'fontsize',25, 'FontWeight','Bold')

%%%%% PerfSpleen vs Whole-Body %%%%%
ax = axes('Position',[posF,axesSize]); hold on
plot([0 axisLimit],[0 axisLimit],'-','color','k','linewidth',3)
scatterPlotCorrelation(ax,perfSpleenKi,wbKi,'2-2CUM k_i (s^{-1})','Whole-Body k_i (s^{-1})', ...
    'doSquare', 'markerSize',13,...
    'fontSize',25, 'limX',[0 axisLimit], 'limY',[0 axisLimit])
text(RposX,RposY,'R = 0.78', 'fontsize',25, 'FontWeight','Bold')
text(letterPosX,letterPosY,'F', 'fontsize',35, 'FontWeight','Bold')
ax.TickDir = 'out'; ax.LineWidth = 3;
ax.XColor = 'black'; ax.YColor = 'black';
ax.FontName = 'Arial'; ax.FontWeight = 'Bold';
ax.YTick = (0:2:8)*1e-3;
title({'2-2CUM Spleen Input','vs Whole-Body'}, 'fontsize',25, 'FontWeight','Bold')



end


function ki = readAllKi(resultFolder,idx)

patFolders = dir(resultFolder); patFolders = patFolders(3:end);
n = 1;
for i  = 1:length(patFolders)
    if patFolders(i).isdir
        path = [resultFolder patFolders(i).name '/param_cost.mat'];
        load(path,'param')
        ki(n) = param(idx);
        n = n+1;
    end
end

end



