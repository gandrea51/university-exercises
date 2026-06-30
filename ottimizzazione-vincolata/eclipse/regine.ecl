:- lib(fd).
:- lib(fd_global).

queen(N, Q) :-
    length(Q, N),
    Q :: 1 .. N,
    fd_global:alldifferent(Q),
    diag(Q),
    
    labeling(Q).


diag([]).
diag([Q | QT]) :-  
    diag_loop(QT, Q, 1), diag(QT).

diag_loop([], _, _).
diag_loop([A | T], Q, D) :-
    abs(Q - A) #\= D,
    D1 #= D + 1,
    diag_loop(T, Q, D1).

