function runDR

axesSize = [0.25,0.35];
posA = [0.05,0.58]; posB = [0.3775,0.58]; posC = [0.71,0.58];
posD = [0.05,0.09]; posE = [0.3775,0.09]; posF = [0.71,0.09];
figSizie = [100,200,500,500];

%% Load 
% Load Param
load('./Results/AZ Rat/ulloa/NLME-IC50/param_cost.mat') 
% Load data in old format
load('./CODE/PLOT/Figure 5/AZData.mat')

%% Plot Shit

% Corrected ki
figA = figure('outerposition',figSizie);
ax = gca; hold on
plotParam(param(:,1),individData,'k_i',ax);
ax.YAxis.Exponent = -2;
ax.YLim = [0 5e-2];


% DR-curve ki
figB = figure('outerposition',figSizie);
ax = gca; hold on
plotParamDR(param(:,1),DRki,individData,'k_i',ax)
ax.YAxis.Exponent = -2;
ax.YLim = [0 5e-2];

% Pat variations ki
figC = figure('outerposition',figSizie);
ax = gca; hold on
plotParam(uncorrecteParam(:,1),individData,'k_i',ax);
ax.YAxis.Exponent = -2;
ax.YLim = [-2.5e-2 2.5e-2];


% Corrected kef
figD = figure('outerposition',figSizie);
ax = gca; hold on
plotParam(param(:,2),individData,'k_{ef}',ax);
ax.YLim = [0 5e-3];

% DR-curve kef
figE = figure('outerposition',figSizie);
ax = gca; hold on
plotParamDR(param(:,2),DRkef,individData,'k_{ef}',ax)
ax.YLim = [0 5e-3];

% Pat variations kef
figF = figure('outerposition',figSizie);
ax = gca; hold on
plotParam(uncorrecteParam(:,2),individData,'k_{ef}',ax);
ax.YLim = [-2.5e-3 2.5e-3];


function plotParam(param,data,pName,ax)

groups = [data.group]';
nGroups = length(unique(groups));

doses = [1 20 50 200 2000];
allDoses = doses(groups);
labels = {'0', '20', '50', '200', '2000'};
%colors = [ 1 1 1] %colorSpectrum(nGroups);

for g = 1:nGroups
    idx = groups==g;
    n = sum(idx);
    plot(ax, ones(1,n)*g, param(idx), 'ko', 'markerfacecolor',[ 0 0 1],...
        'markersize',14)
    hold on
end
set(ax, 'fontsize',24,  'xscale','lin', 'xtick',1:nGroups, 'xticklabel',labels); % 
xlabel('Dose (mg/kg)'); ylabel([pName ' (s^{-1})'])
%title(pName, 'fontsize',24, 'FontWeight','Bold')
xlim([0 nGroups+1]);
ax.TickDir = 'out'; ax.LineWidth = 3;
ax.XColor = 'black'; ax.YColor = 'black';
ax.FontName = 'Arial'; ax.FontWeight = 'Bold';



function plotParamDR(modelParam,DRParam,data,pName,ax)

groups = [data.group]';
nGroups = length(unique(groups));

doses = [1 20 50 200 2000];
allDoses = doses(groups);
%colors = colorSpectrum(nGroups);

% % Plot DR-curve % %

DRFun = @(p,x) p(2) + (p(1)-p(2)) ./ (1 + (p(3)./x).^p(4));

% Plot IC50
halfActivity = DRParam(2) + (DRParam(1)-DRParam(2))/2;
plot(ax,[DRParam(3),DRParam(3)],[0,halfActivity],'-', 'color',[.50 .50 .50],'linewidth',3)
plot(ax,[0.9,DRParam(3)],[halfActivity,halfActivity],'-', 'color',[.50 .50 .50],'linewidth',3)

% Plot dose-respons-curve
x = logspace(log10(0.9),log10(3000),5000);
plot(ax,x,DRFun(DRParam,x),'-k', 'linewidth',3)

% % Plot Data Points % %

for g = 1:nGroups
    idx = groups==g;
    n = sum(idx);
    plot(ax, ones(1,n)*doses(g), modelParam(idx), 'ko', 'markerfacecolor',[ 0 0 1],...
        'markersize',14)
    hold on
end
set(ax, 'fontsize',24,  'xscale','log');
xlabel('Dose (mg/kg)'); ylabel([pName ' (s^{-1})'])
% title(pName, 'fontsize',24, 'FontWeight','Bold')
xlim([0.9 3000])
ax.TickDir = 'out'; ax.LineWidth = 3;
ax.XColor = 'black'; ax.YColor = 'black';
ax.FontName = 'Arial'; ax.FontWeight = 'Bold';
ax.XTick = 10.^([0,1,2,3]); ax.XTickLabel = {'0','10^1','10^2','10^3'};


% Add X-Axis Break
annotation('line', [0.22,0.20], [0.19,0.14], 'linewidth',10, 'color','w');
annotation('line', [0.21,0.19], [0.19,0.14], 'linewidth',3);
annotation('line', [0.23,0.21], [0.19,0.14], 'linewidth',3);

