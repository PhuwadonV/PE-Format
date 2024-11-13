BITS 64

SECTION .header START=0
DOS_Header:
DB "MZ"
DB 0x3A DUP 0
DD COFF_Header

COFF_Header:
DB "PE", 0, 0
DW 0x8664      ; Machine
DW 3           ; NumberOfSections
DD 0           ; TimeDateStamp
DD 0           ; PointerToSymbolTable
DD 0           ; NumberOfSymbols
DW 0xF0        ; SizeOfOptionalHeader
DW 0x0022      ; Characteristics

COFF_Standard_Fields:
DW 0x020B      ; Magic
DB 0           ; MajorLinkerVersion
DB 0           ; MinorLinkerVersion
DD 0           ; SizeOfCode
DD 0           ; SizeOfInitializedData
DD 0           ; SizeOfUninitializedData
DD 0x1000      ; AddressOfEntryPoint
DD 0           ; BaseOfCode

Windows_Specific_Fields:
DQ 0x140000000 ; ImageBase
DD 0x1000      ; SectionAlignment
DD 0x200       ; FileAlignment
DW 0           ; MajorOperatingSystemVersion
DW 0           ; MinorOperatingSystemVersion
DW 0           ; MajorImageVersion
DW 0           ; MinorImageVersion
DW 6           ; MajorSubsystemVersion
DW 0           ; MinorSubsystemVersion
DD 0           ; Win32VersionValue
DD 0x4000      ; SizeOfImage
DD 0x200       ; SizeOfHeaders
DD 0           ; CheckSum
DW 0x3         ; Subsystem
DW 0x8160      ; DllCharacteristics
DQ 0           ; SizeOfStackReserve
DQ 0           ; SizeOfStackCommit
DQ 0           ; SizeOfHeapReserve
DQ 0           ; SizeOfHeapCommit
DD 0           ; LoaderFlags
DD 16          ; NumberOfRvaAndSizes

Data_Directories:
DD 0     , 0    ; ExportTable          , Size
DD 0x2048, 0    ; ImportTable          , Size
DD 0     , 0    ; ResourceTable        , Size
DD 0     , 0    ; ExceptionTable       , Size
DD 0     , 0    ; CertificateTable     , Size
DD 0x3000, 0x18 ; BaseRelocationTable  , Size
DD 0     , 0    ; Debug                , Size
DD 0     , 0    ; Architecture         , Size
DD 0     , 0    ; GlobalPtr            , Zero
DD 0     , 0    ; TLSTable             , Size
DD 0     , 0    ; LoadConfigTable      , Size
DD 0     , 0    ; BoundImport          , Size
DD 0     , 0    ; IAT                  , Size
DD 0     , 0    ; DelayImportDescriptor, Size
DD 0     , 0    ; CLRRuntimeHeader     , Size
DQ 0            ; Reserved (must be zero)

Section_Table:
DB ".text", 0, 0, 0
DD 0x39        ; VirtualSize
DD 0x1000      ; VirtualAddress
DD 0x200       ; SizeOfRawData
DD 0x200       ; PointerToRawData
DD 0           ; PointerToRelocations
DD 0           ; PointerToLinenumbers
DW 0           ; NumberOfRelocations
DW 0           ; NumberOfLinenumbers
DD 0x60000020  ; Characteristics

DB ".rdata", 0, 0
DD 0xC8        ; VirtualSize
DD 0x2000      ; VirtualAddress
DD 0x200       ; SizeOfRawData
DD 0x400       ; PointerToRawData
DD 0           ; PointerToRelocations
DD 0           ; PointerToLinenumbers
DW 0           ; NumberOfRelocations
DW 0           ; NumberOfLinenumbers
DD 0x40000040  ; Characteristics

DB ".reloc", 0, 0
DD 0x18        ; VirtualSize
DD 0x3000      ; VirtualAddress
DD 0x200       ; SizeOfRawData
DD 0x600       ; PointerToRawData
DD 0           ; PointerToRelocations
DD 0           ; PointerToLinenumbers
DW 0           ; NumberOfRelocations
DW 0           ; NumberOfLinenumbers
DD 0x42000040  ; Characteristics

SECTION .text START=0x200 VSTART=0x1000
sub rsp, 32 + 8
mov ecx, 0x800
call [rel Sleep]
xor ecx, ecx
mov rdx, 0x140002030
mov r8, 0x140002030
xor r9, r9
call [rel MSG]
mov ecx, 1234567890
call [rel Exit]

SECTION .rdata START=0x400 VSTART=0x2000
Exit:
DQ 0x20A8
Sleep:
DQ 0x20A0
DQ 0

MSG:
DQ 0x20B8
DQ 0

ALIGN 16, DB 0
DB "Hello, World!", 0

ALIGN 8, DB 0
DQ 0x140000000

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

SECTION .reloc START=0x600 VSTART=0x3000
DD 0x1000
DD 0xC
DW 0xA013
DW 0xA01D

DD 0x2000
DD 0xC
DW 0xA040
DW 0

DB 0x200 - ($ - $$) DUP 0
