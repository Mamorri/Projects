;Prototype Mastermind 2.0
; Credit Michael Morrison

.586
.MODEL FLAT

INCLUDE io.h            ; header file for input/output

.STACK 4096

.DATA 
number1 DWORD   ?
number2 DWORD   ?
blackflags DWORD   0
whiteflags	DWORD	0
prompt2 BYTE    "Enter 4 letters guess", 0
prompt1 BYTE    "Enter key 4 letters", 0

string  BYTE    40 DUP (?)
string2 BYTE	40 DUP (?)
resultLbl BYTE  "The sum is", 0
resultLbl3 BYTE    "Number of black flags:", 0
resultLbl4 BYTE    "Number of white flags:", 0
resultLbl5 BYTE  "you won", 0
temp     BYTE    11 DUP (?), 0

.CODE
_MainProc PROC

		input   prompt1, string, 40      ; read ASCII characters

untilguesscorrect:
       
        input   prompt2, string2, 40      ; read ASCII characters

		mov ecx, 0
		mov ebx, 0

		jmp check2

check1: cmp ecx, 4
		je roundcomplete

		inc ecx
		mov ebx, 0
		
check2:	
		mov al, string[ebx]			;key
		cmp string2[ecx], al		;guess
		je addblackflag

		mov al, string[ebx]			;key
		cmp string2[ecx], al		;guess
		je addwhiteflag

		inc ebx

		cmp ebx, 4
		je check1

	  	mov eax, 4
		cmp blackflags, eax
		je complete
		jmp check1
		
		
addblackflag:	mov eax, blackflags
				inc eax
				mov blackflags, eax			;blackflags + 1

				mov eax, 4
				cmp blackflags, eax
				je complete					;if (blackflags == 4)     END

				inc ebx
				jmp check2


addwhiteflag:	mov eax, whiteflags			
				inc eax
				mov whiteflags, eax			;whiteflags + 1
				
				inc ebx
				jmp check2


roundcomplete:  mov eax, blackflags
				dtoa    temp, eax        ; convert to ASCII characters
				output  resultLbl3, temp  ; output label and sum

				mov eax, whiteflags
				dtoa    temp, eax        ; convert to ASCII characters
				output  resultLbl4, temp  ; output label and sum

				jmp untilguesscorrect
		

complete:
				output  resultLbl5, temp  ; output label and sum
	
        mov     eax, 0  ; exit with return code 0
        ret
_MainProc ENDP
END                             ; end of source code