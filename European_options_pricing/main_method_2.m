clc
close all
clear all

%% Variables

market_stock_price = readtable('AAPL.csv');
close_price = table2array(market_stock_price(:,5));
N = size(close_price(:,1));
N = N(1);
delta_t = N/252;
r = 0.0010;
%delta_t = 31/360;
%% Plot for AAPL 
figure; 
x_axis = 1:1:N;
plot(x_axis,close_price,'b');
title('Evolution of the stock price of AAPL');
xlim([1 N]);
xlabel('Days');
ylabel('Stock price of AAPL');

%% Optimal u&d

drift_estimated = drift_estimation(close_price,N,delta_t);
volatility_estimated = volatility_estimation(close_price,N,delta_t);

[u,d] = optimal_u_d(drift_estimated,volatility_estimated,delta_t);


Binomial_tree = binomial_tree_u_d(70,u,d,149.87);
option_price = risk_neutral_pricing_u_d(u,d,150,r,70,Binomial_tree,'Call')





