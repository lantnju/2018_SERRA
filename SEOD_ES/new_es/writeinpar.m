function writeinpar(Y,X,Nm)
hk=exp(Y);
k_tce=exp(X);
fid1=fopen('hk1.ref','w');
fid2=fopen('k_tce.dat','w');
for i=1:Nm;
  fprintf(fid1,'%.9e\n',hk(i));
  fprintf(fid2,'%.9e\n',k_tce(i));
end;
fclose(fid1);
fclose(fid2);