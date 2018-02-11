function [y1,y2,y3] = generation()

kl_term=20;
Y_mean=1;
Y(273,1001)=0;
Fi=KLexpansion(1);  
%kl=zeros(20,301);
for i=1:1001;
    kl=randn(kl_term,1);
    Y(:,i)=Y_mean+Fi(:,1:kl_term)*kl;
end;
k_sorp=0.5*Y-15.95;
y1=[Y(:,1:1000);k_sorp(:,1:1000)];
y2=Y(:,1001);
y3=k_sorp(:,1001);
