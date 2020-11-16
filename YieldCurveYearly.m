function [YieldCurve] = YieldCurveYearly(Yield1y,SR)

n = length(SR);
EBOR = zeros(n,1);
EBOR(1) = Yield1y;

for i = 2:n
    pv = 0;
    for n = 1:i-1
        pv = pv + (100 * SR(i) * 1) * exp(-1 * EBOR(n) * n);
        %fprintf('SR(i) = %.4f \n EBOR(n) = %.4f \n n = %.4f \n', SR(i), EBOR(n), n);
    end
    EBOR(i) = -1 * log((100 - pv) / ((100 * SR(i) * 1)+100)) / i;
    %fprintf('log((100 - pv) / ((100 * SR(i) * 1)+100)) = %.4f \n', log((100 - pv) / ((100 * SR(i) * 1)+100)))
end

plot(EBOR)
YieldCurve = EBOR;

end

