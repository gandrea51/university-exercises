:- lib(fd).
:- lib(fd_global).
:- [progetti].

accoppiamento(Decision, Gain) :-
    findall(P, progetto(P), Lprog),
    findall(T, team(T), Lteam),

    length(Lprog, NP),
    length(Lteam, NT),
    length(Decision, NP),
    Decision :: 1 .. NT,

    findall([P, T], richiede(P, T), Lrich),
    def_richieste(Lrich, Decision),

    findall([P, T], incompatibile(P, T), Lincomp),
    def_incompatibile(Lincomp, Decision),

    def_capacity(Decision, NT),

    findall([P, R], collabora(P, R), Lcoll),
    def_collabora(Lcoll, Decision, Price),

    fd_global:sumlist(Price, Gain),
    min_max(labeling(Decision), -Gain).

    

def_capacity(Decision, Team) :-
    (
        for(T, 1, Team), param(Decision) do
            occurrences(T, Decision, N),
            N #=< 2
    ).

def_incompatibile([], _).
def_incompatibile([[P, T] | IT], Decision) :-
    index_project(P, I),
    index_team(T, V),
    nth1(I, Decision, D),
    D #\= V,
    def_incompatibile(IT, Decision).


def_richieste([], _).
def_richieste([[P, T] | RT], Decision) :-
    index_project(P, I),
    index_team(T, V),
    nth1(I, Decision, V),
    def_richieste(RT, Decision).


def_collabora([], _, []).
def_collabora([[A, B] | CT], Decision, [P | PT]) :- 
    index_project(A, IA),
    index_project(B, IB),
    nth1(IA, Decision, VA),
    nth1(IB, Decision, VB),
    VA #= VB #<=> P,
    def_collabora(CT, Decision, PT).

index_project(P, I) :-
    findall(A, progetto(A), List),
    nth1(I, List, P).


index_team(T, I) :-
    findall(A, team(A), List),
    nth1(I, List, T).

