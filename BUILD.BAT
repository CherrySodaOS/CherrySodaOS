@ECHO OFF
REM The Official Cherry Soda Operating System Build Script

IF EXIST CherrySodaOS.img DEL CherrySodaOS.img

ECHO Assembling Bootloader...
FASM BOOTSECT.ASM

ECHO Assembling Kernel...
FASM KERNEL.ASM

ECHO Creating Disk...
FAT_IMGEN -c -f CherrySodaOS.img

ECHO Copying system to disk...
FAT_IMGEN -m -f CherrySodaOS.img -s BOOTSECT.CHR

ECHO Copying kernel to disk...
FAT_IMGEN -m -f CherrySodaOS.img -i KERNEL.CHR
