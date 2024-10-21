%% Prepare the Critical Soil Moisture Data
clear; clc
load('F:\Projects\PhD_1_CSM_Estimation\Datasets\14_ERL_Major_Revision\ERA5_Rootzone_CSM_Estimates_Model_Fit.mat')
flag(flag==0)=NaN; csm=csm.*flag;    csm(csm<0.03)=NaN; csm(csm>0.55)=NaN;
critSMroot=csm(:,2:3); clearvars -except critSMroot


%% Layer wise Input: Rootzone
clear inVec; inVec=critSMroot; colScheme={'#139fff','#ff6929'};
yLab={'Rootzone \theta^* (m^3 m^-^3)'}; txt={'',''}; 

% Plotting the Critical Soil Moisture Dependence wrt Confounding Variables
figure(1); clf; t=tiledlayout(3,4);

addpath F:\Projects\PhD_1_CSM_Estimation\Codes\Analysis_6\
AridityIndexDependence(inVec,1,colScheme,yLab,txt,2)
xlim([0 3.5]); xline(3.5); set(gca,'FontSize',14)

addpath F:\Projects\PhD_1_CSM_Estimation\Codes\Analysis_6\
ShortWaveRadDependence(inVec,2,colScheme, yLab,{'',''},2)
xlim([70 250]); xline(250); set(gca,'FontSize',14)

addpath F:\Projects\PhD_1_CSM_Estimation\Codes\Analysis_6\
WindDependence(inVec,5,colScheme,yLab,{'',''},2); set(gca,'FontSize',14)

addpath F:\Projects\PhD_1_CSM_Estimation\Codes\Analysis_6\
vpdDependence(inVec,6,colScheme,yLab,{'',''},2)
xlim([0 35]); xline(35);set(gca,'FontSize',14)

%%
figure(1);clf; t=tiledlayout(3,9);
addpath F:\Projects\PhD_1_CSM_Estimation\Codes\Analysis_6\
BiomeDependence(inVec,1,colScheme, {''},{'',''})
xline(2.5:2:14.5); yline(0.6); set(gca,'FontSize',14)

addpath F:\Projects\PhD_1_CSM_Estimation\Codes\Analysis_6\
ClimateZoneDependence(inVec,4,colScheme,{''},{'',''})
xline(2.5:2:12); yline(0.6); set(gca,'FontSize',14)

