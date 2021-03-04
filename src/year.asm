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

YearBCToYearAD:
  lda era
  beq YearBCToYearADEraIsBC
    rts
YearBCToYearADEraIsBC:
  lda (yearEquivalent + 5)
  sec
  sbc #$01
  bpl YearBCToYearADSubtractTens
    dec (yearEquivalent + 4)
    clc
    adc #$0A
YearBCToYearADSubtractTens:
  sta (yearEquivalent + 5)
  lda (yearEquivalent + 4)
  sec
  sbc #$00
  bpl YearBCToYearADSubtractHundreds
    dec (yearEquivalent + 3)
    clc
    adc #$0A
YearBCToYearADSubtractHundreds:
  sta (yearEquivalent + 4)
  lda (yearEquivalent + 3)
  sec
  sbc #$08
  bpl YearBCToYearADSubtractThousands
    dec (yearEquivalent + 2)
    clc
    adc #$0A
YearBCToYearADSubtractThousands:
  sta (yearEquivalent + 3)
  lda (yearEquivalent + 2)
  sec
  sbc #$02
  sta (yearEquivalent + 2)
YearBCToYearADCompliment:
  lda #$0A
  sec
  sbc (yearEquivalent + 5)
  cmp #$0A
  bcc YearBCToYearADComplimentTens
    dec (yearEquivalent + 4)
    sec
    sbc #$0A
YearBCToYearADComplimentTens:
  sta (yearEquivalent + 5)
  lda #$09
  sec
  sbc (yearEquivalent + 4)
  cmp #$0A
  bcc YearBCToYearADComplimentHundreds
    dec (yearEquivalent + 3)
    sec
    sbc #$0A
YearBCToYearADComplimentHundreds:
  sta (yearEquivalent + 4)
  lda #$09
  sec
  sbc (yearEquivalent + 3)
  cmp #$0A
  bcc YearBCToYearADComplimentThousands
    dec (yearEquivalent + 2)
    sec
    sbc #$0A
YearBCToYearADComplimentThousands:
  sta (yearEquivalent + 3)
  lda #$FF
  sec
  sbc (yearEquivalent + 2)
  sta (yearEquivalent + 2)
  rts


YearToYearEquivalent:
  ldx #$05
YearToYearEquivalentLoop:
  lda year, X
  sta yearEquivalent, X
  dex
  bpl YearToYearEquivalentLoop
YearToYearEquivalentSubtractHund:
  lda yearEquivalent
  beq YearToYearEquivalentSubtractTen
    jsr YearToYearEquivalentHundLoop 
YearToYearEquivalentSubtractTen:
  lda (yearEquivalent + 1)
  beq YearToYearEquivalentSubtractOne
    jsr YearToYearEquivalentTenLoop 
YearToYearEquivalentSubtractOne:
  jsr YearToYearEquivalentOneLoop 
  jsr AdjustYearEquivalentYear0To2800
  jsr YearBCToYearAD
  rts

YearToYearEquivalentHundLoop:
  lda (yearEquivalent + 3)
  sec
  sbc #$08
  bpl YearToYearEquivalentHundLoopSubtractOne
    dec (yearEquivalent + 2)
    clc
    adc #$0A
YearToYearEquivalentHundLoopSubtractOne:
  sta (yearEquivalent + 3)
  lda (yearEquivalent + 2)
  sec
  sbc #$00
  bpl YearToYearEquivalentHundLoopSubtractTen
    dec (yearEquivalent + 1)
    clc
    adc #$0A
YearToYearEquivalentHundLoopSubtractTen:
  sta (yearEquivalent + 2)
  lda (yearEquivalent + 1)
  sec
  sbc #$00
  bpl YearToYearEquivalentHundLoopSubtractHund
    dec yearEquivalent
    clc
    adc #$0A
YearToYearEquivalentHundLoopSubtractHund:
  sta (yearEquivalent + 1)
  lda yearEquivalent
  sec
  sbc #$01
  sta yearEquivalent
  bpl YearToYearEquivalentHundLoopContinue
YearToYearEquivalentHundLoopAddLoop:
  lda yearEquivalent
  bpl YearToYearEquivalentHundLoopDone
    lda (yearEquivalent + 3)
    clc
    adc #$02
    cmp #$0A
    bcc YearToYearEquivalentHundLoopAddOne
      inc (yearEquivalent + 2)
      sec
      sbc #$0A
YearToYearEquivalentHundLoopAddOne:
  sta (yearEquivalent + 3)
  lda (yearEquivalent + 2)
  clc
  adc #$01
  cmp #$0A
  bcc YearToYearEquivalentHundLoopAddTen
    inc (yearEquivalent + 1)
    sec
    sbc #$0A
YearToYearEquivalentHundLoopAddTen:
  sta (yearEquivalent + 2)
  lda (yearEquivalent + 1)
  clc
  adc #$01
  cmp #$0A
  bcc YearToYearEquivalentHundLoopAddLoopContinue
    inc yearEquivalent
    sec
    sbc #$0A
YearToYearEquivalentHundLoopAddLoopContinue:
  sta (yearEquivalent + 1)
  jmp YearToYearEquivalentHundLoopAddLoop
YearToYearEquivalentHundLoopDone:
  rts
YearToYearEquivalentHundLoopContinue:
  jmp YearToYearEquivalentHundLoop




YearToYearEquivalentTenLoop:
  lda (yearEquivalent + 3)
  sec
  sbc #$02
  bpl YearToYearEquivalentTenLoopSubtractOne
    dec (yearEquivalent + 2)
    clc
    adc #$0A
YearToYearEquivalentTenLoopSubtractOne:
  sta (yearEquivalent + 3)
  lda (yearEquivalent + 2)
  sec
  sbc #$01
  bpl YearToYearEquivalentTenLoopSubtractTen
    dec (yearEquivalent + 1)
    clc
    adc #$0A
YearToYearEquivalentTenLoopSubtractTen:
  sta (yearEquivalent + 2)
  lda (yearEquivalent + 1)
  sec
  sbc #$01
  sta (yearEquivalent + 1)
  bpl YearToYearEquivalentTenLoopContinue
YearToYearEquivalentTenLoopAddLoop:
  lda (yearEquivalent + 1)
  bpl YearToYearEquivalentTenLoopDone
    lda (yearEquivalent + 3)
    clc
    adc #$08
    cmp #$0A
    bcc YearToYearEquivalentTenLoopAddOne
      inc (yearEquivalent + 2)
      sec
      sbc #$0A
YearToYearEquivalentTenLoopAddOne:
  sta (yearEquivalent + 3)
  lda (yearEquivalent + 2)
  clc
  adc #$02
  cmp #$0A
  bcc YearToYearEquivalentTenLoopAddLoopContinue
    inc (yearEquivalent + 1)
    sec
    sbc #$0A
YearToYearEquivalentTenLoopAddLoopContinue:
  sta (yearEquivalent + 2)
  jmp YearToYearEquivalentTenLoopAddLoop
YearToYearEquivalentTenLoopDone:
  rts
YearToYearEquivalentTenLoopContinue:
  jmp YearToYearEquivalentTenLoop

YearToYearEquivalentOneLoop:
  lda (yearEquivalent + 3)
  sec
  sbc #$08
  bpl YearToYearEquivalentOneLoopSubtractOne
    dec (yearEquivalent + 2)
    clc
    adc #$0A
YearToYearEquivalentOneLoopSubtractOne:
  sta (yearEquivalent + 3)
  lda (yearEquivalent + 2)
  sec
  sbc #$02
  sta (yearEquivalent + 2)
  bpl YearToYearEquivalentOneLoopContinue
    lda (yearEquivalent + 3)
    clc
    adc #$08
    cmp #$0A
    bcc YearToYearEquivalentOneLoopDone
      inc (yearEquivalent + 2)
      sec
      sbc #$0A
YearToYearEquivalentOneLoopDone:
  sta (yearEquivalent + 3)
  lda (yearEquivalent + 2)
  clc
  adc #$02
  sta (yearEquivalent + 2)
  rts
YearToYearEquivalentOneLoopContinue:
  jmp YearToYearEquivalentOneLoop

AdjustYearEquivalentYear0To2800:
  lda (yearEquivalent + 5)
  ora (yearEquivalent + 4)
  ora (yearEquivalent + 3)
  ora (yearEquivalent + 2)
  bne AdjustYearEquivalentYear0To2800Done
    lda #$02
    sta (yearEquivalent + 2)
    lda #$08
    sta (yearEquivalent + 3)
AdjustYearEquivalentYear0To2800Done:
  rts

GetYearMinusTmp:
  lda (yearEquivalent + 5)
  sec
  sbc (tmp + 1)
  sta (tmp + 1)
  lda (yearEquivalent + 4)
  sbc tmp
  sta tmp
  lda (tmp + 1)
  bpl GetYearMinusTmpDone
    clc
    adc #$0A
GetYearMinusTmpDone:
  sta (tmp + 1)
  rts

CompareTmpToYear:
  lda tmp
  cmp (yearEquivalent + 4)
  bcc CompareTmpToYearUnder
    bne CompareTmpToYearOver
      lda (tmp + 1)
      cmp (yearEquivalent + 5)
      bcc CompareTmpToYearUnder
        beq CompareTmpToYearUnder
CompareTmpToYearOver:
  dec dayOffset
  jsr TmpDec12
  jsr GetYearMinusTmp
  jsr AddTmpToDayOffset
  rts
CompareTmpToYearUnder:
  inc dayOffset
  jsr TmpAdd12
  jmp CompareTmpToYear

HandleIncYear:
  lda era
  cmp #ERA_BC
  beq HandleIncYearBC
    jsr IncYear
    rts
HandleIncYearBC:
  jsr DecYear
  rts

HandleDecYear:
  lda era
  cmp #ERA_BC
  beq HandleDecYearBC
    jsr DecYear
    rts
HandleDecYearBC:
  jsr IncYear
  rts

CheckMinYearMonthBC:
  ldx #$05
CheckMinYearMonthBCLoop:
  lda year, X
  cmp #$09
  bne CheckMinYearMonthBCDone
    dex
    bpl CheckMinYearMonthBCLoop
      lda month
      cmp #MONTH_JANUARY
      bne CheckMinYearMonthBCDone
        ldx #$01
        rts
CheckMinYearMonthBCDone:
  ldx #$00
  rts

CheckMaxYearMonthAD:
  ldx #$05
CheckMaxYearMonthADLoop:
  lda year, X
  cmp #$09
  bne CheckMaxYearMonthADDone
    dex
    bpl CheckMaxYearMonthADLoop
      lda month
      cmp #MONTH_DECEMBER
      bne CheckMaxYearMonthADDone
        ldx #$01
        rts
CheckMaxYearMonthADDone:
  ldx #$00
  rts

CheckMinYearBC:
  ldx #$05
CheckMinYearBCLoop:
  lda year, X
  cmp #$09
  bne CheckMinYearBCDone
    dex
    bpl CheckMinYearBCLoop
      ldx #$01
      rts
CheckMinYearBCDone:
  ldx #$00
  rts

CheckMaxYearAD:
  ldx #$05
CheckMaxYearADLoop:
  lda year, X
  cmp #$09
  bne CheckMaxYearADDone
    dex
    bpl CheckMaxYearADLoop
      ldx #$01
      rts
CheckMaxYearADDone:
  ldx #$00
  rts


IncYear:
  ldx #$05
  inc year, X
IncYearLoop:
  lda year, X
  cmp #$0A
  bcc IncYearLoopContinue
    lda year, X
    sec
    sbc #$0A
    sta year, X
    dex
    inc year, X
    inx
IncYearLoopContinue:
  dex
  bpl IncYearLoop
    rts

DecYear:
  ldx #$05
  dec year, X
DecYearLoop:
  lda year, X
  bpl DecYearLoopContinue
    lda year, X
    clc
    adc #$0A
    sta year, X
    dex
    dec year, X
    inx
DecYearLoopContinue:
  dex
  bpl DecYearLoop
    lda (year + 5)
    ora (year + 4)
    ora (year + 3)
    ora (year + 2)
    ora (year + 1)
    ora year
    beq DecYearSwitchEra
      rts
DecYearSwitchEra:
  lda #$01
  sta (year + 5)
  lda era
  cmp #ERA_BC
  beq DecYearSwitchEraFromBCToAD
    lda #ERA_BC
    sta era
    rts
DecYearSwitchEraFromBCToAD:
  lda #ERA_AD
  sta era
  rts

DecYearAllow0:
  ldx #$05
  dec year, X
DecYearAllow0Loop:
  lda year, X
  bpl DecYearAllow0LoopContinue
    lda year, X
    clc
    adc #$0A
    sta year, X
    dex
    dec year, X
    inx
DecYearAllow0LoopContinue:
  dex
  bpl DecYearAllow0Loop
    rts
