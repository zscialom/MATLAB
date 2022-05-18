function [ drift ] = drift_estimation( stock_prices, N, delta_t )
% Estimating the drift
sum = 0;
for i=1:N-1
    sum = sum + stock_prices(i+1,1)/stock_prices(i,1);
end    
sum = (sum/(N-1))-1;
drift = sum/delta_t;
% drift = ((sum/N)-1)/delta_t;
end

