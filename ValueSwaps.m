function value = ValueSwaps(fixed_coupon, floating_payment, discount_factors, maturity)
% this function prices swaps
% assume payments happen quarterly

% you pay fixed, receive floation (youre a bank)

% discount factor is already determined, but maybe nah, also theyre
% percentages/100

% maturity is in years

% fixed coupon is determined, and in decimals, not percentages

% assume for now notional amount is EUR100

%% make monthly vector of discount factors
% if you would receive discount factors as monthly numbers in a vector:
% format of vector received = [1month, 3months, 6months, 9m, 12, 15, etc.]

new_discounts = 1:(maturity*12);
new_discounts(1) = discount_factors(1);
new_discounts(2) = (discount_factors(1) + discount_factors(2))*0.5;

for i = 3:(maturity*12)
    if mod(i,3) == 0
        new_discounts(i) = discount_factors(i/3 + 1);
    elseif mod(i,3) == 2
        new_discounts(i) = discount_factors(floor(i/3)+1) + (2/3)*(discount_factors(ceil(i/3)+1) - discount_factors(floor(i/3)+1));
    elseif mod(i,3) == 1
        new_discounts(i) = discount_factors(floor(i/3)+1) + (1/3)*(discount_factors(ceil(i/3)+1) - discount_factors(floor(i/3)+1));
    end
end

%% determine PV of fixed:
% maturity to months for easier loops:
current_month = maturity*12;

% get last payment's PV first:
PVfix = 100*(1 + fixed_coupon/4) * exp(-1 * new_discounts(current_month) * current_month/12);
current_month = current_month - 3;

while current_month > 0
    PVfix = PVfix + ((100 * fixed_coupon) / 4)*exp(-1 * new_discounts(current_month) * current_month/12);
    current_month = current_month - 3;
end

%% now to determine PV of floating:
current_month = current_month + 3;
PVfloat = 100 * (1 + floating_payment/4) * exp(-1 * new_discounts(current_month) * current_month/12);

%% calculate value
value = PVfloat - PVfix;











end






