clc
close all
clear all

% Method 1: Engineering way: calibrate
%% Variables

S_0 = 150.44; % AAPL stock price chosen
r = 0.0010;   % r=0.1%

% Put data
market_option_data_put = readtable('data3.csv');                           % read the data
market_option_price_put = table2array(market_option_data_put(:,4));        % select the option prices column
market_option_strike_put = table2array(market_option_data_put(:,3));       % select the strike prices column
tab_option_price_chosen_put = zeros(1,12);                                 % tab containing the chosen option prices
tab_option_strike_chosen_put = zeros(1,12);                                % tab containing the chosen strike prices
calibrate_option_price_put = zeros(12,10);                                 % tab containing the option prices for every strike and every u
T = 9;                                                                     % maturity



%% Choosing interesting prices/strikes
for i=1:1:length(tab_option_price_chosen_put)
    tab_option_price_chosen_put(i)=market_option_price_put(23+i);
end

for i=1:1:length(tab_option_price_chosen_put)
    tab_option_strike_chosen_put(i)=market_option_strike_put(23+i);
end

%% Obtaining the optimal u&d
tab_u=1.01:0.01:1.10;                                                      % values of u tried

for u=1:length(tab_u)
    Binomial_tree = binomial_tree(T,tab_u(u),S_0);                         % Binomial tree associated with u
    for i=1:length(tab_option_strike_chosen_put)
        for k=tab_option_strike_chosen_put(i)
            option_price = risk_neutral_pricing(tab_u(u),k,r,T,Binomial_tree,'Put');
            %option_price = pricing_option_0(S_0,r,k,2,'Call',tab_u(u),1/tab_u(u));
            calibrate_option_price_put(i,u) = option_price;                
        end
    end    
end


%% Comparing market and model
err = zeros(1,length(calibrate_option_price_put(1,:)));                    % vector containing all the errors
for i=1:length(calibrate_option_price_put(1,:))
    for j=1:length(calibrate_option_price_put)
        err(1,i) = err(1,i) + sqrt((market_option_price_put(32+j)-calibrate_option_price_put(j,i)).^2); %RMSE
    end
end
err = err/length(calibrate_option_price_put);

%% RSE 
figure;
plot(tab_u',err);
title('Evolution of the error according to u')
xlabel('Value of u')
