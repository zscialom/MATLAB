function [ sigma ] = volatility_estimation( stock_prices,N,delta_t )

% Estimation of the volatility

% First, we derive the ratio (Sj/Sj-1)
tab_return = zeros(N-1,1);
for j=1:N-1
    tab_return(j,1)=stock_prices(j+1,1)/stock_prices(j,1);
end

% Standard deviation
mean_prices = mean(tab_return); 
S = 0;
for i=1:N-1
    S = S+abs(tab_return(i,1)-mean_prices)^2;
end
sigma = sqrt(S/(delta_t*(N-2)));

end

