:- lib(fd).

prezzi(P1, P2) :-
    P1 :: 1 .. 5,
    P2 :: 1 .. 5,

    element(P1, [10, 5, 6, 8, 11], X),
    element(P2, [10, 5, 6, 8, 11], Y),
    X + Y #< 15,

    labeling([P1, P2]).
    