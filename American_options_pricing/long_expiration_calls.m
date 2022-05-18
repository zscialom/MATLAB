clc
close all
clear all

% Call options, T=70 trading days
% Calibrating the parameter u
% Pricing for European, American and American with dividends
%% Variables

S_0 = 149.87;
r = 0.0010;

% Call data
market_option_data_call = readtable('data4.csv');                          % read the data
market_option_price_call = table2array(market_option_data_call(:,4));      % select the option prices column
market_option_strike_call = table2array(market_option_data_call(:,3));     % select the strike prices column
tab_option_price_chosen_call = zeros(1,10);                                % tab containing the chosen option prices
tab_option_strike_chosen_call = zeros(1,10);                               % tab containing the chosen strike prices
calibrate_option_price_call_usa = zeros(10,10);                            % tab containing the option prices for every strike and every u: American style
calibrate_option_price_call_eu = zeros(10,10);                             % tab containing the option prices for every strike and every u: European style
calibrate_option_price_call_usa_div = zeros(10,10);                        % tab for dividends
T_div = 69;                                                                % time where div is paid
div = 1;                                                                   % dividends price
T = 70;                                                                    % maturity



%% Choosing interesting prices/strikes
for i=1:1:length(tab_option_price_chosen_call)
    tab_option_price_chosen_call(i)=market_option_price_call(15+i);
end

for i=1:1:length(tab_option_price_chosen_call)
    tab_option_strike_chosen_call(i)=market_option_strike_call(15+i);
end

%% Obtaining the optimal u&d
tab_u=1.001:0.001:1.010;                                                   % values of u tried

for u=1:length(tab_u)
    Binomial_tree = binomial_tree(T,tab_u(u),S_0);                         % Binomial tree associated with u
    Binomial_tree_div = binomial_dividends(T,tab_u(u),1/tab_u(u),S_0,div,T_div); % Binomial tree adapted with dividends
    for i=1:length(tab_option_strike_chosen_call)
        for k=tab_option_strike_chosen_call(i)
            option_price_usa = risk_neutral_pricing_usa(tab_u(u),1/tab_u(u),k,r,T,Binomial_tree,'Call'); % r.n pricing usa
            option_price_eu = risk_neutral_pricing(tab_u(u),k,r,T,Binomial_tree,'Call'); % r.n pricing european
            option_price_usa_div = risk_neutral_pricing_usa(tab_u(u),1/tab_u(u),k,r,T,Binomial_tree_div,'Call'); %r.n pricing usa with divs
            
            calibrate_option_price_call_usa(i,u) = option_price_usa;
            calibrate_option_price_call_eu(i,u) = option_price_eu;
            calibrate_option_price_call_usa_div(i,u) = option_price_usa_div;
        end
    end    
end


%% Comparing market and model
% American options
err_usa = zeros(1,length(calibrate_option_price_call_usa(1,:))); % vector containg all the errors usa
err_eu = zeros(1,length(calibrate_option_price_call_eu(1,:))); % vector containg all the errors eu
err_usa_div = zeros(1,length(calibrate_option_price_call_usa_div(1,:))); % vector containg all the errors usa with divs
for i=1:length(calibrate_option_price_call_usa(1,:))
    for j=1:length(calibrate_option_price_call_usa)
        err_usa(1,i) = err_usa(1,i) + sqrt((market_option_price_call(15+j)-calibrate_option_price_call_usa(j,i)).^2); %RMSE
        err_eu(1,i) = err_eu(1,i) + sqrt((market_option_price_call(15+j)-calibrate_option_price_call_eu(j,i)).^2); 
        err_usa_div(1,i) = err_usa_div(1,i) + sqrt((market_option_price_call(15+j)-calibrate_option_price_call_usa_div(j,i)).^2);
    end
end
err_usa = err_usa/length(calibrate_option_price_call_usa);
err_eu = err_eu/length(calibrate_option_price_call_eu);
err_usa_div = err_usa_div/length(calibrate_option_price_call_usa_div);
%% RSE 
% American options
figure;
plot(tab_u',err_usa);
title('Evolution of the error according to u: American options')
xlabel('Value of u')

% European options
figure;
plot(tab_u',err_eu);
title('Evolution of the error according to u: European options')
xlabel('Value of u')

% American options with dividends
figure;
plot(tab_u',err_usa);
title('Evolution of the error according to u: American options with dividends')
xlabel('Value of u')
%% Strike vs Prices
figure;
hold all
plot(tab_option_strike_chosen_call,calibrate_option_price_call_usa(:,7),'r')
plot(tab_option_strike_chosen_call, tab_option_price_chosen_call)
plot(tab_option_strike_chosen_call, calibrate_option_price_call_eu(:,7),'g')
plot(tab_option_strike_chosen_call, calibrate_option_price_call_usa_div(:,7),'m')
title('Strike vs Prices for optimal u and d')
xlabel('Strike Prices')
ylabel('Option Prices')




