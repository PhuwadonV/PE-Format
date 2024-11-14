BITS 64

%assign Image.base           0x140000000
%assign Image.vstart         0
%define Image.vsize          (Image.vend - Image.vstart)

%assign Header.size          0x200

%assign NumberOfSections     3

%assign Section.text.start   0x200
%assign Section.rdata.start  0x400
%assign Section.reloc.start  0x600

%assign Section.text.size    0x200
%assign Section.rdata.size   0x200
%assign Section.reloc.size   0x200

%assign Section.text.vstart  0x1000
%assign Section.rdata.vstart 0x2000
%assign Section.reloc.vstart 0x3000

%define Section.text.vsize   (Section.text.vend - Section.text.vstart)
%define Section.rdata.vsize  (Section.rdata.vend - Section.rdata.vstart)
%define Section.reloc.vsize  (Section.reloc.vend - Section.reloc.vstart)

%define Reloc.text.vsize  (Reloc.text.vend - Reloc.text.vstart)
%define Reloc.rdata.vsize (Reloc.rdata.vend - Reloc.rdata.vstart)

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
DW 0xF0                 ; SizeOfOptionalHeader
DW 0x0022               ; Characteristics

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
DD 0x1000               ; SectionAlignment
DD 0x200                ; FileAlignment
DW 0                    ; MajorOperatingSystemVersion
DW 0                    ; MinorOperatingSystemVersion
DW 0                    ; MajorImageVersion
DW 0                    ; MinorImageVersion
DW 6                    ; MajorSubsystemVersion
DW 0                    ; MinorSubsystemVersion
DD 0                    ; Win32VersionValue
DD Image.vsize          ; SizeOfImage
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
DD 0                    ; ExportTable
DD 0                    ; Size
DD ImportTable          ; ImportTable
DD 0                    ; Size
DD 0                    ; ResourceTable
DD 0                    ; Size
DD 0                    ; ExceptionTable
DD 0                    ; Size
DD 0                    ; CertificateTable
DD 0                    ; Size
DD Section.reloc.vstart ; BaseRelocationTable
DD Section.reloc.vsize  ; Size
DD 0                    ; Debug
DD 0                    ; Size
DD 0                    ; Architecture
DD 0                    ; Size
DD 0                    ; GlobalPtr
DD 0                    ; Zero
DD 0                    ; TLSTable
DD 0                    ; Size
DD 0                    ; LoadConfigTable
DD 0                    ; Size
DD 0                    ; BoundImport
DD 0                    ; Size
DD 0                    ; IAT
DD 0                    ; Size
DD 0                    ; DelayImportDescriptor
DD 0                    ; Size
DD 0                    ; CLRRuntimeHeader
DD 0                    ; Size
DQ 0                    ; Reserved (must be zero)

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
mov r8,  Image.base + HelloWorld
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
DQ Image.base

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
DD Section.text.start
DD Reloc.text.vend - Reloc.text.vstart
DW 0xA013
DW 0xA01D
Reloc.text.vend:

Reloc.rdata.vstart:
DD Section.rdata.start
DD Reloc.rdata.vsize
DW 0xA040
DW 0
Reloc.rdata.vend:

Section.reloc.vend:
DB Section.reloc.size - ($ - $$) DUP 0

Image.vend:
