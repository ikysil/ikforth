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
   \ FIXME
   2SWAP 2DROP 0
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
