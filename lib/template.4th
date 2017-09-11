\
\  template.4th
\
\  Copyright (C) 1999-2017 Illya Kysil
\

CR .( Loading TEMPLATE definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

ONLY FORTH DEFINITIONS

VOCABULARY TEMPLATE-PRIVATE

ALSO TEMPLATE-PRIVATE DEFINITIONS

\ private definitions go here

ONLY FORTH DEFINITIONS ALSO TEMPLATE-PRIVATE

\ public definitions go here
\ private definitions are available for use

ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !
