function [option_price] = pricing_option_0( S_0,r,K,time_steps,type,u,d )
% Resolution H_0/H_1

% K, the strike
% time_steps, maturity

% First of all we need to build the binomial tree

Binomialtree = nan(time_steps,time_steps); 
Binomialtree(1,1) = S_0;
for i=2:time_steps
    %if it goes up, the price at t=t-1 is multiplied by u
    Binomialtree(1:i-1,i) = Binomialtree(1:i-1,i-1)*u;
    %if it goes down, the price at t=t-1 is multiplied by d
    Binomialtree(i,i) = Binomialtree(i-1,i-1)*d;
end

% Then, we need to obtain the payoff for every omega

Payoff_tree = zeros(time_steps,time_steps);
for i=1:time_steps
    switch type
        case 'Call'
            Payoff_tree(i,time_steps) = max(0,Binomialtree(i,time_steps)-K);
        case 'Put'
            Payoff_tree(i,time_steps) = max(0,K-Binomialtree(i,time_steps));
            
    end
end    
   
% At last, we go through the tree backwards

Pricing_list = [];
for j=1:1:time_steps
    Pricing_list = [Pricing_list Payoff_tree(j,time_steps)];
end   

for k=time_steps:-1:1
        length_vector = length(Binomialtree(:,k)) - sum(isnan(Binomialtree(:,k)));
        a=0;
        for i=length_vector-1:-1:1
            % Resolution of H0 and H1
            syms H_0 H_1
            eqns = [H_0*(1+r)+H_1*Binomialtree(i,k) == Pricing_list(a+i), H_0*(1+r)+H_1*Binomialtree(i+1,k) == Pricing_list(a+i+1)];
            vars = [H_0 H_1];
            [sol1,sol2] = solve(eqns,vars);
            %i
            C = sol1+sol2*Binomialtree(i,k-1);
            Pricing_list = [C Pricing_list];
            a=a+1;
        end      
end
option_price = Pricing_list(1);

end



