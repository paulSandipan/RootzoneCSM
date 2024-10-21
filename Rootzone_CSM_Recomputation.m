clear; clc

%% Load the Data sets
load E:\1_Critical_SM\Datasets\D_GLDAS_dT_Grid_Wise_Timeseries\GLDAS_Valid_Daily_dT_MaxMin.mat

load E:\1_Critical_SM\Datasets\B_A_ERA5_SM_Grid_Wise_Timeseries\Valid_Daily_RootZoneSM_0to28cm.mat
load E:\1_Critical_SM\Datasets\B_A_ERA5_SM_Grid_Wise_Timeseries\Valid_Daily_RootZoneSM_0to100cm.mat

dT=valid_dT; smL2=theta_valid_0_28;  smL3=theta_valid_0_100;

t=(datetime(2015,1,1):datetime(2022,12,31))';


%%
clearvars -except dT smL2 smL3 t lat

tic; clc

paramsOrgMod1 = NaN(size(smL2,2),3); paramsMod1 = NaN(size(smL2,2),3); RSSMod1 = NaN(size(smL2,2),1);
aicModSelect1 = NaN(size(smL2,2),1); modelFlag1 = NaN(size(smL2,2),1); modelBIC1 = NaN(size(smL2,2),1);
edgeflag1 = NaN(size(smL2,2),1); xMax1 = NaN(size(smL2,2),1); NE1 = NaN(size(smL2,2),1); dTsmCriteria1 = NaN(size(smL2,2),1);
slopeDiff1 = NaN(size(smL2,2),1); ddTLowMed1 = NaN(size(smL2,2),1);

paramsOrgMod2 = NaN(size(smL2,2),3); paramsMod2 = NaN(size(smL2,2),3); RSSMod2 = NaN(size(smL2,2),1);
aicModSelect2 = NaN(size(smL2,2),1); modelFlag2 = NaN(size(smL2,2),1); modelBIC2 = NaN(size(smL2,2),1);
edgeflag2 = NaN(size(smL2,2),1); xMax2 = NaN(size(smL2,2),1); NE2 = NaN(size(smL2,2),1);
dTsmCriteria2 = NaN(size(smL2,2),1); slopeDiff2 = NaN(size(smL2,2),1); ddTLowMed2 = NaN(size(smL2,2),1);


for ii = 1 : size(smL2,2)

    if lat(ii)<=60

        [ddValsL2, ddValsL3]= drydownVarVec(smL2(:,ii),smL3(:,ii),dT(:,ii),t);

        if ~isempty(ddValsL2) && size(ddValsL2,1)>40
            xL2 = ddValsL2(:,1);   yL2 = ddValsL2(:,end-1);
            if length(find(isnan(xL2)==0))>40 && length(find(isnan(yL2)==0))>40
            [paramsOrgMod1(ii,1:3),paramsMod1(ii,1:3), RSSMod1(ii,:), aicModSelect1(ii,:), modelFlag1(ii,:),...
                modelBIC1(ii,:), edgeflag1(ii,:),xMax1(ii,:), NE1(ii,:), dTsmCriteria1(ii,:), ...
                slopeDiff1(ii,:), ddTLowMed1(ii,:)] = fit_energydTNewV2(xL2',yL2',25);
            end
        end

        if ~isempty(ddValsL3) && size(ddValsL3,1)>40
            xL3 = ddValsL3(:,1);   yL3 = ddValsL3(:,end-1);
            if length(find(isnan(xL3)==0))>40 && length(find(isnan(yL3)==0))>40
            [paramsOrgMod2(ii,1:3),paramsMod2(ii,1:3), RSSMod2(ii,:), aicModSelect2(ii,:), modelFlag2(ii,:),...
                modelBIC2(ii,:), edgeflag2(ii,:),xMax2(ii,:), NE2(ii,:), dTsmCriteria2(ii,:), ...
                slopeDiff2(ii,:), ddTLowMed2(ii,:)] =fit_energydTNewV2(xL3',yL3',25);
            end
        end

        % Saving the Outputs
        if rem(ii,1000)==0 || ii==size(smL2,2)
            pathOut='E:\1_Critical_SM\Codes\ERL_Revision\';

            save([pathOut 'CSM_Estimation_ERA5_L2.mat'],...
                'paramsOrgMod1', 'paramsMod1', 'RSSMod1', ...
                'aicModSelect1', 'modelFlag1', 'modelBIC1', ...
                'edgeflag1', 'xMax1', 'NE1', 'dTsmCriteria1', ...
                'slopeDiff1','ii','-v7.3')

            save([pathOut 'CSM_Estimation_ERA5_L3.mat'],...
                'paramsOrgMod2', 'paramsMod2', 'RSSMod2', ...
                'aicModSelect2', 'modelFlag2', 'modelBIC2', ...
                'edgeflag2', 'xMax2', 'NE2', 'dTsmCriteria2', ...
                'slopeDiff2', 'ii','-v7.3')
        end

        if rem(ii,2000)==0; disp(['Computation of ' num2str(ii) ' grid locations are done']); end

    end % lat condition ends

end % ii for loop ends

toc



