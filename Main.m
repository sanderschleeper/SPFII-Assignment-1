%% Set the yields for the initial yield curve and Swap Rates.
% Data yield curve from: https://www.emmi-benchmarks.eu/euribor-org/euribor-rates.html
% Data Swap Rates from: https://produkte.erstegroup.com/CorporateClients/en/MarketsAndTrends/Fixed_Income/Capital_markets_derivatives/index.phtml?elem999058_index=Table_SwapRates_Europe_Europe_EUR&elem999058_durationTimes=0

clear
EBOR3m  = -0.513/100;
EBOR6m  = -0.504/100;
EBOR12m  = -0.468/100;
EBOR9m  = (EBOR6m + EBOR12m) / 2;

SR1y  = -0.5160/100;
SR2y  = -0.5200/100;
SR3y  = -0.5080/100;
SR4y  = -0.4840/100;
SR5y  = -0.4510/100;
SR6y  = -0.4120/100;
SR7y  = -0.3680/100;
SR8y  = -0.3180/100;
SR9y  = -0.3000/100;
SR10y = -0.2220/100;
SR11y = -0.1720/100;
SR12y = -0.1300/100;
SR13y = -0.0300/100;
SR14y = -0.0300/100;
SR15y = -0.0200/100;

SR = [SR1y SR2y SR3y SR4y SR5y SR6y SR7y SR8y SR9y SR10y SR11y SR12y SR13y SR14y SR15y];

%% Bootstrap the yield curve.
% To check wether the EURIBOR rates and SWAP RATES match, the value of test
% should be 100. 
test = (100 * SR1y * 0.25) * exp(-1 * EBOR3m * 0.25) + ...
    (100 * SR1y * 0.25) * exp(-1 * EBOR6m * 0.5) + ...
    (100 * SR1y * 0.25) * exp(-1 * EBOR9m * 0.75) + ...
    ((100 * SR1y * 0.25)+100) * exp(-1 * EBOR1y * 1)

%% Bootstrap the EURIBOR yield curve using yearly settlements SWAPS.

EBOR = YieldCurveYearly(EBOR12m, SR);

%% Do linear interpolation to get the quarterly zero yields. 
n = 15 / 0.25;
a = zeros(n,1);

for i = 1:n
    if(mod(i,4) == 0 )
        a(i) = EBOR(i*0.25);
    else
        a(i) = 0;
    end
end

it = 0;

for i = 5:n
    it = it + 1;
    if(it == 1)
        a(i) = a(i-1) + 1*(a(i+3) - a(i-1))/4;
    elseif(it == 2)
        a(i) = a(i-1) + 1*(a(i+2) - a(i-2))/4;
    elseif(it == 3)
        a(i) = a(i-1) + 1*(a(i+1) - a(i-3))/4;
    else
        it = 0;
    end
end

a(1) = EBOR3m;
a(2) = EBOR6m;
a(3) = EBOR9m;

plot(a)
EBOR = a;







