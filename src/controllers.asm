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

PollController:
  lda #$01
  sta CONTROLLER_1
  lda #$00
  sta CONTROLLER_1
  ldx #$08
PollControllerLoop:
  lda CONTROLLER_1
  lsr
  rol controller
  dex
  bne PollControllerLoop
    rts

UpdateController:
  lda controller
  sta controllerLastFrame
  jsr PollController
  lda screen
  cmp #SCREEN_START
  bne UpdateControllersCalendar
    jsr DrawCursor
    jsr CheckLeftStart
    jsr CheckRightStart
    jsr CheckUpStart
    jsr CheckDownStart
    jsr CheckStartStart
    rts
UpdateControllersCalendar:
  jsr CheckLeft
  jsr CheckRight
  jsr CheckUp
  jsr CheckDown
  jsr CheckStart
  rts

CheckStartStart:
  lda controller
  and #(BUTTON_START + BUTTON_A)
  beq CheckStartStartDone
    lda controllerLastFrame
    and #(BUTTON_START + BUTTON_A)
    bne CheckStartStartDone
      jsr DrawCalendarScreen
CheckStartStartDone:
  rts

CheckLeftStart:
  lda controller
  cmp #BUTTON_LEFT
  bne CheckLeftStartDone
    lda controllerLastFrame
    and #BUTTON_LEFT
    bne CheckLeftStartDone
      dec cursorOffset
      bpl CheckLeftStartContinue
        lda #$08
        sta cursorOffset
CheckLeftStartContinue:
  jsr DrawCursor
CheckLeftStartDone:
  rts

CheckRightStart:
  lda controller
  cmp #BUTTON_RIGHT
  bne CheckRightStartDone
    lda controllerLastFrame
    and #BUTTON_RIGHT
    bne CheckRightStartDone
      inc cursorOffset
      lda cursorOffset
      cmp #$09
      bcc CheckRightStartContinue
        lda #$00
        sta cursorOffset
CheckRightStartContinue:
  jsr DrawCursor
CheckRightStartDone:
  rts

CheckUpStart:
  lda controller
  cmp #BUTTON_UP
  bne CheckUpStartDone
    lda controllerLastFrame
    and #BUTTON_UP
    bne CheckUpStartDone
      ldx cursorOffset
      bne CheckUpStartNotMonth
        inc month
        lda month
        cmp #12
        bne CheckUpStartContinue
          lda #$00
          sta month
          jmp CheckUpStartContinue
CheckUpStartNotMonth:
  cpx #$07
  bcs CheckUpStartNotYear
    dex
    inc year, X
    lda year, X
    cmp #$0A
    bne CheckUpStartContinue
      lda #$00
      sta year, X
      lda year
      ora (year + 1)
      ora (year + 2)
      ora (year + 3)
      ora (year + 4)
      ora (year + 5)
      bne CheckUpStartContinue
        lda #$01
        sta (year + 5)
        jmp CheckUpStartContinue
CheckUpStartNotYear:
  bne CheckUpStartNotEra
    lda era
    eor #%00000001
    sta era
    jmp CheckUpStartContinue
CheckUpStartNotEra:
  dec calendar
  bpl CheckUpStartContinue
    lda #CALENDAR_ROMAN
    sta calendar
CheckUpStartContinue:
  jsr DrawStart
CheckUpStartDone:
  rts

CheckDownStart:
  lda controller
  cmp #BUTTON_DOWN
  bne CheckDownStartDone
    lda controllerLastFrame
    and #BUTTON_DOWN
    bne CheckDownStartDone
      ldx cursorOffset
      bne CheckDownStartNotMonth
        dec month
        bpl CheckDownStartContinue
          lda #11
          sta month
          jmp CheckDownStartContinue
CheckDownStartNotMonth:
  cpx #$07
  bcs CheckDownStartNotYear
    dex
    dec year, X
    lda year
    ora (year + 1)
    ora (year + 2)
    ora (year + 3)
    ora (year + 4)
    ora (year + 5)
    bne CheckDownStartYearContinue
      lda #$09
      sta (year + 5)
CheckDownStartYearContinue:
  lda year, X
  bpl CheckDownStartContinue
    lda #$09
    sta year, X
    jmp CheckDownStartContinue
CheckDownStartNotYear:
  bne CheckDownStartNotEra
    lda era
    eor #%00000001
    sta era
    jmp CheckDownStartContinue
CheckDownStartNotEra:
  inc calendar
  lda calendar
  cmp #$03
  bne CheckDownStartContinue
    lda #CALENDAR_GREGORIAN
    sta calendar
CheckDownStartContinue:
  jsr DrawStart
CheckDownStartDone:
  rts

CheckLeft:
  lda controller
  cmp #BUTTON_LEFT
  bne CheckLeftDone
    lda controllerLastFrame
    and #BUTTON_LEFT
    bne CheckLeftDone
      lda era
      cmp #ERA_BC
      bne CheckLeftNotBC
        jsr CheckMinYearMonthBC
        cpx #$01
        beq CheckLeftDone
CheckLeftNotBC:
  dec month
  lda month
  bpl CheckLeftMonthNotUnderflow
    jsr HandleDecYear
    lda #MONTH_DECEMBER
    sta month
CheckLeftMonthNotUnderflow:
  jsr DrawCalendar
CheckLeftDone:
  rts

CheckRight:
  lda controller
  cmp #BUTTON_RIGHT
  bne CheckRightDone
    lda controllerLastFrame
    and #BUTTON_RIGHT
    bne CheckRightDone
      lda era
      cmp #ERA_AD
      bne CheckRightNotAD
        jsr CheckMaxYearMonthAD
        cpx #$01
        beq CheckRightDone
CheckRightNotAD:
  inc month
  lda month
  cmp #(MONTH_DECEMBER + 1)
  bcc CheckRightMonthNotOverflow
    jsr HandleIncYear
    lda #MONTH_JANUARY
    sta month
CheckRightMonthNotOverflow:
  jsr DrawCalendar
CheckRightDone:
  rts

CheckUp:
  lda controller
  cmp #BUTTON_UP
  bne CheckUpDone
    lda controllerLastFrame
    and #BUTTON_UP
    bne CheckUpDone
      lda era
      cmp #ERA_AD
      bne CheckUpNotAD
        jsr CheckMaxYearAD
        cpx #$01
        beq CheckUpDone
CheckUpNotAD:
  jsr HandleIncYear
  jsr DrawCalendar
CheckUpDone:
  rts

CheckDown:
  lda controller
  cmp #BUTTON_DOWN
  bne CheckDownDone
    lda controllerLastFrame
    and #BUTTON_DOWN
    bne CheckDownDone
      lda era
      cmp #ERA_BC
      bne CheckDownNotBC
        jsr CheckMinYearBC
        cpx #$01
        beq CheckDownDone
CheckDownNotBC:
  jsr HandleDecYear
  jsr DrawCalendar
CheckDownDone:
  rts

CheckStart:
  lda controller
  and #(BUTTON_START + BUTTON_B)
  beq CheckStartDone
    lda controllerLastFrame
    and #(BUTTON_START + BUTTON_B)
    bne CheckStartDone
      jsr DrawStartScreen
CheckStartDone:
  rts
