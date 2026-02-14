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

section .rodata
    twos: dq 2.0, 2.0

    range_funcs:
        dq GrimoireRandom_sample,
        dq GrimoireRandom_get_sample_for_large_range

    endian_test: dw 0xFF00

;-------------------------------------------------------------------------------
; Public Functions
;-------------------------------------------------------------------------------

section .text

; START: GrimoireRandom_CreateNew ----------------------------------------------

GRIMOIRE_PUBLIC GrimoireRandom_CreateNew
    sub         rsp, 40
    call        clock
    mov         ecx, dword UINT32_MAX
    and         rax, rcx
    mov         rcx, rax
    call        GrimoireRandom_CreateSeed
    add         rsp, 40
    ret

; END: GrimoireRandom_CreateNew ------------------------------------------------

; START: GrimoireRandom_CreateSeed ---------------------------------------------

GRIMOIRE_PUBLIC GrimoireRandom_CreateSeed
    mov         dword [rsp + 8], ecx
    sub         rsp, 40
    mov         rcx, 1
    mov         rdx, GrimoireRandom_SizeOf
    call        calloc
    add         rsp, 40
    test        rax, rax
    jz          .GrimoireRandom_CreateSeed_Done

    mov         edx, dword [rsp + 8]
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
    mov         qword [rsp + 8], rax
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
    mov         rax, [rsp + 8]

    lea         rdx, [rax + GrimoireRandom_INext]
    mov         [rdx], rcx
    sub         qword [rdx], 4

    lea         rdx, [rax + GrimoireRandom_INextP]
    add         rcx, 80
    mov         [rdx], rcx   

.GrimoireRandom_CreateSeed_Done:
    ret

; END: GrimoireRandom_CreateSeed -----------------------------------------------

; START: GrimoireRandom_Destroy ------------------------------------------------

GRIMOIRE_PUBLIC GrimoireRandom_Destroy
    jmp free

; END: GrimoireRandom_Destroy --------------------------------------------------

; START: GrimoireRandom_Next ---------------------------------------------------

GRIMOIRE_PUBLIC GrimoireRandom_Next
    jmp GrimoireRandom_internal_sample

; END: GrimoireRandom_Next -----------------------------------------------------

; START: GrimoireRandom_NextRange ----------------------------------------------

GRIMOIRE_PUBLIC GrimoireRandom_NextRange
    sub         rsp, 40
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

; END: GrimoireRandom_NextRange ------------------------------------------------

; START: GrimoireRandom_NextMax ------------------------------------------------

GRIMOIRE_PUBLIC GrimoireRandom_NextMax
    sub         rsp, 40
    mov         dword [rsp + 48], edx
    call        GrimoireRandom_sample
    cvtsi2sd    xmm1, dword [rsp + 48]
    mulsd       xmm0, xmm1
    roundsd     xmm0, xmm0, 0x01
    cvtsd2si    rax, xmm0
    add         rsp, 40
    ret

; END: GrimoireRandom_NextMax --------------------------------------------------

; START: GrimoireRandom_NextDouble ---------------------------------------------

GRIMOIRE_PUBLIC GrimoireRandom_NextDouble
    jmp GrimoireRandom_sample

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

.GrimoireRandom_NextBytes_Loop:
    cmp         rdi, 0
    jz          .GrimoireRandom_NextBytes_Done

    mov         rcx, rbx
    call        GrimoireRandom_internal_sample
    and         eax, 0xFF
    mov         byte [rsi], al
    inc         rsi
    dec         rdi
    jmp         .GrimoireRandom_NextBytes_Loop

.GrimoireRandom_NextBytes_Done:
    mov         rbx, [rsp + 48]
    mov         rsi, [rsp + 56]
    mov         rdi, [rsp + 64]
    add         rsp, 40
    ret

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

    mov         rax, qword [rcx]
    sub         rax, r8
    shr         rax, 2
    mov         r10d, eax
    bswap       r10d
    cmp         byte [rel endian_test], 0x00
    cmovne      eax, r10d
    mov         dword [rdx], eax
    add         rdx, 4
    add         rcx, 8

    mov         rax, qword [rcx]
    sub         rax, r8
    shr         rax, 2
    mov         r10d, eax
    bswap       r10d
    cmp         byte [rel endian_test], 0x00
    cmovne      eax, r10d
    mov         dword [rdx], eax
    add         rdx, 4
    add         rcx, 8

    ret

; END: GrimoireRandom_Serialize ------------------------------------------------

; START: GrimoireRandom_Deserialize --------------------------------------------

GRIMOIRE_PUBLIC GrimoireRandom_Deserialize
    mov         [rsp + 8], rcx

    sub         rsp, 40
    mov         rcx, 1
    mov         rdx, GrimoireRandom_SizeOf
    call        calloc
    add         rsp, 40

    test        rax, rax
    jz          .GrimoireRandom_Deserialize_Done

    mov         rcx, [rsp + 8]
    mov         [rsp + 8], rax
    lea         rax, [rax + GrimoireRandom_SeedArray]
    
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

    mov         edx, dword [rcx]
    mov         r8d, edx
    bswap       r8d
    cmp         byte [rel endian_test], 0x00
    cmovne      edx, r8d
    shl         rdx, 2
    add         rdx, rax
    mov         [rax], rdx
    add         rcx, 4
    add         rax, 8

    mov         edx, dword [rcx]
    mov         r8d, edx
    bswap       r8d
    cmp         byte [rel endian_test], 0x00
    cmovne      edx, r8d
    shl         rdx, 2
    add         rdx, rax
    mov         [rax], rdx
    add         rcx, 4
    add         rax, 8

    mov         rax, [rsp + 8]

.GrimoireRandom_Deserialize_Done:
    ret

; END: GrimoireRandom_Deserialize ----------------------------------------------

;-------------------------------------------------------------------------------
; Private Functions
;-------------------------------------------------------------------------------

section .text

; START: GrimoireRandom_internal_sample ----------------------------------------

GRIMOIRE_PRIVATE GrimoireRandom_internal_sample
    mov         r8, [rcx + GrimoireRandom_INext]
    mov         r9, [rcx + GrimoireRandom_INextP]
    lea         r10, [rcx + GrimoireRandom_SeedArray]
    lea         r11, [rcx + GrimoireRandom_INext]
    mov         rax, rcx

    add         r8, 4
    cmp         r8, r11
    cmovge      r8, r10


    add         r9, 4
    cmp         r9, r11
    cmovge      r9, r10

    mov         ecx, dword [r8]
    sub         ecx, dword [r9]

    mov         edx, ecx
    dec         edx
    cmp         ecx, INT32_MAX
    cmove       ecx, edx

    mov         edx, ecx
    add         edx, INT32_MAX
    cmp         ecx, 0
    cmovl       ecx, edx
    
    mov         dword [r8], ecx
    mov         [rax + GrimoireRandom_INext], r8
    mov         [rax + GrimoireRandom_INextP], r9
    mov         eax, ecx
    ret

; END: GrimoireRandom_internal_sample ------------------------------------------

; START: GrimoireRandom_sample -------------------------------------------------

GRIMOIRE_PRIVATE GrimoireRandom_sample
    sub         rsp, 40
    call        GrimoireRandom_internal_sample
    add         rsp, 40
    cvtsi2sd    xmm0, eax
    mov         rax, INT32_MAX
    cvtsi2sd    xmm1, rax
    divsd       xmm0, xmm1
    ret

; END: GrimoireRandom_sample ---------------------------------------------------

; START: GrimoireRandom_get_sample_for_large_range -----------------------------

GRIMOIRE_PRIVATE GrimoireRandom_get_sample_for_large_range
    sub         rsp, 40
    call        GrimoireRandom_internal_sample
    mov         [rsp + 48], eax
    call        GrimoireRandom_internal_sample
    add         rsp, 40
    
    and         eax, 1
    cmp         eax, 0
    mov         eax, [rsp + 8]
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
    ret

; END: GrimoireRandom_get_sample_for_large_range -------------------------------