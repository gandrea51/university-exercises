:- lib(fd).
:- lib(fd_global).

verniciatura(Sequenza, MaxD, Lista) :-
    length(Sequenza, N),
    length(Lista, N),
    Lista ::  1 .. N,

    posizioni(Lista, 1, MaxD),
    fd_global:alldifferent(Lista),
    cambio(Lista, Sequenza, Obiettivo),

    min_max(labeling(Lista), Obiettivo).


posizioni([], _, _).
posizioni([H | T], N, MaxD) :-
    N - H #<= MaxD,
    H - N #<= MaxD,
    Successivo is N + 1,
    posizioni(T, Successivo, MaxD).


cambio([_], _, 0) :- !.
cambio([L | LT], [S | ST], Obiettivo) :-
    cloop(L, LT, S, ST, Ob1),
    cambio(LT, ST, Ob2),
    Obiettivo #= Ob1 + Ob2.


cloop(_, [], _, [], 0).
cloop(L, [_ | LT], S, [S | ST], Ob1) :- !,
    cloop(L, LT, S, ST, Ob1).
cloop(L, [L1 | LT], S, [S1 | ST], Ob1) :- !,
    S \= S1,
    L - L1 #= 1 #<=> Bool1,
    L1 - L #= 1 #<=> Bool2,
    Ob1 #= Ob2 + Bool1 + Bool2,
    cloop(L, LT, S, ST, Ob2).