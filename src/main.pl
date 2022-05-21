/**
 * This module (main.pl) contains the program entry point,
 * as well as all the game menu's logics, and user input
 */
:-consult('logic.pl').

/**
 * menu()
 *
 * Main Menu logic
 */
menu :-
    repeat,
    display_menu,
    read_input(Opt),
    menu_options(Opt).

/**
 * menu(+Option)
 *
 * Main Menu Options redirection
 */
menu_options(1) :-
    repeat,
    display_game_modes,
    read_input(Opt),
    game_modes(Opt).
menu_options(2) :-
    display_instructions,
    read(_),
    menu.
menu_options(3) :-
    abort.

/**
 * game_modes(+Option)
 *
 * Game modes menu options redirection
 */
game_modes(1) :-
    initial_board(Board),
    display_game(Board),
    turn_player(player1_cross),
    game(hh, _, Board).
game_modes(2) :-
    display_computer_dificulty,
    read_input(Opt),
    choose_dificulty(hc, Opt, human_cross).
game_modes(3) :-
    display_computer_dificulty,
    read_input(Opt),
    choose_dificulty(ch, Opt, computer_cross).
game_modes(4) :-
    display_computer_dificulty,
    read_input(Opt),
    choose_dificulty(cc, Opt, computer1_cross).
game_modes(5) :-
    menu.

/**
 * choose_dificulty(+Mode, +Dificulty, +PlayerName)
 *
 * Ai dificulty options redirection
 */
choose_dificulty(Mode, 1, PlayerName) :-
    initial_board(Board),
    display_game(Board),
    turn_player(PlayerName),
    game(Mode, 1, Board).
choose_dificulty(_, 2) :-
    menu.
choose_dificulty(_, 3) :-
    menu.
choose_dificulty(_, 4) :-
    menu.

/**
 * read_input(-Input)
 *
 * Reads an input from user
 */
read_input(Input) :-
    read(Input).

/**
 * is_quit(+Input)
 *
 * Checks if user wants to quit
 */
is_quit(Input) :- ((Input = e) -> menu; true).

/**
 * play()
 *
 * The start of the program (starts with menu)
 */
play :- menu.
