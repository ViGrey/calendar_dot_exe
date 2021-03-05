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

CalendarTypes:
  .byte $88, $89, $8A, $8B, $8C, $E1, "  "; Gregorian
  .byte $E1, $8D, $8E, $8F, $E1, $E1, "  "; Julian
  .byte $E1, $9B, $9C, $8C, $E1, $E1, "  "; Roman
  .byte $C8, $C9, $CA, $CB, $E1, $E1, "  "; Parker A
  .byte $C8, $C9, $CA, $CC, $E1, $E1, "  "; Parker B
  .byte $C8, $C9, $CA, $CD, $E1, $E1, "  "; Parker C

DrawCalendarScreen:
  lda #$01
  sta updateDisabled
  lda #$FF
  sta controller
  sta controllerLastFrame
  lda #$00
  sta needDraw
  jsr WaitForNewFrame
  jsr BlackPalette
  lda #$01
  sta needDraw
  jsr WaitForNewFrame
  lda #$00
  sta needDraw
  jsr Blank
  lda #SCREEN_CALENDAR
  sta screen
  jsr ClearSprites
  jsr ClearPPURAM
  jsr SetPalettes
  jsr UpdateDone
  jsr ReadThenResetGraphics
  jsr DrawCalendarSkeleton
  jsr ResetScroll
  jsr DrawCalendar
  jsr ResetScroll
  lda #$00
  sta updateDisabled
  rts

DrawCalendarType:
  lda calendar
  asl
  asl
  asl
  tax
  lda PPU_STATUS
  lda #$20
  lda PPU_ADDR
  lda #$AF
  lda PPU_ADDR
DrawCalendarTypeLoop:
  lda CalendarTypes, X
  sta PPU_DATA
  inx
  txa
  and #%00000111
  cmp #%00000101
  bne DrawCalendarTypeLoop
    rts

SetCalendarTypeTmp:
  lda calendar
  cmp #CALENDAR_PARKER_A
  beq SetCalendarTypeTmpGregorian
    cmp #CALENDAR_PARKER_B
    beq SetCalendarTypeTmpJulian
      cmp #CALENDAR_PARKER_C
      beq SetCalendarTypeTmpJulian
SetCalendarTypeTmpNotParker:
  cmp #CALENDAR_ROMAN
  bne SetCalendarTypeTmpNotRoman
    lda era
    cmp #ERA_BC
    beq SetCalendarTypeTmpJulian
      lda year
      ora (year + 1)
      bne SetCalendarTypeTmpGregorian
        lda (year + 2)
        cmp #$02
        bcs SetCalendarTypeTmpGregorian
          cmp #$01
          bcc SetCalendarTypeTmpJulian
            lda (year + 3)
            cmp #$06
            bcs SetCalendarTypeTmpGregorian
              cmp #$05
              bcc SetCalendarTypeTmpJulian
                lda (year + 4)
                cmp #$09
                bcs SetCalendarTypeTmpGregorian
                  cmp #$08
                  bcc SetCalendarTypeTmpJulian
                    lda (year + 5)
                    cmp #$03
                    bcs SetCalendarTypeTmpGregorian
                      cmp #$02
                      bcc SetCalendarTypeTmpJulian
                        lda month
                        cmp #MONTH_NOVEMBER
                        bcs SetCalendarTypeTmpGregorian
                          jmp SetCalendarTypeTmpJulian
SetCalendarTypeTmpNotRoman:
  cmp #CALENDAR_JULIAN
  bne SetCalendarTypeTmpGregorian
SetCalendarTypeTmpJulian:
  lda #CALENDAR_JULIAN
  sta calendarTmp
  rts
SetCalendarTypeTmpGregorian:
  lda #CALENDAR_GREGORIAN
  sta calendarTmp
  rts

DrawMonthTop:
  ldy graphicsPointer
  lda month
  asl
  asl
  asl
  asl
  sta tmp
DrawMonthTopLoop:
  ldx tmp
  lda Months, X
  sec
  sbc #$40
  asl
  tax
  lda Alphabet, X
  sta graphics, Y
  iny
  inc tmp
  lda tmp
  and #%00001111
  cmp #%00001010
  bne DrawMonthTopLoop
    sty graphicsPointer
    rts

DrawMonthBottom:
  ldy graphicsPointer
  lda month
  asl
  asl
  asl
  asl
  sta tmp
DrawMonthBottomLoop:
  ldx tmp
  lda Months, X
  sec
  sbc #$40
  asl
  tax
  inx
  lda Alphabet, X
  sta graphics, Y
  iny
  inc tmp
  lda tmp
  and #%00001111
  cmp #%00001010
  bne DrawMonthBottomLoop
    sty graphicsPointer
    rts

DrawCalendarTypeTop:
  ldy graphicsPointer
  ldx #$06
  lda #$E1
DrawCalendarTypeTopLoop:
  sta graphics, Y
  iny
  dex
  bne DrawCalendarTypeTopLoop
    sty graphicsPointer
    rts

DrawCalendarTypeBottom:
  ldy graphicsPointer
  lda calendar
  asl
  asl
  asl
  tax
DrawCalendarTypeBottomLoop:
  lda CalendarTypes, X
  sta graphics, Y
  iny
  inx
  txa
  and #%00000111
  cmp #%00000110
  bne DrawCalendarTypeBottomLoop
    sty graphicsPointer
    rts

DrawYearTop:
  ldy graphicsPointer
  lda era
  cmp #ERA_AD
  bne DrawYearTopNotAD
    lda #$E1
    sta graphics, Y
    iny
DrawYearTopNotAD:
  ldx #$00
DrawYearTopBlankLoop:
  stx tmp
  lda year, X
  bne DrawYearTopLoop
    lda #$E1
    sta graphics, Y
    iny
    inx
    cpx #$06
    bne DrawYearTopBlankLoop
DrawYearTopLoop:
  ldx tmp
  lda year, X
  asl
  tax
  lda Numbers, X
  sta graphics, Y
  iny
  inc tmp
  lda tmp
  cmp #$06
  bne DrawYearTopLoop
    lda era
    cmp #ERA_BC
    bne DrawYearTopDone
      lda #$E1
      sta graphics, Y
      iny
DrawYearTopDone:
  sty graphicsPointer
  rts

DrawYearBottom:
  ldy graphicsPointer
  ldx #$00
DrawYearBottomBlankLoop:
  stx tmp
  lda year, X
  bne DrawYearBottomContinue
    lda #$E1
    sta graphics, Y
    iny
    inx
    cpx #$06
    bne DrawYearBottomBlankLoop
DrawYearBottomContinue:
  lda era
  cmp #ERA_AD
  bne DrawYearBottomLoop
    lda #$9A
    sta graphics, Y
    iny
DrawYearBottomLoop:
  ldx tmp
  lda year, X
  asl
  tax
  inx
  lda Numbers, X
  sta graphics, Y
  iny
  inc tmp
  lda tmp
  cmp #$06
  bne DrawYearBottomLoop
    lda era
    cmp #ERA_BC
    bne DrawYearBottomDone
      lda #$99
      sta graphics, Y
      iny
DrawYearBottomDone:
  sty graphicsPointer
  rts

DrawCalendarTop:
  ldy graphicsPointer
  lda #$00
  sta graphics, Y
  iny
  lda #$FE
  sta graphics, Y
  iny

  lda #$20
  sta graphics, Y
  iny
  lda #$85
  sta graphics, Y
  iny
  sty graphicsPointer

  jsr DrawMonthTop
  jsr DrawCalendarTypeTop
  jsr DrawYearTop

  ldy graphicsPointer
  lda #$00
  sta graphics, Y
  iny
  sta graphics, Y
  iny
  sty graphicsPointer

  jsr DrawMonthBottom
  jsr DrawCalendarTypeBottom
  jsr DrawYearBottom

  ldy graphicsPointer
  lda #$00
  sta graphics, Y
  iny
  lda #$FF
  sta graphics, Y
  iny
  sty graphicsPointer
  rts

InitializeDayDraw:
  lda #$20
  sta ppuAddr
  lda #$E3
  ;lda #$C3
  sta (ppuAddr + 1)
  lda #$00
  sta dayDraw
  lda #$01
  sec
  sbc dayOffset
  bpl InitializeDayDrawDone
    dec dayDraw
    clc
    adc #$0A
InitializeDayDrawDone:
  sta (dayDraw + 1)
  rts

DrawCalendarDaysRow:
  jsr IncPPUAddr1Row
  jsr IncPPUAddr1Row
  ;jsr IncPPUAddr1Row
  ldy graphicsPointer
  lda #$00
  sta graphics, Y
  iny
  lda #$FE
  sta graphics, Y
  iny
  lda ppuAddr
  sta graphics, Y
  iny
  lda (ppuAddr + 1)
  sta graphics, Y
  iny
  jsr DrawCalendarDaysRowTop
  dey
  lda #$00
  sta graphics, Y
  iny
  sta graphics, Y
  iny
  jsr DrawCalendarDaysRowBottom
  dey
  sty graphicsPointer
  rts

DrawCalendarDaysRowTop:
  lda #$00
  sta dayDrawOffset
DrawCalendarDaysRowTopDrawDaysLoop:
  jsr CheckMacrobiusOctober1582
  cpx #$01
  bne DrawCalendarDaysRowTopDrawDaysLoopNotMacrobius
    lda dayDraw
    bne DrawCalendarDaysRowTopDrawDaysLoopNotMacrobius
      lda (dayDraw + 1)
      cmp #$05
      bne DrawCalendarDaysRowTopDrawDaysLoopNotMacrobius
        lda #$01
        sta dayDraw
DrawCalendarDaysRowTopDrawDaysLoopNotMacrobius:
  lda dayDrawOffset
  cmp #$07
  beq DrawCalendarDaysRowTopDrawDaysDone
    lda #$E1
    sta graphics, Y
    iny
    lda dayDraw
    ora (dayDraw + 1)
    beq DrawCalendarDaysRowTopDrawDaysLoopIsOverflow
    lda month
    asl
    tax
    lda DaysPerMonthTable, X
    cmp dayDraw
    bcc DrawCalendarDaysRowTopDrawDaysLoopIsOverflow
      bne DrawCalendarDaysRowTopDrawDaysLoopNotOverflow
        inx
        lda DaysPerMonthTable, X
        cmp (dayDraw + 1)
        bcs DrawCalendarDaysRowTopDrawDaysLoopNotOverflow
          lda month
          cmp #MONTH_FEBRUARY
          bne DrawCalendarDaysRowTopDrawDaysLoopIsOverflow
            lda leapYear
            bne DrawCalendarDaysRowTopDrawDaysLoopNotOverflow
DrawCalendarDaysRowTopDrawDaysLoopIsOverflow:
  lda #$E1
  sta graphics, Y
  iny
  sta graphics, Y
  iny
  jmp DrawCalendarDaysRowTopDrawDaysLoopDayDone
DrawCalendarDaysRowTopDrawDaysLoopNotOverflow:
  lda dayDraw
  beq DrawCalendarDaysRowTopDrawDaysLoopUnder10
    asl
    tax
    lda Numbers, X
    sta graphics, Y
    iny
    jmp DrawCalendarDaysRowTopDrawDaysLoopContinue
DrawCalendarDaysRowTopDrawDaysLoopUnder10:
  lda #$E1
  sta graphics, Y
  iny
DrawCalendarDaysRowTopDrawDaysLoopContinue:
  lda (dayDraw + 1)
  asl
  tax
  lda Numbers, X
  sta graphics, Y
  iny
DrawCalendarDaysRowTopDrawDaysLoopDayDone:
  lda #$E2
  sta graphics, Y
  iny
  inc dayDrawOffset
  inc (dayDraw + 1)
  lda (dayDraw + 1)
  cmp #$0A
  beq DrawCalendarDaysRowTopDrawDaysIncDayDraw10s
    jmp DrawCalendarDaysRowTopDrawDaysLoop
DrawCalendarDaysRowTopDrawDaysIncDayDraw10s:
  inc dayDraw
  lda #$00
  sta (dayDraw + 1)
  jmp DrawCalendarDaysRowTopDrawDaysLoop
DrawCalendarDaysRowTopDrawDaysDone:
  rts

DrawCalendarDaysRowBottom:
  lda #$00
  sta dayDrawOffset
  lda (dayDraw + 1)
  sec
  sbc #$07
  sta (dayDraw + 1)
  bpl DrawCalendarDaysRowBottomDrawDaysLoop
    dec dayDraw
    clc
    adc #$0A
    sta (dayDraw + 1)
DrawCalendarDaysRowBottomDrawDaysLoop:
  jsr CheckMacrobiusOctober1582
  cpx #$01
  bne DrawCalendarDaysRowBottomDrawDaysLoopNotMacrobius
    lda dayDraw
    bne DrawCalendarDaysRowBottomDrawDaysLoopNotMacrobius05
      lda (dayDraw + 1)
      cmp #$05
      bne DrawCalendarDaysRowBottomDrawDaysLoopNotMacrobius
        lda #$01
        sta dayDraw
        jmp DrawCalendarDaysRowBottomDrawDaysLoopNotMacrobius
DrawCalendarDaysRowBottomDrawDaysLoopNotMacrobius05:
  lda (dayDraw + 1)
  bne DrawCalendarDaysRowBottomDrawDaysLoopNotMacrobius
    lda dayDraw
    cmp #$01
    bne DrawCalendarDaysRowBottomDrawDaysLoopNotMacrobius
      dec dayDraw
DrawCalendarDaysRowBottomDrawDaysLoopNotMacrobius:
  lda dayDrawOffset
  cmp #$07
  beq DrawCalendarDaysRowBottomDrawDaysDone
    lda #$E1
    sta graphics, Y
    iny
    lda dayDraw
    ora (dayDraw + 1)
    beq DrawCalendarDaysRowBottomDrawDaysLoopIsOverflow
    lda month
    asl
    tax
    lda DaysPerMonthTable, X
    cmp dayDraw
    bcc DrawCalendarDaysRowBottomDrawDaysLoopIsOverflow
      bne DrawCalendarDaysRowBottomDrawDaysLoopNotOverflow
        inx
        lda DaysPerMonthTable, X
        cmp (dayDraw + 1)
        bcs DrawCalendarDaysRowBottomDrawDaysLoopNotOverflow
          lda month
          cmp #MONTH_FEBRUARY
          bne DrawCalendarDaysRowBottomDrawDaysLoopIsOverflow
            lda leapYear
            bne DrawCalendarDaysRowBottomDrawDaysLoopNotOverflow
DrawCalendarDaysRowBottomDrawDaysLoopIsOverflow:
  lda #$E1
  sta graphics, Y
  iny
  sta graphics, Y
  iny
  jmp DrawCalendarDaysRowBottomDrawDaysLoopDayDone
DrawCalendarDaysRowBottomDrawDaysLoopNotOverflow:
  lda dayDraw
  beq DrawCalendarDaysRowBottomDrawDaysLoopUnder10
    asl
    tax
    inx
    lda Numbers, X
    sta graphics, Y
    iny
    jmp DrawCalendarDaysRowBottomDrawDaysLoopContinue
DrawCalendarDaysRowBottomDrawDaysLoopUnder10:
  lda #$E1
  sta graphics, Y
  iny
DrawCalendarDaysRowBottomDrawDaysLoopContinue:
  lda (dayDraw + 1)
  asl
  tax
  inx
  lda Numbers, X
  sta graphics, Y
  iny
DrawCalendarDaysRowBottomDrawDaysLoopDayDone:
  lda #$E2
  sta graphics, Y
  iny
  inc dayDrawOffset
  inc (dayDraw + 1)
  lda (dayDraw + 1)
  cmp #$0A
  beq DrawCalendarDaysRowBottomDrawDaysIncDayDraw10s
    jmp DrawCalendarDaysRowBottomDrawDaysLoop
DrawCalendarDaysRowBottomDrawDaysIncDayDraw10s:
  inc dayDraw
  lda #$00
  sta (dayDraw + 1)
  jmp DrawCalendarDaysRowBottomDrawDaysLoop
DrawCalendarDaysRowBottomDrawDaysDone:
  rts

DrawCalendar:
  lda #$00
  sta needDraw

  jsr CalculateCalendar

  lda #$00
  sta needDraw
  jsr DrawCalendarTop
  lda #$01
  sta needDraw

  jsr WaitForNewFrame
  jsr DrawDaysNormal
  rts

DrawDaysNormal:
  lda #$01
  sta updateDisabled

  lda #$00
  sta needDraw
  jsr HandleParkerRedLetterDays
  lda #$00
  jsr DrawRedLetterAttr
  lda #$01
  sta needDraw
  jsr WaitForNewFrame

  lda #$00
  sta needDraw
  jsr InitializeDayDraw
  jsr DrawCalendarDaysRow
  lda #$01
  sta needDraw
  jsr WaitForNewFrame

  lda #$00
  sta needDraw
  jsr DrawCalendarDaysRow
  lda #$01
  sta needDraw
  jsr WaitForNewFrame

  lda #$00
  sta needDraw
  jsr DrawCalendarDaysRow
  lda #$01
  sta needDraw
  jsr WaitForNewFrame

  lda #$00
  sta needDraw
  jsr DrawCalendarDaysRow
  lda #$01
  sta needDraw
  jsr WaitForNewFrame

  lda #$00
  sta needDraw
  jsr DrawCalendarDaysRow
  lda #$01
  sta needDraw
  jsr WaitForNewFrame

  lda #$00
  sta needDraw
  jsr DrawCalendarDaysRow
  lda #$01
  sta needDraw
  jsr WaitForNewFrame

  lda #$00
  sta updateDisabled
  rts

CalculateCalendar:
  jsr YearToYearEquivalent
  jsr SetCalendarTypeTmp
  lda #$00
  sta dayOffset
  jsr ParkerEraBCYearDec
  jsr IsLeapYear
  jsr IsLeapYearGregorian
  jsr GetGregorianCenturyOffset
  jsr GetJulianCenturyOffset
  jsr DetermineIfMacrobiusError
  jsr HandleParkerA
  jsr HandleParkerB_C
  jsr ParkerEraBCYearInc
  jsr GetMonthOffset
  lda #$00
  tax
  sta tmp
  sta (tmp + 1)
  jsr CompareTmpToYear
  jsr TmpDiv4
  clc
  adc dayOffset
  sta dayOffset
  jsr ModifyMonthsLeapYearOffset
  jsr DayOffsetMod7
  rts

CalendarTiles:
  .incbin "graphics/calendar.nam"

PaletteValues:
  .incbin "graphics/palettes.pal"
