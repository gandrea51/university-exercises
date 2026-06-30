:- lib(fd).
:- lib(fd_global).
:- lib(listut).
:- [abbina_matrimonio].

abbinamento(Decision) :-
    num_invitati(I),
    num_tavoli(T),
    capacita(C),

    length(Decision, I),
    Decision :: 0 .. T,

    findall([A, B], conflitto(A, B), Lconf),
    findall([A, B], conosce(A, B), Lconos),

    def_conflitto(Lconf, Decision),
    def_capacity(T, C, Decision),
    
    def_gain(Lconos, Decision, Price),
    fd_global:sumlist(Price, Gain),
    min_max(labeling(Decision), -Gain).


def_conflitto([], _).
def_conflitto([[A, B] | T], Decision) :-
    nth1(A, Decision, VA),
    nth1(B, Decision, VB),
    VA #\= VB,
    def_conflitto(T, Decision).

def_capacity(Table, Capacita, Decision) :-
    (
        for(T, 1, Table), param(Capacita, Decision) do
            occurrences(T, Decision, Number),
            Number #=< Capacita
    ).

def_gain([], _, []). 
def_gain([[A, B] | T], Decision, [P | PT]) :-
    nth1(A, Decision, VA),
    nth1(B, Decision, VB),
    VA #= VB #<=> P,
    def_gain(T, Decision, PT).