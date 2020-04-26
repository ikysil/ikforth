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
\ Guidelines:
\ * all words ending with COMMA (,) compile to the dictionary

REPORT-NEW-NAME @
REPORT-NEW-NAME ON

ONLY FORTH DEFINITIONS

VOCABULARY FAASM8632-PRIVATE

ALSO FAASM8632-PRIVATE DEFINITIONS

\ private definitions go here

\G Compile a 8-bits value (S x -- )
DEFER ASM8,

' C, IS ASM8,

\G Compile a 16-bits value - always LSB first (S x -- )
\G Uses ASM8, for actual compilation.
: ASM16,
   DUP
   H# FF AND ASM8, 8 RSHIFT
   H# FF AND ASM8,
;

\G Compile a 32-bits value - always LSB first (S x -- )
\G Uses ASM8, for actual compilation.
: ASM32,
   DUP
   H# FF AND ASM8, 8 RSHIFT DUP
   H# FF AND ASM8, 8 RSHIFT DUP
   H# FF AND ASM8, 8 RSHIFT
   H# FF AND ASM8,
;

\G Assembly mode - 32-bits address and operands by default.
\G TRUE for 32-bits address and operands
\G FALSE for 16-bits address and operands
TRUE VALUE MODE32

: USE32
   TRUE TO MODE32
;

: USE16
   FALSE TO MODE32
;

: ?OPSIZE, (S flag -- )
   \G Conditionaly compile operands size prefix
   IF   H# 66 ASM8,   THEN
;

: ?OP16, (S -- )
   \G Conditionaly compile prefix for 16-bits operands in 32-bits mode
   MODE32 ?OPSIZE,
;

: ?OP32,
   \G Conditionaly compile prefix for 32-bits operands in 16-bits mode
   MODE32 INVERT ?OPSIZE,
;

: ?ADDRSIZE, (S flag -- )
   \G Conditionaly compile address size prefix
   IF   H# 67 ASM8,   THEN
;

: ?ADDR16, (S -- )
   \G Conditionaly compile prefix for 16-bits addresses in 32-bits mode
   MODE32 ?ADDRSIZE,
;

: ?ADDR32,
   \G Conditionaly compile prefix for 32-bits addresses in 16-bits mode
   MODE32 INVERT ?ADDRSIZE,
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


\ Registers - 8 bits

B# 000   CONSTANT AL
B# 001   CONSTANT CL
B# 010   CONSTANT DL
B# 011   CONSTANT BL
B# 100   CONSTANT AH
B# 101   CONSTANT CH
B# 110   CONSTANT DH
B# 111   CONSTANT BH

\ Registers - 16 bits

B# 000   CONSTANT AX
B# 001   CONSTANT CX
B# 010   CONSTANT DX
B# 011   CONSTANT BX
B# 100   CONSTANT SP
B# 101   CONSTANT BP
B# 110   CONSTANT SI
B# 111   CONSTANT DI

\ Registers - 32 bits

B# 000   CONSTANT EAX
B# 001   CONSTANT ECX
B# 010   CONSTANT EDX
B# 011   CONSTANT EBX
B# 100   CONSTANT ESP
B# 101   CONSTANT EBP
B# 110   CONSTANT ESI
B# 111   CONSTANT EDI

\ Segment Registers

B# 000   CONSTANT ES
B# 001   CONSTANT CS
B# 010   CONSTANT SS
B# 011   CONSTANT DS
B# 100   CONSTANT FS
B# 101   CONSTANT GS
\ B# 110   RESERVED
\ B# 111   RESERVED

\ Defining words for instruction classes

: I1B: (S op-code "name" -- )
   \G Create a word which compiles one byte op-code into the definition at runtime.
   CREATE C,
   DOES> C@ ASM8,
;

: I1B-OP16: (S op-code "name" -- )
   \G Create a word which compiles one byte op-code with 16-bits operands into the definition at runtime.
   CREATE C,
   DOES> ?OP16, C@ ASM8,
;

: I1B-OP32: (S op-code "name" -- )
   \G Create a word which compiles one byte op-code with 32-bits operands into the definition at runtime.
   CREATE C,
   DOES> ?OP32, C@ ASM8,
;

: I2B: (S l-op-code m-op-code "name" -- )
   \G Create a word which compiles two bytes byte op-code into the definition at runtime.
   \G l-op-code is compiled first, m-op-code second.
   CREATE C, C,
   DOES> C@+ ASM8, C@ ASM8,
;


B# 00000001 CONSTANT ALU-W-BIT
B# 00000010 CONSTANT ALU-D-BIT
B# 00000010 CONSTANT ALU-S-BIT

: ALURR, (S reg1 reg2 alu-opcode -- )
   \G Append ALU operation between two registers to the current definition.
   ASM8,
   SWAP 3 LSHIFT OR
   B# 11000000 OR
   ASM8,
;

: ALURR8: (S alu-opcode -- )
   \G Create a word which compiles ALU operation between two 8 bit registers
   \G when executed with following stack effect:
   \G (S reg1 reg2 -- )
   CREATE
      [ ALU-W-BIT INVERT ] LITERAL AND C,
   DOES>
      C@ ALURR,
;

: ALURR16: (S alu-opcode -- )
   \G Create a word which compiles ALU operation between two 16 bit registers
   \G when executed with following stack effect:
   \G (S reg1 reg2 -- )
   CREATE
      ALU-W-BIT OR C,
   DOES>
      ?OP16, C@ ALURR,
;

: ALURR32: (S alu-opcode -- )
   \G Create a word which compiles ALU operation between two 32 bit registers
   \G when executed with following stack effect:
   \G (S reg1 reg2 -- )
   CREATE
      ALU-W-BIT OR C,
   DOES>
      ?OP32, C@ ALURR,
;

: ALUOP-> (S alu-opcode -- alu-opcode' )
   \G Modify direction of alu-opcode to left-to-right.
   [ ALU-D-BIT INVERT ] LITERAL AND
;

: ALUOP<- (S alu-opcode -- alu-opcode' )
   \G Modify direction of alu-opcode to right-to-left.
   ALU-D-BIT OR
;


\ AAA – ASCII Adjust after Addition
B# 00110111
   I1B:  AAA,

\ AAD – ASCII Adjust AX before Division
B# 11010101
B# 00001010
   I2B:  AAD,

\ AAM – ASCII Adjust AX after Multiply
B# 11010100
B# 00001010
   I2B:  AAM,

\ AAS – ASCII Adjust AL after Subtraction
B# 00111111
   I1B:  AAS,

INCLUDE" lib/~ik/fa-asm-x86-32/op-adc.4th"
INCLUDE" lib/~ik/fa-asm-x86-32/op-add.4th"
INCLUDE" lib/~ik/fa-asm-x86-32/op-and.4th"

\ ARPL – Adjust RPL Field of Selector
\ BOUND – Check Array Against Bounds
\ BSF – Bit Scan Forward
\ BSR – Bit Scan Reverse


\ BSWAP – Byte Swap

: BSWAPR, (S reg -- )
   B# 00001111 ASM8,
   B# 11001000 OR ASM8,
;

: BSWAPR16, (S reg -- )
   ?OP16,
   BSWAPR,
;

: BSWAPR32, (S reg -- )
   ?OP32,
   BSWAPR,
;


\ BT – Bit Test
\ BTC – Bit Test and Complement
\ BTR – Bit Test and Reset
\ BTS – Bit Test and Set
\ CALL – Call Procedure (in same segment)
\ CALL – Call Procedure (in other segment)
\ CBW – Convert Byte to Word
B# 10011000
   I1B:  CBW,

\ CDQ – Convert Doubleword to Qword
B# 10011001
   I1B:  CDQ,

\ CLC – Clear Carry Flag
B# 11111000
   I1B:  CLC,

\ CLD – Clear Direction Flag
B# 11111100
   I1B:  CLD,

\ CLI – Clear Interrupt Flag
\ CLTS – Clear Task-Switched Flag in CR0
\ CMC – Complement Carry Flag
B# 11110101
   I1B:  CMC,

INCLUDE" lib/~ik/fa-asm-x86-32/op-cmp.4th"

\ CMPS/CMPSB/CMPSW/CMPSD – Compare String Operands
\ CMPXCHG – Compare and Exchange
\ CPUID – CPU Identification
\ CWD – Convert Word to Doubleword
B# 10011001
   I1B:  CWD,

\ CWDE – Convert Word to Doubleword
B# 10011000
   I1B:  CWDE,

\ DAA – Decimal Adjust AL after Addition
B# 00100111
   I1B:  DAA,

\ DAS – Decimal Adjust AL after Subtraction
B# 00101111
   I1B:  DAS,

\ DEC – Decrement by 1
\ DIV – Unsigned Divide
\ HLT – Halt
B# 11110100
   I1B:  HLT,

\ IDIV – Signed Divide
\ IMUL – Signed Multiply
\ IN – Input From Port
\ INC – Increment by 1
\ INS – Input from DX Port
\ INT n – Interrupt Type n
\ INT – Single-Step Interrupt 3
B# 11001100
   I1B:  INT,

\ INTO – Interrupt 4 on Overflow
B# 11001110
   I1B:  INTO,

\ INVD – Invalidate Cache
\ INVLPG – Invalidate TLB Entry
\ INVPCID – Invalidate Process-Context Identifier
\ IRET/IRETD – Interrupt Return
B# 11001111
   I1B-OP16:   IRET,

B# 11001111
   I1B-OP32:   IRETD,

\ Jcc – Jump if Condition is Met
\ JCXZ/JECXZ – Jump on CX/ECX Zero
\ JMP – Unconditional Jump (to same segment)
\ JMP – Unconditional Jump (to other segment)
\ LAHF – Load Flags into AHRegister
B# 10011111
   I1B:  LAHF,

\ LAR – Load Access Rights Byte
\ LDS – Load Pointer to DS
\ LEA – Load Effective Address
\ LEAVE – High Level Procedure Exit
B# 11001001
   I1B:  LEAVE,

\ LES – Load Pointer to ES
\ LFS – Load Pointer to FS
\ LGDT – Load Global Descriptor Table Register
\ LGS – Load Pointer to GS
\ LIDT – Load Interrupt Descriptor Table Register
\ LLDT – Load Local Descriptor Table Register
\ LMSW – Load Machine Status Word
\ LOCK – Assert LOCK# Signal Prefix
B# 11110000
   I1B:  LOCK,

\ LODS/LODSB/LODSW/LODSD – Load String Operand
\ LOOP – Loop Count
\ LOOPZ/LOOPE – Loop Count while Zero/Equal
\ LOOPNZ/LOOPNE – Loop Count while not Zero/Equal
\ LSL – Load Segment Limit
\ LSS – Load Pointer to SS
\ LTR – Load Task Register

INCLUDE" lib/~ik/fa-asm-x86-32/op-mov-data.4th"

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
B# 10010000
   I1B:  NOP,

\ NOP – Multi-byte No Operation 1
\ NOT – One's Complement Negation

INCLUDE" lib/~ik/fa-asm-x86-32/op-or.4th"

\ OUT – Output to Port
\ OUTS – Output to DX Port
\ POP – Pop a Word from the Stack
\ POP – Pop a Segment Register from the Stack (Note: CS cannot be sreg2 in this usage.)
\ POPA/POPAD – Pop All General Registers
B# 01100001
   I1B-OP16:   POPA,

B# 01100001
   I1B-OP32:   POPAD,

\ POPF/POPFD – Pop Stack into FLAGS or EFLAGS Register
B# 10011101
   I1B-OP16:   POPF,

B# 10011101
   I1B-OP32:   POPFD,

\ PUSH – Push Operand onto the Stack
\ PUSH – Push Segment Register onto the Stack
\ PUSHA/PUSHAD – Push All General Registers
B# 01100000
   I1B-OP16:   PUSHA,

B# 01100000
   I1B-OP32:   PUSHAD,

\ PUSHF/PUSHFD – Push Flags Register onto the Stack
B# 10011100
   I1B-OP16:   PUSHF,

B# 10011100
   I1B-OP32:   PUSHFD,

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
H# F3
   I1B:  REPE,

SYNONYM REP, REPE,
SYNONYM REPZ, REPE,

\ REPNE CMPS – Compare String
\ REPNE SCAS – Scan String
H# F2
   I1B:  REPNE,

SYNONYM REPNZ, REPNE,

\ RET – Return from Procedure (to same segment)
\ RET – Return from Procedure (to other segment)
\ ROL – Rotate Left
\ ROR – Rotate Right
\ RSM – Resume from System Management Mode
\ SAHF – Store AH into Flags
B# 10011110
   I1B:  SAHF,

\ SAL – Shift Arithmetic Left same instruction as SHL
\ SAR – Shift Arithmetic Right

INCLUDE" lib/~ik/fa-asm-x86-32/op-sbb.4th"

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
B# 11111001
   I1B:  STC,

\ STD – Set Direction Flag
B# 11111101
   I1B:  STD,

\ STI – Set Interrupt Flag
\ STOS/STOSB/STOSW/STOSD – Store String Data
\ STR – Store Task Register

INCLUDE" lib/~ik/fa-asm-x86-32/op-sub.4th"
INCLUDE" lib/~ik/fa-asm-x86-32/op-test.4th"

\ UD0 – Undefined instruction
B# 00001111
B# 11111111
   I2B:  UD0,

\ UD1 – Undefined instruction
B# 00001111
B# 00001011
   I2B:  UD1,

\ UD2 – Undefined instruction
\ VERR – Verify a Segment for Reading
\ VERW – Verify a Segment for Writing
\ WAIT – Wait
B# 10011011
   I1B:  WAIT,

\ WBINVD – Writeback and Invalidate Data Cache
\ WRMSR – Write to Model-Specific Register
\ XADD – Exchange and Add

INCLUDE" lib/~ik/fa-asm-x86-32/op-xchg.4th"

\ XLAT/XLATB – Table Look-up Translation
B# 11010111
   I1B:  XLAT,

SYNONYM XLATB, XLAT,

INCLUDE" lib/~ik/fa-asm-x86-32/op-xor.4th"

\ Prefix Bytes
\ address size 0110 0111
\ LOCK 1111 0000
\ operand size 0110 0110
\ CS segment override 0010 1110
H# 2E
   I1B:  CS:,

\ DS segment override 0011 1110
H# 3E
   I1B:  DS:,

\ ES segment override 0010 0110
H# 26
   I1B:  ES:,

\ FS segment override 0110 0100
H# 64
   I1B:  FS:,

\ GS segment override 0110 0101
H# 65
   I1B:  GS:,

\ SS segment override 0011 0110
H# 36
   I1B:  SS:,


ONLY FORTH DEFINITIONS ALSO FAASM8632-PRIVATE

\ public definitions go here
\ private definitions are available for use

ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !
