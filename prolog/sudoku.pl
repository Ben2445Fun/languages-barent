:- use_module(library(clpfd)).

% Enter Puzzle Here, use underscore for blanks
% Empty row for copying _, _, _, _, _, _, _, _, _
    puzzle([
        [_, 5, _, _, 4, 6, 9, _, 2],
        [_, 4, 6, _, _, _, _, 5, _],
        [7, _, _, _, _, 5, 4, 8, _],
        [_, _, _, _, 9, _, _, 2, 3],
        [_, 2, 8, _, 5, _, 7, 6, _],
        [6, 9, _, _, 3, _, _, _, _],
        [_, 7, 3, 9, _, _, _, _, 5],
        [_, 8, _, _, _, _, 1, 3, _],
        [4, _, 5, 7, 1, _, _, 9, _]
    ]).

groupings([[1,2,3],[4,5,6],[7,8,9]]).

% Subgridding
    nth1fromrow(Row, Column, Element) :-
        nth1(Column, Row, Element).

    get_columns(Puzzle, SelectedColumns, SelectedRow, SubgridRow) :-
        nth1(SelectedRow, Puzzle, ReturnRow),
        maplist(nth1fromrow(ReturnRow), SelectedColumns, SubgridRow).

    extract_subgrid(Puzzle, SelectedRows, SelectedColumns, Subgrid) :-
        maplist(get_columns(Puzzle, SelectedColumns), SelectedRows, SubgridRows),
        append(SubgridRows, Subgrid).


% Constraints
    row_constraints([]).
    row_constraints([Row|Rows]) :-
        all_distinct(Row),
        row_constraints(Rows).

    column_constraints(Puzzle) :-
        transpose(Puzzle, Transposed),
        row_constraints(Transposed).

    enforce_subgrid_constraints(Puzzle, SelectedRows, SelectedColumns) :-
        extract_subgrid(Puzzle, SelectedRows, SelectedColumns, Subgrid),
        all_distinct(Subgrid).

    unique_subgrid(Puzzle, SelectedRows) :-
        groupings(Groupings),
        maplist(enforce_subgrid_constraints(Puzzle, SelectedRows), Groupings).

    subgrid_constraints(Puzzle) :-
        groupings(Groupings),
        maplist(unique_subgrid(Puzzle), Groupings).

    constraints(Puzzle) :-
        row_constraints(Puzzle),
        column_constraints(Puzzle),
        subgrid_constraints(Puzzle).



solve(Puzzle) :-
    append(Puzzle, Vars),
    Vars ins 1..9,
    constraints(Puzzle),
    labeling([], Vars).