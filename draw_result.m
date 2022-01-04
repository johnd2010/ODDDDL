function drawopt = draw_result(drawopt, fno, frame, bbox,true_bbox,drawstuff)
if drawstuff
    if (isempty(drawopt))
        figure('units','normalized','outerposition',[0 0 1 1])
        clf;
        set(gcf,'DoubleBuffer','on','MenuBar','none');
        drawopt.curaxis = [];
        drawopt.curaxis.frm  = axes('position', [0.00 0 1.00 1.0]);
    end


    imshow(frame);
    hold on;
    if ~iscell(bbox)
        rect_on_image(bbox,"r");
    else
        ptch_count=size(bbox);
        for i=1:ptch_count(1)
            for j=1:ptch_count(2)
                rect_on_image(bbox{i,j},"r");
            end
        end
    end
    if fno>1
        rect_on_image(true_bbox,"g");
    end
    text(10, 15, '#', 'Color','y', 'FontWeight','bold', 'FontSize',24);
    text(30, 15, num2str(fno), 'Color','y', 'FontWeight','bold', 'FontSize',24);

    axis equal off;
    hold off;
    drawnow;

end
end