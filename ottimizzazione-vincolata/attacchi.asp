difesa(D) :-  difese(L), member(D, L).

{ find(D) } :- difesa(D).

:- attacco(A, _), not coperto(A).
coperto(A) :- attacco(A, D), find(D).

#minimize { 1, D : find(D) }.