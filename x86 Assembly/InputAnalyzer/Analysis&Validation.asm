;Michael Morrison
.586
.MODEL FLAT
INCLUDE io.h            ; header file for input/output
.STACK 4096

.DATA 
input1 DWORD   ?
nbrElts DWORD	0
count DWORD		0
numevens DWORD	0
numodds DWORD	0
prompt1 BYTE    "enter any number to fill array or '0' to stop entering:", 0
string  BYTE    40 DUP (?)
nbrArr	DWORD 	21 DUP (?)
resultLbl BYTE  "The array is full at this many elements:", 0
resultLbl1 BYTE  "Not in array", 0
resultLbl3 BYTE  "Number cant be negative", 0
resultLbl4 BYTE  "Number of evens", 0
resultLbl5 BYTE  "Number of odds", 0
first     BYTE    11 DUP (?), 0
nullsy	  BYTE	  11 DUP (?), 0

.CODE
_MainProc PROC     
mov ebx, 0
mov eax, 0
mov ecx, 0

whilenot0:						;loop while input != 0

			input   prompt1, string, 40      ; read ASCII characters
			atod    string         	 ; convert to integer
			mov input1, eax 

			cmp eax, 0		
			jl numisnegative		;jumps while input != 0
			cmp input1, 0
			je exitprog		;leaves loop

	dtoa string, eax
	AND al, 01H        ;0000 0001
					   ;1111 0111
					   ;0000 0001
	jz jmpEvn
	jmp jmpOdds

midwaypoint:
			mov eax, 1
			add eax, nbrElts
			mov nbrElts, eax		;adds to number of elements


			mov ecx, nbrElts		;gives ecx the number of elements
			mov eax, input1			;gives eax the input
			mov nbrArr[4 * ecx], eax		;moves input to array index


			mov eax, 20
			cmp nbrElts, eax	
			jne whilenot0			;jumps back if number of elements is < 20
			jmp outofbounds

numisnegative:
			mov eax, input1			;value is not in array
			 dtoa first, eax
			 output  resultLbl3, first  	 ; output label and sum
			 jmp whilenot0
jmpEvn:							;increments evens
			mov eax, numevens
			inc eax
			mov numevens, eax
			jmp midwaypoint

jmpOdds:						;increments odds
		mov eax, numodds
			inc eax
			mov numodds, eax
			jmp midwaypoint

outofbounds: mov eax, 20
			 dtoa nullsy, eax
			 output resultLbl, nullsy	;for if array exceeds boundaries

exitprog:	
			 mov eax, numevens			;value is not in array
			 dtoa first, eax
			 output  resultLbl4, first  	 ; output label and sum

			 mov eax, numodds			;value is not in array
			 dtoa first, eax
			 output  resultLbl5, first  	 ; output label and sum
	
        ret
_MainProc ENDP
END                             ; end of source code

