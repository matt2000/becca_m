% Performs a center-surround filtering on a 2D grayscale image.
function im = util_center_surround(rawIm)

    [vPix hPix] = size(rawIm);

    % Creates block by finding center-surround difference
    im    =  rawIm(2:vPix-1,2:hPix-1)     - ...  % center
            (rawIm(1:vPix-2,2:hPix-1)./6) - ...  % top
            (rawIm(3:vPix  ,2:hPix-1)./6) - ...  % bottom
            (rawIm(2:vPix-1,1:hPix-2)./6) - ...  % left
            (rawIm(2:vPix-1,3:hPix  )./6) - ...  % right
            (rawIm(1:vPix-2,1:hPix-2)./12)- ...  % top-left
            (rawIm(3:vPix  ,3:hPix  )./12)- ...  % bottom-right
            (rawIm(3:vPix  ,1:hPix-2)./12)- ...  % bottom-left
            (rawIm(1:vPix-2,3:hPix  )./12);      % top-right

    % Enforces the range [-1, 1]
    im(find(im >  0.99)) =  0.99;
    im(find(im < -0.99)) = -0.99;

end

