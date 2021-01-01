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

ResetScroll:
  lda #$04
  sta PPU_SCROLL
  lda #$00
  sta PPU_SCROLL
  jsr EnableNMI
  rts

Draw:
  lda #%00011110
  sta PPU_MASK
  rts

DisableNMI:
  lda #$00
  sta PPU_CTRL
  rts

EnableNMI:
  lda #%10001000
  sta PPU_CTRL
  rts

Blank:
  lda #%00000110
  sta PPU_MASK
  jsr DisableNMI
  rts

ClearPPURAM:
  lda #$20
  sta PPU_ADDR
  lda #$00
  sta PPU_ADDR
  ldy #$10
  ldx #$00
  txa
ClearPPURAMLoop:
  sta PPU_DATA
  dex
  bne ClearPPURAMLoop
    ldx #$00
    dey
    bne ClearPPURAMLoop
      rts

ClearSprites:
  ldx #$00
  lda #$FE
ClearSpritesLoop:
  sta $200, X
  inx
  bne ClearSpritesLoop
    rts
