function C = perfConvSpleenRat(param,simInput)
%
% C = expGeorgiou(param,simInput)
%
% param    = [Fp fa ve ki kef]
% simInput = [time; spleen; spleen]
%

if size(simInput,2) ~= 3
    if size(simInput,1) ~= 3
        simInput = simInput';
    else
        error('perfConv: Wrong size of X')
    end
end

time = simInput(:,1);
Ca   = simInput(:,2); % Spleen, extracellular concentration
Cv   = simInput(:,3); % Spleen, extracellular concentration

Fp  = param(1);
fa  = param(2);
ve  = param(3);
ki  = param(4);
kef = param(5);

vi = 1-ve;
fv = 1-fa;
Fa = Fp*fa;
Fv = Fp*fv;

Te   = ve/(Fp+ki);
Ti   = vi/kef;
Ei   = ki/(Fp+ki);
temp = Ei/(1-(Te/Ti));

Xai = expConvolution(1/Ti,time,Ca);
Xvi = expConvolution(1/Ti,time,Cv);
Xae = expConvolution(1/Te,time,Ca);
Xve = expConvolution(1/Te,time,Cv);

C = Fa*temp*Xai +  Fv*temp*Xvi + Fa*(1-temp)*Xae +  Fv*(1-temp)*Xve;

end

