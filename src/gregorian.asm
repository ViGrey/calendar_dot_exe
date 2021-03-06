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

; Century Offset == -2(partial_century % 4)

GetGregorianCenturyOffset:
  lda calendarTmp
  cmp #CALENDAR_GREGORIAN
  beq GetGregorianCenturyOffsetContinue
    rts
GetGregorianCenturyOffsetContinue:
  ldx #$03
  jsr YearDiv4Check
  lda mod
  asl
  tax
  lda #$07
  sec
GetGregorianCenturyOffsetLoop:
  cpx #$00
  beq GetGregorianCenturyOffsetLoopDone
    sbc #$01
    dex
    jmp GetGregorianCenturyOffsetLoop
GetGregorianCenturyOffsetLoopDone:
  sta dayOffset
  rts

IsLeapYearGregorian:
  lda calendarTmp
  cmp #CALENDAR_GREGORIAN
  bne IsLeapYearGregorianDone
    lda (yearEquivalent + 4)
    ora (yearEquivalent + 5)
    bne IsLeapYearGregorianDone
      ldx #$03
      jsr YearDiv4Check
      sta leapYear 
IsLeapYearGregorianDone:
  rts
