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

CalculateCalendarRowAttributes:
  ldy #$00
CalculateCalendarRowAttributesRow0:
  lda redLetterDays, Y
  beq CalculateCalendarRowAttributesRow0Continue
    lda #%01110111
    sta calendarAttributes, Y
CalculateCalendarRowAttributesRow0Continue:
  iny
  cpy #07
  bne CalculateCalendarRowAttributesRow0
    lda calendarAttributes, Y
    and #%00110011
    sta calendarAttributes, Y
CalculateCalendarRowAttributesRow1:
  lda redLetterDays, Y
  beq CalculateCalendarRowAttributesRow1Continue
    lda #%01010111
    sta calendarAttributes, Y
CalculateCalendarRowAttributesRow1Continue:
  iny
  cpy #14
  bne CalculateCalendarRowAttributesRow1
    lda calendarAttributes, Y
    and #%00110011
    sta calendarAttributes, Y
CalculateCalendarRowAttributesRow2:
  lda redLetterDays, Y
  beq CalculateCalendarRowAttributesRow2Continue
    tya
    sec
    sbc #07
    tay
    lda #%01110101
    ora calendarAttributes, Y
    sta calendarAttributes, Y
    tya
    clc
    adc #07
    tay
    lda #$03
    lda #%01010111
    sta calendarAttributes, Y
CalculateCalendarRowAttributesRow2Continue:
  iny
  cpy #21
  bne CalculateCalendarRowAttributesRow2
    tya
    sec
    sbc #$07
    tay
    lda calendarAttributes, Y
    and #%00110011
    sta calendarAttributes, Y
    tya
    clc
    adc #$07
    tay
CalculateCalendarRowAttributesRow3:
  lda redLetterDays, Y
  beq CalculateCalendarRowAttributesRow3Continue
    tya
    sec
    sbc #07
    tay
    lda #%01110101
    ora calendarAttributes, Y
    sta calendarAttributes, Y
    tya
    clc
    adc #07
    tay
CalculateCalendarRowAttributesRow3Continue:
  iny
  cpy #28
  bne CalculateCalendarRowAttributesRow3
    tya
    sec
    sbc #$07
    tay
    lda calendarAttributes, Y
    and #%00110011
    sta calendarAttributes, Y
    tya
    clc
    adc #$07
    tay
CalculateCalendarRowAttributesRow4:
  lda redLetterDays, Y
  beq CalculateCalendarRowAttributesRow4Continue
    tya
    sec
    sbc #07
    tay
    lda #%01110111
    sta calendarAttributes, Y
    tya
    clc
    adc #07
    tay
CalculateCalendarRowAttributesRow4Continue:
  iny
  cpy #35
  bne CalculateCalendarRowAttributesRow4
    tya
    sec
    sbc #$07
    tay
    lda calendarAttributes, Y
    and #%00110011
    sta calendarAttributes, Y
    tya
    clc
    adc #$07
    tay
CalculateCalendarRowAttributesRow5:
  lda redLetterDays, Y
  beq CalculateCalendarRowAttributesRow5Continue
    tya
    sec
    sbc #07
    tay
    lda #%01010111
    sta calendarAttributes, Y
    tya
    clc
    adc #07
    tay
CalculateCalendarRowAttributesRow5Continue:
  iny
  cpy #42
  bne CalculateCalendarRowAttributesRow5
    tya
    sec
    sbc #$07
    tay
    lda calendarAttributes, Y
    and #%00110011
    sta calendarAttributes, Y
    tya
    clc
    adc #$07
    tay
    rts

ClearRedLetterDaysAttributes:
  lda #$00
  ldy #$00
ClearRedLetterDaysLoop:
  sta redLetterDays, Y
  iny
  cpy #42
  bne ClearRedLetterDaysLoop
    lda #%01010101
    ldy #$00
ClearRedLetterAttributesLoop:
  sta calendarAttributes, Y
  iny
  cpy #35
  bne ClearRedLetterAttributesLoop
    rts

DrawRedLetterAttr:
  pha
  sta tmp
  tax
  ldy graphicsPointer
  lda #$00
  sta graphics, Y
  iny
  lda #$FE
  sta graphics, Y
  iny
  lda #$23
  sta graphics, Y
  iny
  txa
  asl
  asl
  asl
  sta (tmp + 1)
  clc
  adc #$D1
  sta graphics, Y
  iny
  lda (tmp + 1)
  sec
  sbc tmp
  tax
  lda #$07
  sta tmp
DrawRedLetterAttrLoop:
  lda calendarAttributes, X
  sta graphics, Y
  iny
  jmp DrawRedLetterAttrLoopContinue
DrawRedLetterAttrLoopContinue:
  inx
  dec tmp
  bne DrawRedLetterAttrLoop
    sty graphicsPointer
    pla
    clc
    adc #$01
    cmp #$05
    bne DrawRedLetterAttr
      rts

ThirdsdayRedLetter:
  lda month
  cmp #MONTH_JANUARY
  bne ThirdsdayRedLetterNotJanuary
    lda dayOffset
    cmp #$02
    bne ThirdsdayRedLetterDone
      lda #$01
      ldx #$04
      sta redLetterDays, X
      rts
ThirdsdayRedLetterNotJanuary:
  lda month
  cmp #MONTH_MARCH
  bne ThirdsdayRedLetterDone
    lda dayOffset
    cmp #$04
    bne ThirdsdayRedLetterDone
      lda #$01
      ldx #$04
      sta redLetterDays, X
ThirdsdayRedLetterDone:
  rts

PiDayRedLetter:
  lda month
  cmp #MONTH_MARCH
  bne PiDayRedLetterDone
    lda dayOffset
    clc
    adc #13
    tax
    lda #$01
    sta redLetterDays, X
PiDayRedLetterDone:
  rts

TauDayRedLetter:
  lda month
  cmp #MONTH_JUNE
  bne TauDayRedLetterDone
    lda dayOffset
    clc
    adc #27
    tax
    lda #$01
    sta redLetterDays, X
TauDayRedLetterDone:
  rts

LeapDayRedLetter:
  lda month
  cmp #MONTH_FEBRUARY
  bne LeapDayRedLetterDone
    lda leapYear
    beq LeapDayRedLetterDone
      lda dayOffset
      clc
      adc #23
      tax
      lda #$01
      sta redLetterDays, X
LeapDayRedLetterDone:
  rts

Dec22RedLetter:
  lda month
  cmp #MONTH_DECEMBER
  bne Dec22RedLetterDone
    lda era
    cmp #ERA_AD
    bne Dec22RedLetterDone
      lda year
      bne Dec22RedLetterSuccess
        lda (year + 1)
        bne Dec22RedLetterSuccess
          lda (year + 2)
          cmp #$01
          bcc Dec22RedLetterDone
            bne Dec22RedLetterSuccess
              lda (year + 3)
              cmp #$09
              bcc Dec22RedLetterDone
                lda (year + 4)
                cmp #$08
                bcc Dec22RedLetterDone
Dec22RedLetterSuccess:
  lda dayOffset
  clc
  adc #21
  tax
  lda #$01
  sta redLetterDays, X
Dec22RedLetterDone:
  rts

SpringEquinoxRedLetter:
  lda month
  cmp #MONTH_MARCH
  bne SpringEquinoxRedLetterDone
    lda era
    cmp #ERA_AD
    bne SpringEquinoxRedLetterDone
      lda year
      bne SpringEquinoxRedLetterSuccess
        lda (year + 1)
        bne SpringEquinoxRedLetterSuccess
          lda (year + 2)
          bne SpringEquinoxRedLetterSuccess
            lda (year + 3)
            cmp #$03
            bcc SpringEquinoxRedLetterDone
              bne SpringEquinoxRedLetterSuccess
                lda (year + 4)
                cmp #$02
                bcc SpringEquinoxRedLetterDone
                  bne SpringEquinoxRedLetterSuccess
                    lda (year + 5)
                    cmp #$05
                    bcc SpringEquinoxRedLetterDone
SpringEquinoxRedLetterSuccess:
  lda dayOffset
  clc
  adc #20
  tax
  lda #$01
  sta redLetterDays, X
SpringEquinoxRedLetterDone:
  rts
