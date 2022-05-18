function [ Binomialtree ] = binomial_tree(time_steps,u,S_0)
% Build the binomial tree for u and d=1/u
% time_steps, maturity

Binomialtree = nan(time_steps,time_steps);
Binomialtree(1,1) = S_0;
for i=2:time_steps
    %if it goes up, the price at t=t-1 is multiplied by u
    Binomialtree(1:i-1,i) = Binomialtree(1:i-1,i-1)*u;
    %if it goes down, the price at t=t-1 is multiplied by 1/u
    Binomialtree(i,i) = Binomialtree(i-1,i-1)*(1/u);
end


end

