function [dict, dictpars] = init_tracker(img,bbox, dictpars, trackpars)
%
% p = featpars.bbox;
rect_positive = get_positive_rectangles(bbox,trackpars.posnum,size(img,1:2),trackpars.bbox_dilation);
rect_negative = get_negative_rectangles(bbox,trackpars.negnum,size(img,1:2),trackpars.bbox_dilation+1);
if rem(size(rect_positive,1) + size(rect_negative,1),2)~=0
    rect_negative(end,:)=[];
end
feat.feaArr = extract_features_from_patch(img,[rect_negative;rect_positive],trackpars);
feat.label = [-1*ones(size(rect_negative,1),1) ;ones(size(rect_positive,1),1)];

%% dictionary initialization
numcls = length(unique(feat.label));
dictpars.numBases = dictpars.numpercls * numcls; % dictionary size
dictpars.numcls = numcls;
[D, W, A, Q] = init_dict(feat, dictpars);
dict.D = D;
dict.W = W;
dict.A = A;
dict.Q = Q;

T = []; TW = [];
[T, TW] = get_template(img, bbox, T, TW, 0, trackpars);
dict.T = T;
dict.TW = TW;