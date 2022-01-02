function bbox = dilate_rectangle(bbox,scale)
%DILATE_RECTANGLE Summary of this function goes here
%   Detailed explanation goes here
if length(scale)==1
    bbox(1:2)= bbox(1:2)-bbox(3:4)*0.5*(scale-1);
    bbox(3:4)= bbox(3:4)*scale;
else
    bbox(1)= bbox(1)-bbox(3)*0.5*(scale(1)/bbox(3)-1);
    bbox(2)= bbox(2)-bbox(4)*0.5*(scale(2)/bbox(4)-1);
    bbox(3:4)= scale;
end

