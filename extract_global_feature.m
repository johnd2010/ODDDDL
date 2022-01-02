function feat = extract_global_feature(img, bbox, trackpars)
%
rect_positive = get_positive_rectangles(bbox,trackpars.posnum,size(img),trackpars.bbox_dilation);
rect_negative = get_negative_rectangles(bbox,trackpars.negnum,size(img),trackpars.bbox_dilation+1);
if rem(size(rect_positive,1) + size(rect_negative,1),2)~=0
    rect_negative(end,:)=[];
end
feat.feats = extract_features_from_patch(img,[rect_negative;rect_positive],trackpars);
feat.labels = [-1*ones(size(rect_negative,1),1) ;ones(size(rect_positive,1),1)];
end