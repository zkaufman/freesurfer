function [f, F, nu, a, b, dnu] = silverstein(r)
% [f F nu a b dnu] = silverstein(r)
%
% Computes the pdf (f) and cdf (F) of the eigenvalues of
% the N1-by-N1 covariance matrix of an N1-by-N2 data matrix 
% whose components are gauassianly distributed i.i.d with zero 
% mean and unit variance. r = N1/N2. nu is the value of an
% eigenvalue. a and b are the min and max that the non-zero
% eivenvalues can achieve (on average). If N1 > N2 (ie, r > 1), 
% then there will be N1-N2 zero-valued eignenvalues. 
%
% For some reason, the min and max of sample data can extend
% beyond a and b. I am not sure why this is.
%
% y = randn(N1,N2);
% cvm = y*y'/N2; %'
% [u s v] = svd(cvm);
% 
% R.M. Everson and S.J. Roberts, "Inferring the eigenvalues of 
% covariance matrices from limited, noisy data." IEEE Trans. 
% Sig. Proc., 48:7, 2083-2091, 2000. 
% http://www.dcs.ex.ac.uk/people/reverson/pubs


%
% silverstein.m
%
% Original Author: Doug Greve
% CVS Revision Info:
%    $Author: nicks $
%    $Date: 2007/01/10 22:02:34 $
%    $Revision: 1.2 $
%
% Copyright (C) 2002-2007,
% The General Hospital Corporation (Boston, MA). 
% All rights reserved.
%
% Distribution, usage and copying of this software is covered under the
% terms found in the License Agreement file named 'COPYING' found in the
% FreeSurfer source code root directory, and duplicated here:
% https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferOpenSourceLicense
%
% General inquiries: freesurfer@nmr.mgh.harvard.edu
% Bug reports: analysis-bugs@nmr.mgh.harvard.edu
%

f = [];
F = [];
nu = [];
a = [];
b = [];

if(nargin ~= 1)
  fprintf('USAGE: [f F nu a b dnu] = silverstein(r)\n');
  return;
end

a = (1-sqrt(r))^2;
b = (1+sqrt(r))^2;

dnu = (b-a)/100;

nu = [a-dnu:dnu:b+dnu];

inunz = find(nu > a & nu < b);
nunz = nu(inunz);

f = zeros(size(nu));

f(inunz) = sqrt( (nunz-a) .* (b-nunz) ) ./ (2*pi*r*nunz);
f = f/sum(f);

if(r > 1) % Some EVs must be zero
  F = (1-1/r) + cumsum(f)/r;
else
  F = cumsum(f);
end


return;
