// linked_list_serial.h

#ifndef LINKED_LIST_SERIAL_H
#define LINKED_LIST_SERIAL_H

typedef struct Node
{
    int data;
    struct Node *next;
} Node;

void insert(int data);
int member(int data);
void delete(int data);
void printList();

#endif // LINKED_LIST_SERIAL_H
