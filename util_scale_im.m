% scales image im to have the pixel width wid
function scaled_im = util_scale_im( im, new_wid)
    old_wid = size(im, 2);
    scale = new_wid / old_wid;
    new_hgt = floor( size( im, 1) * scale);
    scaled_im = interp2( im, (1:new_wid) / scale, ...
        (1:new_hgt)' / scale, 'linear', 0); 
end
