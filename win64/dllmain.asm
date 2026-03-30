bits 64

%include "common.inc"

;-------------------------------------------------------------------------------
; PData
;-------------------------------------------------------------------------------

section .pdata rdata align=4
    __GrimoireDll_Main_pdata:
        dd GrimoireDll_Main - $$
        dd GrimoireDll_Main_End - $$
        dd __GrimoireDll_Main_xdata - $$

;-------------------------------------------------------------------------------
; XData
;-------------------------------------------------------------------------------

section .xdata rdata align=4
    __GrimoireDll_Main_xdata:
        db 1,
        db 0,
        db 0,
        db 0

;-------------------------------------------------------------------------------
; Internal Functions
;-------------------------------------------------------------------------------

section .text code align=16

; START: GrimoireDll_Main -------------------------------------------------------

GRIMOIRE_INTERNAL GrimoireDll_Main
    mov         rax, 1
    ret
MARKER GrimoireDll_Main_End

; END: GrimoireDll_Main ---------------------------------------------------------