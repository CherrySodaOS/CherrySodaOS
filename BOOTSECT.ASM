;=======================================================================;
;		CherrySodaOS						;
;			(C) Copyright All CherrySodaOS Contributors	;
;		Stage1.ASM - The Stage 1 Bootloader			;
;=======================================================================;
	
	USE16
	FORMAT BINARY AS 'CHR'
	ORG 0x0
	
	JMP LoadImage
	
	bpbOEMLabel		DB	'CHRYSODA'
	bpbBytesPerSector	DW	512
	bpbSectorsPerCluster	DB	1
	bpbReservedSectors	DW	1
	bpbNumberOfFATs		DB	2
	bpbRootEntries		DW	224
	bpbTotalSectors		DW	2880
	bpbMediaID		DB	0xF0
	bpbSectorsPerFAT	DW	9
	bpbSectorsPerTrack	DW	18
	bpbHeads		DW	2
	bpbHiddenSectors	DD	0
	bpbLargeSectors		DD	0
	bsDriveNumber		DB	0
	bsNTReserved		DB	0
	bsBootSignature		DB	0x29
	bsSerialNumber		DD	0x24242424
	bsVolumeLabel		DB	'CHERYSODAOS'
	bsFileSystem		DB	'FAT12   '
	
	LF			EQU	10
	CR			EQU	13
	KernelSegment		EQU	0x2000
	Buffer			EQU	0x0200
	InitMSG			DB	'Loading CherrySodaOS...', 0
	
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
		
	LoadRoot:
		; We will add code later - we are researching FAT12
		
		CLI
		HLT
		
	TIMES 510-($-$$) DB 0
	DW 0xAA55
