%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Projeto 2 Magellan %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:-use_module(library(clpfd)).
:-use_module(library(lists)).

inicio(Vars):-
  write('                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,
  write('                    %%                          %%'),nl,
  write('                    %%     MAGELLAN PUZZLE      %%'),nl,
  write('                    %%                          %%'),nl,
  write('                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),
  magellan(Vars),nl,
  write('Correspondencias:'),nl,nl,
  write('1 - Branco.'),nl,
  write('2 - Azul.'),nl,
  write('3 - Verde.'),nl,
  write('4 - Preto.'),nl,
  write('5 - Vermelho.'),nl,
  write('6 - Amarelo.'),nl,nl.

%Predicado responsavel pela execução do programa, inclui as restrições relativas a células com cilindros visiveis dos dois lados do tabuleiro
magellan(Vars):-
  Vars=[A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16,A17,A18,A19,A20,A21,A22,A23,A24,A25,A26,A27,A28,A29,A30,A31,A32,A33,A34,A35,A36,A37,A38,A39,A40,A41,A42,A43,A44,A45,A46,A47,A48,A49,A50,A51,A52,A53,A54,A55,A56,A57,A58,A59,A60,A61,A62,A63,A64,A65,A66],
  domain(Vars,1,6),
  colectNeigh(Vars,1,Vars,Pares),
  myAllDiff(Pares,Vars),
  double(A2,V), A35#= V,
  double(A14,B), A47#= B,
  double(A21,N), A54#= N,
  double(A22,M), A55#= M,
  double(A29,L), A62#= L,
  double2(A3, A), A36#= A,
  double2(A4, S), A37#= S,
  double2(A13, D), A46#= D,
  double2(A32, F), A65#= F,
  labeling([],Vars),
  printPuzzle(Vars).

%Predicados de relação de vizinhança entre as celulas
neighbour(1,2).
neighbour(1,3).
neighbour(1,5).
neighbour(1,7).
neighbour(2,4).
neighbour(2,5).
neighbour(2,6).
neighbour(3,7).
neighbour(3,9).
neighbour(4,6).
neighbour(4,8).
neighbour(4,11).
neighbour(5,6).
neighbour(5,7).
neighbour(5,12).
neighbour(6,8).
neighbour(6,12).
neighbour(7,5).
neighbour(7,9).
neighbour(7,12).
neighbour(8,11).
neighbour(8,12).
neighbour(9,10).
neighbour(9,12).
neighbour(10,12).
neighbour(10,14).
neighbour(10,16).
neighbour(11,12).
neighbour(11,13).
neighbour(12,13).
neighbour(12,14).
neighbour(12,15).
neighbour(12,17).
neighbour(13,15).
neighbour(14,16).
neighbour(14,17).
neighbour(15,17).
neighbour(15,18).
neighbour(16,17).
neighbour(16,19).
neighbour(17,18).
neighbour(17,19).
neighbour(18,19).
neighbour(18,20).
neighbour(18,21).
neighbour(18,25).
neighbour(19,20).
neighbour(19,22).
neighbour(19,23).
neighbour(19,24).
neighbour(20,21).
neighbour(20,24).
neighbour(20,27).
neighbour(21,25).
neighbour(21,27).
neighbour(22,23).
neighbour(22,26).
neighbour(22,28).
neighbour(23,24).
neighbour(23,26).
neighbour(24,26).
neighbour(24,27).
neighbour(24,29).
neighbour(25,27).
neighbour(25,30).
neighbour(26,28).
neighbour(26,29).
neighbour(26,31).
neighbour(27,29).
neighbour(27,30).
neighbour(27,33).
neighbour(28,31).
neighbour(29,31).
neighbour(29,32).
neighbour(29,33).
neighbour(30,33).
neighbour(31,32).
neighbour(32,33).
neighbour(34,35).
neighbour(34,36).
neighbour(34,38).
neighbour(34,40).
neighbour(35,37).
neighbour(35,38).
neighbour(35,39).
neighbour(36,40).
neighbour(36,42).
neighbour(37,39).
neighbour(37,41).
neighbour(37,44).
neighbour(38,39).
neighbour(38,40).
neighbour(38,45).
neighbour(39,41).
neighbour(39,45).
neighbour(40,42).
neighbour(40,45).
neighbour(41,44).
neighbour(41,45).
neighbour(42,43).
neighbour(42,45).
neighbour(43,45).
neighbour(43,47).
neighbour(43,51).
neighbour(44,45).
neighbour(44,46).
neighbour(45,46).
neighbour(45,47).
neighbour(45,48).
neighbour(45,50).
neighbour(46,48).
neighbour(47,49).
neighbour(47,50).
neighbour(48,50).
neighbour(48,51).
neighbour(49,50).
neighbour(49,52).
neighbour(50,51).
neighbour(50,52).
neighbour(51,52).
neighbour(51,53).
neighbour(51,54).
neighbour(51,58).
neighbour(52,53).
neighbour(52,55).
neighbour(52,56).
neighbour(52,57).
neighbour(53,54).
neighbour(53,57).
neighbour(53,60).
neighbour(54,58).
neighbour(54,60).
neighbour(55,56).
neighbour(55,59).
neighbour(55,61).
neighbour(56,57).
neighbour(56,59).
neighbour(57,59).
neighbour(57,60).
neighbour(57,62).
neighbour(58,60).
neighbour(58,63).
neighbour(59,61).
neighbour(59,62).
neighbour(59,64).
neighbour(60,62).
neighbour(60,63).
neighbour(60,66).
neighbour(61,64).
neighbour(62,64).
neighbour(62,65).
neighbour(62,66).
neighbour(63,66).
neighbour(64,65).
neighbour(65,66).

%Predicados de relação entre os cilindros visiveis dos dois lados, tipo 1
double(1,4).
double(2,5).
double(3,6).
double(4,1).
double(5,2).
double(6,3).

%Predicados de relaçaõ entre os cilindros visiveis dos dois lados, tipo 2
double2(3,4).
double2(1,5).
double2(2,6).
double2(4,3).
double2(5,1).
double2(6,2).

%Predicado para a criação de uma lista de pares celula/vizinhos
colectNeigh([],_,_,[]).
colectNeigh([_V|Mais],N,Vars,[N/Vizinhos|Resto]):-
  buscaNeigh(N,Vizinhos),
  N1 is N + 1,
  colectNeigh(Mais,N1,Vars,Resto).

%Predicado auxiliar para a criação dos pares celula/vizinho
buscaNeigh(N,Vizinhos):-
  findall(V1,neighbour(N,V1),Vizinhos).

%Predicados responsaveis pela aplicação das restrições de adjacencia entre vizinhos
myAllDiff([],_).
myAllDiff([V/Vizinhos|Resto],Vars):-
  allLocalDiff([V/Vizinhos],Vars),
  myAllDiff(Resto,Vars).

allLocalDiff([],_).
allLocalDiff([V/Vizinhos],Vars):-
  evenMoreLocal(V,Vizinhos,Vars).

evenMoreLocal(_,[],_).
evenMoreLocal(V,[Vizinhos|Rest],Vars):-
  nth1(V,Vars,O),
  nth1(Vizinhos,Vars,D),
  O #\= D,
  evenMoreLocal(V,Rest,Vars).

%Predicado responsavel por imprimir um elemento de uma dada lista
printElement(Index,Vars):-
  nth1(Index,Vars,Element),
  write(Element).

%Predicado responsavel pela impressão do puzzle
printPuzzle(Vars):-
  nl,nl,nl,
  write('          Frontside                           '), write(' Backside'),nl,nl,
  write(' ------------------------------     '),  write('  ------------------------------'),nl,
  write('|      '),printElement(1,Vars),write('     |     '),printElement(2,Vars),write('      |    |     '),  write('|      '),printElement(34,Vars),write('     |     '),printElement(35,Vars),write('      |    |'),nl,
  write('|-------------------------|    |     '),write('|-------------------------|    |'),nl,
  write('| '),printElement(3,Vars),write('  |  '),printElement(7,Vars),write('  |  '),printElement(5,Vars),write('  |   '),printElement(6,Vars),write('    | '),printElement(4,Vars),write('  |     '),write('| '),printElement(36,Vars),write('  |  '),printElement(40,Vars),write('  |  '),printElement(38,Vars),write('  |   '),printElement(39,Vars),write('    | '),printElement(37,Vars),write('  |'),nl,
  write('|-------------------------|    |     '),write('|-------------------------|    |'),nl,
  write('|   '),printElement(9,Vars),write('   |          |   '),printElement(8,Vars),write('  |    |     '),write('|   '),printElement(42,Vars),write('   |          |   '),printElement(41,Vars),write('  |    |'),nl,
  write('|-------|          |-----------|     '),write('|-------|          |-----------|'),nl,
  write('|   '),printElement(10,Vars),write('   |   '),printElement(12,Vars),write('      |   '),printElement(11,Vars),write('       |     '),write('|   '),printElement(43,Vars),write('   |   '),printElement(45,Vars),write('      |   '),printElement(44,Vars),write('       |'),nl,
  write('|----------        |-----------|     '),write('|----------        |-----------|'),nl,
  write('|  '),printElement(16,Vars),write('  | '),printElement(14,Vars),write('  |       |   '),printElement(13,Vars),write('       |     '),write('|  '),printElement(49,Vars),write('  | '),printElement(47,Vars),write('  |       |   '),printElement(46,Vars),write('       |'),nl,
  write('|     |    |       |-----------|     '),write('|     |    |       |-----------|'),nl,
  write('|     |    |       |   '),printElement(15,Vars),write('       |     '),write('|     |    |       |   '),printElement(48,Vars),write('       |'),nl,
  write('|     |------------------------|     '),write('|     |------------------------|'),nl,
  write('|     |      '),printElement(17,Vars),write('       |   '),printElement(18,Vars),write('     |     '),write('|     |      '),printElement(50,Vars),write('       |   '),printElement(51,Vars),write('     |'),nl,
  write('|---------------------------   |     '),write('|---------------------------   |'),nl,
  write('|         '),printElement(19,Vars),write('           |  |  |  |     '),write('|         '),printElement(52,Vars),write('           |  |  |  |'),nl,
  write('|---------------------|  |  |--|     '),write('|---------------------|  |  |--|'),nl,
  write('|   '),printElement(22,Vars),write('     |   '),printElement(23,Vars),write('    |  |'),printElement(20,Vars),write(' |'),printElement(21,Vars),write(' |  |     '),write('|   '),printElement(55,Vars),write('     |   '),printElement(56,Vars),write('    |  |'),printElement(53,Vars),write(' |'),printElement(54,Vars),write(' |  |'),nl,
  write('|         |        |  |  |  |  |     '),write('|         |        |  |  |  |  |'),nl,
  write('|         |        |'),printElement(24,Vars),write(' |  |  |'),printElement(25,Vars),write(' |     '),write('|         |        |'),printElement(57,Vars),write(' |  |  |'),printElement(58,Vars),write(' |'),nl,
  write('|------------------|  |-----|  |     '),write('|------------------|  |-----|  |'),nl,
  write('| '),printElement(28,Vars),write('   |     '),printElement(26,Vars),write('      |  | '),printElement(27,Vars),write('   |  |     '),write('| '),printElement(61,Vars),write('   |     '),printElement(59,Vars),write('      |  | '),printElement(60,Vars),write('   |  |'),nl,
  write('|     |            |  |     |--|     '),write('|     |            |  |     |--|'),nl,
  write('|     |            |  |     |  |     '),write('|     |            |  |     |  |'),nl,
  write('|---------------------------|  |     '),write('|---------------------------|  |'),nl,
  write('|    '),printElement(31,Vars),write('        |   '),printElement(29,Vars),write('      |  |'),printElement(30,Vars),write(' |     '),write('|    '),printElement(64,Vars),write('        |   '),printElement(62,Vars),write('      |  |'),printElement(63,Vars),write(' |'),nl,
  write('|          --------------   |  |     '),write('|          --------------   |  |'),nl,
  write('|         |     '),printElement(32,Vars),write('     |  '),printElement(33,Vars),write('  |  |     '),write('|         |     '),printElement(65,Vars),write('     |  '),printElement(66,Vars),write('  |  |'),nl,
  write(' ------------------------------     '),write('  ------------------------------'),nl,nl,nl.

printPuzzle2(Vars):-
  write('Backside'),nl,nl,
  write(' ------------------------------'),nl,
  write('|      '),printElement(34,Vars),write('     |     '),printElement(35,Vars),write('      |    |'),nl,
  write('|-------------------------|    |'),nl,
  write('| '),printElement(36,Vars),write('  |  '),printElement(40,Vars),write('  |  '),printElement(38,Vars),write('  |   '),printElement(39,Vars),write('    | '),printElement(37,Vars),write('  |'),nl,
  write('|-------------------------|    |'),nl,
  write('|   '),printElement(42,Vars),write('   |          |   '),printElement(41,Vars),write('  |    |'),nl,
  write('|-------|          |-----------|'),nl,
  write('|   '),printElement(43,Vars),write('   |   '),printElement(45,Vars),write('      |   '),printElement(44,Vars),write('       |'),nl,
  write('|----------        |-----------|'),nl,
  write('|  '),printElement(49,Vars),write('  | '),printElement(47,Vars),write('  |       |   '),printElement(46,Vars),write('       |'),nl,
  write('|     |    |       |-----------|'),nl,
  write('|     |    |       |   '),printElement(48,Vars),write('       |'),nl,
  write('|     |------------------------|'),nl,
  write('|     |      '),printElement(50,Vars),write('       |   '),printElement(51,Vars),write('     |'),nl,
  write('|---------------------------   |'),nl,
  write('|         '),printElement(52,Vars),write('           |  |  |  |'),nl,
  write('|---------------------|  |  |--|'),nl,
  write('|   '),printElement(55,Vars),write('     |   '),printElement(56,Vars),write('    |  |'),printElement(53,Vars),write(' |'),printElement(54,Vars),write(' |  |'),nl,
  write('|         |        |  |  |  |  |'),nl,
  write('|         |        |'),printElement(57,Vars),write(' |  |  |'),printElement(58,Vars),write(' |'),nl,
  write('|------------------|  |-----|  |'),nl,
  write('| '),printElement(61,Vars),write('   |     '),printElement(59,Vars),write('      |  | '),printElement(60,Vars),write('   |  |'),nl,
  write('|     |            |  |     |--|'),nl,
  write('|     |            |  |     |  |'),nl,
  write('|---------------------------|  |'),nl,
  write('|    '),printElement(64,Vars),write('        |   '),printElement(62,Vars),write('      |  |'),printElement(63,Vars),write(' |'),nl,
  write('|          --------------   |  |'),nl,
  write('|         |     '),printElement(65,Vars),write('     |  '),printElement(66,Vars),write('  |  |'),nl,
  write(' ------------------------------').
