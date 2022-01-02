function check_folder(curr_path)
%% create directory to save results
if ~isfolder(curr_path)
    mkdir(curr_path);
end