clear all;close all;clc;
%% basic settings
N = 1000; % ensemble size
R1 = 1e-4;
R2 = 1e-12;
kl_term=60;
timestep = 10; % time steps
Obs_Num = 10;  % number of wells
Node_Num = 273; % number of para
%Case_Num = 4; % number of sampling strategies
Para_Num = Node_Num; % number of estimated parameters
varR_all = zeros(2*Node_Num,timestep);
R=zeros(2*Obs_Num);
varR=zeros(2*Obs_Num,2*Obs_Num);
for i=1:Node_Num
   varR_all(i,:) = 1e-4; % observation error of head
end;
for i=1+Node_Num:Node_Num*2
   varR_all(i,:) = 1e-12; % observation error of conc
end;

Obs_Node_space=[1:2:21 43:2:63 85:2:105 127:2:147 169:2:189 211:2:231 253:2:273];

%
lb=1*ones(1,Obs_Num);
ub=77*ones(1,Obs_Num);  %137备选观测井总数
% opts=gaoptimset('PlotFcns',@gaplotbestf);
IntCon=1:Obs_Num;

%% generate observations
% generate reference parameters according to the prior statistics
[Y_prior,HK_TRUE,k_tce_TRUE]=generation();

% generate observations 
Obss=zeros(2*Node_Num,timestep);
writeinpar(HK_TRUE,k_tce_TRUE,Para_Num); 
for t = 1:timestep
    filechange(t);
    unix('./all.sh > null');
    %system('allrun.bat');
    Obss(:,t) = getobs(Node_Num); 
end;
Obss=Obss';
Obs(:,1:Node_Num) = Obss(:,1:Node_Num)+sqrt(R1)*randn(timestep,Node_Num); 
Obs(:,Node_Num+1:2*Node_Num) = Obss(:,Node_Num+1:2*Node_Num)+sqrt(R2)*randn(timestep,Node_Num); 
%for t=1:timestep
    %for i=Node_Num+1:5*Node_Num
     %    Obs(t,i) = Obss(t,i)+sqrt(R2)*randn(1,1); 
     %    varR_all(i,t) = abs(R2*Obss(t,i));
    %end;
%end;
    

% generate observation ensemble
Obs_en = zeros(timestep,2*Node_Num,N);
for i = 1:N
    Obs_en(:,1:Node_Num,i) = Obs(:,1:Node_Num)+sqrt(R1)*randn(timestep,Node_Num); 
    Obs_en(:,Node_Num+1:2*Node_Num,i) = Obs(:,Node_Num+1:2*Node_Num)+sqrt(R2)*randn(timestep,Node_Num); 
    %for t=1:timestep
        %for j=Node_Num+1:5*Node_Num
         %    Obs_en(t,j,i) = Obs(t,j)+sqrt(R2)*randn(1,1);
        %end;
    %end;
end;

save data;