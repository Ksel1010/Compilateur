TARGETL = src/Analyseur/Analyseur_Lex
TARGETS = src/Analyseur/Analyseur_Syn
all: 
	-yacc -t -g -v -d $(TARGETS).y 
	-lex $(TARGETL).l 
	-gcc -g lex.yy.c y.tab.c src/C/*.c -o compilo.exe
	-./compilo.exe < test.c

lex:
	- lex $(TARGETL).l

yacc:
	- yacc -v -g -d $(TARGETS).y 

compile: 
	-gcc lex.yy.c y.tab.c -o compilo.exe

exe:
	-./compilo.exe < test.c

clean:
	-rm *.o
	-rm $(TARGET)
	-rm *.o.s
	-rm simd-test