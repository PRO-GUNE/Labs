// test_rwlock.c

#include "linked_list_rwlock.h"
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

// Probability of each operation as global variables
double mMember, mInsert, mDelete;
// Seed for random number generation
int seed;

void *worker(void *arg)
{
    int m = *((int *)arg);
    int *operations = (int *)malloc(m * sizeof(int));
    srand(seed);

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

    free(operations);
    return NULL;
}

int main(int argc, char *argv[])
{
    if (argc != 8)
    {
        fprintf(stderr, "Usage: %s <n> <m> <mMember> <mInsert> <mDelete> <seed> <numThreads>\n", argv[0]);
        return 1;
    }

    int n = atoi(argv[1]);
    int m = atoi(argv[2]);
    mMember = atof(argv[3]);
    mInsert = atof(argv[4]);
    mDelete = atof(argv[5]);
    seed = atoi(argv[6]);
    int numThreads = atoi(argv[7]);

    pthread_t threads[numThreads];
    int threadArgs[numThreads];

    pthread_rwlock_init(&listRwlock, NULL);

    srand(seed);

    // Initialize linked list with n unique random values
    for (int i = 0; i < n; i++)
    {
        insert(rand() % 65536);
    }

    // Timing the operations
    clock_t start, end;
    double cpu_time_used;

    start = clock();

    for (int i = 0; i < numThreads; i++)
    {
        threadArgs[i] = m / numThreads;
        pthread_create(&threads[i], NULL, worker, &threadArgs[i]);
    }

    for (int i = 0; i < numThreads; i++)
    {
        pthread_join(threads[i], NULL);
    }

    end = clock();
    cpu_time_used = ((double)(end - start)) / CLOCKS_PER_SEC;

    printf("Time taken with %d threads: %f seconds\n", numThreads, cpu_time_used);

    pthread_rwlock_destroy(&listRwlock);
    return 0;
}
