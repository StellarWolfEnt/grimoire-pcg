bits 64

%include "common.inc"

;-------------------------------------------------------------------------------
; Imports
;-------------------------------------------------------------------------------

extern clock

extern calloc
extern free

;-------------------------------------------------------------------------------
; Structure Definitions
;-------------------------------------------------------------------------------

; START: GrimoireRandom --------------------------------------------------------

%define GrimoireRandom_SeedArray 0
%define GrimoireRandom_INext     (GrimoireRandom_SeedArray + (55 * 4))
%define GrimoireRandom_INextP    (GrimoireRandom_INext + 8)
%define GrimoireRandom_Padding   (GrimoireRandom_INextP + 8)
%define GrimoireRandom_SizeOf    (GrimoireRandom_Padding + 4)

; END: GrimoireRandom ----------------------------------------------------------

;-------------------------------------------------------------------------------
; Constants
;-------------------------------------------------------------------------------

%define UINT32_MAX  0xFFFFFFFF
%define INT32_MAX   0x7FFFFFFF
%define INT32_MIN   0x80000000
%define MSEED       161803398

section .rodata align=16
    twos: dq 2.0, 2.0

    range_funcs:
        dq GrimoireRandom_sample,
        dq GrimoireRandom_get_sample_for_large_range

    endian_test: dw 0xFF00

    __GrimoireRandom_NextBytes_Functions:
        dq GrimoireRandom_NextBytes_Loop_Next,
        dq GrimoireRandom_NextBytes_Done

;-------------------------------------------------------------------------------
; PData
;-------------------------------------------------------------------------------

section .pdata rdata align=4
    __GrimoireRandom_CreateNew_pdata:
        dd GrimoireRandom_CreateNew - $$
        dd GrimoireRandom_CreateNew_End - $$
        dd __GrimoireRandom_CreateNew_xdata - $$
    __GrimoireRandom_CreateSeed_pdata:
        dd GrimoireRandom_CreateSeed - $$
        dd GrimoireRandom_CreateSeed_End - $$
        dd __GrimoireRandom_CreateSeed_xdata - $$
    __GrimoireRandom_Destroy_pdata:
        dd GrimoireRandom_Destroy - $$
        dd GrimoireRandom_Destroy_End - $$
        dd __GrimoireRandom_Destroy_xdata - $$
    __GrimoireRandom_Next_pdata:
        dd GrimoireRandom_Next - $$
        dd GrimoireRandom_Next_End - $$
        dd __GrimoireRandom_Next_xdata - $$
    __GrimoireRandom_NextRange_pdata:
        dd GrimoireRandom_NextRange - $$
        dd GrimoireRandom_NextRange_End - $$
        dd __GrimoireRandom_NextRange_xdata - $$
    __GrimoireRandom_NextMax_pdata:
        dd GrimoireRandom_NextMax - $$
        dd GrimoireRandom_NextMax_End - $$
        dd __GrimoireRandom_NextMax_xdata - $$
    __GrimoireRandom_NextDouble_pdata:
        dd GrimoireRandom_NextDouble - $$
        dd GrimoireRandom_NextDouble_End - $$
        dd __GrimoireRandom_NextDouble_xdata - $$
    __GrimoireRandom_NextBytes_pdata:
        dd GrimoireRandom_NextBytes - $$
        dd GrimoireRandom_NextBytes_End - $$
        dd __GrimoireRandom_NextBytes_xdata - $$
    __GrimoireRandom_Serialize_pdata:
        dd GrimoireRandom_Serialize - $$
        dd GrimoireRandom_Serialize_End - $$
        dd __GrimoireRandom_Serialize_xdata - $$
    __GrimoireRandom_Deserialize_pdata:
        dd GrimoireRandom_Deserialize - $$
        dd GrimoireRandom_Deserialize_End - $$
        dd __GrimoireRandom_Deserialize_xdata - $$
    __GrimoireRandom_CloneInto_pdata:
        dd GrimoireRandom_CloneInto - $$
        dd GrimoireRandom_CloneInto_End - $$
        dd __GrimoireRandom_CloneInto_xdata - $$
    __GrimoireRandom_Clone_pdata:
        dd GrimoireRandom_Clone - $$
        dd GrimoireRandom_Clone_End - $$
        dd __GrimoireRandom_Clone_xdata - $$
    __GrimoireRandom_internal_sample_pdata:
        dd GrimoireRandom_internal_sample - $$
        dd GrimoireRandom_internal_sample_End - $$
        dd __GrimoireRandom_internal_sample_xdata - $$
    __GrimoireRandom_sample_pdata:
        dd GrimoireRandom_sample - $$
        dd GrimoireRandom_sample_End - $$
        dd __GrimoireRandom_sample_xdata - $$
    __GrimoireRandom_get_sample_for_large_range_pdata:
        dd GrimoireRandom_get_sample_for_large_range - $$
        dd GrimoireRandom_get_sample_for_large_range_End - $$
        dd __GrimoireRandom_get_sample_for_large_range_xdata - $$

;-------------------------------------------------------------------------------
; XData
;-------------------------------------------------------------------------------

section .xdata rdata align=4
    __GrimoireRandom_CreateNew_xdata:
        db 1,
        db 4,
        db 1,
        db 0,
        db 4,
        db (2 | (4 << 4))
    __GrimoireRandom_CreateSeed_xdata:
        db 1,
        db 4,
        db 1,
        db 0,
        db 4,
        db (2 | (4 << 4))
    __GrimoireRandom_Destroy_xdata:
        db 1,
        db 0,
        db 0,
        db 0
    __GrimoireRandom_Next_xdata:
        db 1,
        db 0,
        db 0,
        db 0
    __GrimoireRandom_NextRange_xdata:
        db 1,
        db 4,
        db 1,
        db 0,
        db 4,
        db (2 | (4 << 4))
    __GrimoireRandom_NextMax_xdata:
        db 1,
        db 4,
        db 1,
        db 0,
        db 4,
        db (2 | (4 << 4))
    __GrimoireRandom_NextDouble_xdata:
        db 1,
        db 0,
        db 0,
        db 0
    __GrimoireRandom_NextBytes_xdata:
        db 1,
        db 28,
        db 7,
        db 0,

        db 28,
        db (4 | (7 << 4)),
        dw 8,

        db 20,
        db (4 | (6 << 4)),
        dw 7,

        db 12,
        db (4 | (3 << 4)),
        dw 6,

        db 4,
        db (2 | (4 << 4))
    __GrimoireRandom_Serialize_xdata:
        db 1,
        db 0,
        db 0,
        db 0
    __GrimoireRandom_Deserialize_xdata:
        db 1,
        db 4,
        db 1,
        db 0,
        db 4,
        db (2 | (4 << 4))
    __GrimoireRandom_CloneInto_xdata:
        db 1,
        db 0,
        db 0,
        db 0
    __GrimoireRandom_Clone_xdata:
        db 1,
        db 4,
        db 1,
        db 0,
        db 4,
        db (2 | (4 << 4))
    __GrimoireRandom_internal_sample_xdata:
        db 1,
        db 0,
        db 0,
        db 0
    __GrimoireRandom_sample_xdata:
        db 1,
        db 4,
        db 1,
        db 0,
        db 4,
        db (2 | (4 << 4))
    __GrimoireRandom_get_sample_for_large_range_xdata:
        db 1,
        db 4,
        db 1,
        db 0,
        db 4,
        db (2 | (4 << 4))

;-------------------------------------------------------------------------------
; Public Functions
;-------------------------------------------------------------------------------

section .text align=16

; START: GrimoireRandom_CreateNew ----------------------------------------------

GRIMOIRE_PUBLIC GrimoireRandom_CreateNew
    sub         rsp, 40
    call        clock
    mov         rcx, rax
    mov         eax, dword UINT32_MAX
    and         rcx, rax
    call        GrimoireRandom_CreateSeed
    add         rsp, 40
    ret
MARKER GrimoireRandom_CreateNew_End

; END: GrimoireRandom_CreateNew ------------------------------------------------

; START: GrimoireRandom_CreateSeed ---------------------------------------------

GRIMOIRE_PUBLIC GrimoireRandom_CreateSeed
    sub         rsp, 40
    mov         dword [rsp + 48], ecx
    mov         rcx, 1
    mov         rdx, GrimoireRandom_SizeOf
    call        calloc
    test        rax, rax
    jz          .GrimoireRandom_CreateSeed_Done ; branch 1

    mov         edx, dword [rsp + 48] ; seed
    mov         ecx, INT32_MAX
    cmp         edx, INT32_MIN
    and         edx, INT32_MAX
    cmove       edx, ecx

    mov         ecx, MSEED
    sub         ecx, edx

    lea         rdx, [rax + GrimoireRandom_INext]
    sub         rdx, 4
    mov         dword [rdx], ecx

    mov         r8d, ecx
    mov         r9d, 1
    mov         qword [rsp + 48], rax
    lea         rax, [rax + GrimoireRandom_SeedArray]

%assign i 1
%assign ii 80
%rep 54
    mov         rcx, ii
    add         rcx, rax
    mov         dword [rcx], r8d
    mov         edx, r8d
    sub         edx, r9d
    mov         r9d, edx

    mov         r10d, r9d
    add         r10d, INT32_MAX
    cmp         r9d, 0
    cmovl       r9d, r10d
    mov         r8d, dword [rcx]

    %assign i (i + 1)
    %assign ii (((21 * i) % 55) - 1) * 4
%endrep

%rep 4
%assign i 0
%assign j 0
%assign k 124
%rep 55
    lea         rcx, [rax + j]
    lea         rdx, [rax + k]
    mov         r8d, dword [rcx]
    sub         r8d, dword [rdx]
    mov         r9d, r8d
    add         r9d, INT32_MAX
    cmp         r8d, 0
    cmovl       r8d, r9d
    mov         dword [rcx], r8d
%assign i (i + 1)
%assign j (j + 4)
%assign k ((i + 31) % 55) * 4
%endrep
%endrep
    mov         rcx, rax
    mov         rax, [rsp + 48]

    lea         rdx, [rax + GrimoireRandom_INext]
    mov         [rdx], rcx
    sub         qword [rdx], 4

    lea         rdx, [rax + GrimoireRandom_INextP]
    add         rcx, 80
    mov         [rdx], rcx

.GrimoireRandom_CreateSeed_Done:
    add         rsp, 40
    ret
MARKER GrimoireRandom_CreateSeed_End

; END: GrimoireRandom_CreateSeed -----------------------------------------------

; START: GrimoireRandom_Destroy ------------------------------------------------

GRIMOIRE_PUBLIC GrimoireRandom_Destroy
    jmp free
MARKER GrimoireRandom_Destroy_End

; END: GrimoireRandom_Destroy --------------------------------------------------

; START: GrimoireRandom_Next ---------------------------------------------------

GRIMOIRE_PUBLIC GrimoireRandom_Next
    jmp GrimoireRandom_internal_sample
MARKER GrimoireRandom_Next_End

; END: GrimoireRandom_Next -----------------------------------------------------

; START: GrimoireRandom_NextRange ----------------------------------------------

GRIMOIRE_PUBLIC GrimoireRandom_NextRange
    sub         rsp, 40

    cmp         ecx, edx
    cmovg       r8d, ecx
    cmovg       ecx, edx
    cmovg       edx, r8d

    sub         r8d, edx
    mov         qword [rsp + 48], rcx
    mov         dword [rsp + 56], edx
    mov         dword [rsp + 60], r8d
    cmp         r8d, INT32_MAX
    setg        al
    shl         rax, 3
    lea         rcx, [rel range_funcs]
    add         rax, rcx
    mov         rcx, [rsp + 48]
    call        [rax]
    cvtsi2sd    xmm1, dword [rsp + 60]
    mulsd       xmm0, xmm1
    cvtsi2sd    xmm1, dword [rsp + 56]
    addsd       xmm0, xmm1
    roundsd     xmm0, xmm0, 0x01
    cvtsd2si    rax, xmm0
    add         rsp, 40
    ret
MARKER GrimoireRandom_NextRange_End

; END: GrimoireRandom_NextRange ------------------------------------------------

; START: GrimoireRandom_NextMax ------------------------------------------------

GRIMOIRE_PUBLIC GrimoireRandom_NextMax
    sub         rsp, 40

    mov         edx, INT32_MAX
    cmp         ecx, INT32_MIN
    and         ecx, INT32_MAX
    cmove       ecx, edx
    

    mov         dword [rsp + 48], edx
    call        GrimoireRandom_sample
    cvtsi2sd    xmm1, dword [rsp + 48]
    mulsd       xmm0, xmm1
    roundsd     xmm0, xmm0, 0x01
    cvtsd2si    rax, xmm0
    add         rsp, 40
    ret
MARKER GrimoireRandom_NextMax_End

; END: GrimoireRandom_NextMax --------------------------------------------------

; START: GrimoireRandom_NextDouble ---------------------------------------------

GRIMOIRE_PUBLIC GrimoireRandom_NextDouble
    jmp GrimoireRandom_sample
MARKER GrimoireRandom_NextDouble_End

; END: GrimoireRandom_NextDouble -----------------------------------------------

; START: GrimoireRandom_NextBytes ----------------------------------------------

GRIMOIRE_PUBLIC GrimoireRandom_NextBytes
    sub         rsp, 40
    mov         [rsp + 48], rbx
    mov         [rsp + 56], rsi
    mov         [rsp + 64], rdi

    mov         rbx, rcx
    mov         rsi, rdx
    mov         rdi, r8
    lea         r10, [rel __GrimoireRandom_NextBytes_Functions]

GrimoireRandom_NextBytes_Loop:
    cmp         rdi, 0
    setz        al
    shl         rax, 3
    add         rax, r10
    jmp         [rax]

GrimoireRandom_NextBytes_Loop_Next:
    mov         rcx, rbx
    call        GrimoireRandom_internal_sample
    and         eax, 0xFF
    mov         byte [rsi], al
    inc         rsi
    dec         rdi
    jmp         GrimoireRandom_NextBytes_Loop

GrimoireRandom_NextBytes_Done:
    mov         rdi, [rsp + 64]
    mov         rsi, [rsp + 56]
    mov         rbx, [rsp + 48]
    add         rsp, 40
    ret
MARKER GrimoireRandom_NextBytes_End

; END: GrimoireRandom_NextBytes ------------------------------------------------

; START: GrimoireRandom_Serialize ----------------------------------------------

GRIMOIRE_PUBLIC GrimoireRandom_Serialize
    lea         rcx, [rcx + GrimoireRandom_SeedArray]
    mov         r8,  rcx
    mov         r9,  rdx
%rep 55
    mov         eax, dword [rcx]
    mov         r10d, eax
    bswap       r10d
    cmp         byte [rel endian_test], 0x00
    cmovne      eax, r10d
    mov         dword [rdx], eax
    add         rcx, 4
    add         rdx, 4
%endrep

%rep 2
    mov         rax, qword [rcx]
    sub         rax, r8
    shr         rax, 2
    inc         rax
    mov         r10d, eax
    bswap       r10d
    cmp         byte [rel endian_test], 0x00
    cmovne      eax, r10d
    mov         dword [rdx], eax
    add         rdx, 4
    add         rcx, 8
%endrep

    ret
MARKER GrimoireRandom_Serialize_End

; END: GrimoireRandom_Serialize ------------------------------------------------

; START: GrimoireRandom_Deserialize --------------------------------------------

GRIMOIRE_PUBLIC GrimoireRandom_Deserialize
    sub         rsp, 40
    mov         [rsp + 48], rcx

    mov         rcx, 1
    mov         rdx, GrimoireRandom_SizeOf
    call        calloc

    test        rax, rax
    jz          .GrimoireRandom_Deserialize_Done

    mov         rcx, [rsp + 48]
    mov         [rsp + 48], rax
    lea         rax, [rax + GrimoireRandom_SeedArray]
    mov         r9, rax
     
%rep 55
    mov         edx, dword [rcx]
    mov         r8d, edx
    bswap       r8d
    cmp         byte [rel endian_test], 0x00
    cmovne      edx, r8d
    mov         dword [rax], edx
    add         rcx, 4
    add         rax, 4
%endrep

%rep 2
    mov         edx, dword [rcx]
    mov         r8d, edx
    bswap       r8d
    cmp         byte [rel endian_test], 0x00
    cmovne      edx, r8d
    mov         r10d, edx
    mov         r8, r9
    sub         r8, 4
    shl         rdx, 2
    add         rdx, r9
    sub         rdx, 4
    mov         qword [rax], rdx
    add         rcx, 4
    add         rax, 8
%endrep

    mov         rax, [rsp + 48]

.GrimoireRandom_Deserialize_Done:
    add         rsp, 40
    ret
MARKER GrimoireRandom_Deserialize_End

; END: GrimoireRandom_Deserialize ----------------------------------------------

; START: GrimoireRandom_CloneInto ----------------------------------------------

GRIMOIRE_PUBLIC GrimoireRandom_CloneInto
    mov         r8, rcx
    mov         r9, rdx

%rep 55
    mov         eax, dword [r8]
    mov         dword [r9], eax
    add         r8, 4
    add         r9, 4
%endrep

%rep 2
    mov         rax, qword [r8]
    sub         rax, rcx
    add         rax, rdx
    mov         qword [r9], rax
    add         r8, 8
    add         r9, 8
%endrep

    ret
MARKER GrimoireRandom_CloneInto_End

; END: GrimoireRandom_CloneInto ------------------------------------------------

; START: GrimoireRandom_Clone --------------------------------------------------

GRIMOIRE_PUBLIC GrimoireRandom_Clone
    sub         rsp, 40
    mov         [rsp + 48], rcx
    mov         rcx, 1
    mov         rdx, GrimoireRandom_SizeOf
    call        calloc
    test        rax, rax
    jz          .GrimoireRandom_Clone_Done ; branch 3
    mov         r8, [rsp + 48]
    mov         r9, rax

%rep 55
    mov         edx, dword [r8]
    mov         dword [r9], edx
    add         r8, 4
    add         r9, 4
%endrep

%rep 2
    mov         rdx, qword [r8]
    sub         rdx, [rsp + 48]
    add         rdx, rax
    mov         qword [r9], rdx
    add         r8, 8
    add         r9, 8
%endrep

.GrimoireRandom_Clone_Done:
    add         rsp, 40
    ret
MARKER GrimoireRandom_Clone_End

; END: GrimoireRandom_Clone ----------------------------------------------------

;-------------------------------------------------------------------------------
; Private Functions
;-------------------------------------------------------------------------------

section .text align=16

; START: GrimoireRandom_internal_sample ----------------------------------------

GRIMOIRE_PRIVATE GrimoireRandom_internal_sample
    mov         rdx, rcx
    mov         rax, qword [rdx + GrimoireRandom_INext]
    mov         rcx, qword [rdx + GrimoireRandom_INextP]
    lea         r8, [rdx + GrimoireRandom_INext]

    add         rax, 4
    cmp         rax, r8
    cmove       rax, rdx
    mov         qword [rdx + GrimoireRandom_INext], rax

    add         rcx, 4
    cmp         rcx, r8
    cmove       rcx, rdx
    mov         qword [rdx + GrimoireRandom_INextP], rcx

    mov         ecx, dword [rcx]
    sub         dword [rax], ecx

    mov         ecx, [rax]
    cmp         dword [rax], INT32_MAX
    mov         r9d, 0x7FFFFFFE
    cmove       ecx, r9d
    mov         r9d, ecx
    add         r9d, INT32_MAX
    cmp         ecx, 0
    cmovl       ecx, r9d
    mov         dword [rax], ecx
    mov         eax, ecx
    ret
MARKER GrimoireRandom_internal_sample_End

; END: GrimoireRandom_internal_sample ------------------------------------------

; START: GrimoireRandom_sample -------------------------------------------------

GRIMOIRE_PRIVATE GrimoireRandom_sample
    sub         rsp, 40
    call        GrimoireRandom_internal_sample
    cvtsi2sd    xmm0, eax
    mov         rax, INT32_MAX
    cvtsi2sd    xmm1, rax
    divsd       xmm0, xmm1
    add         rsp, 40
    ret
MARKER GrimoireRandom_sample_End

; END: GrimoireRandom_sample ---------------------------------------------------

; START: GrimoireRandom_get_sample_for_large_range -----------------------------

GRIMOIRE_PRIVATE GrimoireRandom_get_sample_for_large_range
    sub         rsp, 40
    call        GrimoireRandom_internal_sample
    mov         [rsp + 48], eax
    call        GrimoireRandom_internal_sample
    
    and         eax, 1
    cmp         eax, 0
    mov         eax, [rsp + 48]
    mov         edx, eax
    neg         edx
    cmove       eax, edx

    cvtsi2sd    xmm0, eax
    mov         eax, INT32_MAX
    dec         eax
    cvtsi2sd    xmm1, eax
    addsd       xmm0, xmm1
    movapd      xmm2, oword [rel twos]
    mulsd       xmm1, xmm2
    divsd       xmm0, xmm1
    add         rsp, 40
    ret
MARKER GrimoireRandom_get_sample_for_large_range_End

; END: GrimoireRandom_get_sample_for_large_range -------------------------------