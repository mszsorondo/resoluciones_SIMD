global cardContains
global cardCmp
global arrayGet
global cardNew
global listNew
global strClone
global intClone
global listGetSize

extern malloc
extern free

%define OFF_ARRAY_SIZE 4
%define OFF_LIST_SIZE 4

%define OFF_CARD_STACKED 16
%define OFF_LIST_FIRST 8
%define OFF_NODE_DATA 0
%define OFF_NODE_NEXT 8
section .text
cardContains: ;rdi -> mazo
              ;rsi -> carta
              ;rdx -> level (*int)
  push rbp
  mov rbp, rsp
  push r12
  push r13
  push r14
  push r15
  push rbx
  sub rsp, 8
  ;ALINEAR PILA ACORDATEEEEEEEEEEEEE
  

  mov r13, rdi; mazo
  mov r14, rsi; carta
  mov r15, rdx; level

  mov r12, -1 ; levelFound
  mov rbx, 0 ; contador
  


.cicloMazo:
  cmp bl, byte [r13 + OFF_ARRAY_SIZE]
  je .fin
  cmp r12, -1
  jne .fin

  mov rdi, r13
  mov rsi, rbx
  call arrayGet

  ;en rax tengo actual
  
  mov rdi, rax
  mov rsi, r14
  mov rdx, 0

  call depthFound

  mov r12, rax

  inc rbx
  jmp .cicloMazo

.fin:
  mov [r15], r12d
  cmp r12, -1
  je .false
  mov rax, 1
  jmp .true

.false:
  mov rax, 0
.true:
  add rsp, 8
  pop rbx
  pop r15
  pop r14
  pop r13
  pop r12
  pop rbp
  ret




depthFound:; dada una carta con stackeadas y una carta a buscar, devuelve la profundidad en la que se encuentra (y si no esta devuelve -1)
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    push rbx
    sub rsp, 8
    ;ALINEAR LA PILA TIO ALINEAAAAAAAR

    ;cartaConStack en rdi
    ;buscada en rsi
    ;currentDepth en rdx

    mov r12, rdi 
    mov r13, rsi
    xor r14,r14
    mov r14, rdx
    mov r15, -1 ; depth


    ;mov rdi, r12 creo que puede prescindir de...
    ;mov rsi, r13 ... estas dos instrucciones
    call cardCmp

    cmp rax, 0
    je .finFound

    mov r9, [r12+OFF_CARD_STACKED] ; puntero a stacked
    cmp dword [r9+OFF_LIST_SIZE],0 ; comparo el largo de la lista
    jle .finNotFound

    
    mov r10, [r12 + OFF_CARD_STACKED]
    mov rbx, [r10 + OFF_LIST_FIRST];currentNode
    .ciclo:
        cmp rbx, 0
        je .finStackedNotNull
        cmp r15, -1
        jne .finStackedNotNull

        mov rdi, [rbx+OFF_NODE_DATA];currentCard
        mov rsi, r13
        mov r11, r14 ; currentDepth
        inc r11
        mov rdx, r11

        call depthFound

        mov r15,rax
        mov rbx, [rbx+OFF_NODE_NEXT]
        jmp .ciclo

.finStackedNotNull:
    mov rax, r15
    jmp .fin
.finNotFound:
    mov rax, -1
    jmp .fin
.finFound:
    mov rax, r14

.fin:

    add rsp, 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret





;----------------Auxiliares------------------





;-----------------AUXILIARES del TP-----------------------
; int32_t intCmp(int32_t* a, int32_t* b)
intCmp:
    PUSH RBP
    MOV RBP, RSP
    SUB RSP, 8
    PUSH RBX

    MOV EBX, [RDI]
    CMP EBX, [RSI]
    JZ cero
    JG menosUno
    MOV EAX, 1
    JMP fin
    cero:
        MOV EAX, 0
        JMP fin
    menosUno:
        MOV EAX, -1
    fin:
        
    POP RBX
    ADD RSP, 8
    POP RBP
    ret

; uint32_t strLen(char* a)
strLen:
    PUSH RBP
    MOV RBP , RSP
    MOV RCX, 0
.comp:
    CMP byte [RDI+RCX], 0
    JE .fin
    
    inc RCX
    jmp .comp

.fin:
    mov rax, rcx
    POP RBP
    ret

; int32_t strCmp(char* a, char* b)
strCmp:
    push rbp
    mov rbp, rsp
    sub rsp, 8
    push r12
    push r13
    push r14
    push r15
    push rbx
  

    mov r13, rsi 
    mov r15, rdi
    
    call strLen

    mov r12, rax ;longitud de a

    mov rdi, r13 

    call strLen
    mov r14, rax ;longitud de b


    mov rsi, r13
    mov rdi, r15
    
    inc r14
    inc r12
    CMP r14, r12
    JLE .minA
    mov rcx, r12
    mov rbx, 0
.ciclo:
    mov al, byte [rdi+rbx]
    CMP al, byte [rsi+rbx]
    JG .aEsMayor
    JL .bEsMayor
    inc rbx
    CMP rcx, rbx
    JG .ciclo

    cmp r14, r12
    JG .aEsMayor
    JL .bEsMayor
    mov RAX, 0
    jmp .fin

.aEsMayor:
    MOV rax, -1
    jmp .fin

.bEsMayor:
    mov rax, 1
    jmp .fin

.minA:
    mov rcx, r14
    mov rbx, 0
    JMP .ciclo

.fin:
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
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


listGetSize:
    push rbp
    mov rbp, rsp

    cmp rdi, 0
    je .listaInvalida

    mov rax, 0
    mov eax, dword [rdi + 4]
    jmp .fin

    .listaInvalida:
    mov rax, 0

.fin:
pop rbp
ret

cardCmp:
    push rbp
    mov rbp, rsp
    push r12
    push r13

    mov r12, rdi
    mov r13, rsi

    mov rdi, [rdi]
    mov rsi, [rsi]
    call strCmp

    cmp rax, 0
    JNE .fin

    mov rdi, [r12+8]
    mov rsi, [r13+8]
    call intCmp

.fin:
    pop r13
    pop r12
    pop rbp
    ret

; card_t* cardNew(char* suit, int32_t* number)
cardNew:
    PUSH RBP
    MOV RBP, RSP
    push r12
    push r13
    push r14
    push r15

    mov r12, rdi
    mov r13, rsi
    
    call strClone
    mov r14, rax

    mov rdi, r13
    call intClone
    mov r15, rax

    mov rdi, 24
    call malloc

    mov [rax], r14
    mov [rax+8], r15
    mov r14, rax

    mov rdi, 3
    call listNew
    mov [r14+16], rax

    mov rax, r14

    pop r15
    pop r14
    pop r13
    pop r12

    POP RBP
    RET

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
; char* strClone(char* a)
strClone:
    push rbp
    mov rbp, rsp  
    sub rsp, 8
    push r12
    

    mov rsi, rdi

    mov r12, rdi

    call strLen 

    mov rdi, rax
    inc rdi
    call malloc


    mov rcx, 0

.ciclo:
    mov dl, [r12+rcx]
    mov [rax+rcx], dl
    inc rcx
    cmp dl, 0
    jne .ciclo


.fin:
    pop r12
    add rsp, 8
    pop rbp
    ret


strDelete:
    push rbp
    mov rbp, rsp
    call free
    pop rbp
    ret

; int32_t* intClone(int32_t* a)
intClone:
    PUSH RBP
    MOV RBP, RSP
    SUB RSP, 8
    PUSH RBX

    mov ebx, [RDI]
    mov rdi, 4
    call malloc
    mov [rax], ebx

    POP RBX
    ADD RSP, 8
    POP RBP
ret
;--------------------------------------------------