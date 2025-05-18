TARGETL =src/Analyseur/Analyseur_Lex
TARGETS =src/Analyseur/Analyseur_Syn

FILE ?=test.c

OUTPUT_FILENAME :=$(notdir $(FILE))
OUTPUT_BASENAME :=$(strip $(basename $(OUTPUT_FILENAME)))
OUTPUT:=./target/$(OUTPUT_BASENAME).o

all: 
	@mkdir -p ./target

	@echo "Compilation des analyseurs"
	-yacc -t -g -v -d $(TARGETS).y 
	-lex $(TARGETL).l 

	@echo "Compilation de l'exécutable"
	-gcc  -g lex.yy.c y.tab.c src/C/*.c -o compilo.exe

	@echo "Execution"
	-./compilo.exe $(OUTPUT) < $(FILE)
	
	@mkdir -p ./crossCompiled

	@echo "Generation cross compiled lisible"
	-python cross_compiler.py -i $(OUTPUT) -o ./crossCompiled/$(OUTPUT_BASENAME).txt


lex:
	- lex $(TARGETL).l

yacc:
	- yacc -v -Wother -Wcounterexamples -g -d $(TARGETS).y 

compile: 
	-gcc lex.yy.c y.tab.c -o compilo.exe

exe:
	-./compilo.exe < test.c

clean:
	-rm y.tab.c
	-rm y.tab.h
	-rm lex.yy.c
	-rm y.gv
	-rm y.output
	-rm compilo.exe
	-rm -rf ./crossCompiled/
	-rm -rf ./target/
