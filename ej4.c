#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

uint32_t* newX(long unsigned int size);
int16_t* newT(long unsigned int size);
float* newM(long unsigned int size);
uint8_t* newK(long unsigned int size);

extern float* xtmk(uint32_t* x, int16_t* t, float* m, uint8_t* k);

int main(void) {
  
  srand(12345);

  uint32_t* x = newX(120*120);
  int16_t* t = newT(120*120);
  float* m = newM(60*60);
  uint8_t* k = newK(30*30);

  printf("Input\n");
  printf("  X: "); for(int i=0; i < 10; i++) {printf("%i\t", x[i]);} printf("\n");
  printf("  T: "); for(int i=0; i < 10; i++) {printf("%i\t", t[i]);} printf("\n");
  printf("  M: "); for(int i=0; i < 10; i++) {printf("%.2f\t", m[i]);} printf("\n");
  printf("  K: "); for(int i=0; i < 10; i++) {printf("%i\t", k[i]);} printf("\n");

  printf("...\n \n  X: "); for(int i=10; i >0; i--) {printf("%i\t", x[120*120 - i]);} printf("\n");
  printf("  T: "); for(int i=10; i >0; i--) {printf("%i\t", t[120*120 - i]);} printf("\n");
  printf("  M: "); for(int i=10; i >0; i--) {printf("%.2f\t", m[60*60 - i]);} printf("\n");
  printf("  K: "); for(int i=10; i >0; i--) {printf("%i\t", k[30*30 - i]);} printf("\n");
  float* r = xtmk(x, t, m, k);

  printf("Results\n");
  if(r!=0) {
    printf("  R: "); for(int i=0; i < 10; i++) {printf("%.2f\t", r[i]);} printf("\n");
    printf("... \n \n  R: "); for(int i=10; i >0; i--) {printf("%.2f\t", r[120*120 - i]);} printf("\n");
    free(r);
  } else {
    printf("  R: null\n");
  }

  free(x);
  free(t);
  free(m);
  free(k);

  return 0;
}

uint32_t* newX(long unsigned int size) {
  uint32_t* x = malloc(sizeof(uint32_t) * (size));
  for(long unsigned int i=0;i<size;i++) {
    x[i] = (uint32_t)(rand() % 1000);
  }
  return x;
}

int16_t* newT(long unsigned int size) {
  int16_t* t = malloc(sizeof(int16_t) * (size));
  for(long unsigned int i=0;i<size;i++) {
    t[i] = (int16_t)(rand() % 1000);
  }
  return t;
}

float* newM(long unsigned int size) {
  float* m = malloc(sizeof(float) * (size));
  for(long unsigned int i=0;i<size;i++) {
    m[i] = (float)(rand() % 1000) / (float)100.0;
    m[i] = m[i] == 0 ? m[i]+1 : m[i];
  }
  return m;
}

uint8_t* newK(long unsigned int size) {
  uint8_t* k = malloc(sizeof(uint8_t) * (size));
  for(long unsigned int i=0;i<size;i++) {
    k[i] = (uint8_t)(rand() % 256);
  }
  return k;
}