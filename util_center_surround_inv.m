% Performs an inverse  center-surround filtering on 
% a 2D grayscale image.
% Assumes rawIm falls on [-1 1]
function im = util_center_surround_inv(rawIm)

[vPix hPix] = size(rawIm);

% Creates block by finding center-surround difference
im = zeros( vPix + 2, hPix + 2);
im(2:vPix+1,2:hPix+1) = im(2:vPix+1,2:hPix+1) + rawIm; % center
im(1:vPix  ,2:hPix+1) = im(1:vPix  ,2:hPix+1) - rawIm / 6; % left
im(3:vPix+2,2:hPix+1) = im(3:vPix+2,2:hPix+1) - rawIm / 6; % right
im(2:vPix+1,1:hPix  ) = im(2:vPix+1,1:hPix  ) - rawIm / 6; % top
im(2:vPix+1,3:hPix+2) = im(2:vPix+1,3:hPix+2) - rawIm / 6; % bottom
im(1:vPix  ,1:hPix  ) = im(1:vPix  ,1:hPix  ) - rawIm / 12; % top-left
im(1:vPix  ,3:hPix+2) = im(1:vPix  ,3:hPix+2) - rawIm / 12; % bottom-left
im(3:vPix+2,1:hPix  ) = im(3:vPix+2,1:hPix  ) - rawIm / 12; % top-right
im(3:vPix+2,3:hPix+2) = im(3:vPix+2,3:hPix+2) - rawIm / 12; % bottom-right

% Enforces the range [-1, 1]
im(find(im >  0.99)) =  0.99;
im(find(im < -0.99)) = -0.99;

