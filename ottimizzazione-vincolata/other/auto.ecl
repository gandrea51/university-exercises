:- lib(fd).
:- lib(cumulative).
:- [automobili].

task(cl(ID), 20, [], cl) :- rich(ID, _, 1, _, _).
task(ac(ID), 80, [], ac) :- rich(ID, _, _, 1, _).
task(ns(ID), 50, [], ns) :- rich(ID, _, _, _, 1).

schedule(End, Data) :-
    findall(task(Id, Dur, Prec, Mach), task(Id, Dur, Prec, Mach), Data),
    schedule(Data, End, TaskList).

schedule(Data, End, TaskList) :-
    def_variables(Data, End, TaskList),
    machine(TaskList),
    find_start(TaskList, Starts),
    min_max(labeling(Starts), End).


def_variables([], _, []).
def_variables([task(Id, Dur, Prec, Mach) | IT], End, [task(Id, Dur, Prec, Mach, Start) | OT]) :-
    Start #>= 0,
    Start #=< End - Dur,
    def_variables(IT, End, OT).


machine(TaskList) :-
    findall(M, task(_, _, _, M), LM),
    rm_dup(LM, ListMachine),
    apply_cumulative(ListMachine, TaskList).

rm_dup([], []).
rm_dup([H | T], L) :-
    member(H, T), !, rm_dup(T, L).
rm_dup([H | T], [H  L]) :-
    rm_dup(T, L).

apply_cumulative([], _).
apply_cumulative([M | MT], TaskList) :-
    same_machine(M, TaskList, Starts, Durs, Resources),
    cumulative(Starts, Durs, Resources, 1),
    apply_cumulative(MT, TaskList).

same_machine(_, [], [], [], []).
same_machine(M, [task(_, D, _, M, Start) | TT], [Start | ST], [D | DT], [1 | RT]) :- !,
    same_machine(M, TT, ST, DT, RT).
same_machine(M, [_ | LT], LS, LD, LR) :-
    same_machine(M, LT, LS, LD, LR).


find_start([], []).
find_start([task(_, _, _, _, S) | T], [S | ST]) :-
    find_start(T, ST).