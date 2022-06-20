clear all

% Add Paths

% Dose-Response Function
% p = [max min IC50 hill]
DRFun = @(p,dose) p(2) + (p(1)-p(2)) ./ (1 + (p(3)./dose).^p(4));

efficacyParam = [1,0,30,5];

% Calc new param for one patient
ax = gca; hold on
dose = 0:1:2000;
for i = 1:length(dose)
    efficacy(i)  = DRFun(efficacyParam, dose(i));
end

% Our limit for "minimal efficacy"
limit = 0.40;

% Plot Normal and Bad Area
fill(ax,[4.05,4.05,200,200], [limit,0.0045,0.0045,limit],[.8,.8,.8], 'edgecolor','none')


% Plot limit
plot(ax,dose,ones(size(dose))*limit,'k--','linewidth',3);
text(31,0.445, {'Required efficacy'}, 'fontsize',25)
% Coalc srossing with limit
[~,cross1] = min(abs(efficacy-limit));
% Plot crossin line
plot(ax, [cross1-1,cross1-1], [0,efficacy(cross1)], ':', 'color',[ 0 1 1], 'linewidth',3);

% Plot All Max ki
% plot(ax,ones(1,nPat), oldKi, 'ko', 'markerfacecolor',markusColor(1), 'markersize',10);

% Plot dosepresonse for efficacy
plot(ax, dose,efficacy, '-', 'color',[0 1 1], 'linewidth',3);

% Make Figure Pretty
ax.FontSize = 25;      
ax.XLim = [4 200];     ax.YLim = [0 1];
ax.TickDir = 'out';      ax.LineWidth = 3;
ax.XColor = 'black';     ax.YColor = 'black';
ax.FontName = 'Arial';   ax.FontWeight = 'Bold';
ax.XScale = 'log';
ax.YTick = 0:0.5:1.;     ax.YTickLabel = {'0','50','100'};
ax.XTick = ([4 10 100]);        ax.XTickLabel = {'0','10^1','10^2'};

%title('Prediction of Liver Function', 'fontweight','bold', 'fontsize',22)
ylabel('Efficacy (% Max)'); 
xlabel('Dose (mg/kg)')


% Add X-Axis Break
annotation('rectangle', [0.16,0.152,  0.021,0.02],'facecolor',[.8,.8,.8], 'edgecolor','none');
annotation('rectangle', [0.16,0.132,  0.021,0.02],'facecolor','w'       , 'edgecolor','none');
annotation('line',      [0.17,0.15], [0.18,0.13], 'linewidth',3);
annotation('line',      [0.19,0.17], [0.18,0.13], 'linewidth',3);


