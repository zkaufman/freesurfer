function [yest] = fmri_estsignal(X,hest)
%
% yest = fmri_estsignal(X,hest)
%
% X:     Stim Conv Mtx (nTP x nTotEst x nRuns)
% hest:  hemodynamic resp est  (nRows x nCols x nTotEst)
% 
% yest:  estimated fMRI slice (nRows x nCols x nTP x nRuns)
%
%
%


%
% fmri_estsignal.m
%
% Original Author: Doug Greve
% CVS Revision Info:
%    $Author: nicks $
%    $Date: 2007/01/10 22:02:32 $
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

if(nargin ~= 2)
  msg = 'USAGE: [yest] = fmri_estsignal(X,hest)';
  qoe(msg);
  error(msg);
end

nTP     = size(X,1);
nTotEst = size(X,2);
nRuns   = size(X,3);

nRows   = size(hest,1);
nCols   = size(hest,2);

if(size(hest,3) ~= nTotEst)
  msg = 'hest and X dimensions are inconsistent';
  qoe(msg);
  error(msg);
end

% Compute number of voxels %
nV = nRows*nCols; 

hest = reshape(hest, [nV nTotEst])';

for r = 1:nRuns,
  yest(:,:,r) = X(:,:,r) * hest;
end

yest = permute(yest, [2 1 3]);
yest = reshape(yest, [nRows nCols nTP nRuns]);

return;
