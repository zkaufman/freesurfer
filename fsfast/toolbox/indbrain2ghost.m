function [indg, rg, cg, sg] = indbrain2ghost(volsize,indb,pedim)
% [indg, rg, cg, sg] = indbrain2ghost(volsize,indb,<pedim>)
%
% Computes the linear index into a volume of the ghost (indg)
% corresponding to the index from the main/brain image (indb).  Note
% that it can be used in the opposite direction (ie, to find the index
% in the main image from that of the ghost). In fact, running it with
% indg as input will give indb as a result. The ghost of the ghost is
% the orginal image. As a bonus, it returns the subscript
% (rg,cg,sg) of the index in the ghost.
%
% volsize = [nrows ncols nslices]
%
% pedim = 2 means that the phase encode changes from 
% one row to the next. This is the default if pedim is
% unspecfied or null.
%
% pedim = 1 means that the phase encode changes from 
% one col to the next.
%
% Beware of matlab's column-major when assigning PE dim.
%
% See also: subbrain2ghost
%
%


%
% indbrain2ghost.m
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

indg = [];
cg = [];

if(nargin < 2 | nargin > 3)
  fprintf('indg = indbrain2ghost(volsize,indg,<pedim>)\n');
  return;
end

if(~exist('pedim','var')) pedim = []; end
if(isempty(pedim)) pedim = 2; end
if(pedim ~= 1 & pedim ~= 2)
  fprintf('ERORR: pedim = %d, must be 1 or 2\n',pedim);
  return;
end

nr = volsize(1);
nc = volsize(2);
ns = volsize(3);
nv = nr*nc*ns;

% Make sure none of the indices are out of range
if(length(find(indb>nv)))
  fprintf('ERROR: ind values are out of range\n');
  return;
end

[rb cb sb] = ind2sub([nr nc ns],indb);
[rg cg] = subbrain2ghost([nr nc],rb,cb,pedim);
sg = sb;
indg = sub2ind([nr nc ns],rg,cg,sg);

return;


