function s_rs=fx_rescale_struct(s, I, idx_beg, idx_end)
%--------------------------------------------------------------------------
% rescale a structure by I
% n is the number of field

%--------------------------------------------------------------------------
% field name
field_c=fieldnames(s);

% nargin
if nargin<3
    i_beg=1;
    i_end=length(field_c);
else
    i_beg=idx_beg;
    i_end=idx_end;
end
    
% rescale by field name
for i=i_beg:i_end
    ifield=field_c{i};
    value=getfield(s, ifield); %#ok<GFLD> %get value of each field
       value_rs=value(I);
    s_rs.(ifield)=value_rs;
end
end