:- lib(fd).
:- lib(fd_global).
:- lib(listut).
:- [pack_inst].

pip(Decision) :-
    package(Pacchetti),
    installed(Installati),

    findall([A, B], conflict(A, B), Lconf),
    findall([A, B], requires(A, B), Lreq),
    findall(A, install(A), Linst),

    length(Pacchetti, N),
    length(Decision, N),
    Decision :: 0 .. 1,

    def_install(Linst, Decision),
    def_conflict(Lconf, Decision),
    def_requires(Lreq, Decision),

    def_change(Installati, Decision, Obiettivo),
    fd_global:sumlist(Obiettivo, Price),
    min_max(labeling(Decision), Price).


def_install([], _).
def_install([I | IT], Dec) :-
    nth1(I, Dec, 1),
    def_install(IT, Dec).


def_conflict([], _).
def_conflict([[A, B] | CT], Dec) :-
    nth1(A, Dec, VA),
    nth1(B, Dec, VB),
    VA + VB #=< 1,
    def_conflict(CT, Dec).


def_requires([], _).
def_requires([[A, B] | RT], Dec) :-
    nth1(A, Dec, VA),
    nth1(B, Dec, VB),
    VA #=< VB,
    def_requires(RT, Dec).


def_change([], [], []).
def_change([I | IT], [D | DT], [O | OT]) :-
    I #\= D #<=> O,
    def_change(IT, DT, OT). 