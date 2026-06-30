:- lib(fd).
:- lib(fd_global).
:- lib(cumulative).
:- [task].

task(Finish) :-
    Starts = [S1, S2, S3, S4, S5, S6],
    Ends = [E1, E2, E3, E4, E5, E6],

    Finish :: 0 .. 100,
    Starts :: 0 .. 100,
    Ends :: 0 .. 100,

    E1 #= S1 + 3,
    E2 #= S2 + 8,
    E3 #= S3 + 8,
    E4 #= S4 + 6,
    E5 #= S5 + 3,
    E6 #= S6 + 4,

    S3 #>= E4,
    S3 #>= E5,
    S5 #>= E1,
    S6 #>= E1,

    Finish #>= E1, 
    Finish #>= E2,
    Finish #>= E3,
    Finish #>= E4,
    Finish #>= E5,
    Finish #>= E6,

    cumulative([S1, S2, S3], [3, 8, 8], [1, 1, 1], 1),
    cumulative([S4, S5, S6], [6, 3, 4], [1, 1, 1], 1),
    min_max(labeling(Starts), Finish).
