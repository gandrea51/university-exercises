:- lib(fd).
:- lib(fd_global).
:- lib(cumulative).

torta([Talk, Dog, Cake]) :-
    [Talk, Dog, Cake] :: 1 .. 3,
    [Talkstart, Dogstart, Cakestart] :: 0 .. 20,

    fd_global:alldifferent([Talk, Dog, Cake]),

    element(Talk, [5, 3, 2], Talkdur),
    element(Dog, [4, 2, 3], Dogdur),
    element(Cake, [2, 5, 4], Cakedur),

    Talkend #= Talkstart + Talkdur,
    Dogend #= Dogstart + Dogdur,
    Cakeend #= Cakestart + Cakedur,
    
    Dogstart #>= Talkstart + 1,
    Dogend #=< Talkend - 1,

    Cakestart #>= Talkstart,
    Cakestart #>= Dogstart,
    
    Cakeend #<= Talkend,
    Cakeend #<= Dogend,

    cumulative([Talkstart, Dogstart, Cakestart], [Talkduration, Dogduration, Cakeduration], [1, 1, 1], 1),
    labeling([Talk, Dog, Cake]).
