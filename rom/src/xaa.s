; da65 V2.18 - Git ece63f0
; Created:    2023-03-27 15:58:12
; Input file: xaa
; Page:       1


        .setcpu "6502"
        .include "common.s"

SCRATCH_SUBC := $0678
GRAPPLER_OPCODE := $0578

        sec
        bcs     :+
        nop
        nop
        sec
        nop
        clc
:       clv
        bvc     :+
        .byte $01, $10, $fc, $e5, $e8, $fc
:       pha
        php
        sei
        GETSLOT
        plp
        bcc     :+
        lda     #$41            ; ascii A
        sta     SCRATCH_SUBC,x
        lda     #$49            ; ascii I
        sta     $06F8,x
        lda     #$00
        sta     GRAPPLER_OPCODE,x ; clear Grappler opcode
        lda     #$07            ; control G
        sta     $36
        lda     $24
        sta     $0478,x
:       pla
        and     #$7F            ; strip to ascii
        cmp     #$07            ; control G?
        beq     EXIT            ; do nothing, bail
        cmp     #$09            ; control I -- Grappler sequence
        beq     LC17F           ; save to buffer, bail
        pha
        lda     GRAPPLER_OPCODE,x
        cmp     #$09            ; were we starting Grappler sequence?
        bne     PRINT
        pla
        cmp     #$41            ; A - append line feeds after CR
        beq     GRAPPLER
        cmp     #$4B            ; K - don't append line feeds after CR
        beq     GRAPPLER
        cmp     #$49            ; I - send to both screen and printer
        beq     LC177
        cmp     #$4E            ; N - set line length to n (precedes N)
        beq     LC177
        cmp     #$44            ; D - not documented
        beq     LC177
        cmp     #$30            ; number sequence (for the numbered commands)?
        bmi     LC17A
        cmp     #$39
        bpl     LC17A
        clc
        bcc     EXIT

GRAPPLER:
        sta     SCRATCH_SUBC,x
        clc
        bcc     LC17A
LC177:  sta     $06F8,x
LC17A:  lda     #$00
        sta     GRAPPLER_OPCODE,x
LC17F:  sta     GRAPPLER_OPCODE,x         ; save in slot scratch space.
EXIT:   jsr     RESTORE
        rts

PRINT:  lda     $24
        cmp     $0478,x
        beq     P1
        lda     #$20
        pha
        WAITACK
        pla
        SENDCHAR
        inc     $0478,x
        bne     PRINT
P1:     WAITBUSY
        pla
        pha
        SENDCHAR
        cmp     #$0D            ; CR?
        bne     LC1CA
        lda     SCRATCH_SUBC,x
        cmp     #$41            ; are we adding linefeeds?
        bne     LC1CA
        pla
        lda     #$0A            ; send LF
        pha
        clc
        bcc     P1              ; send it
LC1CA:  lda     $06F8,x
        cmp     #$49            ; are we sending to screen too?
        bne     :+
        txa
        pha
        jsr     RESTORE
        jsr     COUT1
        pla
        tax
:       pla
        lda     $24
        sta     $0478,x
        jmp     RESTORE
