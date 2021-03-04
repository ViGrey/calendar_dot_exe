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

RESET:
  sei
  cld
  ldx #$40
  stx APU_FRAME_COUNTER
  ldx #$FF
  txs
  inx
  lda #%00000110
  sta PPU_MASK
  lda #%00000000
  sta PPU_CTRL
  stx $4010
  ldy #$00

VBlankWait:
  ldx #$02
VBlankWaitLoop:
  lda PPU_STATUS
  bpl VBlankWaitLoop
    dex
    bne VBlankWaitLoop

InitializeCPURAM:
  ldx #$00
InitializeCPURAMLoop:
  lda #$00
  sta $0000, X
  sta $0100, X
  sta $0300, X
  sta $0400, X
  sta $0500, X
  sta $0600, X
  sta $0700, X
  inx
  bne InitializeCPURAMLoop
    lda #$00
    sta year
    lda #$00
    sta (year + 1)
    lda #$02
    sta (year + 2)
    lda #$00
    sta (year + 3)
    lda #$02
    sta (year + 4)
    lda #$01
    sta (year + 5)
    lda #ERA_AD
    sta era
    lda #MONTH_JANUARY
    sta month
    lda #CALENDAR_GREGORIAN
    sta calendar
    jsr ResetScroll
    jsr DrawStartScreen

Forever:
  jmp Forever

  .pad $C100, $FF

NMI:
  pha
  txa
  pha
  tya
  pha
  lda #$00
  sta PPU_OAM_ADDR
  lda #$02
  sta OAM_DMA
  inc frames
  lda needDraw
  beq NMISkipDraw
    lda PPU_STATUS
    jsr Draw
    jsr UpdateDone
    jsr ReadThenResetGraphics
    jsr ResetScroll
    lda updateDisabled
    bne NMIDone
      jsr Update
NMISkipDraw:
NMIDone:
  pla
  tay
  pla
  tax
  pla
  rti

Update:
  jsr UpdateController
  rts

.include "frames.asm"
.include "draw.asm"
.include "graphics.asm"
.include "start.asm"
.include "leap-year.asm"
.include "math.asm"
.include "alphanum.asm"
.include "months.asm"
.include "calendars.asm"
.include "year.asm"
.include "date-tables.asm"
.include "gregorian.asm"
.include "julian.asm"
.include "macrobius.asm"
.include "parker.asm"
.include "parkera.asm"
.include "days.asm"
.include "controllers.asm"
.include "redletter.asm"
