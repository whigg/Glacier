function fx_errorbar(x, y, yneg, ypos, cs, lw, c)
% the add capsize to errorbar
% cs: cap size
% lw: line width
% c:  color

%--------------------------------------------------------------------------
hold on;
for i=1:length(x)
    % errorbar design
    if length(yneg)==1
        y_neg=[y(i)-yneg; y(i)-yneg];
        y_pos=[y(i)+ypos; y(i)+ypos];
        y_mid=[y(i)-yneg; y(i)+ypos];
    else
        y_neg=[y(i)-yneg(i); y(i)-yneg(i)];
        y_pos=[y(i)+ypos(i); y(i)+ypos(i)];
        y_mid=[y(i)-yneg(i); y(i)+ypos(i)];
    end
    x_neg=[x(i)-cs; x(i)+cs];
    x_pos=[x(i)-cs; x(i)+cs];
    x_mid=[x(i); x(i)];
    % plot
    line(x_neg, y_neg, 'LineWidth', lw, 'Color', c);
    line(x_pos, y_pos, 'LineWidth', lw, 'Color', c);
    line(x_mid, y_mid, 'LineWidth', lw, 'Color', c);
end

end