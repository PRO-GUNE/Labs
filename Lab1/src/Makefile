# Make file to compile the source code

# Compiler
CC = gcc

# Compiler flags
CFLAGS = -Wall -std=c99

# Debug flags
DEBUGFLAGS = -g

# Linker flags
PFLAGS = -pthread

# Targets
all: serial.o mutex.o rwlock.o

# Serial version
serial.o: test_serial.c linked_list_serial.c linked_list_serial.h
	$(CC) $(DEBUGFLAGS) $(CFLAGS) -o serial.o test_serial.c linked_list_serial.c

# Parallel version - mutex
mutex.o: test_mutex.c linked_list_mutex.c linked_list_mutex.h
	$(CC) $(DEBUGFLAGS) $(CFLAGS) $(PFLAGS) -o mutex.o test_mutex.c linked_list_mutex.c

# Parallel version - rwlock
rwlock.o: test_rwlock.c linked_list_rwlock.c linked_list_rwlock.h
	$(CC) $(DEBUGFLAGS) $(CFLAGS) $(PFLAGS) -o rwlock.o test_rwlock.c linked_list_rwlock.c

# Clean
clean:
	rm -f *.o *.log