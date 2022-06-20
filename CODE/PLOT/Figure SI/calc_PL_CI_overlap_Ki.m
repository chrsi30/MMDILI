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

ax        = axes(); 
figure(1)
set(figure(1), 'outerposition',[0 0 750 750], 'PaperType','a4')
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
    
    % Plot Rat, patlak?
    [h(1),rat_maximum,rat_minimum ] = helper(ratResults,i+0.22,ax,mColor1  );
     
    % Plot Perfusion
    [h(2),perf_maximum,perf_minimum ] = helper(perfResults,i,ax,mColor2  );
    
    % Plot Whole-Body
    [h(3),wb_maximum,wb_minimum ] = helper(wbResults,i-0.22,ax,mColor3 );
    
    if rat_maximum < perf_maximum && rat_minimum > perf_minimum 
    count_rat = count_rat + 1;      
    end
    
    if rat_maximum < wb_maximum && rat_minimum > wb_minimum 
    count_rat2 = count_rat2 + 1;      
    end
    
    tmp = abs(log(rat_maximum)- log(rat_minimum)); 
    unc_size_rat = [  tmp ; unc_size_rat ];
    
    tmp = abs(log(perf_maximum)- log(perf_minimum)); 
    unc_size_pref = [  tmp ; unc_size_pref ];

    tmp = abs(log(wb_minimum)- log(wb_maximum)); 
    unc_size_wb = [  tmp ; unc_size_wb ];

end
legend(h,{'Patlak','Perfusion','Whole-Body'}, 'location','northwest')
legend('boxoff')

figure(2)
set(figure(2), 'outerposition',[0 0 1000 750], 'PaperType','a4')
b = bar([ count_rat/nFiles ;  count_rat2/nFiles ]*100, 'facecolor', 'flat');
b(1).CData(1,:) = mColor1;
b(1).CData(2,:) = mColor1;

xlim([ 0 3]); xticks([ 1 2]); xticklabels({'Patlak \in Perfusion','Patlak \in Whole-Body'})
xlabel('CI overlap'); ylabel(' Procent of total data-series (%)')
set(gca,'fontsize',18 )
b.FaceColor = 'flat';

box 'off'


figure(3)
set(figure(3), 'outerposition',[0 0 750 750], 'PaperType','a4')
b = bar([ mean(unc_size_rat)  ;  mean(unc_size_pref) ;  mean(unc_size_wb) ],'facecolor', 'flat'  );

b(1).CData(1,:) = mColor1;
b(1).CData(2,:) = mColor2;
b(1).CData(3,:) = mColor3;


[t1, p1 ] = ttest2(unc_size_rat,unc_size_pref) 

[t2, p2 ] = ttest2(unc_size_rat,unc_size_wb) 


xlim([ 0 4]); xticks([ 1 2 3]); xticklabels({'Patlak','Perfusion','Whole-Body'})
ylabel('Mean CI length - ln(k_{i})')
set(gca,'fontsize',18 )

box 'off'


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
xlabel('ln(k_{i}) (s^{-1})');

box 'off'

end