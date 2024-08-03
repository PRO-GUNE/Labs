// linked_list_serial.c

#include "linked_list_serial.h"
#include <stdio.h>
#include <stdlib.h>

Node *head = NULL;

void insert(int data)
{
    Node *newNode = (Node *)malloc(sizeof(Node));
    newNode->data = data;
    newNode->next = head;
    head = newNode;
}

int member(int data)
{
    Node *temp = head;
    while (temp != NULL)
    {
        if (temp->data == data)
            return 1;
        temp = temp->next;
    }
    return 0;
}

void delete(int data)
{
    Node *temp = head;
    Node *prev = NULL;

    while (temp != NULL && temp->data != data)
    {
        prev = temp;
        temp = temp->next;
    }

    if (temp == NULL)
        return;

    if (prev == NULL)
    {
        head = temp->next;
    }
    else
    {
        prev->next = temp->next;
    }

    free(temp);
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
