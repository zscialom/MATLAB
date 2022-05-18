clc
close all
clear all

% Method 1: Engineering way: calibrate
%% Variables

S_0 = 150.44;
r = 0.0010;

% Call data
market_option_data_call = readtable('data2.csv');                          % read the data
market_option_price_call = table2array(market_option_data_call(:,4));      % select the option prices column
market_option_strike_call = table2array(market_option_data_call(:,3));     % select the strike prices column
tab_option_price_chosen_call = zeros(1,16);                                % tab containing the chosen option prices
tab_option_strike_chosen_call = zeros(1,16);                               % tab containing the chosen strike prices
calibrate_option_price_call = zeros(16,10);                                % tab containing the option prices for every strike and every u
T = 9;



%% Choosing interesting prices/strikes
for i=1:1:length(tab_option_price_chosen_call)
    tab_option_price_chosen_call(i)=market_option_price_call(32+i);
end

for i=1:1:length(tab_option_price_chosen_call)
    tab_option_strike_chosen_call(i)=market_option_strike_call(32+i);
end

%% Obtaining the optimal u&d
tab_u=1.001:0.001:1.010;                                                   % values of u tried

for u=1:length(tab_u)
    Binomial_tree = binomial_tree(T,tab_u(u),S_0);                         % Binomial tree associated with u
    for i=1:length(tab_option_strike_chosen_call)
        for k=tab_option_strike_chosen_call(i)
            option_price = risk_neutral_pricing(tab_u(u),k,r,T,Binomial_tree,'Call'); % r.n pricing
            %option_price = pricing_option_0(S_0,r,k,9,'Call',tab_u(u),1/tab_u(u));
            calibrate_option_price_call(i,u) = option_price;
        end
    end    
end


%% Comparing market and model
err = zeros(1,length(calibrate_option_price_call(1,:))); % vector containing all the errors
for i=1:length(calibrate_option_price_call(1,:))
    for j=1:length(calibrate_option_price_call)
        err(1,i) = err(1,i) + sqrt((market_option_price_call(32+j)-calibrate_option_price_call(j,i)).^2); %RMSE
    end
end
err = err/length(calibrate_option_price_call);

%% RSE 
figure;
plot(tab_u',err,'b');
title('Evolution of the error according to u')
xlabel('Value of u')

%% Strike vs Prices
figure;
plot(tab_option_strike_chosen_call,calibrate_option_price_call(:,9),'r')
title('Strike vs Prices for optimal u and d')
xlabel('Strike Prices')
ylabel('Option Prices')

