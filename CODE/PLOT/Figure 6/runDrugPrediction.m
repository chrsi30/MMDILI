clear all

patName = 'Pat15';

% Add Paths
addpath('./CODE/Ulloa/sim and cost/')
addpath('./CODE/Common Code/')

% Load rat DR-param
load('./Results/AZ Rat/ulloa/NLME-IC50/param_cost.mat','DRki','DRkef')
ratDRki  = DRki;
ratDRkef = DRkef;
clear DRki DRkef

% Load param and data from NILB-patient
load(['./Results/NILB/Rat Spleen Gd 4/' patName '/param_cost.mat'],'param','data')

% Dose-Response Function
% p = [max min IC50 hill]
DRFun = @(p,dose) p(2) + (p(1)-p(2)) ./ (1 + (p(3)./dose).^p(4));

% Funktion reduction in rats
reductionKi  = ratDRki(2)/ratDRki(1);
reductionKef = ratDRkef(2)/ratDRkef(1);

% New DR-param (ki)
maxKi   = param(1);
minKi   = param(1)*reductionKi;
IC50ki  = ratDRki(3);
hillKi  = ratDRki(4);
newDRKi = [maxKi minKi IC50ki hillKi];

% New DR-param (kef)
maxKef   = param(2);
minKef   = param(2)*reductionKef;
IC50kef  = ratDRkef(3);
hillKef  = ratDRkef(4);
newDRKef = [maxKef minKef IC50kef hillKef];

% Calc new param and Plot fit
figure(1)

ax = gca; hold on
dose = 0:1:100;
for i = 1:length(dose)
    newParam(i,:) = [DRFun(newDRKi,dose(i)) DRFun(newDRKef,dose(i))];
end

% Do Plotting
h = ratPlotFitDR(newParam,data,'ratConv','Liver',data.time,ax);

% Make Figure Pretty
ax = gca;
ax.FontSize = 25;      
ax.XLim = [-1 30.5*60]; ax.YLim = [0 0.63];
ax.TickDir = 'out';     ax.LineWidth = 3;
ax.XColor = 'black';    ax.YColor = 'black';
ax.FontName = 'Arial';  ax.FontWeight = 'Bold';
ax.YTick = 0:0.1:0.6;
legend(h(1:20:101), sprintfc('%d mg/kg',dose(1:20:101)), 'Location','northwest',...
    'Orientation','horizontal', 'NumColumns',2, 'fontweight','normal');
legend('boxoff')

%title('Prediction of Liver Function', 'fontweight','bold', 'fontsize',22)
ylabel('Gadoxetate Concentration (mM)')


