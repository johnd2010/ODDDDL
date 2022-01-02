function [Dinit, Winit, Ainit, Q] = init_dict(feat, dictpars)
%

trn = feat.feaArr;
dictsize = dictpars.numBases;
iterations = dictpars.iterationini;
numClass = dictpars.numcls; % number of objects
Dinit = []; % for C-Ksvd and D-Ksvd
dictLabel = [];
numPerClass = dictsize / numClass;
H_train = zeros(numClass, dictsize);
H_train(1, feat.label == 1) = 1;
H_train(2, feat.label == -1) = 1;

Dinit = zeros(size(feat.feaArr,1),dictsize);  %Check the dimensionality - John

for classid = 1:numClass
    col_ids = find(H_train(classid,:) == 1);
    data_ids = find(colnorms_squared_new(trn(:, col_ids)) > 1e-6);   % ensure no zero data elements are chosen
    perm = randperm(length(data_ids));
    
    %% Initilization for LC-KSVD (perform KSVD in each class)
    Dpart = trn(:, col_ids(data_ids(perm(1:min(numPerClass,length(perm))))));
    param1.mode = 2;
    param1.K = dictsize;
    param1.lambda = dictpars.lambda;
    param1.lambda2 = 0;
    param1.iter = iterations;
    param1.D = Dpart;
    Dpart = mexTrainDL(trn(:,col_ids(data_ids)), param1);
    Dinit(:,1+(classid-1)*100:(classid)*100) =  Dpart;
    labelvector = zeros(numClass,1);
    labelvector(classid) = 1;
    dictLabel = [dictLabel repmat(labelvector,1,numPerClass)];
end

param1.D = Dinit;
Dinit = mexTrainDL(trn, param1);

param2.lambda = dictpars.lambda;
param2.lambda2 = 0;
param2.mode = 2;
Xinit = mexLasso(trn, Dinit, param2);

% learning linear classifier parameters
Winit = ((Xinit*Xinit' + eye(size(Xinit*Xinit')))\Xinit*H_train')';

Q = zeros(dictsize, size(trn, 2)); % energy matrix
for frameid = 1:size(trn, 2)
    label_training = H_train(:, frameid);
    [~, maxid1] = max(label_training);
    for itemid = 1:size(Dinit,2)
        label_item = dictLabel(:, itemid);
        [~, maxid2] = max(label_item);
        if(maxid1 == maxid2)
            Q(itemid, frameid) = 1;
        end
    end
end
% 
% Ainit = inv(Xinit*Xinit' + eye(size(Xinit*Xinit')))*Xinit*Q';
% Ainit = Ainit';
Ainit = eye(size(Xinit,1));
