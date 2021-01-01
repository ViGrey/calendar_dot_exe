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

; Roman calendar with incorrect leap years until Caesar Augustus

;DrawDaysMacrobiusOctober1582:
  lda dayOffset
  tay
  asl
  asl
  clc
  adc #$24
  sta (ppuAddr + 1)
  lda #$21
  adc #$00
  sta ppuAddr
  ldx #$00
DrawDaysMacrobiusOctober1582Loop:
  cpx #$08
  bne DrawDaysMacrobiusOctober1582LoopNotJump11Days
    ldx #$1C 
DrawDaysMacrobiusOctober1582LoopNotJump11Days:
  lda NumbersPrint, X
  sta tmp
  inx
  lda NumbersPrint, X
  sta (tmp + 1)
  inx
  txa
  pha

  jsr DrawDayDigits
  pla
  tax
  lda (ppuAddr + 1)
  clc
  adc #$04
  sta (ppuAddr + 1)
  lda ppuAddr
  adc #$00
  sta ppuAddr
  stx tmp
  lsr tmp
  txa
  pha

  ldx month
  lda DaysPerMonthTable, X
  cmp tmp
  beq DrawDaysMacrobiusOctober1582Done
    pla
    tax
    iny
    cpy #$07
    bne DrawDaysMacrobiusOctober1582Loop
      ldy #$00
      lda (ppuAddr + 1)
      clc
      adc #$04
      sta (ppuAddr + 1)
      lda ppuAddr
      adc #$00
      sta ppuAddr
      jsr IncPPUAddr1Row
      jsr IncPPUAddr1Row
      jmp DrawDaysMacrobiusOctober1582Loop
DrawDaysMacrobiusOctober1582Done:
  pla
  rts

CheckMacrobiusOctober1582:
  ldx #$00
  lda calendar
  cmp #CALENDAR_ROMAN
  bne CheckMacrobiusOctober1582Done
    lda era
    cmp #ERA_AD
    bne CheckMacrobiusOctober1582Done
      lda year
      eor (year + 1)
      bne CheckMacrobiusOctober1582Done
        lda (year + 2)
        cmp #$01
        bne CheckMacrobiusOctober1582Done
          lda (year + 3)
          cmp #$05
          bne CheckMacrobiusOctober1582Done
            lda (year + 4)
            cmp #$08
            bne CheckMacrobiusOctober1582Done
              lda (year + 5)
              cmp #$02
              bne CheckMacrobiusOctober1582Done
                lda month
                cmp #MONTH_OCTOBER
                bne CheckMacrobiusOctober1582Done
                  inx
CheckMacrobiusOctober1582Done:
  rts

DetermineIfMacrobiusError:
  lda year
  eor (year + 1)
  eor (year + 2)
  eor (year + 3)
  bne DetermineIfMacrobiusErrorDone
    lda calendar
    cmp #CALENDAR_ROMAN
    bne DetermineIfMacrobiusErrorDone
      lda era
      cmp #ERA_AD
      beq DetermineIfMacrobiusErrorAD
        lda (year + 4)
        cmp #$05
        bcs DetermineIfMacrobiusErrorDone
          cmp #$04
          bcc DetermineIfMacrobiusErrorTrue
            lda (year + 5)
            cmp #03
            bcs DetermineIfMacrobiusErrorDone
              jmp DetermineIfMacrobiusErrorTrue
DetermineIfMacrobiusErrorAD:
  lda (year + 4)
  bne DetermineIfMacrobiusErrorDone
    lda (year + 5)
    cmp #$05
    bcs DetermineIfMacrobiusErrorDone
DetermineIfMacrobiusErrorTrue:
  jsr AdjustMacrobiusDayOffsetRemoveLeapYears
  jsr AdjustMacrobiusDayOffsetMacrobiusError
  jsr DetermineIfLeapYearMacrobius
DetermineIfMacrobiusErrorDone:
  rts


AdjustMacrobiusDayOffsetRemoveLeapYears:
  ldy #$00
  lda era
  cmp #ERA_BC
  beq AdjustMacrobiusDayOffsetRemoveLeapYearsBC
    lda #$03
    clc
    adc dayOffset
    sta dayOffset
    lda (year + 5)
    cmp #$04
    bcc AdjustMacrobiusDayOffsetRemoveLeapYearsNotAD4
      dec dayOffset
AdjustMacrobiusDayOffsetRemoveLeapYearsNotAD4:
  rts
AdjustMacrobiusDayOffsetRemoveLeapYearsBC:
  lda #$04
  sta tmp
  lda #$01
  sta (tmp + 1)
AdjustMacrobiusDayOffsetRemoveLeapYearsBCLoop:
  ; If year is the same or less than tmp
  lda (year + 4)
  cmp tmp
  bcc AdjustMacrobiusDayOffsetRemoveLeapYearsBCLoopIny
    bne AdjustMacrobiusDayOffsetRemoveLeapYearsDone
      lda (year + 5)
      cmp (tmp + 1)
      bcc AdjustMacrobiusDayOffsetRemoveLeapYearsBCLoopIny
        beq AdjustMacrobiusDayOffsetRemoveLeapYearsBCLoopIny
          jmp AdjustMacrobiusDayOffsetRemoveLeapYearsDone
AdjustMacrobiusDayOffsetRemoveLeapYearsBCLoopIny:
  iny
  jsr DecTmp04
  lda tmp
  bpl AdjustMacrobiusDayOffsetRemoveLeapYearsBCLoop
AdjustMacrobiusDayOffsetRemoveLeapYearsDone:
  tya
  sta tmp
  lda #14
  sec
  sbc tmp
  clc
  adc dayOffset
  sta dayOffset
  rts


AdjustMacrobiusDayOffsetMacrobiusError:
  lda era
  cmp #ERA_AD
  beq AdjustMacrobiusDayOffsetYearAD
    lda (year + 4)
    bne AdjustMacrobiusDayOffsetYearBC
      lda (year + 5)
      cmp #$09
      bcc AdjustMacrobiusDayOffsetYearAD
AdjustMacrobiusDayOffsetYearBC:
  lda #$04
  sta tmp
  lda #$02
  sta (tmp + 1)
AdjustMacrobiusDayOffsetYearBCLoop:
  lda (year + 4)
  cmp tmp
  bcc AdjustMacrobiusDayOffsetYearBCLoopAddToOffset
    bne AdjustMacrobiusDayOffsetDone
      lda (year + 5)
      cmp (tmp + 1)
      bcc AdjustMacrobiusDayOffsetYearBCLoopAddToOffset
        beq AdjustMacrobiusDayOffsetYearBCLoopAddToOffset
          rts
AdjustMacrobiusDayOffsetYearBCLoopAddToOffset:
  inc dayOffset
  jsr DecTmp03
  jmp AdjustMacrobiusDayOffsetYearBCLoop
AdjustMacrobiusDayOffsetYearAD:
  lda dayOffset
  clc
  adc #$0C
  sta dayOffset
AdjustMacrobiusDayOffsetDone:
  rts

DetermineIfLeapYearMacrobius:
  lda #$00
  sta leapYear
  lda era
  cmp #ERA_BC
  bne DetermineIfLeapYearMacrobiusDone
    lda #$04
    sta tmp
    lda #$02
    sta (tmp + 1)
DetermineIfLeapYearMacrobiusLoop:
  lda (year + 4)
  cmp tmp
  bne DetermineIfLeapYearMacrobiusLoopCheckEnd
    lda (year + 5)
    cmp (tmp + 1)
    beq DetermineIfLeapYearMacrobiusTrue
DetermineIfLeapYearMacrobiusLoopCheckEnd:
  lda tmp
  bne DetermineIfLeapYearMacrobiusLoopContinue
    lda (tmp + 1)
    cmp #$09
    beq DetermineIfLeapYearMacrobiusDone
DetermineIfLeapYearMacrobiusLoopContinue:
  jsr DecTmp03
  jmp DetermineIfLeapYearMacrobiusLoop
DetermineIfLeapYearMacrobiusTrue:
  lda #$01
  sta leapYear
DetermineIfLeapYearMacrobiusDone:
  rts
