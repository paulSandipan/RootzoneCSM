function pi = piComputeFun (sm1,sm2,csm)

% Computation of pi: pi=n_w/n
%                    n_w=# days correct regimes are classified in both method
%                    n=total days with valid observation

if ~isnan(csm(1)) && ~isnan(csm(2))

    % Identify the regimes at all the timestamp
    clear idx
    identifyRegimes=NaN(length(sm1),2);
    % Utilise the first csm estimation method
    idx=find(sm1<csm(1));    identifyRegimes(idx,1)=1;
    idx=find(sm1>=csm(1));   identifyRegimes(idx,1)=2;
    % Utilise the second csm estimation method
    idx=find(sm2<csm(2));    identifyRegimes(idx,2)=1;
    idx=find(sm2>=csm(2));   identifyRegimes(idx,2)=2;

    % Find total days with valid observation
    n=length(sm1);

    % Identify the similarity in regime
    clear idxWLR idxELR
    idxWLR=find(identifyRegimes(:,1)==1 & identifyRegimes(:,2)==1);
    idxELR=find(identifyRegimes(:,1)==2 & identifyRegimes(:,2)==2);
    nw=length(idxWLR)+length(idxELR);
    pi=nw/n;

else
    pi=NaN;
end

end