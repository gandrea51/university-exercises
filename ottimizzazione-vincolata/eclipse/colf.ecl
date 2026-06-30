:- lib(fd).
:- lib(cumulative).

colf([Lava, Asciuga, Stira, Piatti, Impasta, Lievita, Cuoci, Pulisci]) :-
    Lavdur = 45, Lavpot = 17,
    Ascdur = 60, Ascpot = 10,
    Stidur = 60, Stipot = 20,
    Piadur = 40, Piapot = 18,
    Impdur = 15, Imppot = 0,
    Liedur :: 60 .. 120, Liepot = 0,
    Cuodur = 15, Cuopot = 20,
    Puldur = 120, Pulpot = 0,

    [Lava, Asciuga, Stira, Piatti, Impasta, Lievita, Cuoci, Pulisci] :: 0 .. 200,

    Lava + Lavdur #=< Asciuga,
    Asciuga + Ascdur #=< Stira,
    Impasta + Impdur #=< Cuoci - 5,
    Lievita + Liedur #=< Cuoci,
    Impasta + Impdur #=< Pulisci,

    Lava + Lavdur #=< 200,
    Asciuga + Ascdur #=< 200,
    Stira + Stidur #=< 200,
    Piatti + Piadur #=< 200,
    Cuoci + Cuodur #=< 200,
    Pulisci + Puldur #=< 200,

    cumulative([Lava, Asciuga, Stira, Piatti, Cuoci], [Lavdur, Ascdur, Stidur, Piadur, Cuodur], [Lavpot, Ascpot, Stipot, Piapot, Cuopot], 30),
    cumulative([Stira, Impasta], [Stidur, Impdur], [1, 1], 1),

    labeling([Lava, Asciuga, Stira, Piatti, Impasta, Lievita, Cuoci, Pulisci]).
