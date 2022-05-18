clc
close all
clear all

% Method 1: Engineering way: calibrate
%% Variables

S_0 = 149.87;
r = 0.0010;

% Put data
market_option_data_put = readtable('data5.csv');                           % read the data
market_option_price_put = table2array(market_option_data_put(:,4));        % select the option prices column
market_option_strike_put = table2array(market_option_data_put(:,3));       % select the strike prices column
tab_option_price_chosen_put = zeros(1,10);                                 % tab containing the chosen option prices
tab_option_strike_chosen_put = zeros(1,10);                                % tab containing the chosen strike prices
calibrate_option_price_put = zeros(10,10);                                 % tab containing the option prices for every strike and every u
T = 70;                                                                    % maturity



%% Choosing interesting prices/strikes
for i=1:1:length(tab_option_price_chosen_put)
    tab_option_price_chosen_put(i)=market_option_price_put(11+i);
end

for i=1:1:length(tab_option_price_chosen_put)
    tab_option_strike_chosen_put(i)=market_option_strike_put(11+i);
end

%% Obtaining the optimal u&d
tab_u=1.01:0.01:1.10;                                                      % values of u tried

for u=1:length(tab_u)
    Binomial_tree = binomial_tree(T,tab_u(u),S_0);                         % Binomial tree associated with u
    for i=1:length(tab_option_strike_chosen_put)
        for k=tab_option_strike_chosen_put(i)
            option_price = risk_neutral_pricing(tab_u(u),k,r,T,Binomial_tree,'Put'); % r.n pricing
            calibrate_option_price_put(i,u) = option_price;
        end
    end    
end


%% Comparing market and model
err = zeros(1,length(calibrate_option_price_put(1,:))); % vector containing all the errors
for i=1:length(calibrate_option_price_put(1,:))
    for j=1:length(calibrate_option_price_put)
        err(1,i) = err(1,i) + sqrt((market_option_price_put(11+j)-calibrate_option_price_put(j,i)).^2); %RMSE
    end
end
err = err/length(calibrate_option_price_put);

%% RSE 
figure;
plot(tab_u',err,'b');
title('Evolution of the error according to u')
xlabel('Value of u')

%% Strike vs Prices
figure;
plot(tab_option_strike_chosen_put,calibrate_option_price_put(:,2),'r')
hold on
plot(tab_option_strike_chosen_put, tab_option_price_chosen_put)
title('Strike vs Prices for optimal u and d')
xlabel('Strike Prices')
ylabel('Option Prices')
