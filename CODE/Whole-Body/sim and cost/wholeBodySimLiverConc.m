function varargout = wholeBodySimLiverConc(param,X,modelName,doScale)
%
% C = forsgrenSim(param,X)
% C = forsgrenSim(param,X,modelName)
% C = forsgrenSim(param,X,modelName,doScale)
%
% param     = [kef kdiff ki kback scale]
% X         = time
% modelName = name of the model (deafault = 'forsgren'
% doScale   = boolean, if to use scale param (deafault = true)
%

if nargin < 4
    doScale = true;
end

if nargin < 3
    modelName = 'forsgren';
end

if size(X,2) ~= 3
    X = X';
end


%% Simulation settings
simOptions = [];
simOptions.maxnumsteps = 1e8;
simOptions.abstol = 1e-10;
simOptions.reltol = 1e-10;
simOptions.minstep = 0;
simOptions.maxstep = inf;

ICs = SBinitialconditions(modelName);
[pNames,~] = SBparameters(modelName);


%% Simulate
if doScale
    scale = param(end);
    simParam = param(1:end-1);
else
    scale = 1;
    simParam = param;
end

simTime = X;
% If we are doing NLME
if sum(simTime==0) == 2 || sum(simTime==60) == 2
    simTime = simTime(1:end/2);
end

if simTime(1) == 0
    simData = SBPDsimulate(modelName, simTime, ICs, pNames, simParam, simOptions);
    simLiver   = simData.reactionvalues(:, ismember(simData.reactions,{'Cl'}))*scale*1000;
    simSpleen  = simData.reactionvalues(:, ismember(simData.reactions,{'Cs'}))*scale*1000;
else
    simTime = [0, simTime];
    simData = SBPDsimulate(modelName, simTime, ICs, pNames, simParam, simOptions);
    simLiver   = simData.reactionvalues(2:end, ismember(simData.reactions,{'Cl'}))*scale*1000;
    simSpleen  = simData.reactionvalues(2:end, ismember(simData.reactions,{'Cs'}))*scale*1000;
end

if nargout == 1
    varargout{1} = [simLiver; simSpleen];
elseif nargout == 2
    varargout{1} = simLiver;
    varargout{2} = simSpleen;
elseif nargout == 3
    varargout{1} = simLiver;
    varargout{2} = simSpleen;
    varargout{3} = simData;
end

end