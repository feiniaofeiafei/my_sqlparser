LEX=flex
YACC=bison
CC=g++
OBJECT=main			

$(OBJECT): lex.yy.o  yacc.tab.o
	$(CC) lex.yy.o yacc.tab.o -o $(OBJECT) -lfl -ly
	@./$(OBJECT)	

lex.yy.o: lex.yy.c  yacc.tab.h  main.h
	$(CC) -std=c++11 -c lex.yy.c

yacc.tab.o: yacc.tab.c  main.h
	$(CC) -std=c++11 -c yacc.tab.c

yacc.tab.c  yacc.tab.h: yacc.y
	$(YACC) -d -v yacc.y --verbose -t --locations

lex.yy.c: lex.l
	$(LEX) lex.l

clean:
	@rm -f $(OBJECT)  *.o
