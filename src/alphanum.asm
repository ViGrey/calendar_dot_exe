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

Numbers:
  .byte $80, $90 ; 0
  .byte $81, $91 ; 1
  .byte $82, $92 ; 2
  .byte $82, $93 ; 3
  .byte $83, $94 ; 4
  .byte $84, $95 ; 5
  .byte $85, $96 ; 6
  .byte $86, $91 ; 7
  .byte $87, $97 ; 8
  .byte $87, $98 ; 9

Alphabet:
  .byte $E1, $E1; Blank
  .byte $A0, $B0; A
  .byte $A1, $B1; B
  .byte $A2, $B2; C
  .byte $A3, $B3; D
  .byte $84, $92; E
  .byte $84, $B4; F
  .byte $A2, $B5; G
  .byte $83, $B0; H
  .byte $A4, $B6; I
  .byte $A5, $B7; J
  .byte $A6, $B8; K
  .byte $A7, $B9; L
  .byte $A8, $BA; M
  .byte $A9, $BB; N
  .byte $80, $90; O
  .byte $A1, $B4; P
  .byte $80, $BC; Q
  .byte $A1, $B8; R
  .byte $85, $98; S
  .byte $A4, $BD; T
  .byte $83, $90; U
  .byte $83, $BE; V
  .byte $AA, $BF; W
  .byte $AB, $AD; X
  .byte $83, $AE; Y
  .byte $AC, $AF; Z
  .byte $E1, $5F; [

NumbersPrint:
  .byte $0A, $01
  .byte $0A, $02
  .byte $0A, $03
  .byte $0A, $04
  .byte $0A, $05
  .byte $0A, $06
  .byte $0A, $07
  .byte $0A, $08
  .byte $0A, $09
  .byte $01, $00
  .byte $01, $01
  .byte $01, $02
  .byte $01, $03
  .byte $01, $04
  .byte $01, $05
  .byte $01, $06
  .byte $01, $07
  .byte $01, $08
  .byte $01, $09
  .byte $02, $00
  .byte $02, $01
  .byte $02, $02
  .byte $02, $03
  .byte $02, $04
  .byte $02, $05
  .byte $02, $06
  .byte $02, $07
  .byte $02, $08
  .byte $02, $09
  .byte $03, $00
  .byte $03, $01
