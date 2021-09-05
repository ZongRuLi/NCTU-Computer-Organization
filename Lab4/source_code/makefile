#declare variables
CC = g++
#version = c++0x
MAP = direct_mapped_cache
LRU = direct_mapped_cache_lru
FILE1 = ICACHE.txt
FILE2 = DCACHE.txt
FILE3 = LU.txt
FILE4 = RADIX.txt
OUTFILE = out.txt

all: compile display

compile: cmap clru

cmap:
	$(CC) $(MAP).cpp -o $(MAP).out
clru:
	$(CC) $(LRU).cpp -o $(LRU).out

display: dmap dlru cat
dmap:
	./$(MAP).out $(FILE1) > $(OUTFILE)
	./$(MAP).out $(FILE2) >>$(OUTFILE)
dlru:
	./$(LRU).out $(FILE3) >>$(OUTFILE)
	./$(LRU).out $(FILE4) >>$(OUTFILE)
cat:
	cat $(OUTFILE)
clean:
	rm -f $(MAP).out $(LRU).out $(OUTFILE)
