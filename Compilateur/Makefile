GRM = parser.y
LEX = lex.l
BIN = comp

CC = gcc
CFLAGS = -Wall -g

OBJ = y.tab.o lex.yy.o instruction.o ts.o

all: $(BIN)

%.o: %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

y.tab.c: $(GRM)
	yacc -d -t -v $<

lex.yy.c: $(LEX)
	flex $<

$(BIN): $(OBJ)
	$(CC) $(CFLAGS) $(CPPFLAGS) $^ -o $@

clean:
	rm $(OBJ) y.tab.c y.tab.h lex.yy.c

test:   all
	./$(BIN) < test.c