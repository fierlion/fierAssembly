TITLE Low Level/Macro     (readVal.asm)

; Author: Ray Allan
; Course / Project ID				CS271_400, Homework 6A                 Date:  Mar. 7, 2014
; Description: This program implements readInteger/writeInteger procedures for unsigned integers.  It also uses macros for getString and displayString.
; The included test program gets 10 valid integers from the user and stores the values in an array, then it displays the integers, their sum, and average.

INCLUDE Irvine32.inc

displayString MACRO buffer
	push		edx
	mov		edx, OFFSET buffer	
	call		WriteString
	pop		edx
ENDM

getString MACRO varName
	push		ecx
	push		edx
	mov		edx, OFFSET varName
	mov		ecx, (SIZEOF varName)-1
	call		readString
	pop		edx
	pop		ecx
ENDM

NUM_INTS = 10
BUFSIZE = 11

.data
buffer			BYTE		BUFSIZE		DUP(?)
userLength		DWORD		?														; user input length
errorRange		BYTE		"I don't think that's a 32-bit number. Try again.", 0
userNum			DWORD		0
userCharInt		BYTE		BUFSIZE		DUP(?)
userIntArr		DWORD		NUM_INTS	DUP(?)


.code
main PROC
	
		getString	buffer
	
		INVOKE	Str_length, ADDR buffer			; get real length of user string
		mov		userLength, eax			; put in eax
		
		push		OFFSET userNum
		push		OFFSET errorRange
		push		OFFSET buffer
		push		userLength
		call		readInteger			; read Integer returns userNum with the userInt
		mov		esi, OFFSET userIntArr
		mov		eax, [esi]
		call		WriteDec
	
		push		userLength			; write Integer as char string
		push		OFFSET userCharInt
		push		userNum
		call		writeInteger
	
		displayString userCharInt

	
	exit	; exit to operating system
	
main ENDP

; Description:  gets user integer (the SUPER! hard way) using lodsd and stosd
; Required: On Stack: userLength (Str_length userInpt), offset userInpt
; Returns: int equivalent of string in userNum
; Preconditions: references to OFFSET userNum, OFFSET errorRange
; OFFSET buffer, and userLength on stack, also input int cannot exceed 999,999,999
; Registers changed: none (uses pushad)
	readInteger	PROC
		pushad
		mov		ebp, esp
		mov		esi, [ebp + 48]	
		mov		eax, 0						
		mov		[esi], eax			; reset userNum data
		cld						; direction = forward
		mov		esi, [ebp + 40]			; offset buffer
		mov		edi, esi			; destination index
		mov		ecx, [ebp + 36]			; loop counter = userLength
		mov		eax, ecx
		cmp		ecx, 0
		je		ERROR
		cmp		ecx, 10
		jge		ERROR				; largest 32 bit int is 2,147,483,647 easiest to check for length 9
	L1:  
		lodsb						; the hard part (business end of this proc)
		cmp		al, 30h
		jl		ERROR
		cmp		al, 39h
		jg		ERROR
		sub		al, 30h				; check 0-9
		movzx		ebx, al				; clean register
		mov		eax, ebx
		push		eax								
		push		ecx				; save outer loop
								; get decimal place
		cmp		ecx, 1				; the following code returns 10 ^ (ecx -1) power in eax register
		je		ONE
		dec		ecx
		mov		eax, 1
		push		eax
	L2:
		pop		eax
		mov		ebx, 10
		mul		ebx
		push		eax
		loop		L2
		pop		eax
		jmp		DECDONE
	ONE:
		mov		eax, 1
	DECDONE:
		pop		ecx				; reset outer loop

		mov		ebx, eax			; eax has decimal, mov to ebx
		pop		eax				; top of stack has single integer value for the decimal place
		mul		ebx
		push		esi
		mov		esi, [ebp + 48]							
		mov		ebx, [esi]
		add		eax, ebx
		mov		[esi], eax
		pop		esi

		stosb
		loop		L1
		jmp		OUTRO
	ERROR:	
		mov		edx, [ebp + 44]
		call		WriteString
		call		CrLf	
	OUTRO:
		popad
		ret		16
	readInteger	ENDP

; Description:  writes user integer (the hard way) using lodsd and stosd
; Required: On Stack: 
; Returns: display of numbers sequentially in char array
; Preconditions: 
; also input int cannot exceed 999,999,999
; Registers changed: 
	writeInteger	PROC
		pushad
		mov		ebp, esp		
		mov		esi, [ebp + 40]			; offset userCharString
		mov		edi, esi			; destination index
		mov		ecx, [ebp + 44]			; loop counter = userLength
	L1: 
		mov		eax, [ebp + 36] 
		cdq
		mov		ebx, 10
		div		ebx
		mov		[ebp + 36], eax
		mov		al, dl 
		add		al, 30h
		movzx		ebx, al
		push		ebx				; push chars onto stack in reverse order
		loop		L1
		cld						; reverse string
		mov		ecx,  [ebp + 44]		; loop counter = userLength
	L2:
		lodsb
		pop		ebx				; pop ordered chars into al then store them
		mov		al, bl
		stosb
		loop		L2

		popad
		ret		12
	writeInteger	ENDP


END main
