;=======================================================================;
;		CherrySodaOS						;
;			(C) Copyright All CherrySodaOS Contributors	;
;		BOOTSECT.ASM - The Bootloader				;
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
	InitMSG			DB	'Loading CherrySodaOS...', CR, LF, 0
	KernelNotFoundMSG	DB	'CherrySoda Kernel Not Found!', 0
	Cluster			DW	0
	Pointer			DW	0
	KernelFilename		DB	'KERNEL  CHR'
	
	ConvertLBAtoCHS:
		PUSH BX
		PUSH AX
		
		MOV BX, AX
		
		MOV DX, 0
		DIV WORD [bpbSectorsPerTrack]
		ADD DL, 0x01
		MOV CL, DL
		MOV AX, BX
		
		MOV DX, 0
		DIV WORD [bpbSectorsPerTrack]
		MOV DX, 0
		DIV WORD [bpbHeads]
		
		MOV DH, DL
		MOV CH, AL
		
		POP AX
		POP BX
		
		MOV DL, BYTE [bpbDriveNumber]
		
		RET
	
	ResetFloppy:
		PUSHA
		
		MOV AX, 0
		MOV DL, BYTE [bsDriveNumber]
		
		INT 13h
		
		POPA
		RET
	
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
		MOV AX, 19
		CALL ConvertLBAtoCHS
		
		MOV BX, Buffer
		
		MOV AH, 2
		MOV AL, 14
		
		PUSHA
		
	LoadRootLoop:
		POPA
		PUSHA
		
		STC
		INT 13h
		
		JNC LoadedRoot
		CALL ResetFloppy
		JMP LoadRootLoop
		
	LoadedRoot:
		POPA
		
		MOV DI, Buffer
		MOV CX, WORD [bpbRootDirEntries]
		MOV AX, 0
		
	NextEntry:
		XCHG CX, DX
		
		MOV SI, KernelFilename
		MOV CX, 11
		REP CMPSB
		
		JE FoundKernel
		
		ADD AX, 32
		
		MOV DI, Buffer
		ADD DI, AX
		
		XCHG DX, CD
		LOOP NextEntry
		
		MOV SI, KernelNotFoundMSG
		CALL PrintString
		
		CLI
		HLT
		
	FoundKernel:
		MOV AX, WORD [ES:DI + 0x0F]
		MOV WORD [Cluster], AX
		
		MOV AX, 1
		CALL ConvertLBAtoCHS
		
		MOV BX, Buffer
		
		MOV AH, 2
		MOV AL, 9
		
		PUSHA
		
	ReadFAT:
		POPA
		PUSHA
		
		STC
		INT 13h
		
		JNC LoadedFAT
		CALL ResetFloppy
		JMP ReadFAT
		
	LoadedFAT:
		POPA
		
		MOV AX, KernelSegment
		MOV ES, AX
		
		MOV BX, 0
		
		MOV AH, 2
		MOV AL, 1
		
		PUSH AX
		
	LoadFileSector:
		MOV AX, WORD [Cluster]
		ADD AX, 31
		
		CALL ConvertLBAtoCHS
		
		MOV AX, KernelSegment
		MOV ES, AX
		
		MOV BX, WORD [Pointer]
		
		POP AX
		PUSH AX
		
		STC
		INT 13h
		
		JNC CalculateNextCluster
		CALL ResetFloppy
		JMP LoadFileSector
		
	CalculateNextCluster:
		MOV AX, [Cluster]
		MOV DX, 0
		MOV BX, 3
		MUL BX
		
		MOV BX, 2
		DIV BX
		
		MOV SI, Buffer
		
		ADD SI, AX
		
		MOV AX, WORD [DS:SI]
		
		OR DX, DX
		
		JZ EVEN
		
	ODD:
		SHR AX, 4
		JMP SHORT NextClusterCont
		
	EVEN:
		AND AX, 0xFFF
		
	NextClusterCont:
		MOV WORD [Cluster], AX
		
		CMP AX, 0xFF8
		JAE EnterKernel
		
		ADD WORD [Pointer], 512
		JMP LoadFileSector
		
	EnterKernel:
		POP AX
		
		JMP KernelSegment:0x0000
		
		CLI
		HLT
		
	TIMES 510-($-$$) DB 0
	DW 0xAA55
