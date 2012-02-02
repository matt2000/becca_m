% pastes one image into another at a specified center position
function pasted_im = util_paste_im( new_im, im, row, col)

[im_hgt im_wid] = size(im);
[new_im_hgt new_im_wid] = size(new_im);
new_im_rows = (1:new_im_hgt) + round (row - new_im_hgt/2);
new_im_cols = (1:new_im_wid) + round (col - new_im_wid/2);

new_im = new_im( (new_im_rows >= 1) & ...
                 (new_im_rows <= im_hgt), :);
new_im_rows = new_im_rows( (new_im_rows >= 1) & ...
                           (new_im_rows <= im_hgt));
new_im = new_im( :, (new_im_cols >= 1) & ...
                    (new_im_cols <= im_wid));
new_im_cols = new_im_cols( (new_im_cols >= 1) & ...
                           (new_im_cols <= im_wid));

im( new_im_rows, new_im_cols) = new_im;
pasted_im = im;

