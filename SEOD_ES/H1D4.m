function opt=H1D4(o)
global N mf vf x_p x_p_error yh Obs_Node_space varR R1 R2 R varR_all Obs_Num Node_Num t kl_term
%zero=zeros(kl_term,kl_term);
T=Obs_Node_space(o);
%Obs_Node(1:Obs_Num)=T; 
%Obs_Node(1+Obs_Num:2*Obs_Num)=T+Node_Num;
y=squezze([yh(T,:,1);yh(T,:,2);yh(T,:,3);yh(T,:,4);yh(T,:,5);...
  yh(T+Node_Num,:,1);yh(T+Node_Num,:,2);yh(T+Node_Num,:,3);yh(T+Node_Num,:,4);yh(T+Node_Num,:,5)]);
%R=varR_all(Obs_Node,t);
for i=1:5*Obs_Num
    varR(i,i)=R1;
end;
for i=1+5*Obs_Num:10*Obs_Num
    varR(i,i)=R2;
end;
y_average=mean(y,2);
y_error=y-repmat(y_average,1,N);
ph=x_p_error*y_error'/(N-1);
hph=y_error*y_error'/(N-1);
y(1:5*Obs_Num,:)=y(1:5*Obs_Num,:)+sqrt(R1)*randn(5*Obs_Num,N);
y(1+5*Obs_Num:Obs_Num*10,:)=y(1+5*Obs_Num:Obs_Num*10,:)+sqrt(R2)*randn(5*Obs_Num,N);
%for i=1:N
    %for j=1+Obs_Num:Obs_Num*5
    %    y(j,i)=y(j,i)+sqrt(abs(R2*y(j,i)))*randn(1,1);
   % end;
%end;
Obs1=zeros(10*Obs_Num,N);
R_entropy=zeros(N,1);
for n=1:N
    for i=1:N
        Obs1(1:5*Obs_Num,i)=y(1:5*Obs_Num,n)+sqrt(R1)*randn(5*Obs_Num,1);
        Obs1(5*Obs_Num+1:10*Obs_Num,i)=y(5*Obs_Num+1:10*Obs_Num,n)+sqrt(R2)*randn(5*Obs_Num,1);
        %for j=Obs_Num+1:5*Obs_Num
         %    Obs1(j,i) = y(j,n)+sqrt(abs(R2*y(j,n)))*randn(1,1);
        %end;
    end
    k=ph/(hph+varR);
    x1=x_p+k*(Obs1-y);
    ma=mean(x1,2);     % updated
    va=cov(x1');
    R_entropy(n)=RE(ma,va,mf,vf);
end
opt=-mean(R_entropy);