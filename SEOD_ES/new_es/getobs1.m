function y = getobs1(obs_rand)

a=zeros(546,1);
ex=importdata('head_all.dat');
a(1:273,1)=ex.data(:,4);
ex=importdata('concen1_all.dat');
a(274:546,1)=ex.data(:,4);
y=a;

end