function [ u,d ] = optimal_u_d(drift,sigma,delta_t)
% Method of estimation
u = 1 + drift*delta_t + sigma*sqrt(delta_t);
d = 1 + drift*delta_t - sigma*sqrt(delta_t);

end

