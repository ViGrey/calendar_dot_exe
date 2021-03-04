; Copyright (C) 2020-2021, Vi Grey
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions
; are met:
;
; 1. Redistributions of source code must retain the above copyright
;    notice, this list of conditions and the following disclaimer.
; 2. Redistributions in binary form must reproduce the above copyright
;    notice, this list of conditions and the following disclaimer in the
;    documentation and/or other materials provided with the distribution.
;
; THIS SOFTWARE IS PROVIDED BY AUTHOR AND CONTRIBUTORS ``AS IS'' AND
; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL AUTHOR OR CONTRIBUTORS BE LIABLE
; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
; OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
; HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
; SUCH DAMAGE.

.enum $0000
  screen        dsb 1
  dayOffset     dsb 1
  dayDrawOffset dsb 1
  dayDraw       dsb 2
  weekDraw      dsb 1

  tmp           dsb 3
  
  addr          dsb 2

  year          dsb 6
  yearBinary    dsb 3
  era           dsb 1
  month         dsb 1
  calendar      dsb 1
  calendarTmp   dsb 1

  yearTmp         dsb 6
  yearEquivalent  dsb 6

  leapYear      dsb 1
  mod           dsb 1

  frames          dsb 1
  updateDisabled  dsb 1
  regionCheck     dsb 1
  needDraw        dsb 1

  kcode                 dsb 1
  disallowA             dsb 1
  controller            dsb 1
  controllerLastFrame   dsb 1

  cursorOffset          dsb 1
.ende

.enum $300
  graphicsControlFlags  dsb 1
  graphicsPointer       dsb 1
  ppuAddr               dsb 2
  ppuAddrLast           dsb 2

  graphics              dsb 244
.ende

.enum $400
  redLetterDays         dsb 42
  calendarAttributes    dsb 35
.ende

.enum $700
  debug     dsb 1
.ende
