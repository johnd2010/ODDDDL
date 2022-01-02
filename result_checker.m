Datasets = dir("/home/durable20/Documents/Data/");
Datasets = Datasets(3:end);
Result_path = "/home/durable20/Documents/Result";
close all;
% clear ;
draw=false;
for datasets=2:length(Datasets)
    drawopt = [];
    env.data = "/home/durable20/Documents/Data/"+Datasets(datasets).name;
    matfiles=dir(fullfile(Result_path,Datasets(datasets).name));
    matfiles = matfiles(3:end);
    load(fullfile(Result_path,Datasets(datasets).name,matfiles.name));
    env.data = env.data;
    s = dir(env.data);
    seq = s(3:end);
    %     figure(1);
    if draw==true
        for j=1:length(seq)
            img = imread(env.data+seq(j).name);
            drawopt = draw_result(drawopt, j, img, result(j,:),featpars.bbox_full(j,:));
            clf;
        end
    end

    figure(2);
    subplot(2,1,1);
    plot(errCoverage);
    subplot(2,1,2);
    plot(errCenter);
end