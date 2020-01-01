function s=fx_cell2struct(c)
% convert cell to structure
%--------------------------------------------------------------------------
field_c=fieldnames(c{1});
for i=1:length(field_c)
    % read the ith field
    ifield=field_c{i};
    value=[];
    for j=1:length(c)
        jc=c{j};
        jvalue=getfield(jc, ifield); %#ok<GFLD>
        value=[value; jvalue];
    end
    % set the ith field 
    s.(ifield)=value;
end

end