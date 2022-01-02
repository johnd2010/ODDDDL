clear; close all;
warning('off');
addpath("/home/durable20/Documents/ODDL/tracker_benchmark_v1.0/rstEval");
% cd ./sampling
% mex -O interp2.cpp
% cd ..
%% Environment variables
env.frame_number = 1;
env.dataset = "Deer";
env.color = true;
env.draw = true;
env.data = "/home/durable20/Documents/Data/"+env.dataset ;
env.gt = env.data+ "/groundtruth_rect.txt";
% check_folder(env.result);
env.data = env.data  + "/img/";
featpars.bbox_full = (get_ground_truth(env,false));
featpars.bbox = featpars.bbox_full(1,:);

% addpath('sampling');

%% change the directory of test sequences
s = dir(env.data);
seq = s(3:end);

%% loop through all sequences
trackpars.title = seq(1).name;

%% parameter setting
trackparam;

%% collect training samples
img = imread(env.data+trackpars.title);
if size(img,3) == 3 && env.color==false
    img = rgb2gray(img);
end

%%?initialize tracker
[dict, dictpars, bb_prev] = init_tracker(img, featpars, dictpars, trackpars);

drawopt = [];
samples.feaArr = [];
samples.label = [];
result = bb_prev;
cnt = 0;

%% draw results
if env.draw
    drawopt = draw_result(drawopt, 1, img, featpars.bbox);
end


tic;
duration = 0;
update_count =0;
template_count =0;
%% do tracking
file_check="passed";
try
    for f = 2 : length(seq)
        [f  length(seq) ]
        if exist(env.data+seq(f).name, 'file')
            frame = imread(env.data+seq(f).name);
        else
            error("Image Not Found");
        end

        if size(frame,3) == 3 && env.color==false
            frame = rgb2gray(frame);
        end

        [bb_next, feats, minval] = do_tracking(frame, dict, bb_prev, trackpars, dictpars.sparsity );

        if ~isempty(feats)
            cnt = cnt + 1;
            samples.feaArr = [samples.feaArr feats.feats];
            samples.label = [samples.label feats.labels'];
            [dict.T, dict.TW] = get_template(frame, bb_next, dict.T, dict.TW, minval, trackpars);
            %             template_count = template_count+1;
        end

        if ~isempty(samples.feaArr) && mod(size(samples.feaArr,2)/(trackpars.updatenum*2), trackpars.update) == 0 && trackpars.isupdate ~= 0
            dict = update_dict(samples, dictpars, dict);
            samples.feaArr = [];
            samples.label = [];
            update_count = update_count+1;
            %                 [f update_count]
        end

        %% draw result
        if env.draw
            drawopt = draw_result(drawopt, f, frame, bb_next,featpars.bbox_full(f,:));
        end

        %% append new result
        result = [result; bb_next];
        bb_prev = bb_next;
    end
    [aveErrCoverage, aveErrCenter,errCoverage, errCenter] = calcSeqErrRobust_edit(result,featpars.bbox_full);

catch
    file_check = "failed";
end

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

