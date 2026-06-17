@echo off
if exist scdbuilt.bin move /y scdbuilt.bin scdbuilt.prev.bin >NUL
"../../../../Tools/vasmm68k_psi-x.exe" -noalign -m68000 -maxerrors=0 -Fbin -start=0 -o scdbuilt.bin -L R11A.lst -Lall R11A.asm 2> errors.log
pause