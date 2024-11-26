%INCLUDE "utl.asm"

SectionAlignment   EQU PageTableSize
FileAlignment      EQU DiskSectorSize

Characteristics    EQU 0x2022
DllCharacteristics EQU 0x160

Image.base         EQU 0x180000000

DefineSections     text, rdata

Section.text.char  EQU 0x60000020
Section.rdata.char EQU 0x40000040

SECTION Header START=0

Header.begin:

Header.DOS:
DB "MZ"                 ; e_magic
DB 0x3A DUP 0           ; Unused
DD Header.COFF          ; e_lfanew

Header.COFF:
DB "PE", 0, 0           ; Signature
DW Machine              ; Machine
DW NumberOfSections     ; NumberOfSections
DD 0                    ; TimeDateStamp
DD 0                    ; PointerToSymbolTable
DD 0                    ; NumberOfSymbols
DW SizeOfOptionalHeader ; SizeOfOptionalHeader
DW Characteristics      ; Characteristics

Header.Optional.begin:

Header.COFF.StandardFields:
DW Magic                ; Magic
DB 0                    ; MajorLinkerVersion
DB 0                    ; MinorLinkerVersion
DD 0                    ; SizeOfCode
DD 0                    ; SizeOfInitializedData
DD 0                    ; SizeOfUninitializedData
DD 0                    ; AddressOfEntryPoint
DD 0                    ; BaseOfCode

Header.COFF.WindowsSpecificFields:
DQ Image.base           ; ImageBase
DD SectionAlignment     ; SectionAlignment
DD FileAlignment        ; FileAlignment
DW 0                    ; MajorOperatingSystemVersion
DW 0                    ; MinorOperatingSystemVersion
DW 0                    ; MajorImageVersion
DW 0                    ; MinorImageVersion
DW 0                    ; MajorSubsystemVersion
DW 0                    ; MinorSubsystemVersion
DD 0                    ; Win32VersionValue
DD SizeOfImage          ; SizeOfImage
DD SizeOfHeaders        ; SizeOfHeaders
DD 0                    ; CheckSum
DW 0                    ; Subsystem
DW DllCharacteristics   ; DllCharacteristics
DQ 0                    ; SizeOfStackReserve
DQ 0                    ; SizeOfStackCommit
DQ 0                    ; SizeOfHeapReserve
DQ 0                    ; SizeOfHeapCommit
DD 0                    ; LoaderFlags
DD 16                   ; NumberOfRvaAndSizes

Header.COFF.DataDirectories:
DD ExportTable.begin    ;  1.1 : ExportTable
DD 0                    ;  1.2 : Size
DD ImportTable.begin    ;  2.1 : ImportTable
DD 0                    ;  2.2 : Size
DD 0                    ;  3.1 : ResourceTable
DD 0                    ;  3.2 : Size
DD 0                    ;  4.1 : ExceptionTable
DD 0                    ;  4.2 : Size
DD 0                    ;  5.1 : CertificateTable
DD 0                    ;  5.2 : Size
DD 0                    ;  6.1 : BaseRelocationTable
DD 0                    ;  6.2 : Size
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

Header.COFF.SectionTable.end:

Header.end:

SECTION .text START=Section.text.start VSTART=Section.text.vstart

Section.text.begin:

ALIGN 16
Func.exit:
jmp [rel FuncPtr.ExitProcess]

ALIGN 16
Func.sleep:
jmp [rel FuncPtr.Sleep]

Section.text.end:

SECTION .rdata START=Section.rdata.start VSTART=Section.rdata.vstart

Section.rdata.begin:

ALIGN 8, DB 0
ImportAddressTable.KERNEL32.begin:
FuncPtr.ExitProcess:
DQ FuncHintName.ExitProcess
FuncPtr.Sleep:
DQ FuncHintName.Sleep
DQ 0
ImportAddressTable.KERNEL32.end:

ALIGN 4, DB 0
ExportTable.begin:

ExportTable:
DD 0                                       ; ExportFlags
DD 0                                       ; TimeDateStamp
DW 0                                       ; MajorVersion
DW 0                                       ; MinorVersion
DD .Name                                   ; Name
DD 1                                       ; OrdinalBase
DD .AddressTable.end - .AddressTable.begin ; AddressTableEntries
DD .NamePointer.end - .NamePointer.begin   ; NumberOfNamePointers
DD .AddressTable.begin                     ; ExportAddressTable
DD .NamePointer.begin                      ; NamePointer
DD .OrdinalTable.begin                     ; OrdinalTable

.AddressTable.begin:
DD Func.exit
DD Func.sleep
.AddressTable.end:

.NamePointer.begin:
DD FuncName.exit
DD FuncName.sleep
.NamePointer.end:

.OrdinalTable.begin:
DW 0
DW 1
.OrdinalTable.end:

.Name:
DB "knl.dll", 0
FuncName.exit:
DB "exit", 0
FuncName.sleep:
DB "sleep", 0

ExportTable.end:

ALIGN 4, DB 0
ImportTable.begin:

ImportTable.knl:
DD ImportLookupTable.KERNEL32.begin  ; ImportLookupTable
DD 0                                 ; TimeDateStamp
DD 0                                 ; ForwarderChain
DD ImportName.knl                    ; Name
DD ImportAddressTable.KERNEL32.begin ; ImportAddressTable

DQ 0
ImportTable.end:

ALIGN 8, DB 0
ImportLookupTable.KERNEL32.begin:
DQ FuncHintName.ExitProcess
DQ FuncHintName.Sleep
DQ 0
ImportLookupTable.KERNEL32.end:

ALIGN 2, DB 0
FuncHintName.Sleep:
DW 0x5B4
DB "Sleep", 0
ALIGN 2, DB 0
FuncHintName.ExitProcess:
DW 0x178
DB "ExitProcess", 0
ImportName.knl:
DB "KERNEL32.dll", 0

Section.rdata.end:

DB FileAlignment - ($ - $$) % FileAlignment DUP 0
