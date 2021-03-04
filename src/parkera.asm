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

AddParkerACenturyOffset:
  lda era
  cmp #ERA_BC
  beq AddParkerACenturyOffsetBC
    jsr ParkerAYearHundredsCheckAD
    jmp AddParkerACenturyOffsetContinue
AddParkerACenturyOffsetBC:
  jsr ParkerAYearHundredsCheckBC
AddParkerACenturyOffsetContinue:
  stx tmp
  lda era
  cmp #ERA_AD
  beq AddParkerACenturyOffsetAD
    lda #$07
    sec
    sbc tmp
    sta tmp
    lda year
    asl
    adc tmp
    sta tmp
    lda (year + 1)
    asl
    asl
    sec
    sbc (year + 1)
    clc
    adc tmp
    adc dayOffset
    sta dayOffset
AddParkerACenturyOffsetDone:
  rts
AddParkerACenturyOffsetAD:
  lda year
  asl
  asl
  clc
  adc year
  adc tmp
  sta tmp
  lda (year + 1)
  asl
  asl
  clc
  adc tmp
  adc dayOffset
  sta dayOffset
  rts

; Divide year[2:3] by 28 and place 7 minus that number in X register
ParkerAYearHundredsCheckBC:
  ldx #$07
  lda (year + 2)
  cmp #$01
  bcs ParkerAYearThousandsGTE1BC
    rts
ParkerAYearThousandsGTE1BC:
  bne ParkerAYearThousandsNE1BC
    lda (year + 3)
    cmp #$06
    bcc ParkerAYearHundredsCheckBCDone
      dex
      rts
ParkerAYearThousandsNE1BC:
  dex
  cmp #$04
  bcs ParkerAYearThousandsGTE4BC
    rts
ParkerAYearThousandsGTE4BC:
  bne ParkerAYearThousandsNE4BC
    lda (year + 3)
    cmp #$04
    bcc ParkerAYearHundredsCheckBCDone
      dex
      rts
ParkerAYearThousandsNE4BC:
  dex
  cmp #$07
  bcs ParkerAYearThousandsGTE7BC
    rts
ParkerAYearThousandsGTE7BC:
  bne ParkerAYearThousandsNE7BC
    lda (year + 3)
    cmp #$02
    bcc ParkerAYearHundredsCheckBCDone
ParkerAYearThousandsNE7BC:
  dex
ParkerAYearHundredsCheckBCDone:
  rts

; Divide year[2:3] by 28 and place 7 minus that number in X register
ParkerAYearHundredsCheckAD:
  ldx #$07
  lda (year + 2)
  cmp #$02
  bcs ParkerAYearThousandsGTE2AD
    rts
ParkerAYearThousandsGTE2AD:
  bne ParkerAYearThousandsNE2AD
    lda (year + 3)
    cmp #$08
    bcc ParkerAYearHundredsCheckADDone
      dex
      rts
ParkerAYearThousandsNE2AD:
  dex
  cmp #$05
  bcs ParkerAYearThousandsGTE5AD
    rts
ParkerAYearThousandsGTE5AD:
  bne ParkerAYearThousandsNE5AD
    lda (year + 3)
    cmp #$06
    bcc ParkerAYearHundredsCheckADDone
      dex
      rts
ParkerAYearThousandsNE5AD:
  dex
  cmp #$08
  bcs ParkerAYearThousandsGTE8AD
    rts
ParkerAYearThousandsGTE8AD:
  bne ParkerAYearThousandsNE8AD
    lda (year + 3)
    cmp #$04
    bcc ParkerAYearHundredsCheckADDone
ParkerAYearThousandsNE8AD:
  dex
ParkerAYearHundredsCheckADDone:
  rts

IsLeapYearParkerAAD:
  lda era
  cmp #ERA_BC
  beq IsLeapYearParkerAADDone
    lda (year + 4)
    ora (year + 5)
    bne IsLeapYearParkerAADDone
      lda (year + 2)
      cmp #$02
      bne IsLeapYearParkerAADThousandsNot2
        lda (year + 3)
        cmp #$08
        bne IsLeapYearParkerAADDone
          jmp IsLeapYearParkerAADSuccess
IsLeapYearParkerAADThousandsNot2:
  cmp #$05
  bne IsLeapYearParkerAADThousandsNot5
    lda (year + 3)
    cmp #$06
    bne IsLeapYearParkerAADDone
      jmp IsLeapYearParkerAADSuccess
IsLeapYearParkerAADThousandsNot5:
  cmp #$08
  bne IsLeapYearParkerAADDone
    lda (year + 3)
    cmp #$04
    bne IsLeapYearParkerAADDone
IsLeapYearParkerAADSuccess:
  lda #$00
  sta leapYear
IsLeapYearParkerAADDone:
  rts

IsLeapYearParkerABC:
  lda era
  cmp #ERA_AD
  beq IsLeapYearParkerABCDone
    lda (year + 4)
    ora (year + 5)
    bne IsLeapYearParkerABCDone
      lda (year + 2)
      cmp #$01
      bne IsLeapYearParkerABCThousandsNot1
        lda (year + 3)
        cmp #$06
        bne IsLeapYearParkerABCDone
          jmp IsLeapYearParkerABCSuccess
IsLeapYearParkerABCThousandsNot1:
  cmp #$04
  bne IsLeapYearParkerABCThousandsNot4
    lda (year + 3)
    cmp #$04
    bne IsLeapYearParkerABCDone
      jmp IsLeapYearParkerABCSuccess
IsLeapYearParkerABCThousandsNot4:
  cmp #$07
  bne IsLeapYearParkerABCDone
    lda (year + 3)
    cmp #$02
    bne IsLeapYearParkerABCDone
IsLeapYearParkerABCSuccess:
  lda #$00
  sta leapYear
  lda #$06
  clc
  adc dayOffset
  sta dayOffset
IsLeapYearParkerABCDone:
  rts

HandleParkerA:
  lda calendar
  cmp #CALENDAR_PARKER_A
  bne HandleParkerADone
  lda era
  jsr AddParkerACenturyOffset
  jsr IsLeapYearParkerAAD
  jsr IsLeapYearParkerABC
HandleParkerADone:
  rts
