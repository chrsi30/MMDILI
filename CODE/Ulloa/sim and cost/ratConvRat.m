function C = ratConvRat(param,X,signalType)
%
% C = ulloaConv(param,X,signalType)
% C = ulloaConv(param,X,signalType,simTime)
%
% param = [ki,kef] or [ki,kef,Vel]
% X = [time Cs]
% signalType = 'liver' or 'hep'
%

if nargin == 2
    signalType = 'Hep';
end

% Acording to other litterature
Ves = 0.43;
Vel = 0.23;

time = X(:,1);
Cs = X(:,2);

ki = param(1);
kef = param(2);
if length(param) == 3
    Vel = param(3);
end


% In this case, Cs comes as the concentration in the spleen extracellular space.
Ces = Cs;


Chep = ki*expConvolution(kef,time,Ces);

if strcmp(signalType,'Liver')
    C = Vel.*Ces + (1-Vel)*Chep;
elseif strcmp(signalType,'Hep')
    C = Chep;
else
    error('ulloaConv: Wrong signalType')
end


