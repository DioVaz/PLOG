estado_inicial([[[],[],[],[],[],[],[],[]],
							 [[],[1,1],[1,1],[1,1],[1,1],[1,1],[1,1],[]],
							 [[],[1],[1],[1],[1],[1],[1],[]],
							 [[],[],[],[],[],[],[],[]],
							 [[],[],[],[],[],[],[],[]],
							 [[],[2],[2],[2],[2],[2],[2],[]],
							 [[],[2,2],[2,2],[2,2],[2,2],[2,2],[2,2],[]],
							 [[],[],[],[],[],[],[],[]]]).

estado_auxiliar([[[7],[7],[7],[7],[7],[7],[7],[7]],
							 	 [[7],[6],[6],[6],[6],[6],[6],[7]],
							 	 [[7],[6],[5],[5],[5],[5],[6],[7]],
							 	 [[7],[6],[5],[4],[4],[5],[6],[7]],
							 	 [[7],[6],[5],[4],[4],[5],[6],[7]],
							 	 [[7],[6],[5],[5],[5],[5],[6],[7]],
							 	 [[7],[6],[6],[6],[6],[6],[6],[7]],
							 	 [[7],[7],[7],[7],[7],[7],[7],[7]]]).

lista_jogadas([['T',0,0,0,0]]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                    Predicados principais do jogo                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inicio:-
		menu(0).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                    Menus e apresentação                  					  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

menu(0):-
      menu(0, []).
menu(0, []):-
      estado_inicial(Tab),
			estado_auxiliar(Sizes),
      menu(0, Tab, Sizes).
menu(0, Tab, Sizes) :-
      write('Welcome to SPLAY Game!'), nl, nl,
      write('* Menu *'),nl,
      write('1 - Play : 2 Players'),nl,
			write('2 - Play : Single Player'),nl,
      write('3 - Instructions'), nl,
      write('4 - Exit'), nl, nl,
      write('Your option: '),
      read(Option),
      valid_menu_option(Option, 4, ValidOption),!,
      menu(ValidOption, Tab, Sizes).
menu(4, _, _).
menu(1, Tab, Sizes):-
      nl, nl,
      write('* Player 1 vs. Player 2'), nl,
      pick_first_player(StartingPlayer), nl,!,
      game_cycle(StartingPlayer, Tab, 1, 0, Sizes),
      !.
menu(2, Tab, Sizes):-
			nl, nl,
			write('* Player 2 vs. Computer'), nl,
			pick_first_player(StartingPlayer), nl,!,
			NewStartingPlayer is StartingPlayer + 1,
			game_cycle(NewStartingPlayer, Tab, 2, 0, Sizes),
			!.
menu(3, Tab, Sizes):-
	write('Instructions on how to play the game'),nl,nl,
	menu(0, Tab, Sizes).

% Checks if the option is valid
% valid_menu_option(Option, ValidOption)
valid_menu_option(Option, NumberOfOptions, ValidOption):-
      Option>0, Option=<NumberOfOptions,
      	ValidOption=Option;
      write('Invalid option. Please choose a number between 1 and '), write(NumberOfOptions), write(' : '),
      read(NewOption),
      valid_menu_option(NewOption, NumberOfOptions, ValidOption).

% Asks the user who should begin to play
% pick_first_player(-PlayerId)
pick_first_player(PlayerId):-
      nl,
      write('You need to pick a player to begin. Throw a coin!'), nl,
      write('Please choose the player that will begin (1 or 2): '),
      read(Id),
      PlayerId is Id.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                    Visualização de estado do jogo                    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

visualiza_estado(Tab):-
	nl, write('     0         1        2        3        4        5        6        7'), nl, nl,
	mostra_linhas(0,Tab),
	write('     0         1        2        3        4        5        6        7'), nl,!.

mostra_linhas(_,[]).
mostra_linhas(N,[Lin|Resto]):-
	write(N), write(' '), mostra_linha(Lin), write(' '), write(N), nl, nl,
	N2 is N+1,
	mostra_linhas(N2, Resto).

mostra_linha([]).
mostra_linha([El|Resto]):-
	escreve(El,7), write('|'),
	mostra_linha(Resto).

escreve([],0):-
	write(' ').
escreve([],N):-
  write(' '),
	N1 is N - 1,
	escreve([],N1).
escreve([El|Rest],N):-
	write(El),
	N1 is N - 1,
	escreve(Rest, N1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                    Lógica de jogo                    								%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
game_cycle(3,Tab,Mode,0, SizesTab):-
				computer_to_move(3,Tab,NewTab,Winner,SizesTab),
				game_cycle(2,NewTab,Mode,Winner,SizesTab).
game_cycle(Current_Player,Tab,Mode,0, SizesTab):-
				Current_Player=<2,
				play(Current_Player,Tab,NewTab,Winner,SizesTab),
				switch_player(Current_Player,Mode,Next_Player),
				game_cycle(Next_Player,NewTab,Mode,Winner,SizesTab).
game_cycle(_,_,_,1,_):-
	write('Player 1 Won the game!!!!!!!!!!!!!').
game_cycle(_,_,_,2,_):-
	write('Player 2 Won the game!!!!!!!!!!!!!').
game_cycle(_,_,_,3,_):-
	write('Computer Won the game!!!!!!!!!!!!!').


switch_player(1, 1, Next_Player):- Next_Player=2.
switch_player(2, 1, Next_Player):- Next_Player=1.
switch_player(2, 2, Next_Player):- Next_Player=3.
switch_player(3, 2, Next_Player):- Next_Player=2.
switch_player(3, 3, Next_Player):- Next_Player=4.
switch_player(4, 3, Next_Player):- Next_Player=3.

play(Current_Player,Tab,NewTab,Winner,SizesTab):-
	visualiza_estado(Tab),
	nl,write('It is player '), write(Current_Player), write(' turn!'),nl,
	write('Type of play: STEP - 1    SPLAY - 2  '), nl,
	read(Type),
	write('Row of origin: '), nl,
	read(Row),
	write('Column of origin'),nl,
	read(Column),
	write('Row of destination: '),nl,
	read(NewRow),
	write('Column of destination: '),nl,
	read(NewColumn),
	validate_out_of_bonds(Tab,Current_Player,NewRow,NewColumn,SizesTab),
	check_top_piece(Tab,Row,Column,Current_Player,SizesTab),
	make_play(Type,Row,Column,NewRow,NewColumn,Tab,AuxTab,SizesTab,Current_Player),
	capture(AuxTab,NewTab),
	check_winner(NewTab,Current_Player,Winner),
	!.

make_play(Type,Row,Column,NewRow,NewColumn,Tab,NewTab,SizesTab,Player):-
	Type == 2,
			splay_type(Row,Column,NewRow,NewColumn,Type2),
			splay(Type2,Row,Column,Tab,NewTab,SizesTab,Player,Tab);
			validate_step(Row,Column,NewRow,NewColumn,Player,Tab,SizesTab),
			step(Row,Column,NewRow,NewColumn,Tab,NewTab,SizesTab,Player).

splay_type(Row,Column,NewRow,NewColumn,Type2):-
	NewColumn<Column, NewRow=:=Row,
		Type2 = 0;
	NewColumn=:=Column, NewRow>Row,
		Type2 = 1;
	NewColumn>Column, NewRow=:=Row,
		Type2 = 2;
	NewColumn=:=Column, NewRow<Row,
		Type2 = 3;
	NewColumn<Column, NewRow>Row,
		Type2 = 4;
	NewColumn>Column, NewRow>Row,
		Type2 = 5;
	NewColumn>Column, NewRow<Row,
		Type2 = 6;
	NewColumn<Column, NewRow<Row,
		Type2 = 7;
	write('Please pick appropriate coordinates'),nl.

splay(0,Row,Column,Tab,AuxTab,SizesTab,Player,InitialTab):-
	get_piece(Tab,Row,Column,Element),
	get_from_board(Tab,Column,LinhaInicial),
	replace(LinhaInicial,Row,[],EditedLinhaInicial),
	spread_element(0,Element,Row,Column,Tab,NewTab,SizesTab,Player,InitialTab),
	replace(NewTab,Column,EditedLinhaInicial,AuxTab).

splay(1,Row,Column,Tab,AuxTab,SizesTab,Player,InitialTab):-
	get_piece(Tab,Row,Column,Element),
	spread_element(1,Element,Row,Column,Tab,NewTab,SizesTab,Player,InitialTab),
	get_from_board(NewTab,Column,LinhaInicial),
	replace(LinhaInicial,Row,[],EditedLinhaInicial),
	replace(NewTab,Column,EditedLinhaInicial,AuxTab).

splay(2,Row,Column,Tab,AuxTab,SizesTab,Player,InitialTab):-
	get_piece(Tab,Row,Column,Element),
	get_from_board(Tab,Column,LinhaInicial),
	replace(LinhaInicial,Row,[],EditedLinhaInicial),
	spread_element(2,Element,Row,Column,Tab,NewTab,SizesTab,Player,InitialTab),
	replace(NewTab,Column,EditedLinhaInicial,AuxTab).

splay(3,Row,Column,Tab,AuxTab,SizesTab,Player,InitialTab):-
	get_piece(Tab,Row,Column,Element),
	spread_element(3,Element,Row,Column,Tab,NewTab,SizesTab,Player,InitialTab),
	get_from_board(NewTab,Column,LinhaInicial),
	replace(LinhaInicial,Row,[],EditedLinhaInicial),
	replace(NewTab,Column,EditedLinhaInicial,AuxTab).

splay(4,Row,Column,Tab,AuxTab,SizesTab,Player,InitialTab):-
	get_piece(Tab,Row,Column,Element),
	get_from_board(Tab,Column,LinhaInicial),
	replace(LinhaInicial,Row,[],EditedLinhaInicial),
	spread_element(4,Element,Row,Column,Tab,NewTab,SizesTab,Player,InitialTab),
	replace(NewTab,Column,EditedLinhaInicial,AuxTab).

splay(5,Row,Column,Tab,AuxTab,SizesTab,Player,InitialTab):-
	get_piece(Tab,Row,Column,Element),
	get_from_board(Tab,Column,LinhaInicial),
	replace(LinhaInicial,Row,[],EditedLinhaInicial),
	spread_element(5,Element,Row,Column,Tab,NewTab,SizesTab,Player,InitialTab),
	replace(NewTab,Column,EditedLinhaInicial,AuxTab).

splay(6,Row,Column,Tab,AuxTab,SizesTab,Player,InitialTab):-
	get_piece(Tab,Row,Column,Element),
	get_from_board(Tab,Column,LinhaInicial),
	replace(LinhaInicial,Row,[],EditedLinhaInicial),
	spread_element(6,Element,Row,Column,Tab,NewTab,SizesTab,Player,InitialTab),
	replace(NewTab,Column,EditedLinhaInicial,AuxTab).

splay(7,Row,Column,Tab,AuxTab,SizesTab,Player,InitialTab):-
	get_piece(Tab,Row,Column,Element),
	get_from_board(Tab,Column,LinhaInicial),
	replace(LinhaInicial,Row,[],EditedLinhaInicial),
	spread_element(7,Element,Row,Column,Tab,NewTab,SizesTab,Player,InitialTab),
	replace(NewTab,Column,EditedLinhaInicial,AuxTab).

spread_element(0,[],_Row,_Column,Tab,Tab,_SizesTab,_Player,_InitialTab).
spread_element(0,Element,Row,Column,Tab,NewTab,SizesTab,Player,InitialTab):-
	Element = [First|Rest],
	Column2 is Column - 1,
	get_piece(Tab,Row,Column2,Element2),
	append([First],Element2,Element3),
	check_max_size(Element3,Row,Column2,SizesTab,InitialTab,Player),
	get_from_board(Tab,Column2,LinhaFinal),
	replace(LinhaFinal,Row,Element3,EditedLinhaFinal),
	replace(Tab,Column2,EditedLinhaFinal,NewTab2),
	spread_element(0,Rest,Row,Column2,NewTab2,NewTab,SizesTab,Player,InitialTab).

spread_element(1,[],_Row,_Column,Tab,Tab,_SizesTab,_Player,_InitialTab).
spread_element(1,Element,Row,Column,Tab,NewTab,SizesTab,Player,InitialTab):-
	Element = [First|Rest],
	Row2 is Row + 1,
	get_piece(Tab,Row2,Column,Element2),
	append([First],Element2,Element3),
	check_max_size(Element3,Row2,Column,SizesTab,InitialTab,Player),
	get_from_board(Tab,Column,LinhaFinal),
	replace(LinhaFinal,Row2,Element3,EditedLinhaFinal),
	replace(Tab,Column,EditedLinhaFinal,NewTab2),
	spread_element(1,Rest,Row2,Column,NewTab2,NewTab,SizesTab,Player,InitialTab).

spread_element(2,[],_Row,_Column,Tab,Tab,_SizesTab,_Player,_InitialTab).
spread_element(2,Element,Row,Column,Tab,NewTab,SizesTab,Player,InitialTab):-
	Element = [First|Rest],
	Column2 is Column + 1,
	get_piece(Tab,Row,Column2,Element2),
	append([First],Element2,Element3),
	check_max_size(Element3,Row,Column2,SizesTab,InitialTab,Player),
	get_from_board(Tab,Column2,LinhaFinal),
	replace(LinhaFinal,Row,Element3,EditedLinhaFinal),
	replace(Tab,Column2,EditedLinhaFinal,NewTab2),
	spread_element(2,Rest,Row,Column2,NewTab2,NewTab,SizesTab,Player,InitialTab).

spread_element(3,[],_Row,_Column,Tab,Tab,_SizesTab,_Player,_InitialTab).
spread_element(3,Element,Row,Column,Tab,NewTab,SizesTab,Player,InitialTab):-
	Element = [First|Rest],
	Row2 is Row - 1,
	get_piece(Tab,Row2,Column,Element2),
	append([First],Element2,Element3),
	check_max_size(Element3,Row2,Column,SizesTab,InitialTab,Player),
	get_from_board(Tab,Column,LinhaFinal),
	replace(LinhaFinal,Row2,Element3,EditedLinhaFinal),
	replace(Tab,Column,EditedLinhaFinal,NewTab2),
	spread_element(3,Rest,Row2,Column,NewTab2,NewTab,SizesTab,Player,InitialTab).

spread_element(4,[],_Row,_Column,Tab,Tab,_SizesTab,_Player,_InitialTab).
spread_element(4,Element,Row,Column,Tab,NewTab,SizesTab,Player,InitialTab):-
	Element = [First|Rest],
	Row2 is Row + 1,
	Column2 is Column - 1,
	get_piece(Tab,Row2,Column2,Element2),
	append([First],Element2,Element3),
	check_max_size(Element3,Row2,Column2,SizesTab,InitialTab,Player),
	get_from_board(Tab,Column2,LinhaFinal),
	replace(LinhaFinal,Row2,Element3,EditedLinhaFinal),
	replace(Tab,Column2,EditedLinhaFinal,NewTab2),
	spread_element(4,Rest,Row2,Column2,NewTab2,NewTab,SizesTab,Player,InitialTab).

spread_element(5,[],_Row,_Column,Tab,Tab,_SizesTab,_Player,_InitialTab).
spread_element(5,Element,Row,Column,Tab,NewTab,SizesTab,Player,InitialTab):-
	Element = [First|Rest],
	Row2 is Row + 1,
	Column2 is Column + 1,
	get_piece(Tab,Row2,Column2,Element2),
	append([First],Element2,Element3),
	check_max_size(Element3,Row2,Column2,SizesTab,InitialTab,Player),
	get_from_board(Tab,Column2,LinhaFinal),
	replace(LinhaFinal,Row2,Element3,EditedLinhaFinal),
	replace(Tab,Column2,EditedLinhaFinal,NewTab2),
	spread_element(5,Rest,Row2,Column2,NewTab2,NewTab,SizesTab,Player,InitialTab).

spread_element(6,[],_Row,_Column,Tab,Tab,_SizesTab,_Player,_InitialTab).
spread_element(6,Element,Row,Column,Tab,NewTab,SizesTab,Player,InitialTab):-
	Element = [First|Rest],
	Row2 is Row - 1,
	Column2 is Column + 1,
	get_piece(Tab,Row2,Column2,Element2),
	append([First],Element2,Element3),
	check_max_size(Element3,Row2,Column2,SizesTab,InitialTab,Player),
	get_from_board(Tab,Column2,LinhaFinal),
	replace(LinhaFinal,Row2,Element3,EditedLinhaFinal),
	replace(Tab,Column2,EditedLinhaFinal,NewTab2),
	spread_element(6,Rest,Row2,Column2,NewTab2,NewTab,SizesTab,Player,InitialTab).

spread_element(7,[],_Row,_Column,Tab,Tab,_SizesTab,_Player,_InitialTab).
spread_element(7,Element,Row,Column,Tab,NewTab,SizesTab,Player,InitialTab):-
	Element = [First|Rest],
	Row2 is Row - 1,
	Column2 is Column - 1,
	get_piece(Tab,Row2,Column2,Element2),
	append([First],Element2,Element3),
	check_max_size(Element3,Row2,Column2,SizesTab,InitialTab,Player),
	get_from_board(Tab,Column2,LinhaFinal),
	replace(LinhaFinal,Row2,Element3,EditedLinhaFinal),
	replace(Tab,Column2,EditedLinhaFinal,NewTab2),
	spread_element(7,Rest,Row2,Column2,NewTab2,NewTab,SizesTab,Player,InitialTab).

step(Row,Column,NewRow,NewColumn,Tab,NewTab,SizesTab,Player):-
	get_piece(Tab,Row,Column,Element),
	get_piece(Tab,NewRow,NewColumn,Element2),
	set_piece(Row,Column,NewRow,NewColumn,Element,Element2,Tab,NewTab,SizesTab,Player).


set_piece(Row,Column,NewRow,NewColumn,Element,Element2,Tab,NewTab,SizesTab,Player):-
	append(Element,Element2,Element3),

	check_max_size(Element3,NewRow,NewColumn,SizesTab,Tab,Player),write('Step'),
	get_from_board(Tab,NewColumn,LinhaFinal),write('Step'),
	replace(LinhaFinal,Row,[],EditedLinhaFinal),write('Step'),
	replace(EditedLinhaFinal,NewRow,Element3,EditedLinhaFinal2),write('Step'),
	get_from_board(Tab,Column,LinhaInicial),write('Step'),
	replace(LinhaInicial,Row,[],EditedLinhaInicial),write('Step'),
	replace(Tab,Column,EditedLinhaInicial,AuxTab),write('Step'),
	replace(AuxTab,NewColumn,EditedLinhaFinal2,NewTab).


% Replaces the content at Index position in List with NewValue and returns the modified NewList
% replace(+List, +Index, +NewValue, -NewList)
replace([_|Tail], 0, NewValue, [NewValue|Tail]).
replace([Head|Tail], Index, NewValue, [Head|R]):-
        Index > 0, Index1 is Index-1,
        replace(Tail, Index1, NewValue, R).

% get_piece/4
% get an piece from board
get_piece(Tab, X, Y, Element) :-
  get_from_board(Tab, Y, Row),
  get_from_board(Row, X, Element).

% get_from_board/3
% get something from a certain position of the board
get_from_board([Head|_],0,Head).
get_from_board([_Head|Tail],Pos,Elem):-
  Pos \= 0,
  NewPos is Pos - 1,
  get_from_board(Tail,NewPos,Elem).



capture(Tab,NewTab):-
	get_piece(Tab, 0, 0, Element0),
	delMember(1,Element0,ElementFinal0),
	get_piece(Tab, 1, 0, Element1),
	delMember(1,Element1,ElementFinal1),
	get_piece(Tab, 2, 0, Element2),
	delMember(1,Element2,ElementFinal2),
	get_piece(Tab, 3, 0, Element3),
	delMember(1,Element3,ElementFinal3),
	get_piece(Tab, 4, 0, Element4),
	delMember(1,Element4,ElementFinal4),
	get_piece(Tab, 5, 0, Element5),
	delMember(1,Element5,ElementFinal5),
	get_piece(Tab, 6, 0, Element6),
	delMember(1,Element6,ElementFinal6),
	get_piece(Tab, 7, 0, Element7),
	delMember(1,Element7,ElementFinal7),
	get_from_board(Tab,0,LinhaBrancas),
	replace(LinhaBrancas,0,ElementFinal0,LinhaBrancasFinal0),
	replace(LinhaBrancasFinal0,1,ElementFinal1,LinhaBrancasFinal1),
	replace(LinhaBrancasFinal1,2,ElementFinal2,LinhaBrancasFinal2),
	replace(LinhaBrancasFinal2,3,ElementFinal3,LinhaBrancasFinal3),
	replace(LinhaBrancasFinal3,4,ElementFinal4,LinhaBrancasFinal4),
	replace(LinhaBrancasFinal4,5,ElementFinal5,LinhaBrancasFinal5),
	replace(LinhaBrancasFinal5,6,ElementFinal6,LinhaBrancasFinal6),
	replace(LinhaBrancasFinal6,7,ElementFinal7,LinhaBrancasFinal7),
	get_piece(Tab, 0, 7, ElementP0),
	delMember(2,ElementP0,ElementFinalP0),
	get_piece(Tab, 1, 7, ElementP1),
	delMember(2,ElementP1,ElementFinalP1),
	get_piece(Tab, 2, 7, ElementP2),
	delMember(2,ElementP2,ElementFinalP2),
	get_piece(Tab, 3, 7, ElementP3),
	delMember(2,ElementP3,ElementFinalP3),
	get_piece(Tab, 4, 7, ElementP4),
	delMember(2,ElementP4,ElementFinalP4),
	get_piece(Tab, 5, 7, ElementP5),
	delMember(2,ElementP5,ElementFinalP5),
	get_piece(Tab, 6, 7, ElementP6),
	delMember(2,ElementP6,ElementFinalP6),
	get_piece(Tab, 7, 7, ElementP7),
	delMember(2,ElementP7,ElementFinalP7),
	get_from_board(Tab,7,LinhaPretas),
	replace(LinhaPretas,0,ElementFinalP0,LinhaPretasFinal0),
	replace(LinhaPretasFinal0,1,ElementFinalP1,LinhaPretasFinal1),
	replace(LinhaPretasFinal1,2,ElementFinalP2,LinhaPretasFinal2),
	replace(LinhaPretasFinal2,3,ElementFinalP3,LinhaPretasFinal3),
	replace(LinhaPretasFinal3,4,ElementFinalP4,LinhaPretasFinal4),
	replace(LinhaPretasFinal4,5,ElementFinalP5,LinhaPretasFinal5),
	replace(LinhaPretasFinal5,6,ElementFinalP6,LinhaPretasFinal6),
	replace(LinhaPretasFinal6,7,ElementFinalP7,LinhaPretasFinal7),
	replace(Tab,0,LinhaBrancasFinal7,AuxTab),
	replace(AuxTab,7,LinhaPretasFinal7,NewTab).


delMember(_, [], []).
delMember(X, [X|Xs], Y) :-
    delMember(X, Xs, Y).
delMember(X, [T|Xs], [T|Y]) :-
    dif(X, T),
    delMember(X, Xs, Y).


check_winner(Tab,Player,Winner):-
	conta_pecas_tab(Tab,Player,Z),
	Z<10,
		Winner = Player;
	Winner = 0.


conta_pecas([],_X,0).
conta_pecas([X|T],X,Y):- conta_pecas(T,X,Z), Y is 1+Z.
conta_pecas([X1|T],X,Z):- X1\=X,conta_pecas(T,X,Z).

conta_pecas_linha([],_X,0).
conta_pecas_linha(Linha,X,W):-
	Linha = [First|Rest],
	conta_pecas(First,X,Z),
	conta_pecas_linha(Rest,X,W1),
	W is Z + W1.

conta_pecas_tab([],_X,0).
conta_pecas_tab(Tab,X,W):-
	Tab = [First|Rest],
	conta_pecas_linha(First,X,Z),
	conta_pecas_tab(Rest,X,W1),
	W is Z + W1.

check_top_piece(Tab,Row,Column,Player,SizesTab):-
	get_piece(Tab,Row,Column,Element),
	Element = [First|_Rest],
	Player == First,
			write('Player piece is on top of the stack'),nl;
			write('Please pick a cell with one of your pieces on top of the stack!!!'),nl,nl,!,
			game_cycle(Player,Tab,1,0,SizesTab).

validate_out_of_bonds(Tab,Player,NewRow,NewColumn,SizesTab):-
	NewRow>=0, NewRow=<7,
		NewColumn>=0, NewColumn=<7,
			write('Inside of the board'),nl;
			write('Please pick a destination cell inside the limits of the board'),nl,nl,!,
			game_cycle(Player,Tab,1,0,SizesTab).

check_max_size(Element,Row,Column,SizesTab,Tab,Player):-
write('Step'),
	get_piece(SizesTab,Row,Column,Element2),
	write('Step'),
	length(Element,X1),
	Element2 = [First|_Rest],
	X1=<First,
		write('Size is good'),nl;
	write('Your movement creates invalid stacks, pick a different move!'),nl,nl,!,
	game_cycle(Player,Tab,1,0,SizesTab).

validate_step(Row,Column,NewRow,NewColumn,Player,Tab,SizesTab):-
	Row2 = NewRow - Row,
	Column2 = NewColumn - Column,
	Row2>=0-1, Row2<2,
		Column2>=0-1, Column2<2,
			write('Valid step!'),nl;
		write('You can only move one cell when using the step movement!'),nl,nl,!,
		game_cycle(Player,Tab,1,0,SizesTab).

%validate_play(Type,Row,Column,NewRow,NewColumn,Tab):-
	%Type \= 'S',
	%Type \= 'P',
	%invalid_play.

%invalid_play:-
	%write('That play is not valid, please try again'),nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            	      Inteligencia Artificial           								%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

computer_to_move(Current_Player,Tab,NewTab,Winner,SizesTab):-
	visualiza_estado(Tab),
	write('Computer to move'),nl,nl,
	Tab1=Tab,
	find_moves(Tab, 1, Best,FSplay,SizesTab,0,Tab1),
	%pick_best_move(),
	NewTab=Tab,
	Winner=0.

find_moves([],_,_,_,_,_,_).
find_moves([Lin|Rest], Color, Best, FSplay, SizesTab,Row,Tab1):-
	NewRow is Row+1,
	find_moves_lin(Lin, Color, Best, NewBest, FSplay,Row,0,Tab1),
	find_moves(Rest, Color, NewBest, FSplay,SizesTab,NewRow,Tab1).

find_moves_lin([],_,_,_,_,_,_,_).
find_moves_lin([Cell|Rest], Color, Best, NewBest, FSplay,Row,Column,Tab1):-
	NewColumn is Column+1,
	Valid=0,
	check_top_pieceIA(Cell,Row,Column,Color,Valid,NewValid),
	write(NewValid),
	%check_splay
	%%conta_pecas(Cell, FSplay),
	valid_moves(Tab1,Row,Column,Color,SizesTab,NewValid, Best, NewBest,NewValid2),
	find_moves_lin(Rest, Color, Best, NewBest, FSplay,Row,NewColumn,Tab).

check_top_pieceIA(Element,Row,Column,Color,Valid,NewValid):-
	Element = [First|_Rest],
	Color == First,
	NewValid=2;
	NewValid=0,!.


valid_moves(_,_,_,_,_,0,_,_,_).
valid_moves(Tab,Row,Column,Color,SizesTab,Valid, Best, NewBest,NewValid):-
	check_steps(Tab,Cell,NewTab,Row,Column,Total,Novo_total,Best, New_best).
	%valid_moves().
%valid_moves(Valid,Tab, Color, nova_lista_pilhas, lista_jogadas,nova_lista_jogadas,total):-
	%check_splays(),
	%valid_moves().

check_steps(Tab,Cell,NewTab,Row,Column,Total,Novo_total,Best, New_best):-
	checksteps_aux(Cell,Row,Column,1,0,Tab,NewTab1,SizesTab,Total,Novo_total,Best, New_best1),
	checksteps_aux(Cell,Row,Column,0,1,Tab,NewTab2,SizesTab,Total,Novo_total,New_best1, New_best2),
	checksteps_aux(Cell,Row,Column,-1,0,Tab,NewTab3,SizesTab,Total,Novo_total,New_best2, New_best3),
	checksteps_aux(Cell,Row,Column,1,1,Tab,NewTab4,SizesTab,Total,Novo_total,New_best3, New_best4),
	checksteps_aux(Cell,Row,Column,-1,1,Tab,NewTab5,SizesTab,Total,Novo_total,New_best4, New_best5),
	checksteps_aux(Cell,Row,Column,1,0,Tab,NewTab6,SizesTab,Total,Novo_total,New_best5, New_best6),
	checksteps_aux(Cell,Row,Column,1,-1,Tab,NewTab7,SizesTab,Total,Novo_total,New_best6, New_best7),
	checksteps_aux(Cell,Row,Column,0,-1,Tab,NewTab8,SizesTab,Total,Novo_total,New_best7, New_best8),
	checksteps_aux(Cell,Row,Column,-1,-1,Tab,NewTab9,SizesTab,Total,Novo_total,New_best8, New_best9),
	New_Best=New_best9.

checksteps_aux(Cell,Row,Column,X,Y,Tab,NewTab,SizesTab,Total,Novo_total,Best, New_best):-
	NewRow is Row + Y,
	NewColumn is Column + X,
	validate_out_of_bondsIA(NewRow,NewColumn, Pow),
	dostep(Row,Column,NewRow,NewColumn,Tab,NewTab,SizesTab,1, Pow).

dostep(_,_,_,_,_,_,_,_,0).
dostep(Row,Column,NewRow,NewColumn,Tab,NewTab,SizesTab,Player, Pow):-
	step(Row,Column,NewRow,NewColumn,Tab,NewTab,SizesTab,Player),
	write('check'),
	addPlay(Cell,NewTab,'S',Row,Column,NewRow,NewColumn,Total,Novo_total,SizesTab,Best, New_best).

addPlay(Cell, NewTab,Type,Row,Column,NewRow,NewColumn,Total,Novo_total,SizesTab,Best, New_best):-
	check_max_sizeIA(Element,NewRow,NewColumn,SizesTab,Tab,Valid),
	Valid==1,
	addPlay_aux(NewTab,Type,Row,Column,NewRow,Total,Novo_total,Best, New_best).

addPlay_aux(Tab,Type,Row,Column,NewRow,Total,Novo_total,Best, New_best):-
	Novo_Total=Total+1,
	Forca is Total,
	%%calcula_forca(forca)
	Novo_Total<31,
	New_best =[Total,Type,Row,Column,NewRow];
	New_best=Best.

check_max_sizeIA(Row,Column,SizesTab,Tab,Valid):-
	get_piece(Tab,Row,Column,Element),
	get_piece(SizesTab,Row,Column,Element2),
	length(Element,X1),
	Element2 = [First|_Rest],
	X1=<First,
	Valid=1;
	Valid=0.

validate_out_of_bondsIA(NewRow,NewColumn,Pos):-
		NewRow>=0, NewRow=<7,
		NewColumn>=0, NewColumn=<7,
		Pos=1;
		Pos=0,!.
