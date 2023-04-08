COUT1           := $FDF0
RESTORE         := $FF3F
SAVE            := $FF4A

.macro  GETSLOT
        jsr     SAVE
        tsx     
        lda     $0100,x
        and     #$0F
        tax
        asl     a
        asl     a
        asl     a
        asl     a
        tay
.endmacro

.macro  SENDCHAR
        sta     $C080,y         ; send character and pull STROBE high
        sta     $C081,y         ; pull STROBE low
        sta     $C080,y         ; pull STROBE high
.endmacro

.macro  WAITACK
:       lda     $C080,y
        and     #$01            ; wait for ACK to be pulled high
        beq     :-
.endmacro

.macro  WAITBUSY
:       lda     $C080,y
        and     #$06            ; wait for BUSY (or PAPER_END?) to go high
        bne     :-
.endmacro
