%Finds files of a particular extension in a folder
function [u,nfile]=fx_dir(path_dir, type) 
ind=zeros;
switch nargin
    case 1
        type='';
    otherwise
end
c=strcat(path_dir,'*',type);
u=dir(c); % s is a structure having various fields, name etc
%filelist=s;
ind=0;
filelist = {u.name}'; % convert the name field from the elements
                        % of the structure array into a cell array
                        % of strings.
if nargin == 1
    a = length(u([u.isdir]));
elseif nargin ==2
    a=length(u);
end
b=0;
c=0;
for i=1:a
    if strcmp(u(i).name,'.') 
        if size(u(i).name)==1
        c=c+1;
        ind(c)=i;
        continue;
        end
    elseif strcmp(u(i).name,'..')
        c=c+1;
        ind(c)=i;
        continue;
    end
      
  end
nfile=a-c;
if ind~=0
u(ind)=[];
end
    
end