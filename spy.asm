SEG00   SEGMENT BYTE PARA PUBLIC USE16 'CODE'
        ASSUME CS:SEG00,DS:SEG00,ES:SEG00
        .8086
        org 100h
start:  mov ax,0fff0h                   ; 
        mov bx,0ffffh                   ;
        mov cx,0ffffh                   ; AX-BX-CX FFFFh per vedere se siamo
        int 21h                         ; installati
        cmp ax,0aaa0h                   ; se in ax c'e' AAA0h, lo siamo, ma..
        jz cantrem
        cmp ax,0aaaah                   ; se in ax c'e' AAAAh, lo siamo
        jnz notinst
remove: mov es,cx                       ; in CX c'e' il segmento del tsr
        mov ax,4900h                    ; 2149h DOS - Libera la memoria
        int 21h
        lea dx,str2                     ; DX = ^string2
        call writestr                   ; Stampa la stringa
        jmp bye

cantrem:
        lea dx,str4                     ; DX = ^string4
        call writestr                   ; Stampa la stringa
        mov ax,4c01h                    ; Esce con errore
        int 21h                         

notinst:
        mov ax,3c00h                    ; Apre snoop.lst
        xor cx,cx                       ; Azzera CX
        mov dx,offset nome              ; 
        xor bx,bx                       ; DS:BX = nome del file da aprire
        int 21h                         ; DOS OPEN AH = 3Ch
        jnz bye                         ; Zero ? esci!
        mov bx,ax                       ; e lo richiude
        mov ax,4000h                    ; WRITE TO FILE  AH = 40h
        lea dx,str3                     ; DS:BX = ^string
        mov cx,str3e-str3               ; Bytes da scrivere
        int 21h
        mov ax,3e00h                    ; DOS CLOSE AH = 3Eh
        xor cx,cx
        xor dx,dx
        int 21h                         ; CLOSE FILE
        mov ah,62h                      ; chiedi l'address del Program Segment Prefix
        int 21h                         ; seg in BX
        mov es,bx                       ; lo metti in ES
        mov es,es:[2Ch]                 ; leggi l'address dell'environment..
        mov ah,49h                      ; free memory
        int 21h                         ; NOW !        
        mov ax,3400h                    ; Prende l'indirizzo del DOS ACTIVE
        int 21h                         ; FLAG.
        mov word ptr cs:activ,bx        ; store IP
        mov word ptr cs:activ+2,es      ; store CS
        mov ax,5d06h                    ; Prende l'indirizzo del Critical
        int 21h                         ; Error handler
        mov word ptr cs:criti,si        ; Salva l'offset
        mov word ptr cs:criti+2,ds      ; Salva il segmento
        lea dx,str1                     ; ^DX = Stringa 1 
        call writestr
        mov ax,3521h                    ; 2135xxh DOS - return int. handler
        int 21h                         ; in ES:BX
        mov word ptr cs:orig,bx         ; Salva l'indirizzo dell'int handler
        mov word ptr cs:orig+2,es       ; originale
        mov dx,OFFSET NEWINT            ; Offset del nuovo interrupt handler
        mov ax,2521h                    ; 2125xxh DOS - Setta ind. INT HANDLER
        int 21h                         ; SET INTERRUPT HANDLER AH = 25h
        mov dx,endprog-start
        add dx,100h
        int 27h                         ; 27DX DOS - Go tsr, DX paragraphs
bye:    mov ax,4c00h
        int 21h

writestr:
        mov ax,900h
        push cs
        pop ds
        int 21h
        ret

NEWINT: cmp ax,0fff0h                   ; in caso in cui si voglia
        jnz snoop                       ; deinstallare il programma 
        cmp bx,0ffffh                   ; AX,CX devono essere 0FFFFh BX = 0
        jnz snoop                       ; a questo punto si deve saltare        
        cmp cx,0ffffh                   ; alla "subroutine" per reinstallare        
        jnz snoop                       ; l'handler vecchio
        jmp restore                     ; ( Reinstallare il vecchio ) 
snoop:  cli
        push ax                         ; ( Procediamo per lo snoop )
        push bx                         ; Salva AX e BX        
        lea bx,snooptab                 ; BX = ^ tabella delle funz. interes.
ciclo:  mov al,byte ptr cs:[bx]         ; AL =  *tabella delle funz. interes.
        cmp ah,al                       ; COND = ( AH == AL )
        jz match                        ; IF ( COND )
        inc bx                          ; TABPTR++ 
        test al,al                      ; COND = ( AL == 0  )
        jnz ciclo                       ; IF ( COND )
back:
        call stackrestore
        jmp dword ptr cs:orig

match:  sub bx,OFFSET snooptab          ; Qual'e' la funzione ?
        mov word ptr cs:tmpbx,bx
        shl bx,1                        ; BX *= 2     =)
        add bx,OFFSET jumptab           ;
        call openout                    ; Chiama la funzione per aprire il
                                        ; file di Snoop
        jmp cs:[bx]                     ; qui AX e BX (originali) nello stack

READ:
        call stackrestore
OPEN:
        call stackrestore
        call tabflags
        call getfirst
        cli
        pushf
        call dword ptr cs:orig
        pushf
        call tstcarry
        call closef
        popf
        sti
        retf 2

RENA:   ; DS:DX   ES:DI
        call stackrestore
        call getfirst
        call tabflags
        push ds
        push dx
        mov dx,es
        mov ds,dx
        mov dx,di
        call getfirst
        pop dx
        pop ds
        cli
        pushf
        call dword ptr cs:orig
        pushf
        call tstcarry
        popf
        sti
        retf 2

getfirst:
        push cx
        push dx
        push ds
        push bx
        mov bx,dx
        call strlen
        call writeout
        pop bx
        pop ds
        pop dx
        pop cx
        ret

tabflags:
        push bx
        push cx
        push dx
        push ds
        mov dx,word ptr cs:tmpbx
        lea bx,strtab
        shl dx,1
        add bx,dx
        mov dx,word ptr cs:[bx]
        mov cx,7
        push cs
        pop ds
        call writeout
        pop ds
        pop dx
        pop cx
        pop bx
        ret

tstcarry:
        push cx
        push dx
        push ds
        jc car
        lea dx,okay
        jmp wri
car:    lea dx,fail
wri:
        mov cx,7
        push cs
        pop ds
        call writeout
        pop ds
        pop dx
        pop cx
        ret

closef: 
        push ax
        push bx
        mov ax,3e00h
        mov bx,word ptr cs:handle
        cli
        pushf
        call dword ptr cs:orig
        call stackrestore
        ret

openout:

        call waitdone                   ; Aspetta i flags DOS
        push ds
        push cx                         ; Salva CX originale
        push dx                         ; Salva DX originale
        mov ah,3dh                      ; Open existing file 12h = Read/Write
        mov al,33                       ; Write Only, PROHIBIT WRITE
        push cs                         ;
        pop ds                          ; DS = CS
        xor cx,cx                       ; CX = 0
        lea dx,nome                     ; DX = &"c:\spy.lst"
        cli                             ; Clear Interrupts
        pushf
        call dword ptr cs:orig          ; Chiama il vecchio handler
        jnc opened                      ; Fallito ?
fall:   mov ax,3c00h                    ; Lo crea se non esiste
        push cs
        pop ds
        xor cx,cx
        lea dx,nome
        cli
        pushf
        call dword ptr cs:orig          ; Chiama il vecchio handler
        jnc opened
        pop dx
        pop cx
        pop ds
        add sp,2                        ; Leviamo l'indirizzo del RET
        jmp back                        ; Chiama il vecchio interrupt
opened: mov word ptr cs:handle,ax       ; Handle del file SPY.LST
        push ax
        push bx
        mov bx,ax
        mov ax,4202h                               ; LSEEK
        xor cx,cx
        xor dx,dx
        call waitdone                   ; Aspetta i flags DOS
        cli
        pushf
        call dword ptr cs:orig                     ; Int 21h
        call stackrestore
        pop dx
        pop cx
        pop ds
        ret                                        ; Tutto ok, ritorniamo su

; CX    = Numero di bytes da scrivere
; DS:DX = Buffer

writeout:
        call waitdone
        push ax
        push bx
        mov ax,4000h                  ; WRITE TO FILE AH = 40h
        mov bx,word ptr cs:handle     ; BX = Handle del file
        cli
        pushf
        call dword ptr cs:orig
        call stackrestore
        ret

strlen: xor cx,cx
        push ax
        push bx
m2:     mov al,byte ptr ds:[bx]
        inc cx
        inc bx
        test al,al
        jnz m2
        call stackrestore
        ret

waitdone:
        push ax
        push bx
        push ds
wai: 
        mov bx,word ptr cs:activ
        mov ds,word ptr cs:activ+2
        mov al,byte ptr ds:[bx]
        mov bx,word ptr cs:criti
        mov ds,word ptr cs:criti+2
        mov ah,byte ptr ds:[bx]
        test ax,ax
        jnz wai
        pop ds
        call stackrestore
        ret

restore:
        mov ax,3521h
        cli
        pushf
        call dword ptr cs:orig         ; SIMULA INT 21h
        mov ax,cs
        mov bx,es
        cmp ax,bx
        jz remo
        mov ax,0aaa0h
        iret
remo:   mov ax,WORD PTR [cs:orig+2]    ; AX = Offset del vecchio handler
        mov ds,ax                      ; DS = AX
        mov dx,WORD PTR [cs:orig]      ; DX = Segmento del vecchio handler
        mov ax,2521h                   ; SET INTERRUPT HANDLER AH = 25h
        cli
        pushf
        call dword ptr cs:orig         ; Chiama l'interrupt h. vecchio
        mov ax,0aaaah                  ; Risposta = Siamo installati (AX)
        lea bx,start                   ; Inizio del programma        (BX)
        mov cx,cs                      ; Segmento da deallocare      (CX)
        sti
        retf 2                         ; Ritorna al programma principale

stackrestore:
        mov bx , sp
        mov ax , ss:[bx+4]
        mov bx , ss:[bx+2]
        ret 4

activ:  dw 0,0
criti:  dw 0,0
orig:   dd 0
handle: dw 0
tmpbx:  dw 0
tmpfl:  dw 0
curfun: db 0
str1:   db 'Spy versione 1.5 By Stefano Crosara in 1996-1997 aKa mOoNsHaDo',13,10,'Installato sull''Int 21h','$'
str2:   db 'Spy rimosso correttamente',13,10,'$'
str3:   db 'Spy versione 1.5 By Stefano Crosara in 1996-1997 aKa mOoNsHaDo',13,10,13,10
str3e:
str4:   db 'Impossibile rimuovere SPY un altro programma ha il controllo dell''interrupt 21h$'
nome:   db 'C:\spy.lst',0
fail:   db 'FAIL ',13,10
okay:   db 'OKAY ',13,10
stra:   db 'OPEN   '
strb:   db 'CREATE '
strc:   db 'DELETE '
strd:   db 'RENAME '
stre:   db 'MAKDIR '
strf:   db 'REMDIR '
strg:   db 'CD-DIR '
strh:   db 'FINDFR '
snooptab: db  3dh,  3ch,  41h,  56h,  39h,  3ah,  3bh, 4eh , 0 , 03fh , 0
jumptab:  dw OPEN, OPEN, OPEN, RENA, OPEN, OPEN, OPEN, OPEN, READ
;            OPEN  CREA  DELE  RENA  MDIR  RDIR  CDIR, FINF, READ
strtab:   dw stra ,strb ,strc ,strd ,stre ,strf, strg, strh
endprog:
        SEG00 ends
; 0F  = Open file                           Using FCB
; 10  = Close file                          Using FCB
; 11  = Find First                          Using FCB
; 12  = Find Next                           Using FCB
; 13  = Del. file                           Using FCB
; 14  = Seq. read                           Using FCB
; 15  = Seq. write                          Using FCB
; 16  = Creat/Trunc file                    Using FCB
; 17  = Rename file                         Using FCB
; 19  = Get Current Default Drive           Using FCB
; 1B  = Get Alloc. info for Default Drive   Using FCB
; 1C  = Get Alloc. info for Specific Drive  Using FCB
; 21  = Random Read                         Using FCB
; 22  = Random Write                        Using FCB
; 23  = Get File Size                       Using FCB
; 25  = Set Interrupt Vector
; 27  = Random Read                         Using FCB
; 28  = Random Write                        Using FCB
; 31  = Go TSR
; 32  = Get Dos Drive PBlock for Sp. Drive
; 35  = Get Interrupt Vector
; 36  = Get Free Disk Space
; 39  = Make Directory                                  *
; 3A  = Remove Directory                                *
; 3B  = Change Directory                                *
; 3C  = Create/Truncate File
; 3D  = Open File                                       *
; 3E  = Close File                                      *
; 3F  = Read From File
; 40  = Write to File/Device
; 41  = Delete file                                     *
; 42  = Seek into file
; 44  = ALL
; 47  = Get current directory
; 4E  = FindFirst
; 4F  = FindNext
; 56  = Rename a file                                   *
; 5B  = Create a file                                   *
        end start
