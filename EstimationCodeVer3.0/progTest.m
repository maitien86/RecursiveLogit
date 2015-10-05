global Op;
[Op.value, Op.grad ] = getLL(Op);
h = 0.000000001 * [0 1 0 0 0]';
Op.x = Op.x +h;
[val gr] = getLL(Op);
(gr - Op.grad)/0.000000001