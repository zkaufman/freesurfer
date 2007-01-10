function [dsm, g] = fast_smooth1d(d,gsigma)
% [dsm g] = fast_smooth1d(d,<gsigma>)
%
% Gaussian smooths the columns of d. Pads with zeros so no
% wrap-around. Uses fft. Should work on complex data. 
%
%


%
% fast_smooth1d.m
%
% Original Author: Doug Greve
% CVS Revision Info:
%    $Author: nicks $
%    $Date: 2007/01/10 22:02:32 $
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

% Test 1
% N = 50; gstd = 2;
% y = zeros(N,1); y(round(N/2)) = 1;
% [ysm g] = fast_smooth1d(y,gstd);
% x = [1:N]'; x = x - x(round(N/2));
% g0 = gaussian(x,0,gstd);
% plot(x,g0,'o-',x,ysm);
%
% Test 2
% nn = 1:N;
% y = randn(N,3000);
% ysm = fast_smooth1d(y,gstd);
% ymss = mean(ysm.^2,2);
% plot(nn,ymss,nn,g0'*g0)

dsm = [];
if(nargin < 1 | nargin > 2)
  fprintf('[dsm g] = fast_smooth1d(d,<gsigma>)\n');
  return;
end

if(~exist('gsigma','var')) gsigma = []; end
if(isempty(gsigma)) gsigma = 1; end

nrows = size(d,1);
ncols = size(d,2);
nrows2 = 2*nrows;

x = ([1:nrows2]' - (nrows2/2 + 1))/gsigma;
g = exp( -(x.^2)/2 );
g = g/sum(g);

dpad = zeros(nrows2,ncols);
dpad(1:nrows,:) = d;

kd = fft(dpad);
kg = fft(g);

dsm = ifft(kd .* repmat(kg,[1 ncols]));
dsm = fftshift(dsm,1); % so you can take 1:nrows
dsm = dsm(1:nrows,:);

if( max(abs(imag(d(:)))) == 0 )
  % Only take the real if input is totally real
  dsm = real(dsm);
end


return;
