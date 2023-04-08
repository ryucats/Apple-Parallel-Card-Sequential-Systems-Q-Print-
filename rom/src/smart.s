; Sequential Systems Q-Print ROM
;
; 0x0200 (
; 0x0300 (
; 0x0400 ( shares with no_strip )
; 0x0600 ( shares with no_strip )
; 0x0700 ( shares with no_strip

        .setcpu "6502"
        .include "common.s"

CHAR_COUNTER :=         $04F8
DO_GRAPPLER :=          $0578
DO_LF :=                $0678
DO_SCREEN :=            $06F8
OPCODE :=               $0778

.ifdef OPT2
.define ID1 $10
.define ID2 $03
.define ID3 $03
.define ID4 $f7
.define ID5 $03
.define CHK #$7F
.endif

.ifdef OPT3
.define ID1 $10
.define ID2 $03
.define ID3 $03
.define ID4 $f7
.define ID5 $03
.define CHK #$7F
.endif

.ifdef OPT4
.define ID1 $31
.define ID2 $03
.define ID3 $03
.define ID4 $e1
.define ID5 $03
.define CHK #$00
.endif

.ifdef TYPER
.define ID1 $10
.define ID2 $03
.define ID3 $03
.define ID4 $f9
.define ID5 $03
.define CHK #$7F
.endif

COLD:   clc
        bcc     :+
WARM:   ldx     #$00
        sec
        rts

        clc
        sec
        bcs     :+
        .byte $01, ID1, ID2, ID3, ID4, ID5
:       pha
        php
        sei
        GETSLOT
.ifdef  TYPER
        plp
        lda     #$61
.else
        lda     #$61
        plp
.endif
        bcc     LC166
        lda     DO_GRAPPLER,x
        cmp     #$09    ; were we doing Grappler?
        bne     LC18E
        lda     OPCODE,x
        cmp     #$7A    ; Z - undocumented
        beq     LC18E
        pla
        and     #$7F
        cmp     #$30    ; is it a number?
        bmi     :+
        beq     LC146
        cmp     #$3A    ; :
        bpl     :+
        inc     CHAR_COUNTER,x
LC146:  jmp     RESTORE

:       cmp     #$5B    ; [
        bcs     LC14F
        adc     #$20
LC14F:
.ifndef OPT4
        tay
.endif
.ifdef TYPER
        cmp     #$69    ; I - send char to both screen and printer
        beq     LC192
        cmp     #$64    ; D
        beq     LC192
.endif
        cmp     #$61    ; A - append linefeeds
        beq     LC166
        cmp     #$6B    ; K - don't append linefeeds
        beq     LC166
GO_WARM:  beq     WARM
        cmp     #$6E    ; N
        bne     LC163
.ifdef TYPER
        sta     DO_SCREEN,x
.endif
        ldy     CHAR_COUNTER,x
        cpy     CHK
LC163:  sec
        bne     LC169           ; sleazy way of 
LC166:  sta     DO_LF,x
LC169:  sta     OPCODE,x
        sta     DO_GRAPPLER,x
        lda     CHK
        sta     CHAR_COUNTER,x
.ifndef OPT4
        bcc     LC180
        cpy     #$78
.ifdef OPTA
        sec
        beq     LC180
.else
        beq     LC180
        sec
.endif
        rol     a
        cpy     #$68
        bne     LC146
LC180:  sta     $05F8,x
.endif
        bcs     LC146
.ifdef  TYPER
        lda     #$69            ; I - explicitly echo to screen?
LC192:  sta     DO_SCREEN,x
        bcs     LC169
.endif
        lda     #$07
        sta     $36
.ifndef TYPER
        sta     $24
.else
        lda     $24
.endif
        sta     $0478,x
LC18E:  lda     $0478,x
        cmp     $24
        bcs     LC1AE
.ifndef TYPER
LC195:  lda     #$20
        pha
.else
        inc     $0478,x
        lda     #$20
.endif
        clc
.ifdef TYPER
LC19B:  pha
LC1AE:  pla
.else
        bcc     LC1AE
LC19B:  inc     $0478,x
        lda     $24
        cmp     $0478,x
        bne     LC195
        pla
        and     #$7F
        cmp     #$0D
        beq     LC1F5
        pha
        sec
LC1AE:  pla
.endif
        php
        pha
.ifdef W_BUSY
        WAITBUSY
.else
        WAITACK
.endif
        pla
.ifndef OPT4
        cpx     #$FF
        beq     LC1C0
        and     $05F8,x
.endif
LC1C0:  SENDCHAR
        plp
.ifdef  TYPER
        bcc     LC18E
.else
        bcc     LC19B
.endif
        cpx     #$FF
        beq     GO_WARM
        and     #$7F
        sta     DO_GRAPPLER,x
.ifdef TYPER
        cmp     #$0D
        bne     LC1F1
.else
        cmp     #$20
        bmi     LC1DC
        inc     $0478,x
LC1DC:  cmp     #$0D
        bne     LC1F1
        lda     #$00
        sta     $0478,x
.endif
        lda     DO_LF,x
        cmp     #$61            ; 'a' -- do linefeeds
        bne     LC1F1
        lda     #$0A
        pha
        bcs     LC1AE
LC1F1:
.ifdef TYPER
        lda     DO_SCREEN,x
        cmp     #$69
        bne     :+
        lda     $45
        jsr     COUT1
:       lda     $24
        sta     $0478,x
.else
        lda     #$00
        sta     $24
.endif

LC1F5:  jmp     RESTORE
