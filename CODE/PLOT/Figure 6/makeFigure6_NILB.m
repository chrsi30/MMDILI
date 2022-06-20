clear all 

load('./CODE/PLOT/Figure 6/NILB_uptake.mat');

% Calc new param for one patient
%fig = figure('outerposition',[200 200 700 600]);

ax = gca; hold on

plot(ax,1,F0,'ko', 'markerfacecolor',[ 0 1 0 ], 'markersize',10);
plot(ax,2,F1,'ko', 'markerfacecolor',[ 0 1 0 ], 'markersize',10);
plot(ax,3,F2,'ko', 'markerfacecolor',[ 0 1 0 ], 'markersize',10);
plot(ax,4,F3,'ko', 'markerfacecolor',[ 0 1 0 ], 'markersize',10);
plot(ax,5,F4,'ko', 'markerfacecolor',[ 0 1 0 ], 'markersize',10);

ax.FontSize = 25;      
ax.YLim = [0 6e-3];     ax.XLim = [-1.1 5.7];
ax.TickDir = 'out';     ax.LineWidth = 3;
ax.XColor = 'black';    ax.YColor = 'black';
ax.FontName = 'Arial';  ax.FontWeight = 'Bold';
ax.YTick = (0:6)*1e-3;
ax.XTick = (1:5);       ax.XTickLabel = {'No Fibrosis       ','F1','F2','F3','F4'};

ylabel('k_i (s^{-1})'); 
xlabel('Fibrosis Stage');

