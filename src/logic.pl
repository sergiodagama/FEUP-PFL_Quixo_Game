/**
 * This module (logic.pl) contains the all the game logic
 */
:-use_module(library(lists)).
:-use_module(library(system)).
:-use_module(library(random)).
:-consult('user_interface.pl').

/**
 * initial_board(-Board)
 *
 * Game Board data structure (list)
 */
initial_board([
    [empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty]
    ]).

/**
 * computer_delay(-Delay)
 *
 * The computer play delay (seconds)
 */
computer_delay(2).

/**
 * game(-GameMode, +Board)
 *
 * Game loops
 */
game(hh, _, Board) :-
    %loop human human
    make_play(h, 0, Board, NewBoard),
    display_game(NewBoard),!,
    \+game_over(NewBoard, player1, player2),
    turn_player(player2_nought),
    make_play(h, 1, NewBoard, NewBoard2),
    display_game(NewBoard2),!,
    \+game_over(NewBoard2, player1, player2),
    turn_player(player1_cross),
    game(hh, _, NewBoard2).

game(hc, Dificulty, Board) :-
    %loop human computer
    make_play(h, 0, Board, NewBoard),
    display_game(NewBoard),!,
    \+game_over(NewBoard, human, computer),
    turn_player(computer_nought),
    make_play(c, 1, NewBoard, NewBoard2),
    display_game(NewBoard2),!,
    \+game_over(NewBoard2, human, computer),
    turn_player(human_cross),
    game(hc, Dificulty, NewBoard2).

game(ch, Dificulty, Board) :-
    %loop computer human
    make_play(c, 0, Board, NewBoard),
    display_game(NewBoard),!,
    \+game_over(NewBoard, computer, human),
    turn_player(human_nought),
    make_play(h, 1, NewBoard, NewBoard2),
    display_game(NewBoard2),!,
    \+game_over(NewBoard2, computer, human),
    turn_player(computer_cross),
    game(ch, Dificulty, NewBoard2).

game(cc, Dificulty, Board) :-
    %loop computer computer
    make_play(c, 0, Board, NewBoard),
    display_game(NewBoard),!,
    \+game_over(NewBoard, computer1, computer2),
    turn_player(computer2_nought),
    make_play(c, 1, NewBoard, NewBoard2),
    display_game(NewBoard2),!,
    \+game_over(NewBoard2, computer1, computer2),
    turn_player(computer1_cross),
    game(cc, Dificulty, NewBoard2).

/**
 * make_play(+GameMode, +Player, +Board, -NewBoard)
 *
 * Makes a play
 */
make_play(c, Player, Board, NewBoard) :-
    pc_move(_, _, _, _, Board, Player, NewBoard),
    computer_delay(Delay),
    sleep(Delay).

make_play(h, Player, Board, NewBoard) :-
    repeat,
    nl,
    format("Choose one of the pieces in the outer ring.~n", []),
    format("X: ", []),
    input_play(X),
    format("Y: ", []),
    input_play(Y),
    is_valid_play(X, Y, Board, Player),
    move(X, Y, Board, Player, NewBoard).

/**
 * choose_move(-X, -Y, -MoveX, -MoveY)
 *
 * Chooses a random play and a move to the computer
 */
choose_move(X, Y, MoveX, MoveY) :-
    random(0, 5, Y),
    ((Y > 0, Y < 4) -> (random(0, 2, R), ((R = 1) -> X is 4; X is 0)); random(0, 5, X)),
    edge_cases_pc_move(X, Y, MoveX, MoveY),
    normal_pc_moves(X, Y, MoveX, MoveY).

/**
 * edge_cases_pc_move(+X, +Y, -MoveX, -MoveY)
 *
 * Creates a pc random Move, after receiving a valid (edge) play
 */
edge_cases_pc_move(X, Y, MoveX, MoveY) :-
    ((((X = 0), (Y = 0)); ((X = 4), (Y = 4)) ) -> valid_pc_edge1(X, Y, MoveX, MoveY); true),
    ((((X = 4), (Y = 0)); ((X = 0), (Y = 4)) ) -> valid_pc_edge2(X, Y, MoveX, MoveY); true).

/**
 * valid_pc_edge1/2(_, _, +MoveX, +MoveY)
 *
 * Validates an edge pc move
 */
valid_pc_edge1(_, _, MoveX, MoveY) :-
    random(0, 2, Rand),
    ((Rand = 0) -> (MoveX is 0, MoveY is 4); true),
    ((Rand = 1) -> (MoveX is 4, MoveY is 0); true).

valid_pc_edge2(_, _, MoveX, MoveY) :-
    random(0, 2, Rand),
    ((Rand = 0) -> (MoveX is 4, MoveY is 4); true),
    ((Rand = 1) -> (MoveX is 0, MoveY is 0); true).

/**
 * normal_pc_moves(+X, +Y, +MoveX, +MoveY)
 *
 * Validates a non edge pc move
 */
normal_pc_moves(X, Y, MoveX, MoveY) :-
    (((X = 0), (Y < 4), (Y > 1)) -> valid_pc_move_l(X, Y, MoveX, MoveY); true),
    (((X = 4), (Y < 4), (Y > 1)) -> valid_pc_move_r(X, Y, MoveX, MoveY); true),
    (((Y = 0), (X < 4), (X > 1)) -> valid_pc_move_t(X, Y, MoveX, MoveY); true),
    (((Y = 4), (X < 4), (X > 1)) -> valid_pc_move_b(X, Y, MoveX, MoveY); true).

valid_pc_move_l(_, Y, MoveX, MoveY) :-
    random(0, 3, Rand),
    ((Rand = 0) -> (MoveX is 0, MoveY is 0); true),
    ((Rand = 1) -> (MoveX is 0, MoveY is 4); true),
    ((Rand = 2) -> (MoveX is 4, MoveY is Y); true).

valid_pc_move_r(_, Y, MoveX, MoveY) :-
    random(0, 3, Rand),
    ((Rand = 0) -> (MoveX is 4, MoveY is 0); true),
    ((Rand = 1) -> (MoveX is 4, MoveY is 4); true),
    ((Rand = 2) -> (MoveX is 0, MoveY is Y); true).

valid_pc_move_t(X, _, MoveX, MoveY) :-
    random(0, 3, Rand),
    ((Rand = 0) -> (MoveX is 0, MoveY is 0); true),
    ((Rand = 1) -> (MoveX is 4, MoveY is 0); true),
    ((Rand = 2) -> (MoveX is X, MoveY is 4); true).

valid_pc_move_b(X, _, MoveX, MoveY) :-
    random(0, 3, Rand),
    ((Rand = 0) -> (MoveX is X, MoveY is 0); true),
    ((Rand = 1) -> (MoveX is 0, MoveY is 4); true),
    ((Rand = 2) -> (MoveX is 4, MoveY is 4); true).

/**
 * move(+X, +Y, +Board, +Player, -NewBoard)
 *
 * Makes a human move
 */
move(X, Y, Board, Player, NewBoard) :-
    repeat,
    nl,
    format("Now input your move", []), nl,
    format("X: ", []),
    input_play(MoveX),
    format("Y: ", []),
    input_play(MoveY),
    is_valid_move(X, Y, MoveX, MoveY),
    make_move(X, Y, MoveX, MoveY, Board, Player, NewBoard).

/**
 * pc_move(_, _, _, _, +Board, +Player, -NewBoard)
 *
 * Makes a pc move
 */
pc_move(X, Y, MoveX, MoveY, Board, Player, NewBoard) :-
    repeat,
    choose_move(X, Y, MoveX, MoveY),
    is_valid_play(X, Y, Board, Player),
    is_valid_move(X, Y, MoveX, MoveY),
    nl,
    format("Play -> X: ~w  |  Y: ~w~n", [X, Y]), nl,
    format("Move -> X: ~w  |  Y: ~w~n", [MoveX, MoveY]), nl,
    make_move(X, Y, MoveX, MoveY, Board, Player, NewBoard).

/**
 * input_play(-Play)
 *
 * Reads a play from input and checks for quit
 */
input_play(Play) :-
    read_input(Play),
    is_quit(Play).

/**
 * is_valid_play(+X, +Y, +Board, +Player)
 *
 * Checks if a play is valid or not
 */
is_valid_play(X, Y, Board, Player) :-
    is_valid_index(X, Y),
    is_in_cell(X, Y, Board, Player).

/**
 * is_valid_play(+X, +Y, +Board, +Player)
 *
 * Checks if a a inputted play is valid (only validates the coordinates)
 */
is_valid_index(X, Y) :-
    ((Y = 0; Y = 4), (X < 5, X>=0));
    ((X = 0; X = 4), (Y < 5, Y>=0)).

/**
 * is_in_cell(+X, +Y, +Board, +Player)
 *
 * Checks if a a inputted play is valid
 * (only validates if the symbol corresponds to the player playing)
 */
is_in_cell(X, Y, Board, Player) :-
    nth0(Y, Board, List),
    nth0(X, List, Elem),
    (is_empty(Elem); is_symbol(Elem, Player)).

/**
 * is_empty(+Elem)
 *
 * Checks if an Element is empty
 */
is_empty(Elem) :- Elem = empty.

/**
 * is_symbol(+Elem, +Player)
 *
 * Checks if an Element is equal to the player's symbol
 */
is_symbol(Elem, Player) :- player_symbol(Player, S), Elem = S.

/**
 * is_valid_move(+X, +Y, +MoveX, +MoveY)
 *
 * Checks if an human move is a valid one,
 * by going through all the plays coordinates possible cases.
 *
 * Edge moves only have two possibilities, while
 * the rest of the moves have three.
 */
is_valid_move(X, Y, MoveX, MoveY) :-
    \+(((X = MoveX), (Y = MoveY))),
    (
    is_top_left_corner(X, Y, MoveX, MoveY);
    is_top_right_corner(X, Y, MoveX, MoveY);
    is_bot_left_corner(X, Y, MoveX, MoveY);
    is_bot_right_corner(X, Y, MoveX, MoveY);
    is_top_lateral(X, Y, MoveX, MoveY);
    is_bot_lateral(X, Y, MoveX, MoveY);
    is_right_lateral(X, Y, MoveX, MoveY);
    is_left_lateral(X, Y, MoveX, MoveY)
    ).

is_top_left_corner(X, Y, MoveX, MoveY) :-
    (X = 0; Y = 0),
    ((MoveX = 0, MoveY = 4); (MoveX = 4, MoveY = 0)).

is_top_right_corner(X, Y, MoveX, MoveY) :-
    (X = 4; Y = 0),
    ((MoveX = 0, MoveY = 0); (MoveX = 4, MoveY = 4)).

is_bot_left_corner(X, Y, MoveX, MoveY) :-
    (X = 0; Y = 4),
    ((MoveX = 0, MoveY = 0); (MoveX = 4, MoveY = 4)).

is_bot_right_corner(X, Y, MoveX, MoveY) :-
    (X = 4; Y = 4),
    ((MoveX = 4, MoveY = 0); (MoveX = 0, MoveY = 4)).

is_top_lateral(X, Y, MoveX, MoveY) :-
    (X > 0, X < 4, Y = 0),
    ((MoveX = X, MoveY = 4);
    (MoveX = 0, MoveY = Y);
    (MoveX = 4, MoveY = Y)).

is_bot_lateral(X, Y, MoveX, MoveY) :-
    (X > 0, X < 4, Y = 4),
    ((MoveX = X, MoveY = 0);
    (MoveX = 0, MoveY = Y);
    (MoveX = 4, MoveY = Y)).

is_right_lateral(X, Y, MoveX, MoveY) :-
    (Y > 0, Y < 4, X = 4),
    ((MoveX = 0, MoveY = Y);
    (MoveX = X, MoveY = 0);
    (MoveX = X, MoveY = 4)).

is_left_lateral(X, Y, MoveX, MoveY) :-
    (Y > 0, Y < 4, X = 0),
    ((MoveX = 4, MoveY = Y);
    (MoveX = X, MoveY = 0);
    (MoveX = X, MoveY = 4)).

/**
 * make_move(+X, +Y, +MoveX, +MoveY, +Board, +Player, -NewBoard)
 *
 * Makes an human move, by checking where the move is being made
 * and redirecting to what the move is going to be (the move outcome
 * depends on where the move is being made).
 */
make_move(X, Y, MoveX, MoveY, Board, Player, NewBoard) :-
    ((Y = MoveY) -> make_move_row(X, Y, MoveX, MoveY, Board, Player, NewBoard);
    make_move_col(X, Y, MoveX, MoveY, Board, Player, NewBoard)).

/*
 * make_move_row(0,+Y,_, _, +Board, +Player, +NewBoard)
 *
 * Function to make a move in a row, if the player wants to move to a spot where MoveX is 0. If so, we get the row we want,
 * and then execute the move by removing the row head, and afterwards appending it in the tail of the row.
*/
make_move_row(0, Y, _, _, Board, Player, NewBoard) :-
    nth0(Y, Board, [_|T]),
    player_symbol(Player, Flipped), %flipped only needed for the first time (else irrelevant)
    append(T, [Flipped], Row),
    nth0(Y, TempBoard, Row, Board),
    Index is Y + 1,
    nth0(Index, TempBoard, _, NewBoard).

/*
 * make_move_row(4,+Y,_, _, +Board, +Player, +NewBoard)
 *
 * Function to make a move in a row, if the player wants to move to a spot where MoveX is 0. If so, we get the row we want,
 * and then execute the move by removing last element in the row, and afterwards inserting it in the head of the row.
*/
make_move_row(4, Y, _, _, Board, Player, NewBoard) :-
    nth0(Y, Board, List),
    nth0(4, List,_, NewList), %delete last
    player_symbol(Player, Flipped), %flipped only needed for the first time (else irrelevant)
    nth0(Y, TempBoard, [Flipped|NewList], Board),
    Index is Y + 1,
    nth0(Index, TempBoard, _, NewBoard).

/*
 * make_move_row(+X,+Y,4, _, +Board, +Player, -NewBoard)
 *
 * Function to make a move in a row, if the player wants to move to a spot where MoveX is 0. If so, we get the row we want,
 * and then execute the move by removing the element we picked to move, and afterwards inserting it in the desired position.
 * In this case appending it in the tail of the row.
*/
make_move_row(X, Y, 4, _, Board, Player, NewBoard) :-
    nth0(Y, Board, List),
    nth0(X, List, _, NewList), %delete elem
    player_symbol(Player, Flipped), %flipped only needed for the first time (else irrelevant)
    append(NewList, [Flipped], Row),
    nth0(Y, TempBoard, Row, Board),
    Index is Y + 1,
    nth0(Index, TempBoard, _, NewBoard).

/*
 * make_move_row(+X,+Y,0, _, +Board, +Player, -NewBoard)
 *
 * Function to make a move in a row, if the player wants to move to a spot where MoveX is 0. If so, we get the row we want,
 * and then execute the move by removing the element we picked to move, and afterwards inserting it in the desired position.
 * In this case in the head of the Row.
*/
make_move_row(X, Y, 0, _, Board, Player, NewBoard) :-
    nth0(Y, Board, List),
    nth0(X, List,_, NewList), %delete elem
    player_symbol(Player, Flipped), %flipped only needed for the first time (else irrelevant)
    nth0(Y, TempBoard, [Flipped|NewList], Board),
    Index is Y + 1,
    nth0(Index, TempBoard, _, NewBoard).

/*
 * make_move_col(+X,+Y,+MoveX, +MoveY, +Board, +Player, +NewBoard)
 *
 * Function to make a move in a column by transposing the matrix, and executing the function to making a move in a row
*/
make_move_col(X, Y, MoveX, MoveY, Board, Player, NewBoard) :-
    transpose(Board, Trans),
    make_move_row(Y, X, MoveY, MoveX, Trans, Player, Final), nl,
    transpose(Final, NewBoard).

/*
 * game_over(+Board, +Player1, +Player2)
 *
 * Function to check wheter or not a player has won the game. If so, end the game and display a message
 */
game_over(Board, Player1, Player2) :-
    (win(Board, 0);
    win(Board, 1)),
    nl,
    format("GAME OVER~n", []), nl,
    (win(Board, 0) -> format('~w has won!~n', [Player1]); format("~w has won!~n", [Player2])),
    nl,
    format("Input anything to go back to the menu~n", []),
    read_input(_).


/**
 * win(+Board, +Player)
 *
 * Function to check wheter or not the player with Symbol won
 */
win(Board, Player) :-
    player_symbol(Player, Symbol),
    (check_win_rows(Board, Symbol);
    check_win_cols(Board, Symbol);
    check_win_diagonals(Board, Symbol)).

/**
 * check_win_rows(+Row, +Symbol)
 *
 * Function to check wheter or not the player with Symbol won, by having 5 pieces in a board row
 */
check_win_rows(Board, Symbol) :-
    member(Row, Board),
    \+check_win_row(Row, Symbol).

/**
 * check_win_cols(+Row, +Symbol)
 *
 * Function to check wheter or not the player with Symbol won, by having 5 pieces in a board columns
 */
check_win_cols(Board, Symbol) :-
    transpose(Board, Trans),
    member(Row, Trans),
    \+check_win_row(Row, Symbol).

/**
 * check_win_row(+Row, +Symbol)
 *
 * Auxiliary function to check wheter or not the player with Symbol won, by having 5 pieces in a board row. If the player won
 *it gives no, otherwise yes.
 */
%gives no if all the same (win), else gives yes
check_win_row(Row, Symbol) :-
    member(X, Row),
    X \= Symbol.


/**
 * check_win_diagonals(+Board, +Symbol)
 *
 * Function to check wheter or not the player with Symbol won, by having 5 pieces in the board diagonal
*/
check_win_diagonals(Board, Symbol) :-
    create_list_from_diagonal1(Board, Symbol, 0);
    create_list_from_diagonal2(Board, Symbol, 4).

/**
 * create_list_from_diagonal1(+Board, +PlayerSymbol, +Index)
 *
 * Auxiliary function to check the board diagonal for a win, (x,y) = (0,0) -> (4,4)
 */
create_list_from_diagonal1([], _, _).
create_list_from_diagonal1([H|T], Symbol, Index) :-
    nth0(Index, H, X),
    NewIndex is Index+1,
    X = Symbol,
    create_list_from_diagonal1(T, Symbol, NewIndex).

/**
 * create_list_from_diagonal2(+Board, +PlayerSymbol, +Index)
 *
 * Auxiliary function to check the board diagonal for a win (x,y) = (4,0) -> (0,4)
 */
create_list_from_diagonal2([], _, _).
create_list_from_diagonal2([H|T], Symbol, Index) :-
    nth0(Index, H, X),
    NewIndex is Index-1,
    X = Symbol,
    create_list_from_diagonal2(T, Symbol, NewIndex).
