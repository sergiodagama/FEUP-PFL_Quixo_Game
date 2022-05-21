/**
 * This module (user_interface.pl) contains the program 'views'
 */

/**
 * clear_screen()
 *
 * Clears the screen
 */
clear_screen :- write('\33\[2J').

/**
 * symbol(+SymbolName, -SymbolView)
 *
 * Board Symbols
 */
symbol(empty, S) :- S='-'.
symbol(cross, S) :- S='X'.
symbol(nought, S) :- S='O'.

/**
 * player_symbol(+SymbolName, -SymbolView)
 *
 * Player's Symbols
 */
player_symbol(0, Symbol) :- Symbol = cross.
player_symbol(1, Symbol) :- Symbol = nought.

/* Symbol Board Format helper functions */

/**
 *  white_char(+Char, +Padding)
 *
 * Function used to write ' ' in the console with a padding associated to it
 */
white_char(_, 0).
white_char(S, N):-
    N > 0,
    NewN is N - 1,
    write(S),
    white_char(S, NewN).

/**
 * print_symbol(+String, +Padding)
 *
 * Function used to write a board symbol in the board padded with ' '
 */
print_symbol(String, Padding):-
    white_char(' ', Padding),
    write(String),
    white_char(' ', Padding).

/* Board Header, Footer and Rows */

/**
 * print_header()
 * Function do display the board header to ease inputs
 */
print_header :-
    nl,
    write('   | 0 | 1 | 2 | 3 | 4 |\n'),
    write('---|---|---|---|---|---|\n').

/**
 * print_footer()
 * Function do display the board footer to see where the board ends
 */
print_footer :-
    write('---|---|---|---|---|---|\n\n\n').

/**
 * print_sep()
 * Function  to ease inputs
 */
print_sep :-
    write('---|---|---|---|---|---|\n').

/**
 * print_row(+Row)
 *
 * Function to print a board row to the console, with row value
 */
print_row([]) :- nl.
print_row([H|T]):-
    symbol(H, S),
    print_symbol(S, 1),
    write('|'),
    print_row(T).

/**
 * print_board(+Board, +RowIndex)
 *
 * Function to print the board in the console
 */
print_board([],_).
print_board([H|T], Id):-
    NewId is Id+1,
    print_symbol(Id,1),
    write('|'),
    print_row(H),
    print_sep,
    print_board(T, NewId).

/**
 * turn_player(+Player)
 *
 * Game Player's Turn View
 */
turn_player(Player):-
    write('Player Turn: '),
    write(Player),
    nl.

/**
 * display_game(+Board)
 *
 * Game Board View
 */
display_game(Board):-
    clear_screen,
    print_header,
    print_board(Board,0),
    nl.

/**
 * display_menu()
 *
 * Main Menu View
 */
display_menu :-
    clear_screen,
    nl,
    format("QUIXO GAME~n", []), nl,
    format("1. Play~n", []),
    format("2. Instructions~n", []),
    format("3. Quit~n", []),
    nl.

/**
 * display_game_modes()
 *
 * Game modes menu View
 */
display_game_modes :-
    clear_screen,
    nl,
    format("GAME MODES~n", []), nl,
    format("1. Two Humans~n", []),
    format("2. Human vs Computer~n", []),
    format("3. Computer vs Human~n", []),
    format("4. Two Computers~n", []),
    format("5. Back~n", []),
    nl.

/**
 * display_instructions()
 *
 * Game Instructions View
 */
display_instructions :-
    clear_screen,
    nl,
    format("Instructions~n", []), nl,
    format("On a turn, the active player takes a cube that is blank or bearing his symbol from the outer ring of the grid, ", []), nl,
    format("rotates it so that it shows his symbol (if needed), then adds it to the grid by pushing it into one of the rows", []), nl,
    format("from which it was removed. Thus, a few pieces of the grid change places each turn, and the cubes slowly go from", []), nl,
    format("blank to crosses and circles. Play continues until someone forms an orthogonal or diagonal line of five cubes", []), nl,
    format("bearing his symbol, with this person winning the game.", []), nl, nl,
    format("ENJOY THE GAME~n", []), nl,
    format("Input anything to go back to the menu~n", []).

/**
 * display_computer_dificulty()
 *
 * Game Ai dificulty menu view
 */
display_computer_dificulty :-
    clear_screen,
    nl,
    format("GAME AI LEVEL~n", []), nl,
    format("1. Easy~n", []),
    format("2. Medium~n", []),
    format("3. Hard~n", []),
    format("4. Back~n", []),
    nl.
