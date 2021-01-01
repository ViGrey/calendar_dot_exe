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

; Assumes X is in correct rightmost offset.
; Sets A to 0 if not divisible by 4 else 1.
; Sets mod to 
YearDiv4Check:
  lda yearEquivalent, X
  tay
  sta tmp
  dex
  lda yearEquivalent, X
  and #%00000001
  beq YearDiv4CheckContinue
    iny
    iny
YearDiv4CheckContinue:
  tya
  and #%00000011
  beq YearDiv4CheckDone
    sta mod
    lda #$00
    rts
YearDiv4CheckDone:
  sta mod
  lda #$01
  rts

TmpDiv4:
  ldy tmp
  lda #$00
TmpDiv410sLoop:
  dey
  bmi TmpDiv410sLoopDone
    clc
    adc #$0A
TmpDiv410sLoopDone:
  adc (tmp + 1)
  and #%11111100
  lsr
  lsr
  rts

IncAddr:
  lda addr
  clc
  adc #$01
  sta addr
  lda (addr + 1)
  adc #$00
  sta (addr + 1)
  rts

IncPPUAddr:
  lda (ppuAddr + 1)
  clc
  adc #$01
  sta (ppuAddr + 1)
  lda ppuAddr
  adc #$00
  sta ppuAddr
  rts

IncPPUAddr1Row:
  lda (ppuAddr + 1)
  clc
  adc #$20
  sta (ppuAddr + 1)
  lda ppuAddr
  adc #$00
  sta ppuAddr
  rts

DecPPUAddr:
  lda (ppuAddr + 1)
  sec
  sbc #$01
  sta (ppuAddr + 1)
  lda ppuAddr
  sbc #$00
  sta ppuAddr
  rts

DecPPUAddr1Row:
  lda (ppuAddr + 1)
  sec
  sbc #$20
  sta (ppuAddr + 1)
  lda ppuAddr
  sbc #$00
  sta ppuAddr
  rts

DecTmp04:
  lda (tmp + 1)
  sec
  sbc #$04
  bpl DecTmp04Done
    dec tmp
    clc
    adc #$0A
DecTmp04Done:
  sta (tmp + 1)
  rts

DecTmp03:
  lda (tmp + 1)
  sec
  sbc #$03
  bpl DecTmp03Done
    dec tmp
    clc
    adc #$0A
DecTmp03Done:
  sta (tmp + 1)
  rts

IncTmp03:
  lda (tmp + 1)
  clc
  adc #$03
  cmp #$0A
  bcc IncTmp03Done
    inc tmp
    sec
    sbc #$0A
IncTmp03Done:
  sta (tmp + 1)
  rts

TmpAdd12:
  lda (tmp + 1)
  clc
  adc #$02
  cmp #$0A
  bcc TmpAdd12NotCarry
    sec
    sbc #$0A
TmpAdd12NotCarry:
  sta (tmp + 1)
  lda tmp
  adc #$01
  sta tmp
  rts

TmpDec12:
  lda (tmp + 1)
  sec
  sbc #$02
  bcs TmpDec12NotCarry
    adc #$0A
    clc
TmpDec12NotCarry:
  sta (tmp + 1)
  lda tmp
  sbc #$01
  sta tmp
  rts
