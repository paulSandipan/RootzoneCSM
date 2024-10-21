function gamma= gammaComputeFun (sm,csm)

% Computation of gamma: gamma=n_c/n   
%                       n_c=# days when theta<theta*  
%                       n=total days with valid observation 

if ~isnan(csm)
    clear nc n idx
    idx=find(isnan(sm)==1);
    sm(idx)=[];
    nc=length(find(sm<csm));
    n=length(sm);
    gamma=nc/n;
else
    gamma=NaN;
end

end