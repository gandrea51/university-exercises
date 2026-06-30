:- lib(fd).
:- lib(fd_global).
:- [corsi].

abbinamento(Decision, Gain) :-
    findall(I, corso(I), Lcorsi),
    findall(D, docente(D), Ldoc),

    length(Lcorsi, Ncorsi),
    length(Ldoc, Ndoc),

    length(Decision, Ncorsi),
    Decision :: 1 .. Ndoc,

    findall([C, D], incompatibile(C, D), Lincomp),
    def_incompatibile(Lincomp, Decision),

    findall([C1, C2], richiede(C1, C2), Lrich),
    def_richiede(Lrich, Decision),

    % Ipotizzando che esista un fatto capacita'/1 nel file corsi.pl --> capacita(C), def_capacity(C, Decision, Ldoc),
    % Altrimenti
    def_capacity(Decision, Ldoc),

    findall([C1, C2], affine(C1, C2), Laffi),
    def_affinity(Laffi, Decision, Price),
    fd_global:sumlist(Price, Gain),
    min_max(labeling(Decision), -Gain).