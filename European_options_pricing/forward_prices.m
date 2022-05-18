function [ forward_price,H0,H1 ] = forward_prices( T,S_0,u,d,r,N )
% Function to obtain forward prices at every time/every state

% T, maturity
% N, number of contacts (long or short)
% S_0, stock price at time zero

K = S_0*exp(r*T); % Forward price

Binomialtree = nan(T,T);
Binomialtree(1,1) = S_0;
for i=2:T
    %if it goes up, the price at t=t-1 is multiplied by u
    Binomialtree(1:i-1,i) = Binomialtree(1:i-1,i-1)*u;
    %if it goes down, the price at t=t-1 is multiplied by d
    Binomialtree(i,i) = Binomialtree(i-1,i-1)*d;
end

Payoff_tree = N*(Binomialtree - K*(1+r));  % Payoff forward prices

% First, we need the last column of the payoff
Pricing_list = [];
for j=1:1:T
    Pricing_list = [Pricing_list Payoff_tree(j,T)];
end 

% Then, we go through the tree backwards
% Every price obtained is place in the pricing list
for k=T:-1:1
        length_vector = length(Binomialtree(:,k)) - sum(isnan(Binomialtree(:,k)));
        a=0;
        for i=length_vector-1:-1:1
            syms H_0 H_1
            eqns = [H_0*(1+r)+H_1*Binomialtree(i,k) == Pricing_list(a+i), H_0*(1+r)+H_1*Binomialtree(i+1,k) == Pricing_list(a+i+1)];
            vars = [H_0 H_1];
            [sol1,sol2] = solve(eqns,vars);
            C = sol1+sol2*Binomialtree(i,k-1);
            Pricing_list = [C Pricing_list];
            a=a+1;
        end      
end
forward_price = K;
H0 = sol1;
H1 = sol2;


end
