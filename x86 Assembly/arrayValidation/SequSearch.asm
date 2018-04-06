;Michael Morrison
.586
.MODEL FLAT
INCLUDE io.h            ; header file for input/output
.STACK 4096

.DATA 
input1 DWORD   ?
nbrElts DWORD	0
count DWORD		0
prompt1 BYTE    "enter any number to fill array or '0' to enter key value:", 0
prompt2 BYTE    "enter a key value or 'N'/'n' to close:", 0
string  BYTE    40 DUP (?)
nbrArr	DWORD 	50 DUP (?)
resultLbl BYTE  "key is in element", 0
resultLbl1 BYTE  "Not in array", 0
first     BYTE    11 DUP (?), 0

.CODE
_MainProc PROC     
mov ebx, 0
mov eax, 0
mov ecx, 0

	mov eax, 0			;sum := 0
	lea esi, nbrArr		;load array address

	input   prompt1, string, 40      ; read ASCII characters
	atod    string       		   ; convert to integer
	mov input1, eax 

whilenot0:						;loop while input != 0
			mov eax, 1
			add eax, nbrElts
			mov nbrElts, eax		;adds to number of elements

			mov ecx, nbrElts		;gives ecx the number of elements
			mov eax, input1			;gives eax the input
			mov nbrArr[4 * ecx], eax		;moves input to array index
			
			input   prompt1, string, 40      ; read ASCII characters
			atod    string         	 ; convert to integer
			mov input1, eax 

			cmp input1, 0		
			jne whilenot0		;jumps while input != 0
checkredo:
	input   prompt2, string, 40      ; read ASCII characters
	atod    string         	 ; convert to integer

	cmp string, 78				;ascii value
	je exitprog
	cmp string, 110	 		;ascii value
	je exitprog

	mov input1, eax		;inputs key

	lea esi, nbrArr		;loads array elements

			mov ecx, 0
			mov eax, input1

inarraycheck:	 cmp nbrElts, ecx		;makes sure the count is never greater than number of elemnts
				 je notinarray
				 inc ecx			;increments count in ecx
			     cmp eax, nbrArr[4 * ecx]		;checks if it is in the array
				 je inarray
				 
				 jmp inarraycheck

inarray:	 dec ecx		;NOT SURE IF YOU WANT ARRAY INDEX TO START AT 0 OR 1
			 mov eax, ecx			;gives index value to eax
			 dtoa first, eax
			 output  resultLbl, first   ; output label and sum

			 jmp exitprog

notinarray:	 mov eax, input1			;value is not in array
			 dtoa first, eax
			 output  resultLbl1, first  	 ; output label and sum
			 jmp checkredo				;retries scan if value is not in array

exitprog:	
        ret
_MainProc ENDP
END                             ; end of source code
