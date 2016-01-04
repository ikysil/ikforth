\
\  peimage.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\
\  Win32 Portable Executable utils
\

REQUIRES" lib\~ik\struct.f"

CR .( Loading PEIMAGE definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME ON

STRUCTURE PE-HEADER
  CELL: Signature \ PE/0/0
  WORD: CPUtype   \ 14Ch - 386
  WORD: NumberOfSections
  CELL: TimeDateStamp
  CELL: PointerToSymbolTable
  CELL: NumberOfSymbols
  WORD: NTHDRsize
  WORD: Flags
 
  \ Standart fields
 
  WORD: Magic
  BYTE: MajorLinkedVersion
  BYTE: MinorLinkedVersion
  CELL: SizeOfCode
  CELL: SizeOfInitializedData
  CELL: SizeOfUninitializedData
  CELL: AddresOfEntryPoint
  CELL: BaseOfCode
  CELL: BaseOfData
 
  \ NT Additional fields
 
  CELL: ImageBase
  CELL: SectionAlignment
  CELL: FileAlignment
  WORD: OSMajor
  WORD: OSMinor
  WORD: UserMajor
  WORD: UserMinor
  WORD: SubsysMajor
  WORD: SubsysMinor
  CELL: Reserved1
  CELL: ImageSize
  CELL: HeaderSize
  CELL: FileChecksum
  WORD: Subsystem
  WORD: DLLFlags
  CELL: StackReserve
  CELL: StackCommitSize
  CELL: HeapReserveSize
  CELL: HeapCommitSize
  CELL: LoaderFlags
  CELL: NumberOfRvaAndSizes
 
  \ IMAGE_DATA_DIRECTORY
 
  CELL: ExportTableRVA
  CELL: TotalExportDataSize
  CELL: ImportTableRVA
  CELL: TotalImportDataSize
  CELL: ResourceTableRVA
  CELL: TotalResourceDataSize
  CELL: ExceptionTableRVA
  CELL: TotalExceptionDataSize
  CELL: SecurityTableRVA
  CELL: TotalSecurityDataSize
  CELL: RelocationTableRVA
  CELL: TotalRelocationDataSize
  CELL: DebugTableRVA
  CELL: TotalDebugDataSize
  CELL: MachineValueTableRVA
  CELL: TotalMachineValueDataSize
  CELL: GlobalPtrTableRVA
  CELL: TotalGlobalPtrDataSize
  CELL: TLSTableRVA
  CELL: TotalTLSDataSize
  CELL: LoadConfigurationTableRVA
  CELL: TotalLoadConfigurationDataSize
  CELL: BoundImportTableRVA
  CELL: TotalBoundImportDataSize
  CELL: IATTableRVA
  CELL: TotalIATDataSize
  CELL: DelayImportTableRVA
  CELL: TotalDelayImportDataSize
  
  2 2CELLS: ReservedSections
ENDSTRUCTURE
SIZEOF PE-HEADER CONSTANT /PE-HEADER

STRUCTURE ObjectTable
  8 BYTES: OT.ObjectName        \ CODE\0\0\0\0
  CELL: OT.VirtualSize       \ size in memory
  CELL: OT.RVA               \ Relative Virtual Address
  CELL: OT.PhysicalSize      \ size in file
  CELL: OT.PhysicalOffset    \ offset in file
  CELL: OT.Res1              \ pointer to relocations
  CELL: OT.Res2              \ pointer to line numbers
  WORD: OT.Res3              \ number of relocations
  WORD: OT.Res4              \ number of line numbers
  CELL: OT.ObjectFlags       \ 60000020h=read/execute code
                             \ E0000060h=read/write data
ENDSTRUCTURE
SIZEOF ObjectTable CONSTANT /ObjectTable

STRUCTURE ImportDirectory
  CELL: ID.ImportLookupTableRVA  
  CELL: ID.TimeDateStamp
  WORD: ID.MajorVersion
  WORD: ID.MinorVersion
  CELL: ID.NameRVA               \ DLL name pointer
  CELL: ID.ImportAddressTableRVA 
ENDSTRUCTURE
SIZEOF ImportDirectory CONSTANT /ImportDirectory

STRUCTURE ExportDirectory
  CELL: ED.ExportFlags       \ 0
  CELL: ED.TimeDateStamp     \ 0
  WORD: ED.MajorVersion      \ 0
  WORD: ED.MinorVersion      \ 0
  CELL: ED.NameRVA           \ DLL name pointer
  CELL: ED.OrdinalBase       \ 1
  CELL: ED.NumberOfFunctions
  CELL: ED.NumberOfNames
  CELL: ED.AddressTableRVA   
  CELL: ED.NamePtrTableRVA   
  CELL: ED.OrdinalTableRVA   
ENDSTRUCTURE
SIZEOF ExportDirectory CONSTANT /ExportDirectory

REPORT-NEW-NAME !
