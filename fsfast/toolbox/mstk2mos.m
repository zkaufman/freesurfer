function StkMosaic = mstk2mos(MStack,nTileCols)
%
% StkMosaic = mstk2mos(MStack,nTileCols)
%
% Converts the multiple image stack into a mosaic.  
% Eg: if size(MStack) = 128 x 128 x 16 x 10
% and nTileCols = 4, then Mosaic will have
% dimension 512 x 512 x 10.  The 16 images in
% Stack will be tiled in a stack of 10 4x4 mosaics.
%
%


%
% mstk2mos.m
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


[nR nC nTP nSlices] = size(MStack);

nTileRows = ceil(nSlices/nTileCols);

nMosC = nTileCols * nC;
nMosR = nTileRows * nR;

Mosaic = zeros(nMosR,nMosC,nTP);

for t = 1:nTP

  for r = 1:nTileRows,
    r0 = (r-1)*nR + 1;
    r1 = r0 + nR - 1;
    for c = 1:nTileCols,
      S = (r-1)*nTileCols + c;
      if(S <= nSlices)
        c0 = (c-1)*nC + 1;
        c1 = c0 + nC - 1;
        %fprintf('r=%d, c=%d, S=%2d, r0=%3d, r1=%3d, c0=%3d, c1=%3d\n',...
        %         r,c,S,r0,r1,c0,c1);
        StkMosaic(r0:r1,c0:c1,t) = MStack(:,:,t,S);
      end
    end
  end

end


return;
