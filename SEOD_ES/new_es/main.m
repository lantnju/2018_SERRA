clear all;close all;clc;
cd /hydrosphere/lantian/running/EnOpt/wel_2_500/;
global N mf vf x_p x_p_error yh Obs_Node_space varR R1 R2 R varR_all Obs_Num Node_Num t kl_term
load data.mat;
N=500;
Obs_Num=2;
lb=1*ones(1,Obs_Num);
ub=77*ones(1,Obs_Num);  %137备选观测井总数
% opts=gaoptimset('PlotFcns',@gaplotbestf);
IntCon=1:Obs_Num;
R=zeros(2*Obs_Num);
varR=zeros(2*Obs_Num,2*Obs_Num);

% preallocation
Obs_Node_design=zeros(Obs_Num,timestep);
Y_est_en=zeros(2*Node_Num,N,timestep);
x=zeros(4*Node_Num,N);
x(1:2*Node_Num,:)=Y_prior(:,1:N);
y=zeros(2*Node_Num,N,timestep);
%h=waitbar(0,'Please wait...');
for t=1:timestep
%    waitbar(t/timestep,h)
    % optimal design
    x_p=DimR(x(1:2*Node_Num,:),kl_term);
    mf=mean(x_p,2);     % forecasted
    vf=cov(x_p');
    for i = 1:N
            writeinpar(x(1:Para_Num,i),x(1+Para_Num:2*Para_Num,i),Para_Num);
            filechange(t);
            unix('./all.sh>null');
            %system('allrun.bat');
            y(:,i,t) = getobs(Node_Num); 
    end;
    yh=squeeze(y(:,:,t));
    x=[x(1:2*Node_Num,:);yh]; 
    x_average=mean(x,2);
    x_error=x-repmat(x_average,1,N);
    x_p_error=x_p-repmat(mf,1,N);
    str1='ga(@H1D4,Obs_Num,[],[],[],[],lb,ub,@nonlcon,IntCon)';
    [~,m,fval,exitflag,output]=evalc(str1);
    Obs_Node_design(:,t)=Obs_Node_space(m);
    Obs_Node(1:Obs_Num)=Obs_Node_design(:,t); 
    Obs_Node(1+Obs_Num:2*Obs_Num)=Obs_Node_design(:,t)+Node_Num;
    Obst=squeeze(Obs_en(t,Obs_Node,1:N));
    R=varR_all(Obs_Node,t);
    for i=1:2*Obs_Num
       varR(i,i)=R(i);
    end;
    y_average=mean(yh(Obs_Node,:),2);
    y_error=yh(Obs_Node,:)-repmat(y_average,1,N);
    ph=x_error*y_error'/(N-1);
    hph=y_error*y_error'/(N-1);
    k=ph/(hph+varR);
    x=x+k*(Obst-yh(Obs_Node,:));
    Y_est_en(:,:,t)=x(1:2*Node_Num,:);
end;

Y_est=mean(Y_est_en(:,:,end),2);
Y_est_total=mean(Y_est_en(:,:,:),2);
RMSE1_total=sqrt(mean((squeeze(Y_est_total(1:273,:,:))-repmat(HK_TRUE,1,timestep)).^2));
RMSE2_total=sqrt(mean((squeeze(Y_est_total(274:546,:,:))-repmat(k_tce_TRUE,1,timestep)).^2));
for t=1:timestep
    Spread1_total(t)=sqrt(mean(var(Y_est_en(1:273,:,t)')));
end
for t=1:timestep
    Spread2_total(t)=sqrt(mean(var(Y_est_en(274:546,:,t)')));
end

save EnOpt_2_500;

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
    
