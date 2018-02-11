function kl_en=DimR(y,kl_term)
covy = cov(y');

[eigV,lambda] = eig(covy);

dln = diag(lambda);
[~, rindices] = sort(dln,'descend');
lambda = lambda(rindices,rindices);
eigV = eigV(:,rindices);

H = eigV(:,1:kl_term);
ln = lambda(1:kl_term,1:kl_term);

kl_en = inv(sqrt(ln))*H'*y;    % random number


 