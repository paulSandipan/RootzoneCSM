%% Preproces the Datasets
clear; clc; tic

% Load Critical Soil Mositure Datasets
load('F:\Projects\PhD_1_CSM_Estimation\Datasets\14_ERL_Major_Revision\ERA5_Rootzone_CSM_Estimates_Model_Fit.mat')
flag(flag==0)=NaN; csm=csm.*flag;    csm(csm<0.03)=NaN; csm(csm>0.55)=NaN;

% Load Gamma & Pi Datasets
load('F:\Projects\PhD_1_CSM_Estimation\Datasets\14_ERL_Major_Revision\GammaSurfaceAnn.mat','gammaSurf');
gammaAnn(:,1)=gammaSurf;
load('F:\Projects\PhD_1_CSM_Estimation\Datasets\14_ERL_Major_Revision\PiGammaL2AnnSes.mat','gamma','pi');
gammaAnn(:,2)=gamma(:,1);    piAnn(:,1)=pi(:,1); 
load('F:\Projects\PhD_1_CSM_Estimation\Datasets\14_ERL_Major_Revision\PiGammaL3AnnSes.mat','gamma','pi');
gammaAnn(:,3)=gamma(:,1);   piAnn(:,2)=pi(:,1); 

%% Plotting Critical Soil Mositure Estimates
clearvars -except piAnn gammaAnn csm; clc
clf; t=tiledlayout(2,4);
lim=[0 0.6; 0 0.6; -0.2 0.2; 0 1; 0 1; -0.6 0.6]; diff=[0.1 0.1 0.1 0.2 0.2 0.2];
xLab={'Surface (0-7 cm) \theta* (m^3 m^-^3)',...
    'Surface (0-7 cm) \theta* (m^3 m^-^3)',...
    'Surface - Rootzone (0-28 cm) \theta*',...
    'Surface (0-7 cm) \gamma',...
    'Surface (0-7 cm) \gamma',...
    'Surface - Rootzone (0-28 cm) \gamma'};
yLab={'Rootzone (0-28 cm) \theta* (m^3 m^-^3)',...
    'Rootzone (0-100 cm) \theta* (m^3 m^-^3)',...
    'Surface - Rootzone (0-100 cm) \theta*',...
    'Rootzone (0-28 cm) \gamma',...
    'Rootzone (0-100 cm) \gamma',...
    'Surface - Rootzone (0-100 cm) \gamma'};
txtLoc=[0.008 0.547;0.008 0.547;-0.195 0.1645; 0.014 0.913; 0.014 0.913; -0.583 0.49485];
tlLoc=[1 2 3 5 6 7];
cLim=[0.5 1;0.5 1;-0.3 0.3];
figNum={'(a)','(b)','(c)','(d)','(e)','(f)'};
figLoc=[-0.12 0.625; -0.12 0.625; -0.29 0.22; -0.18 1.03; -0.18 1.03; -0.84 0.63];

for i=1:6
    ax=nexttile(tlLoc(i));
    if i<=2; x=csm(:,1); y=csm(:,i+1); 
    elseif i==3; x=csm(:,1)-csm(:,2); y=csm(:,1)-csm(:,3);
    elseif i>=4 && i<=5; x=gammaAnn(:,1); y=gammaAnn(:,i-2); z=piAnn(:,i-3);
    else; x=gammaAnn(:,1)-gammaAnn(:,2); y=gammaAnn(:,1)-gammaAnn(:,3); z=piAnn(:,1)-piAnn(:,2);
    end   
    
    idx=isnan(x) | isnan(y);    x(idx)=[];  y(idx)=[];
    if i<=3
        addpath F:\Projects\Matlab_Ext_Funs\Density_Scatter\
        dscatterV2(x,y);
    else
        z(idx)=[];
        scatter(x,y,8,z,'filled','MarkerFaceAlpha',0.5)
        clim(cLim(i-3,:))
    end

    [roh,p]=corr(x,y,'Rows','complete'); roh=round(roh,2);
    if p<0.05; check=' (p-value < 0.05)';    else; check=''; end
    ols=fitlm(x,y); m=ols.Coefficients.Estimate(2); c=ols.Coefficients.Estimate(1);
    xHat=linspace(min(x),max(x),50);     yHat=m*xHat+c; hold on;

    plot(xHat,yHat,'k','LineWidth',1.5,'LineStyle','--');       
    plot(lim(i,:),lim(i,:),'--','Color','#737373')

    idx1=find(isnan(x)==0); idx2=find(isnan(y)==0); n=length(intersect(idx1,idx2));
    if i==1;  txt={['\rho = ',num2str(roh),check,' , n = ',num2str(n)],['\theta*_S_u_r_f = ',num2str(round(m,2)),' \times \theta*_2_8_c_m ',num2str(abs(round(c,2)))]}; end
    if i==2; txt={['\rho = ',num2str(roh),check,' , n = ',num2str(n)],['\theta*_S_u_r_f = ',num2str(round(m,2)),' x \theta*_1_0_0_c_m  - ',num2str(abs(round(c,2)))]}; end
    if i==3; txt={['\rho = ',num2str(roh),check,' , n = ',num2str(n)],['\theta*_S_u_r_f_-_2_8_c_m = ',num2str(round(m,2)),' x \theta*_S_u_r_f_-_1_0_0_c_m  - ',num2str(abs(round(c,2)))]}; end
    if i==4;  txt={['\rho = ',num2str(roh),check,' , n = ',num2str(n)],['\gamma_S_u_r_f = ',num2str(round(m,2)),' \times \gamma_2_8_c_m ',num2str(abs(round(c,2)))]}; end
    if i==5; txt={['\rho = ',num2str(roh),check,' , n = ',num2str(n)],['\gamma_S_u_r_f = ',num2str(round(m,2)),' x \gamma_1_0_0_c_m  - ',num2str(abs(round(c,2)))]}; end
    if i==6; txt={['\rho = ',num2str(roh),check,' , n = ',num2str(n)],['\gamma_S_u_r_f_-_2_8_c_m = ',num2str(round(m,2)),' x \gamma_S_u_r_f_-_1_0_0_c_m  - ',num2str(abs(round(c,2)))]}; end
    
    text(txtLoc(i,1),txtLoc(i,2),txt,"FontSize",12,'EdgeColor','k')

    set(gca,'FontSize',14,'FontWeight','normal','XLim',lim(i,:),'YLim',lim(i,:), ...
        'XTick',lim(i,1):diff(i):lim(i,2),'YTick',lim(i,1):diff(i):lim(i,2),'Box','off')
    pbaspect([1 1 1])
    xline(lim(i,2),'k'); yline(lim(i,2),'k')
    xlabel(xLab{i});   ylabel(yLab{i})

    if i<=3
        addpath F:\Projects\Colorpmaps\ColorBrewer_v2\cbrewer2\
        colormap(ax,flip(cbrewer2('Spectral')))
    elseif i>=4 && i<=5
        addpath F:\Projects\Colorpmaps\NCL_Colormaps\
        colormap(ax,MPL_Spectral)
    else
        addpath F:\Projects\Colorpmaps\ColorBrewer_v2\cbrewer2\
        colormap(ax,flip(cbrewer2('BrBG')))
    end

   text(figLoc(i,1),figLoc(i,2),figNum{i},"FontSize",18)
end

