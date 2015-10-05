%   Get MUtility
%%
function Mfull = getM(x, isLS)   

    global incidenceFull;
    global Atts;
    global Op;
    u = 0;
    for i = 1:Op.n
        u = u + x(i) * Atts(i).Value;
    end
    expM = u;
    expM(find(incidenceFull)) = exp(u(find(incidenceFull)));
    Mfull = incidenceFull .* expM;
    
end