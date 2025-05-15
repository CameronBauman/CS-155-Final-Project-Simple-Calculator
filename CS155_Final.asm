; CS-155 Final Project
; By Cameron Bauman
; Spring 2025
; LC3-Calculator
; Using LC3Tools
; This program was designed to preform arithmetic operations based on user input
; This program can preform addition, subtraction, multiplication, and division

.ORIG x3000

; Initialize stack pointer (R6)
LD R6, STACK

; Calculator Hub ______________________________________________________
; This is the Hub for the calculator
; This code branches out into the many other functions that this code contains
; Everything comes back to this code when it is done
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
    LD R1, YESCAPS
    NOT R1, R1
    ADD R1, R1, #1
    ADD R1, R0, R1
    BRz LOOP
    
    ; This for lowercase y
    LD R1, YESLOWER
    NOT R1, R1
    ADD R1, R1, #1
    ADD R1, R0, R1
    BRz LOOP
    
    ; Program End
    TRAP x25
    
; ASCII for y for the continue prompt
; ASCII code for uppercase Y
YESCAPS .FILL x0059
; ASCII code for lowercase y
YESLOWER .FILL x0079
; Stack 
STACK .FILL xFE00

; MENU stuff ______________________________________________________
; This menu prints out the menu for operation selection
MENU
    ; Save return address to the stack
    ADD R6, R6, #-1
    STR R7, R6, #0
    
    ; Prints the menu message
    LEA R0, MENUMSG
    TRAP x22
    
    ; Restore return address and return
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET

MENUMSG .STRINGZ "\nEnter operator (+, -, /, *): "
    
; USERINPUT stuff ______________________________________________________
; This code accepts an keybord input for operations
USERINPUT
    ; Save return address to the stack
    ADD R6, R6, #-1
    STR R7, R6, #0
    
    ; Prompts user input
    TRAP x20
    TRAP x21
    
    ; Restore return address and return
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET

; Addition stuff ______________________________________________________
; this code takes 2 integers between 0-9 to perform addition
ADDING
    ; Save return address to the stack
    ADD R6, R6, #-1
    STR R7, R6, #0
    
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
    

    ; Restore return address and return
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET
    
; Addition ASCII
ADDFIRSTNUM .STRINGZ "\nEnter first number (0-9): "
ADDSECNUM .STRINGZ "\nEnter second number (0-9): "
ADDRESULT .STRINGZ "\nAddition result: "

; Subtraction stuff ______________________________________________________
; this code takes 2 integers between 0-9 to perform subtraction
SUBTRACT
    ; Save return address to the stack
    ADD R6, R6, #-1
    STR R7, R6, #0

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
    
    ; Display Result
    LEA R0, SUBRESULT
    TRAP x22
    
    ; If result is negative
    ADD R5, R4, #0
    BRzp SUBPOSITIVE
    
    ; Print minus sign and convert to positive
    LD R0, MINUS
    TRAP x21
    NOT R4, R4
    ADD R4, R4, #1
    
SUBPOSITIVE
    JSR PRINT
    
    ; Restore return address and return
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET
    
; Subtraction ASCII
SUBFIRSTNUM .STRINGZ "\nEnter first number (0-9): "
SUBSECNUM .STRINGZ "\nEnter second number (0-9): "
SUBRESULT .STRINGZ "\nSubtraction result: "

; OPERATOR stuff ______________________________________________________
; This is the Hub for operation detection
; Depending on users input for operations
; This code will filter where the PC should jump to
OPERATOR
    ; Save return address to the stack
    ADD R6, R6, #-1
    STR R7, R6, #0
    
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
    
    ; Restore return address and return
    LDR R7, R6, #0
    ADD R6, R6, #1
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
; this code takes 2 integers between 0-9 to perform division
DIVISION
 ; Save return address to the stack
    ADD R6, R6, #-1
    STR R7, R6, #0
    
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
    ; Changed R6 to R5
    NOT R5, R3
    ADD R5, R5, #1
    
    DIVIDELOOP
        ; Changed R5 to R1
        ADD R1, R2, R5
        BRn DIVIDEFINISH
        ADD R2, R1, #0
        ADD R4, R4, #1
        BR DIVIDELOOP

    DIVZERO
        LEA R0, DIVIDEZERO
        TRAP x22

    ; Restore return address and return
    LDR R7, R6, #0
    ADD R6, R6, #1

    RET

    DIVIDEFINISH
         LEA R0, DIVRESULT
         TRAP x22
         JSR PRINT
    
    
    ; Restore return address and return
    LDR R7, R6, #0
    ADD R6, R6, #1

    RET

; Division ASCII
DIVFIRSTNUM .STRINGZ "\nEnter first number (0-9): "
DIVSECNUM .STRINGZ "\nEnter second number (0-9): "
DIVIDEZERO .STRINGZ "\nError: You cannot divide by 0."
DIVRESULT .STRINGZ "\nDivision result: "

; Multiplication stuff ______________________________________________________
; this code takes 2 integers between 0-9 to perform multiplication
MULTIPLY
    ; Save return address to the stack
    ADD R6, R6, #-1
    STR R7, R6, #0
    
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
    
    ; Getting R4 and R1 ready for calculations
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
    
    ; Restore return address and return
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET

; Multiplication ASCII
MULTFIRSTNUM .STRINGZ "\nEnter first number (0-9): "
MULTSECNUM .STRINGZ "\nEnter second number (0-9): "
MULTRESULT .STRINGZ "\nMultiplication result: "

; USERNUM stuff ______________________________________________________
; This code accepts a keyboard input from the user expecting a number between 0-9
USERNUM
    ; Save return address to the stack
    ADD R6, R6, #-1
    STR R7, R6, #0
    
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
    
    ; Restore return address and return
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET

; PRINT stuff ______________________________________________________
; This code prints out the results of the arithmetic operations
PRINT
    ; Save return address to the stack
    ADD R6, R6, #-1
    STR R7, R6, #0
    
    ; Checking if R4 is single digit
    ADD R5, R4, #-10
    BRn SINGLEDIGIT
    ; if it is not single digit prepare more registers
    ; for printing
    AND R1, R1, #0 
    ADD R5, R4, #0 
    
    MULTIPLEDIGITS
        ; Substracts 10 from R5 and puts result into R0
        ADD R0, R5, #-10
        BRn FINISHPRINT
        ; if not add 1 to R1 which is for the tens digit
        ; and loop
        ADD R1, R1, #1
        ADD R5, R0, #0
        BR MULTIPLEDIGITS
    
    FINISHPRINT
        ; converts both R1 and R5 to ASCII and prints
        ; First load ASCIIZERO to R0
        LD R0, ASCIIZERO
        ; Print tens value
        ADD R0, R1, R0
        TRAP x21
        ; Print ones value
        LD R0, ASCIIZERO
        ADD R0, R5, R0
        TRAP x21
        

    ; Restore return address and return
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET

    SINGLEDIGIT
        LD R0, ASCIIZERO
        ADD R0, R4, R0
        TRAP x21
        

    ; Restore return address and return
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET
        
; ASCII code for 0
ASCIIZERO .FILL x0030

; CONTINUE stuff ______________________________________________________
; This code is for the Hub loop which loops when user presses either y or Y
; This code only prints the string for performing another calculation and 
; allows user to give a keyboard input
CONTINUE
    ; Save return address to the stack
    ADD R6, R6, #-1
    STR R7, R6, #0
    
    ; Asks if user wants to continue and prompts user for input
    LEA R0, CONTINUEPROMPT
    TRAP x22
    TRAP x20
    
    ; Restore return address and return
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET

; Continue ASCII
CONTINUEPROMPT .STRINGZ "\nPerform another calculation? (Y/N): "

.END
