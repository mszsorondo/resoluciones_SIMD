#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

extern void RGB_646_to_888(uint8_t* src, uint8_t* dst, int m, int n);

int main(void) {
  
  srand(12345);
  int rows = 256;
  int cols = 128;

  uint8_t* src = malloc(sizeof(uint8_t) * (long unsigned int)(2 * rows * cols));
  for (int i = 0; i < rows * cols * 2; i++) {
    src[i] = (uint8_t)(rand() % 256);
  }

  uint8_t* dst = malloc(sizeof(uint8_t) * (long unsigned int)(3 * rows * cols));
  int lastSrcPix = 2 * cols * rows - 1;
  int lastDstPix = 3 * cols * rows - 1;
  printf("SRC\n");
  printf("  %x %x | %x %x | %x %x | ...\n", src[0], src[1], src[2], src[3], src[4], src[5]);
  printf(" ... | %x %x | %x %x | %x %x \n", src[lastSrcPix-5],  src[lastSrcPix-4], src[lastSrcPix-3],src[lastSrcPix-2],src[lastSrcPix-1], src[lastSrcPix]);
  RGB_646_to_888(src, dst, rows, cols);

  printf("\nDST\n");
  printf("  %x %x %x | %x %x %x | %x %x %x | ...\n", dst[0], dst[1], dst[2], dst[3], dst[4], dst[5], dst[6], dst[7], dst[8]);
  printf(" | ... %x %x %x | %x %x %x | %x %x %x \n", dst[lastDstPix-8], dst[lastDstPix-7],dst[lastDstPix-6], dst[lastDstPix-5],dst[lastDstPix-4],dst[lastDstPix-3], dst[lastDstPix-2], dst[lastDstPix-1], dst[lastDstPix]);
  
  free(src);
  free(dst);

  return 0;
}
