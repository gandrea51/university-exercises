:- lib(fd).
:- lib(cumulative).

task(j1,3,[],m1).
task(j2,8,[],m1).
task(j3,8,[j4,j5],m1).
task(j4,6,[],m2).
task(j5,3,[j1],m2).
task(j6,4,[j1],m2).

schedule(End,TaskList):-
    findall(task(J,D,P,M),task(J,D,P,M),Data),
    schedule(Data, End, TaskList).

schedule(Data, End, TaskList):-	
    makeTaskVariables(Data,End,TaskList),
    precedence(TaskList),
    machines(TaskList),
    extract_start(TaskList,LStart),
    min_max(labeling(LStart),End).

makeTaskVariables([],_,[]).
makeTaskVariables([task(N,D,P,M)|T],End,[task(N,D,P,M,Start)|Var]):-
    Start #<= End-D, Start #>=0,
    makeTaskVariables(T,End,Var).

precedence(TaskList):- precedence2(TaskList,TaskList).
precedence2([],_).
precedence2([task(_,_,Prec,_,Start)|T],TaskList):-
  impose_after(Prec,Start,TaskList),
  precedence2(T,TaskList).

impose_after([],_,_).
impose_after([PrecJ|LPrec],StartI,TaskList):- !,
    get_task(PrecJ,TaskList,task(PrecJ,DJ,_,_,StartJ)),
    StartI #>= StartJ+DJ,
    impose_after(LPrec,StartI,TaskList).

get_task(J,[task(J,DJ,PJ,MJ,StartJ)|_],task(J,DJ,PJ,MJ,StartJ)):-!.
get_task(J,[_|TaskList],TaskJ):-
    get_task(J,TaskList,TaskJ).

machines(TaskList):-
    findall(M,task(_,_,_,M),LM),
    remove_duplicates(LM,ListMachines),
    impose_cumulative(ListMachines,TaskList).

impose_cumulative([],_).
impose_cumulative([M|LM],TaskList):-
    select_same_machine(M,TaskList,LStart,LDur,LRes), % Fissa ad 1 tutti gli elementi di LRes
    cumulative(LStart,LDur,LRes,1),
    impose_cumulative(LM,TaskList).
    
% Fare come esercizio i seguenti predicati:
select_same_machine(_,[],[],[],[]).
select_same_machine(M,[task(_,D,_,M,Start)|TaskList],[Start|LStart],[D|LDur],[1|LRes]):-!,
    select_same_machine(M,TaskList,LStart,LDur,LRes).
select_same_machine(M,[_|TaskList],LStart,LDur,LRes):-
    select_same_machine(M,TaskList,LStart,LDur,LRes).

remove_duplicates([],[]).
remove_duplicates([X|T],L):-
    member(X,T),!,
    remove_duplicates(T,L).
remove_duplicates([X|T],[X|L]):-
    remove_duplicates(T,L).

extract_start([],[]).
extract_start([task(_,_,_,_,Start)|TaskList],[Start|LS]):-
    extract_start(TaskList,LS).
%==================================================
