clear; clc; tic

% -------------------------------    Processing CSM  --------------------------------
load('F:\Projects\PhD_1_CSM_Estimation\Datasets\14_ERL_Major_Revision\ERA5_Rootzone_CSM_Estimates_Model_Fit.mat')
flag(flag==0)=NaN; csm=csm.*flag;    csm(csm<0.03)=NaN; csm(csm>0.55)=NaN;
clearvars -except csm

% ---------------------------- SM data Processing    ----------------------------------
load F:\Projects\PhD_1_CSM_Estimation\Datasets\2_ERA5_SM_Grid_Wise_Timeseries\Valid_Daily_Mean_SM_L1_Mod.mat
inMtrx1=sm_valid;
clearvars -except csm inMtrx1

for ii=1:2 % number of layer
    if ii==1; load F:\Projects\PhD_1_CSM_Estimation\Datasets\2_ERA5_SM_Grid_Wise_Timeseries\Valid_Daily_RootZoneSM_0to28cm.mat; inMtrx2=theta_valid_0_28;   end
    if ii==2; load F:\Projects\PhD_1_CSM_Estimation\Datasets\2_ERA5_SM_Grid_Wise_Timeseries\Valid_Daily_RootZoneSM_0to100cm.mat; inMtrx2=theta_valid_0_100; end
    clearvars -except csm inMtrx1 inMtrx2 ii condMean

    for j=1:size(inMtrx2,2)
        if ~isnan(csm(j,1)) && ~isnan(csm(j,ii+1))
            sm1=inMtrx1(:,j);
            idx=find(sm1>= csm(j,1)-0.005 & sm1<= csm(j,1)+0.005);
            condMean(j,ii)=mean(inMtrx2(idx,j),'omitmissing');
        else
            condMean(j,ii)=NaN;
        end
    end

end

save('F:\Projects\PhD_1_CSM_Estimation\Datasets\14_ERL_Major_Revision\CondMeanRootzoneSM_SurfCSM.mat','condMean')

toc
