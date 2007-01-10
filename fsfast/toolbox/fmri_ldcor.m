function cor = fmri_ldcor(subject,arg2,arg3)
%
% Loads the indicated corronal slices from 
%   $SUBJECTS_DIR/subject/mri/volumeid
%
% cor = fmri_ldcor(subject)                
% cor = fmri_ldcor(subject,volumeid)
% cor = fmri_ldcor(subject,slices)
% cor = fmri_ldcor(subject,volid,slices)
%
% If unspecified, volumeid defaults to T1.
% If unspecified, nslices defaults to [1:256].
% If subject is not found in SubjectsDir, then it
%    interprets subject as the full path to the COR.
%
%


%
% fmri_ldcor.m
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

if(nargin < 1 | nargin > 3)
  msg = 'USAGE: cor = fmri_ldcor(subject,<volid>,<slices>)';
  qoe(msg);error(msg);
end

volumeid = 'T1';
slices   = [1:256];

if(nargin == 2)
  if(ischar(arg2)) volumeid = arg2;
  else             slices   = arg2;
  end
end

if(nargin == 3)
  if(ischar(arg2)) volumeid = arg2;
  else             slices   = arg2;
  end
  if(ischar(arg3)) volumeid = arg3;
  else             slices   = arg3;
  end
end

if(min(slices) < 1)
  msg = sprintf('Min Slice No = %d, must be > 0',min(slices));
  qoe(msg);error(msg);
end

if(max(slices) > 256)
  msg = sprintf('Max Slice No = %d, must be <= 256',max(slices));
  qoe(msg);error(msg);
end


subject = deblank(subject);
volumeid = deblank(volumeid);

SubjectsDir = deblank(getenv('SUBJECTS_DIR'));
if(isempty(SubjectsDir))
  msg = 'Cannot find SUBJECTS_DIR environment variable';
  qoe(msg);error(msg);
end

SubjDir = strcat(SubjectsDir,'/',subject);
CorDir  = strcat(SubjDir,'/mri/',volumeid);

d = dir(CorDir);
if(isempty(d))
  CorDir = deblank(subject);
  d = dir(CorDir);
  if(isempty(d))
    msg = sprintf('Directory %s does not exist',CorDir);
    qoe(msg);error(msg);
  end
end

nslices = length(slices);
cor = zeros(256,nslices,256);

Endian = 0;
precision = 'uint8';
Nv = 256*256;

fprintf(1,'Loading corronals from subject %s, volume %s, %d slices ... \n',...
        subject,volumeid,nslices);
fprintf('CorDir: %s\n',CorDir);


for s = 1:nslices,

  n = slices(s);

  corfile = sprintf('%s/COR-%03d',CorDir,n);
  d = dir(corfile);
  if(isempty(d))
    msg = sprintf('File %s does not exist',corfile);
    qoe(msg);error(msg);
  end
  
  %%%% Open the corfile %%%%%
  if(Endian == 0) fid=fopen(corfile,'r','b'); % Big-Endian
  else            fid=fopen(corfile,'r','l'); % Little-Endian
  end
  if(fid == -1)
    msg = sprintf('Could not open %s for reading.',corfile); 
    qoe(msg); error(msg);
  end

  %%% Read the file in corfile %%%
  z = fread(fid,Nv,precision);
  cor(:,s,:) = reshape(z, [256 256])'; %' transpose for row major
  fclose(fid); 

end
fprintf(1,'Done \n');

cor = permute(cor, [3 2 1]);

return;
