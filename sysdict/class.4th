PURPOSE: CLASS definitions
LICENSE: Unlicense since 1999 by Illya Kysil

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

BASE @

\ CLASS members wordlists
\ member-id CONSTANT member-name

WORDLIST CONSTANT CLASS-METHODS
WORDLIST CONSTANT CLASS-FIELDS

HEX

000000FF CONSTANT MF-TYPE
00000001 CONSTANT MF-METHOD
00000002 CONSTANT MF-FIELD
00000100 CONSTANT MF-NAME

DECIMAL

\ CLASS members chain
\ value -> +0     member-id
\          +1     member CFA <-> virtual methods/fields
\          +2     member flags

\ CLASS structure
\ offset (cells)  field
\ -1              pointer to CLASS ( = HERE CELL+ )
\  0              members chain
\ +1              size ( in bytes )
\ +2              pointer to parent CLASS

\ instance structure
\ offset (cells)  field
\ -1              pointer to CLASS
\  0              instance data

S" Member not found"
   EXCEPTION CONSTANT EXC-MEMBER-UNDEFINED

S" Class can't be its own superclass"
   EXCEPTION CONSTANT EXC-INVALID-INHERITANCE

S" Class declaration needed"
   EXCEPTION CONSTANT EXC-NO-CLASS

: >CLASS (S instance | class -- class-addr )
   CELL-
;

: CLASSOF (S instance | class -- class )
   >CLASS @
;

: >THIS (S instance | class -- instance | class  class )
   DUP CLASSOF
;

: >SUPER (S class -- super-class-addr )
   2 CELLS+
;

: SUPER (S instance | class -- super-class )
   CLASSOF >SUPER @
;

: >SIZE (S instance | class -- size-addr )
   CELL+
;

: CLASS-SIZEOF (S instance | class -- size )
   CLASSOF >SIZE @
;

: >MEMBERS (S class | instance -- class-members-chain )
   CLASSOF @
;

: ISCLASS (S instance class -- flag )
   =
;

USER THIS^ 1 CELLS USER-ALLOC

: THIS@ THIS^ @ ;

DEFER THIS ' THIS@ IS THIS

: THIS! THIS^ ! ;

: THIS>R R> THIS >R >R ;

: R>THIS R> R> THIS! >R ;

0 VALUE CURRENT-CLASS

: ?CLASS
   CURRENT-CLASS 0= IF   EXC-NO-CLASS THROW   THEN
;

: DOES>-CLASS DOES> CELL+ ;

: CREATE-CLASS (S parent-class size "name" -- )
   0 CHAIN-NONAME
   CREATE
   HERE CELL+ DUP TO CURRENT-CLASS
   , \ -4 class ref
   , \ +0 members chain
   , \ +4 size ( of parent )
   , \ +8 parent
;

: (CLASS) (S parent size "name" -- )
   CREATE-CLASS DOES>-CLASS
;

: ;CLASS (S -- )
   0 TO CURRENT-CLASS
;

: <SUPER (S class -- )
   CURRENT-CLASS
   2DUP = IF  EXC-INVALID-INHERITANCE THROW  THEN
   2DUP >SUPER ! >SIZE SWAP CLASS-SIZEOF SWAP !
;

: CLASS-ADDMEMBER (S members-flags member-CFA member-id class -- )
   >R HERE >R , , , R> R> >MEMBERS CHAIN.ADD
;

: (METHOD-ENTER) (S instance class -- )
   R> THIS>R >R THIS!
;

: (METHOD-EXIT)
   R> R>THIS >R
;

: GET/CREATE-MEMBER-ID (S SLITERAL"name" members-wordlist -- member-id )
   2 PICK 2 PICK 2 PICK \ duplicate member info
   SEARCH-WORDLIST 0=
   IF
      \ create new member
      GET-CURRENT >R
      SET-CURRENT
      (DO-CREATE) -ROT &USUAL CHECK-HEADER,
      R> SET-CURRENT
   ELSE
      >R DROP DROP DROP R>
   THEN
;

: GET/CREATE-METHOD-ID (S SLITERAL"name" -- method-id )
   CLASS-METHODS GET/CREATE-MEMBER-ID
;

: GET/CREATE-FIELD-ID  (S SLITERAL"name" -- field-id )
   CLASS-FIELDS  GET/CREATE-MEMBER-ID
;

: CREATE-FIELD  (S size -- field-CFA )
   (DO-CREATE) 0 0 &USUAL HEADER, >R
   CURRENT-CLASS >SIZE DUP @ , +! R>
   DOES> @ +
;

: FIELD (S size "name" -- )
   ?CLASS CREATE-FIELD
   MF-FIELD MF-NAME OR SWAP
   PARSE-NAME GET/CREATE-FIELD-ID CURRENT-CLASS CLASS-ADDMEMBER
;

: M-ID: (S method-id -- flags method-id xt )
   ?CLASS MF-METHOD SWAP :NONAME
;

: M: (S "name" -- flags method-id xt )
   ?CLASS MF-METHOD MF-NAME OR PARSE-NAME GET/CREATE-METHOD-ID :NONAME
;

: ;M (S flags method-id xt -- )
   ?CLASS POSTPONE ; SWAP CURRENT-CLASS CLASS-ADDMEMBER
; IMMEDIATE/COMPILE-ONLY

: GET-MEMBER-ID (S SLITERAL"name" members-wordlist -- member-id )
   OVER 0= IF   EXC-EMPTY-NAME THROW   THEN
   SEARCH-WORDLIST 0= IF   EXC-MEMBER-UNDEFINED THROW   THEN
;

: GET-METHOD-ID (S SLITERAL"name" -- method-id )
   CLASS-METHODS GET-MEMBER-ID
;

: GET-FIELD-ID  (S SLITERAL"name" -- field-id )
   CLASS-FIELDS  GET-MEMBER-ID
;

USER MEMBER-XT 1 CELLS USER-ALLOC
USER MEMBER-ID 1 CELLS USER-ALLOC

: MEMBER-NOT-FOUND EXC-MEMBER-UNDEFINED THROW ;

(GET-EXC-ID) CONSTANT EXC-MEMBER-FOUND

: (ID>CFA) (S value -- exception if found | TRUE )
   DUP 0=
   IF
      DROP TRUE
   ELSE
      DUP @ MEMBER-ID @ =
      IF
         CELL+ @ MEMBER-XT !
         EXC-MEMBER-FOUND THROW
      ELSE
         DROP TRUE
      THEN
   THEN
;

: (CLASS-MEMBER-ID>CFA) (S class -- )
   >MEMBERS ['] (ID>CFA) CHAIN.FOR-EACH<
;

: ID>CFA (S member-id class -- CFA )
   ['] MEMBER-NOT-FOUND MEMBER-XT ! SWAP MEMBER-ID !
   BEGIN         \ S: class
      DUP
   WHILE
      DUP ['] (CLASS-MEMBER-ID>CFA) CATCH
      EXC-MEMBER-FOUND = IF   2DROP 0   ELSE   SUPER   THEN
   REPEAT
   DROP
   MEMBER-XT @
;

: DOES>-INSTANCE DOES> CELL+ ;

: DICT-INSTANCE (S class "name" -- )
   CREATE DUP , CLASS-SIZEOF ALLOT DOES>-INSTANCE
;

: CREATE-HEAP-INSTANCE (S class -- heap-instance )
   DUP CLASS-SIZEOF ALLOCATE THROW DUP -ROT ! CELL+
;

: FREE-HEAP-INSTANCE (S heap-instance -- )
   CELL- FREE THROW
;

: PARSE-GET-METHOD-ID (S "name" -- method-id )
   PARSE-NAME GET-METHOD-ID
;

: (DO-INVOKE) (S i*x instance class xt -- j*y )
   NIP SWAP (METHOD-ENTER) CATCH (METHOD-EXIT) THROW
;

: (ID>CFA-INVOKE) (S i*x instance class method-id -- j*y )
   OVER ID>CFA (DO-INVOKE)
;

: (INVOKE-ID) >R >THIS R> (ID>CFA-INVOKE) ;

:NONAME (S i*x instance method-id -- j*y )
   (INVOKE-ID)
;
:NONAME (S i*x instance method-id -- j*y )
   POSTPONE (INVOKE-ID)
;
INT/COMP: INVOKE-ID

:NONAME (S i*x instance "name" -- j*y )
   >THIS PARSE-GET-METHOD-ID (ID>CFA-INVOKE)
;
:NONAME (S "name" -- )
   POSTPONE >THIS PARSE-GET-METHOD-ID POSTPONE LITERAL POSTPONE (ID>CFA-INVOKE)
;
INT/COMP: INVOKE

: SUPER-INVOKE (S instance "name" -- )
   ?CLASS CURRENT-CLASS SUPER POSTPONE LITERAL PARSE-GET-METHOD-ID
   POSTPONE LITERAL POSTPONE (ID>CFA-INVOKE)
; IMMEDIATE/COMPILE-ONLY

: PARSE-GET-FIELD-ID (S "name" -- field-id )
   PARSE-NAME GET-FIELD-ID
;

: (ID>CFA-FIELD-ADDR) (S i*x instance class field-id -- j*y )
   SWAP ID>CFA EXECUTE
;

:NONAME (S i*x instance "name" -- j*y )
   >THIS PARSE-GET-FIELD-ID (ID>CFA-FIELD-ADDR)
;
:NONAME (S "name" -- )
   POSTPONE >THIS PARSE-GET-FIELD-ID POSTPONE LITERAL POSTPONE (ID>CFA-FIELD-ADDR)
;
INT/COMP: FIELD-ADDR

0 0 (CLASS) OBJECT

   M: CREATE ;M

   M: DESTROY ;M

   M: .NAME THIS CELL- BODY> >HEAD H>#NAME TYPE ;M

   M: .INFO THIS INVOKE .NAME SPACE THIS CLASSOF INVOKE .NAME SPACE THIS H.8 ;M

   M: .CLASSINFO THIS INVOKE .NAME ." , SIZEOF=" THIS CLASS-SIZEOF . ;M

   : (.T) (S class level -- level )
      OVER SUPER ?DUP IF   SWAP RECURSE   THEN
      DUP ?DUP IF   1- 2* SPACES ." \-"   THEN 1+
      SWAP INVOKE .CLASSINFO CR
   ;

   M: .TREE
      THIS CLASSOF 0 (.T) DROP
   ;M

\   M: SEE
\      PARSE-NAME GET-METHOD-ID THIS CLASSOF ID>CFA (SEE)
\   ;M

   : .MEMBER-TYPE (S member-flags -- )
      MF-TYPE AND
      CASE
         MF-FIELD  OF ." FIELD  " ENDOF
         MF-METHOD OF ." METHOD " ENDOF
      ENDCASE
   ;

   : (.MEMBERS)
      ?DUP
      IF
         DUP
         [ 2 CELLS ] LITERAL + @ DUP
         CR .MEMBER-TYPE
         OVER       @ ." ID=H# " H.8 1 SPACES
         OVER CELL+ @ ." XT=H# " H.8 2 SPACES
         MF-NAME AND
         IF
            @ >HEAD H>#NAME TYPE
         ELSE
            DROP ." (noname)"
         THEN
      THEN TRUE
   ;

   M: .MEMBERS
      THIS INVOKE .CLASSINFO
      THIS >MEMBERS ['] (.MEMBERS) CHAIN.FOR-EACH>
   ;M

;CLASS

: CLASS: (S "name" -- )
   OBJECT DUP CLASS-SIZEOF (CLASS)
;

BASE !

REPORT-NEW-NAME !
