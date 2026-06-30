auto(f; a; l; m).
colore(giallo; rosso; nero; grigio).
prezzo(1 .. 4).
interno(marrone; panna; blu; verde).

1 { col(A, C) : colore(C) } 1 :- auto(A).
1 { pr(A, P) : prezzo(P) } 1 :- auto(A).
1 { int(A, I) : interno(I) } 1 :- auto(A).

:- col(A, C), col(B, C), A != B.
:- pr(A, P), pr(B, P), A != B.
:- int(A, I), int(B, I), A != B.

1 { int(A, verde) : auto(A)} 1.

e(1, 1) :- not col(l, giallo).
e(1, 2) :- not pr(l, 2).
e(1, 3) :- not int(l, marrone).

e(2, 1) :- not col(f, rosso).
e(2, 2) :- not pr(f, 4).
e(2, 3) :- not int(f, marrone).

e(3, 1) :- col(A, nero), A != a.
e(3, 2) :- col(A, nero), not pr(A, 1).
e(3, 3) :- col(A, nero), not int(A, panna).

e(4, 1) :- pr(A, 4), A != l.
e(4, 2) :- pr(A, 4), not col(A, rosso).
e(4, 3) :- pr(A, 4), not int(A, blu).

e(5, 1) :- not col(a, grigio).
e(5, 2) :- not pr(a, 3).
e(5, 3) :- not int(a, blu).

#maximize{ 1, T, E : e(T, E) }.