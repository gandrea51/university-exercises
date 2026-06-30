:- lib(fd).
:- lib(fd_global).
:- lib(cumulative).
:- [production].

schedule(Tasklist, Gain) :-
    findall(ordine(ID, Deadline), ordine(ID, Deadline), Data),
    endtime(End),
    schedule(Data, End, Tasklist, Gain).

schedule(Data, End, Tasklist, Gain) :-
    def_variables(Data, End, Tasklist),
    def_precedence(Tasklist),
    def_cumulative(Tasklist),
    
    def_obiettivo(Tasklist, Price),
    fd_global:sumlist(Price, Gain),
    extract_start(Tasklist, Lstart),
    min_max(labeling(Lstart), -Gain).


def_variables([], _, []).
def_variables([ordine(ID, Deadline) | DT], End, [ordine(ID, 1, Deadline, Start) | LT]) :-
    Start #>= 0,
    Start + 1 #=< End,
    def_variables(DT, End, LT).


def_precedence(Tasklist) :-
    findall([A, B], precedenza(A, B), Lprec),
    def_prec2(Lprec, Tasklist).

def_prec2([], _).
def_prec2([[A, B] | LT], Tasklist) :-
    find_ordine(A, Tasklist, ordine(A, 1, _, StartA)),
    find_ordine(B, Tasklist, ordine(B, 1, _, StartB)),
    StartA + 1 #=< StartB,
    def_prec2(LT, Tasklist).

find_ordine(A, [ordine(A, Dur, Dead, St) | _], ordine(A, Dur,  Dead, St)) :- !.
find_ordine(A, [_ | LT], List) :-
    find_ordine(A, LT, List).


def_cumulative(Tasklist) :-
    def_make(Tasklist, Lstart, Ldur),
    cumulative(Lstart, Ldur, Ldur, 1).

def_make([], [], []).
def_make([ordine(_, Dur, _, Start) | LT], [Start | ST], [Dur | DT]) :-
    def_make(LT, ST, DT).


def_obiettivo([], []).
def_obiettivo([ordine(_, 1, Dead, Start) | LT], [P | PT]) :-
    Start + 1 #=< Dead #<=> P,
    def_obiettivo(LT, PT).


extract_start([], []).
extract_start([ordine(_, _, _, Start) | LT], [Start | ST]) :-
    extract_start(LT, ST).