function pdf = BiNormalPDF(x,y,u,K)m = length(x);n = length(y);pdf = zeros(m,n);Kdet = det(K);Kinv = inv(K);for i = 1:m  for j = 1:n    vec = [x(i) y(j)]';    z = vec-u;    pdf(i,j) = exp( -0.5*z'*Kinv*z );  endendpdf = 1/(2*pi)*1/(sqrt(Kdet))*pdf;