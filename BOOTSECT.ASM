;===============================================================;
;		CherrySodaOS											;
;			(C) Copyright All CherrySodaOS Contributors			;
;		Stage1.ASM - The Stage 1 Bootloader						;
;===============================================================;
	
	USE16
	FORMAT BINARY AS 'CHR'
	ORG 0x0
	
	JMP LoadImage
	
	InitMSG			DB 'Hello, World! - CherrySodaOS', 0
	
	PrintString:
		PUSHA
		MOV AH, 0Eh
	NextChar:
		LODSB
		CMP AL, 0
		JE DonePrinting
		INT 10h
		JMP NextChar
	DonePrinting:
		POPA
		RET
	
	LoadImage:
		CLI
		MOV AX, 0x0
		MOV SS, AX
		MOV SP, 0xFFFF
		STI
		
		MOV AX, 0x07C0
		MOV DS, AX
		MOV ES, AX
		MOV FS, AX
		MOV GS, AX
		
		MOV SI, InitMSG
		CALL PrintString
		
		CLI
		HLT
		
	TIMES 510-($-$$) DB 0
	DW 0xAA55