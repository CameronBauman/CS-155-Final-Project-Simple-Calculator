; CS-155 Final Project
; By Cameron Bauman
; Spring 2025
; LC3-Calculator
; Using LC3Tools
; This program was designed to preform arithmetic operations based on user input
; This program can preform addition, subtraction, multiplication, and division

.ORIG x3000

; Calculator Hub ______________________________________________________
LOOP
    ; Displays the menu for operations
    ; Enter operator (+, -, /, *): 
    JSR MENU
    
    ; Asks for user input
    JSR USERINPUT
    
    
    ; Asks for which operation they want to do
    JSR OPERATOR
    
    ; Prompts user if they want to continue
    JSR CONTINUE
    
    ; This code loads the ASCII of y into R1
    ; This for uppercase Y
    ; LD R1, YESCAPS
    ; NOT R1, R1
    ; ADD R1, R1, #1
    ;n ADD R1, R0, R1
    ; BRz LOOP
    
    ; This for lowercase y
    ; LD R1, YESLOWER
    ; NOT R1, R1
    ; ADD R1, R1, #1
    ; ;ADD R1, R0, R1
    ; BRz LOOP
    
    ; Program End
    ;JSR NEWLINEPRINT
    TRAP x25
    
; ASCII for y for the continue prompt
; ASCII code for uppercase Y
YESCAPS .FILL x0059
; ASCII code for lowercase y
YESLOWER .FILL x0079

; MENU stuff ______________________________________________________
MENU
    ; Prints the menu message
    LEA R0, MENUMSG
    TRAP x22
    
    RET

MENUMSG .STRINGZ "\nEnter operator (+, -, /, *): "
    
; USERINPUT stuff ______________________________________________________
USERINPUT
    ; Prompts user input
    TRAP x20
    TRAP x21
    
    RET

; Addition stuff ______________________________________________________
ADDING
    ; Display prompt for first num
    LEA R0, ADDFIRSTNUM
    TRAP x22
    
    ; User enters first number
    JSR USERNUM
    ADD R2, R0, #0
    
    ; Display prompt for second num
    LEA R0, ADDSECNUM
    TRAP x22
    
    ; User enters second number
    JSR USERNUM
    ADD R3, R0, #0
    
    ; Perform addition
    ADD R4, R2, R3
    
    ; Display Result
    LEA R0, ADDRESULT
    TRAP x22
    JSR PRINT
    
    
    RET
    
; Addition ASCII
ADDFIRSTNUM .STRINGZ "\nEnter first number (0-9): "
ADDSECNUM .STRINGZ "\nEnter second number (0-9): "
ADDRESULT .STRINGZ "\nAddition result: "

; Subtraction stuff ______________________________________________________
SUBTRACT

    ; Display prompt for first num
    LEA R0, SUBFIRSTNUM
    TRAP x22
    
    ; User enters first number
    JSR USERNUM
    ADD R2, R0, #0
    
    ; Display prompt for second num
    LEA R0, SUBSECNUM
    TRAP x22
    
    ; User enters second number
    JSR USERNUM
    ADD R3, R0, #0

    ; Perform subtraction
    ; Set R4 to first Number
    AND R4, R4, #0
    ADD R4, R2, #0
    
    ; Turn second number into its negative version
    NOT R3, R3
    ADD R3, R3, #1

    ; Compute the operation
    ADD R4, R4, R3
    ; If result is not negative
    BRzp SUBPRINT
    
    ; If result is negative
    LD R0, MINUS
    TRAP x21
    ; Turn result positive
    NOT R4, R4
    ADD R4, R4,  #1
    
    
    SUBPRINT
        ; Display Result
        LEA R0, SUBRESULT
        TRAP x22
        JSR PRINT
    
    RET
    
; Subtraction ASCII
SUBFIRSTNUM .STRINGZ "\nEnter first number (0-9): "
SUBSECNUM .STRINGZ "\nEnter second number (0-9): "
SUBRESULT .STRINGZ "\nSubtraction result: "

; OPERATOR stuff ______________________________________________________
OPERATOR
    ; Checks to see if ASCII + was inputed
    LD R1, PLUS
    NOT R1, R1
    ADD R1, R1, #1
    ADD R1, R0, R1
    BRz ADDING
    
    ; Checks to see if ASCII - was inputed
    LD R1, MINUS
    NOT R1, R1
    ADD R1, R1, #1
    ADD R1, R0, R1
    BRz  SUBTRACT
    
    ; Checks to see if ASCII / was inputed
    LD R1, DIVIDE
    NOT R1, R1
    ADD R1, R1, #1
    ADD R1, R0, R1
    BRz  DIVISION
    
    ; Checks to see if ASCII * was inputed
    LD R1, MULT
    NOT R1, R1
    ADD R1, R1, #1
    ADD R1, R0, R1
    BRz  MULTIPLY
    
    LEA R0, ERRMSG
    TRAP x22
    
    RET
    
; ASCII for +
PLUS .FILL x002B 
; ASCII for -
MINUS .FILL x002D
; ASCII for /         
DIVIDE .FILL x002F
; ASCII for *
MULT .FILL x002A

ERRMSG .STRINGZ "\nInvalid operator. Please try again."

; Division stuff ______________________________________________________
DIVISION
    ; Display prompt for first num
    LEA R0, DIVFIRSTNUM
    TRAP x22
    
    ; User enters first number
    JSR USERNUM
    ADD R2, R0, #0
    
    ; Display prompt for second num
    LEA R0, DIVSECNUM
    TRAP x22
    
    ; User enters second number
    JSR USERNUM
    ADD R3, R0, #0
    
    ; Checks if it is division by 0
    ADD R1, R3, #0
    BRz DIVZERO
    
    ; Getting R4 ready
    AND R4, R4, #0
    
    ; Setting up division before DIVIDELOOP
    NOT R6, R3
    ADD R6, R6, #1
    
    DIVIDELOOP
        ADD R5, R2, R6
        BRn DIVIDEFINISH
        ADD R2, R5, #0
        ADD R4, R4, #1
        BR DIVIDELOOP
        
    DIVIDEFINISH
         LEA R0, DIVRESULT
         TRAP x22
         JSR PRINT
    
    RET
    
    DIVZERO
        LEA R0, DIVIDEZERO
        TRAP x22
        
    RET

; Division ASCII
DIVFIRSTNUM .STRINGZ "\nEnter first number (0-9): "
DIVSECNUM .STRINGZ "\nEnter second number (0-9): "
DIVIDEZERO .STRINGZ "\nError: You cannot divide by 0."
DIVRESULT .STRINGZ "\nDivision result: "

; Multiplication stuff ______________________________________________________
MULTIPLY
    ; Display prompt for first num
    LEA R0, MULTFIRSTNUM
    TRAP x22
    
    ; User enters first number
    JSR USERNUM
    ADD R2, R0, #0
    
    ; Display prompt for second num
    LEA R0, MULTSECNUM
    TRAP x22
    
    ; User enters second number
    JSR USERNUM
    ADD R3, R0, #0
    
    ; Check to see if multiplying by 0
    ADD R1, R2, #0
    BRz MULTIPLYZERO
    
    ADD R1, R3, #0
    BRz MULTIPLYZERO
    
    ; Zero out R4 before calculations
    AND R4, R4, #0
    ADD R1, R3, #0
    
    MULTIPLYLOOP
        ADD R4, R4, R2
        ADD R1, R1, #-1
        BRp MULTIPLYLOOP
        BRnzp MULTPRINT
    
    MULTIPLYZERO
        AND R4, R4, #0
        
    MULTPRINT
        LEA R0, MULTRESULT
        TRAP x22
        JSR PRINT
    
    RET

; Multiplication ASCII
MULTFIRSTNUM .STRINGZ "\nEnter first number (0-9): "
MULTSECNUM .STRINGZ "\nEnter second number (0-9): "
MULTRESULT .STRINGZ "\nMultiplication result: "

; USERNUM stuff ______________________________________________________
USERNUM
    ; Reads ASCII user imputed and changes it into its numeric value
    TRAP x20
    TRAP x21
    ; Two's complimenting ASCII zero to make the R1 value
    ; which holds the binary value of ASCIIZERO negative
    LD R1, ASCIIZERO
    NOT R1, R1
    Add R1, R1, #1
    ; add the values together
    ADD R0, R0, R1
    
    RET

; PRINT stuff ______________________________________________________
PRINT
    ; Checking if R4 is single digit
    ADD R5, R4, #-10
    BRn SINGLEDIGIT
    ; if it is not single digit prepare more registers
    ; for printing
    AND R6, R6, #0
    ADD R7, R4, #0
    
    MULTIPLEDIGITS
        ; Substracts 10 from R7 and puts result into R5
        ; and checks to see if we have finished with the double digits
        ADD R5, R7, #-10
        BRn FINISHPRINT
        ; if not add 1 to R6 which is for the tens digit
        ; and loop
        ADD R6, R6, #1
        ADD R7, R5, #0
        BR MULTIPLEDIGITS
    
    FINISHPRINT
        ; converts both R6 and R7 to ASCII and prints
        ; First load ASCIIZERO to R1
        LD R1, ASCIIZERO
        ; Print tens value
        ADD R0, R6, R1
        TRAP x21
        ; Print ones value
        ADD R0, R7, R1
        TRAP x21
        
        RET

    SINGLEDIGIT
        LD R1, ASCIIZERO
        ADD R0, R4, R1
        TRAP x21
        
        RET
        
; ASCII code for 0
ASCIIZERO .FILL x0030

; CONTINUE stuff ______________________________________________________
CONTINUE
    ; Asks if user wants to continue and prompts user for input
    LEA R0, CONTINUEPROMPT
    TRAP x22
    TRAP x20
    
    RET

; Continue ASCII
CONTINUEPROMPT .STRINGZ "\nPerform another calculation? (Y/N): "

; NEWLINE stuff ______________________________________________________
; NEWLINEPRINT
    ; LD R0, NEWLINE
    ; TRAP x21
    
    ; RET
; Make a new line
; NEWLINE .FILL x000A

.END
