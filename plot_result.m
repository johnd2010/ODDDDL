% clear;
env.dataset = "Jumping";
env.result = "/home/durable20/Documents/Result/"+env.dataset+"/all_successful_run.mat";
load(env.result)
env.data = "/home/durable20/Documents/Data/"+env.dataset+"/img";
s = dir(env.data);
seq = s(3:end);
env.gt = "/home/durable20/Documents/Data/"+env.dataset+ "/groundtruth_rect.txt";
featpars.bbox_full = (get_ground_truth(env,false));

for i=1:length(seq)
    bbox = featpars.bbox_full(i,:);
    imshow(imread(env.data+"/"+seq(i).name));
    hold on;
    rect_on_image(bbox,"g");
    rect_on_image(result(i,:),"r");
    text(10, 15, '#', 'Color','y', 'FontWeight','bold', 'FontSize',24);
    text(30, 15, num2str(i), 'Color','y', 'FontWeight','bold', 'FontSize',24);
    pause(0.1)
    clf
end
