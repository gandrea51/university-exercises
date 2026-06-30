:- lib(fd).
:- lib(fd_global).
:- lib(cumulative).
:- [stampante].

% 2 - Versione su makespan

stamping(Tasklist) :-
    findall(task(I, Est, Lct, D), task(I, Est, Lct, D), Tasklist),
    
    length(Tasklist, N), 
    length(Starts, N).
    maxend(M),
    Starts :: 0 .. M,
    Ends ::  0 .. 1000,
    
    constraints(Tasklist, Starts, Ends), 
    cumul(Tasklist, Starts), 
    
    % distanze(Tasklist, Starts, Mind), nel testo
    append(Starts, [Ends], Vars)
    
    % min_max(labeling(Starts), -Mind).
    min_max(labeling(Vars), Ends).


constraints([], []).
constraints([task(_, Est, Lct, D) | TT], [S | ST], Ends) :-
    S #>= Est,
    S + D #=< Lct,
    s + D #=< Ends,
    constraints(TT, ST).


cumul(Tasklist, Starts) :-
    duration(Tasklist, Durations),
    length(Starts, N),
    length(Risorse, N),
    Risorse :: 1,
    cumulative(Starts, Durations, Risorse, 1).


duration([], []).
duration([task(_, _, _, D) | TT], [D | DT]) :-
    duration(TT, DT).


distanze(Tasklist, Starts, Mind) :-
    distanze2(Tasklist, Starts, Distance), 
    maxend(M),
    Mind :: 0 .. M,
    minimo(Distance, Mind).


distanze2([], [], []).
distanze2([T | TT], [S | ST], D) :-
    distloop(T, S, TT, ST, D1),
    distanze2(TT, ST, D2),
    append(D1, D2, D).

distloop(_, _, [], [], []).
distloop(task(_, _, _, D1), S1, [task(_, _, _, D2) | TT], [S2 | ST], [D | DT]) :-
    D #>= 0, 
    (
        S1 + D1 #=< S2,
        D #= S2 - (S1 + D1)
    ;
        S2 + D2 #=< S1,
        D #= S1 - (S2 + D2)
    ),
    distloop(task(_, _, _, D1), S1, TT, ST, DT).

minimo([], _).
minimo([D | DT], Min) :-
    Min #=< D,
    minimo(DT, Min).