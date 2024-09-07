# Make file to compile the source code

# Directories
TOPDIR = ../
SRCDIR = $(TOPDIR)src/
BINDIR = $(TOPDIR)bin/
TESTDIR = $(TOPDIR)test/
LOGSDIR = $(TOPDIR)logs/

# Compiler
CC = gcc

# Compiler flags
CFLAGS = -I $(SRCDIR) -Wall -std=c99

# Debug flags
DEBUGFLAGS = -g

# Linker flags
PFLAGS = -pthread

# Targets
all: $(BINDIR)serial.o $(BINDIR)mutex.o $(BINDIR)rwlock.o

# Serial version
$(BINDIR)serial.o: $(TESTDIR)test_serial.c $(SRCDIR)linked_list_serial.c $(SRCDIR)linked_list_serial.h
	$(CC) $(DEBUGFLAGS) $(CFLAGS) -o $@ $^

# Parallel version - mutex
$(BINDIR)mutex.o: $(TESTDIR)test_mutex.c $(SRCDIR)linked_list_mutex.c $(SRCDIR)linked_list_mutex.h
	$(CC) $(DEBUGFLAGS) $(CFLAGS) $(PFLAGS) -o $@ $^

# Parallel version - rwlock
$(BINDIR)rwlock.o: $(TESTDIR)test_rwlock.c $(SRCDIR)linked_list_rwlock.c $(SRCDIR)linked_list_rwlock.h
	$(CC) $(DEBUGFLAGS) $(CFLAGS) $(PFLAGS) -o $@ $^

# Clean
clean:
	rm -f $(BINDIR)*.o $(LOGSDIR)*.csv