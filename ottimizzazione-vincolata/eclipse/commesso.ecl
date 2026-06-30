:- lib(fd).
:- lib(fd_global).
:- lib(propia).
:- [commesso_dist].

commesso(Percorso, Costo) :-
    ncitta(N),
    N1 is N + 1,

    length(Percorso, N1),
    Percorso = [1 | PT],
    last(Percorso, 1),

    PT :: 2 .. N,
    fd_global:alldifferent(PT),

    chilometri(Percorso, Costo),
    min_max(labeling(PT), Costo).


distanza(C1, C2, K) :- dista(C1, C2, K) infers most.

chilometri([_], 0).
chilometri([C1, C2 | CT], Costo) :-
    distanza(C1, C2, K),
    chilometri([C2 | CT], Costo1),
    Costo #= K + Costo1.

