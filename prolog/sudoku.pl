:- use_module(library(clpfd)).

puzzle([
    [7, _, _, _, _, _, _, _, 6],
    [_, 4, _, _, _, 8, 1, _, 2],
    [2, _, _, 3, 1, _, 4, _, _],
    [_, _, 4, _, 2, 1, 3, _, 5],
    [_, 9, _, 5, _, 6, _, 2, _],
    [8, _, 2, 4, 3, _, 7, _, _],
    [_, _, 7, _, 4, 2, _, _, 8],
    [1, _, 5, 9, _, _, _, 4, _],
    [4, _, _, _, _, _, _, _, 7]
]).


transpose([], []).
transpose([F|Fs], Ts) :-
    transpose(F, [F|Fs], Ts).


transpose([], _, []).
transpose([_|Rs], Ms, [Ts|Tss]) :-
    lists_firsts_rests(Ms, Ts, Ms1),
    transpose(Rs, Ms1, Tss).


lists_firsts_rests([], [], []).
lists_firsts_rests([[F|Os]|Rest], [F|Fs], [Os|Oss]) :-
    lists_firsts_rests(Rest, Fs, Oss).


solve(Puzzle) :-
    Puzzle = [Row1, Row2, Row3, Row4, Row5, Row6, Row7, Row8, Row9],
    append(Puzzle, Vars),
    Vars ins 1..9,
    maplist(all_distinct, Puzzle),
    transpose(Puzzle, Columns),
    maplist(all_distinct, Columns),
    label(Vars).
