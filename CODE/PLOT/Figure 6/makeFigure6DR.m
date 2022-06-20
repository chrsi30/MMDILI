clear all

% Add Paths
addpath('./CODE/Ulloa/sim and cost/')
addpath('./CODE/Common Code/')

% Load rat DR-param
load('./Results/AZ Rat/ulloa/NLME-IC50/param_cost.mat','DRki','DRkef')
% Load data in old format
ratDRki  = DRki;
ratDRkef = DRkef;
clear DRki DRkef

% Load param and data from NILB-patient
paramFolder = './Results/NILB/Rat Spleen Gd 4/';
oldKi       = readAllKi(paramFolder,1);
nPat        = length(oldKi);

% Dose-Response Function
% p = [max min IC50 hill]
DRFun = @(p,dose) p(2) + (p(1)-p(2)) ./ (1 + (p(3)./dose).^p(4));

% Funktion reduction in rats
reductionKi  = ratDRki(2)/ratDRki(1);
reductionKef = ratDRkef(2)/ratDRkef(1);

% New DR-param (ki)
for i = 1:nPat
    maxKi(i)     = oldKi(i);
    minKi(i)     = oldKi(i)*reductionKi;
    IC50ki       = ratDRki(3);
    hillKi       = ratDRki(4);
    newDRKi(i,:) = [maxKi(i) minKi(i) IC50ki hillKi];
end


% Calc new param for one patient
%fig = figure('outerposition',[200 200 700 600]); 

ax = gca; hold on
pat = [1 15 25];
dose = 0:1:2000;
for i = 1:length(dose)
    newParam1(i) = DRFun(newDRKi(pat(1),:), dose(i));
    newParam2(i) = DRFun(newDRKi(pat(2),:), dose(i));
    newParam3(i) = DRFun(newDRKi(pat(3),:), dose(i));
end

% Our limit for "normal function"
limit = 0.0012;

% Plot Normal and Bad Area
fill([3.86,3.86,700,700], [limit,.013e-3,.013e-3,limit],[.8,.8,.8], 'edgecolor','none')

% Plot limit
plot(ax,dose,ones(size(dose))*limit,'k--','linewidth',3);
text(50,0.00138, {'Normal Liver Function'}, 'fontsize',25, 'fontname','Arial')
text(50,0.001, {'Reduced Liver Function'}, 'fontsize',25, 'fontname','Arial')
% Coalc srossing with limit
[~,cross1] = min(abs(newParam1-limit));
[~,cross2] = min(abs(newParam2-limit));
[~,cross3] = min(abs(newParam3-limit));
% Plot crossin line
plot(ax, [cross1-1,cross1-1], [0,newParam1(cross1)], ':', 'color',[ 1 0 0], 'linewidth',3);
plot(ax, [cross2-1,cross2-1], [0,newParam2(cross2)], ':', 'color',[ 0 1 0], 'linewidth',3);
plot(ax, [cross3-1,cross3-1], [0,newParam3(cross3)], ':', 'color',[ 0 0 1], 'linewidth',3);

% Plot dosepresonse for special ki
plot(ax, dose,newParam1, '-', 'color',[ 1 0 0], 'linewidth',3);
plot(ax, dose,newParam2, '-', 'color',[ 0 1 0], 'linewidth',3);
plot(ax, dose,newParam3, '-', 'color',[ 0 0 1], 'linewidth',3);
% Replot the special ki
plot(ax, 4, oldKi(pat(1)), 'ko', 'markerfacecolor',[ 1 0 0], 'markersize',10);
plot(ax, 4, oldKi(pat(2)), 'ko', 'markerfacecolor',[ 0 1 0], 'markersize',10);
plot(ax, 4, oldKi(pat(3)), 'ko', 'markerfacecolor',[ 0 0 1], 'markersize',10);



% Make Figure Pretty
ax.FontSize = 25;      
ax.XLim = [3.8 600];  ax.YLim = [0 4.2e-3];
ax.TickDir = 'out';      ax.LineWidth = 3;
ax.XColor = 'black';     ax.YColor = 'black';
ax.FontName = 'Arial';   ax.FontWeight = 'Bold';
ax.XScale = 'log';
ax.YTick = (0:1:4)*1e-3; 
ax.XTick = ([4,1e1,1e2]); ax.XTickLabel = {'0','10^{1}','10^{2}'};

%title('Prediction of Liver Function', 'fontweight','bold', 'fontsize',22)
ylabel('k_i (s^{-1})'); 
xlabel('Dose (mg/kg)')

% Add X-Axis Break
%fill([4.2,4.2,5.1,5.1],[2e-4,0,0,2e-4], [.9,.9,.9], 'edgecolor','none')
annotation('rectangle', [0.16,0.152,0.021,0.02],'facecolor',[.8,.8,.8], 'edgecolor','none');
annotation('rectangle', [0.16,0.132,0.021,0.02],'facecolor','w'       , 'edgecolor','none');
annotation('line', [0.17,0.15], [0.18, 0.13], 'linewidth',3);
annotation('line', [0.19,0.17], [0.18, 0.13], 'linewidth',3);


% print('/Volumes/homes/marka/Model Comparison/Results/Figures For Paper/Fig 7A_2', '-dtiff', '-r300');