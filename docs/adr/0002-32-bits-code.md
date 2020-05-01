# 2. 32 bits code

Date: 2020-05-01

## Status

Accepted

## Context

32-bits systems were all the rage when this project was concieved back in 1999.
64-bits systems were not available yet.
16-bits and 8-bit systems were not interesting.

## Decision

IKForth is implemented as 32-bits code with 32-bits CELL size.

## Consequences

The portability of 32-bits codebase is quite good over the past 21 years.
There are concerns about the future of 32-bits systems in 2020.
