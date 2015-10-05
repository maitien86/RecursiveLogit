function [f g] = LL(x)
    global Op;
    Op.x = x;
    [f g] = getLL();
    Op.nFev  = Op.nFev + 1;
%    Op.value = f;
%    Op.grad = g;
%    Op.value
%    Op.grad
end