CR .( Running LITERAL-EXT tests, no output is expected on success ) CR

REQUIRES" test/forth2012-test-suite/src/ttester.fs"

\ Binary literals:      %<literal>, \b<literal>, \B<literal>
\ Octal literals:       @<literal>, \o<literal>, \O<literal>
\ Decimal literals:     #<literal>, &<literal>
\ Hexadecimal literals: $<literal>, 0x<literal>, 0X<literal>,
\                       \x<literal>, \X<literal>, \u<literal>, \U<literal>

T{ S" "        ?BASE-PREFIX -> FALSE }T
T{ S" ^"       ?BASE-PREFIX -> FALSE }T
T{ S" %"       ?BASE-PREFIX -> FALSE }T
T{ S" @"       ?BASE-PREFIX -> FALSE }T
T{ S" #"       ?BASE-PREFIX -> FALSE }T
T{ S" &"       ?BASE-PREFIX -> FALSE }T
T{ S" $"       ?BASE-PREFIX -> FALSE }T
T{ S" %123"    ?BASE-PREFIX 2SWAP S" 123" COMPARE ->  2 TRUE 0 }T
T{ S" @123"    ?BASE-PREFIX 2SWAP S" 123" COMPARE ->  8 TRUE 0 }T
T{ S" #123"    ?BASE-PREFIX 2SWAP S" 123" COMPARE -> 10 TRUE 0 }T
T{ S" &123"    ?BASE-PREFIX 2SWAP S" 123" COMPARE -> 10 TRUE 0 }T
T{ S" $123"    ?BASE-PREFIX 2SWAP S" 123" COMPARE -> 16 TRUE 0 }T

T{ S" \a"      ?BASE-PREFIX -> FALSE }T
T{ S" \A"      ?BASE-PREFIX -> FALSE }T
T{ S" \b"      ?BASE-PREFIX -> FALSE }T
T{ S" \B"      ?BASE-PREFIX -> FALSE }T
T{ S" \o"      ?BASE-PREFIX -> FALSE }T
T{ S" \O"      ?BASE-PREFIX -> FALSE }T
T{ S" \u"      ?BASE-PREFIX -> FALSE }T
T{ S" \U"      ?BASE-PREFIX -> FALSE }T
T{ S" \x"      ?BASE-PREFIX -> FALSE }T
T{ S" \X"      ?BASE-PREFIX -> FALSE }T
T{ S" 0x"      ?BASE-PREFIX -> FALSE }T
T{ S" 0X"      ?BASE-PREFIX -> FALSE }T
T{ S" 0y"      ?BASE-PREFIX -> FALSE }T
T{ S" 0Y"      ?BASE-PREFIX -> FALSE }T
T{ S" 1x"      ?BASE-PREFIX -> FALSE }T
T{ S" 1X"      ?BASE-PREFIX -> FALSE }T
T{ S" \a123"   ?BASE-PREFIX -> FALSE }T
T{ S" \A123"   ?BASE-PREFIX -> FALSE }T
T{ S" \b123"   ?BASE-PREFIX 2SWAP S" 123" COMPARE ->  2 TRUE 0 }T
T{ S" \B123"   ?BASE-PREFIX 2SWAP S" 123" COMPARE ->  2 TRUE 0 }T
T{ S" \o123"   ?BASE-PREFIX 2SWAP S" 123" COMPARE ->  8 TRUE 0 }T
T{ S" \O123"   ?BASE-PREFIX 2SWAP S" 123" COMPARE ->  8 TRUE 0 }T
T{ S" \u123"   ?BASE-PREFIX 2SWAP S" 123" COMPARE -> 16 TRUE 0 }T
T{ S" \U123"   ?BASE-PREFIX 2SWAP S" 123" COMPARE -> 16 TRUE 0 }T
T{ S" \x123"   ?BASE-PREFIX 2SWAP S" 123" COMPARE -> 16 TRUE 0 }T
T{ S" \X123"   ?BASE-PREFIX 2SWAP S" 123" COMPARE -> 16 TRUE 0 }T
T{ S" 0x123"   ?BASE-PREFIX 2SWAP S" 123" COMPARE -> 16 TRUE 0 }T
T{ S" 0X123"   ?BASE-PREFIX 2SWAP S" 123" COMPARE -> 16 TRUE 0 }T
T{ S" 0y123"   ?BASE-PREFIX -> FALSE }T
T{ S" 0Y123"   ?BASE-PREFIX -> FALSE }T
T{ S" 1x123"   ?BASE-PREFIX -> FALSE }T
T{ S" 1X123"   ?BASE-PREFIX -> FALSE }T
