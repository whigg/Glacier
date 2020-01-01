function path_refile=fx_reext(path_file, ext)
% 1. replace the original ext with new extension specified in 'ext'
% 2. if ext is not specified, the original ext is removed

%--------------------------------------------------------------------------
[file.path, file.name, file.ext]=fileparts(path_file);
if nargin==1
    filename=file.name;
end
if nargin==2
    filename=[file.name, ext];
end
% output
path_refile=fullfile(file.path, filename);

end