%   Get Utility
%%
function Ufull = getU(x, isLS)

    global incidenceFull;
    global Atts;
    global Op;
    u = 0;
    for i = 1:Op.n
        u = u + x(i) * Atts(i).Value;
    end
    Ufull = incidenceFull .* u;
end


