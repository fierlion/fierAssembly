TITLE Simple Integer Arithmetic     (intArith.asm)

; Author: Ray Foote
; Course / Project ID    CS271_400 / integer Arithmetic             Date: Jan 12, 2014
; Description: simple arithmetic calculations on 2 user input integers

INCLUDE Irvine32.inc


.data
my_name			BYTE			"           Elementary Arithmetic       by Ray Foote. ", 0
user_instruct1	BYTE			"Enter two integers.  This program will display their sum, diff,", 0
user_instruct2	BYTE			"prod, and quot (and its remainder).", 0
prompt1			BYTE			"First integer: ", 0
prompt2			BYTE			"Second integer: ", 0
user_int1			DWORD		?
user_int2			DWORD		?
sum_res			DWORD		?
diff_res			DWORD		?
prod_res			DWORD		?
quot_res			DWORD		?
remain				DWORD		?
plus				BYTE			' + ',0
minus				BYTE			' - ',0
times				BYTE			' * ',0
divide				BYTE			' / ',0
equals				BYTE			' = ',0
remainder			BYTE			" remainder ", 0
goodbye			BYTE			"The End.  Goodbye.", 0
again_ask			BYTE			"Want to do another? ",0
ag_prompt		BYTE			"Enter '1' for 'yes', '0' to end: ",0


.code
main PROC

; Introduction
	mov	edx, OFFSET my_name
	call		WriteString
	call		CrLf
	call		CrLf
L1:
; color change
	call		Randomize
	mov	eax, 14										; color between black(0) and lightMagenta(13)
	call		RandomRange
	mov	ebx, 16
	mul	ebx
	add	eax, 15
	call		SetTextColor

; prompt for user input
	mov	edx, OFFSET user_instruct1
	call		WriteString
	call		CrLf
	mov	edx, OFFSET user_instruct2
	call		WriteString
	call		CrLf
	call		CrLf

; Get user data
	mov	edx, OFFSET prompt1
	call		WriteString
     call		ReadInt
     mov	user_int1, eax
	call		CrLf
	mov	edx, OFFSET prompt2
	call		WriteString
	call		ReadInt
	mov	user_int2, eax
	call		CrLf

; Calculate required values

	mov	eax, user_int1								; add
	mov	ebx, user_int2
	add	eax, ebx
	mov	sum_res, eax

	mov	eax, user_int1								; add
	mov	ebx, user_int2
	sub	eax, ebx
	mov	diff_res, eax
	
	mov	eax, user_int1								; multiply
	mov	ebx, user_int2
	mul	ebx
	mov	prod_res, eax

	mov	eax, user_int1								; divide
	cdq
	mov	ebx, user_int2
	div		ebx
	mov	quot_res, eax
	mov	remain, edx

; Display results
	
	mov	eax, user_int1								; plus result
	call		WriteDec
	mov	edx, OFFSET plus
	call		WriteString
	mov	eax, user_Int2
	call		WriteDec
	mov	edx, OFFSET equals
	call		WriteString
	mov	eax, sum_res
	call		WriteDec
	call		CrLf

	mov	eax, user_int1								; minus result
	call		WriteDec
	mov	edx, OFFSET minus
	call		WriteString
	mov	eax, user_Int2
	call		WriteDec
	mov	edx, OFFSET equals
	call		WriteString
	mov	eax, diff_res
	call		WriteDec
	call		CrLf

	mov	eax, user_int1								; multiply result
	call		WriteDec
	mov	edx, OFFSET times
	call		WriteString
	mov	eax, user_Int2
	call		WriteDec
	mov	edx, OFFSET equals
	call		WriteString
	mov	eax, prod_res
	call		WriteDec
	call		CrLf

	mov	eax, user_int1								; divide result
	call		WriteDec
	mov	edx, OFFSET divide
	call		WriteString
	mov	eax, user_Int2
	call		WriteDec
	mov	edx, OFFSET equals
	call		WriteString
	mov	eax, quot_res
	call		WriteDec
	mov	edx, OFFSET remainder
	call		WriteString
	mov	eax, remain
	call		WriteDec
	call		CrLf
	call		CrLf

; ask for repeat
	mov	edx, OFFSET again_ask
	call		WriteString
	call		CrLf
	mov	edx, OFFSET ag_prompt
	call		WriteString
	call		ReadInt
	cmp	eax, 1
	jge		L1

; Say goodbye if 'no'
	mov	edx, OFFSET goodbye
	call		WriteString
	call		CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main


		mov		eax, RAND_HI
		inc			eax
		mov		ebx, RAND_LOW
		sub		eax, ebx		