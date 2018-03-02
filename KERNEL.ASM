;=======================================================================;
;		CherrySodaOS						;
;			(C) Copyright All CherrySodaOS Contributors	;
;		KERNEL.ASM - The Core Code				;
;=======================================================================;
        
        USE16								; We are still in 16-bit real mode
        ORG 0x0								; For 16-bit code
        FORMAT BINARY AS 'CHR'						; Output KERNEL.CHR
	
	JMP CherrySodaEntry						; Jump to the kernel entry point
	
	CherrySodaEntery:
		CLI							; Clear the interrupts - we can't setup stack
									; with interrupts
		MOV AX, 0						; The 16-bit stack segment will be 0
		MOV SS, AX						; We can't write directly to a segment register
									; so, we write to ax, then write ax to ss
		MOV SP, 0xFFFF						; The stack is located in 0xFFFF down
		STI							; Re-enable the interrupts because we are done
									; setting up the stack
