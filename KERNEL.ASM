;=======================================================================;
;		CherrySodaOS						;
;			(C) Copyright All CherrySodaOS Contributors	;
;		BOOTSECT.ASM - The Bootloader				;
;=======================================================================;
        
        USE16
        ORG 0x0
        FORMAT BINARY AS 'CHR'
        
        JMP CherrySodaEntry
        
        CherrySodaEntry:
                CLI
                MOV AX, 0
                MOV SS, AX
                MOV SP, 0xFFFF
                STI
                
                MOV AX, 0x2000
		MOV DS, AX
		MOV ES, AX
		MOV FS, AX
		MOV GS, AX
