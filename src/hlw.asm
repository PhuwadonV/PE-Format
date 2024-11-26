%INCLUDE "utl.asm"

SectionAlignment      EQU PageTableSize
FileAlignment         EQU DiskSectorSize

Subsystem             EQU 0x3
MajorSubsystemVersion EQU 6
Characteristics       EQU 0x22
DllCharacteristics    EQU 0x8160

Image.base            EQU 0x140000000

DefineSections        text, rdata, reloc

Section.text.char     EQU 0x60000020
Section.rdata.char    EQU 0x40000040
Section.reloc.char    EQU 0x42000040

SECTION Header START=0

Header.begin:

Header.DOS:
DB "MZ"                  ; e_magic
DB 0x3A DUP 0            ; Unused
DD Header.COFF           ; e_lfanew

Header.COFF:
DB "PE", 0, 0            ; Signature
DW Machine               ; Machine
DW NumberOfSections      ; NumberOfSections
DD 0                     ; TimeDateStamp
DD 0                     ; PointerToSymbolTable
DD 0                     ; NumberOfSymbols
DW SizeOfOptionalHeader  ; SizeOfOptionalHeader
DW Characteristics       ; Characteristics

Header.Optional.begin:

Header.COFF.StandardFields:
DW Magic                 ; Magic
DB 0                     ; MajorLinkerVersion
DB 0                     ; MinorLinkerVersion
DD 0                     ; SizeOfCode
DD 0                     ; SizeOfInitializedData
DD 0                     ; SizeOfUninitializedData
DD Section.text.vstart   ; AddressOfEntryPoint
DD 0                     ; BaseOfCode

Header.COFF.WindowsSpecificFields:
DQ Image.base            ; ImageBase
DD SectionAlignment      ; SectionAlignment
DD FileAlignment         ; FileAlignment
DW 0                     ; MajorOperatingSystemVersion
DW 0                     ; MinorOperatingSystemVersion
DW 0                     ; MajorImageVersion
DW 0                     ; MinorImageVersion
DW MajorSubsystemVersion ; MajorSubsystemVersion
DW 0                     ; MinorSubsystemVersion
DD 0                     ; Win32VersionValue
DD SizeOfImage           ; SizeOfImage
DD SizeOfHeaders         ; SizeOfHeaders
DD 0                     ; CheckSum
DW Subsystem             ; Subsystem
DW DllCharacteristics    ; DllCharacteristics
DQ 0                     ; SizeOfStackReserve
DQ 0                     ; SizeOfStackCommit
DQ 0                     ; SizeOfHeapReserve
DQ 0                     ; SizeOfHeapCommit
DD 0                     ; LoaderFlags
DD 16                    ; NumberOfRvaAndSizes

Header.COFF.DataDirectories:
DD 0                     ;  1.1 : ExportTable
DD 0                     ;  1.2 : Size
DD ImportTable.begin     ;  2.1 : ImportTable
DD 0                     ;  2.2 : Size
DD 0                     ;  3.1 : ResourceTable
DD 0                     ;  3.2 : Size
DD 0                     ;  4.1 : ExceptionTable
DD 0                     ;  4.2 : Size
DD 0                     ;  5.1 : CertificateTable
DD 0                     ;  5.2 : Size
DD Section.reloc.vstart  ;  6.1 : BaseRelocationTable
DD Section.reloc.vsize   ;  6.2 : Size
DD 0                     ;  7.1 : Debug
DD 0                     ;  7.2 : Size
DD 0                     ;  8.1 : Architecture
DD 0                     ;  8.2 : Size
DD 0                     ;  9.1 : GlobalPtr
DD 0                     ;  9.2 : Zero
DD 0                     ; 10.1 : TLSTable
DD 0                     ; 10.2 : Size
DD 0                     ; 11.1 : LoadConfigTable
DD 0                     ; 11.2 : Size
DD 0                     ; 12.1 : BoundImport
DD 0                     ; 12.2 : Size
DD 0                     ; 13.1 : IAT
DD 0                     ; 13.2 : Size
DD 0                     ; 14.1 : DelayImportDescriptor
DD 0                     ; 14.2 : Size
DD 0                     ; 15.1 : CLRRuntimeHeader
DD 0                     ; 15.2 : Size
DQ 0                     ; 16   : Reserved (must be zero)

Header.Optional.end:

Header.COFF.SectionTable.begin:

DB ".text"              ; Name (Size < 8 bytes)
ALIGN 8, DB 0
DD Section.text.vsize   ; VirtualSize
DD Section.text.vstart  ; VirtualAddress
DD Section.text.size    ; SizeOfRawData
DD Section.text.start   ; PointerToRawData
DD 0                    ; PointerToRelocations
DD 0                    ; PointerToLinenumbers
DW 0                    ; NumberOfRelocations
DW 0                    ; NumberOfLinenumbers
DD Section.text.char    ; Characteristics

DB ".rdata"             ; Name (Size < 8 bytes)
ALIGN 8, DB 0
DD Section.rdata.vsize  ; VirtualSize
DD Section.rdata.vstart ; VirtualAddress
DD Section.rdata.size   ; SizeOfRawData
DD Section.rdata.start  ; PointerToRawData
DD 0                    ; PointerToRelocations
DD 0                    ; PointerToLinenumbers
DW 0                    ; NumberOfRelocations
DW 0                    ; NumberOfLinenumbers
DD Section.rdata.char   ; Characteristics

DB ".reloc"             ; Name (Size < 8 bytes)
ALIGN 8, DB 0
DD Section.reloc.vsize  ; VirtualSize
DD Section.reloc.vstart ; VirtualAddress
DD Section.reloc.size   ; SizeOfRawData
DD Section.reloc.start  ; PointerToRawData
DD 0                    ; PointerToRelocations
DD 0                    ; PointerToLinenumbers
DW 0                    ; NumberOfRelocations
DW 0                    ; NumberOfLinenumbers
DD Section.reloc.char   ; Characteristics

Header.COFF.SectionTable.end:

Header.end:

SECTION .text START=Section.text.start VSTART=Section.text.vstart

Section.text.begin:

ALIGN 16
sub rsp, 32 + 8
mov ecx, 2000
call [rel FuncPtr.sleep]
xor ecx, ecx
mov rdx, Image.base + HelloWorld
Reloc.text.1.end:
mov r8,  Image.base + HelloWorld
Reloc.text.2.end:
xor r9, r9
call [rel FuncPtr.msg]
mov ecx, 1234567890
call [rel FuncPtr.exit]

Section.text.end:

SECTION .rdata START=Section.rdata.start VSTART=Section.rdata.vstart

Section.rdata.begin:

ALIGN 8, DB 0
ImportAddressTable.knl.begin:
FuncPtr.sleep:
DQ FuncHintName.sleep
FuncPtr.exit:
DQ FuncHintName.exit
DQ 0
ImportAddressTable.knl.end:

ALIGN 8, DB 0
ImportAddressTable.usr.begin:
FuncPtr.msg:
DQ FuncHintName.msg
DQ 0
ImportAddressTable.usr.end:

HelloWorld:
DB "Hello, World!", 0

ALIGN 8, DB 0
Reloc.rdata.1:
DQ Image.base                   ; Reloc Example

ALIGN 4, DB 0
ImportTable.begin:

ImportTable.knl:
DD ImportLookupTable.knl.begin  ; ImportLookupTable
DD 0                            ; TimeDateStamp
DD 0                            ; ForwarderChain
DD ImportName.knl               ; Name
DD ImportAddressTable.knl.begin ; ImportAddressTable

ImportTable.usr:
DD ImportLookupTable.usr.begin  ; ImportLookupTable
DD 0                            ; TimeDateStamp
DD 0                            ; ForwarderChain
DD ImportName.usr               ; Name
DD ImportAddressTable.usr.begin ; ImportAddressTable

DQ 0
ImportTable.end:

ALIGN 8, DB 0
ImportLookupTable.knl.begin:
DQ FuncHintName.sleep
DQ FuncHintName.exit
DQ 0
ImportLookupTable.knl.end:

ALIGN 8, DB 0
ImportLookupTable.usr.begin:
DQ FuncHintName.msg
DQ 0
ImportLookupTable.usr.end:

ALIGN 2, DB 0
FuncHintName.exit:
DW 0
DB "exit", 0
ALIGN 2, DB 0
FuncHintName.sleep:
DW 1
DB "sleep", 0
ImportName.knl:
DB "knl.dll", 0

ALIGN 2, DB 0
FuncHintName.msg:
DW 0
DB "msg", 0
ImportName.usr:
DB "usr.dll", 0

Section.rdata.end:

SECTION .reloc START=Section.reloc.start VSTART=Section.reloc.vstart

Section.reloc.begin:

ALIGN 4, DB 0
Reloc.text:
.begin:
DD Section.text.vstart                                 ; Page
DD .end - .begin                                       ; BlockSize
DW 0xA000 - Section.text.vstart + Reloc.text.1.end - 8
DW 0xA000 - Section.text.vstart + Reloc.text.2.end - 8
ALIGN 4, DB 0
.end:

ALIGN 4, DB 0
Reloc.rdata:
.begin:
DD Section.rdata.vstart                                ; Page
DD .end - .begin                                       ; BlockSize
DW 0xA000 - Section.rdata.vstart + Reloc.rdata.1
ALIGN 4, DB 0
.end:

Section.reloc.end:

DB FileAlignment - ($ - $$) % FileAlignment DUP 0
