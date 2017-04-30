cs = csc
flags = -require-extension r7rs -i

all: compile link clean

compile:
	$(cs) $(flags) -c main.scm
	$(cs) $(flags) -c communicate.scm
	$(cs) $(flags) -c packages.scm
	$(cs) $(flags) -c config.scm

link:
	$(cs) $(flags) main.o communicate.o packages.o config.o -o pigmanclassic

clean:
	rm *.o
