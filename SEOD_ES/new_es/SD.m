function y = SD(m0,sig0,m1,sig1)
% This function calculates the KL divergence from N1(m1,sig1) to
% N0(m0,sig0); i.e., N1 is the prior, N0 is the posterior, 
% m0, m1 are with dim(k,1), sig0, sig1 are with dim(k,k)
%references http://en.wikipedia.org/wiki/Kullback%E2%80%93Leibler_divergence#KL_divergence_for_the_normal_distributions
if (length(m0(:)) ~= length(m1(:))) && (length(sig0(:)) ~= length(sig1(:))) && (length(m0)^2 ~= length(sig0(:)) )
    fprintf('error, dim mismatch')
    pause;
end;
P3 = log(det(sig1)/det(sig0));
y = 0.5 * P3;