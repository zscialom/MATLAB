% Test of the function for the forward contract

% The values chosen inside the function are not based on any stocks. 
% I just wanted to verify
% that the function works and gives the hedging strategy without any 
% additional issues

% [ forward_price,H0,H1 ] = forward_prices( T,S_0,u,d,r,N )
[ forward_price,H0,H1 ] = forward_prices(5,50,1.05,0.90,0.001,2);

H0 = sym2poly(H0);
H1 = sym2poly(H1);

forward_price
H0 = round(H0,2)
H1 = round(H1,2)