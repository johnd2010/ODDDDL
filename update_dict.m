function dict = update_dict(feat, dictpars, dict)

% online dictionary learning using stochastic gradient descent algorithm
% Inputs:
%    -para: learning paramters
%       .D: initial dictionary
%       .A: initial transform matrix
%       .W: initial classifier
%       .mu: reguliarization parameter
%       .nu1: reguliarization parameter
%       .nu2: reguliarization parameter
%       .maxIters: iteration number
%       .rho: learning rate parameter
%    -trainingdata: input training des. with size of n X N
%    -HMat: label matrix of training des. with size of m X N
%    -QMat: optimal code matrix of training des. with size of K X N
%
% Outputs:
%    -model: learned paramters
%       .D: learned dictionary
%       .A: learned transform matrix
%       .W: learned classifier
%    -stat:
%       .fobj_avg: average objective function value
%
%  Author: Zhuolin Jiang (zhuolin@umiacs.umd.edu)
%



trn = feat.feaArr;
num_bases = dictpars.numBases;
num_iters = dictpars.maxIters;
num_images = size(trn, 2);
numClass = dictpars.numcls; % number of objects
HMat = zeros(numClass, num_bases);
HMat(1, feat.label == 1) = 1;
HMat(2, feat.label == -1) = 1;

%% compute Q
dictLabel = [];
numPerClass = num_bases / numClass;
for classid = 1:numClass
    labelvector = zeros(numClass,1);
    labelvector(classid) = 1;
    dictLabel = [dictLabel repmat(labelvector,1,numPerClass)];
end
QMat = zeros(num_bases, size(trn, 2)); % energy matrix
for frameid = 1:size(trn, 2)
    label_training = HMat(:, frameid);
    [~, maxid1] = max(label_training);
    for itemid = 1:size(dict.D,2)
        label_item = dictLabel(:, itemid);
        [~, maxid2] = max(label_item);
        if(maxid1 == maxid2)
            QMat(itemid, frameid) = 1;
        end
    end
end


gamma = dictpars.gamma; % sparse coding parameters
lambda = dictpars.lambda;
nu1 = dictpars.nu1;
nu2 = dictpars.nu2;
mu = dictpars.mu;
rho = dictpars.rho;
bsize = dictpars.batchSize;
% bsize = num_images / 5;
%n0 = num_images/10
n0 = num_images/(bsize*10);

model.D = dict.D; % dictionary
model.W = dict.W; % classifier
model.A = dict.A; % transform matrix

param.lambda = dictpars.lambda;
param.lambda2 = 0;
param.mode = 2;

% crf iterations
for iter = 1 : num_iters
    tic;
    stat.fobj_total = 0;
    % Take a random permutation of the samples
    ind_rnd = randperm(num_images);
    
    for batch = 1:(num_images/bsize)
        % load the dataset
        % we only loads one sample or a small batch at each iteration
        batch_idx = ind_rnd((1:bsize) + bsize*(batch-1));
        yt = trn(:,batch_idx);
        ht = HMat(:,batch_idx);
        qt = QMat(:,batch_idx);
        
        D = model.D;
        W = model.W;
        A = model.A;
        
        % sparse coding
        %S = L1QP_FeatureSign_Set(yt, D, gamma, lambda);
        S = mexLasso(yt,D,param);
       
        % compute the gradient of crf parameters       
        grad_W = (1-mu)*(W*S - ht)*S' + nu2*W; %
%         grad_A = mu*(A*S - qt)*S' + nu1*A;
        grad_S1 = W'*(W*S - ht); % gradient w.r.t S for 0.5*||H-WS||_2^2
        grad_S2 = A'*(A*S - qt); % gradient w.r.t S for 0.5*||Q-AS||_2^2
        
        % compute the gradient of dictionary
        % find the active set and compute beta
        B1 = zeros(num_bases, bsize);
        B2 = zeros(num_bases, bsize);
        DtD = D'*D;
        for j = 1:bsize
            active_set = find(S(:,j) ~= 0);
            %DtD = D(:,active_set)'*D(:,active_set) + gamma*eye(length(active_set));
            DtD_hat = DtD(active_set,active_set) + gamma*eye(length(active_set));
            
            %DtD_inv = DtD\eye(length(active_set));
            DtD_inv = DtD_hat\eye(length(active_set));
            
            beta1 = DtD_inv * grad_S1(active_set,j);
            B1(active_set,j) = beta1;
            
            beta2 = DtD_inv * grad_S2(active_set,j);
            B2(active_set,j) = beta2;
        end
        grad_D = (1-mu)*(-D*B1*S' + (yt - D*S)*B1') + mu*(-D*B2*S' + (yt - D*S)*B2'); % dD = -D*B*S' + (X - D*S)*B';
        
        %use yang's method
        %gfullMat = zeros([size(D),size(D,2)]);
        %[gMat, IDX] = sparseDerivative(D, full(S), yt);
        %gfullMat(:,IDX,IDX) = gMat;
        %gradSmat = repmat(reshape(grad_S1,[1 1 length(grad_S1)]),size(D));
        %grad_D = sum(gfullMat.*gradSmat,3);
        
        % update the learning rate
        rho_i = min(rho, rho*n0/batch);
        
        % update model parameters
        D = D - rho_i*grad_D;
        l2norm = (sum(D.^2)).^.5;
        D = D ./ repmat(l2norm,size(D,1),1);
        model.D = D;
        
        W = W - rho_i*grad_W;
        model.W = W;
        
%         A = A - rho_i*grad_A;
%         model.A = A;    
    end
  
    % get statistics
    S = mexLasso(trn,D,param);
    fobj = get_objective(D, S, trn, W, HMat, A, QMat, lambda, mu);
    stat.fobj_avg(iter) = fobj + 0.5*nu1*sum(sum(W.^2)) + 0.5*nu2*sum(sum(A.^2));
%     fprintf('Iter = %d, Elapsed Time = %f\n', iter, toc);
end

% figure(3);
% plot(stat.fobj_avg)