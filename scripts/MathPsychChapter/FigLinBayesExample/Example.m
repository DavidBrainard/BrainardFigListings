% Clearclear; close all;% Figure parameterscurDir = pwd;masterFigParamsDir = getpref('bfScripts','masterFigParamsDir');cd(masterFigParamsDir);figParams = MasterFigParams;cd(curDir);if (exist('../SecondaryFigParams','file'))    cd ..    figParams = SecondaryFigParams(figParams);    cd(curDir);end% Viewpointaz = -40; el = 64;xlRot = 43.05;ylRot = -49.8;% Set up discrete coordinate systemreality_x = linspace(0,1,100);reality_y = linspace(0,1,100);dArea = (reality_x(2)-reality_x(1))*(reality_y(2)-reality_y(1));% Set up prior pdfpriorVar1 = 160/10000;priorVar2 = 160/10000;priorR2 = 0.8;priorCov = priorR2*sqrt(priorVar1)*sqrt(priorVar2);prior_u = [0.5 0.5]';prior_K = [priorVar1 priorCov ; priorCov priorVar2];prior_pdf = BiNormalPDF(reality_x,reality_y,prior_u,prior_K);priorVolume = sum(prior_pdf(:))*dArea;if (abs(priorVolume-1) > 0.01)    error('Prior volume not close enough to unity');endfigParams.figName = 'PriorFigure';theFig = figure; clf; hold onset(gcf,'Position',[100 100 figParams.sqSize figParams.sqSize]);set(gca,'FontName',figParams.fontName,'FontSize',figParams.axisFontSize-4,'LineWidth',figParams.axisLineWidth);mesh(reality_x,reality_y,prior_pdf);axis('square');view(az,el);xl = xlabel('Pixel 1 radiance');set(xl,'Rotation',40.5);set(xl,'Position',[0.2 -0.2246 -1.6721]);yl = ylabel('Pixel 2 radiance');set(yl,'Rotation',-48.5);set(yl,'Position',[-0.2411 0.14   -1.8420]);zl = zlabel('Probability density');tl = title('Prior');FigureSave(fullfile(pwd,[mfilename '_' figParams.figName]),theFig,figParams.figType);% Render matrixR = [0.5 0.5];noise_sd = 0.01;noise_K = eye(1)*noise_sd^2;% Observationy = 0.3;% Compute likelihood over domain of xfor ii = 1:length(reality_x)    for jj = 1:length(reality_y)        likelihood(ii,jj) = NormalPDF(R*[reality_x(ii),reality_y(jj)]',y,noise_K);    endendfigParams.figName = 'LikeliFigure';theFig = figure; clf; hold onset(gcf,'Position',[100 100 figParams.sqSize figParams.sqSize]);set(gca,'FontName',figParams.fontName,'FontSize',figParams.axisFontSize-4,'LineWidth',figParams.axisLineWidth);mesh(reality_x,reality_y,likelihood);axis('square');view(az,el);xl = xlabel('Pixel 1 radiance');set(xl,'Rotation',40.5);set(xl,'Position',[0.2 -0.2246 -1.6721]);yl = ylabel('Pixel 2 radiance');set(yl,'Rotation',-48.5);set(yl,'Position',[-0.2411 0.14   -1.8420]);zl = zlabel('Probability density');tl = title('Likelihood');FigureSave(fullfile(pwd,[mfilename '_' figParams.figName]),theFig,figParams.figType);% Posterior analytic[posterior_u,posterior_K] = NormalPosterior(y,... 	                            prior_u,prior_K,...                              R,noise_K);posterior_pdf = BiNormalPDF(reality_x,reality_y,...                              posterior_u,posterior_K);posteriorVolume = sum(posterior_pdf(:))*dArea;if (abs(posteriorVolume-1) > 0.01)    error('Posterior volume not close enough to unity');endfigParams.figName = 'PosteriorFigure';theFig = figure; clf; hold onset(gcf,'Position',[100 100 figParams.sqSize figParams.sqSize]);set(gca,'FontName',figParams.fontName,'FontSize',figParams.axisFontSize-4,'LineWidth',figParams.axisLineWidth);mesh(reality_x,reality_y,posterior_pdf);axis('square');view(az,el);xl = xlabel('Pixel 1 radiance');set(xl,'Rotation',40.5);set(xl,'Position',[0.2 -0.2246 -1.6721]);yl = ylabel('Pixel 2 radiance');set(yl,'Rotation',-48.5);set(yl,'Position',[-0.2411 0.14   -1.8420]);zl = zlabel('Probability density');tl = title('Posterior');FigureSave(fullfile(pwd,[mfilename '_' figParams.figName]),theFig,figParams.figType);% Posterior multiplyposterior_pdf_check = prior_pdf .* likelihood;posterior_pdf_check = posterior_pdf_check / (sum(posterior_pdf_check(:))*dArea);figParams.figName = 'PosteriorCheckFigure';theFig = figure; clf; hold onset(gcf,'Position',[100 100 figParams.sqSize figParams.sqSize]);set(gca,'FontName',figParams.fontName,'FontSize',figParams.axisFontSize-4,'LineWidth',figParams.axisLineWidth);mesh(reality_x,reality_y,posterior_pdf_check);axis('square');view(az,el);xl = xlabel('Pixel 1 radiance');set(xl,'Rotation',40.5);set(xl,'Position',[0.2 -0.2246 -1.6721]);yl = ylabel('Pixel 2 radiance');set(yl,'Rotation',-48.5);set(yl,'Position',[-0.2411 0.14   -1.8420]);zl = zlabel('Probability density');tl = title('Posterior Chk');FigureSave(fullfile(pwd,[mfilename '_' figParams.figName]),theFig,figParams.figType);