BITS 64
Machine               EQU 0x8664
Magic                 EQU 0x020B

PageTableSize         EQU 0x1000
DiskSectorSize        EQU 0x200

%XDEFINE AlignSize(Align, Size) (Align) * (((Size) / (Align)) + 1)

SizeOfHeaders         EQU AlignSize(FileAlignment, Header.end - Header.begin)
SizeOfOptionalHeader  EQU Header.Optional.end - Header.Optional.begin

%MACRO DefineSections 1-*
    NumberOfSections    EQU %0

    Section.%{1}.start  EQU SizeOfHeaders
    Section.%{1}.size   EQU AlignSize(FileAlignment, Section.%{1}.vsize)
    Section.%{1}.vstart EQU AlignSize(SectionAlignment, SizeOfHeaders)
    Section.%{1}.vsize  EQU Section.text.end - Section.text.begin

    %REP %0 - 1
        Section.%{2}.start  EQU Section.%{1}.size + Section.%{1}.start
        Section.%{2}.size   EQU AlignSize(FileAlignment, Section.%{2}.vsize)
        Section.%{2}.vstart EQU AlignSize(SectionAlignment, Section.%{1}.vsize) + Section.%{1}.vstart
        Section.%{2}.vsize  EQU Section.%{2}.end - Section.%{2}.begin
        %ROTATE 1
    %ENDREP

    SizeOfImage EQU AlignSize(SectionAlignment, Section.%{1}.vsize) + Section.%{1}.vstart
%ENDMACRO
