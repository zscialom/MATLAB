function [ Binomialtree ] = binomial_tree_u_d(time_steps,u,d,S_0)
% Build the binomial tree for u and d

Binomialtree = nan(time_steps,time_steps);
Binomialtree(1,1) = S_0;
for i=2:time_steps
    %if it goes up, the price at t=t-1 is multiplied by u
    Binomialtree(1:i-1,i) = Binomialtree(1:i-1,i-1)*u;
    %if it goes down, the price at t=t-1 is multiplied by d
    Binomialtree(i,i) = Binomialtree(i-1,i-1)*d;
end
 

end

