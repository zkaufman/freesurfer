function index = flac_evindex(flac,evname)
% index = flac_evindex(flac,evname) 
%
% Retuns the index of an EV from its name. Returns empty if evname
% not found.
%
%


%
% flac_evindex.m
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

index = [];

if(nargin ~= 2)
  fprintf('index = flac_evindex(flac,evname)\n');
  return;
end

nevs = length(flac.ev);
for nthev = 1:nevs
  if(strcmp(flac.ev(nthev).name,evname))
    index = nthev;
    return;
  end
end

return;


















