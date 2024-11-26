%INCLUDE "utl.asm"

SectionAlignment   EQU PageTableSize
FileAlignment      EQU DiskSectorSize

Characteristics    EQU 0x2022
DllCharacteristics EQU 0x160

Image.base         EQU 0x180000000

DefineSections     text, rdata, pdata

Section.text.char  EQU 0x60000020
Section.rdata.char EQU 0x40000040
Section.pdata.char EQU 0x40000040

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
DD Section.pdata.vstart ;  4.1 : ExceptionTable
DD Section.pdata.vsize  ;  4.2 : Size
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

DB ".pdata"             ; Name (Size < 8 bytes)
ALIGN 8, DB 0
DD Section.pdata.vsize  ; VirtualSize
DD Section.pdata.vstart ; VirtualAddress
DD Section.pdata.size   ; SizeOfRawData
DD Section.pdata.start  ; PointerToRawData
DD 0                    ; PointerToRelocations
DD 0                    ; PointerToLinenumbers
DW 0                    ; NumberOfRelocations
DW 0                    ; NumberOfLinenumbers
DD Section.pdata.char   ; Characteristics

Header.COFF.SectionTable.end:

Header.end:

SECTION .text START=Section.text.start VSTART=Section.text.vstart

Section.text.begin:

ALIGN 16
Func.msg:
.begin:
.prolog.begin:
sub rsp, 32 + 8
.prolog.1:
.prolog.end:
.exception.1.try.begin:
call Func.readAddrZero
jmp .exception.1.catch.end
.exception.1.try.end:
.exception.1.catch.begin:
or r9d, 0x10
ALIGN 16
.exception.1.catch.end:
call [rel FuncPtr.MessageBoxA]
xor eax, eax
add rsp, 32 + 8
ret
.end:

ALIGN 16
Func.readAddrZero:
.begin:
.prolog.begin:
sub rsp, 32 + 8
.prolog.1:
mov [rsp + 0x30], rcx
.prolog.2:
mov [rsp + 0x38], rdx
.prolog.3:
mov [rsp + 0x40], r8
.prolog.4:
mov [rsp + 0x48], r9
.prolog.5:
.prolog.end:
xor eax, eax
mov eax, [rax]
add rsp, 32 + 8
ret
.end:

ALIGN 16
Func.msg.exception.1.handler:
mov eax, 1
ret

ALIGN 16
Func.__C_specific_handler:
jmp [rel FuncPtr.__C_specific_handler]

Section.text.end:

SECTION .rdata START=Section.rdata.start VSTART=Section.rdata.vstart

Section.rdata.begin:

ALIGN 8, DB 0
ImportAddressTable.USER32.begin:
FuncPtr.MessageBoxA:
DQ FuncHintName.MessageBoxA
DQ 0
ImportAddressTable.USER32.end:

ALIGN 8, DB 0
ImportAddressTable.VCRUNTIME140.begin:
FuncPtr.__C_specific_handler:
DQ FuncHintName.__C_specific_handler
DQ 0
ImportAddressTable.VCRUNTIME140.end:

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
DD Func.msg
.AddressTable.end:

.NamePointer.begin:
DD FuncName.msg
.NamePointer.end:

.OrdinalTable.begin:
DW 0
.OrdinalTable.end:

.Name:
DB "usr.dll", 0
FuncName.msg:
DB "msg", 0

ExportTable.end:

ALIGN 4, DB 0
ImportTable.begin:

ImportTable.USER32:
DD ImportLookupTable.USER32.begin        ; ImportLookupTable
DD 0                                     ; TimeDateStamp
DD 0                                     ; ForwarderChain
DD ImportName.USER32                     ; Name
DD ImportAddressTable.USER32.begin       ; ImportAddressTable

ImportTable.VCRUNTIME140:
DD ImportLookupTable.VCRUNTIME140.begin  ; ImportLookupTable
DD 0                                     ; TimeDateStamp
DD 0                                     ; ForwarderChain
DD ImportName.VCRUNTIME140               ; Name
DD ImportAddressTable.VCRUNTIME140.begin ; ImportAddressTable

DQ 0
ImportTable.end:

ALIGN 8, DB 0
ImportLookupTable.USER32.begin:
DQ FuncHintName.MessageBoxA
DQ 0
ImportLookupTable.USER32.end:

ALIGN 8, DB 0
ImportLookupTable.VCRUNTIME140.begin:
DQ FuncHintName.__C_specific_handler
DQ 0
ImportLookupTable.VCRUNTIME140.end:

ALIGN 2, DB 0
FuncHintName.MessageBoxA:
DW 0
DB "MessageBoxA", 0
ImportName.USER32:
DB "USER32.dll", 0

ALIGN 2, DB 0
FuncHintName.__C_specific_handler:
DW 0
DB "__C_specific_handler", 0
ImportName.VCRUNTIME140:
DB "VCRUNTIME140.dll", 0

ALIGN 8, DB 0

ALIGN 2, DB 0
Func.msg.unwindInfo:
.begin:
DB 0b000 | 0x8                                  ; Version | Flags
DB Func.msg.prolog.end - Func.msg.prolog.begin  ; SizeOfProlog
DB (.code.end - .code.begin) / 2                ; CountOfunwindInfoCodes
DB 0                                            ; FrameRegister | FrameOffset

.code.begin:
DB Func.msg.prolog.1, 0x02 | (((32 + 8) / 8) - 1) << 4
.code.end:

ALIGN 4, DB 0
DD Func.__C_specific_handler               ; ExceptionHandler
DD (.scopes.end - .scopes.begin) / (4 * 4) ; Count

.scopes.begin:
DD Func.msg.exception.1.try.begin   ; BeginAddress
DD Func.msg.exception.1.try.end     ; EndAddress
DD Func.msg.exception.1.handler     ; HandlerAddress
DD Func.msg.exception.1.catch.begin ; JumpTarget
.scopes.end:

.end:

ALIGN 2, DB 0
Func.readAddrZero.unwindInfo:
.begin:
DB 0b000 | 0x0                                                   ; Version | Flags
DB Func.readAddrZero.prolog.end - Func.readAddrZero.prolog.begin ; SizeOfProlog
DB (.code.end - .code.begin) / 2                                 ; CountOfunwindInfoCodes
DB 0                                                             ; FrameRegister | FrameOffset

.code.begin:
DB Func.readAddrZero.prolog.5 - Func.readAddrZero.prolog.begin, 0x04 | 0x90
DB 0x48 / 8                                                   , 0x00
DB Func.readAddrZero.prolog.4 - Func.readAddrZero.prolog.begin, 0x04 | 0x80
DB 0x40 / 8                                                   , 0x00
DB Func.readAddrZero.prolog.3 - Func.readAddrZero.prolog.begin, 0x04 | 0x20
DB 0x38 / 8                                                   , 0x00
DB Func.readAddrZero.prolog.2 - Func.readAddrZero.prolog.begin, 0x04 | 0x10
DB 0x30 / 8                                                   , 0x00
DB Func.readAddrZero.prolog.1 - Func.readAddrZero.prolog.begin, 0x02 | (((32 + 8) / 8) - 1) << 4
.code.end:

.end:

Section.rdata.end:

SECTION .pdata START=Section.pdata.start VSTART=Section.pdata.vstart

Section.pdata.begin:

DD Func.msg.begin               ; BeginAddress
DD Func.msg.end                 ; EndAddress
DD Func.msg.unwindInfo          ; unwindInfoInformation

DD Func.readAddrZero.begin      ; BeginAddress
DD Func.readAddrZero.end        ; EndAddress
DD Func.readAddrZero.unwindInfo ; unwindInfoInformation

Section.pdata.end:

DB FileAlignment - ($ - $$) % FileAlignment DUP 0
