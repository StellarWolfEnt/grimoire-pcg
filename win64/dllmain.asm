bits 64

%include "common.inc"

;-------------------------------------------------------------------------------
; Internal Functions
;-------------------------------------------------------------------------------

section .text

; START: GrimoireDllMain -------------------------------------------------------

GRIMOIRE_INTERNAL GrimoireDllMain
    mov         rax, 1
    ret

; END: GrimoireDllMain ---------------------------------------------------------