;Prototype Mastermind 
; Michael Morrison, Group 3
.586
.MODEL FLAT

INCLUDE io.h            ; header file for input/output

.STACK 4096

.DATA 

blackflags DWORD   0
whiteflags	DWORD	0
count DWORD   0
count2 DWORD   0
guesses DWORD   0
maxguesses DWORD   21

prompt2 BYTE    "Enter 4 letters guess", 0
prompt1 BYTE    "Enter key 4 letters", 0

string  BYTE    40 DUP (?)
string2 BYTE	40 DUP (?)

resultLbl BYTE  "The sum is", 0
resultLbl3 BYTE    "Number of black flags:", 0
resultLbl4 BYTE    "Number of white flags:", 0
resultLbl5 BYTE  "you won in this many guesses:", 0
resultLbl6 BYTE  "you used 20 guesses and lost", 0
temp     BYTE    11 DUP (?), 0

.CODE
_MainProc PROC

		input   prompt1, string, 40      ; enter key

untilguesscorrect:

		mov ebx, 0
		mov blackflags, ebx			;resets flags
		mov whiteflags, ebx			;resets flags

		mov eax, guesses
		inc eax
		mov guesses, eax			;increment user guesses

		cmp eax, maxguesses			;if user guesses == 20 game over
		je loser
       
        input   prompt2, string2, 40      ; enter guess

		
othercheck:
			mov eax, 0
			mov ecx, 0
			mov ebx, 0
			mov count, ebx		;resets count

			jmp blackflagcheck
otc1:
			mov eax, 0
			mov ecx, 0
			mov ebx, 0
			mov count, ebx		;resets count
			mov count2, ebx		;resets count

			jmp whiteflagcheck
otc2:		
			mov eax, whiteflags
			sub eax, blackflags
			mov whiteflags, eax			;subtracts black flags from white to yield correct value

			jmp roundcomplete


blackflagcheck:
				mov al, string[ebx]			;key
				cmp string2[ecx], al		;guess
				je addblackflag
bfc1:
				mov eax, count
				inc eax
				mov count, eax				;increases count
				
				inc ebx						;increment key index
				inc ecx						;increment guess index

				cmp count, 4				;exit if count is 4
				je otc1

				jmp blackflagcheck


		
addblackflag:	mov eax, blackflags
				inc eax
				mov blackflags, eax			;blackflags + 1

				jmp bfc1



whiteflagcheck:	
				mov al, string[ebx]			;key
				cmp string2[ecx], al		;guess
				je addwhiteflag
wfc1:
				mov eax, count
				inc eax
				mov count, eax				;increases count

				mov eax, count2
				inc eax
				mov count2, eax				;increases count

				cmp count2, 16
				je otc2

				;cmp ebx, ecx
				;je otc2						;exit condition

				inc ebx
				cmp count, 4
				je wfc2

				jmp whiteflagcheck

wfc2:
				inc ecx						;increases guess index +1
				mov ebx, 0					;resets key index
				mov count, ebx				;resets count

				jmp whiteflagcheck


addwhiteflag:	mov eax, whiteflags			
				inc eax
				mov whiteflags, eax			;whiteflags + 1

				jmp wfc1


roundcomplete:  mov eax, blackflags
				dtoa    temp, eax        ; convert to ASCII characters
				output  resultLbl3, temp  ; output label and sum

				mov eax, whiteflags
				dtoa    temp, eax        ; convert to ASCII characters
				output  resultLbl4, temp  ; output label and sum

				
			 	mov eax, 4
				cmp blackflags, eax		
				je complete					;exits if black flags are 4

				jmp untilguesscorrect
		

complete:
				mov eax, guesses
				dtoa	temp, eax
				output  resultLbl5, temp  ; output label and sum
				jmp progexit

loser:
				mov eax, maxguesses
				dtoa	temp, eax
				output  resultLbl6, temp  ; output label and sum
				jmp progexit

progexit:
	
        mov     eax, 0  ; exit with return code 0
        ret
_MainProc ENDP
END                             ; end of source code