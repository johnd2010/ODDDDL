function [bb_next, samples, minval] = do_tracking(img, dict, bb_prev, trackpars, sparsity)
%

%% global features
bbox = bb_prev;
backup.rect = get_positive_rectangles(bbox,trackpars.search_sum,size(img,1:2),trackpars.search_area);

hog_patch_vec = extract_features_from_patch(img,backup.rect,trackpars);

A_norm = sqrt(sum(hog_patch_vec .* hog_patch_vec));
hog_patch_vec = hog_patch_vec ./ (ones(size(hog_patch_vec,1),1) * A_norm + eps);

pred = classify(double(hog_patch_vec), dict, sparsity);
[minval, ind] = min(pred.val);
% ind = pred.best_ind;
bb_next = backup.rect( ind,:)+[0 0 1 1];
% bbox = [best(1), best(2), best(3)*psize(2), best(5)*best(3)*psize(1)];
% bb_next = [bbox(2)-bbox(4)/2, bbox(1)-bbox(3)/2, bbox(2)+bbox(4)/2, bbox(1)+bbox(3)/2];

isgood = update_check(pred, ind, trackpars);
  
samples = [];
if isgood
    samples = extract_global_feature(img, bb_next, trackpars);
end

