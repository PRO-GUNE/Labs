// test_serial.c
// The numThreads argument is not used here as this is the serial implementation.

#include "linked_list_serial.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char *argv[])
{
    if (argc != 8)
    {
        fprintf(stderr, "Usage: %s <n> <m> <mMember> <mInsert> <mDelete> <seed> <numThreads>\n", argv[0]);
        return 1;
    }

    int n = atoi(argv[1]);
    int m = atoi(argv[2]);
    double mMember = atof(argv[3]);
    double mInsert = atof(argv[4]);
    double mDelete = atof(argv[5]);
    int seed = atoi(argv[6]);

    srand(seed);

    // Initialize linked list with n unique random values
    for (int i = 0; i < n; i++)
    {
        insert(rand() % 65536);
    }

    // Generate operations
    int *operations = (int *)malloc(m * sizeof(int));
    for (int i = 0; i < m; i++)
    {
        double r = (double)rand() / RAND_MAX;
        if (r < mMember)
        {
            operations[i] = 0; // Member
        }
        else if (r < mMember + mInsert)
        {
            operations[i] = 1; // Insert
        }
        else
        {
            operations[i] = 2; // Delete
        }
    }

    // Timing the operations
    clock_t start, end;
    double cpu_time_used;

    start = clock();

    for (int i = 0; i < m; i++)
    {
        int value = rand() % 65536;
        if (operations[i] == 0)
        {
            member(value);
        }
        else if (operations[i] == 1)
        {
            insert(value);
        }
        else
        {
            delete (value);
        }
    }

    end = clock();
    cpu_time_used = ((double)(end - start)) / CLOCKS_PER_SEC;

    free(operations);

    printf("Time taken: %f seconds\n", cpu_time_used);

    return 0;
}
