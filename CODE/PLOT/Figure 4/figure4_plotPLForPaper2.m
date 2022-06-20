function plotPLForPaper2

patName = 'Pat17';
axesSize1 = [0.35,0.23];  axesSize2 = [0.45,0.87];
posA = [0.07 0.73]; posB = [0.07,0.41]; 
posC = [0.07,0.09]; posD = [0.48,0.09];
figure('outerposition',[100,200,1000,800])

%% Load 
plFolder = './Results/NILB/Profile Likelihood/Small Limit/';

% Perfusion
load([plFolder 'Perfusion/' patName '_PL_perf.mat'],'plResult')
perfResult = plResult;

% Rat
load([plFolder 'Rat/' patName '_PL_rat.mat'],'plResult')
ratResult = plResult;

% Whole-Body
load([plFolder 'Whole-Body/' patName '_PL_wb.mat'],'plResult')
wbResult = plResult;

%% Plot 

mColor1 = [ 1 0  0];
mColor2 = [ 0 1  0];
mColor3 = [ 0 0  1];

% Rat
ax        = axes('Position',[posA,axesSize1]); hold on
titleName = 'Patlak';
helper(ratResult,1,ax,titleName,mColor1)
% text(0.4e-3,7.25,'A', 'fontsize',25, 'FontWeight','Bold')
ax.YTick = 2:8;
ylim([2.8 7.3])


% Perfusion
ax        = axes('Position',[posB,axesSize1]); hold on
titleName = 'Perfusion';
helper(perfResult,4,ax,titleName,mColor2)
% text(0.4e-3,6,'B', 'fontsize',25, 'FontWeight','Bold')
ax.YTick = 0:6;


% Whole-Boody
ax        = axes('Position',[posC,axesSize1]); hold on
titleName = 'Whole-Body';
helper(wbResult,3,ax,titleName,mColor3)
% text(0.39e-3,7,'C', 'fontsize',25, 'FontWeight','Bold')
ax.YTick = 2:7;
ylim([2 7])


% All Intrevals
ax        = axes('Position',[posD,axesSize2]); hold on
plotIntervalsKiAllModels(ax)
ax.FontSize = 20;    ax.YColor = [1,1,1];
ax.XScale   = 'log'; ax.YTick  = [];
ax.TickDir = 'out'; ax.LineWidth = 2;
ax.FontName = 'Arial'; ax.FontWeight = 'Bold';
ax.YLim  = [.5 35.5];   ax.XLim   = [1e-5 1e-0];
ax.XTick = 10.^(-4:2:0);
% title('All Intervals','fontsize',20); 
label = xlabel('k_{i} (s^{-1})');
label.Units = 'normalized';
label.Position(2) = -0.030;  label.Position(1) = 0.45;


function helper(plResult,num,ax,titleName,color)

pVals      = plResult(num).paramValues;
costVals   = plResult(num).costValues;
pName      = plResult(num).pName;
startCost  = plResult(num).startCost;
startParam = plResult(num).startFixedVal;
chiLimit   = plResult(num).limit;

[sortedParam,I] = sort(pVals);
sortedCost = costVals(I);

% Gor from log-space to normal-space
sortedParam = exp(sortedParam);
startParam  = exp(startParam);

plot(ax,sortedParam,sortedCost,'-',  'color',  color ,           'linewidth',3);

if ~isempty(chiLimit) % If a chi2-limit exists
    h(1) = plot(ax,sortedParam([1 end]),[chiLimit chiLimit],'-', 'color',[0,0,0], 'linewidth',3);
end

set(ax, 'fontsize',20, 'xscale','log')
label = xlabel('k_{i} (s^{-1})');
label.Units = 'normalized';
label.Position(2) = -0.10;
ylabel('Cost')

ax.TickDir = 'out'; ax.LineWidth = 2;
ax.XColor = 'black'; ax.YColor = 'black';
ax.FontName = 'Arial'; ax.FontWeight = 'Bold';
%title(titleName, 'fontsize',20)
% xlim([0.95e-3 2.1e-3])
xlim([0.6e-3 2e-2])

