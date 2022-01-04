function rect_negative = get_negative_rectangles(bbox,count,size_img,bbox_dilation)
%GET_NEGATIVE_RECTANGLES Summary of this function goes here
%   Detailed explanation goes here
bbox_diluted = dilate_rectangle(bbox,bbox_dilation);
b = bbox2points(bbox_diluted,[]);
region_of_interest.negative = poly2mask(b(:,1),b(:,2),size_img(1),size_img(2));
b = bbox2points(bbox,[]);
region_of_interest.negative = region_of_interest.negative & ~poly2mask(b(:,1),b(:,2),size_img(1),size_img(2));
[x,y]=find(region_of_interest.negative==1);
centres = randi(length(x),ceil(1.5*count),1);
rect_negative = [y(centres)-(0.5)*bbox(3) x(centres)-(0.5)*bbox(4) repmat(bbox(3:4)-[1 1],length(centres),1)];
diff = rect_negative(:,1:2)-bbox(:,1:2);
rect_negative = rect_negative((sum(abs(diff)>bbox(3:4),2)<2),:);

if size(rect_negative,1)<count
    count_new = (count - size(rect_negative,1));
    rect_negative = [rect_negative ; get_negative_rectangles(bbox,count_new,size_img,bbox_dilation)];
elseif size(rect_negative,1)>count
    rect_negative = rect_negative(1:count,:);
end
end

