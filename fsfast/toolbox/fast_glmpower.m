function [tpr, tnc, dof] = fast_glmpower(beta,XtX,rvar,C,alpha,dof,nsides)
% [tpr tnc dof] = fast_glmpower(beta,XtX,rvar,C,alpha,dof,nsides)
% 
% Computes the power (ie, true positive rate) of a hypothetical
% t-test from a GLM analysis. NOTE: requires statistics toolbox.
%
% beta - vector of hypothetical regression coefficients
% XtX - deisgn covariance matrix (ie, X'*X)
% rvar - hypothetical variance 
% C - contrast matrix (only one row allowed for t-test)
% alpha - Type I Error Rate 
% dof - degrees of freedom
% nsides - 1 for one-sided t test, or 2 for two-sided t test
%   default is one-sided.
%
% Notes on input dimensions. beta, rvar, and alpha may have more
% than one column under certain circumstances. If beta and/or rvar
% have more than one column, then alpha must be scalar. If both
% beta and rvar have more than one column, then must have the same
% number of columns. tpr will have the same number of columns as
% beta, rvar, or alpha.
%
% tpr = 1 - Type II Error Rate
% tnc = noncentrality parameter
%
% Bugs: not accurate for 1-sided with alpha > 0.5.
% 
% See also: fast_glmfitw, fast_fratiow, FTest.
% 
%


%
% fast_glmpower.m
%
% Original Author: Doug Greve
% CVS Revision Info:
%    $Author: nicks $
%    $Date: 2007/01/10 22:02:30 $
%    $Revision: 1.3 $
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

tpr = [];
tnc = [];

if(nargin < 6 | nargin > 7)
  fprintf('[tpr tnc] = fast_glmpower(beta,X,rvar,C,alpha,dof,nsides)\n');
  return;
end

if(size(C,1) ~= 1)
  fprintf('ERROR: C can only have 1 row\n');
  return;
end

if(~exist('nsides','var')) nsides = []; end
if(isempty(nsides)) nsides = 1; end

% This is the noncentraliity parameter for the noncentral t distribution
iXtX = inv(XtX);
tnc = (C*beta)./sqrt(rvar*(C*iXtX*C'));

% Compute the ideal TPR
if(nsides == 1)
  t = abs(tinv(alpha,dof)); % t corresonding to alpha in central t
else
  t = abs(tinv(alpha/2,dof)); % t corresonding to alpha in central t
end
tpr = 1 - nctcdf(t,dof,tnc); % get p from noncentral t

return;


