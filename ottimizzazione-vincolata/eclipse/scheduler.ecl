:- lib(fd).
:- lib(fd_global).
:- lib(cumulative).

task(j1, 3, [], m1).
task(j2, 8, [], m1).
task(j3, 8, [j4, j5], m1).
task(j4, 6, [], m2).
task(j5, 3, [], m2).
task(j6, 4, [j1], m2).

schedule(End, TaskList) :- End :: 0 .. 100, findall(task(J, D, P, M), task(J, D, P, M), Data), schedule(Data, End, TaskList).

schedule(Data, End, TaskList) :- 
    makeVariables(Data, End, TaskList), 
    precedence(TaskList), 
    machines(TaskList), 
    starting(TaskList, LStart), 
    min_max(labeling(LStart), End).

makeVariables([], _, []).
makeVariables([task(J, D, P, M) | DT], End, [task(J, D, P, M, Start) | LT]) :- 
    Start #>= 0, Start #<= End - D,
    makeVariables(DT, End, LT).

precedence(TaskList) :- precedence2(TaskList, TaskList).

precedence2([], _).
precedence2([task(_, _, P, _, Start) | T], TaskList) :- 
    after(P, Start, TaskList), precedence2(T, TaskList).

after([], _, _).
after([P | PT], Start, TaskList) :- 
    getting(P, TaskList, task(P, D, _, _, S)),
    Start #>= S + D,
    after(PT, Start, TaskList).

getting(J, [task(J, D, P, M, S) | _], task(J, D, P, M, S)) :- !.
getting(J, [ _ | TaskList], Task) :- getting(J, TaskList, Task).

machines(TaskList) :- 
    findall(M, task(_, _, _, M), LM),
    rm_duplicate(LM, ListMachine),
    apply_cumulative(ListMachine, TaskList).

apply_cumulative([], _).
apply_cumulative([M | MT], TaskList) :-
    select_machine(M, TaskList, Lstart, Lduration, Lresource),
    cumulative(Lstart, Lduration, Lresource, 1),
    apply_cumulative(MT, TaskList).

rm_duplicate([], []).
rm_duplicate([A | AT], L) :-
    member(A, AT), !,
    rm_duplicate(AT, L).
rm_duplicate([A | AT], [A | BT]) :-
    rm_duplicate(AT, BT).

select_machine(_, [], [], [], []).
select_machine(M, [task(_, D, _, M, Start) | TL], [Start | ST], [D | DT], [1 | RT]) :-
    !, select_machine(M, TL, ST, DT, RT).
select_machine(M, [_ | TL], ST, DT, RT) :-
    select_machine(M, TL, ST, DT, RT).

starting([], []).
starting([task(_, _, _, _, Start) | TL], [Start | ST]) :-
    starting(TL, ST).