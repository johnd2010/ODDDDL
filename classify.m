function pred = classify(data, dict, sparsity)

alpha = .8;
% sparse coding
G = dict.D' * dict.D;
% try 
Gamma = omp(dict.D' * data, G, sparsity);
% catch ME
%     Gamma
%     
% end
pred = [];

% classify process
% score_est =  dict.W * Gamma;
% [val, ind] = max(score_est);  % classifying
% pred.val = score_est(1,:) - score_est(2,:);
% pred.ind = ind;
pred.sc = Gamma;

% reconstruction error
TW = dict.TW / sum(dict.TW);

avgT = dict.T * TW';
% figure(4);
% imagesc(reshape(avgT,32,32));

d = dict.D * Gamma;
A_norm = sqrt(sum(d .* d));
DX = d ./ (ones(size(d,1),1) * A_norm + eps);
Y = repmat(avgT, 1, size(data,2));
dif1 = Y - DX;
% dif1 = dif1 ./ repmat(sum(dif1), size(dif1,1), 1);
rec_err = sqrt(sum(dif1.^2));

% classification error
H = repmat([1;0],1,size(data,2));
dif2 = H - dict.W * Gamma;
cls_err = sqrt(sum(dif2.^2));
% t = dict.W * Gamma;
% cls_err = exp(-(t(1,:)-t(2,:)));
pred.rec_err = rec_err;
pred.cls_err = cls_err;

% % combine
pred.val = alpha * rec_err/sum(rec_err) + (1-alpha) * cls_err/sum(cls_err);

% pred.val = rec_err/sum(rec_err) .* cls_err/sum(cls_err);

% [val, ind] = min(pred.val);
% a=dif1(:,ind);
% figure(2);
% imagesc(reshape(a,32,32));