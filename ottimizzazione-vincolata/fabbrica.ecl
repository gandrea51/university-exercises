:- lib(fd).
:- lib(fd_global).
:- lib(cumulative).
:- [fabbrica_fatti].

schedule(Tasklist, End) :-
    findall(task(ID, Dur, Prec, Machine), task(ID, Dur, Prec, Machine), Data),
    def_variables(Data, End, Tasklist),
    def_precedence(Tasklist),

    find_all_machine(Tasklist),
    extracting(Tasklist, Starts),
    min_max(labeling(Starts), End).


def_variables([], _, []).
def_variables([task(ID, Dur, Prec, Machine) | DT], End, [task(ID, Dur, Prec, Machine, Start) | LT]) :-
    Start #>= 0, 
    Start + Dur #=< End,
    def_variables(DT, End, LT).

def_precedence(Tasklist) :-
    precedence2(Tasklist, Tasklist).

precedence2([], _).
precedence2([task(_, _, Prec, _, Start) | T], Tasklist) :-
    def_after(Prec, Start, Tasklist),
    precedence2(T, Tasklist).

def_after([], _, _).
def_after([P1 | PT], Start, Tasklist) :- !,
    find_task(P1, Tasklist, task(P1, Dur1, _, _, S1)),
    S1 + Dur1 #=< Start,
    def_after(PT, Start, Tasklist).

find_task(P, [task(P, Dur, Prec, Machine, Start) | LT], task(P, Dur, Prec, Machine, Start)) :- !.
find_task(P, [_ | T], LT) :-
    find_task(P, T, LT).


find_all_machine(Tasklist) :-
    findall(M, task(_, _, _, M), Lmach),
    removing(Lmach, Machines),
    impose_cumulative(Machines, Tasklist).


removing([], []).
removing([X | T], L) :-
    member(X, T), !,
    removing(T, L).
removing([X | T], [X | L]) :-
    removing(T, L).


impose_cumulative([], _).
impose_cumulative([M | MT], Tasklist) :-
    find_the_task(M, Tasklist, Lstart, Ldur, Lres),
    cumulative(Lstart, Ldur, Lres, 1),
    impose_cumulative(MT, Tasklist).


find_the_task(_, [], [], [], []).
find_the_task(M, [task(_, D, _, M, Start) | LT], [Start | ST], [D | DT], [1 | RT]) :- !,
    find_the_task(M, LT, ST, DT, RT).
find_the_task(M, [_ | LT], LS, LD, LR) :-
    find_the_task(M, LT, LS, LD, LR).


extracting([], []).
extracting([task(_, _, _, _, Start) | LT], [Start | ST]) :-
    extracting(LT, ST).