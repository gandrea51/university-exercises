:- lib(fd).
:- lib(fd_global_gac).

workon([Peter, Paul, Mary, John, Bob, Mike, Julia]) :-
    Peter :: 1 .. 5,
    Paul :: 1 .. 5,
    Mary :: 1 .. 5,
    John :: 1 .. 5,
    Bob :: 1 .. 5,
    Mike :: 1 .. 5,
    Julia :: 1 .. 5,

    gcc([gcc(1, 2, 1),
        gcc(1, 2, 2),
        gcc(1, 1, 3),
        gcc(0, 2, 4),
        gcc(0, 2, 5)], [Peter, Paul, Mary, John, Bob, Mike, Julia]),

    labeling([Peter, Paul, Mary, John, Bob, Mike, Julia]).
