% N-Queen 

scacchiera(1).
scacchiera(N + 1) :- scacchiera(N), N < 100.

{ queen(R, C) } :- scacchiera(R), scacchiera(C).

:- scacchiera(R), not row(R).
row(R) :- queen(R, C).

:- queen(R, C), queen(R, C1), C != C1.
:- queen(R, C), queen(R1, C), R != R1.

:- queen(R, C), queen(R1, C1), |R - R1| == |C - C1|.
