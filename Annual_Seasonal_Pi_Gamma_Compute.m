%% Rootzone Gamma and Pi Computation
clear; clc; 

for layerIdx=2:3
[gamma,pi] = PiGammaAnnSesComput(layerIdx);
if layerIdx==2 ;save('F:\Projects\PhD_1_CSM_Estimation\Datasets\14_ERL_Major_Revision\PiGammaL2AnnSes.mat','gamma',"pi"); end
if layerIdx==3 ;save('F:\Projects\PhD_1_CSM_Estimation\Datasets\14_ERL_Major_Revision\PiGammaL3AnnSes.mat','gamma',"pi"); end
end

%% Surface Gamma Computation
clear; clc; tic

load('F:\Projects\PhD_1_CSM_Estimation\Datasets\14_ERL_Major_Revision\ERA5_Rootzone_CSM_Estimates_Model_Fit.mat')
flag(flag==0)=NaN; csm=csm.*flag;    csm(csm<0.03)=NaN; csm(csm>0.55)=NaN;

load F:\Projects\PhD_1_CSM_Estimation\Datasets\2_ERA5_SM_Grid_Wise_Timeseries\Valid_Daily_Mean_SM_L1_Mod.mat
smTSsurf=sm_valid;

clearvars -except csm smTSsurf

gammaSurf=NaN(size(csm,1),1);
for i=1:size(csm,1) % grid point index
    gammaSurf(i,1)= gammaComputeFun(smTSsurf(:,i),csm(i,1));
end

save('F:\Projects\PhD_1_CSM_Estimation\Datasets\14_ERL_Major_Revision\GammaSurfaceAnn.mat','gammaSurf');

toc

%% ==================================== FUNCTION ========================================
function [gamma,pi] = PiGammaAnnSesComput(layerIdx)
tic
% -------------------------------    Processing CSM  --------------------------------
load('F:\Projects\PhD_1_CSM_Estimation\Datasets\14_ERL_Major_Revision\ERA5_Rootzone_CSM_Estimates_Model_Fit.mat')
flag(flag==0)=NaN; csm=csm.*flag;    csm(csm<0.03)=NaN; csm(csm>0.55)=NaN;

% ---------------------------- SM data Processing    ----------------------------------
load F:\Projects\PhD_1_CSM_Estimation\Datasets\2_ERA5_SM_Grid_Wise_Timeseries\Valid_Daily_Mean_SM_L1_Mod.mat
smTSsurf=sm_valid;
if layerIdx==2; load F:\Projects\PhD_1_CSM_Estimation\Datasets\2_ERA5_SM_Grid_Wise_Timeseries\Valid_Daily_RootZoneSM_0to28cm.mat; smTSeval=theta_valid_0_28; end
if layerIdx==3; load F:\Projects\PhD_1_CSM_Estimation\Datasets\2_ERA5_SM_Grid_Wise_Timeseries\Valid_Daily_RootZoneSM_0to100cm.mat; smTSeval=theta_valid_0_100;end
clearvars -except csm smTSsurf smTSeval layerIdx

% ---------------------------- Seasonal Indexing ------------------------------------
t=datetime(2015,1,1):datetime(2022,12,31); 
mn=month(t)';   mn=mn(:);
idxDJF=find(mn==12 | mn==1 | mn==2);
idxMAM=find(mn==3  | mn==4 | mn==5);
idxJJA=find(mn==6  | mn==7 | mn==8);
idxSON=find(mn==9  | mn==10| mn==11);

% -------------------- Persistance of Water-Limited Regime ------------------------
gamma=NaN(size(csm,1),5);
for i=1:size(csm,1) % grid point index
    gamma(i,1)= gammaComputeFun (smTSeval(:,i),     csm(i,layerIdx));
    gamma(i,2)= gammaComputeFun (smTSeval(idxDJF,i),csm(i,layerIdx));
    gamma(i,3)= gammaComputeFun (smTSeval(idxMAM,i),csm(i,layerIdx));
    gamma(i,4)= gammaComputeFun (smTSeval(idxJJA,i),csm(i,layerIdx));
    gamma(i,5)= gammaComputeFun (smTSeval(idxSON,i),csm(i,layerIdx));
end % i loop ends

% -------------------- Similarity in Regime Identification ------------------------
pi=NaN(size(csm,1),5);
for i=1:size(csm,1) % grid point index
    pi(i,1)= piComputeFun (smTSsurf(:,i),smTSeval(:,i),     csm(i,[1 layerIdx]));
    pi(i,2)= piComputeFun (smTSsurf(idxDJF,i),smTSeval(:,i),csm(i,[1 layerIdx]));
    pi(i,3)= piComputeFun (smTSsurf(idxMAM,i),smTSeval(:,i),csm(i,[1 layerIdx]));
    pi(i,4)= piComputeFun (smTSsurf(idxJJA,i),smTSeval(:,i),csm(i,[1 layerIdx]));
    pi(i,5)= piComputeFun (smTSsurf(idxSON,i),smTSeval(:,i),csm(i,[1 layerIdx]));
end % i loop ends

toc

end % Function ends
