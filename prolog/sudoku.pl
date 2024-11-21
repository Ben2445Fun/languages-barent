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

subgrid(Puzzle, Rows, Columns, Subgrid) :-
    maplist(slice(Columns), Rows, Puzzle, Subgrid).

slice(Puzzle, Rows, Columns, Subgrid) :-
    nth1(Rows, Puzzle, Row),
    include_indices(Row, Columns, Subgrid).

include_indices(Row, Indices, Subgrid) :-
    maplist(nth1_indices(Row), Indices, Subgrid).

extract_subgrid(Puzzle, RowIndices, ColIndices, Subgrid) :-
    maplist(get_columns(ColIndices), RowIndices, Puzzle, SubgridRows),
    append(SubgridRows, Subgrid).

get_columns(ColIndices, RowIndex, Puzzle, SubgridRow) :-
    nth1(RowIndex, Puzzle, Row), 
    findall(Element, (nth1(Index, Row, Element), member(Index, ColIndices)), SubgridRow).

extract_all_subgrids(Puzzle, Subgrids) :-
    RowGroups = [[1,2,3], [4,5,6], [7,8,9]],
    ColGroups = [[1,2,3], [4,5,6], [7,8,9]],
    findall(Subgrid, (member(Rows, RowGroups), member(Cols, ColGroups), extract_subgrid(Puzzle, Rows, Cols, Subgrid)), Subgrids).


solve(Puzzle) :-
    Puzzle = [Row1, Row2, Row3, Row4, Row5, Row6, Row7, Row8, Row9],
    Puzzle2 = Puzzle,
    append(Puzzle, Vars),           % Flatten table
    Vars ins 1..9,                  % Value Range
    maplist(all_distinct, Puzzle),  % Makes sure each variable in each row is unique
    transpose(Puzzle, Columns),     % Reorganizes into columns
    maplist(all_distinct, Columns), % Makes sure each variable in each column is unique
    label(Vars).                    % Assign unique value to each cell
