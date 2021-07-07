global xtmk
extern malloc
section .rodata
cuatrosPS: times 4 dd 0x00000004


section .text
xtmk: ; rdi -> x ; rsi -> t 
      ; rdx -> m ; rcx -> k
  push rbp
  mov rbp, rsp
  push r13
  push r14
  push r15
  push rbx



  mov r15, rcx ; r15 -> k
  mov r14, rdx ; r14 -> m

  mov rcx, 0 ; j
  mov rbx, 0 ; i


  ;--------Espacio de R-------

  push rdi
  push rsi
  push rdx
  push rcx
  mov rdi, 57600 ; 120*120*4
  call malloc
  mov r11, rax
  pop rcx
  pop rdx
  pop rsi
  pop rdi
  ;---------------------------

  .unaFila:
    cmp rcx, 120
    je .nuevaFila

    .extraerXyT:  
      ;extraere 2 elementos de x
      mov rax, rbx
      mov r9, 480d;4*120 = tamanio dato * tamanio fila
      mul r9
      lea rax,[rax+rcx*4] ; rax + tamanio dato * indice columna

      pxor xmm2, xmm2
      movq xmm2, [rdi+rax] ; 2 dwords = 2 elem de x
      ; tengo en xmm2 (en el qword + bajo) 2 elem de x

      ;ahora extraere 2 elementos de t
      mov rax, rbx
      mov r9, 240 ; 2 * 120 = tamanio dato * tamanio fila
      mul r9
      lea rax,[rax+rcx*2]
      pxor xmm3, xmm3
      movd xmm3, [rsi+rax]
      ;tengo en xmm3 en el dword + bajo 2 elem de t
      ;antes de operar, los pasare a floats

      CVTDQ2PS xmm2, xmm2 ; convertir en floats
      ;para convertir los word de xmm3 en floats primero
      ;tengo que convertirlos en dwords mediante upacks...
      pxor xmm4, xmm4
      PUNPCKLWD xmm3, xmm4
      CVTDQ2PS xmm3, xmm3

    xor r9, r9
    xor r10, r10

    ; j / 4 en r9
    mov r9, rcx
    shr r9, 1

    ; i / 4 en r10
    mov r10, rbx
    shr r10, 1


    ;cmp 
    mov rax, r10
    mov r10, 240 ; 60 * 4 (largo fila * tamanio dato)
    mul r10

    lea r9, [r9*4+rax] 

    pxor xmm5, xmm5 ; 
    movd xmm5, [r14+r9]; levanto 1 float
    pxor xmm7,xmm7 ; voy a broadcastearlo
    movdqu xmm7, xmm5
    PSLLDQ xmm7, 4
    pxor xmm5, xmm7



; seteo en cero r9 y r10
; para ...
;...limpiar eventuales
; acarreos de numeros
    xor r9, r9
    xor r10, r10

    ; j / 4 en r9
    mov r9, rcx
    shr r9, 2

    ; i / 4 en r10
    mov r10, rbx
    shr r10, 2


    ;cmp 
    mov rax, r10
    mov r10, 30
    mul r10

    lea r9, [r9+rax]
    mov r9b, byte [r15+r9]
    

    cmp r9, 128
    jg .esMayor


;ya tengo convertidos los dos elem de x y de t en xmm2 y xmm3 
; respectivamente
    

    .sino:  

    movdqu xmm4, [cuatrosPS]
    CVTDQ2PS xmm4, xmm4

    mulps xmm3, xmm4
    subps xmm2, xmm3
    divps xmm2, xmm5
    
    jmp .WriteAndIncrem

    .esMayor:

    movdqu xmm4, [cuatrosPS]
    CVTDQ2PS xmm4, xmm4

    mulps xmm3, xmm4
    addps xmm2, xmm3
    divps xmm2, xmm5
    
  




  .WriteAndIncrem:
      mov rax, rbx
      mov r9, 480d;4*120 = tamanio dato * tamanio fila
      mul r9
      lea rax,[rax+rcx*4] ; rax + tamanio dato * indice columna

      movq [r11+rax], xmm2
    
      add rcx, 2; pues voy haciendo de a 2 elementos
      jmp .unaFila

  .nuevaFila:
    inc rbx
    cmp rbx, 120
    je .fin
    mov rcx, 0
    jmp .unaFila



.fin:
  mov rax, r11

  pop rbx
  pop r15
  pop r14
  pop r13
  pop rbp
  ret
