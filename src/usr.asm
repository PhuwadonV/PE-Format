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
DW 0x2022      ; Characteristics

COFF_Standard_Fields:
DW 0x020B      ; Magic
DB 0           ; MajorLinkerVersion
DB 0           ; MinorLinkerVersion
DD 0           ; SizeOfCode
DD 0           ; SizeOfInitializedData
DD 0           ; SizeOfUninitializedData
DD 0x          ; AddressOfEntryPoint
DD 0           ; BaseOfCode

Windows_Specific_Fields:
DQ 0x180000000 ; ImageBase
DD 0x1000      ; SectionAlignment
DD 0x200       ; FileAlignment
DW 0           ; MajorOperatingSystemVersion
DW 0           ; MinorOperatingSystemVersion
DW 0           ; MajorImageVersion
DW 0           ; MinorImageVersion
DW 0           ; MajorSubsystemVersion
DW 0           ; MinorSubsystemVersion
DD 0           ; Win32VersionValue
DD 0x4000      ; SizeOfImage
DD 0x200       ; SizeOfHeaders
DD 0           ; CheckSum
DW 0           ; Subsystem
DW 0x160       ; DllCharacteristics
DQ 0           ; SizeOfStackReserve
DQ 0           ; SizeOfStackCommit
DQ 0           ; SizeOfHeapReserve
DQ 0           ; SizeOfHeapCommit
DD 0           ; LoaderFlags
DD 16          ; NumberOfRvaAndSizes

Data_Directories:
DD 0x2020, 0    ; ExportTable          , Size
DD 0x2060, 0    ; ImportTable          , Size
DD 0     , 0    ; ResourceTable        , Size
DD 0x3000, 0x18 ; ExceptionTable       , Size
DD 0     , 0    ; CertificateTable     , Size
DD 0     , 0    ; BaseRelocationTable  , Size
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
DD 0xB8        ; VirtualSize
DD 0x1000      ; VirtualAddress
DD 0x200       ; SizeOfRawData
DD 0x200       ; PointerToRawData
DD 0           ; PointerToRelocations
DD 0           ; PointerToLinenumbers
DW 0           ; NumberOfRelocations
DW 0           ; NumberOfLinenumbers
DD 0x60000020  ; Characteristics

DB ".rdata", 0, 0
DD 0x130       ; VirtualSize
DD 0x2000      ; VirtualAddress
DD 0x200       ; SizeOfRawData
DD 0x400       ; PointerToRawData
DD 0           ; PointerToRelocations
DD 0           ; PointerToLinenumbers
DW 0           ; NumberOfRelocations
DW 0           ; NumberOfLinenumbers
DD 0x40000040  ; Characteristics

DB ".pdata", 0, 0
DD 0x18        ; VirtualSize
DD 0x3000      ; VirtualAddress
DD 0x200       ; SizeOfRawData
DD 0x600       ; PointerToRawData
DD 0           ; PointerToRelocations
DD 0           ; PointerToLinenumbers
DW 0           ; NumberOfRelocations
DW 0           ; NumberOfLinenumbers
DD 0x40000040  ; Characteristics

SECTION .text START=0x200 VSTART=0x1000
sub rsp, 32 + 8
ALIGN 8
call B
ALIGN 8
jmp A
ALIGN 8
or r9d, 0x10
ALIGN 8
A:
call [rel MessageBoxA]
ALIGN 8
xor eax, eax
ALIGN 8
add rsp, 32 + 8
ALIGN 8
ret

ALIGN 8
int3

ALIGN 8, int3
B:
sub rsp, 32 + 8
ALIGN 8
mov [rsp + 0x30], rcx
ALIGN 8
mov [rsp + 0x38], rdx
ALIGN 8
mov [rsp + 0x40], r8
ALIGN 8
mov [rsp + 0x48], r9
ALIGN 8
xor eax, eax
ALIGN 8
mov eax, [rax]
ALIGN 8
add rsp, 32 + 8
ALIGN 8
ret

ALIGN 8
int3

ALIGN 8, int3
mov eax, 1
ALIGN 8
ret

ALIGN 8
int3

ALIGN 8, int3
jmp [rel __C_specific_handler]
ALIGN 8

SECTION .rdata START=0x400 VSTART=0x2000
MessageBoxA:
DQ 0x20B0
DQ 0

__C_specific_handler:
DQ 0x20C9
DQ 0

DD 0
DD 0
DW 0
DW 0
DD 0x2052
DD 1
DD 1
DD 1
DD 0x2048
DD 0x204C
DD 0x2050

DD 0x1000

DD 0x205A

DW 0

DB "usr.dll", 0
DB "msg", 0

ALIGN 8, DB 0
DD 0x2090
DD 0
DD 0
DD 0x20BE
DD 0x2000

DD 0x20A0
DD 0
DD 0
DD 0x20E0
DD 0x2010

DQ 0

DQ 0x20B0
DQ 0

DQ 0x20C9
DQ 0

DW 0x284
DB "MessageBoxA", 0
DB "USER32.dll", 0
DW 0x8
DB "__C_specific_handler", 0
DB "VCRUNTIME140.dll", 0

ALIGN 8, DB 0
DB 9
DB 8
DB 1
DB 0
DB 0x04, 0x42
ALIGN 4, DB 0
DD 0x10B0
DD 1
DD 0x1008
DD 0x1010
DD 0x1098
DD 0x1018

DB 1
DB 0x28
DB 9
DB 0
DB 0x25, 0x94
DB 0x09, 0x00
DB 0x1D, 0x84
DB 0x08, 0x00
DB 0x15, 0x24
DB 0x07, 0x00
DB 0x0D, 0x14
DB 0x06, 0x00
DB 0x04, 0x42

SECTION .pdata START=0x600 VSTART=0x3000
DD 0x1000
DD 0x1088
DD 0x20F8

DD 0x1048
DD 0x1090
DD 0x2118

DB 0x200 - ($ - $$) DUP 0
