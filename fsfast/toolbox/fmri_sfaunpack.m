function [nstd, hr, hi] = fmri_sfaunpack(sfaslice)
% [nstd hr hi] = fmri_sfaunpack(sfaslice)
%
% sfaslice: nrows ncols nplanes
%
%


%
% fmri_sfaunpack.m
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

if(nargin ~= 1)
  msg = '[nstd hr hi] = fmri_sfaunpack(sfaslice)';
  qoe(msg); error(msg);
end

[nrows ncols nplanes] = size(sfaslice);

nstd = sfaslice(:,:,1);

nfreq = (nplanes-1)/2;
indreal = [2:2+(nfreq-1)];
indimag = indreal + nfreq;
hr = sfaslice(:,:,indreal);
hi = sfaslice(:,:,indimag);


return;
