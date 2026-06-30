:- lib(fd).
:- lib(fd_global).
:- [pazienti].

routing(Successori, Arrivi, Tempo) :-
    
    % Ottengo tutti i pazienti
    findall(I, paziente(I, _, _), Paz),
    length(Paz, N),

    % Aggiungo il paz. 0
    NC is N + 1,
    length(Successori, NC),
    Successori :: 0 .. N,

    ic_global:alldifferent(Successori),

    length(Arrivi, NC),
    Arrivi :: 0 .. 1000,

    windows(Arrivi),
    travel(Successori, Arrivi, 0),

    maximum(Arrivi, Tempo),
    append(Successori, Arrivi, Vars),
    min_max(labeling(Vars), Tempo).


windows(Arrivi) :-
    findall(paziente(I, Min, Max), paziente(I, Min, Max), Data),
    windows2(Data, Arrivi).

windows2([], _).
windows2([paziente(I, Min, Max) | PT], Arrivi) :-
    element(I, Arrivi, V),
    V #=> Min, V #<= Max,
    windows2(PT, Arrivi). 

travel([], [], _).
travel([S | ST], [A | AT], I) :-
    element(S, AT, V),
    distanza(I, S, Tempo),
    V #>= A + Tempo,
    I1 is I + 1,
    travel(ST, AT, I1).