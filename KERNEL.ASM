;=======================================================================;
;		CherrySodaOS						;
;			(C) Copyright All CherrySodaOS Contributors	;
;		KERNEL.ASM - The Core Code				;
;=======================================================================;
        
        USE16								; We are still in 16-bit real mode
        ORG 0x0								; For 16-bit code
        FORMAT BINARY AS 'CHR'						; Output KERNEL.CHR
	
	JMP CherrySodaEntry						; Jump to the kernel entry point
	
	InitSys:
		MOV AH, 09h
		MOV AL, ' '
		MOV BH, 0
		MOV BL, 0x1F
		MOV CX, 2000
		INT 10h
	
	CherrySodaEntry:						; We enter here from boot
		CLI
		MOV AX, 0
		MOV SS, AX
		MOV SP, 0xFFFF
		STI
		
		MOV AX, 0x1000
		MOV DS, AX
		MOV ES, AX
		MOV FS, AX
		MOV GS, AX
		
		MOV AX, 03h
		INT 10h
		
		CALL InitSys
