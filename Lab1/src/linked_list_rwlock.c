// linked_list_rwlock.c

#include "linked_list_rwlock.h"
#include <stdio.h>
#include <stdlib.h>

Node *head = NULL;
pthread_rwlock_t listRwlock;

void insert(int data)
{
    pthread_rwlock_wrlock(&listRwlock);

    Node *newNode = (Node *)malloc(sizeof(Node));
    newNode->data = data;
    newNode->next = head;
    head = newNode;

    pthread_rwlock_unlock(&listRwlock);
}

int member(int data)
{
    pthread_rwlock_rdlock(&listRwlock);

    Node *temp = head;
    while (temp != NULL)
    {
        if (temp->data == data)
        {
            pthread_rwlock_unlock(&listRwlock);
            return 1;
        }
        temp = temp->next;
    }

    pthread_rwlock_unlock(&listRwlock);
    return 0;
}

void delete(int data)
{
    pthread_rwlock_wrlock(&listRwlock);

    Node *temp = head;
    Node *prev = NULL;

    while (temp != NULL && temp->data != data)
    {
        prev = temp;
        temp = temp->next;
    }

    if (temp == NULL)
    {
        pthread_rwlock_unlock(&listRwlock);
        return;
    }

    if (prev == NULL)
    {
        head = temp->next;
    }
    else
    {
        prev->next = temp->next;
    }

    free(temp);

    pthread_rwlock_unlock(&listRwlock);
}

void printList()
{
    Node *temp = head;
    while (temp != NULL)
    {
        printf("%d -> ", temp->data);
        temp = temp->next;
    }
    printf("NULL\n");
}
