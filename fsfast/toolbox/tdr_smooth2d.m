function [imgsm, G] = tdr_smooth2d(img,sig1,sig2)
% [imgsm filtimg] = tdr_smooth2d(img,sig1,sig2)
% 
% 2D gaussian smoother.
%
% sig1 - gaussian standard dev for the rows
% sig2 - gaussian standard dev for the columns
%
%


%
% tdr_smooth2d.m
%
% Original Author: Doug Greve
% CVS Revision Info:
%    $Author: nicks $
%    $Date: 2007/01/10 22:02:35 $
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

if(nargin ~= 3)
  fprintf('[imgsm filtimg] = tdr_smooth2d(img,sig1,sig2)\n');
  return;
end

[nrows ncols] = size(img);
nrows2 = 2*nrows;
ncols2 = 2*ncols;

x = ([1:nrows2] - (nrows2/2 + 1))/sig1;
xx = ones(nrows2,1) * x;
y = ([1:ncols2]' - (ncols2/2 + 1))/sig2;
yy = y * ones(1,ncols2);
G = exp( -(xx.^2)/2 + -(yy.^2)/2 );
G = G/sum(reshape1d(G));

% zero pad
zpimg = zeros(2*size(img));
zpimg(1:nrows,1:ncols) = img;

kimg  = fftn(zpimg); 
kG    = fftn(G);
imgsm = fftshift(ifftn(kimg.*kG));
imgsm = imgsm(1:nrows,1:ncols); 

if( max(abs(reshape1d(imag(img)))) == 0 )
  % Only take the magnitude if input is totally really
  imgsm = abs(imgsm);
end

%keyboard

