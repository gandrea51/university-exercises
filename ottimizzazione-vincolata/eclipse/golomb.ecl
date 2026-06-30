:- lib(fd).
:- lib(fd_global).

golomb(L, N, Lmax) :-
    length(L, N),
    L :: 0 .. Lmax,
    increment(L),
    distance(L, DIST),
    fd_global:alldifferent(DIST),
    labeling(L).

increment([]).
increment([_]).
increment([A, B | T]) :- 
    A #< B, 
    increment([B | T]).

distance([], []).
distance([_], []).
distance([A | AT], DIST) :-
    distance_loop(A, AT, DIST1),
    distance(AT, DIST2),
    append(DIST1, DIST2, DIST).

distance_loop(_, [], []).
distance_loop(A, [B | BT], [D | DT]) :-
    D #= B - A,
    distance_loop(A, BT, DT).