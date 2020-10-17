PURPOSE: STRING-SUBSTITUTE definitions
LICENSE: Unlicense since 1999 by Illya Kysil

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

ONLY FORTH DEFINITIONS

VOCABULARY STRING-SUBSTITUTE-PRIVATE

ALSO STRING-SUBSTITUTE-PRIVATE DEFINITIONS

\ private definitions go here

WORDLIST CONSTANT wid-subst
\ Wordlist ID of the wordlist used to hold substitution names and replacement text.

: makeSubst \ (S c-addr1 u1 c-addr2 u2 -- )
\ Given a name string (c-addr2 u2) create a substution returning c-addr1 u1.
   GET-CURRENT >R wid-subst SET-CURRENT
   2>R (DO-:) 2R> &USUAL
   HEADER, DROP
   POSTPONE SLITERAL
   POSTPONE (;)
   R> SET-CURRENT
;

: findSubst \ c-addr len -- xt flag | 0
\ Given a name string, find the substitution.
\ Return xt and flag if found, or just zero if not found.
   wid-subst SEARCH-WORDLIST
;

: "/COUNTED-STRING" S" /COUNTED-STRING" ;
"/COUNTED-STRING" ENVIRONMENT? 0= [IF] 256 [THEN]
CHARS CONSTANT string-max

CHAR % CONSTANT delim                  \ Character used as the substitution name delimiter.
string-max CHARS BUFFER: Name          \ Holds substitution name as a counted string.
string-max CHARS BUFFER: Src           \ Source string buffer for substitution to accommodate overlapping input buffers.
VARIABLE DestLen                       \ Maximum length of the destination buffer.
2VARIABLE Dest                         \ Holds destination string current length and address.
VARIABLE SubstErr                      \ Holds zero or an error code.

: addDest \ char --
\ Add the character to the destination string.
   Dest @ DestLen @ < IF
      Dest 2@ + C! 1 CHARS Dest +!
   ELSE
      DROP -1 SubstErr !
   THEN
;

[UNDEFINED] place [IF]
   : place    \ c-addr1 u c-addr2 --
   \ Copy the string described by c-addr1 u as a counted
   \ string at the memory address described by c-addr2.
      2DUP 2>R
      1 CHARS + SWAP MOVE
      2R> C!
   ;
[THEN]

: formName \ c-addr len -- c-addr' len' flag
\ Given a source string pointing at a leading delimiter, place the name string in the name buffer.
\ Flag is true if closing delimiter has been found.
   1 /STRING 2DUP delim SCAN >R DROP   \ find length of residue
   2DUP R@ - DUP >R Name place         \ save name in buffer
   R> 1 CHARS + /STRING                \ step over name and trailing %
   R> 0<>
;

[UNDEFINED] bounds [IF]
   : bounds    \ addr len -- addr+len addr
      OVER + SWAP
   ;
[THEN]

: >dest \ c-addr len --
\ Add a string to the output string.
   bounds ?DO
      I C@ addDest
   1 CHARS +LOOP
;

: processName \ delim-flag -- flag
\ Process the last substitution name. Return true if found, 0 if not found.
   IF
      \ closing delimeter has been found -> process substitution
      Name COUNT findSubst DUP >R IF
         EXECUTE >dest
      ELSE
         delim addDest Name COUNT >dest delim addDest
      THEN
      R>
   ELSE
      \ closing delimeter has NOT been found -> copy rest of the string
      delim addDest Name COUNT >dest
      FALSE
   THEN
;

ONLY FORTH DEFINITIONS ALSO STRING-SUBSTITUTE-PRIVATE

\ public definitions go here
\ private definitions are available for use

: REPLACES (S c-addr1 u1 c-addr2 u2 -- )
   (G 17.6.2.2141 REPLACES )
   (G Set the string c-addr1 u1 as the text to substitute for the substitution named by c-addr2 u2.)
   (G If the substitution does not exist it is created. )
   (G The program may then reuse the buffer c-addr1 u1 without affecting the definition of the substitution. )
   (G )
   (G Ambiguous conditions occur as follows: )
   (G )
   (G The substitution cannot be created;)
   (G The name of a substitution contains the `%' delimiter character.)
   (G REPLACES may allot data space and create a definition. This breaks the contiguity of the current region and is not allowed during compilation of a colon definition)
   makeSubst
;

: SUBSTITUTE (S c-addr1 u1 c-addr2 u2 -- c-addr2 u3 n )
   (G 17.6.2.2255 SUBSTITUTE )
   (G Perform substitution on the string c-addr1 u1 placing the result at string c-addr2 u3,
      where u3 is the length of the resulting string. An error occurs if the resulting string
      will not fit into c-addr2 u2 or if c-addr2 is the same as c-addr1.
      The return value n is positive or 0 on success and indicates the number of substitutions made.
      A negative value for n indicates that an error occurred, leaving c-addr2 u3 undefined.
      Negative values of n are implementation defined except for values in table 9.1 THROW code assignments.

      Substitution occurs left to right from the start of c-addr1 in one pass and is non-recursive.

      When text of a potential substitution name, surrounded by `%' [ASCII $25] delimiters is encountered by SUBSTITUTE,
      the following occurs:

      If the name is null, a single delimiter character is passed to the output, i.e., %% is replaced by %.
      The current number of substitutions is not changed.

      If the text is a valid substitution name acceptable to 17.6.2.2141 REPLACES,
      the leading and trailing delimiter characters and the enclosed substitution name are replaced by the substitution text.
      The current number of substitutions is incremented.

      If the text is not a valid substitution name, the name with leading and trailing delimiters is passed unchanged to the output.
      The current number of substitutions is not changed.

      Parsing of the input string resumes after the trailing delimiter.
      If after processing any pairs of delimiters, the residue of the input string contains a single delimiter,
      the residue is passed unchanged to the output.
   )
\ Expand the source string using substitutions.
\ Note that this version is simplistic, performs no error checking,
\ and requires a global buffer and global variables.
   Destlen ! 0 Dest 2! 0 -rot             \ -- 0 src slen
   0 SubstErr !
   Src SWAP 2DUP 2>R CMOVE 2R>            \ copy to Src buffer to accommodate overlapping input buffers
   BEGIN
      DUP 0 >
   WHILE
      OVER C@ delim <> IF                 \ character not %
         OVER C@ addDest 1 /STRING
      ELSE
         OVER 1 CHARS + C@ delim = IF     \ %% for one output %
            delim addDest 2 /STRING       \ add one % to output
         ELSE
            formName processName IF
               ROT 1+ -rot                \ count substitutions
            THEN
         THEN
      THEN
   REPEAT
   2DROP Dest 2@ ROT SubstErr @ IF
      DROP SubstErr @
   THEN
;

: UNESCAPE (S c-addr1 u1 c-addr2 -- c-addr2 u2 )
   (G 17.6.2.2375 UNESCAPE )
   (G Replace each `%' character in the input string c-addr1 u1 by two `%' characters.
      The output is represented by c-addr2 u2. The buffer at c-addr2 shall be big enough to hold the unescaped string.
      An ambiguous condition occurs if the resulting string will not fit into the destination buffer at c-addr2. )
   \  17.6.2.2375 UNESCAPE
   \  Replace each '%' character in the input string c-addr1 len1 with two '%' characters.
   \  The output is represented by c-addr2 len2.
   \  If you pass a string through UNESCAPE and then SUBSTITUTE, you get the original string.
   DUP 2SWAP OVER + SWAP ?DO
      I C@ [CHAR] % = IF
         [CHAR] % OVER C! 1+
      THEN
      I C@ OVER C! 1+
   LOOP
   OVER -
;

ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !
