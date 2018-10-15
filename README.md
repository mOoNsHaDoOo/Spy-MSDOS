# Spy-MSDOS
A TSR for snooping MSDOS I/O operations. Written in 1996-1997, still useful today with DOS emulators :-)<br />
<br />
Assemble and link with Turbo Assembler (TASM).<br />
<br />
```tasm spy.asm```<br />
```tlink /Tdc spy.obj```<br />
<br />
/Tdc is for generating a COM file<br />
<br />
Spy will generate I/O operations dump file in C:\SPY.LST
<br />
Run it once for installing. Run again for removing (if possible)
<br />
# Output example: capture of TASM/TLINK generating spy.com
OPEN   NUL OKAY<br />
OPEN   NUL OKAY<br />
OPEN   NUL OKAY<br />
OPEN   NUL OKAY<br />
OPEN   NUL OKAY<br />
OPEN   NUL OKAY<br />
OPEN   NUL OKAY<br />
OPEN   NUL OKAY<br />
OPEN   NUL OKAY<br />
OPEN   NUL OKAY<br />
OPEN   NUL OKAY<br />
OPEN   NUL OKAY<br />
OPEN   NUL OKAY<br />
OPEN   NUL OKAY<br />
OPEN   NUL FAIL<br />
OPEN   TASM.CFG FAIL<br />
OPEN   D:\UTY\TASM.CFG FAIL<br />
OPEN   * FAIL<br />
OPEN   spy.asm OKAY<br />
CREATE spy.OBJ OKAY<br />
OPEN   D:\UTY\dpmi16bi.ovl OKAY<br />
OPEN   D:\UTY\dpmiload.exe OKAY<br />
OPEN   D:\UTY\dpmi16bi.ovl OKAY<br />
OPEN   D:\UTY\TLINK.EXE OKAY<br />
FINDFR tlink.cfg FAIL<br />
FINDFR D:\UTY\tlink.cfg FAIL<br />
FINDFR tlink.cfg FAIL<br />
FINDFR D:\UTY\tlink.cfg FAIL<br />
FINDFR tlink.cfg FAIL<br />
FINDFR D:\UTY\tlink.cfg FAIL<br />
FINDFR tlink.cfg FAIL<br />
FINDFR D:\UTY\tlink.cfg FAIL<br />
FINDFR tlink.cfg FAIL<br />
FINDFR D:\UTY\tlink.cfg FAIL<br />
OPEN   D:\SPY\DPMIMEM.DLL FAIL<br />
OPEN   D:\UTY\DPMIMEM.DLL OKAY<br />
CREATE spy.map OKAY<br />
OPEN   spy.obj OKAY<br />
CREATE spy.com OKAY<br />
