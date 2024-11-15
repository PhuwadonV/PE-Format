BITS 64

PageTableSize        EQU 0x1000
DiskSectorSize       EQU 0x200

SectionAlignment     EQU PageTableSize
FileAlignment        EQU DiskSectorSize

Image.base           EQU 0x140000000
Image.size           EQU 0x4000

Header.size          EQU 0x200
Header.Optional.size EQU Header.Optional.end - Header.Optional.start

NumberOfSections     EQU 3

Section.text.start   EQU 0x200
Section.rdata.start  EQU 0x400
Section.reloc.start  EQU 0x600

Section.text.size    EQU 0x200
Section.rdata.size   EQU 0x200
Section.reloc.size   EQU 0x200

Section.text.vstart  EQU 0x1000
Section.rdata.vstart EQU 0x2000
Section.reloc.vstart EQU 0x3000

Section.text.vsize   EQU Section.text.vend - Section.text.vstart
Section.rdata.vsize  EQU Section.rdata.vend - Section.rdata.vstart
Section.reloc.vsize  EQU Section.reloc.vend - Section.reloc.vstart

Reloc.text.vsize     EQU Reloc.text.vend - Reloc.text.vstart
Reloc.rdata.vsize    EQU Reloc.rdata.vend - Reloc.rdata.vstart

SECTION Header START=0

Header.DOS:
DB "MZ"
DB 0x3A DUP 0
DD Header.COFF

Header.COFF:
DB "PE", 0, 0
DW 0x8664               ; Machine
DW NumberOfSections     ; NumberOfSections
DD 0                    ; TimeDateStamp
DD 0                    ; PointerToSymbolTable
DD 0                    ; NumberOfSymbols
DW Header.Optional.size ; SizeOfOptionalHeader
DW 0x0022               ; Characteristics

Header.Optional.start:

Header.COFF.StandardFields:
DW 0x020B               ; Magic
DB 0                    ; MajorLinkerVersion
DB 0                    ; MinorLinkerVersion
DD 0                    ; SizeOfCode
DD 0                    ; SizeOfInitializedData
DD 0                    ; SizeOfUninitializedData
DD Section.text.vstart  ; AddressOfEntryPoint
DD 0                    ; BaseOfCode

Header.COFF.WindowsSpecificFields:
DQ Image.base           ; ImageBase
DD SectionAlignment     ; SectionAlignment
DD FileAlignment        ; FileAlignment
DW 0                    ; MajorOperatingSystemVersion
DW 0                    ; MinorOperatingSystemVersion
DW 0                    ; MajorImageVersion
DW 0                    ; MinorImageVersion
DW 6                    ; MajorSubsystemVersion
DW 0                    ; MinorSubsystemVersion
DD 0                    ; Win32VersionValue
DD Image.size           ; SizeOfImage
DD Header.size          ; SizeOfHeaders
DD 0                    ; CheckSum
DW 0x3                  ; Subsystem
DW 0x8160               ; DllCharacteristics
DQ 0                    ; SizeOfStackReserve
DQ 0                    ; SizeOfStackCommit
DQ 0                    ; SizeOfHeapReserve
DQ 0                    ; SizeOfHeapCommit
DD 0                    ; LoaderFlags
DD 16                   ; NumberOfRvaAndSizes

Header.COFF.DataDirectories:
DD 0                    ;  1.1 : ExportTable
DD 0                    ;  1.2 : Size
DD ImportTable          ;  2.1 : ImportTable
DD 0                    ;  2.2 : Size
DD 0                    ;  3.1 : ResourceTable
DD 0                    ;  3.2 : Size
DD 0                    ;  4.1 : ExceptionTable
DD 0                    ;  4.2 : Size
DD 0                    ;  5.1 : CertificateTable
DD 0                    ;  5.2 : Size
DD Section.reloc.vstart ;  6.1 : BaseRelocationTable
DD Section.reloc.vsize  ;  6.2 : Size
DD 0                    ;  7.1 : Debug
DD 0                    ;  7.2 : Size
DD 0                    ;  8.1 : Architecture
DD 0                    ;  8.2 : Size
DD 0                    ;  9.1 : GlobalPtr
DD 0                    ;  9.2 : Zero
DD 0                    ; 10.1 : TLSTable
DD 0                    ; 10.2 : Size
DD 0                    ; 11.1 : LoadConfigTable
DD 0                    ; 11.2 : Size
DD 0                    ; 12.1 : BoundImport
DD 0                    ; 12.2 : Size
DD 0                    ; 13.1 : IAT
DD 0                    ; 13.2 : Size
DD 0                    ; 14.1 : DelayImportDescriptor
DD 0                    ; 14.2 : Size
DD 0                    ; 15.1 : CLRRuntimeHeader
DD 0                    ; 15.2 : Size
DQ 0                    ; 16   : Reserved (must be zero)

Header.Optional.end:

Header.COFF.SectionTable:

DB ".text"
ALIGN 8, DB 0
DD Section.text.vsize   ; VirtualSize
DD Section.text.vstart  ; VirtualAddress
DD Section.text.size    ; SizeOfRawData
DD Section.text.start   ; PointerToRawData
DD 0                    ; PointerToRelocations
DD 0                    ; PointerToLinenumbers
DW 0                    ; NumberOfRelocations
DW 0                    ; NumberOfLinenumbers
DD 0x60000020           ; Characteristics

DB ".rdata"
ALIGN 8, DB 0
DD Section.rdata.vsize  ; VirtualSize
DD Section.rdata.vstart ; VirtualAddress
DD Section.rdata.size   ; SizeOfRawData
DD Section.rdata.start  ; PointerToRawData
DD 0                    ; PointerToRelocations
DD 0                    ; PointerToLinenumbers
DW 0                    ; NumberOfRelocations
DW 0                    ; NumberOfLinenumbers
DD 0x40000040           ; Characteristics

DB ".reloc"
ALIGN 8, DB 0
DD Section.rdata.vsize  ; VirtualSize
DD Section.reloc.vstart ; VirtualAddress
DD Section.reloc.size   ; SizeOfRawData
DD Section.reloc.start  ; PointerToRawData
DD 0                    ; PointerToRelocations
DD 0                    ; PointerToLinenumbers
DW 0                    ; NumberOfRelocations
DW 0                    ; NumberOfLinenumbers
DD 0x42000040           ; Characteristics

Header.vend:
DB Header.size - ($ - $$) DUP 0

SECTION .text START=Section.text.start VSTART=Section.text.vstart

sub rsp, 32 + 8
mov ecx, 0x800
call [rel knl.sleep]
xor ecx, ecx
mov rdx, Image.base + HelloWorld
Reloc.text.1.end:
mov r8,  Image.base + HelloWorld
Reloc.text.2.end:
xor r9, r9
call [rel usr.msg]
mov ecx, 1234567890
call [rel knl.exit]

Section.text.vend:
DB Section.text.size - ($ - $$) DUP 0

SECTION .rdata START=Section.rdata.start VSTART=Section.rdata.vstart

knl.exit:
DQ 0x20A8
knl.sleep:
DQ 0x20A0
DQ 0

usr.msg:
DQ 0x20B8
DQ 0

ALIGN 16, DB 0
HelloWorld:
DB "Hello, World!", 0

ALIGN 8, DB 0
Reloc.rdata.1:
DQ Image.base

ALIGN 4, DB 0
ImportTable:
DD 0x2078
DD 0
DD 0
DD 0x20B0
DD 0x2000

DD 0x2090
DD 0
DD 0
DD 0x20BE
DD 0x2018

DQ 0

DQ 0x20A8
DQ 0x20A0
DQ 0

DQ 0x20B8
DQ 0

DW 1
DB "sleep", 0
DW 0
DB "exit", 0
ALIGN 8, DB 0
DB "knl.dll", 0

DW 0
DB "msg", 0
DB "usr.dll", 0

Section.rdata.vend:
DB Section.rdata.size - ($ - $$) DUP 0

SECTION .reloc START=Section.reloc.start VSTART=Section.reloc.vstart

Reloc.text.vstart:
DD Section.text.vstart
DD Reloc.text.vsize
DW 0xA000 - Section.text.vstart + Reloc.text.1.end - 8
DW 0xA000 - Section.text.vstart + Reloc.text.2.end - 8
ALIGN 4, DB 0
Reloc.text.vend:

Reloc.rdata.vstart:
DD Section.rdata.vstart
DD Reloc.rdata.vsize
DW 0xA000 - Section.rdata.vstart + Reloc.rdata.1
ALIGN 4, DB 0
Reloc.rdata.vend:

Section.reloc.vend:
DB Section.reloc.size - ($ - $$) DUP 0
