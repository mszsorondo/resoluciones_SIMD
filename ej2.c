#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include "lib.h"

int32_t* TESTintClone(int32_t* a);
void TESTintPrint(int32_t* a, FILE* pFile);
list_t* TESTlistNew(type_t t);
void TESTlistAddFirst(list_t* l, int d);
void TESTlistDelete(list_t* l);
void TESTlistPrint(list_t* l, FILE* pFile);
array_t* TESTarrayNew(type_t t, uint8_t capacity);
void  TESTarrayAddLast(array_t* a, void* data);
void  TESTarrayPrint(array_t* a, FILE* pFile);
void  TESTarrayDelete(array_t* a);
array_t* example();
void insertarIesimosC(array_t* listas, int i, list_t* listRes);
list_t* listMultiMergeC(array_t* listas);

extern void insertarIesimos(array_t* listas, int i, list_t* listRes);

extern list_t* listMultiMerge(array_t* listas);
extern void* listGet(list_t* l, uint8_t i);
extern void listAddCardLast(list_t* l, card_t* card);


int main(void) {

  array_t* a = example();

  printf("Input\n  ");
  TESTarrayPrint(a, stdout);
  printf("\n");

  list_t* lm = listMultiMerge(a);

  printf("Result\n  ");
  if(lm != 0) {
    TESTlistPrint(lm, stdout);
    TESTlistDelete(lm);
    printf("\n");
  } else {
    printf("null\n");
  }

  TESTarrayDelete(a);
  
  return 0;
}

int32_t* TESTintClone(int32_t* a){
    int32_t* n = (int32_t*)malloc(sizeof(int32_t));
    *n = *a;
    return n;
}

void TESTintPrint(int32_t* a, FILE* pFile){
    fprintf(pFile, "%i", *a);
}

list_t* TESTlistNew(type_t t){
    list_t* l = malloc(sizeof(list_t));
    l->type = t;
    l->first = 0;
    l->last = 0;
    l->size = 0;
    return l;
}

void TESTlistAddFirst(list_t* l, int d){
    listElem_t* n = malloc(sizeof(listElem_t));
    l->size = (uint8_t)(l->size + 1);
    n->data = TESTintClone(&d);
    n->prev = 0;
    n->next = l->first;
    if(l->first == 0)
        l->last = n;
    else
        l->first->prev = n;
    l->first = n;
}

void TESTlistDelete(list_t* l){
    listElem_t* current = l->first;
    while(current!=0) {
        listElem_t* tmp = current;
        current =  current->next;
        free(tmp->data);
        free(tmp);
    }
    free(l);
}

void TESTlistPrint(list_t* l, FILE* pFile) {
    fprintf(pFile, "[");
    listElem_t* current = l->first;
    if(current==0) {
        fprintf(pFile, "]");
        return;
    }
    while(current!=0) {
        fprintf(pFile, "%i", *((uint32_t*)current->data));
        current = current->next;
        if(current==0)
            fprintf(pFile, "]");
        else
            fprintf(pFile, ",");
    }
}

array_t* TESTarrayNew(type_t t, uint8_t capacity) {
    array_t* array = (array_t*)malloc(sizeof(array_t));
    array->type = t;
    array->capacity = capacity;
    array->size = 0;
    array->data = (void**)malloc(sizeof(void*)*capacity);
    return array;
}

void  TESTarrayAddLast(array_t* a, void* data) {
    if(a->size != a->capacity) {
        a->data[a->size] = data;
        a->size = (uint8_t)(a->size + 1);
    }
}

void  TESTarrayPrint(array_t* a, FILE* pFile) {
    fprintf(pFile, "[");
    for(int i=0; i<a->size-1; i++) {
        TESTlistPrint(a->data[i], pFile);
        fprintf(pFile, ",");
    }
    if(a->size >= 1) {
        TESTlistPrint(a->data[a->size-1], pFile);
    }
    fprintf(pFile, "]");
}

void  TESTarrayDelete(array_t* a) {
    for(int i=0; i<a->size; i++)
        TESTlistDelete(a->data[i]);
    free(a->data);
    free(a);
}

array_t* example() {
    list_t* l1 = TESTlistNew(TypeInt);
    TESTlistAddFirst(l1, 1);
    TESTlistAddFirst(l1, 2);
    TESTlistAddFirst(l1, 3);
    TESTlistAddFirst(l1, 4);
    list_t* l2 = TESTlistNew(TypeInt);
    //TESTlistAddFirst(l2, 999);
    //TESTlistAddFirst(l2, 99);
    //TESTlistAddFirst(l2, 9);
    list_t* l3 = TESTlistNew(TypeInt);
    TESTlistAddFirst(l3, 88);
    TESTlistAddFirst(l3, 80);
    TESTlistAddFirst(l3, 88);
    TESTlistAddFirst(l3, 80);
    TESTlistAddFirst(l3, 88);
    array_t* a = TESTarrayNew(TypeList, 5);
    TESTarrayAddLast(a, l1);
    TESTarrayAddLast(a, l2);
    TESTarrayAddLast(a, l3);
    return a;
}
//void* listGet(list_t* l, uint8_t i);
list_t* listMultiMergeC(array_t* listas){
    //1. tomar maxListLen 
    //2. crear lista resultante en listRes
    //3. iterar de i = 0 a maxListLen
    //      de k= 0 a long(arrei):
        //      appendear a listRes listGet(listas,i)
    int maxListLen = 0;
    for(uint8_t i = 0; i< listas->size ; i++){
        list_t* listActual = arrayGet(listas,i);

        if(maxListLen<listActual->size)
            maxListLen=listActual->size;
    }

    list_t* listaRes = listNew(1);

    for(uint8_t i = 0; i < maxListLen ; i++){
        insertarIesimosC(listas, i, listaRes);
    }

    return listaRes;
    
}
void insertarIesimosC(array_t* listas, int i, list_t* listRes){
    for(uint8_t k = 0 ; k< listas->size ; k++){
        list_t* listActual = arrayGet(listas,k);

        card_t* aInsertar = listGet(listActual,i);
        if(aInsertar!=0)
            listAddCardLast(listRes,aInsertar);
    }

    return;
}

