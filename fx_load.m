%to get the value in a field
function c=fx_load(path_file_read)
%--------------------------------------------------------------------------
% field name
s=load(path_file_read); %Load variables from file into workspace
field=fieldnames(s); 
%names = fieldnames(s) returns a cell array of character vectors 
% containing the names of the fields in structure s.
% rescale by field name
value=getfield(s, field{1}); %the value in a field
c=value;

end
