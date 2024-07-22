# Spy-MSDOS
A TSR for snooping MSDOS I/O operations. Written in 1996-1997, still useful today with DOS emulators ;-)<br />
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
```OPEN   NUL OKAY
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
```

