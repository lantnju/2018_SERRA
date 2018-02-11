function y = getobs(obs)
a=zeros(2*obs,1);
ex=importdata('head_all.dat');
a(1:obs,1)=ex.data(:,4);
ex=importdata('concen1_all.dat');
a(1+obs:2*obs,1)=ex.data(:,4);
y=a;