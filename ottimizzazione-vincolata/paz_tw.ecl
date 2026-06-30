:- lib(fd).
:- lib(fd_global).
:- lib(propia).
:- [pazienti].

routing(Percorso, Arrivi, Price) :-
    findall(ID, paziente(ID, _, _), Paz),
    
    length(Paz, N),
    length(Percorso, N),
    length(Arrivi, N),
    Percorso :: 1 .. N,
    Arrivi :: 1 .. 1000,

    fd_global:alldifferent(Percorso),
    
    windows(Percorso, Arrivi),
    
    time(Percorso, Arrivi),
    last(Percorso, Ult),
    nth1(N, Arrivi, Timelast),
    distanza(Ult, 0, Dult),

    Price #= Timelast + Dult,
    min_max(labeling(Percorso), Price).



paz(ID, Min, Max) :- paziente(ID, Min, Max) infers most.
dista(A, B, D) :- distanza(A, B, D) infers most.

windows([], []).
windows([P | PT], [A | AT]) :-
    paz(ID, Min, Max),
    A #>= Min,
    A #=< Max,
    windows(PT, AT).

time([P | PT], [A | AT]) :-
    dista(0, P, D),
    A #>= D,
    time2(P, PT, A, AT).

time2(_, [], _, []).
time2(P, [P2 | PT], A, [A2 | AT]) :-
    dista(P, P2, D2),
    A2 #>= A + D2,
    time2(P, PT, A, AT).


last([U], U).
last([_ | T], L) :- 
    last(T, L).