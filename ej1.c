#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include "lib.h"

array_t* TESTarrayNew(type_t t, uint8_t capacity);
void TESTarrayAddLast(array_t* a, void* data);
card_t* TESTcardNew(char* suit, int32_t* number);
void TESTcardAddStacked(card_t* c, card_t* card);
uint32_t TESTstrLen(char* a);
int32_t* TESTintClone(int32_t* a);
char* TESTstrClone(char* a);
list_t* TESTlistNew(type_t t);
void TESTarrayPrint(array_t* a, FILE* pFile);
void TESTlistPrint(list_t* l, FILE* pFile);
void TESTcardPrint(card_t* c, FILE* pFile);
void TESTarrayDelete(array_t* a);
void TESTlistDelete(list_t* l);
void TESTcardDelete(card_t* c);
array_t* newMazo();
int depthFoundC(card_t* cartaConStack, card_t* buscada, int currentDepth);
int cardContainsC(array_t* mazo,card_t* carta, int*level);
extern void* arrayGet(array_t* a, uint8_t i);
extern int32_t intCmp(int32_t* a, int32_t* b);
extern int32_t strCmp(char* a, char* b);
extern uint8_t  listGetSize(list_t* l);
extern int32_t cardCmp(card_t* a, card_t* b);
extern uint32_t strLen(char* a);
extern  list_t* listNew(type_t t);
extern card_t* cardNew(char* suit, int32_t* number);


int cardContains(array_t* mazo, card_t* carta, int* level);

int main(void) {

  printf("Input\n  ");
  array_t* mazo = newMazo();
  TESTarrayPrint(mazo, stdout);
  int tres = 3;
  card_t* carta = TESTcardNew("basto", &tres);
  int level;
  int result = cardContains(mazo, carta, &level);

  printf("\nResult = %i\n", result);
  if(result != 0) {
    printf("  Carta %s %i\n", carta->suit, *(carta->number));
    printf("  Level %i\n", level);
  }
  printf("  Level %i\n", level);
  TESTarrayDelete(mazo);
  //cardDelete(carta);

  //printf("\n ENUM TIENE TAMANIO %i", sizeof(type_t));
  return 0;
}

array_t* newMazo() {
  array_t* a = TESTarrayNew(TypeCard, 100); int32_t n;
  n = 1; card_t* c_e1 = TESTcardNew("espada", &n);
  n = 2; card_t* c_e2 = TESTcardNew("espada", &n);
  n = 3; card_t* c_e3 = TESTcardNew("espada", &n);
  n = 1; card_t* c_c1 = TESTcardNew("copa", &n);
  n = 2; card_t* c_c2 = TESTcardNew("copa", &n);
  n = 3; card_t* c_c3 = TESTcardNew("copa", &n);
  n = 3; card_t* b_b3 = TESTcardNew("basto", &n);

  TESTcardAddStacked(c_e1, c_c2);
  TESTcardAddStacked(c_c2, b_b3);
  TESTcardAddStacked(c_e1, c_c3);
  TESTcardAddStacked(c_c1, c_e2);
  TESTcardAddStacked(c_c1, c_e3);
  TESTarrayAddLast(a, c_e1);
  TESTarrayAddLast(a, c_c1);
  return a;
}

array_t* TESTarrayNew(type_t t, uint8_t capacity) {
    array_t* array = (array_t*)malloc(sizeof(array_t));
    array->type = t;
    array->capacity = capacity;
    array->size = 0;
    array->data = (void**)malloc(sizeof(void*)*capacity);
    return array;
}

void TESTarrayAddLast(array_t* a, void* data) {
    if(a->size != a->capacity) {
        a->data[a->size] = data;
        a->size = (uint8_t)(a->size + 1);
    }
}

card_t* TESTcardNew(char* suit, int32_t* number) {
    card_t* card = (card_t*)malloc(sizeof(card_t));
    card->suit = TESTstrClone(suit);
    card->number = TESTintClone(number);
    card->stacked = TESTlistNew(TypeCard);
    return card;
}

void TESTcardAddStacked(card_t* c, card_t* card) {
    list_t* l = c->stacked;
    listElem_t* n = malloc(sizeof(listElem_t));
    l->size = (uint8_t)(l->size + 1);
    n->data = card;
    n->prev = 0;
    n->next = l->first;
    if(l->first == 0)
        l->last = n;
    else
        l->first->prev = n;
    l->first = n;
}

uint32_t TESTstrLen(char* a) {
    uint32_t i=0;
    while(a[i]!=0) i++;
    return i;
}

int32_t* TESTintClone(int32_t* a){
    int32_t* n = (int32_t*)malloc(sizeof(int32_t));
    *n = *a;
    return n;
}

char* TESTstrClone(char* a) {
    uint32_t len = TESTstrLen(a) + 1;
    char* s = malloc(len);
    while(len-- != 0)
        { s[len]=a[len];}
    return s;
}

list_t* TESTlistNew(type_t t){
    list_t* l = malloc(sizeof(list_t));
    l->type = t;
    l->first = 0;
    l->last = 0;
    l->size = 0;
    return l;
}

void TESTarrayPrint(array_t* a, FILE* pFile) {
    fprintf(pFile, "[");
    for(int i=0; i<a->size-1; i++) {
        TESTcardPrint(a->data[i], pFile);
        fprintf(pFile, ",");
    }
    if(a->size >= 1) {
        TESTcardPrint(a->data[a->size-1], pFile);
    }
    fprintf(pFile, "]");
}

void TESTlistPrint(list_t* l, FILE* pFile) {
    fprintf(pFile, "[");
    listElem_t* current = l->first;
    if(current==0) {
        fprintf(pFile, "]");
        return;
    }
    while(current!=0) {
        TESTcardPrint(current->data, pFile);
        current = current->next;
        if(current==0)
            fprintf(pFile, "]");
        else
            fprintf(pFile, ",");
    }
}

void TESTcardPrint(card_t* c, FILE* pFile) {
    fprintf(pFile,"{%s-%i-", c->suit, *(c->number));
    TESTlistPrint(c->stacked, pFile);
    fprintf(pFile,"}");
}

void  TESTarrayDelete(array_t* a) {
    for(int i=0; i<a->size; i++)
        TESTcardDelete(a->data[i]);
    free(a->data);
    free(a);
}

void TESTlistDelete(list_t* l){
    listElem_t* current = l->first;
    while(current!=0) {
        listElem_t* tmp = current;
        current =  current->next;
        TESTcardDelete(tmp->data);
        free(tmp);
    }
    free(l);
}

void TESTcardDelete(card_t* c) {
    free(c->suit);
    free(c->number);
    TESTlistDelete(c->stacked);
    free(c);
}

int cardContainsC(array_t* mazo,card_t* carta, int*level){

    int levelFound = -1;
    for(uint8_t i = 0; i < mazo->size && levelFound==-1 ; i++){
            card_t* actual = arrayGet(mazo, i);
            levelFound = depthFoundC(actual,carta,0);
        
    }
    *level = levelFound;
    return levelFound>=0;
}

int depthFoundC(card_t* cartaConStack, card_t* buscada, int currentDepth){
    //dada una carta con stack:
    //si la carta buscada es igual, retornar currentDepth
    //si no, hay 2 alternativas:
    //1. no hay cartas stackeadas -> retorna -1
    //2. hay cartas stackeadas -> recorrer la lista llamando a depthFound;
    int depth = -1;
    int largoLista = listGetSize(cartaConStack->stacked);
    if(cardCmp(cartaConStack,buscada)==0){
        return currentDepth;
    } else if(largoLista>0){
        listElem_t* currentNode = (cartaConStack->stacked)->first;
        while(currentNode!=NULL && depth==-1){
            card_t* currentCard = currentNode->data;
            depth = depthFoundC(currentCard, buscada, currentDepth+1);
            currentNode = currentNode->next;
        }
        return depth;
    } else {
        return -1;

    }

    


}
