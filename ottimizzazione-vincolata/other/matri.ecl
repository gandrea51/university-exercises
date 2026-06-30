:- lib(fd).
:- lib(fd_global).
:- lib(fd_global_gac).
:- lib(listut).
:- [matrimonio].

assegnamento(Abbina) :-
    findall([A, B], conflitto(A, B), Lconf),
    findall([A, B], conosce(A, B), Lconos),

    num_invitati(Invitati),
    num_tavoli(Tavoli),
    capacita(Capacita),

    length(Abbina, Invitati),
    Abbina :: 1 .. Tavoli,

    def_conflict(Lconf, Abbina),
    def_capacity(Tavoli, Capacita, Abbina),
    
    obiettivo(Lconos, Abbina, Obi),
    Price #= sum(Obi),
    min_max(labeling(Abbina), -Price).


def_conflict([], _).
def_conflict([[One, Two] | CT], Abbina) :-
    nth1(One, Abbina, V1), nth1(Two, Abbina, V2),
    V1 #\= V2,
    def_conflict(CT, Abbina).


obiettivo([], _, []).
obiettivo([[One, Two] | CT], Abbina, [O | OT]) :-
    nth1(One, Abbina, V1), nth1(Two, Abbina, V2),
    V1 #= V2 #<=> O,
    obiettivo(CT, Abbina, OT).


def_capacity(NumTavoli, Capacita, Abbina) :-
    ( for(T,1,NumTavoli), param(Capacita,Abbina) do
        occurrences(T, Abbina, Count),
        Count #=< Capacita
    ).
