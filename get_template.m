function [T, TW] = get_template(frame, bb, T, TW, err, trackpars)
%
img = frame;
% tmp = double(imresize(imcrop(img,bb), trackpars.nsize));
tmp = double(imresize(imcrop(img,bb),trackpars.nsize));
tmp = double(vl_hog(im2single(tmp), trackpars.hog_window));
T = [T  tmp(:) / sqrt(sum(tmp(:) .* tmp(:)))];
TW = [TW exp(-err)];
if size(T,2) > trackpars.lengthT
    T = T(:,2:end);
    TW = TW(2:end);
end
