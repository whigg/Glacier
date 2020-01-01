function fx_mkdir(path_dir)
% make directory if it does not exist.

%--------------------------------------------------------------------------
% mother folder
[dir.path, dir.name, dir.ext]=fileparts(path_dir);
A1 = exist(dir.path, 'dir');
if A1==0
    mkdir(path_dir);
end   

% folder
A = exist(path_dir, 'dir');
if A==0
    mkdir(path_dir);
end    

end