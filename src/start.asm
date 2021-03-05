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

StartMenuCopyright:
  .byte $9D, " 2020-2021 VI GREY"

StartMenuPressStart:
  .byte "PRESS [START] TO START"

StartMenuTitle:
  .byte "CALENDAR[DOT[EXE"

StartMenuVersion:
  .byte "            v0.0.3"

StartMenuTitleBoxTop:
  .byte $C0, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C3, $00, $00
  .byte $E0, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E3

StartMenuTitleBoxMiddle:
  .byte $E0, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E3, $00, $00
  .byte $E0, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E3

StartMenuTitleBoxBottom:
  .byte $E0, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E3, $00, $00
  .byte $F0, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F3

StartMenuCalendar:
  .byte "GREGORIAN       "
  .byte "@JULIAN@@       "
  .byte "@@ROMAN@@       "
  .byte "PARKER@A@       "
  .byte "PARKER@B@       "
  .byte "PARKER@C@       "

StartMenuEra:
  .byte "BC"
  .byte "AD"

StartMenuMonths:
  .byte "JAN "
  .byte "FEB "
  .byte "MAR "
  .byte "APR "
  .byte "MAY "
  .byte "JUN "
  .byte "JUL "
  .byte "AUG "
  .byte "SEP "
  .byte "OCT "
  .byte "NOV "
  .byte "DEC "

CursorOffsets:
  .byte $2C, $44, $4C, $54, $5C, $64, $6C, $80, $B4

SetStartMenuPalette:
  lda PPU_STATUS
  lda #$3F
  sta PPU_ADDR
  lda #$00
  sta PPU_ADDR
  ldx #$08
  lda kcode
  bmi SetStartMenuPaletteKCodeActivated
    ldy #$30
    lda #$0F
    jmp SetStartMenuPaletteLoop
SetStartMenuPaletteKCodeActivated:
  ldy #$0F
  lda #$30
SetStartMenuPaletteLoop:
  sta PPU_DATA
  sta PPU_DATA
  sta PPU_DATA
  sty PPU_DATA
  dex
  bne SetStartMenuPaletteLoop
    rts

SetKCodePalette:
  ldy graphicsPointer
  lda #$00
  sta graphics, Y
  iny
  lda #$FE
  sta graphics, Y
  iny
  lda #$3F 
  sta graphics, Y
  iny
  lda #$00
  sta graphics, Y
  iny
  ldx #$08
SetKCodePaletteLoop:
  lda #$30
  sta graphics, Y
  iny
  sta graphics, Y
  iny
  sta graphics, Y
  iny
  lda #$0F
  sta graphics, Y
  iny
  dex
  bne SetKCodePaletteLoop
    sty graphicsPointer
    rts

DrawStartScreen:
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
  lda #SCREEN_START
  sta screen
  jsr ClearSprites
  jsr ClearPPURAM
  jsr SetStartMenuPalette
  jsr UpdateDone
  jsr ReadThenResetGraphics
  jsr DrawCopyright
  jsr UpdateDone
  jsr ReadThenResetGraphics
  jsr DrawPressStart
  jsr UpdateDone
  jsr ReadThenResetGraphics
  jsr DrawTitleBoxTop
  jsr UpdateDone
  jsr ReadThenResetGraphics
  jsr DrawTitleBoxMiddle
  jsr UpdateDone
  jsr ReadThenResetGraphics
  jsr DrawTitleBoxBottom
  jsr UpdateDone
  jsr ReadThenResetGraphics
  jsr DrawTitle
  jsr UpdateDone
  jsr ReadThenResetGraphics
  jsr DrawVersion
  jsr UpdateDone
  jsr ReadThenResetGraphics
  lda #$00
  sta cursorOffset
  jsr DrawCursor
  jsr ResetScroll
  jsr DrawStart
  lda #$00
  sta updateDisabled
  rts

BlackPalette:
  ldy graphicsPointer
  lda #$00
  sta graphics, Y
  iny
  lda #$FE
  sta graphics, Y
  iny
  lda #$3F 
  sta graphics, Y
  iny
  lda #$00
  sta graphics, Y
  iny
  ldx #$20
  lda #$0F
BlackPaletteLoop:
  sta graphics, Y
  iny
  dex
  bne BlackPaletteLoop
    sty graphicsPointer
    rts

DrawStart:
  lda #$01
  sta updateDisabled
  lda #$00
  sta needDraw
  ldy graphicsPointer
  lda #$00
  sta graphics, Y
  iny
  lda #$FE
  sta graphics, Y
  iny
  lda #$21
  sta graphics, Y
  iny
  lda #$C5
  sta graphics, Y
  iny
  jsr DrawStartTop
  lda #$00
  sta graphics, Y
  iny
  sta graphics, Y
  iny
  jsr DrawStartBottom
  sty graphicsPointer
  lda #$01
  sta needDraw
  jsr WaitForNewFrame
  lda #$00
  sta updateDisabled
  rts

DrawStartTop:
  lda month
  asl
  asl
  sta tmp
DrawStartTopMonthLoop:
  ldx tmp
  lda StartMenuMonths, X
  sec
  sbc #$40
  asl
  tax
  lda Alphabet, X
  sta graphics, Y
  iny
  inc tmp
  lda tmp
  and #%00000011
  cmp #%00000011
  bne DrawStartTopMonthLoop
    lda #$E1
    sta graphics, Y
    iny
    lda #$00
    sta tmp
DrawStartTopYearLoop:
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
  bne DrawStartTopYearLoop
    lda #$E1
    sta graphics, Y
    iny
    lda era
    asl
    sta tmp
DrawStartTopEraLoop:
  ldx tmp
  lda StartMenuEra, X
  sec
  sbc #$40
  asl
  tax
  lda Alphabet, X
  sta graphics, Y
  iny
  inc tmp
  lda tmp
  and #%00000001
  cmp #%00000000
  bne DrawStartTopEraLoop
    lda #$E1
    sta graphics, Y
    iny
    lda calendar
    asl
    asl
    asl
    asl
    sta tmp
DrawStartTopCalendarTypeLoop:
  ldx tmp
  lda StartMenuCalendar, X
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
  cmp #%00001001
  bne DrawStartTopCalendarTypeLoop
    rts

DrawStartBottom:
  lda month
  asl
  asl
  sta tmp
DrawStartBottomMonthLoop:
  ldx tmp
  lda StartMenuMonths, X
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
  and #%00000011
  cmp #%00000011
  bne DrawStartBottomMonthLoop
    lda #$E1
    sta graphics, Y
    iny
    lda #$00
    sta tmp
DrawStartBottomYearLoop:
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
  bne DrawStartBottomYearLoop
    lda #$E1
    sta graphics, Y
    iny
    lda era
    asl
    sta tmp
DrawStartBottomEraLoop:
  ldx tmp
  lda StartMenuEra, X
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
  and #%00000001
  cmp #%00000000
  bne DrawStartBottomEraLoop
    lda #$E1
    sta graphics, Y
    iny
    lda calendar
    asl
    asl
    asl
    asl
    sta tmp
DrawStartBottomCalendarTypeLoop:
  ldx tmp
  lda StartMenuCalendar, X
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
  cmp #%00001001
  bne DrawStartBottomCalendarTypeLoop
    rts

DrawCursor:
  lda frames
  and #%00011100
  lsr
  lsr
  tax
  lda CursorTopYValues, X
  sta $200
  lda CursorBottomYValues, X
  sta $204
  lda #$01
  sta $201
  sta $205
  lda #$00
  sta $202
  lda #%10000000 
  sta $206
  ldx cursorOffset
  lda CursorOffsets, X
  sta $203
  sta $207
  rts

DrawVersion:
  ldy graphicsPointer
  lda #$00
  tax
  sta graphics, Y
  iny
  lda #$FE
  sta graphics, Y
  iny
  lda #$21
  sta graphics, Y
  iny
  lda #$47
  sta graphics, Y
  iny
DrawVersionLoop:
  lda StartMenuVersion, X
  sta graphics, Y
  iny
  inx
  cpx #18
  bne DrawVersionLoop
    sty graphicsPointer
    rts

DrawCopyright:
  ldy graphicsPointer
  lda #$00
  tax
  sta graphics, Y
  iny
  lda #$FE
  sta graphics, Y
  iny
  lda #$23
  sta graphics, Y
  iny
  lda #$4A
  sta graphics, Y
  iny
DrawCopyrightLoop:
  lda StartMenuCopyright, X
  sta graphics, Y
  iny
  inx
  cpx #19
  bne DrawCopyrightLoop
    sty graphicsPointer
    rts

DrawPressStart:
  ldy graphicsPointer
  lda #$00
  tax
  sta graphics, Y
  iny
  lda #$FE
  sta graphics, Y
  iny
  lda #$22
  sta graphics, Y
  iny
  lda #$85
  sta graphics, Y
  iny
DrawPressStartLoop:
  lda StartMenuPressStart, X
  sta graphics, Y
  iny
  inx
  cpx #22
  bne DrawPressStartLoop
    sty graphicsPointer
    rts

DrawTitle:
  ldy graphicsPointer
  lda #$00
  sta graphics, Y
  iny
  sta tmp
  lda #$FE
  sta graphics, Y
  iny
  lda #$20
  sta graphics, Y
  iny
  lda #$C8
  sta graphics, Y
  iny
DrawTitleTopLoop:
  ldx tmp
  lda StartMenuTitle, X
  sec
  sbc #$40
  asl
  tax
  lda Alphabet, X
  sta graphics, Y
  iny
  inc tmp
  lda tmp
  cmp #$10
  bne DrawTitleTopLoop
    lda #$00
    sta tmp
    sta graphics, Y
    iny
    sta graphics, Y
    iny
DrawTitleBottomLoop:
  ldx tmp
  lda StartMenuTitle, X
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
  cmp #$10
  bne DrawTitleBottomLoop
    sty graphicsPointer
    rts

DrawTitleBoxTop:
  ldy graphicsPointer
  lda #$00
  tax
  sta graphics, Y
  iny
  lda #$FE
  sta graphics, Y
  iny
  lda #$20
  sta graphics, Y
  iny
  lda #$86
  sta graphics, Y
  iny
DrawTitleBoxTopLoop:
  lda StartMenuTitleBoxTop, X
  sta graphics, Y
  iny
  inx
  cpx #42
  bne DrawTitleBoxTopLoop
    sty graphicsPointer
    rts

DrawTitleBoxMiddle:
  ldy graphicsPointer
  lda #$00
  tax
  sta graphics, Y
  iny
  lda #$FE
  sta graphics, Y
  iny
  lda #$20
  sta graphics, Y
  iny
  lda #$C6
  sta graphics, Y
  iny
DrawTitleBoxMiddleLoop:
  lda StartMenuTitleBoxMiddle, X
  sta graphics, Y
  iny
  inx
  cpx #42
  bne DrawTitleBoxMiddleLoop
    sty graphicsPointer
    rts

DrawTitleBoxBottom:
  ldy graphicsPointer
  lda #$00
  tax
  sta graphics, Y
  iny
  lda #$FE
  sta graphics, Y
  iny
  lda #$21
  sta graphics, Y
  iny
  lda #$06
  sta graphics, Y
  iny
DrawTitleBoxBottomLoop:
  lda StartMenuTitleBoxBottom, X
  sta graphics, Y
  iny
  inx
  cpx #42
  bne DrawTitleBoxBottomLoop
    sty graphicsPointer
    rts

CursorTopYValues:
  .byte $65, $64, $63, $64, $65, $66, $67, $66

CursorBottomYValues:
  .byte $82, $83, $84, $83, $82, $81, $80, $81
