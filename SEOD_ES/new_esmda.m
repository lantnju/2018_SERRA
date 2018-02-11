clear all;close all;clc;
cd /hydrosphere/lantian/running/EnOpt/new_es/;
global N mf vf x_p x_p_error yh Obs_Node_space varR R1 R2 R varR_all Obs_Num Node_Num t kl_term
load data.mat;
N=100;
timestep=2;
Obs_Num=2;
lb=1*ones(1,Obs_Num);
ub=77*ones(1,Obs_Num);  %137备选观测井总数
% opts=gaoptimset('PlotFcns',@gaplotbestf);
IntCon=1:Obs_Num;
%R=zeros(2*Obs_Num);
varR=zeros(10*Obs_Num,10*Obs_Num);
Na = 4;         % multiple times of data assimilation
alpha = [4,4,4,4];      % coffecients

% preallocation
Obs_Node_design=zeros(Obs_Num,timestep);
Y_est_en=zeros(2*Node_Num,N,Na,timestep);
x=zeros(2*Node_Num,N);
x(1:2*Node_Num,:)=Y_prior(:,1:N);
y=zeros(2*Node_Num,N,timestep*5,Na);
y_es=zeros(2*Node_Num,N,timestep*5);
%h=waitbar(0,'Please wait...');
for t=1:timestep
%    waitbar(t/timestep,h)
    % optimal design
    x_p=DimR(x(1:2*Node_Num,:),kl_term);
    mf=mean(x_p,2);     % forecasted
    vf=cov(x_p');
    for i = 1:N
        for j=1+(t-1)*5:t*5
            writeinpar(x(1:Para_Num,i),x(1+Para_Num:2*Para_Num,i),Para_Num);
            filechange(j);
            unix('./all.sh>null');
            %system('allrun.bat');
            y_es(:,i,j) = getobs(Node_Num); 
        end;
    end;
    yh=y_es(:,:,1+(t-1)*5:t*5);
    %x=[x(1:2*Node_Num,:);yh]; 
    x_average=mean(x,2);
    x_error=x-repmat(x_average,1,N);
    x_p_error=x_p-repmat(mf,1,N);
    str1='ga(@H1D4,Obs_Num,[],[],[],[],lb,ub,@nonlcon,IntCon)';
    [~,m,fval,exitflag,output]=evalc(str1);
    Obs_Node_design(:,t)=Obs_Node_space(m);
    T1=Obs_Node_design(:,t);
    %Obs_Node(1:Obs_Num)=Obs_Node_design(:,t); 
    %Obs_Node(1+Obs_Num:2*Obs_Num)=Obs_Node_design(:,t)+Node_Num;
    Obss_new=[Obss(1+(t-1)*5,T1);Obss(2+(t-1)*5,T1);Obss(3+(t-1)*5,T1);Obss(4+(t-1)*5,T1);Obss(5+(t-1)*5,T1);Obss(1+(t-1)*5,T1+Node_Num);...
                 Obss(2+(t-1)*5,T1+Node_Num);Obss(3+(t-1)*5,T1+Node_Num);Obss(4+(t-1)*5,T1+Node_Num);Obss(5+(t-1)*5,T1+Node_Num)];
    Obss_new = Obss_new';
    %R=varR_all(Obs_Node,t);
    for i=1:5*Obs_Num
       varR(i,i)=R1;
    end;
    for i=1+5*Obs_Num:10*Obs_Num
       varR(i,i)=R2;
    end;
    for j = 1:Na
        for i = 1:N
            for l=1+(t-1)*5:t*5
                writeinpar(x(1:Para_Num,i),x(1+Para_Num:2*Para_Num,i),Para_Num);
                filechange(l);
                unix('./all.sh>null');
                %system('allrun.bat');
                y(:,i,l,j) = getobs(Node_Num); 
            end;
        end;  
        y_new=squeeze([y(T1,:,1+(t-1)*5);y(T1,:,2+(t-1)*5);y(T1,:,3+(t-1)*5);y(T1,:,4+(t-1)*5);y(T1,:,5+(t-1)*5);y(T1+Node_Num,:,1+(t-1)*5);...
                      y(T1+Node_Num,:,2+(t-1)*5);y(T1+Node_Num,:,3+(t-1)*5);y(T1+Node_Num,:,4+(t-1)*5);y(T1+Node_Num,:,5+(t-1)*5)]);
        obst_es(1:5*Obs_Num,1) = Obss_new(1:5*Obs_Num)+sqrt(alpha(j))*sqrt(R1)*randn(5*Obs_Num,1);
        obst_es(1+5*Obs_Num:10*Obs_Num,1) = Obss_new(1+5*Obs_Num:10*Obs_Num,1)+sqrt(alpha(j))*sqrt(R2)*randn(5*Obs_Num,1);
        Obst = repmat(obst_es,1,N);
        x_average=mean(x,2);
        x_error=x-repmat(x_average,1,N);
        y_average=mean(y_new,2);
        y_error=y_new-repmat(y_average,1,N);
        ph=x_error*y_error'/(N-1);
        hph=y_error*y_error'/(N-1);
        k=ph/(hph+varR);
        x=x+k*(Obst-y_new);
        Y_est_en(:,:,j,t)=x(1:2*Node_Num,:);
    end;
end;

save SEOD_ESmda.mat;
%% result analysis
%Y_est=mean(Y_est_en(:,:,end),2);
%Y_est_total=mean(Y_est_en(:,:,:),2);
%RMSE1_total=sqrt(mean((squeeze(Y_est_total(1:273,:,:))-repmat(HK_TRUE,1,timestep)).^2));
%RMSE2_total=sqrt(mean((squeeze(Y_est_total(274:546,:,:))-repmat(k_tce_TRUE,1,timestep)).^2));
%for t=1:timestep
%    Spread1_total(t)=sqrt(mean(var(Y_est_en(1:273,:,t)')));
%end
%for t=1:timestep
%    Spread2_total(t)=sqrt(mean(var(Y_est_en(274:546,:,t)')));
%end


%% plot the log hydraulic conductivity field
%field=reshape(Y_true,21,21); 
%subplot(2,1,1)
%contourf(flipud(field'),15);   % reference field
%Y_est=mean(Y_est_en(:,:,end),2);
%Y_est_total=mean(Y_est_en(:,:,:),2);
%field=reshape(Y_est,21,21);
%subplot(2,1,2)
%contourf(flipud(field'),15);  % estimated field by conventional sampling strategy
%RMSE=sqrt(mean((Y_est-Y_true).^2));
%RMSE_total=sqrt(mean((squeeze(Y_est_total)-repmat(Y_true,1,timestep)).^2));
%Spread=sqrt(mean(var(Y_est_en(:,:,end)')));
%for t=1:timestep
%    Spread_total(t)=sqrt(mean(var(Y_est_en(:,:,t)')));
%end