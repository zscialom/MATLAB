clc
close all
clear all

% Put options, T=70 trading days
% Calibrating the parameter u
% Pricing for European, American and American with dividends
%% Variables

S_0 = 149.87;
r = 0.0010;

% Put data
market_option_data_put = readtable('data5.csv');                           % read the data
market_option_price_put = table2array(market_option_data_put(:,4));        % select the option prices column
market_option_strike_put = table2array(market_option_data_put(:,3));       % select the strike prices column
tab_option_price_chosen_put = zeros(1,10);                                 % tab containing the chosen option prices
tab_option_strike_chosen_put = zeros(1,10);                                % tab containing the chosen strike prices
calibrate_option_price_put_eu = zeros(10,10);                              % tab containing the option prices for every strike and every u
calibrate_option_price_put_usa = zeros(10,10);
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
            option_price_eu = risk_neutral_pricing(tab_u(u),k,r,T,Binomial_tree,'Put'); % r.n pricing
            option_price_usa = risk_neutral_pricing_usa(tab_u(u),1/tab_u(u),k,r,T,Binomial_tree,'Put');
            calibrate_option_price_put_eu(i,u) = option_price_eu;
            calibrate_option_price_put_usa(i,u) = option_price_usa;
        end
    end    
end


%% Comparing market and model
err_eu = zeros(1,length(calibrate_option_price_put_eu(1,:))); % vector containing all the errors
err_usa = zeros(1,length(calibrate_option_price_put_usa(1,:)));
for i=1:length(calibrate_option_price_put_eu(1,:))
    for j=1:length(calibrate_option_price_put_eu)
        err_eu(1,i) = err_eu(1,i) + sqrt((market_option_price_put(11+j)-calibrate_option_price_put_eu(j,i)).^2); %RMSE
        err_usa(1,i) = err_usa(1,i) + sqrt((market_option_price_put(11+j)-calibrate_option_price_put_usa(j,i)).^2);
    end
end    
err_eu = err_eu/length(calibrate_option_price_put_eu);
err_usa = err_usa/length(calibrate_option_price_put_usa);
%% RSE 
figure;
plot(tab_u',err_eu,'b');
title('Evolution of the error according to u: European options')
xlabel('Value of u')

figure;
plot(tab_u',err_usa,'r');
title('Evolution of the error according to u: American options')
xlabel('Value of u')
%% Strike vs Prices
figure;
hold all
plot(tab_option_strike_chosen_put,calibrate_option_price_put_eu(:,2),'r')
plot(tab_option_strike_chosen_put,calibrate_option_price_put_usa(:,2),'g')
plot(tab_option_strike_chosen_put, tab_option_price_chosen_put)
title('Strike vs Prices for optimal u and d')
xlabel('Strike Prices')
ylabel('Option Prices')
