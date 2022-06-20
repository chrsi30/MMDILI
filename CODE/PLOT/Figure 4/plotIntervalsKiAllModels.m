function plotIntervalsKiAllModels(ax)

wbFolder   = './Results/NILB/Profile Likelihood/Small Limit/Whole-Body/';
ratFolder  = './Results/NILB/Profile Likelihood/Small Limit/Rat/';
perfFolder = './Results/NILB/Profile Likelihood/Small Limit/Perfusion/';

wbFiles  = dir([wbFolder '*.mat']);
nFiles = length(wbFiles);

%colors = colorSpectrum(3);

mColor1 = [ 1 0  0];
mColor2 = [ 0 1  0];
mColor3 = [ 0 0  1];


for i = 1:nFiles
    
    % Load Whole-Body
    load([wbFiles(i).folder filesep wbFiles(i).name])
    wbResults = plResult(3);
    pid = wbFiles(i).name(1:end-10);
    
    % Load Rat
    load([ratFolder pid '_PL_rat.mat'])
    ratResults = plResult(1);
    
    % Load Rat
    load([perfFolder pid '_PL_perf.mat'])
    perfResults = plResult(4);
    
    % Plot Rat
    h(1) = helper(ratResults,i+0.22,ax,mColor1  );
     
    % Plot Perfusion
    h(2) = helper(perfResults,i,ax,mColor2  );
    
    % Plot Whole-Body
    h(3) = helper(wbResults,i-0.22,ax,mColor3 );
    
end

legend(h,{'Patlak','Perfusion','Whole-Body'}, 'location','northwest')
legend('boxoff')


function h = helper(plResult,y,ax,color)

optim   = exp(plResult.startFixedVal);
maximum = exp(max(plResult.paramValues));
minimum = exp(min(plResult.paramValues));

h = plot(ax, [minimum,maximum], [y,y]);
h.LineWidth = 3; h.Color = color;

