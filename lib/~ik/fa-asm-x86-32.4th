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

: ALU/RR, (S reg1 reg2 alu-opcode -- )
   \G Append ALU operation between two registers to the current definition.
   ASM8,
   SWAP 3 LSHIFT OR
   B# 11000000 OR
   ASM8,
;

: ALU/RR8: (S alu-opcode -- )
   \G Create a word which compiles ALU operation between two 8 bit registers
   \G when executed with following stack effect:
   \G (S reg1 reg2 -- )
   CREATE
      [ ALU-W-BIT INVERT ] LITERAL AND C,
   DOES>
      C@ ALU/RR,
;

: ALU/RR16: (S alu-opcode -- )
   \G Create a word which compiles ALU operation between two 16 bit registers
   \G when executed with following stack effect:
   \G (S reg1 reg2 -- )
   CREATE
      ALU-W-BIT OR C,
   DOES>
      ?OP16, C@ ALU/RR,
;

: ALU/RR32: (S alu-opcode -- )
   \G Create a word which compiles ALU operation between two 32 bit registers
   \G when executed with following stack effect:
   \G (S reg1 reg2 -- )
   CREATE
      ALU-W-BIT OR C,
   DOES>
      ?OP32, C@ ALU/RR,
;

: ALUOP-> (S alu-opcode -- alu-opcode' )
   \G Modify direction of alu-opcode to left-to-right.
   [ ALU-D-BIT INVERT ] LITERAL AND
;

: ALUOP<- (S alu-opcode -- alu-opcode' )
   \G Modify direction of alu-opcode to right-to-left.
   ALU-D-BIT OR
;


: ALU/AI8: (S alu-opcode -- )
   \G Create a word which compiles ALU operation between AL and imm8 value
   \G when executed with following stack effect:
   \G (S imm8 -- )
   CREATE
      [ ALU-W-BIT INVERT ] LITERAL AND C,
   DOES>
      C@ ASM8, ASM8,
;

: ALU/AI16: (S alu-opcode -- )
   \G Create a word which compiles ALU operation between AX and imm16 value
   \G when executed with following stack effect:
   \G (S imm16 -- )
   CREATE
      ALU-W-BIT OR C,
   DOES>
      ?OP16, C@ ASM8, ASM16,
;

: ALU/AI32: (S alu-opcode -- )
   \G Create a word which compiles ALU operation between EAX and imm32 value
   \G when executed with following stack effect:
   \G (S imm32 -- )
   CREATE
      ALU-W-BIT OR C,
   DOES>
      ?OP32, C@ ASM8, ASM32,
;


: SHIFT/R, (S r opcode1 opcode2 -- )
   \G Compile shift by 1 operation.
   \G opcode1 - first byte of operation encoding
   \G opcode2 - second byte of operation encoding
   SWAP ASM8,
   B# 11000000 OR OR
   ASM8,
;

: SHIFT/R8: (S opcode1 opcode2 -- )
   \G Create a word which compiles shift operation on 8 bit register
   \G when executed with following stack effect:
   \G (S r8 -- )
   \G opcode1 - first byte of operation encoding
   \G opcode2 - second byte of operation encoding
   CREATE
      SWAP [ ALU-W-BIT INVERT ] LITERAL AND C, C,
   DOES>
      C@+ SWAP C@ SHIFT/R,
;

: SHIFT/R16: (S opcode1 opcode2 -- )
   \G Create a word which compiles shift operation on 16 bit register
   \G when executed with following stack effect:
   \G (S r16 -- )
   \G opcode1 - first byte of operation encoding
   \G opcode2 - second byte of operation encoding
   CREATE
      SWAP ALU-W-BIT OR C, C,
   DOES>
      ?OP16, C@+ SWAP C@ SHIFT/R,
;

: SHIFT/R32: (S opcode1 opcode2 -- )
   \G Create a word which compiles shift operation on 32 bit register
   \G when executed with following stack effect:
   \G (S r32 -- )
   \G opcode1 - first byte of operation encoding
   \G opcode2 - second byte of operation encoding
   CREATE
      SWAP ALU-W-BIT OR C, C,
   DOES>
      ?OP32, C@+ SWAP C@ SHIFT/R,
;

: SHIFT/R8I8: (S opcode1 opcode2 -- )
   \G Create a word which compiles shift operation on 8 bit register
   \G when executed with following stack effect:
   \G (S r8 imm8 -- )
   \G opcode1 - first byte of operation encoding
   \G opcode2 - second byte of operation encoding
   CREATE
      SWAP [ ALU-W-BIT INVERT ] LITERAL AND C, C,
   DOES> (S r8 imm8 addr -- )
      SWAP >R
      C@+ SWAP C@ SHIFT/R,
      R> ASM8,
;

: SHIFT/R16I8: (S opcode1 opcode2 -- )
   \G Create a word which compiles shift operation on 16 bit register
   \G when executed with following stack effect:
   \G (S r16 imm8 -- )
   \G opcode1 - first byte of operation encoding
   \G opcode2 - second byte of operation encoding
   CREATE
      SWAP ALU-W-BIT OR C, C,
   DOES> (S r16 imm8 addr -- )
      SWAP >R
      ?OP16, C@+ SWAP C@ SHIFT/R,
      R> ASM8,
;

: SHIFT/R32I8: (S opcode1 opcode2 -- )
   \G Create a word which compiles shift operation on 32 bit register
   \G when executed with following stack effect:
   \G (S r32 imm8 -- )
   \G opcode1 - first byte of operation encoding
   \G opcode2 - second byte of operation encoding
   CREATE
      SWAP ALU-W-BIT OR C, C,
   DOES> (S r32 imm8 addr -- )
      SWAP >R
      ?OP32, C@+ SWAP C@ SHIFT/R,
      R> ASM8,
;

B# 11010000 CONSTANT ALUOP-SHIFT
\G First byte of shift operations with CL or implicit 1.
B# 11000000 CONSTANT ALUOP-SHIFT-IMM
\G First byte of shift operations with immediate value.
B# 00000010 CONSTANT SHIFT-CL-BIT

: SHIFT/CL (S opcode -- opcode' )
   \G Modify shift operation code from shift by 1 to shift by CL.
   SHIFT-CL-BIT OR
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


INCLUDE" lib/~ik/fa-asm-x86-32/op-bsf.4th"
INCLUDE" lib/~ik/fa-asm-x86-32/op-bsr.4th"
INCLUDE" lib/~ik/fa-asm-x86-32/op-bswap.4th"
INCLUDE" lib/~ik/fa-asm-x86-32/op-bt.4th"
INCLUDE" lib/~ik/fa-asm-x86-32/op-btc.4th"
INCLUDE" lib/~ik/fa-asm-x86-32/op-btr.4th"
INCLUDE" lib/~ik/fa-asm-x86-32/op-bts.4th"


\ CALL – Call Procedure (in same segment)

: CALL/R@, (S reg -- )
   \G Compile register indirect CALL (without operand size prefix).
   B# 11111111 ASM8,
   B# 11010000 OR ASM8,
;

: CALL/R16@, (S reg -- )
   \G Compile 16 bits register indirect CALL.
   ?OP16,
   CALL/R@,
;

: CALL/R32@, (S reg -- )
   \G Compile 32 bits register indirect CALL.
   ?OP32,
   CALL/R@,
;


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

INCLUDE" lib/~ik/fa-asm-x86-32/op-cmpxchg.4th"

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

INCLUDE" lib/~ik/fa-asm-x86-32/op-dec.4th"
INCLUDE" lib/~ik/fa-asm-x86-32/op-div.4th"

\ HLT – Halt
B# 11110100
   I1B:  HLT,

INCLUDE" lib/~ik/fa-asm-x86-32/op-idiv.4th"
INCLUDE" lib/~ik/fa-asm-x86-32/op-imul.4th"

\ IN – Input From Port

INCLUDE" lib/~ik/fa-asm-x86-32/op-inc.4th"

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

: JMP/R@, (S reg -- )
   \G Compile register indirect JMP (without operand size prefix).
   B# 11111111 ASM8,
   B# 11100000 OR ASM8,
;

: JMP/R16@, (S reg -- )
   \G Compile 16 bits register indirect JMP.
   ?OP16,
   JMP/R@,
;

: JMP/R32@, (S reg -- )
   \G Compile 32 bits register indirect JMP.
   ?OP32,
   JMP/R@,
;


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

INCLUDE" lib/~ik/fa-asm-x86-32/op-movzx.4th"
INCLUDE" lib/~ik/fa-asm-x86-32/op-mul.4th"
INCLUDE" lib/~ik/fa-asm-x86-32/op-neg.4th"
INCLUDE" lib/~ik/fa-asm-x86-32/op-nop.4th"
INCLUDE" lib/~ik/fa-asm-x86-32/op-not.4th"
INCLUDE" lib/~ik/fa-asm-x86-32/op-or.4th"

\ OUT – Output to Port
\ OUTS – Output to DX Port

INCLUDE" lib/~ik/fa-asm-x86-32/op-pop.4th"

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


INCLUDE" lib/~ik/fa-asm-x86-32/op-push.4th"

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

INCLUDE" lib/~ik/fa-asm-x86-32/op-rcl.4th"
INCLUDE" lib/~ik/fa-asm-x86-32/op-rcr.4th"

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

INCLUDE" lib/~ik/fa-asm-x86-32/op-rol.4th"
INCLUDE" lib/~ik/fa-asm-x86-32/op-ror.4th"

\ RSM – Resume from System Management Mode
\ SAHF – Store AH into Flags
B# 10011110
   I1B:  SAHF,

INCLUDE" lib/~ik/fa-asm-x86-32/op-sal.4th"
INCLUDE" lib/~ik/fa-asm-x86-32/op-sar.4th"
INCLUDE" lib/~ik/fa-asm-x86-32/op-sbb.4th"

\ SCAS/SCASB/SCASW/SCASD – Scan String

INCLUDE" lib/~ik/fa-asm-x86-32/op-set-cond.4th"

\ SGDT – Store Global Descriptor Table Register

INCLUDE" lib/~ik/fa-asm-x86-32/op-shl.4th"

\ SHLD – Double Precision Shift Left

INCLUDE" lib/~ik/fa-asm-x86-32/op-shr.4th"

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
