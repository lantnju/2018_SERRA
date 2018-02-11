clear all;close all;clc;
load EnOpt_2D_300.mat;
initial_hk=Y_prior(1:273,:);
initial_k=Y_prior(274:546,:);
final_hk=Y_est_en(1:273,:,end);
final_k=Y_est_en(274:546,:,end);
%1-20 steps
obs=zeros(6,10,300);
initial=zeros(6,10,300);
true=zeros(6,10);
%21-40 steps
pre_obs=zeros(6,10,300);
pre_initial=zeros(6,10,300);
pre_true=zeros(6,10);
true_hk=HK_TRUE;
true_k=k_tce_TRUE;
Obsest_node=[68,140,207];
for i=1:2
    Obs_rand(1+3*(i-1):3*i)=Obsest_node+(i-1)*273;
end;
for i=1:N            
    for t=1:timestep                                       
        writeinpar(initial_hk(:,i),initial_k(:,i),Para_Num);
        filechange(t);
        unix('./all.sh > null');
        initial_all(:,t,i)=getobs1(Obs_rand); 
        initial(:,t,i)= initial_all(Obs_rand,t,i);
        
        writeinpar(final_hk(:,i),final_k(:,i),Para_Num);
        filechange(t);
        unix('./all.sh > null');
        obs_all(:,t,i)=getobs1(Obs_rand);
        obs(:,t,i)=obs_all(Obs_rand,t,i);
        
        writeinpar(initial_hk(:,i),initial_k(:,i),Para_Num);
        filechange(t+timestep);
        unix('./all.sh > null');
        pre_initial_all(:,t,i)=getobs1(Obs_rand);  
        pre_initial(:,t,i)=pre_initial_all(Obs_rand,t,i);
        
        writeinpar(final_hk(:,i),final_k(:,i),Para_Num);
        filechange(t+timestep);
        unix('./all.sh > null');
        pre_obs_all(:,t,i)=getobs1(Obs_rand);
        pre_obs(:,t,i)=pre_obs_all(Obs_rand,t,i);
    end;
end;                                                                                                  
for t=1:timestep                                       
    writeinpar(true_hk,true_k,Para_Num);
    filechange(t);
    unix('./all.sh > null');
    true_all(:,t)=getobs1(Obs_rand);   
    true(:,t)=true_all(Obs_rand,t); 
    
    writeinpar(true_hk,true_k,Para_Num);
    filechange(t+timestep);
    unix('./all.sh > null');
    pre_true_all(:,t)=getobs1(Obs_rand); 
    pre_true(:,t)=pre_true_all(Obs_rand,t);
end;   

save estANDpre;