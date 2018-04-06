;Michael Morrison Assignment 8 ASM
.586
.MODEL FLAT
INCLUDE io.h            ; header file for input/output
.STACK 4096

.DATA 
input1 DWORD   ?
nbrElts DWORD	0
count DWORD		0
prompt1 BYTE    "enter num for stack, 'p' to pop stack, or 'n' to show stack", 0
string  BYTE    40 DUP (?)
resultLbl BYTE  "The array is full at this many elements:", 0
resultLbl3 BYTE  "Next number in stack", 0
resultLbl4 BYTE  "Number popped off of stack:", 0
first     BYTE    11 DUP (?), 0
nullsy	  BYTE	  11 DUP (?), 0

.CODE
_MainProc PROC     
mov eax, 0
whilenotN:							;loop while input != n
			input   prompt1, string, 40      ; read ASCII characters
			atod    string         	 ; convert to integer
			mov input1, eax 

			cmp string, 110
			je displayfromstack		;leaves loop 

			cmp string, 112
			je popper		;leaves loop 

midwaypoint:
			mov eax, 1
			add eax, nbrElts
			mov nbrElts, eax		;adds to number of elements

			push input1				;pushes element on stack

			mov eax, 20
			cmp nbrElts, eax	
			jne whilenotN			;jumps back if number of elements is < 20
			jmp outofbounds

outofbounds: mov eax, 20
			 dtoa nullsy, eax
			 output resultLbl, nullsy	;for if array exceeds boundaries
		
displayfromstack:
			cmp nbrElts, 0
			je exitprogfinal		;until stack is empty

			pop eax				;pops elemnt from stack

			 dtoa first, eax
			 output  resultLbl3, first  	 ; output label and sum

			 mov eax, nbrElts
			 dec eax
			 mov nbrElts, eax			;decreases stack count

			 jmp displayfromstack

popper:		pop eax				;pops from stack

			 dtoa first, eax
			 output  resultLbl4, first  	 ; output label and sum

			 mov eax, nbrElts
			 dec eax
			 mov nbrElts, eax			;decreases stack count

			 jmp whilenotN

exitprogfinal:
	
        ret
_MainProc ENDP
END                             ; end of source code

