:- lib(fd).
:- lib(fd_global).
:- lib(cumulative).
:- [task].

schedule(Tasklist, Gain) :-
    findall(task(ID, EST, LCT, D), task(ID, EST, LCT, D), Data),
    maxend(End),
    schedule(Data, End, Tasklist, Gain).

schedule(Data, End, Tasklist, Gain) :-
    def_variables(Data, End, Tasklist),
    def_cumulative(Tasklist),

    extract_start(Tasklist, Lstart),
    %extract_end(Tasklist, Lend),
    minimo(Tasklist, Gain),
    min_max(labeling(Lstart), Gain).



def_variables([], _, []).
def_variables([task(ID, EST, LCT, Dur) | T], End, [task(ID, EST, LCT, Dur, Start) | LT]) :-
    Start #>= 0,
    Start #>= EST,
    Start + Dur #=< End,
    Start + Dur #=< LCT,
    def_variables(T, End, LT).


def_cumulative(Tasklist) :-
    def_make(Tasklist, Lstart, Ldur, Lres),
    cumulative(Lstart, Ldur, Lres, 1).


def_make([], [], [], []).
def_make([task(_, _, _, Dur, Start) | T], [Start | ST], [Dur | DT], [1 | RT]) :-
    def_make(T, ST, DT, RT).


extract_start([], []).
extract_start([task(_, _, _, _, Start) | T], [Start | ST]) :-
    extract_start(T, ST).

extract_end([], []).
extract_end([task(_, _, _, Dur, Start) | T], [End | ET]) :-
    Start + Dur #= End,
    extract_start(T, ET).

distance(A, EA, B, EB, D) :-
    (B #>= EA #/\ B - EA #= D) #\/
    (A #>= EB #/\ A - EB #= D). 

alldistance([], _, []).
alldistance([task(_, _, _, Dur, Start) | T], All, Dists) :-
    End #= Start + Dur,
    dwith(task(_, _, _, Dur, Start), T, D1),
    alldistance(T, All, D2),
    append(D1, D2, Dists).

dwith(_, [], []).
dwith(task(_, _, _, Dur, Start), [task(_, _, _, Dur2, Start2) | T], [D | DT]) :-
    E1 #= Start + Dur,
    E2 #= Start2 + Dur2,
    distance(Start, E1, Start2, E2, D),
    dwith(task(_, _, _, Dur, Start), T, DT).


minimo(Tasklist, Gain) :-
    alldistance(Tasklist, Tasklist, Dists),
    Gain #>= 0,
    (
        foreach(D, Dists), param(Gain) do
            Gain #=< D
    ).