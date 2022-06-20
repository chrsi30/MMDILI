
wbFolder   = './Results/NILB/Profile Likelihood/Small Limit/Whole-Body/';
ratFolder  = './Results/NILB/Profile Likelihood/Small Limit/Rat/';
perfFolder = './Results/NILB/Profile Likelihood/Small Limit/Perfusion/';

wbFiles  = dir([wbFolder '*.mat']);
nFiles = length(wbFiles);

mColor1 = [ 94   129  181]./255; 
mColor2 = [ 225  156  36]./255; 
mColor3 = [  143  176  50]./255; 

count_rat = 0;
count_rat2 = 0;
count_wb =0;

unc_size_wb = [];
unc_size_pref = [];
unc_size_rat = [];

figure(4)
set(figure(4), 'outerposition',[0 0 1000 1000], 'PaperType','a4')


ax        = axes(); 

for i = 1:nFiles
    
    % Load Whole-Body
    load([wbFiles(i).folder filesep wbFiles(i).name])
    wbResults = plResult(1); % keff
    pid = wbFiles(i).name(1:end-10);    
    % Load Rat
    load([ratFolder pid '_PL_rat.mat'])
    ratResults = plResult(2); % keff
    % Load Rat
    load([perfFolder pid '_PL_perf.mat'])
    perfResults = plResult(5);% keff
    
    % Plot Rat, patlak?
    [h(1),rat_maximum,rat_minimum ] = helper(ratResults,i+0.22,ax,mColor1  );
     
    % Plot Perfusion
    [h(2),perf_maximum,perf_minimum ] = helper(perfResults,i,ax,mColor2  );
    
    % Plot Whole-Body
    [h(3),wb_maximum,wb_minimum ] = helper(wbResults,i-0.22,ax,mColor3 );
    

end
legend(h,{'Patlak','Perfusion','Whole-Body'}, 'location','northwest')
legend('boxoff')


%%
function [h,maximum,minimum ] = helper(plResult,y,ax,color)

optim   = exp(plResult.startFixedVal);
maximum = exp(max(plResult.paramValues));
minimum = exp(min(plResult.paramValues));

h = plot(ax, [minimum,maximum], [y,y]);
h.LineWidth = 3; h.Color = color;
hold on


ax.FontSize  = 14;   
ax.YColor    = [1,1,1];
ax.XScale    = 'log';
ax.YTick     = [];
ax.TickDir   = 'out'; 
ax.LineWidth = 2;


xlabel('ln(k_{e}) (s^{-1})');

box 'off'


end