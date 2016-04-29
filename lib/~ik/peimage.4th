\
\  peimage.4th
\
\  Copyright (C) 1999-2016 Illya Kysil
\
\  Win32 Portable Executable utils
\

REQUIRES" sysdict/struct.4th"

CR .( Loading PEIMAGE definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

STRUCT PE-HEADER
  CELL: PE_HEADER.Signature \ PE/0/0
  WORD: PE_HEADER.CPUtype   \ 14Ch - 386
  WORD: PE_HEADER.NumberOfSections
  CELL: PE_HEADER.TimeDateStamp
  CELL: PE_HEADER.PointerToSymbolTable
  CELL: PE_HEADER.NumberOfSymbols
  WORD: PE_HEADER.NTHDRsize
  WORD: PE_HEADER.Flags

  \ Standart fields

  WORD: PE_HEADER.Magic
  BYTE: PE_HEADER.MajorLinkedVersion
  BYTE: PE_HEADER.MinorLinkedVersion
  CELL: PE_HEADER.SizeOfCode
  CELL: PE_HEADER.SizeOfInitializedData
  CELL: PE_HEADER.SizeOfUninitializedData
  CELL: PE_HEADER.AddresOfEntryPoint
  CELL: PE_HEADER.BaseOfCode
  CELL: PE_HEADER.BaseOfData

  \ NT Additional fields

  CELL: PE_HEADER.ImageBase
  CELL: PE_HEADER.SectionAlignment
  CELL: PE_HEADER.FileAlignment
  WORD: PE_HEADER.OSMajor
  WORD: PE_HEADER.OSMinor
  WORD: PE_HEADER.UserMajor
  WORD: PE_HEADER.UserMinor
  WORD: PE_HEADER.SubsysMajor
  WORD: PE_HEADER.SubsysMinor
  CELL: PE_HEADER.Reserved1
  CELL: PE_HEADER.ImageSize
  CELL: PE_HEADER.HeaderSize
  CELL: PE_HEADER.FileChecksum
  WORD: PE_HEADER.Subsystem
  WORD: PE_HEADER.DLLFlags
  CELL: PE_HEADER.StackReserve
  CELL: PE_HEADER.StackCommitSize
  CELL: PE_HEADER.HeapReserveSize
  CELL: PE_HEADER.HeapCommitSize
  CELL: PE_HEADER.LoaderFlags
  CELL: PE_HEADER.NumberOfRvaAndSizes

  \ IMAGE_DATA_DIRECTORY

  CELL: PE_HEADER.ExportTableRVA
  CELL: PE_HEADER.TotalExportDataSize
  CELL: PE_HEADER.ImportTableRVA
  CELL: PE_HEADER.TotalImportDataSize
  CELL: PE_HEADER.ResourceTableRVA
  CELL: PE_HEADER.TotalResourceDataSize
  CELL: PE_HEADER.ExceptionTableRVA
  CELL: PE_HEADER.TotalExceptionDataSize
  CELL: PE_HEADER.SecurityTableRVA
  CELL: PE_HEADER.TotalSecurityDataSize
  CELL: PE_HEADER.RelocationTableRVA
  CELL: PE_HEADER.TotalRelocationDataSize
  CELL: PE_HEADER.DebugTableRVA
  CELL: PE_HEADER.TotalDebugDataSize
  CELL: PE_HEADER.MachineValueTableRVA
  CELL: PE_HEADER.TotalMachineValueDataSize
  CELL: PE_HEADER.GlobalPtrTableRVA
  CELL: PE_HEADER.TotalGlobalPtrDataSize
  CELL: PE_HEADER.TLSTableRVA
  CELL: PE_HEADER.TotalTLSDataSize
  CELL: PE_HEADER.LoadConfigurationTableRVA
  CELL: PE_HEADER.TotalLoadConfigurationDataSize
  CELL: PE_HEADER.BoundImportTableRVA
  CELL: PE_HEADER.TotalBoundImportDataSize
  CELL: PE_HEADER.IATTableRVA
  CELL: PE_HEADER.TotalIATDataSize
  CELL: PE_HEADER.DelayImportTableRVA
  CELL: PE_HEADER.TotalDelayImportDataSize

  2 2CELLS: PE_HEADER.ReservedSections
ENDSTRUCT
PE-HEADER STRUCT-SIZEOF CONSTANT /PE-HEADER

STRUCT ObjectTable
  8 BYTES: ObjectTable.ObjectName     \ CODE\0\0\0\0
  CELL: ObjectTable.VirtualSize       \ size in memory
  CELL: ObjectTable.RVA               \ Relative Virtual Address
  CELL: ObjectTable.PhysicalSize      \ size in file
  CELL: ObjectTable.PhysicalOffset    \ offset in file
  CELL: ObjectTable.Res1              \ pointer to relocations
  CELL: ObjectTable.Res2              \ pointer to line numbers
  WORD: ObjectTable.Res3              \ number of relocations
  WORD: ObjectTable.Res4              \ number of line numbers
  CELL: ObjectTable.ObjectFlags       \ 60000020h=read/execute code
                                      \ E0000060h=read/write data
ENDSTRUCT
ObjectTable STRUCT-SIZEOF CONSTANT /ObjectTable

STRUCT ImportDirectory
  CELL: ImportDirectory.ImportLookupTableRVA
  CELL: ImportDirectory.TimeDateStamp
  WORD: ImportDirectory.MajorVersion
  WORD: ImportDirectory.MinorVersion
  CELL: ImportDirectory.NameRVA               \ DLL name pointer
  CELL: ImportDirectory.ImportAddressTableRVA
ENDSTRUCT
ImportDirectory STRUCT-SIZEOF CONSTANT /ImportDirectory

STRUCT ExportDirectory
  CELL: ExportDirectory.ExportFlags       \ 0
  CELL: ExportDirectory.TimeDateStamp     \ 0
  WORD: ExportDirectory.MajorVersion      \ 0
  WORD: ExportDirectory.MinorVersion      \ 0
  CELL: ExportDirectory.NameRVA           \ DLL name pointer
  CELL: ExportDirectory.OrdinalBase       \ 1
  CELL: ExportDirectory.NumberOfFunctions
  CELL: ExportDirectory.NumberOfNames
  CELL: ExportDirectory.AddressTableRVA
  CELL: ExportDirectory.NamePtrTableRVA
  CELL: ExportDirectory.OrdinalTableRVA
ENDSTRUCT
ExportDirectory STRUCT-SIZEOF CONSTANT /ExportDirectory

REPORT-NEW-NAME !
