:- lib(fd).
:- lin(fd_global).
:- [attacchi].

policy(Decision) :-
    difese(Ldif),
    
    length(Ldif, N),
    length(Decision, N),
    Decision :: 0 .. 1,

    findall(L, attacco(_, List), Lattac),
    def_policy(Lattac, Decision),
    
    fd_global:sumlist(Decision, Price),
    min_max(labeling(Decision), Price).



def_policy([], _).
def_policy([L | LT], Decision) :-
    scalar_product(L, Decision, #>=, 1),
    def_policy(LT, Decision).