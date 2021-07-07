global listMultiMerge
global listGet
global arrayGet
global listNew
global listAddCardLast
global insertarIesimos
;%include "abi_enforcer.mac"
extern malloc
extern free

%define ListElemData 0
%define ListElemNext 8
%define ListElemPrev 16
%define OFF_ARRAY_SIZE 4

%define ListSize 4
%define ListFirst 8
%define ListLast 16

;%define 

section .text
listMultiMerge:
  push rbp
  mov rbp, rsp
  ;ALINEAR PILAAAAAA
  push r13
  push r14
  push r15
  push rbx
;rdx = listas (arr*)
  mov r15, 0 ; maxListLen
  mov rbx, 0 ; indice
  mov r14, rdi; listas
.ciclo:
  cmp bl, byte [r14+OFF_ARRAY_SIZE]
  je .fillListRes

  mov rdi, r14
  mov rsi, rbx
  call arrayGet

  cmp r15d, dword[rax+ListSize]
  jge .notMax
  mov r15d, dword[rax+ListSize]
.notMax:
  inc rbx
  jmp .ciclo

.fillListRes:
mov rdi, 1
call listNew

mov r13, rax
mov rbx, 0
.cicloEscritura:
  cmp rbx, r15
  jge .fin

  mov rdi, r14
  mov rsi, rbx
  mov rdx, r13
  call insertarIesimos

  inc rbx
  jmp .cicloEscritura

.fin:
  mov rax, r13
  pop rbx
  pop r15
  pop r14
  pop r13
  pop rbp
  ret



;----------AUX-------------
;void insertarIesimos(array_t* listas, int i, list_t* listRes)
insertarIesimos:
; rdi = listas (*arr)
; rsi = i
; rdx = listRes (*list)
push rbp
mov rbp, rsp
push rbx
push r12
push r13
push r14
;RECORDAR ALINEAR LA PILAAAA

mov rbx, 0
mov r12, rdi
mov r13, rsi
mov r14, rdx

.ciclo:
  cmp bl, byte[r12+OFF_ARRAY_SIZE]
  jge .fin

  mov rdi, r12
  mov rsi, rbx
  call arrayGet
  cmp rax, 0
  je .finciclo

  mov rdi, rax
  mov rsi, r13
  call listGet

  cmp rax, 0
  je .finciclo
  mov rdi, r14
  mov rsi, rax
  call listAddCardLast
    .finciclo:
    inc rbx
    jmp .ciclo
.fin:
pop r14
pop r13
pop r12
pop rbx
pop rbp
ret
;=====AUXILIARES del TP=======

; void* listGet(list_t* l, uint8_t i)
listGet:

    push rbp
    mov rbp, rsp

    mov r9,0
    mov r9d, dword [rdi+4]

    cmp rsi, r9
    JGE .finInvalido

    mov rcx, 0 
    mov rax, [rdi+8]
.ciclo:
    cmp rcx, rsi
    JE .finValido
    mov rax, [rax+8]
    inc rcx
    jmp .ciclo

.finInvalido:
    mov rax, 0
    jmp .fin

.finValido:
    mov rax, [rax]
    jmp .fin

.fin:
    pop rbp
    ret

; list_t* listNew(type_t t)
listNew:
    push rbp
    mov rbp, rsp
    ;type en rdi
    sub rsp, 8
    push rbx
    
    mov rbx, 0
    mov ebx, edi
    
    mov rdi, 24
    call malloc

    mov dword [rax], ebx
    mov dword [rax+4], 0
    mov qword [rax+8], 0
    mov qword [rax+16], 0

    
    pop RBX
    add rsp, 8
    pop rbp
ret

; void* arrayGet(array_t* a, uint8_t i)
arrayGet:
    push rbp
    mov rbp, rsp
    
    mov r8, rsi
    cmp byte [rdi+4], r8b
    jle .retCero

    mov r9, [rdi+8]
    
    mov rax, [r9+rsi*8]
    jmp .fin

.retCero:
    mov rax,0

.fin:
    pop rbp

ret

listAddCardLast:
    ;armamos el stackframe
    push rbp
    mov rbp,rsp
    push rbx
    push r12
    ;programa
    mov rbx, rdi    ;preservamos registros
    mov r12, rsi

; creamos nuevo nodo
    mov rdi, 24
    call malloc ; guardamos espacio para elem y ahora tenemos en rax su puntero
    mov [rax+ListElemData], r12
    mov qword [rax+ListElemPrev], 0
    mov qword [rax+ListElemNext], 0


    ; guardamos el anterior ultimo y conectamos el prev del nuevo nodo a este



    cmp byte [rbx + ListSize], 0
    jne .noVacia
    mov [rbx+ ListFirst], rax    ; si la lista esta vacia el nuevo elem es el First
    jmp .fin

.noVacia:
    mov rdi, [rbx+ ListLast]
    mov [rax+ListElemPrev], rdi 
    ;si el size es mayor a cero entonces el elem que esta ultimo tiene que conectar su next con el nuevo

    mov [rdi+ListElemNext], rax

.fin:
    mov [rbx+ ListLast], rax


    inc byte [rbx + ListSize]
    ;desarmamos stackframe
    pop r12
    pop rbx
    pop rbp
ret
