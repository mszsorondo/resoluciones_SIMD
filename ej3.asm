
global RGB_646_to_888


section .rodata

maskRed: times 4 dw 0x003F
maskGreen: times 4 dw 0x03C0
maskBlue: times 4 dw 0xFC00

shuffleRed: db 0x00, 0x01, 0x01, 0x02, 0x01, 0x01, 0x04, 0x01, 0x01, 0x06, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
shuffleGreen: db 0x01, 0x00, 0x01, 0x01, 0x02, 0x01, 0x01, 0x04, 0x01, 0x01, 0x06, 0x01, 0x01, 0x01, 0x01, 0x01
shuffleBlue: db 0x01, 0x01, 0x00, 0x01, 0x01, 0x02, 0x01, 0x01, 0x04, 0x01, 0x01, 0x06, 0x01, 0x01, 0x01, 0x01

section .text
RGB_646_to_888: ; rdi = src (puntero a origen) 
                ; rsi = dst (puntero a destino)
                ; rdx, rcx = m -columnas-(multiplo de 16),n -filas-
  push rbp
  mov rbp, rsp
  push rbx
  sub rsp, 8

  mov rax, rdx
  mul rcx
  mov rcx, 2
  mul rcx ; tengo el largo lineal de la imagen (en bytes) en rax

  mov rcx, 0 ; indice * desplazamiento de src
  mov rbx, 0 ; indice * desplazamiento de dst
 
  .ciclo:
    cmp rcx, rax
    je .fin 

    pxor xmm0, xmm0
    movq xmm0, qword[rdi+rcx] ; aca 4 pixeles
    

    ;PODES CAMBIAR SHUFFLES POR MULTIPLICA
    ;CIONES Y DIVISIONES POR 2 SOBRE
    ; LOS REGISTROS XMM
    
    
    pxor xmm10, xmm10 ; set en 0
    movq xmm10, [maskRed]
    pxor xmm1, xmm1 ; set en 0
    movq xmm1, xmm0 ; en xmm1 guardare...
    ;... el resultado [parte baja]
    pand xmm1, xmm10; tengo rojos

    ;0|R|0|R|0|R|0|R| (xmm1 Little)
    ;16 |16 |16 |16 | (bits, R ocupa 6)

    pxor xmm11, xmm11 
    movq xmm11, [maskGreen]
    pxor xmm2, xmm2 ; seteo en 0
    movq xmm2, xmm0;
    pand xmm2, xmm11 ; extraigo verdes
    ;0g0 0g0 0g0 0g0 (xmm2 Little)
    ;16 |16 |16 |16 | (bits, g ocupa 4)
    
    pxor xmm9,xmm9
    pxor xmm3,xmm3
    movq xmm9, [maskBlue]
    movq xmm3, xmm0
    pand xmm3, xmm9
    ;|B0|B0|B0|B0 ( 0= 10 ceros, LITTLE endian)

    ;XMM1 los R, XMM2 los G, XMM3 los B

    ;tengo que shiftear...
    ;...los G, 6 a la derecha...
    ;...los B, 10 a la derecha

    psrlq xmm2, 6
    ;00g 00g 00g 00g (xmm2 Little, g ocupa 4bit)
    psrlq xmm3, 10
    ;|0B|0B|0B|0B ( 0= 10 ceros, LITTLE endian)


    ;luego: hacer un shuffle sobre un
    ;registro y escribo sobre memoria

    
    movdqu xmm14, [shuffleRed]
    pshufb xmm1, xmm14
    ; coloco en los bytes que corresponden al nuevo formato
    movdqu xmm14, [shuffleGreen]
    pshufb xmm2, xmm14
    ; coloco en los bytes que corresponden al nuevo formato

    movdqu xmm14, [shuffleBlue]
    pshufb xmm3, xmm14
    ; coloco en los bytes que corresponden al nuevo formato

    por xmm1, xmm2
    por xmm1, xmm3
    ;^^ resultado en xmm1
    movdqu [rsi + rbx], xmm1
    add rbx, 12
    add rcx, 8 
    jmp .ciclo

.fin:

  add rsp,8 
  pop rbx
  pop rbp
  ret
