// linked_list_rwlock.h

#ifndef LINKED_LIST_RWLOCK_H
#define LINKED_LIST_RWLOCK_H
#include <pthread.h>

typedef struct Node
{
    int data;
    struct Node *next;
} Node;

extern Node *head;
extern pthread_rwlock_t listRwlock;

void insert(int data);
int member(int data);
void delete(int data);
void printList();

#endif // LINKED_LIST_RWLOCK_H
