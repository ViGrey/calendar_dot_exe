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

CONTROL_MODE_FLAG = 1 << 7

SetPalettes:
  lda #<(PaletteValues)
  sta addr
  lda #>(PaletteValues)
  sta (addr + 1)
  ldx graphicsPointer
  lda #$00
  sta graphics, X
  inx
  lda #$FE
  sta graphics, X
  inx
  lda #$3F
  sta graphics, X
  inx
  lda #$00
  sta graphics, X
  inx
  ldy #$00
SetPalettesLoop:
  lda (addr), Y
  sta graphics, X
  inx
  iny
  cpy #$20
  bne SetPalettesLoop
    stx graphicsPointer
    rts

DrawCalendarSkeleton:
  lda #<(CalendarTiles)
  sta addr
  lda #>(CalendarTiles)
  sta (addr + 1)
  ldy #$00
  ldx #$04
  lda PPU_STATUS
  lda #$20
  sta PPU_ADDR
  lda #$00
  sta PPU_ADDR
DrawCalendarSkeletonLoop:
  lda (addr), Y
  sta PPU_DATA
  iny
  bne DrawCalendarSkeletonLoop
    inc (addr + 1)
    dex
    bne DrawCalendarSkeletonLoop
      rts

ResetGraphics:
  ldx #$00
  stx graphics
  stx graphicsPointer
  stx graphicsControlFlags
  lda #$FF
  inx
  sta graphics, X
  inx
  sta graphics, X
  rts

PPUAddrIncLine:
  lda (ppuAddr + 1)
  clc
  adc #$20
  sta (ppuAddr + 1)
  lda ppuAddr
  adc #$00
  sta ppuAddr
  rts

ReadGraphics:
  lda PPU_STATUS
  lda #$20
  ldx #$00
  sta PPU_ADDR
  stx PPU_ADDR
ReadGraphicsLoop:
  lda graphics, X
  beq ReadGraphicsControlByte
    cmp #$F8
    beq ReadGraphicsHandleAA
      sta PPU_DATA
      inx
      stx graphicsPointer
      jmp ReadGraphicsLoop
ReadGraphicsHandleAA:
  lda #$00
  sta PPU_DATA
  inx
  stx graphicsPointer
ReadGraphicsControlByte:
  inx
  lda graphics, X
  bne ReadGraphicsControlByteNot00
    jsr ReadGraphicsControl00Handle
    jmp ReadGraphicsLoop
ReadGraphicsControlByteNot00:
  cmp #$80
  bne ReadGraphicsControlByteNot80
    jsr ReadGraphicsControl80Handle
    jmp ReadGraphicsLoop
ReadGraphicsControlByteNot80:
  cmp #$FE
  bne ReadGraphicsControlByteNotFE
    jsr ReadGraphicsControlFEHandle
    jmp ReadGraphicsLoop
ReadGraphicsControlByteNotFE:
  cmp #$FF
  bne ReadGraphicsControlByteNotFF
    lda ppuAddr
    sta ppuAddrLast
    lda (ppuAddr + 1)
    sta (ppuAddrLast + 1)
    rts
ReadGraphicsControlByteNotFF:
ReadGraphicsControlByteInvalid:
  jmp ReadGraphicsLoop

; New Line Handle
ReadGraphicsControl00Handle:
  jsr PPUAddrIncLine
  lda PPU_STATUS
  lda ppuAddr
  sta PPU_ADDR
  lda (ppuAddr + 1)
  sta PPU_ADDR
  inx
  stx graphicsPointer
  rts

; Literal Byte Handle
ReadGraphicsControl80Handle:
  inx
  lda graphics, X
  sta PPU_DATA
  inx
  stx graphicsPointer
  rts

; End GraphicsSectionHandle
ReadGraphicsControlFEHandle:
  lda PPU_STATUS
  inx
  lda graphics, X
  sta ppuAddr
  sta PPU_ADDR
  inx
  lda graphics, X
  sta ppuAddr + 1
  sta PPU_ADDR
  inx
  stx graphicsPointer
  rts

SetPPUAddrInGraphicsBuffer:
  ldx graphicsPointer
  lda #$00
  sta graphics, X
  inx
  lda #$FE
  sta graphics, X
  inx
  lda ppuAddrLast
  sta graphics, X
  inx
  lda (ppuAddrLast + 1)
  sta graphics, X
  inx
  stx graphicsPointer
  rts

DecPPUAddr1Line:
  lda (ppuAddr + 1)
  sec
  sbc #$20
  sta (ppuAddr + 1)
  lda ppuAddr
  sbc #$00
  sta ppuAddr
  rts

ReadThenResetGraphics:
  jsr ReadGraphics
  jsr ResetGraphics
  rts

UpdateDone:
  ldx graphicsPointer
  lda #$00
  sta graphics, X
  inx
  lda #$FF
  sta graphics, X
  inx
  stx graphicsPointer
  rts
