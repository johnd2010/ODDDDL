clear; close all;
warning('off');
addpath("/home/durable20/Documents/ODDL/tracker_benchmark_v1.0/rstEval");

%% Environment variables
env.frame_number = 1;
env.dataset = "Deer";
env.color = true;
env.draw = true;
env.patch = true;
% env.patch = false;
env.data = "/home/durable20/Documents/Data/"+env.dataset ;
env.gt = env.data+ "/groundtruth_rect.txt";
env.result = "/home/durable20/Documents/Result/"+env.dataset ;
env.data = env.data  + "/img/";
%% parameter setting
trackparam;

%% change the directory of test sequences

featpars.bbox_full = get_ground_truth(env,false);
featpars.bbox = featpars.bbox_full(1,:);
bb_prev = featpars.bbox ;

if env.patch
    patches_bbox = bbox_patch_creator(featpars.bbox,trackpars.nsize,false);
    bb_prev=patches_bbox.vec;
    trackpars.search_area = trackpars.search_area*numel(bb_prev);
end
s = dir(env.data);
seq = s(3:end);

%% loop through all sequences
trackpars.title = seq(1).name;

%% collect training samples
frame = get_image(env.data+trackpars.title,env.color);


%%initialize tracker
[dict, dictpars,samples] = initialize_tracker_patch(frame,bb_prev,dictpars,trackpars);

drawopt = [];
result = cell(length(seq),1);
result{1} = bb_prev;
% 
%% draw results
drawopt = draw_result(drawopt, 1, frame, featpars.bbox,[],env.draw);


tic;
duration = 0;
update_count =0;
template_count =0;
%% do tracking
file_check="passed";
% try
for f = 2 : length(seq)
    [f  length(seq) ]
    frame = get_image(env.data+seq(f).name,env.color);
    [bb_next, feats, minval] = do_tracking_patch(frame, dict, bb_prev, trackpars, dictpars);

    [dict,samples]=get_template_patch(frame, bb_next, dict, minval, trackpars,samples,feats);
    [dict,samples]=update_dict_patch(samples, dictpars, dict,trackpars);


    %% draw result
    drawopt = draw_result(drawopt, f, frame, bb_next,featpars.bbox_full(f,:),env.draw);
    bb_next_merge=minBoundingBox(bb_next);
    bb_prev = bb_next;
    if env.patch
        patches_bbox = bbox_patch_creator(bb_next_merge,trackpars.nsize,size(bb_next));
        bb_prev=patches_bbox.vec;
    
    %% append new result
    hold on;
    rect_on_image(bb_next_merge,"b");
    ptch_count = size(bb_prev);
    for i=1:ptch_count(1)
        for j=1:ptch_count(2)
            rect_on_image(bb_prev{i,j},"b");
        end
    end
    pause(0.01)
    end
    result{f} = bb_next;


end
[aveErrCoverage, aveErrCenter,errCoverage, errCenter] = calcSeqErrRobust_edit(cell2mat(result),featpars.bbox_full);

% catch
%     file_check = "failed";
% end

%% Save result and calculate fps

%% Analysis
thresholdSetOverlap = 0:0.05:1;
thresholdSetError = 0:50;

duration = duration + toc;
fprintf('%d frames took %.3f seconds : %.3fps\n', f, duration, f/duration);
fps = f/duration;
check_folder(env.result)
env.result = fullfile(env.result,num2str(fps)+file_check+".mat");
save(env.result);

