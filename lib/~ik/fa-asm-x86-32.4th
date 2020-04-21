PURPOSE: Forth-Assisted Assembler for x86 32 bits and 16 bits mode
LICENSE: Unlicense since 1999 by Illya Kysil

\ Goals:
\ * compile x86 32 bits instructions
\ * self-hosting meta-compiler for IKForth
\ Non-goals:
\ * syntax compatibility with existing assemblers
\ * support for full set of instructions
\ References:
\ * Intel® 64 and IA-32 Architectures Software Developer’s Manual Volume 2D: Instruction Set Reference

REPORT-NEW-NAME @
REPORT-NEW-NAME ON

ONLY FORTH DEFINITIONS

VOCABULARY FAASM8632-PRIVATE

ALSO FAASM8632-PRIVATE DEFINITIONS

\ private definitions go here

\G Compile a 8-bits value (S x -- )
DEFER asm8,

' C, IS asm8,

\G Compile a 16-bits value - always LSB first (S x -- )
\G Uses asm8, for actual compilation.
: asm16,
   DUP
   H# FF AND asm8, 8 RSHIFT
   H# FF AND asm8,
;

\G Compile a 32-bits value - always LSB first (S x -- )
\G Uses asm8, for actual compilation.
: asm32,
   DUP
   H# FF AND asm8, 8 RSHIFT DUP
   H# FF AND asm8, 8 RSHIFT DUP
   H# FF AND asm8, 8 RSHIFT
   H# FF AND asm8,
;

\ Conditions

\G Overflow
B# 0000  CONSTANT ?O

\G No overflow
B# 0001  CONSTANT ?NO

\G Below, Not above or equal
B# 0010  CONSTANT ?B
?B       CONSTANT ?NAE

\G Not below, Above or equal
B# 0011  CONSTANT ?NB
?NB      CONSTANT ?AE

\G Equal, Zero
B# 0100  CONSTANT ?Z
?Z       CONSTANT ?E

\G Not equal, Not zero
B# 0101  CONSTANT ?NZ
?NZ      CONSTANT ?NE

\G Below or equal, Not above
B# 0110  CONSTANT ?NA
?NA      CONSTANT ?BE

\G Not below or equal, Above
B# 0111  CONSTANT ?A
?A       CONSTANT ?NBE

\G Sign
B# 1000  CONSTANT ?S

\G Not sign
B# 1001  CONSTANT ?NS

\G Parity, Parity Even
B# 1010  CONSTANT ?P
?P       CONSTANT ?PE

\G Not parity, Parity Odd
B# 1011  CONSTANT ?PO
?PO      CONSTANT ?NP

\G Less than, Not greater than or equal to
B# 1100  CONSTANT ?L
?L       CONSTANT ?NGE

\G Not less than, Greater than or equal to
B# 1101  CONSTANT ?NL
?NL      CONSTANT ?GE

\G Less than or equal to, Not greater than
B# 1110  CONSTANT ?NG
?NG      CONSTANT ?LE

\G Not less than or equal to, Greater than
B# 1111  CONSTANT ?NLE
?NLE     CONSTANT ?G

\ AAA – ASCII Adjust after Addition
\ AAD – ASCII Adjust AX before Division
\ AAM – ASCII Adjust AX after Multiply
\ AAS – ASCII Adjust AL after Subtraction
\ ADC – ADD with Carry
\ ADD – Add
\ AND – Logical AND
\ ARPL – Adjust RPL Field of Selector
\ BOUND – Check Array Against Bounds
\ BSF – Bit Scan Forward
\ BSR – Bit Scan Reverse
\ BSWAP – Byte Swap
\ BT – Bit Test
\ BTC – Bit Test and Complement
\ BTR – Bit Test and Reset
\ BTS – Bit Test and Set
\ CALL – Call Procedure (in same segment)
\ CALL – Call Procedure (in other segment)
\ CBW – Convert Byte to Word
\ CDQ – Convert Doubleword to Qword
\ CLC – Clear Carry Flag
\ CLD – Clear Direction Flag
\ CLI – Clear Interrupt Flag
\ CLTS – Clear Task-Switched Flag in CR0
\ CMC – Complement Carry Flag
\ CMP – Compare Two Operands
\ CMPS/CMPSB/CMPSW/CMPSD – Compare String Operands
\ CMPXCHG – Compare and Exchange
\ CPUID – CPU Identification
\ CWD – Convert Word to Doubleword
\ CWDE – Convert Word to Doubleword
\ DAA – Decimal Adjust AL after Addition
\ DAS – Decimal Adjust AL after Subtraction
\ DEC – Decrement by 1
\ DIV – Unsigned Divide
\ HLT – Halt
\ IDIV – Signed Divide
\ IMUL – Signed Multiply
\ IN – Input From Port
\ INC – Increment by 1
\ INS – Input from DX Port
\ INT n – Interrupt Type n
\ INT – Single-Step Interrupt 3
\ INTO – Interrupt 4 on Overflow
\ INVD – Invalidate Cache
\ INVLPG – Invalidate TLB Entry
\ INVPCID – Invalidate Process-Context Identifier
\ IRET/IRETD – Interrupt Return
\ Jcc – Jump if Condition is Met
\ JCXZ/JECXZ – Jump on CX/ECX Zero
\ JMP – Unconditional Jump (to same segment)
\ JMP – Unconditional Jump (to other segment)
\ LAHF – Load Flags into AHRegister
\ LAR – Load Access Rights Byte
\ LDS – Load Pointer to DS
\ LEA – Load Effective Address
\ LEAVE – High Level Procedure Exit
\ LES – Load Pointer to ES
\ LFS – Load Pointer to FS
\ LGDT – Load Global Descriptor Table Register
\ LGS – Load Pointer to GS
\ LIDT – Load Interrupt Descriptor Table Register
\ LLDT – Load Local Descriptor Table Register
\ LMSW – Load Machine Status Word
\ LOCK – Assert LOCK# Signal Prefix
\ LODS/LODSB/LODSW/LODSD – Load String Operand
\ LOOP – Loop Count
\ LOOPZ/LOOPE – Loop Count while Zero/Equal
\ LOOPNZ/LOOPNE – Loop Count while not Zero/Equal
\ LSL – Load Segment Limit
\ LSS – Load Pointer to SS
\ LTR – Load Task Register
\ MOV – Move Data
\ MOV – Move to/from Control Registers
\ MOV – Move to/from Debug Registers
\ MOV – Move to/from Segment Registers
\ MOVBE – Move data after swapping bytes
\ MOVS/MOVSB/MOVSW/MOVSD – Move Data from String to String
\ MOVSX – Move with Sign-Extend
\ MOVZX – Move with Zero-Extend
\ MUL – Unsigned Multiply
\ NEG – Two's Complement Negation
\ NOP – No Operation
\ NOP – Multi-byte No Operation 1
\ NOT – One's Complement Negation
\ OR – Logical Inclusive OR
\ OUT – Output to Port
\ OUTS – Output to DX Port
\ POP – Pop a Word from the Stack
\ POP – Pop a Segment Register from the Stack (Note: CS cannot be sreg2 in this usage.)
\ POPA/POPAD – Pop All General Registers
\ POPF/POPFD – Pop Stack into FLAGS or EFLAGS Register
\ PUSH – Push Operand onto the Stack
\ PUSH – Push Segment Register onto the Stack
\ PUSHA/PUSHAD – Push All General Registers
\ PUSHF/PUSHFD – Push Flags Register onto the Stack
\ RCL – Rotate thru Carry Left
\ RCR – Rotate thru Carry Right
\ RDMSR – Read from Model-Specific Register
\ RDPMC – Read Performance Monitoring Counters
\ RDTSC – Read Time-Stamp Counter
\ RDTSCP – Read Time-Stamp Counter and Processor ID
\ REP INS – Input String
\ REP LODS – Load String
\ REP MOVS – Move String
\ REP OUTS – Output String
\ REP STOS – Store String
\ REPE CMPS – Compare String
\ REPE SCAS – Scan String
\ REPNE CMPS – Compare String
\ REPNE SCAS – Scan String
\ RET – Return from Procedure (to same segment)
\ RET – Return from Procedure (to other segment)
\ ROL – Rotate Left
\ ROR – Rotate Right
\ RSM – Resume from System Management Mode
\ SAHF – Store AH into Flags
\ SAL – Shift Arithmetic Left same instruction as SHL
\ SAR – Shift Arithmetic Right
\ SBB – Integer Subtraction with Borrow
\ SCAS/SCASB/SCASW/SCASD – Scan String
\ SETcc – Byte Set on Condition
\ SGDT – Store Global Descriptor Table Register
\ SHL – Shift Left
\ SHLD – Double Precision Shift Left
\ SHR – Shift Right
\ SHRD – Double Precision Shift Right
\ SIDT – Store Interrupt Descriptor Table Register
\ SLDT – Store Local Descriptor Table Register
\ SMSW – Store Machine Status Word
\ STC – Set Carry Flag
\ STD – Set Direction Flag
\ STI – Set Interrupt Flag
\ STOS/STOSB/STOSW/STOSD – Store String Data
\ STR – Store Task Register
\ SUB – Integer Subtraction
\ TEST – Logical Compare
\ UD0 – Undefined instruction
\ UD1 – Undefined instruction
\ UD2 – Undefined instruction
\ VERR – Verify a Segment for Reading
\ VERW – Verify a Segment for Writing
\ WAIT – Wait
\ WBINVD – Writeback and Invalidate Data Cache
\ WRMSR – Write to Model-Specific Register
\ XADD – Exchange and Add
\ XCHG – Exchange Register/Memory with Register
\ XLAT/XLATB – Table Look-up Translation
\ XOR – Logical Exclusive OR
\ Prefix Bytes
\ address size 0110 0111
\ LOCK 1111 0000
\ operand size 0110 0110
\ CS segment override 0010 1110
\ DS segment override 0011 1110
\ ES segment override 0010 0110
\ FS segment override 0110 0100
\ GS segment override 0110 0101
\ SS segment override 0011 0110

ONLY FORTH DEFINITIONS ALSO FAASM8632-PRIVATE

\ public definitions go here
\ private definitions are available for use

ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !
