%% Plotting the Annual and Seasonal Pi
load('F:\Projects\PhD_1_CSM_Estimation\Datasets\14_ERL_Major_Revision\PiGammaL2AnnSes.mat','gamma','pi');
dataSave(:,1:2:10)=pi; 
load('F:\Projects\PhD_1_CSM_Estimation\Datasets\14_ERL_Major_Revision\PiGammaL3AnnSes.mat','gamma','pi');
dataSave(:,2:2:10)=pi; 
clearvars -except dataSave

col={'#4dbeee','#b746ff','#ff6929'}; medCol={'#6baed6','r'};
t=tiledlayout(5,8); nexttile(1,[2 2]); hold on
for i=1:2
    data=dataSave;
    if i==1;data(:,2:2:10)=NaN; else; data(:,1:2:10)=NaN; end
    boxchart(data,'BoxFaceColor',col{i},'MarkerStyle','none', ...
        'WhiskerLineStyle','--', 'WhiskerLineColor','#dbdbdb','LineWidth',1.2)
end

set(gca,'FontSize',14,'TickDir','out','XTick','','YLim',[0.2 1.01],'YTick',0.3:0.1:1)
area([0.3 10.5],[0.275 0.275],'FaceColor','#f0f0f0','EdgeColor','none')
yline([0.2 0.275 1.01]); xline(2.5:2:10.5)
x=1.5:2:10; txt={'ANN','DJF','MAM','JJA','SON'};
for i=1:5
    text(x(i),0.2375,txt{i},'FontSize',14,'HorizontalAlignment','center')
end
ylabel('\pi_S_u_r_f_a_c_e_ _& _R_o_o_t_z_o_n_e')

t.TileSpacing='loose';
t.Padding='compact';

%% Aridity Index, Biome Types and Climate Zone Wise Distribution
plotVec1=NaN(100316,36); plotVec2=NaN(100316,36);
for colIdx=1:2
    clear dummyVar
    dummyVar = depVarPiVals (colIdx);
    if colIdx==1; plotVec1(:,1:2:end)=dummyVar; end
    if colIdx==2; plotVec2(:,2:2:end)=dummyVar; end
end
clearvars -except plotVec2 plotVec1 t col
nexttile(17,[2 6])

for i=1:2
    if i==1;data=plotVec1; else; data=plotVec2; end
    boxchart(data,'BoxFaceColor',col{i},'MarkerStyle','none', ...
        'WhiskerLineStyle','--','WhiskerLineColor','#dbdbdb','LineWidth',1.2)
    hold on
end

set(gca,'FontSize',14,'TickDir','out','XTick','','YLim',[0.4 1.01],'YTick',0.5:0.1:1,'TickLength',[0.005 0.005])
area([0.3 36.5],[0.45 0.45],'FaceColor','#f0f0f0','EdgeColor','none')
yline([0.4 0.45 1.01]);   xline(2.5:2:36.5)
txt={'HA','A','SA','DSH','SH','H','EBF','DBF','MF','OSH','SAV','GRA',...
    'CRO','Trop','Dry','Subtrop','Temp','Cont'};
x=1.5:2:36;
for i=1:length(x)
    text(x(i),0.425,txt{i},'FontSize',14,'HorizontalAlignment','center')
end
ylabel('\pi_S_u_r_f_a_c_e_ _& _R_o_o_t_z_o_n_e')

%% Scatter - [Rootzone CSM & (Rootzone SM | SurfaceSM=CSM)]
load('F:\Projects\PhD_1_CSM_Estimation\Datasets\14_ERL_Major_Revision\ERA5_Rootzone_CSM_Estimates_Model_Fit.mat')
flag(flag==0)=NaN; csm=csm.*flag;    csm(csm<0.03)=NaN; csm(csm>0.55)=NaN;
clearvars -except t col csm
load('F:\Projects\PhD_1_CSM_Estimation\Datasets\14_ERL_Major_Revision\CondMeanRootzoneSM_SurfCSM.mat','condMean')
tlIdx=[3 5];
xTxt={'E(\theta_0_-_2_8_c_m \mid \theta_s_u_r_f=\theta*_s_u_r_f)',...
    'E(\theta_0_-_1_0_0_c_m \mid \theta_s_u_r_f=\theta*_s_u_r_f)'};
yTxt={'Rootzone (0-28cm) \theta*','Rootzone (0-100cm) \theta* '};

for i=1:2
    nexttile(tlIdx(i),[2 2])
    x=condMean(:,i); x(x==0 | x>0.6)=NaN; 
    y= csm(:,i+1);   y(y==0 | y>0.6)=NaN; 
    z=x-y;
    scatter(x,y,7,z,'o','filled','MarkerFaceAlpha',0.3)
    set(gca,'FontSize',14,'TickDir','out','Color',ones(1,3)*0.98, ...
        'GridLineWidth',1,'XTick',0:0.1:0.6,'YTick',0:0.1:0.6, ...
        'Layer','bottom','GridLineStyle','--','CLim',[-0.15 0.15])
    pbaspect([1 1 1]);    xline(0.6);   yline(0.6)
    hold on;  plot([0 0.6],[0 0.6],'--k')
    grid on
    xlabel(xTxt{i});   ylabel(yTxt{i})

    ols=fitlm(x,y);    ols.Coefficients.Estimate;
    yPred=ols.Coefficients.Estimate(1)+ols.Coefficients.Estimate(2)*(0:0.05:0.6);
    
    ols.Rsquared;    r=corrcoef(x,y,'Rows','complete');
    text(0.03,0.56,['R^2 = ' num2str(round(r(1,2)^2,3))],'FontSize',14)

end
addpath F:\Projects\Colorpmaps\ColorBrewer_v2\cbrewer2\
cMap=cbrewer2('RdBu');
colormap(cMap(25:end-25,:))

txt='E(\theta_r_o_o_t \mid \theta_s_u_r_f=\theta*_s_u_r_f) - \theta*_r_o_o_t';
cb=colorbar; 
cb.Ticks=-0.15:0.05:0.15;
tikLab=string(-0.15:0.05:0.15); 
tikLab(1)=strcat("< ",tikLab(1));
tikLab(end)=strcat("> ",tikLab(end));
cb.TickLabels=tikLab;
cb.Layout.Tile=7;
cb.Label.String=txt;
cb.FontSize=14;

%% Defining the functions

function dummyVar = depVarPiVals (colIdx)
% -------------------------------  Pi Data ------------------------------
load E:\1_Critical_SM\Datasets\RootZone2_Pi_gamma_vals.mat gamma pi
gamma(isnan(pi(:,1)) | isnan(pi(:,2)))=NaN;
data(:,1)=gamma;
load E:\1_Critical_SM\Datasets\RootZone3_Pi_gamma_vals.mat gamma pi
gamma(isnan(pi(:,1)) | isnan(pi(:,2)))=NaN;
data(:,2)=gamma;

%------------------------------ Aridity Index--------------------------
load F:\Projects\PhD_1_CSM_Estimation\Datasets\8_Confounding_Variables\AI_Vals.mat validAIgrid
ai=validAIgrid;
aiClass=NaN(length(validAIgrid),1);
aiClass(find(ai<0.03))=1;                aiClass(find(ai>=0.03 & ai<0.2))=2;
aiClass(find(ai>=0.2 & ai<0.5))=3;       aiClass(find(ai>=0.5 & ai<0.65))=4;
aiClass(find(ai>=0.65 & ai<1))=5;        aiClass(find(ai>=1 & ai<1.5))=6;
uqAI=unique(aiClass(isnan(aiClass)==0));
dummyAI=ones(length(data),length(uqAI)).*data(:,colIdx);
for i=1:length(uqAI)
    idx=find(aiClass~=uqAI(i));
    dummyAI(idx,i)=NaN;
    length(find(isnan(dummyAI(:,i))==0));
end


%--------------------------- Biome type ---------------------------------
load F:\Projects\PhD_1_CSM_Estimation\Datasets\8_Confounding_Variables\BiomeTypes_IGBP_Class.mat validBiomeGrid
validBiomeGrid(validBiomeGrid==9)=8;
validBiomeGrid(validBiomeGrid==14)=12;
uqBiome=[2,4,5,7,8,10,12];% unique(validBiomeGrid(isnan(validBiomeGrid)==0));
dummyBiome=ones(length(data),length(uqBiome)).*data(:,colIdx);
for i=1:length(uqBiome)
    idx=find(validBiomeGrid~=uqBiome(i));
    dummyBiome(idx,i)=NaN;
end

% -------------------   Koppen-Gieger Regions  ----------------------
load F:\Projects\PhD_1_CSM_Estimation\Datasets\8_Confounding_Variables\KG_Zones_Climate_Class.mat validKGGrid
validKGGrid(validKGGrid==2)=1;      validKGGrid(validKGGrid==3)=1;
validKGGrid(validKGGrid==5)=4;      validKGGrid(validKGGrid==6)=4;
validKGGrid(validKGGrid==7)=4;      validKGGrid(validKGGrid==9)=8;
validKGGrid(validKGGrid==11)=8;     validKGGrid(validKGGrid==12)=8;
validKGGrid(validKGGrid==15)=14;    validKGGrid(validKGGrid==26)=25;
uqClim=[1,4,8,14,25]; unique(validKGGrid(isnan(validKGGrid)==0));
dummyClim=ones(length(data),length(uqClim)).*data(:,colIdx);
for i=1:length(uqClim)
    idx=find(validKGGrid~=uqClim(i));
    dummyClim(idx,i)=NaN;
end

dummyVar=[dummyAI dummyClim dummyBiome];
end


