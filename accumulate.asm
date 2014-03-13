TITLE Accumulator    (acculuate.asm)

; Author: Ray Allan
; Course / Project ID       CS271_400 Homework 3          Date: 02/04/14
; Description: This program takes repeated (validated as non-negative between 0-100) user input numbers and calculates the average over all

INCLUDE Irvine32.inc

UPPER_LIMIT = 100

.data

progTitle		BYTE		"Accumulator", 0
progName		BYTE		"Programmed by Ray Allan", 0
namePrompt		BYTE		"What's your name? ", 0
greeting		BYTE		"Hello, ", 0
userInst1		BYTE		"Enter a series of integers in the range [0-100] to be averaged", 0
userInst2		BYTE		"After each number press enter. To end input, enter a negative integer.", 0
numPrompt		BYTE		" Enter number: ",0
userName		BYTE		33 DUP(0)		; name to be input by user
userNum			DWORD		?				; user number input
errorRange		BYTE		"Out of range.  Enter a number in the range [0-100]", 0
infoAccum		BYTE		"The sum of these numbers is: ", 0
totNums			BYTE		"You entered a total of ", 0
numName			BYTE		" numbers.", 0
infoAverage		BYTE		"The average to three decimal places (rounded) is: ", 0
accumulated		DWORD		0				; total accumulation
numNums			DWORD		0				; number of integers entered
quot			DWORD		0
remain			DWORD		?
round			DWORD		?				; last number test for rounding up
doneIn			BYTE		"Finished input.", 0
goodbye			BYTE		"Goodbye, ", 0

.code
main PROC

; introduction

	mov		edx, OFFSET progTitle
	call		writeString
	call		CrLf
	mov		edx, OFFSET progName
	call		writeString
	call		CrLf
	call		CrLf

; ask for name, display greeting
	mov		edx, OFFSET namePrompt
	call		WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call		ReadString
	mov		edx, OFFSET greeting
	call		WriteString
	mov		edx, OFFSET userName
	call		WriteString
	call		CrLf

; getUserData
; prompt user to enter number(s)
	mov		edx, OFFSET userInst1
	call		WriteString
	call		CrLf
	mov		edx, OFFSET userInst2
	call		WriteString
	call		CrLf
	call		CrLf
L1:
	mov		eax, numNums
	call		WriteDec
	mov		edx, OFFSET numPrompt
	call		WriteString
	call		ReadInt
	mov		userNum, eax
	mov		ecx, userNum				; mov userNum preparing for loop
	mov		eax, userNum				; loop check
	cmp		eax, UPPER_LIMIT
	jle		L2
	mov		edx, OFFSET errorRange
	call		WriteString
	call		CrLf
	jmp		L1

; count and accumulate the numbers until negative number is entered
L2:
	cmp		eax, 0
	jle		L3
	mov		eax, userNum				; add number to accumulation
	mov		ebx, accumulated
	add		eax, ebx
	mov		accumulated, eax
	inc		numNums					; increment numNums
	jmp		L1
L3:
; display results
	call		CrLf
	mov		edx, OFFSET doneIn
	call		WriteString
	call		CrLf
; count of non-negative numbers used
	mov		edx, OFFSET totNums
	call		WriteString
	mov		eax, numNums
	call		WriteDec
	mov		edx, OFFSET numName
	call		WriteString
	call		CrLf
 ; sum of non negative numbers used
	mov		edx, OFFSET  infoAccum
	call		WriteString
	mov		eax, accumulated
	call		WriteDec
	call		CrLf
  ; calculate and display the average
  ; calculate the average
	mov		eax, accumulated
	cdq
	mov		ebx, numNums
	div		ebx
	mov		quot, eax
	mov		remain, edx
  ; display the average
	mov		edx, OFFSET infoAverage
	call		WriteString
	mov		eax, quot
	call		WriteDec
	mov		al, 46
	call		WriteChar
;set up float loop, number of places after decimal
	mov		ecx, 3
top:
	mov		eax, remain 
	mov		ebx, 10
	mul		ebx
	cdq		
	mov		ebx, numNums
	div		ebx
	mov		quot, eax
	mov		remain, edx
	cmp		ecx, 1
	jg		noRound					; if last integer before loop ends, check next decimal place for rounding
	mov		eax, remain 
	mov		ebx, 10
	mul		ebx
	cdq		
	mov		ebx, numNums
	div		ebx
	cmp		eax, 5					
	jl		noRound
	inc		quot
noRound:
	mov		eax, quot
	call		WriteDec
	loop		top
	call		CrLf

  ; parting greeting
	call		CrLf
  	mov		edx, OFFSET goodbye
	call		WriteString
	mov		edx, OFFSET userName
	call		WriteString
	call		CrLf


	exit	; exit to operating system
main ENDP

END main
