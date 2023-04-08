; da65 V2.18 - Git ece63f0
; Created:    2023-03-27 15:58:12
; Input file: xae
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
        .byte $01, $31, $03, $03, $e1, $03
LC111:  pha
        php
        sei
        GETSLOT
        lda     #$61
        plp
        bcc     LC165
        lda     $0578,x
        cmp     #$09
        bne     LC17E
        lda     $0778,x
        cmp     #$7A
        beq     LC17E
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
LC14F:  cmp     #$61
        beq     LC165
        cmp     #$6B
        beq     LC165
LC157:  beq     LC103
        cmp     #$6E
        bne     LC162
        ldy     $04F8,x
        cpy     #$00
LC162:  sec
        bne     LC168
LC165:  sta     $0678,x
LC168:  sta     $0778,x
        sta     $0578,x
        lda     #$00
        sta     $04F8,x
        bcs     LC146
        lda     #$07
        sta     $36
        sta     $24
        sta     $0478,x
LC17E:  lda     $0478,x
        cmp     $24
        bcs     LC19E
LC185:  lda     #$20
        pha
        clc
        bcc     LC19E
LC18B:  inc     $0478,x
        lda     $24
        cmp     $0478,x
        bne     LC185
        pla
        and     #$7F
        cmp     #$0D
        beq     LC1DE
        pha
        sec
LC19E:  pla
        php
        pha
        WAITACK
        pla
        SENDCHAR
        plp
        bcc     LC18B
        cpx     #$FF
        beq     LC157
        and     #$7F
        sta     $0578,x
        cmp     #$20
        bmi     LC1C5
        inc     $0478,x
LC1C5:  cmp     #$0D
        bne     LC1DA
        lda     #$00
        sta     $0478,x
        lda     $0678,x
        cmp     #$61
        bne     LC1DA
        lda     #$0A
        pha
        bcs     LC19E
LC1DA:  lda     #$00
        sta     $24
LC1DE:  jmp     RESTORE

        ldx     #$FF
        and     #$FF
        pha
        sec
        bcs     LC19E
