function hog_patch_vec = extract_features_from_patch(img,bbox,trackpars)
%EXTRACT_FEATURES_FROM_PATCH Summary of this function goes here
%   Detailed explanation goes here
i=1;
smimage=imresize(imcrop(img,bbox(i,:)),trackpars.nsize);
hog_value = double(vl_hog(im2single(smimage), trackpars.hog_window));
hog_patch_vec = zeros(numel(hog_value),size(bbox,1));
hog_patch_vec(:,i)  = hog_value(:);
for i=2:size(bbox,1)
    smimage=imresize(imcrop(img,bbox(i,:)),trackpars.nsize);
    hog_value = double(vl_hog(im2single(smimage), trackpars.hog_window));
    hog_patch_vec(:,i)  = hog_value(:);
end
end

