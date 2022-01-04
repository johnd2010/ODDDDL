%% parameters of dictionary learning
dictpars.gamma = 1e-6;
dictpars.lambda = 0.5;
dictpars.mu = 0.6; % ||Q-AX||^2
dictpars.nu1 = 1e-6; % regularization of A
dictpars.nu2 = 1e-6; % regularization of W
dictpars.rho = .2; % initial learning rate
dictpars.maxIters = 30; % iteration number for incremental learning
dictpars.batchSize = 100;
dictpars.iterationini = 5; % iteration number for initialization
dictpars.numpercls = 100;
dictpars.sparsity = 10;

%% tracking parameters
trackpars.isupdate = 1;
trackpars.update = 5;
trackpars.posnum = 200;
trackpars.negnum = 200;
trackpars.updatenum = 100;
trackpars.nsize = [32 32];%[64 64];
trackpars.lengthT = 20;
trackpars.bbox_dilation = 0.5;
trackpars.hog_window = 8;%16
trackpars.cls_err_thresh = 0.75;
trackpars.rec_err_thresh = 0.35;
trackpars.search_area = trackpars.bbox_dilation;
trackpars.search_sum = trackpars.posnum+  trackpars.negnum;

%% individual parameters
switch (env.dataset)
    case 'Boy'
        trackpars.cls_err_thresh = 0.6;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 1;
        trackpars.search_sum = 100;

    case 'Walking2'
        trackpars.cls_err_thresh = 0.7;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.3;
        trackpars.search_sum = 100;
    case 'Walking'
        trackpars.cls_err_thresh = 0.7;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.3;
        trackpars.search_sum = 100;
    case 'Vase'
        trackpars.cls_err_thresh = 0.73;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.5;
        trackpars.search_sum = 100;
    case 'Twinnings'
        trackpars.cls_err_thresh = 0.73;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.3;
        trackpars.search_sum = 100;
    case 'Trellis'
        trackpars.cls_err_thresh = 0.6;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.2;
        trackpars.search_sum = 200;
    case 'Tiger2'
        trackpars.cls_err_thresh = 0.6;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.8;
        trackpars.search_sum = 200;

    case 'Tiger1'
        trackpars.cls_err_thresh = 0.6;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.7;
        trackpars.search_sum = 200;
    case 'Skating1'
        trackpars.cls_err_thresh = 0.8;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.5;
        trackpars.search_sum = 100;
    case 'Skater'
        trackpars.cls_err_thresh = 0.7;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.5;
        trackpars.search_sum = 100;
    case 'Shaking'
        trackpars.cls_err_thresh = 0.7;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.5;
        trackpars.search_sum = 300;
    case 'RedTeam'
        trackpars.cls_err_thresh = 0.7;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.3;
        trackpars.search_sum = 100;
    case 'Panda'
        trackpars.cls_err_thresh = 0.8;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.3;
        trackpars.search_sum = 400;
    case 'MountainBike'
        trackpars.cls_err_thresh = 0.7;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.3;
        trackpars.search_sum = 100;
    case 'MotorRolling'
        trackpars.cls_err_thresh = 0.85;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.3;
        trackpars.search_sum = 300;
    case 'Mhyang'
        trackpars.cls_err_thresh = 0.7;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.78;
        trackpars.search_sum = 100;
    case 'Matrix'
        trackpars.cls_err_thresh = 0.8;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.4;
        trackpars.search_sum = 200;
    case 'Man'
        trackpars.cls_err_thresh = 0.7;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.78;
        trackpars.search_sum = 100;
    case 'Lemming'
        trackpars.cls_err_thresh = 0.7;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.78;
        trackpars.search_sum = 100;
    case 'Jumping'
        trackpars.cls_err_thresh = 0.8;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.9;
        trackpars.search_sum = 100;
    case 'Human8'
        trackpars.cls_err_thresh = 0.8;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.7;
        trackpars.search_sum = 100;
    case 'Human2'
        trackpars.cls_err_thresh = 0.7;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.5;
        trackpars.search_sum = 100;
    case 'Girl'
        trackpars.cls_err_thresh = 0.7;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.3;
        trackpars.search_sum = 500;
    case 'Football'
        trackpars.cls_err_thresh = 0.75;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.8;
        trackpars.search_sum = 100;
    case 'Dudek'
        trackpars.cls_err_thresh = 0.6;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.5;
        trackpars.search_sum = 100;
    case 'Deer'
        trackpars.cls_err_thresh = 0.75;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.7;

    case 'David2'
        trackpars.cls_err_thresh = 0.6;
        trackpars.rec_err_thresh = 0.35;
    case 'Dancer2'
        trackpars.cls_err_thresh = 0.6;
        trackpars.rec_err_thresh = 0.35;
        %         trackpars.search_area = 0.45;
        %         trackpars.search_sum = 1000;
    case 'Crowds'
        trackpars.cls_err_thresh = 0.8;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.45;
        trackpars.search_sum = 1000;
    case 'Coke'
        trackpars.cls_err_thresh = 0.8;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 1;
        trackpars.search_sum = 400;

    case 'BlurCar2'
        trackpars.cls_err_thresh = 0.70;
        trackpars.rec_err_thresh = 0.35;

    case 'Car2'
        trackpars.cls_err_thresh = 0.68;
        trackpars.rec_err_thresh = 0.35;
    case 'Board'
        trackpars.cls_err_thresh = 0.75;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.2;
        trackpars.search_sum = 400;
    case 'Bolt'
        trackpars.cls_err_thresh = 0.78;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.4;
        trackpars.search_sum = 200;
    case 'Box'
        trackpars.cls_err_thresh = 0.61;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.29;
        trackpars.search_sum = 400;
    case 'Car4'
        trackpars.cls_err_thresh = 0.7;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.1;
        trackpars.search_sum = 100;
    case 'Gym'
        trackpars.cls_err_thresh = 0.78;
        trackpars.rec_err_thresh = 0.35;
        trackpars.bbox_dilation = 0.45;
    case 'Bird2'
        trackpars.cls_err_thresh = 0.8;
        trackpars.rec_err_thresh = 0.35;
        trackpars.search_area = 0.5;
        trackpars.search_sum = 400;
end


%% parameters for extracting features
% featpars.gridSpacing = 4;
% featpars.patchSizes = [16];
% featpars.patchSize = 16;
% featpars.numOBins = 16;
% featpars.numSBins = 4;
% featpars.maxImSize = 640;
% featpars.dims = [128 128];

