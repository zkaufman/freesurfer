function l = fast_ldfslabel(lname, sname)
% l = fast_ldfslabel(lname, sname)
%
% Reads the label file lname. If sname is included,
% then the label path will be SUBJECTS_DIR/sname/label/lname.
% 
% Returns the matrix l which will be npoints X 5, where
% the five columns are: (1) vertex number, (2-4) xyz,
% (5) value associated with label point.
%
% Based on read_label.m by Bruce F.


%
% fast_ldfslabel.m
%
% Original Author: Doug Greve
% CVS Revision Info:
%    $Author: nicks $
%    $Date: 2007/01/10 22:02:31 $
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

l = [];

if(nargin ~=1 & nargin ~=2)
  fprintf('USAGE: l = fast_ldfslabel(lname, sname)\n');
  return;
end

if(nargin ==2)
  sdir = getenv('SUBJECTS_DIR') ;
  fname = sprintf('%s/%s/label/%s.label', sdir, sname, lname) ;
else
  fname = lname;
end

% open it as an ascii file
fid = fopen(fname, 'r') ;
if(fid == -1) 
  fprintf('ERROR: could not open %s\n',fname);
  return;
end

fgets(fid) ;
line = fgets(fid) ;
nv = sscanf(line, '%d') ;
l = fscanf(fid, '%d %f %f %f %f\n') ;
fclose(fid) ;

l = reshape(l, 5, nv) ;
l = l' ; %'


return;
