// linked_list_mutex.h

#ifndef LINKED_LIST_MUTEX_H
#define LINKED_LIST_MUTEX_H
#include <pthread.h>

typedef struct Node
{
    int data;
    struct Node *next;
} Node;

extern Node *head;
extern pthread_mutex_t listMutex;

void insert(int data);
int member(int data);
void delete(int data);
void printList();

#endif // LINKED_LIST_MUTEX_H
