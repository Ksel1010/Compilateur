TARGETL = Analyseur_Lex
TARGETS = Analyseur_Syn
all: 
	-yacc -d $(TARGETS).y 
	-lex $(TARGETL).l 
	-gcc lex.yy.c y.tab.c -o compilo.exe
	-./compilo.exe < test.c

lex:
	- lex $(TARGETL).l

yacc:
	- yacc -d $(TARGETS).y 

compile: 
	-gcc lex.yy.c y.tab.c -o compilo.exe

exe:
	-./compilo.exe < test.c

clean:
	-rm *.o
	-rm $(TARGET)
	-rm *.o.s
	-rm simd-test