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

ParkerEraBCYearDec:
  lda calendar
  cmp #CALENDAR_PARKER_A
  beq ParkerEraBCYearDecContinue
    cmp #CALENDAR_PARKER_B
    beq ParkerEraBCYearDecContinue
      cmp #CALENDAR_PARKER_C
      beq ParkerEraBCYearDecContinue
        rts
ParkerEraBCYearDecContinue:
  lda era
  cmp #ERA_BC
  bne ParkerEraBCYearDecDone
    jsr DecYearAllow0
ParkerEraBCYearDecDone:
  rts

ParkerEraBCYearInc:
  lda calendar
  cmp #CALENDAR_PARKER_A
  beq ParkerEraBCYearIncContinue
    cmp #CALENDAR_PARKER_B
    beq ParkerEraBCYearIncContinue
      cmp #CALENDAR_PARKER_C
      beq ParkerEraBCYearIncContinue
        rts
ParkerEraBCYearIncContinue:
  lda era
  cmp #ERA_BC
  bne ParkerEraBCYearIncDone
    jsr IncYear
ParkerEraBCYearIncDone:
  rts


AddParkerB_C128YearOffset:
  lda era
  cmp #ERA_BC
  beq AddParkerB_C128YearOffsetBC
    lda tmp
    clc
    adc #$05
    sta tmp
    lda #28
    sec
    sbc tmp
    clc
    adc dayOffset
    sta dayOffset
    rts
AddParkerB_C128YearOffsetBC:
  lda tmp
  clc
  adc #$03
  adc dayOffset
  sta dayOffset
  rts

HandleParkerB_C:
  lda calendar
  cmp #CALENDAR_PARKER_B
  beq HandleParkerB_CContinue
    cmp #CALENDAR_PARKER_C
    beq HandleParkerB_CContinue
      rts
HandleParkerB_CContinue:
  jsr YearToBinary
  jsr IsLeapYearParkerB
  jsr HandleParkerC
  jsr YearBinaryDiv128ToTmp23LittleEndian
  jsr Tmp23Mod7ishLittleEndianToTmp
  jsr AddParkerB_C128YearOffset
  rts

IsLeapYearParkerB:
  lda yearBinary
  and #%01111111
  bne IsLeapYearParkerBDone
    lda #$00
    sta leapYear
    lda era
    cmp #ERA_BC
    bne IsLeapYearParkerBDone
      lda #$06
      clc
      adc dayOffset
      sta dayOffset
IsLeapYearParkerBDone:
  rts

HandleParkerC:
  lda calendar
  cmp #CALENDAR_PARKER_C
  bne HandleParkerCDone
    jsr IsLeapYearParkerC
    jsr AdjustDayParkerC
    jsr AdjustParkerCBC
HandleParkerCDone:
  rts

IsLeapYearParkerC:
  lda (yearBinary + 2)
  ora (yearBinary + 1)
  ora yearBinary
  bne IsLeapYearParkerCContinue
    lda #$01
    sta leapYear
    rts
IsLeapYearParkerCContinue:
  lda (yearBinary + 2)
  cmp #%00001001
  bne IsLeapYearParkerCDone
    lda (yearBinary + 1)
    cmp #%10001001
    bne IsLeapYearParkerCDone
      lda yearBinary
      cmp #%10000000
      bne IsLeapYearParkerCDone
        lda #$01
        sta leapYear
IsLeapYearParkerCDone:
  rts

AdjustDayParkerC:
  lda (yearBinary + 2)
  cmp #%00001001
  bcc AdjustDayParkerCDone
    bne AdjustDayParkerCContinue
      lda (yearBinary + 1)
      cmp #%10001001
      bcc AdjustDayParkerCDone
        bne AdjustDayParkerCContinue
          lda yearBinary
          cmp #%10000000
          bne AdjustDayParkerCDone
            lda era
            cmp #ERA_BC
            beq AdjustDayParkerCBC
              inc dayOffset
              rts
AdjustDayParkerCDone:
  rts
AdjustDayParkerCContinue:
  lda era
  cmp #ERA_BC
  beq AdjustDayParkerCBC
    inc dayOffset
    rts
AdjustDayParkerCBC:
  lda #$06
  clc
  adc dayOffset
  sta dayOffset
  rts

AdjustParkerCBC:
  lda (yearBinary + 2)
  ora (yearBinary + 1)
  ora yearBinary
  beq AdjustParkerCBCDone
    lda era
    cmp #ERA_BC
    bne AdjustParkerCBCDone
      lda #$06
      clc
      adc dayOffset
      sta dayOffset
AdjustParkerCBCDone:
  rts

HandleParkerRedLetterDays:
  jsr ClearRedLetterDaysAttributes
  lda calendar
  cmp #CALENDAR_PARKER_A
  beq HandleParkerRedLetterDaysContinue
    cmp #CALENDAR_PARKER_B
    beq HandleParkerRedLetterDaysContinue
      cmp #CALENDAR_PARKER_C
      bne HandleParkerRedLetterDaysDone
HandleParkerRedLetterDaysContinue:
  jsr ThirdsdayRedLetter
  jsr PiDayRedLetter
  jsr TauDayRedLetter
  jsr LeapDayRedLetter
  jsr Dec22RedLetter
  jsr SpringEquinoxRedLetter
HandleParkerRedLetterDaysDone:
  jsr CalculateCalendarRowAttributes
  rts
