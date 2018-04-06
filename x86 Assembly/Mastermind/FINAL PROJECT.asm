.586
.MODEL FLAT
INCLUDE io.h            ; header file for input/output
.STACK 4096
.DATA 
;Colors (ascii value of colors)
Black BYTE 98     
Purple BYTE 112 
Green BYTE 103 
Tan BYTE 116       
Red BYTE 114 
Orange BYTE 111 
White BYTE 119 
Yellow BYTE 121 
;strings for I/O
stdin BYTE 11 DUP (?), 0
stdout BYTE 11 DUP (?), 0
;RNG Data
random  DWORD   4 DUP (?)
;input data
input_prompt BYTE    "Enter a four color guess. Choices: bpgtrowy", 0
;input_string BYTE 11 DUP (?)
invalid_input_message    BYTE "Your input was invalid, please try again.", 0
;invalid_input_message2 BYTE "Please use bpgtrowy"
;Game Logic
answer  BYTE  5 DUP (?), 0
guess   BYTE  5 DUP (?), 0
guesses DWORD   0               ;Number of Guesses
blackflags DWORD   0
whiteflags  DWORD   0
count DWORD   0
count2 DWORD   0
maxguesses DWORD   21
stringcopy BYTE 5 DUP (?), 0                    ;duplicate of key for white flag check
blackFlagsLbl BYTE    "Number of black flags:", 0
whiteFlagsLbl BYTE    "Number of white flags:", 0
victoryLbl BYTE  "You won in this many guesses:", 0
defeatLbl BYTE  "You used 20 guesses and lost. The answer was ", 0
temp     BYTE    11 DUP (?), 0
;ErrorMessage
errorLbl BYTE "An Error Occurred...", 0
NULL BYTE 0
.CODE
ERR_OUT MACRO;
    output NULL, errorLbl
    ENDM
;Random answer generation
;Credit: Geoff Huang, Gilbert Han
;   generate a random string of chars that represent 4 random colors
;   store answer in result
random_color_string MACRO result
    PUSHAD
    ;Generate a random string of colors
    ;random_number_generator rng_output
    lea esi, random     ; load the address of the first array element in esi
    mov ebx, 8          ; 8 is the divisor
    mov ecx, 4          ; run the for loop 4 times (generate 4 random numbers between 0 and 5)
    rng:    rdtsc               ; get the current timestamp and store in edx:eax
            mov edx, 0          ; prevent integer overflow
            ; the following code performs (random# % 6)
            div ebx         ; divide by 6 (remainder stored in edx)
            mov [esi], edx      ; move the remainder into the random array
            add esi, 4          ; point to the next element
            loop    rng         ; go to the next iteration of the for loop
    
    ;Loop through random[4] and
    ;Convert random numbers into ascii string of colors
    ;store result in result[4]
    mov ecx, 4          ; run the for loop 4 times (4 random numbers)
    lea esi, random     ; load the address of the source (random[4])
    lea edi, result     ; load the address of the destination (result[4])
    
    to_ascii:
    ;Compare random number in [esi] to 0-7 and convert to character in [edi] or result[4]
    mov eax, [esi]
    cmp eax, 0                  ;Check for Black    
    je got_Black
    mov eax, [esi]
    cmp eax, 1                  ;Check for Purple
    je got_Purple
    mov eax, [esi]
    cmp eax, 2                  ;Check for Green
    je got_Green
    mov eax, [esi]
    cmp eax, 3                  ;Check for Tan      
    je got_Tan
    mov eax, [esi]
    cmp eax, 4                  ;Check for Red
    je got_Red
    mov eax, [esi]
    cmp eax, 5                  ;Check for Orange
    je got_Orange
    mov eax, [esi]
    cmp eax, 6                  ;Check for White
    je got_White
    mov eax, [esi]
    cmp eax, 7                  ;Check for Yellow
    je got_Yellow
    ;End of checks reached-- Error
    ERR_OUT
    got_Black:
        mov al, Black
        jmp end_Colors
    got_Purple:
        mov al, Purple
        jmp end_Colors
    got_Green:
        mov al, Green
        jmp end_Colors
    got_Tan:
        mov al, Tan
        jmp end_Colors
    got_Red:
        mov al, Red
        jmp end_Colors
    got_Orange:
        mov al, Orange
        jmp end_Colors
    got_White:
        mov al, White
        jmp end_Colors
    got_Yellow:
        mov al, Yellow
        jmp end_Colors
    end_Colors:
    mov     [edi], al   ; store the random char in result[4]
    ;output outputLbl, randomstring ; display the contents of the array element
    ;store the ascii value into result
    ;increment pointers
    add esi, 4
    add edi, 1
    ;manually implement because jump distance is too far
    ;loop   to_ascii                ; go to the next iteration of the for loop
    dec ecx
    cmp ecx, 0
    jnz to_ascii
    POPAD
    ENDM
;Getting input and checking for errors
;Credit: Joseph Dandro
;   get input from user
;   check to make sure that the input represents a color
get_input MACRO input_string
    PUSHAD
    inputStart:                         ;Start the input loop, get input, check for valid input
        input input_prompt, input_string, 5     ;input_prompt followed by input_string (user input) with a total amount of input up to 4 characters + a null
        LEA ecx, input_string
        ;mov eax, 0                     ;Clear EAX so we can use it for comparisons, as we will use the AL part of EAX for char comparsions
        mov ebx, 0                      ;clear EBX so we can use it to count, done so as we loop within the program, don't want to start count at a number greater than 0
        inputValidStart:
            cmp ebx, 4                  ;we only want 4  characters
            je inputEnd                 ;if we are at 4 characters checked, we can exit here
            mov al, [ecx]               ;Move the character from the input string into the lower end of EAX, 1 character
            ;Check the input against each color
            cmp al, Black
            je inputIsValid
            cmp al, Purple
            je inputIsValid
            cmp al, Green
            je inputIsValid
            cmp al, Tan
            je inputIsValid
            cmp al, Red
            je inputIsValid
            cmp al, Orange
            je inputIsValid
            cmp al, White
            je inputIsValid
            cmp al, Yellow
            je inputIsValid             ;Each comparsion is follwed by a je, we only need to check for the valid characters, anything else is invalid
            ;We will reach the chunk of code if and only if the character was not valid, else it would have jumped to inputValid
            ;We will also reach here if the user input too little input
            output invalid_input_message, input_string  ;Output a statment saying the input was invalid, and show the invalid input
            input input_prompt, input_string, 5     ;prompt for NEW input
            lea ecx, input_string               ;reload the string into the ECX. so we start fresh
            mov ebx, 0                      ;Reset our counter
            jmp inputValidStart             ;jump to the start of validation
        
            inputIsValid:
            inc ebx
            add ecx, 1
            jmp inputValidStart
        ;inputValidEnd
    inputEnd:   ;end inputStuff
    POPAD
    ENDM
;Main game logic
;Credit: Michael Morrison, Christopher Anderson
;   Continuously compare guesses from user with a randomly generated answer
;   Gives the user feedback in the form of white and black flags
;   Flags indicate number of fully correct guesses (black flags)
;   and partially correct guesses (color, but not position) (white flags)
main_loop MACRO
untilguesscorrect:
            mov ebx, 0
            mov blackflags, ebx         ;resets flags
            mov whiteflags, ebx         ;resets flags
            mov eax, guesses
            inc eax
            mov guesses, eax            ;increment user guesses
            cmp eax, maxguesses         ;if user guesses == 20 game over
            je loser
    get_input guess
    othercheck:
                mov eax, 0
                mov ecx, 0
                mov ebx, 0
                mov count, ebx      ;resets count
                jmp blackflagcheck
    otc1:
                mov esi, 0          ;resets esi index for copying answer
                mov eax, 0
                mov ecx, 0
                mov ebx, 0
                mov count, ebx      ;resets count
                mov count2, ebx     ;resets count
    cpyloop:                        ;copies answer
                cmp count, 5
                je whiteflagcheckpre
                mov al, answer[esi]
                mov stringcopy[esi], al
                inc esi
                inc count
                jmp cpyloop
    otc2:       
                mov eax, whiteflags
                sub eax, blackflags
                mov whiteflags, eax         ;subtracts black flags from white to yield correct value
                jmp roundcomplete
    blackflagcheck:
                    mov al, answer[ebx]         ;key
                    cmp guess[ecx], al        ;guess
                    je addblackflag
    bfc1:
                    mov eax, count
                    inc eax
                    mov count, eax              ;increases count
                
                    inc ebx                     ;increment key index
                    inc ecx                     ;increment guess index
                    cmp count, 4                ;exit if count is 4
                    je otc1
                    jmp blackflagcheck
        
    addblackflag:   mov eax, blackflags
                    inc eax
                    mov blackflags, eax         ;blackflags + 1
                    jmp bfc1
    whiteflagcheckpre:
                    mov count, 0
    whiteflagcheck: 
                    mov al, stringcopy[ebx]         ;key COPY, to be editted upon successful result of flag check.
                    cmp guess[ecx], al          ;guess
                    je addwhiteflag
    wfc1:
                    mov eax, count
                    inc eax
                    mov count, eax              ;increases count for position in key
                    inc ebx
                    cmp count, 4
                    je wfc2                     ; move to next position in guess
                    jmp whiteflagcheck          
    wfc2:
                    mov eax, count2
                    inc eax
                    mov count2, eax             ;increases count for position in guess, only if a flag is added or if the key is exhausted
                    cmp count2, 4               ;check if all guesses have been made
                    je otc2                     ;exit condition
                    inc ecx                     ;increases guess index +1
                    mov ebx, 0                  ;resets key index
                    mov count, ebx              ;resets count for key
                    jmp whiteflagcheck
    addwhiteflag:   mov eax, whiteflags         
                    inc eax
                    mov whiteflags, eax         ;whiteflags + 1
                    mov al, 108
                    mov stringcopy[ebx], al     ;overwrite current space in key copy with unused character "l" upon first succesful result of white flag, in case duplicates are found in both the key and the guess.
                    jmp wfc2
    roundcomplete:  mov eax, blackflags
                    dtoa    temp, eax        ; convert to ASCII characters
                    output  blackFlagsLbl, temp  ; output label and sum
                    mov eax, whiteflags
                    dtoa    temp, eax        ; convert to ASCII characters
                    output  whiteFlagsLbl, temp  ; output label and sum
                
                    mov eax, 4
                    cmp blackflags, eax     
                    je complete                 ;exits if black flags are 4
                    jmp untilguesscorrect
        
    complete:
                    mov eax, guesses
                    dtoa    temp, eax
                    output  victoryLbl, temp  ; output label and sum
                    jmp progexit
    loser:
                    mov eax, maxguesses
                    dtoa    temp, eax
                    output  defeatLbl, answer  ; output label and answer
                    jmp progexit
    progexit:
    
            mov     eax, 0  ; exit with return code 0
            ret
    ENDM
;Mastermind
;Credit: Michael Morrison, Christopher Anderson, Geoff Huang, Gilbert Han
;Rules:
;   The computer generates a random string of colors
;   the user wins when they guess the correct string
;   If the user guesses incorrect, then the user is informed of two things
;       1) The number of guesses where position and color are correct.
;       2) The number of guesses where only color is correct.
;   The user has a maximum of 20 guesses
_MainProc PROC
    random_color_string answer
    main_loop
_MainProc ENDP
END                             ; end of source code