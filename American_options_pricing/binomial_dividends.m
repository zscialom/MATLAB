function [ Binomialtree ] = binomial_dividends(T,u,d,S_0,div,T_div)
% Build the binomial tree for u and d + dividends

Binomialtree = nan(T,T);
Binomialtree(1,1) = S_0;
for i=2:T_div
    %if it goes up, the price at t=t-1 is multiplied by u
    Binomialtree(1:i-1,i) = Binomialtree(1:i-1,i-1)*u;
    %if it goes down, the price at t=t-1 is multiplied by d
    Binomialtree(i,i) = Binomialtree(i-1,i-1)*d;
end
Binomialtree = Binomialtree - div;
for i=T_div+1:T
    %if it goes up, the price at t=t-1 is multiplied by u
    Binomialtree(1:i-1,i) = Binomialtree(1:i-1,i-1)*u;
    %if it goes down, the price at t=t-1 is multiplied by d
    Binomialtree(i,i) = Binomialtree(i-1,i-1)*d;
end    

end

