function varargout = ratPlotFitDR(param,data,varargin)
%
% ratPlotFitDR(param,data)
% ratPlotFitDR(param,data,modelName)
% ratPlotFitDR(param,data,modelName,signalType)
% ratPlotFitDR(param,data,modelName,signalType,simTime)
% ratPlotFitDR(param,data,modelName,signalType,simTime,ax)
%

%% Fix Inputs

if nargin < 6
    figure('outerposition',[500 500 650 500]);
    ax = gca; hold on
else
    ax = varargin{4};
end

if nargin < 5
    simTime = data.time;%0:4000;
else
    simTime = varargin{3};
end

if nargin < 4
    signalType = 'Liver';
else
    signalType = varargin{2};
end

if nargin < 3
    modelName = 'ratConv';
else
    modelName = varargin{1};
end


%% Fix Data and Input
switch signalType
    case {'Liver','Hep'} % Use spleen as input data
        simInput = [data.time' data.spleen'];
    case {'Liver_VIF','Hep_VIF'}  % Use portal vein as input data
        simInput = [data.time' data.vif'];
    case 'Liver_AIF'     % Use portal vein as input data
        simInput = [data.time' data.aif'];
end

% Remove a-fas and v-fas
idx = (data.time == 30 | data.time == 38 | data.time == 46);
data.time(idx)   = [];
data.liver(idx)  = []; data.liverSE(idx)  = [];
data.spleen(idx) = []; data.spleenSE(idx) = [];


switch signalType
    case {'Hep','Hep_VIF'}
        dataLiver = data.hep;
        label = {'Gd Concentration (mM)','Liver'};
    case {'Liver','Liver_VIF','Liver_AIF'}
        dataLiver   = data.liver;
        dataLiverSE = data.liverSE;
        label = {'Gd Concentration (mM)','Liver'};
end


%% Plot

% Plot Data
errorbar(ax,data.time,dataLiver,dataLiverSE, 'ko', 'markerfacecolor','k',...
    'markersize',9, 'linewidth',2);

nSets = size(param,1);
%colors = colorSpectrum(nSets);
colors = myColors(nSets);

for i = 1:nSets
    simParam = param(i,:);
    simLiver = feval(modelName,simParam,simInput,signalType);
    h(i) = plot(ax,simTime,simLiver, '-', 'color', colors(i,:), 'linewidth',2);
end

fixAxes(ax,label);

if nargout == 1
    varargout{1} = h;
end

%%%%%%%%%%%%%%%
%%% fixAxes %%%
%%%%%%%%%%%%%%%

function fixAxes(ax,label)

currentYmalx = get(gca,'ylim'); currentYmalx = currentYmalx(2);

set(ax, 'xtick',0:10*60:40*60, 'xticklabel',{'0','10','20','30','40'},...
    'fontsize',20, 'ylim',[0 max(0.4,currentYmalx)])
ylabel(label{1}); xlabel('Time (min)');
legend(label{2})


function colors = myColors(n)

red = [ 1 0 0];
purple = [ 1 0.2 0.5];

colors = [linspace(red(1),purple(1),n)', linspace(red(2),purple(2),n)', linspace(red(3),purple(3),n)'];

for i = 1:n
plot(i,1,'o','color',colors(i,:),'markerfacecolor',colors(i,:),'markersize',10); hold on
end






















