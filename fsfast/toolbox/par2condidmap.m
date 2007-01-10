function condidmap = par2condidmap(par,nullid)
%
% condidmap = par2condidmap(par,nullid)
%
% Extracts and sorts all unique condition numbers in paradigm.
%
%


%
% par2condidmap.m
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

if(nargin ~= 1 & nargin ~= 2)
  msg = 'USAGE: condidmap = par2condidmap(par,<nullid>)'
  qoe(msg); error(msg);
end

condid = reshape1d(par(:,2,:,:));
condidmap = unique(condid);

if(nargin == 2)
  n = find(condidmap == nullid);
  if(isempty(n))
    condidmap = [nullid; reshape1d(condidmap)];
  else
    tmp = condidmap(1);
    condidmap(1) = nullid;
    condidmap(n) = tmp;
  end
end


return;
