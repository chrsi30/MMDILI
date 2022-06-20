function ki = readAllKi(resultFolder,idx)

patFolders = dir(resultFolder); patFolders = patFolders(3:end);
n = 1;
for i  = 1:length(patFolders)
    if patFolders(i).isdir
        path = [resultFolder patFolders(i).name '/param_cost.mat'];
        load(path,'param')
        ki(n) = param(idx);
        n = n+1;
    end
end

end