@ECHO OFF
REM The Official Cherry Soda Operating System Build Script

IF EXIST CherrySodaOS.img DEL CherrySodaOS.img

ECHO Assembling Stage1...
FASM BOOTSECT.ASM

ECHO Creating Disk...
FAT_IMGEN -c -f CherrySodaOS.img

ECHO Copying system to disk...
FAT_IMGEN -m -f CherrySodaOS.img -s BOOTSECT.CHR