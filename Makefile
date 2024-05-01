build1 : 
	bison -d -r all grammer.y ; flex lexer.l ;  gcc extetrickstype.c lex.yy.c grammer.tab.c; ./a.out < ./testcases/tc1.tetris 2>/dev/null > ./game_engine/output1.py; python3 ./game_engine/output1.py

build2 : 
	bison -d -r all grammer.y ; flex lexer.l ;  gcc extetrickstype.c lex.yy.c grammer.tab.c; ./a.out < ./testcases/tc2.tetris 2>/dev/null > ./game_engine/output2.py; python3 ./game_engine/output2.py

build3 : 
	bison -d -r all grammer.y ; flex lexer.l ;  gcc extetrickstype.c lex.yy.c grammer.tab.c; ./a.out < ./testcases/tc3.tetris 2>/dev/null > ./game_engine/output3.py; python3 ./game_engine/output3.py