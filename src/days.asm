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

DrawDays:
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
DrawDaysLoop:
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
  cpx #MONTH_FEBRUARY
  bne DrawDaysNotFeb
    lda leapYear
    beq DrawDaysNotFeb
      lda #29
      jmp DrawDaysFebCheckDone
DrawDaysNotFeb:
  lda DaysPerMonthTable, X
DrawDaysFebCheckDone:
  cmp tmp
  beq DrawDaysDone
    pla
    tax
    iny
    cpy #$07
    bne DrawDaysLoop
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
      jmp DrawDaysLoop
DrawDaysDone:
  pla
  rts

DrawDayDigits:
  lda PPU_STATUS
  lda ppuAddr
  sta PPU_ADDR
  lda (ppuAddr + 1)
  sta PPU_ADDR
  lda tmp
  asl
  tax
  lda Numbers, X
  sta PPU_DATA
  jsr IncPPUAddr1Row
  lda PPU_STATUS
  lda ppuAddr
  sta PPU_ADDR
  lda (ppuAddr + 1)
  sta PPU_ADDR
  inx
  lda Numbers, X
  sta PPU_DATA
  jsr DecPPUAddr1Row
  jsr IncPPUAddr
  lda PPU_STATUS
  lda ppuAddr
  sta PPU_ADDR
  lda (ppuAddr + 1)
  sta PPU_ADDR
  lda (tmp + 1)
  asl
  tax
  lda Numbers, X
  sta PPU_DATA
  jsr IncPPUAddr1Row
  lda PPU_STATUS
  lda ppuAddr
  sta PPU_ADDR
  lda (ppuAddr + 1)
  sta PPU_ADDR
  inx
  lda Numbers, X
  sta PPU_DATA
  jsr DecPPUAddr1Row
  jsr DecPPUAddr
  rts

AddTmpToDayOffset:
  ldy tmp
  lda (tmp + 1)
  clc
  adc dayOffset
AddTmpToDayOffsetLoop:
  dey
  bmi AddTmpToDayOffsetDone
    adc #$0A
AddTmpToDayOffsetDone:
  sta dayOffset
  rts

DayOffsetMod7:
  lda dayOffset
  sec
DayOffsetMod7Loop:
  sbc #$07
  bcs DayOffsetMod7Loop
    adc #$07
    sta dayOffset
    rts
