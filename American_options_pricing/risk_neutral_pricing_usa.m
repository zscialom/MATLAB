function [ option_price ] = risk_neutral_pricing_usa(u,d,K,r,T,Binomialtree,type)

% Risk neutral pricing method:  For American options
q1 = (1+r-d)/(u-d);
Payoff_tree = zeros(T,T);

% Payoff obtained according to the type chosen
for i=1:T
    switch type
        case 'Call'
            Payoff_tree(i,:) = max(0,Binomialtree(i,:)-K);
        case 'Put'
            Payoff_tree(i,:) = max(0,K-Binomialtree(i,:));  
    end
end   

% First, we need the last column of the payoff
Pricing_list = [];
for j=1:1:T
    Pricing_list = [Pricing_list Payoff_tree(j,T)];
end 

% Then, we go through the tree backwards
% Every price obtained is place in the pricing list
sum1 = 0;
sum2 = 0;
for k=T:-1:1
        length_vector = length(Binomialtree(:,k)) - sum(isnan(Binomialtree(:,k)));
        a=0;
        for i=length_vector-1:-1:1
            C = (1/1+r)*(q1*Pricing_list(a+i)+(1-q1)*Pricing_list(a+i+1));
            % American style: Must choose the max between intrinsic value
            % and european style at each time and each state w
            if (C <= Payoff_tree(i,k-1))
                C = Payoff_tree(i,k-1);
                sum1 = sum1+1;
            else
                C=C;
                sum2 = sum2+1;
            end    
            Pricing_list = [C Pricing_list];
            a=a+1;
        end      
end
%sum1
%sum2
option_price = Pricing_list(1);
end

