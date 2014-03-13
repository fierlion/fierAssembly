TITLE Fibonacci numbers     (fibNum.asm)

; Author: Ray Foote
; Course / Project ID  CS271_400 Homework 2                Date: Jan 20, 2014
; Description: This program takes a user input int n and displays the fibonacci numbers from [1...n]

INCLUDE Irvine32.inc

TOP_FIB = 46

.data

progTitle				BYTE			"Fibonacci Numbers", 0
progName			BYTE			"Programmed by Ray Foote", 0
namePrompt			BYTE			"What's your name? ", 0
greeting				BYTE			"Hello, ", 0
userInst1				BYTE			"Enter the number of Fibonacci terms to be displayed", 0
userInst2				BYTE			"Give the number as an integer in the range [1 ... 46]", 0
numPrompt			BYTE			"How many Fibonacci numbers do you want? ",0
userName				BYTE			33 DUP(0)		; name to be input by user
userNum				DWORD			?				; number of requested fibonacci results requested
errorRange			BYTE			"Out of range.  Enter a number in the range [1 ... 46]", 0
fibOne					DWORD		1
fibTwo					DWORD		0
outro					BYTE			"Wasn't that last number, ", 0
wasBig				BYTE			", enormous?  Yes it was.", 0
goodbye				BYTE			"Goodbye, ", 0

.code
main PROC

; introduction

	mov		edx, OFFSET progTitle
	call			writeString
	call			CrLf
	mov		edx, OFFSET progName
	call			writeString
	call			CrLf
	call			CrLf

; userInstructions
; ask for name, display greeting

	mov		edx, OFFSET namePrompt
	call			WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call			ReadString
	mov		edx, OFFSET greeting
	call			WriteString
	mov		edx, OFFSET userName
	call			WriteString
	call			CrLf

; getUserData

	mov		edx, OFFSET userInst1
	call			WriteString
	call			CrLf
	mov		edx, OFFSET userInst2
	call			WriteString
	call			CrLf
	call			CrLf
L1:
	mov		edx, OFFSET numPrompt
	call			WriteString
	call			ReadInt
	mov		userNum, eax
	mov		ecx, userNum								; mov userNum preparing for loop
	mov		eax, userNum							; loop check
	cmp		eax, TOP_FIB
	jle			L2
	mov		edx, OFFSET errorRange
	call			WriteString
	call			CrLf
	jmp		L1
L2:
; displayFibs
	mov		eax, fibTwo
	mov		ebx, fibOne
	add		eax, ebx
	mov		fibOne, eax
	mov		fibTwo, ebx
	mov		eax, fibTwo
	call			WriteDec
	mov		al, 9										; '9' is the ASCII tab decimal
	call			WriteChar
	cmp		fibTwo, 9999999							; '9999999' is the max size of a tab, (if larger, formatted columns break)
	jg			L3							
	call			WriteChar
L3:
	loop		L2

; goodbye
	call			CrLf
	mov		edx, OFFSET outro
	call			WriteString
	mov		eax, fibTwo
	call			WriteDec
	mov		edx, OFFSET wasBig
	call			WriteString
	call			CrLf
	mov		edx, OFFSET goodbye
	call			WriteString
	mov		edx, OFFSET userName
	call			WriteString
	call			CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
