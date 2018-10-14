# Spy-MSDOS
A TSR for snooping MSDOS I/O operations. Written in 1996-1997, still useful today with DOS emulators :-)

Assemble and link with Turbo Assembler (TASM).

tasm spy.asm
tlink /Tdc spy.obj

/Tdc is for generating a COM file

# Output example: example capture of TASM assembling spy
OPEN   NUL OKAY
OPEN   NUL OKAY
OPEN   NUL OKAY 
OPEN   NUL OKAY 
OPEN   NUL OKAY 
OPEN   NUL OKAY 
OPEN   NUL OKAY 
OPEN   NUL OKAY 
OPEN   NUL OKAY 
OPEN   NUL OKAY 
OPEN   NUL OKAY 
OPEN   NUL OKAY 
OPEN   NUL OKAY 
OPEN   NUL OKAY 
OPEN   NUL FAIL 
OPEN   TASM.CFG FAIL 
OPEN   D:\UTY\TASM.CFG FAIL 
OPEN   * FAIL 
OPEN   spy.asm OKAY 
CREATE spy.OBJ OKAY 
OPEN   D:\UTY\dpmi16bi.ovl OKAY 
OPEN   D:\UTY\dpmiload.exe OKAY 
OPEN   D:\UTY\dpmi16bi.ovl OKAY 
OPEN   D:\UTY\TLINK.EXE OKAY 
FINDFR tlink.cfg FAIL 
FINDFR D:\UTY\tlink.cfg FAIL 
FINDFR tlink.cfg FAIL 
FINDFR D:\UTY\tlink.cfg FAIL 
FINDFR tlink.cfg FAIL 
FINDFR D:\UTY\tlink.cfg FAIL 
FINDFR tlink.cfg FAIL 
FINDFR D:\UTY\tlink.cfg FAIL 
FINDFR tlink.cfg FAIL 
FINDFR D:\UTY\tlink.cfg FAIL 
OPEN   D:\SPY\DPMIMEM.DLL FAIL 
OPEN   D:\UTY\DPMIMEM.DLL OKAY 
CREATE spy.map OKAY 
OPEN   spy.obj OKAY 
CREATE spy.com OKAY 

