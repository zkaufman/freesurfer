function dof = fmri_ldsadof(varargin)
%
% dof = fmri_ldsadof(BFileName)
%
%
%
%


%
% fmri_ldsadof.m
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


dof = [];

if(nargin == 0) 
  fprintf(2,'USAGE: fmri_ldsadof(BFileName)');
  qoe;
  return;
end

if( length(varargin) == 1)
  BFileList = varargin{1};
  nRuns = size(BFileList,1);
else
  nRuns = length(varargin);
  BFileList = '';
  for r = 1:nRuns,
    BFileList = strvcat(BFileList,varargin{r});
  end
end


for r = 1:nRuns,

  BFileName = deblank(BFileList(r,:));
  ks = findstr(BFileName,'.bshort');
  kf = findstr(BFileName,'.bfloat');

  if(isempty(ks) & isempty(kf))
    msg = 'BFileName must be either bshort or bfloat';
    qoe(msg);
    error(msg);
  end

  if( ~isempty(ks) ) 
    Base = BFileName(1:ks-1);
  else               
    Base = BFileName(1:kf-1);
  end

  if( isempty(Base) )
    s = 'BFileName must have a non-null base';
    qoe(msg);
    error(msg);
  end

  %%% Open the header file %%%%
  DOFFile = strcat(Base,'.dof');
  fid=fopen(DOFFile,'r');
  if fid == -1 
    msg = sprintf('Could not open %s file',DOFFile); 
    qoe(msg);
    error(msg);
  end

  %%%% Read the Dimension from the header %%%%
  d=fscanf(fid,'%d');
  fclose(fid);

  n = length(d);
  nCond = n/3;
  d = reshape(d,[nCond 3]);
  dof = d(:,[2 3]);

end

return;

%%% y now has size(y) = [nR nC nD nRuns] %%%

