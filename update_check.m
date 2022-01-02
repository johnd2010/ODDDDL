function isgood = update_check(pred, ind, trackpars)
%
isgood = 1;
% numcls = 2;
% th_cls = 0.65;
% th_sc = 0.3;
% numperclass = size(dict.D,2) / numcls;
% sc = pred.sc(:,ind);

% for i = 1:numcls
%     prob(i) = sum(abs(sc(numperclass*(i-1)+1:i*numperclass))) / sum(abs(sc));
% end
% 
% ent = -sum(prob .* log(prob));


% if err > th_sc || ent > th_cls 
%     isgood = 0;
% end
% 

% avgW = sum(dict.TW) / length(dict.TW);
% th_lowerbound = .95;

% pred.cls_err(ind)
% pred.rec_err(ind) 
[pred.rec_err(ind) pred.cls_err(ind)]
if pred.cls_err(ind) > trackpars.cls_err_thresh || pred.rec_err(ind) > trackpars.rec_err_thresh
% if pred.cls_err(ind) > 1 || pred.rec_err(ind) > 0.35
    isgood = 0;
end

% if exp(-pred.val(ind)) < th_lowerbound * avgW
%     isgood = 0;
% end