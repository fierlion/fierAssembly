TITLE Prime Numbers    (primes.asm)

; Author: Ray Allan
; Course / Project ID       CS271_400, Homework 4                 Date: Feb 11, 2014
; Description: This program takes and validates user input int 'n' [1...200] then calculates 
; and displays all the prime numbers up to and including the 'nth' prime, 10 primes per line.
; followed by the count of primes and a goodbye.

INCLUDE Irvine32.inc

UPPER_LIMIT = 200

.data

progTitle		BYTE			"Prime Numbers", 0
progName		BYTE			"Programmed by Ray Allan", 0
userInst		BYTE			"Enter the number (in the range [1...200]) of primes you would like to see.", 0
numPrompt		BYTE			"Enter number: ",0
userNum			DWORD			?				; user number input
userNumDec		DWORD			?				; user number decrement divisor
primeLoop		DWORD			?				; outer loop counter
current			DWORD			?
currentDec		DWORD			?
isntPrime		DWORD			0
numPrimes		DWORD			0				; count of primes
errorRange		BYTE			"Out of range.  Enter a number in the range [1...200]: ", 0
outro1			BYTE			"That's all ", 0
outro2			BYTE			" of them.",0
outro3			BYTE			"Goodbye."

.code

	main PROC
		call		greeting
		call		getNums
		call		primes
		call		goodbye
		exit														; exit to operating system
	main ENDP


; Description: Prints program tite, programmer name and instructions
; Required: progTitle, progName, userInst
; Returns: console write, each string
; Preconditions: none
; Registers changed: none
	greeting PROC
		pushad
		mov		edx, OFFSET progTitle
		call		WriteString
		mov		al, 9
		call		WriteChar
		call		WriteChar
		mov		edx, OFFSET progName
		call		WriteString
		call		CrLf
		call		CrLf
		mov		edx, OFFSET userInst
		call		WriteString
		call		CrLf
		popad
		ret
	greeting ENDP

; Description: Asks user to enter a number in range [1...UPPER_LIMIT]
; validates it to be in range, then stores the number in userNum
; Required: UPPER_LIMIT, userNum, userNumDec
; Returns: userInt stores the validated integer
; Preconditions: none
; Registers changed: (uses eax, edx)
	getNums PROC
		pushad
L1:
		mov		edx, OFFSET numPrompt
		call		WriteString
		call		ReadInt
		mov		userNum, eax
		mov		userNumDec, eax
		mov		ecx, userNum				; mov userNum preparing for loop
		mov		eax, userNum				; loop check
		cmp		eax, UPPER_LIMIT			; less than UPPER_LIMIT
		jle		L2
		mov		edx, OFFSET errorRange
		call		WriteString
		call		CrLf
		jmp		L1
L2:	
		cmp		eax, 0					; greater than 0
		jg		L3
		mov		edx, OFFSET errorRange
		call		WriteString
		call		CrLf
		jmp		L1
L3:
		popad
		ret
	getNums ENDP

; Description: calls isPrime for a user specified number of times, prints primes in user range
; Required: userNum, isPrime PROC
; Returns: nothing, prints primes to console
; Preconditions: current, currentDec are available
; Registers changed: uses eax, (isPrime uses ecx)
	primes PROC
		pushad
		mov		eax, userNum
		mov		current, eax
Top:
		mov		eax, current
		mov		current, eax
		mov		currentDec, eax							
		call		isPrime					; call to isPrime
		mov		eax, isntPrime
		cmp		eax, 0
		jg		Nope
		mov		eax, current
		call		WriteDec
		inc		numPrimes
		mov		al, 9					; '9' is the ASCII 'tab' decimal
		call		WriteChar
Nope:
		mov		eax, current
		dec		eax
		mov		current, eax
		cmp		eax, 1
		je		Outro
		jmp		Top
Outro:
		popad
		ret
	primes ENDP

; Description: A test for primes
; Required: current=currentDec, isntPrime = 0
; Returns: isntPrime = 1 if number isn't prime, else isntPrime=0
; Preconditions: 
; Registers changed: none
	isPrime PROC
		pushad
		mov		isntPrime, 0
		mov		eax, current
		dec		eax
		mov		ecx, eax				; set up loop (userNum -1)
Top:
		mov		eax, current
		cdq
		mov		ebx, currentDec
		dec		ebx
		div		ebx
		mov		currentDec, ebx
		cmp		edx, 0
		je		P1
		loop		Top
P1:
		cmp		eax, current
		je		P4
		mov		isntPrime, 1
P4:
		loop		Top					; counting loop (1 to n) implemented using MASM loop instuction
		popad
		ret
	isPrime ENDP

; Description: farewell to the user
; Required: userNum, outro1,2,3
; Returns: writes to console outro1,2,3 and userNum
; Preconditions: userNum is unchanged from initial entry
; Registers changed: none
	goodbye PROC
		pushad
		call		CrLf
		mov		edx, OFFSET outro1
		call		WriteString
		mov		eax, numPrimes
		call		WriteDec
		mov		edx, OFFSET outro2
		call		WriteString
		call		CrLf
		mov		edx, OFFSET outro3
		call		WriteString
		call		CrLf
		popad
		ret
	goodbye ENDP

END main
