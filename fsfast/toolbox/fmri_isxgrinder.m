function [valStat, sigStat, polStat] = fmri_isxgrinder(havg, hstd, DOF, RM, Np)
%
% [valStat sigStat polStat] = fmri_isxgrinder(havg, hstd, DOF, RM, Np)
%


%
% fmri_isxgrinder.m
%
% Original Author: Doug Greve
% CVS Revision Info:
%    $Author: nicks $
%    $Date: 2007/01/10 22:02:33 $
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

if(nargin ~= 4 & nargin ~= 5)
  msg = 'USAGE: [valStat sigStat polStat] = fmri_isxgrinder(havg, hstd, DOF, RM, <Np>)';
  qoe(msg);error(msg);
end

if(nargin == 4) Np = 1; end

[nRows nCols Nch] = size(havg);
Nv = nRows*nCols;

havg = reshape(havg, [Nv Nch])'; %'
hstd = reshape(hstd, [Nv Nch])'; %'
hvar = hstd.^2;

%ind = find(hstd==0);
%hstd(ind) = 10^(-10);

J = size(RM,1);

q = RM*havg;
qt = q'; %'

RMt   = RM'; %'

valStat = 10^(-10) * ones(1,Nv);

for v = 1:Nv,
  dh = hvar(:,v);
  if(max(dh) > 10^(-10)) 
    Ch = diag(dh);
    valStat(:,v) = qt(v,:)*inv(RM*Ch*RMt)*q(:,v);%
  end
end

valStat = DOF*valStat/J;
sigStat = FTest(J, DOF*trace(RM*RMt), reshape1d(valStat));
polStat = sign(sum(RM,1)*havg);

valStat = reshape(valStat, [nRows nCols]);
sigStat = reshape(sigStat, [nRows nCols]);
polStat = reshape(polStat, [nRows nCols]);

return; 
