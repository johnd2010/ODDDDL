function rect_positive = get_positive_rectangles(bbox,count,size_img,bbox_dilation)
%GET_POSITIVE_RECTANGLES Summary of this function goes here
%   Detailed explanation goes here
% bbox_min = [bbox(1:2)+0.5*(-1+sqrt(2))*bbox(3:4) (-1+sqrt(2))*bbox(3:4)];
bbox_min = dilate_rectangle(bbox,bbox_dilation);
b= bbox2points(bbox_min,[]);

region_of_interest.positive = zeros(size_img);
% if min(b(:,2))<1
    b(b<1)=1;
% end
region_of_interest.positive(min(b(:,2)):max(b(:,2)),min(b(:,1)):max(b(:,1)))=1;
% region_of_interest.positive = poly2mask(b(:,1),b(:,2),size_img(1),size_img(2));
[x,y]=find(region_of_interest.positive==1);
centres = randi(length(x),ceil(1.5*count),1);
rect_positive = [y(centres)-(0.5)*bbox(3) x(centres)-(0.5)*bbox(4) repmat(bbox(3:4)-[1 1],length(centres),1)];
% rect_positive = [y(centres)-(sqrt(2)-1)*bbox(3) x(centres)-(sqrt(2)-1)*bbox(4) repmat(bbox(3:4)-[1 1],length(centres),1)];
% m = find(bbox2points(rect_positive) > size_img & bbox2points(rect_positive) < [0 0]);
% if m 
%     m
% end
rect_positive = rect_positive((sum(abs(rect_positive(:,1:2)-bbox(:,1:2))>bbox(3:4),2)==0),:);

% rect_positive = rect_positive((sum(abs(diff)>bbox(3:4),2)==0),:);
flag =false;
if isempty(rect_positive)
    flag =true;
elseif size(rect_positive,1)<count
        flag =true;
elseif size(rect_positive,1)>count
    rect_positive = rect_positive(1:count,:);
end
if flag
    count_new = (count - size(rect_positive,1));
    rect_positive = [rect_positive ; get_positive_rectangles(bbox,count_new,size_img,bbox_dilation)];
end

end

