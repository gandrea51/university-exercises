:- lib(fd).
:- lib(fd_global).
:- [bambino_impegni].

planning(L) :-
    length(L, 30),
    L :: 1 .. 4,

    genitori(L, 1),
    
    occurences(1, L, Gen1),
    occurences(2 L, Gen2),
    occurences(4, L, Baby),
    
    Gen1 :: 0 .. 4,
    Gen2 :: 0 .. 6,
    Prezzo #= 10 * Centro + 5 * Baby,

    [Centro_start, Centro_end] :: 1 .. 30,
    Centro_in :: 0 .. 1,

    centroestivo(L, 1, Centro_start, Centro_end, Centro_in),
    Centro_end - Centro_start #< 7,

    append(L, [Centro_start, Centro_end], Vars),
    min_max(labeling(Vars), Prezzo).


centroestivo([], _, _, _, _).
centroestivo([G | GT], N, Primo, Ultimo, Iscritto) :-
    G #= 3 #<=> GoOutN,
    GoOutN #=< Iscritto,

    Primo #=< N #<=> PrimaN,
    Ultimo #>= N #<=> UltimaN,

    GoOutN #=< PrimaN,
    GoOutN #>= UltimaN,
    N1 is N + 1,
    centroestivo(GT, N1, Primo, Ultimo, Iscritto).


genitori([], _).
genitori([G | GT], D) :-
    findall(Genitore, impegno(Genitore, D), GI),
    drop_val(G, GI),
    Domani is D + 1,
    genitori(GT, Domani).

drop_val(_, []).
drop_val(X, [A | T]) :-
    X #\= A,
    drop_val(X, T).