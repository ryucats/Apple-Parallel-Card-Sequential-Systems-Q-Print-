; Sequential Systems Q-Print ROM
; 
; 0x0100 (strip high bit before sending)
; 0x0500 (do not strip high bit)

        .setcpu "6502"
        .include "common.s"

        pha             ; character we want to send
        sei
        sec
        bcs     :+
        sec
        nop
        clc
:       jsr     SAVE
        tsx             ; typical derive-this-slot logic
        lda     $0100,x
        and     #$0F
        asl     a
        asl     a
        asl     a
        asl     a
        tay
        WAITACK
        pla             ; pull character
.ifdef NO_STRIP
        SENDCHAR
        and     #$7F
.else
        and     #$7F    ; strip high bit before sending
        SENDCHAR
.endif
        cmp     #$0D    ; carriage return?
        bne     :+      ; if not, exit
        lda     $C080,y ; read status ...
        and     #$08    ; ... of switch 4 ...
        beq     :+      ; ... if low, exit
        lda     #$0A    ; send LF and then exit
        pha             
        clc
        bcc     :-
:       jmp     RESTORE
