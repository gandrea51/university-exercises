:- lib(fd).
:- lib(fd_global).
:- lib(cumulative).
:- [production].

scheduling(Profitto, TaskList) :-
    findall(ordine(ID, Deadline), ordine(ID, Deadline), Data),
    endtime(End),
    scheduling(Data, End, Profitto, TaskList).


scheduling(Data, End, Profitto, TaskList) :-
    def_variables(Data, End, TaskList),
    precedence(TaskList),
    def_schedule(TaskList),
    obtain_starts(TaskList, Starts),
    obiettivo(TaskList, Obj),
    fd_global:sumlist(Obj, Profitto),
    min_max(labeling(Starts), -Profitto).



def_variables([], _, []).
def_variables([ordine(ID, Deadline) | OT], End, [ordine(ID, 1, Deadline, Start) | TT]) :-
    Start #>= 0,
    Start + 1 #=< End,
    def_variables(OT, End, TT).


precedence(TaskList) :-
    findall([One, Two], precedenza(One, Two), Lprec),
    precedence2(Lprec, TaskList).

precedence2([], _).
precedence2([[A, B] | PT], TaskList) :-
    find_ordine(A, TaskList, ordine(A, 1, _, StartA)),
    find_ordine(B, TaskList, ordine(B, 1, _, StartB)),
    StartA + 1 #=< StartB,
    precedence2(PT, TaskList).


find_ordine(ID, [ordine(ID, Dur, Deadline, Start) | _], ordine(ID, Dur, Deadline, Start)) :- !.
find_ordine(ID, [_ | TT], Task) :-
    find_ordine(ID, TT, Task).


def_schedule(TaskList) :-
    def_cumulative_element(TaskList, Starts, Durations, Resources),
    cumulative(Starts, Durations, Resources, 1).


def_cumulative_element([], [], [], []).
def_cumulative_element([ordine(_, D, _, S) | OT], [S | ST], [1 | DT], [1 | RT]) :-
    def_cumulative_element(OT, ST, DT, RT).


obiettivo([], []).
obiettivo([ordine(_, Dur, Deadline, Start) | OT], [P | PT]) :-
    Start + Dur #=< Deadline #<=> P,
    obiettivo(OT, PT).


obtain_starts([], []).
obtain_starts([ordine(_, _, _, S) | OT], [S | ST]) :- 
    obtain_starts(OT, ST).