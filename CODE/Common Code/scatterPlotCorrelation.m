function scatterPlotCorrelation(varargin)
% scatterPlotCorrelation(X,Y,labelX,labelY,...)
%
% scatterPlotCorrelation(ax,X,Y,labelX,labelY,...)
%
% Name-Pair arguments: doRegLine, doR, doTextBox, scaleType, doLegend,
% legendLocation, predInt, limY, limX, markerSize, markerColor, fontSize, 
% title, doSquare, doEqual, doUnity, unityScale, differentMarkers, labels
%

doR = false;
scaleType = {'lin','lin'};
doLegend = false;
legendLocation = 'EastOutside';
doPredInt = false;
doLimY = false;
doLimX = false;
doRegLine = false;
doRegLineRange = false;
markerSize = 8;
fontSize = 20;
doSquare = false;
doEqual = false;
doUnity = false;
unityScale = 1;
doTextBox = false;
markerColor = [ 0 1 0];
doDifferentMarkers = false;
doDifferentColors = false;
doLabels = false;


if nargin < 4
    error('scatterPlotCorrelation: Not enough arguments')
end

if ishandle(varargin{1})
    ax = varargin{1};
    axArg = 1; 
else
    figure;
    ax = gca;
    axArg = 0;
end

X = varargin{1+axArg};
Y = varargin{2+axArg};
labelX = varargin{3+axArg};
labelY = varargin{4+axArg};

if nargin > 4+axArg
    i = 5+axArg;
    while i <= nargin
        switch varargin{i}
            case 'doRegLine'
                doRegLine = true;
                i = i+1;
            case 'regLineRange'
                doRegLineRange = true;
                range = varargin{i+1};
                i = i+2;
            case 'doR'
                doR = true;
                i = i+1;
            case 'doTextBox'
                doTextBox = true;
                i = i+1;
            case 'scaleType'
                scaleType = varargin{i+1};
                i = i+2;
            case 'legendLocation'
                legendLocation = varargin{i+1};
                i = i+2;
            case 'doLegend'
                doLegend = true;
                i = i+1;
            case 'predInt'
                doPredInt = true;
                i = i+1;
            case 'limY'
                doLimY = true;
                limY = varargin{i+1};
                i = i+2;
            case 'limX'
                doLimX = true;
                limX = varargin{i+1};
                i = i+2;
            case 'markerSize'
                markerSize = varargin{i+1};
                i = i+2;
            case 'markerColor'
                markerColor = varargin{i+1};
                i = i+2;
            case 'fontSize'
                fontSize = varargin{i+1};
                i = i+2;
            case 'title'
                axTitle = varargin{i+1};
                i = i+2;
            case 'doSquare'
                doSquare = true;
                i = i+1;
            case 'doEqual'
                doEqual = true;
                i = i+1;
            case 'doUnity'
                doUnity = true;
                i = i+1;
            case 'unityScale'
                unityScale = varargin{i+1};
                i = i+2;
            case 'differentMarkers'
                doDifferentMarkers = true;
                group = varargin{i+1};
                allStyles = varargin{i+2};
                i = i+3;
            case 'differentColors'
                doDifferentColors = true;
                group = varargin{i+1};
                allColors = varargin{i+2};
                i = i+3;
            case 'labels'
                doLabels = true;
                labels = varargin{i+1};
                i = i+2;
            otherwise
                error(['scatterPlotCorrelation: Wrong argument ' varargin{i}])
        end
    end
end

% Check if X and Y are of equal length
if length(X) ~= length(Y)
    error('scatterPlotCorrelation:argChk', 'X and Y must be same length')
end
% Make sure X and Y are both column/row vectors
if ~all(size(X)==size(Y))
    Y = Y';
end

if doRegLine || doR
    % Regression Line
    [model,gof] = fit(X,Y,'poly1');
    R = sqrt(gof.rsquare);
    if ~doRegLineRange
        range = min(X):(max(X)-min(X))/100:max(X);
    end
    hold on
    curve = model(range);
    if doRegLine
        h4 = plot(ax,range,curve,'-','linewidth',3,'color',markusColor(4));
    end
    
    % Confidence Interval
    if doPredInt
        ci = predint(model,range,0.95);
        h5 = plot(ax,range,ci(:,1),'--','linewidth',3,'color',markusColor(4));
        plot(ax,range,ci(:,2),'--','linewidth',3,'color',markusColor(4));
    end
end

% Unity line
if doUnity
   first = min([X(:); Y(:)]);
   last = max([X(:); Y(:)]);
   h5 = plot(ax,[first last],[first unityScale*last],'-','linewidth',3,'color',[ 0 0 0]);
   hold on
end

% If doLabels are chosen, we will write lablels insetead of regular points
% in the scatter plot
if ~doLabels 
    if ~doDifferentMarkers && ~doDifferentColors
        h1 = plot(ax,X,Y,'ko','markerfacecolor',markerColor,'markersize',markerSize);
    elseif doDifferentMarkers
        nGroups = length(allStyles);
        groups = unique(group);
        hold on
        for i = 1:nGroups
            style = allStyles{i};
            newX = X(group==groups(i));
            newY = Y(group==groups(i));
            h1(i) = plot(ax,newX,newY,['k' style(1)], 'markerfacecolor',style(2), 'markersize',markerSize);
        end
    elseif doDifferentColors
        %nGroups = size(allColors,1);
        groups = unique(group);
        nGroups = length(groups);
        hold on
        for i = 1:nGroups
            color = allColors(i,:);
            newX = X(group==groups(i));
            newY = Y(group==groups(i));
            h1(i) = plot(ax,newX,newY,'ko', 'markerfacecolor',color, 'markersize',markerSize);
        end
    end
else
    axis(ax)
    lscatter(X,Y,labels)
end
    
    
% Figure Properties
set(ax,'fontsize',fontSize)
ylabel(labelY)
xlabel(labelX)
set(ax,'XScale',scaleType{1},'YScale',scaleType{2})
if doLimX
    xlim(limX);
end
if doLimY
    ylim(limY);
end
if exist('axTitle','var')
    title(axTitle);
end
if doEqual
    low = min([X(:); Y(:)])*0.9;
    high = max([X(:); Y(:)])*1.1;
    ylim([low high]);
    xlim([low high]);
end
if doSquare
    axis square
end
if doEqual
    yTick = get(ax,'ytick');
    set(ax,'ytick',yTick,'fontsize',fontSize-2)
    set(ax,'xtick',yTick,'fontsize',fontSize-2)
end

% Legend
if doLegend
    if doR && doPredInt
        legend([h4 h5],sprintf('R = %0.2f',R),...
            'Prediction Interval',...
            'location',legendLocation);
    elseif doR && ~doPredInt
        legend(h4,sprintf('R = %0.2f',R),...
            'location',legendLocation);
    elseif ~doR && doPredInt
        legend([h4 h5],'Calibration',...
            'Prediction Interval',...
            'location',legendLocation);
    elseif ~doR && ~doPredInt
        legend(h4,'Calibration',...
            'location',legendLocation);
    end
end

% Text Box with corrlation and/or regression coefficients
if doR && doTextBox
    text(max(X(:)),max(Y(:))/2,sprintf('R = %0.2f',R), ...
        'HorizontalAlignment','right', 'fontSize',fontSize-2)
end
if doRegLine && doTextBox
    text(max(X(:)),max(Y(:))/3,sprintf('Slope = %0.2f\n Offset = %0.2f',model.p1,model.p2), ...
        'HorizontalAlignment','right', 'fontSize',fontSize-2)
end
















