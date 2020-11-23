function value = ValueSwapsAmortizing(notional, fixed_coupon, floating_payment, discount_factors, maturity, amortizing)
% this function prices swaps
% assume payments happen quarterly

% you pay fixed, receive floation (youre a bank)

% discount factor is already determined, but maybe nah, also theyre
% percentages/100

% maturity is in years

% fixed coupon is determined, and in decimals, not percentages

% notional is value of the loan

% amortizing is logical

%structure this one a little different that the last one:
%% Make vector of discount factors: correct
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

new_discounts
%% Determine amortization amount:
if amortizing == true
    am_amount = notional / ceil(maturity/0.25);
elseif amortizing == false
    am_amount = 0;
end


%% Determine value of fixed leg
% do everything in months, bc more clear
mat = maturity*12;
% determine how many months untill next payment
if mod(mat, 3) == 0
    MUNP = 3;
else
    MUNP = mod(mat,3);
end

PVfix = 0;
notionalfix = notional;

while MUNP < mat
    
    deltaPVfix = (notionalfix * fixed_coupon/4 + am_amount) * exp(-1 * new_discounts(MUNP) * MUNP/12);
    PVfix = PVfix + deltaPVfix;
    notionalfix = notionalfix - am_amount;
    MUNP = MUNP + 3;
end
% for last payment

deltaPVfix = (notionalfix) * (1+fixed_coupon/4) * exp(-1 * new_discounts(MUNP) * MUNP/12); % everything up until this is correct
PVfix = PVfix + deltaPVfix;
%% Determine floating leg, correct
if mod(mat,3)==0
    MUNP = 3;
else
    MUNP = mod(mat,3);
end

PVfloat = notional * (1 + floating_payment/4) * exp(-1 * new_discounts(MUNP) * MUNP/12);

%% Calculate swap value
value = PVfloat - PVfix;




end 
