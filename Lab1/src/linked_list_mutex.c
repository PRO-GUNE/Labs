// linked_list_mutex.c

#include "linked_list_mutex.h"
#include <stdio.h>
#include <stdlib.h>

Node *head = NULL;
pthread_mutex_t listMutex;

void insert(int data)
{
    pthread_mutex_lock(&listMutex);

    Node *newNode = (Node *)malloc(sizeof(Node));
    newNode->data = data;
    newNode->next = head;
    head = newNode;

    pthread_mutex_unlock(&listMutex);
}

int member(int data)
{
    pthread_mutex_lock(&listMutex);

    Node *temp = head;
    while (temp != NULL)
    {
        if (temp->data == data)
        {
            pthread_mutex_unlock(&listMutex);
            return 1;
        }
        temp = temp->next;
    }

    pthread_mutex_unlock(&listMutex);
    return 0;
}

void delete(int data)
{
    pthread_mutex_lock(&listMutex);

    Node *temp = head;
    Node *prev = NULL;

    while (temp != NULL && temp->data != data)
    {
        prev = temp;
        temp = temp->next;
    }

    if (temp == NULL)
    {
        pthread_mutex_unlock(&listMutex);
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

    pthread_mutex_unlock(&listMutex);
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
