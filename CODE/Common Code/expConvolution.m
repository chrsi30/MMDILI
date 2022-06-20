function y = expConvolution(exponent,time,C)
%
% y = expConvolution(exponent,time,data)
%

n = length(time);
y = zeros(n,1);

dt = time(2:end)-time(1:end-1);
dC = C(2:end)-C(1:end-1);

Z = exponent*dt;
E = exp(-Z);
E0 = 1-E;
E1 = Z-E0;

I1 = (C(1:end-1).*E0 + dC.*E1./Z) ./ exponent;

for i = 1:n-1
    y(i+1) = E(i)*y(i) + I1(i);
end


end