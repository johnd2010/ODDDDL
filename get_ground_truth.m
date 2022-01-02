function GT = get_ground_truth(env,single)
%GET_GROUND_TRUTH Summary of this function goes here
%   Detailed explanation goes here
GT = table2array(readtable(fullfile(env.gt)));
if single
    GT=GT(env.frame_number,:);
end

