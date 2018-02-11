function [C,Ceq] = nonlcon(o)
Ceq=[];
if numel(unique(o))==2
    C=0;
else
    C=1;
end
    
