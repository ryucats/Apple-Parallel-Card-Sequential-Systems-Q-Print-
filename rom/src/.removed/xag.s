; da65 V2.18 - Git ece63f0
; Created:    2023-03-27 15:58:12
; Input file: xag
; Page:       1


        .setcpu "6502"
        .include "common.s"

        clc
        bcc     LC111
LC103:  ldx     #$00
        sec
        rts

        clc
        sec
        bcs     LC111
        .byte $01, $10, $03, $03, $f9, $03
LC111:  pha
        php
        sei
        GETSLOT
        plp
        lda     #$61
        bcc     LC171
        lda     $0578,x
        cmp     #$09
        bne     LC1A0
        lda     $0778,x
        cmp     #$7A
        beq     LC1A0
        pla
        and     #$7F
        cmp     #$30
        bmi     LC149
        beq     LC146
        cmp     #$3A
        bpl     LC149
        inc     $04F8,x
LC146:  jmp     RESTORE

LC149:  cmp     #$5B
        bcs     LC14F
        adc     #$20
LC14F:  tay
        cmp     #$69
        beq     LC192
        cmp     #$64
        beq     LC192
        cmp     #$61
        beq     LC171
        cmp     #$6B
        beq     LC171
LC160:  beq     LC103
        cmp     #$6E
        bne     LC16E
        sta     $06F8,x
        ldy     $04F8,x
        cpy     #$7F
LC16E:  sec
        bne     LC174
LC171:  sta     $0678,x
LC174:  sta     $0778,x
        sta     $0578,x
        lda     #$7F
        sta     $04F8,x
        bcc     LC18B
        cpy     #$78
        sec
        beq     LC18B
        rol     a
        cpy     #$68
        bne     LC146
LC18B:  sta     $05F8,x
        bcs     LC146
        lda     #$69
LC192:  sta     $06F8,x
        bcs     LC174
        lda     #$07
        sta     $36
        lda     $24
        sta     $0478,x
LC1A0:  lda     $0478,x
        cmp     $24
        bcs     LC1AE
        inc     $0478,x
        lda     #$20
        clc
LC1AD:  pha
LC1AE:  pla
        php
        pha
        WAITACK
        pla
        cpx     #$FF
        beq     LC1C0
        and     $05F8,x
LC1C0:  SENDCHAR
        plp
        bcc     LC1A0
        cpx     #$FF
        beq     LC160
        and     #$7F
        sta     $0578,x
        cmp     #$0D
        bne     LC1E5
        lda     $0678,x
        cmp     #$61
        bne     LC1E5
        lda     #$0A
        pha
        bcs     LC1AE
LC1E5:  lda     $06F8,x
        cmp     #$69
        bne     LC1F1
        lda     $45
        jsr     COUT1
LC1F1:  lda     $24
        sta     $0478,x
        jmp     RESTORE

        ldx     #$FF
        and     #$7F
        sec
        bcs     LC1AD
