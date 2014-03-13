TITLE Random Number Sort    (randSort.asm)

; Author: Ray Foote
; Course / Project ID				CS271_400, Homework 5                 Date:  Feb. 26, 2014
; Description: This program generates numbers in the range [100...999], displays the original list
; sorts the list and calculates the median value.  Finally it diplays the list  sorted in descending order.

INCLUDE Irvine32.inc

USR_MIN = 10
USR_MAX = 200
RAND_HI = 999
RAND_LOW = 100

.data

		progTitle		BYTE			"Random Number Sort", 0
		progName		BYTE			"Programmed by Ray Foote", 0
		userInst		BYTE			"Enter a number in the range [10...200].  This program will ", 0
		userInst2		BYTE			"generate your number of random numbers .  Then it will display this list, ", 0
		userInst3		BYTE			"sort it, find its median value and display it, finally it will display it", 0
		userInst4		BYTE			"in descending order. ", 0
		numPrompt		BYTE			"Enter number: ",0
		request			DWORD			?				; user number input
		errorRange		BYTE			"Out of range.  Enter a number in the range [10...200]: ", 0
		randList		DWORD		USR_MAX		DUP(?)
		randCount		DWORD			0	
		unsortedDisp		BYTE			"The unsorted random numbers: ", 0
		medianDisp		BYTE			"The median is: ", 0
		sortedDisp		BYTE			"The sorted list: ", 0	

.code

main PROC
		push		OFFSET progTitle
		push		OFFSET progName
		push		OFFSET userInst
		push		OFFSET userInst2
		push		OFFSET userInst3
		push		OFFSET userInst4
		call		greeting

		push		OFFSET numPrompt
		push		OFFSET errorRange
		push		OFFSET request
		call		getNums

		call		Randomize			; generate random seed (just once outside call)
		push		OFFSET randList
		push		request
		call		randFill

		push		OFFSET unsortedDisp
		push		OFFSET randList
		push		request
		call		display

		push		OFFSET randList
		push		request
		call		selectSort

		push		OFFSET medianDisp
		push		OFFSET randList
		push		request
		call		median
	
		push		OFFSET sortedDisp
		push		OFFSET randList
		push		request
		call		display

		exit	; exit to operating system
main ENDP

; Description: Prints program tite, programmer name and instructions
; Required: On Stack: progTitle, progName, userInst, userInst2-4 on stack in order
; Returns: console write, each string
; Preconditions: none
; Registers changed: none (uses pushad)
	greeting PROC
		pushad
		mov		ebp, esp			; set up stack pointer

		mov		edx, [ebp + 56]
		call		WriteString
		mov		al, 9
		call		WriteChar
		call		WriteChar
		mov		edx, [ebp + 52]
		call		WriteString
		call		CrLf
		call		CrLf
		mov		edx, [ebp + 48]
		call		WriteString
		call		CrLf
		mov		edx, [ebp + 44]
		call		WriteString
		call		CrLf
		mov		edx, [ebp + 40]
		call		WriteString
		call		CrLf
		mov		edx, [ebp + 36]
		call		WriteString
		call		CrLf
		popad
		ret		24
	greeting ENDP

; Description: Asks user to enter a number in range [USR_MIN...USR_MAX]
; validates it to be in range, then stores the number by reference in userNum
; Required: USR_MIN, USR_MAX.  On stack: numPrompt, errorRange, request
; Returns: request stores the validated integer
; Preconditions: reference to request is on top of stack
; Registers changed: none (uses pushad)
	getNums PROC
		pushad
		mov		ebp, esp			; set up stack pointer
L1:
		mov		edx, [ebp + 44]
		call		WriteString
		call		ReadInt
		mov		ebx, [ebp + 36]							
		mov		[ebx], eax			; pushad (32) request DWORD (4)
		mov		ecx, [ebx]			; mov userNum preparing for loop
		mov		eax, [ebx]			; loop check
		cmp		eax, USR_MAX			; less than USR_MAX
		jle		L2
		mov		edx, [ebp + 40]
		call		WriteString
		call		CrLf
		jmp		L1
L2:	
		cmp		eax, USR_MIN			; greater than USR_MIN
		jge		L3
		mov		edx, [ebp + 40]
		call		WriteString
		call		CrLf
		jmp		L1
L3:
		popad													; popad (-32) leaves 4 on stack
		ret		12
	getNums ENDP

; Description: fills randList with random numbers in the range [RAND_LOW...RAND_HIGH]
; Required: RAND_LOW, RAND_HIGH, On Stack: request, randList
; Returns: randList is populated with [request] number of random integers in range.
; Preconditions: references to request, randList are on top of stack
; Registers changed: none (uses pushad)
	randFill	PROC	
		pushad
		mov		ebp, esp
		mov		edi, [ebp + 40]
		mov		ecx, [ebp + 36]			; ecx makes loop repeat [request] times
	more:
		mov		eax, RAND_HI
		inc		eax
		mov		ebx, RAND_LOW
		sub		eax, ebx				
		call		RandomRange			; (re-used my own code from assignment 1)
		add		eax, 100
		mov		[edi], eax
		add		edi, 4
		loop		more
	endMore:
		popad
		ret		8
	randFill	ENDP

; Description: displays randList
; Required: On Stack: (offset of text intro), request, randList
; Returns: display of numbers sequentially in randList
; Preconditions: references to request, randList are on top of stack
; Registers changed: none (uses pushad)
	display	PROC	
		pushad
		mov		ebp, esp

		mov		edx, [ebp + 44]			; write list intro string
		call		WriteString
		call		CrLF
		mov		esi, [ebp + 40]			; @ randList
		mov		ecx, [ebp + 36]			; ecx makes loop repeat [request] times
	more:
		mov		eax, [esi]			; contents of current element in randList
		call		writeDec
		mov		al, 9				; '9' is the ASCII 'tab' decimal
		call		WriteChar
		add		esi, 4
		loop		more
	endMore:
		call		CrLf
		popad
		ret		12
	display	ENDP

; Description: selection sort algorithm
; Required: on Stack: request, randList
; Returns: sorts the randList numbers 
; Preconditions: references to request, randList are on top of stack
; Registers changed: none (uses pushad)
	selectSort		PROC
		pushad
		mov		ebp, esp
		mov		ecx, [ebp + 36] 		; set outer loop count (request - 1)
		dec		ecx
		mov		esi, [ebp + 40]
		mov		edx, 0
		
	Outer:							; begin outer loop
		push		edx
		push		ecx				; save outer loop count
		mov		eax, [esi]			; current 'i'
		mov		ecx,  [ebp + 36]		; set inner loop count
	Inner:
		add		edx, 4
		mov		ebx, [esi + edx]		; current 'j'
		cmp		ebx, 0 
		je		Break
		cmp		eax, ebx
		jl		NoSwap
		xchg		eax, ebx
		mov		[esi], eax
		mov		[esi + edx], ebx
	NoSwap:
		loop		Inner				; repeat inner loop
	Break:
		pop		ecx				; restore outer loop count
		pop		edx
		add		esi, 4
		loop		Outer				; repeat outer loop

		popad
		ret		12

	selectSort		ENDP

; Description: median display
; Required: on Stack: medianDisp, request, randList (in sorted order, ascending or descending)
; Returns: median of list, 
; Preconditions: references to request, randList and medianDisp are on top of stack
; Registers changed: none (uses pushad)
	median		PROC
		pushad
		mov		ebp, esp

		mov		edx, [ebp + 44]			; write list intro string
		call		WriteString

		mov		esi, [ebp + 40]			; @ randList
		mov		eax, [ebp + 36]
		cdq
		mov		ebx, 2
		div		ebx
		cmp		edx, 0
		je		isEven
		mov		ebx, 4
		mul		ebx
		mov		edx, eax
		mov		eax, [esi + edx]
		jmp		endPoint
	isEven:
		mov		ebx, 4
		mul		ebx
		mov		edx, eax
		mov		eax, [esi + edx]
		mov		ebx, [esi + edx - 4]
		add		eax, ebx
		cdq
		mov		ebx, 2
		div		ebx
		cmp		edx, 1
		jl		endPoint
		inc		eax
	endPoint:
		call		WriteDec
		call		CrLf
		call		CrLf
		popad
		ret		12
	median	ENDP


END main

