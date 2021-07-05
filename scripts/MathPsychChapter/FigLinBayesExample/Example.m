% Clearclear; close all;% Viewpointaz = -40; el = 64;% Set up discrete coordinate systemreality_x = linspace(0,1,100);reality_y = linspace(0,1,100);dArea = (reality_x(2)-reality_x(1))*(reality_y(2)-reality_y(1));% Set up prior pdfprior_u = [0.5 0.5]';prior_K = [250 110 ; 110 100]/10000;prior_pdf = BiNormalPDF(reality_x,reality_y,prior_u,prior_K);priorVolume = sum(prior_pdf(:))*dArea;if (abs(priorVolume-1) > 0.01)    error('Prior volume not close enough to unity');endfigure; clf; hold onmesh(reality_x,reality_y,prior_pdf);axis('square');view(az,el);xlabel('Pixel 1 radiance');ylabel('Pixel 2 radiance');zlabel('Probability density');title('Prior');% Render matrixR = [0.5 0.5];noise_sd = 0.01;noise_K = eye(1)*noise_sd^2;% Observationy = 0.3;% Compute likelihood over domain of xfor ii = 1:length(reality_x)    for jj = 1:length(reality_y)        likelihood(ii,jj) = NormalPDF(R*[reality_x(ii),reality_y(jj)]',y,noise_K);    endendfigure; clf; hold onmesh(reality_x,reality_y,likelihood);axis('square');view(az,el);xlabel('Pixel 1 radiance');ylabel('Pixel 2 radiance');zlabel('Probability density');title('Likelihood');% Posterior analytic[posterior_u,posterior_K] = NormalPosterior(y,... 	                            prior_u,prior_K,...                              R,noise_K);posterior_pdf = BiNormalPDF(reality_x,reality_y,...                              posterior_u,posterior_K);posteriorVolume = sum(posterior_pdf(:))*dArea;if (abs(posteriorVolume-1) > 0.01)    error('Posterior volume not close enough to unity');endfigure; clf; hold onmesh(reality_x,reality_y,posterior_pdf);axis('square');view(az,el);xlabel('Pixel 1 radiance');ylabel('Pixel 2 radiance');zlabel('Probability density');title('Posterior');% Posterior multiplyposterior_pdf_check = prior_pdf .* likelihood;posterior_pdf_check = posterior_pdf_check / (sum(posterior_pdf_check(:))*dArea);figure; clf; hold onmesh(reality_x,reality_y,posterior_pdf_check);axis('square');view(az,el);xlabel('Pixel 1 radiance');ylabel('Pixel 2 radiance');zlabel('Probability density');title('Posterior Chk');