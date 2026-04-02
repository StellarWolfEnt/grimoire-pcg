bits 64

%include "common.inc"

;-------------------------------------------------------------------------------
; Structure Definitions
;-------------------------------------------------------------------------------

; START: Grimoire_FractalSettings -----------------------------------------------

%define Grimoire_FractalSettings_Frequency 0
%define Grimoire_FractalSettings_Octaves (Grimoire_FractalSettings_Frequency + 4)
%define Grimoire_FractalSettings_Lacunarity (Grimoire_FractalSettings_Octaves + 4)
%define Grimoire_FractalSettings_Persistence (Grimoire_FractalSettings_Lacunarity + 4)
%define Grimoire_FractalSettings_StaticSeed (Grimoire_FractalSettings_Persistence + 4)
%define Grimoire_FractalSettings_Padding (Grimoire_FractalSettings_StaticSeed + 1)
%define Grimoire_FractalSettings_Size (Grimoire_FractalSettings_Padding + 15)

; END: Grimoire_FractalSettings -------------------------------------------------

;-------------------------------------------------------------------------------
; Constants
;-------------------------------------------------------------------------------

%define FLOOR 0x01

section .rodata align=16
    six: dd 6.0, 6.0, 6.0, 6.0
    fifteen: dd 15.0, 15.0, 15.0, 15.0
    ten: dd 10.0, 10.0, 10.0, 10.0
    one: dd 1.0, 1.0, 1.0, 1.0
    half: dd 0.5, 0.5, 0.5, 0.5
    sqrt2: dd 1.41421356237, 1.41421356237, 1.41421356237, 1.41421356237
    two: dd 2.0, 2.0, 2.0, 2.0
    inv_255: dd 0.00392156862, 0.00392156862, 0.00392156862, 0.00392156862

    abs_mask: dd 0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF

    GRAD_1D:
        dd 1.0, 0.0, 0.0, 0.0
        dd -1.0, 0.0, 0.0, 0.0

    GRAD_2D:
        dd 1.0, 0.0, 0.0, 0.0
        dd -1.0, 0.0, 0.0, 0.0
        dd 0.0, 1.0, 0.0, 0.0
        dd 0.0, -1.0, 0.0, 0.0
        dd 0.70710678118, 0.70710678118, 0.0, 0.0
        dd -0.70710678118, 0.70710678118, 0.0, 0.0
        dd 0.70710678118, -0.70710678118, 0.0, 0.0
        dd -0.70710678118, -0.70710678118, 0.0, 0.0

    GRAD_3D:
        dd 1.0, 1.0, 0.0, 0.0
        dd -1.0, 1.0, 0.0, 0.0
        dd 1.0, -1.0, 0.0, 0.0
        dd -1.0, -1.0, 0.0, 0.0
        dd 1.0, 0.0, 1.0, 0.0
        dd -1.0, 0.0, 1.0, 0.0
        dd 1.0, 0.0, -1.0, 0.0
        dd -1.0, 0.0, -1.0, 0.0
        dd 0.0, 1.0, 1.0, 0.0
        dd 0.0, -1.0, 1.0, 0.0
        dd 0.0, 1.0, -1.0, 0.0
        dd 0.0, -1.0, -1.0, 0.0
        dd 1.0, 1.0, 0.0, 0.0
        dd -1.0, 1.0, 0.0, 0.0
        dd 0.0, -1.0, 1.0, 0.0
        dd 0.0, -1.0, -1.0, 0.0

;-------------------------------------------------------------------------------
; PData
;-------------------------------------------------------------------------------

section .pdata rdata align=4
    __Grimoire_ValueSharp1D_pdata:
        dd Grimoire_ValueSharp1D - $$
        dd Grimoire_ValueSharp1D_End - $$
        dd __Grimoire_ValueSharp1D_xdata - $$
    __Grimoire_ValueSharp2D_pdata:
        dd Grimoire_ValueSharp2D - $$
        dd Grimoire_ValueSharp2D_End - $$
        dd __Grimoire_ValueSharp2D_xdata - $$
    __Grimoire_ValueSharp3D_pdata:
        dd Grimoire_ValueSharp3D - $$
        dd Grimoire_ValueSharp3D_End - $$
        dd __Grimoire_ValueSharp3D_xdata - $$
    __Grimoire_ValueSmooth1D_pdata:
        dd Grimoire_ValueSmooth1D - $$
        dd Grimoire_ValueSmooth1D_End - $$
        dd __Grimoire_ValueSmooth1D_xdata - $$
    __Grimoire_ValueSmooth2D_pdata:
        dd Grimoire_ValueSmooth2D - $$
        dd Grimoire_ValueSmooth2D_End - $$
        dd __Grimoire_ValueSmooth2D_xdata - $$
    __Grimoire_ValueSmooth3D_pdata:
        dd Grimoire_ValueSmooth3D - $$
        dd Grimoire_ValueSmooth3D_End - $$
        dd __Grimoire_ValueSmooth3D_xdata - $$
    __Grimoire_Perlin1D_pdata:
        dd Grimoire_Perlin1D - $$
        dd Grimoire_Perlin1D_End - $$
        dd __Grimoire_Perlin1D_xdata - $$
    __Grimoire_Perlin2D_pdata:
        dd Grimoire_Perlin2D - $$
        dd Grimoire_Perlin2D_End - $$
        dd __Grimoire_Perlin2D_xdata - $$
    __Grimoire_Perlin3D_pdata:
        dd Grimoire_Perlin3D - $$
        dd Grimoire_Perlin3D_End - $$
        dd __Grimoire_Perlin3D_xdata - $$
    __Grimoire_Fbm_pdata:
        dd Grimoire_Fbm - $$
        dd Grimoire_Fbm_End - $$
        dd __Grimoire_Fbm_xdata - $$
    __Grimoire_Billow_pdata:
        dd Grimoire_Billow - $$
        dd Grimoire_Billow_End - $$
        dd __Grimoire_Billow_xdata - $$
    __Grimoire_WangHash_pdata:
        dd Grimoire_WangHash - $$
        dd Grimoire_WangHash_End - $$
        dd __Grimoire_WangHash_xdata - $$
    __Grimoire_NoiseHash_pdata:
        dd Grimoire_NoiseHash - $$
        dd Grimoire_NoiseHash_End - $$
        dd __Grimoire_NoiseHash_xdata - $$
    __Grimoire_NoiseSmooth_pdata:
        dd Grimoire_NoiseSmooth - $$
        dd Grimoire_NoiseSmooth_End - $$
        dd __Grimoire_NoiseSmooth_xdata - $$
    __Grimoire_NoiseLerp_pdata:
        dd Grimoire_NoiseLerp - $$
        dd Grimoire_NoiseLerp_End - $$
        dd __Grimoire_NoiseLerp_xdata - $$
    __Grimoire_Dot2_pdata:
        dd Grimoire_Dot2 - $$
        dd Grimoire_Dot2_End - $$
        dd __Grimoire_Dot2_xdata - $$
    __Grimoire_Dot3_pdata:
        dd Grimoire_Dot3 - $$
        dd Grimoire_Dot3_End - $$
        dd __Grimoire_Dot3_xdata - $$

;-------------------------------------------------------------------------------
; XData
;-------------------------------------------------------------------------------

section .xdata rdata align=4
    __Grimoire_ValueSharp1D_xdata:
        db 1,
        db 4,
        db 1, 
        db 0,
        db 4,
        db (2 | (4 << 4))
    __Grimoire_ValueSharp2D_xdata:
        db 1,
        db 4,
        db 1, 
        db 0,
        db 4,
        db (2 | (4 << 4))
    __Grimoire_ValueSharp3D_xdata:
        db 1,
        db 4,
        db 1, 
        db 0,
        db 4,
        db (2 | (4 << 4))    
    __Grimoire_ValueSmooth1D_xdata:
        db 1,
        db 4,
        db 1, 
        db 0,
        db 4,
        db (2 | (4 << 4))
    __Grimoire_ValueSmooth2D_xdata:
        db 1,
        db 4,
        db 1, 
        db 0,
        db 4,
        db (2 | (4 << 4))
    __Grimoire_ValueSmooth3D_xdata:
        db 1,
        db 7,
        db 2,
        db 0,
        db 7,
        db 1,
        dw 17
    __Grimoire_Perlin1D_xdata:
        db 1,
        db 4,
        db 1, 
        db 0,
        db 4,
        db (2 | (10 << 4))
    __Grimoire_Perlin2D_xdata:
        db 1,
        db 7,
        db 2,
        db 0,
        db 7,
        db 1,
        dw 23
    __Grimoire_Perlin3D_xdata:
        db 1,
        db 7,
        db 2,
        db 0,
        db 7,
        db 1,
        dw 31
    __Grimoire_Fbm_xdata:
        db 1
        db 53
        db 18
        db 0

        db 53
        db (8 | (11 << 4))
        dw 7

        db 48
        db (8 | (10 << 4))
        dw 6

        db 43
        db (8 | (9 << 4))
        dw 5

        db 38
        db (8 | (8 << 4))
        dw 4

        db 33
        db (8 | (7 << 4))
        dw 3

        db 28
        db (8 | (6 << 4))
        dw 2

        db 23
        db (4 | (6 << 4))
        dw 128

        db 15
        db (4 | (3 << 4))
        dw 120

        db 7
        db 1
        dw 17

    __Grimoire_Billow_xdata:
        db 1
        db 53
        db 18
        db 0

        db 53
        db (8 | (11 << 4))
        dw 7

        db 48
        db (8 | (10 << 4))
        dw 6

        db 43
        db (8 | (9 << 4))
        dw 5

        db 38
        db (8 | (8 << 4))
        dw 4

        db 33
        db (8 | (7 << 4))
        dw 3

        db 28
        db (8 | (6 << 4))
        dw 2

        db 23
        db (4 | (6 << 4))
        dw 128

        db 15
        db (4 | (3 << 4))
        dw 120

        db 7
        db 1
        dw 17
    __Grimoire_WangHash_xdata:
        db 1,
        db 0,
        db 0,
        db 0
    __Grimoire_NoiseHash_xdata:
        db 1,
        db 4,
        db 1, 
        db 0,
        db 4,
        db (2 | (4 << 4))
    __Grimoire_NoiseSmooth_xdata:
        db 1,
        db 0,
        db 0,
        db 0
    __Grimoire_NoiseLerp_xdata:
        db 1,
        db 0,
        db 0,
        db 0
    __Grimoire_Dot2_xdata:
        db 1,
        db 0,
        db 0,
        db 0
    __Grimoire_Dot3_xdata:
        db 1,
        db 0,
        db 0,
        db 0

;-------------------------------------------------------------------------------
; Public Functions
;-------------------------------------------------------------------------------

section .text code align=16

; START:  Grimoire_ValueSharp1D ------------------------------------------------

GRIMOIRE_PUBLIC Grimoire_ValueSharp1D
    sub rsp, 40
    roundps xmm1, xmm0, FLOOR
    cvtss2si edx, xmm1
    xor r8d, r8d
    xor r9d, r9d
    call Grimoire_NoiseHash
    cvtsi2ss xmm0, eax
    mulps xmm0, [rel inv_255]
    add rsp, 40
    ret
MARKER Grimoire_ValueSharp1D_End

; END: Grimoire_ValueSharp1D ---------------------------------------------------

; START:  Grimoire_ValueSharp2D ------------------------------------------------

GRIMOIRE_PUBLIC Grimoire_ValueSharp2D
    sub rsp, 40
    roundps xmm1, xmm0, FLOOR
    roundps xmm2, xmm0, FLOOR
    cvtss2si edx, xmm1
    cvtss2si r8d, xmm2
    xor r9d, r9d
    call Grimoire_NoiseHash
    cvtsi2ss xmm0, eax
    mulps xmm0, [rel inv_255]
    add rsp, 40
    ret
MARKER Grimoire_ValueSharp2D_End

; END: Grimoire_ValueSharp2D ---------------------------------------------------

; START:  Grimoire_ValueSharp3D ------------------------------------------------

GRIMOIRE_PUBLIC Grimoire_ValueSharp3D
    sub rsp, 40
    roundps xmm1, xmm0, FLOOR
    roundps xmm2, xmm0, FLOOR
    roundps xmm3, xmm0, FLOOR
    cvtss2si edx, xmm1
    cvtss2si r8d, xmm2
    cvtss2si r9d, xmm3
    call Grimoire_NoiseHash
    cvtsi2ss xmm0, eax
    mulps xmm0, [rel inv_255]
    add rsp, 40
    ret
MARKER Grimoire_ValueSharp3D_End

; END: Grimoire_ValueSharp3D ---------------------------------------------------

; START:  Grimoire_ValueSmooth1D -----------------------------------------------

GRIMOIRE_PUBLIC Grimoire_ValueSmooth1D
    sub rsp, 40
    mov [rsp + 64], ecx
    movaps [rsp + 48], xmm0
    roundps xmm1, xmm0, FLOOR
    cvtss2si edx, xmm1
    movaps xmm0, [rsp + 48]
    subps xmm0, xmm1
    call Grimoire_NoiseSmooth
    movaps [rsp + 64], xmm0
    mov [rsp + 68], edx

    xor r8d, r8d
    xor r9d, r9d
    call Grimoire_NoiseHash

    mov edx, [rsp + 68]
    mov ecx, [rsp + 64]
    mov [rsp + 68], al
    inc edx
    call Grimoire_NoiseHash

    cvtsi2ss xmm1, eax
    mov al, [rsp + 68]
    cvtsi2ss xmm0, eax
    movaps xmm2, [rsp + 48]
    call Grimoire_NoiseLerp
    mulps xmm0, [rel inv_255]
    add rsp, 40
    ret
MARKER Grimoire_ValueSmooth1D_End

; END: Grimoire_ValueSmooth1D --------------------------------------------------

; START:  Grimoire_ValueSmooth2D -----------------------------------------------

GRIMOIRE_PUBLIC Grimoire_ValueSmooth2D
    sub rsp, 96

    mov [rsp + 80], ecx
    movaps [rsp + 32], xmm0
    movaps [rsp + 48], xmm1
    roundps xmm2, xmm0, FLOOR
    roundps xmm3, xmm1, FLOOR
    
    cvtss2si edx, xmm2
    cvtss2si r8d, xmm3
    mov [rsp + 84], edx
    mov [rsp + 88], r8d

    movaps xmm0, [rsp + 32]
    subps xmm0, xmm2
    call Grimoire_NoiseSmooth
    movaps [rsp + 32], xmm0

    movaps xmm0, [rsp + 48]
    subps xmm0, xmm3
    call Grimoire_NoiseSmooth
    movaps [rsp + 48], xmm0

    xor r9d, r9d
    call Grimoire_NoiseHash
    mov [rsp + 92], al

    mov ecx, [rsp + 80]
    mov edx, [rsp + 84]
    inc edx
    mov r8d, [rsp + 88]
    xor r9d, r9d
    call Grimoire_NoiseHash

    cvtsi2ss xmm1, eax
    mov dl, [rsp + 92]
    cvtsi2ss xmm0, edx
    movaps xmm2, [rsp + 32]
    call Grimoire_NoiseLerp

    movaps [rsp + 64], xmm0

    mov ecx, [rsp + 84]
    mov edx, [rsp + 64]
    mov r8d, [rsp + 88]
    inc r8d
    mov [rsp + 88], r8d
    xor r9d, r9d
    call Grimoire_NoiseHash

    mov [rsp + 92], al

    mov ecx, [rsp + 84]
    mov edx, [rsp + 88]
    inc edx
    mov r8d, [rsp + 88]
    xor r9d, r9d
    call Grimoire_NoiseHash

    cvtsi2ss xmm1, eax
    mov edx, [rsp + 92]
    cvtsi2ss xmm0, edx
    movaps xmm2, [rsp + 32]
    call Grimoire_NoiseLerp

    movaps xmm1, xmm0
    movaps xmm0, [rsp + 64]
    movaps xmm2, [rsp + 48]
    call Grimoire_NoiseLerp
    mulps xmm0, [rel inv_255]
    add rsp, 96
    ret
MARKER Grimoire_ValueSmooth2D_End

; END: Grimoire_ValueSmooth2D --------------------------------------------------

; START:  Grimoire_ValueSmooth3D -----------------------------------------------

GRIMOIRE_PUBLIC Grimoire_ValueSmooth3D
    sub rsp, 136

    mov [rsp + 112], rcx
    movaps [rsp + 32], xmm0
    movaps [rsp + 48], xmm1
    movaps [rsp + 64], xmm2

    roundps xmm3, xmm0, FLOOR
    roundps xmm4, xmm1, FLOOR
    roundps xmm5, xmm2, FLOOR

    cvtss2si edx, xmm3
    cvtss2si r8d, xmm4
    cvtss2si r9d, xmm5

    mov [rsp + 116], edx
    mov [rsp + 120], r8d
    mov [rsp + 124], r9d

    movaps xmm0, [rsp + 32]
    subps xmm0, xmm3
    call Grimoire_NoiseSmooth
    movaps [rsp + 32], xmm0

    movaps xmm0, [rsp + 48]
    subps xmm0, xmm4
    call Grimoire_NoiseSmooth
    movaps [rsp + 48], xmm0

    movaps xmm0, [rsp + 64]
    subps xmm0, xmm5
    call Grimoire_NoiseSmooth
    movaps [rsp + 64], xmm0

    call Grimoire_NoiseHash
    mov [rsp + 128], al

    mov ecx, [rsp + 112]
    mov edx, [rsp + 116]
    inc edx
    mov r8d, [rsp + 120]
    mov r9d, [rsp + 124]
    call Grimoire_NoiseHash

    cvtsi2ss xmm1, eax
    mov edx, [rsp + 128]
    cvtsi2ss xmm0, edx
    movaps xmm2, [rsp + 32]
    call Grimoire_NoiseLerp
    movaps [rsp + 80], xmm0

    mov ecx, [rsp + 112]
    mov edx, [rsp + 116]
    mov r8d, [rsp + 120]
    inc r8d
    mov r9d, [rsp + 124]
    call Grimoire_NoiseHash

    mov [rsp + 128], al
    
    mov ecx, [rsp + 112]
    mov edx, [rsp + 116]
    inc edx
    mov r8d, [rsp + 120]
    inc r8d
    mov r9d, [rsp + 124]
    call Grimoire_NoiseHash

    cvtsi2ss xmm1, eax
    mov edx, [rsp + 128]
    cvtsi2ss xmm0, edx
    movaps xmm2, [rsp + 32]
    call Grimoire_NoiseLerp

    movaps xmm1, xmm0
    movaps xmm0, [rsp + 80]
    movaps xmm2, [rsp + 48]
    call Grimoire_NoiseLerp
    movaps [rsp + 80], xmm0

    mov ecx, [rsp + 112]
    mov edx, [rsp + 116]
    mov r8d, [rsp + 120]
    mov r9d, [rsp + 124]
    inc r9d
    mov [rsp + 124], r9d
    call Grimoire_NoiseHash

    mov [rsp + 128], al

    mov ecx, [rsp + 112]
    mov edx, [rsp + 116]
    inc edx
    mov r8d, [rsp + 120]
    mov r9d, [rsp + 124]
    call Grimoire_NoiseHash

    cvtsi2ss xmm1, eax
    mov edx, [rsp + 128]
    cvtsi2ss xmm0, edx
    movaps xmm2, [rsp + 32]
    call Grimoire_NoiseLerp

    movaps [rsp + 96], xmm0

    mov ecx, [rsp + 112]
    mov edx, [rsp + 116]
    mov r8d, [rsp + 120]
    inc r8d
    mov [rsp + 120], r8d
    mov r9d, [rsp + 124]

    call Grimoire_NoiseHash

    mov [rsp + 128], al

    mov ecx, [rsp + 112]
    mov edx, [rsp + 116]
    inc edx
    mov r8d, [rsp + 120]
    mov r9d, [rsp + 124]

    call Grimoire_NoiseHash

    cvtsi2ss xmm1, eax
    mov edx, [rsp + 128]
    cvtsi2ss xmm0, edx
    movaps xmm2, [rsp + 32]
    call Grimoire_NoiseLerp
    movaps xmm1, xmm0
    movaps xmm0, [rsp + 96]
    movaps xmm2, [rsp + 48]
    call Grimoire_NoiseLerp

    movaps xmm1, xmm0
    movaps xmm0, [rsp + 80]
    movaps xmm2, [rsp + 64]
    call Grimoire_NoiseLerp
    mulps xmm0, [rel inv_255]
    add rsp, 136
    ret
MARKER Grimoire_ValueSmooth3D_End

; END: Grimoire_ValueSmooth3D --------------------------------------------------

; START:  Grimoire_Perlin1D ----------------------------------------------------

GRIMOIRE_PUBLIC Grimoire_Perlin1D
    sub rsp, 88

    lea r10, [rel GRAD_1D]
    mov [rsp + 80], ecx
    movaps [rsp + 32], xmm0
    
    roundps xmm1, xmm0, FLOOR
    cvtss2si edx, xmm1
    mov [rsp + 84], edx

    subps xmm0, xmm1
    movaps [rsp + 32], xmm0
    subps xmm0, [rel one]
    movaps [rsp + 48], xmm0
    movaps xmm0, [rsp + 32]
    call Grimoire_NoiseSmooth
    movaps [rsp + 64], xmm0

    xor r8d, r8d
    xor r9d, r9d
    call Grimoire_NoiseHash

    and rax, 1
    shl rax, 4
    mov rcx, r10
    add rcx, rax
    movaps xmm0, [rcx]

    mov ecx, [rsp + 80]
    mov edx, [rsp + 84]
    inc edx
    xor r8d, r8d
    xor r9d, r9d
    call Grimoire_NoiseHash

    and rax, 1
    shl rax, 4
    mov rcx, r10
    add rcx, rax
    movaps xmm1, [rcx]
    
    movaps xmm2, [rsp + 32]
    movaps xmm3, [rsp + 48]

    mulps xmm0, xmm2
    mulps xmm1, xmm3

    movaps xmm2, [rsp + 64]
    call Grimoire_NoiseLerp
    addps xmm0, [rel half]
    add rsp, 88
    ret
MARKER Grimoire_Perlin1D_End

; END: Grimoire_Perlin1D -------------------------------------------------------

; START:  Grimoire_Perlin2D ----------------------------------------------------

GRIMOIRE_PUBLIC Grimoire_Perlin2D
    sub rsp, 184

    lea r10, [rel GRAD_2D]
    mov [rsp + 160], ecx

    roundps xmm2, xmm0, FLOOR
    roundps xmm3, xmm1, FLOOR

    cvtss2si edx, xmm2
    cvtss2si r8d, xmm3

    subps xmm0, xmm2
    subps xmm1, xmm3

    mov [rsp + 164], edx
    mov [rsp + 168], r8d

    movaps [rsp + 32], xmm0
    movaps [rsp + 48], xmm1

    subps xmm0, [rel one]
    subps xmm1, [rel one]

    movaps [rsp + 64], xmm0
    movaps [rsp + 80], xmm1

    movaps xmm0, [rsp + 32]
    call Grimoire_NoiseSmooth
    movaps [rsp + 96], xmm0
    
    movaps xmm0, [rsp + 48]
    call Grimoire_NoiseSmooth
    movaps [rsp + 112], xmm0

    xor r8d, r8d
    xor r9d, r9d
    call Grimoire_NoiseHash
    and rax, 7
    shl rax, 4
    mov rcx, r10
    add rcx, rax

    movaps xmm0, [rcx]
    movaps xmm1, [rsp + 32]
    movaps xmm2, [rsp + 48]
    call Grimoire_Dot2
    movaps [rsp + 128], xmm0

    mov ecx, [rsp + 160]
    mov edx, [rsp + 164]
    inc edx
    mov r8d, [rsp + 168]
    xor r9d, r9d
    call Grimoire_NoiseHash
    and rax, 7
    shl rax, 4
    mov rcx, r10
    add rcx, rax
    movaps xmm0, [rcx]
    movaps xmm1, [rsp + 64]
    movaps xmm2, [rsp + 48]
    call Grimoire_Dot2
    
    movaps xmm1, xmm0
    movaps xmm0, [rsp + 128]
    movaps xmm2, [rsp + 96]
    call Grimoire_NoiseLerp
    movaps [rsp + 128], xmm0

    mov ecx, [rsp + 160]
    mov edx, [rsp + 164]
    mov r8d, [rsp + 168]
    inc r8d
    mov [rsp + 168], r8d
    xor r9d, r9d
    call Grimoire_NoiseHash
    and rax, 7
    shl rax, 4
    mov rcx, r10
    add rcx, rax
    movaps xmm0, [rcx]
    movaps xmm1, [rsp + 32]
    movaps xmm2, [rsp + 80]
    call Grimoire_Dot2
    movaps [rsp + 144], xmm0

    mov ecx, [rsp + 160]
    mov edx, [rsp + 164]
    inc edx
    mov r8d, [rsp + 168]
    xor r9d, r9d
    call Grimoire_NoiseHash
    and rax, 7
    shl rax, 4
    mov rcx, r10
    add rcx, rax
    movaps xmm0, [rcx]
    movaps xmm1, [rsp + 64]
    movaps xmm2, [rsp + 80]
    call Grimoire_Dot2

    movaps xmm1, xmm0
    movaps xmm0, [rsp + 144]
    movaps xmm2, [rsp + 96]
    call Grimoire_NoiseLerp

    movaps xmm1, xmm0
    movaps xmm0, [rsp + 128]
    movaps xmm2, [rsp + 112]
    call Grimoire_NoiseLerp
    mulps xmm0, [rel sqrt2]
    mulps xmm0, [rel half]
    addps xmm0, [rel half]
    add rsp, 184
    ret
MARKER Grimoire_Perlin2D_End

; END: Grimoire_Perlin2D -------------------------------------------------------

; START:  Grimoire_Perlin3D ----------------------------------------------------

GRIMOIRE_PUBLIC Grimoire_Perlin3D
    sub rsp, 248

    lea r10, [rel GRAD_3D]
    mov [rsp + 224], ecx

    roundps xmm3, xmm0, FLOOR
    roundps xmm4, xmm1, FLOOR
    roundps xmm5, xmm2, FLOOR

    cvtss2si edx, xmm3
    cvtss2si r8d, xmm4
    cvtss2si r9d, xmm5

    mov [rsp + 228], edx
    mov [rsp + 232], r8d
    mov [rsp + 236], r9d

    subps xmm0, xmm3
    subps xmm1, xmm4
    subps xmm2, xmm5

    movaps [rsp + 32], xmm0
    movaps [rsp + 48], xmm1
    movaps [rsp + 64], xmm2

    subps xmm0, [rel one]
    subps xmm1, [rel one]
    subps xmm2, [rel one]

    movaps [rsp + 80], xmm0
    movaps [rsp + 96], xmm1
    movaps [rsp + 112], xmm2

    movaps xmm0, [rsp + 32]
    call Grimoire_NoiseSmooth
    movaps [rsp + 128], xmm0

    movaps xmm0, [rsp + 48]
    call Grimoire_NoiseSmooth
    movaps [rsp + 144], xmm0

    movaps xmm0, [rsp + 64]
    call Grimoire_NoiseSmooth
    movaps [rsp + 160], xmm0

    call Grimoire_NoiseHash
    and rax, 15
    shl rax, 4
    mov rcx, r10
    add rcx, rax
    movaps xmm0, [rcx]
    movaps xmm1, [rsp + 32]
    movaps xmm2, [rsp + 48]
    movaps xmm3, [rsp + 64]
    call Grimoire_Dot3
    movaps [rsp + 176], xmm0

    mov ecx, [rsp + 224]
    mov edx, [rsp + 228]
    inc edx
    mov r8d, [rsp + 232]
    mov r9d, [rsp + 236]
    call Grimoire_NoiseHash
    and rax, 15
    shl rax, 4
    mov rcx, r10
    add rcx, rax
    movaps xmm0, [rcx]
    movaps xmm1, [rsp + 80]
    movaps xmm2, [rsp + 48]
    movaps xmm3, [rsp + 64]
    call Grimoire_Dot3
    movaps xmm1, xmm0
    movaps xmm0, [rsp + 176]
    movaps xmm2, [rsp + 128]
    call Grimoire_NoiseLerp
    movaps [rsp + 176], xmm0

    mov ecx, [rsp + 224]
    mov edx, [rsp + 228]
    mov r8d, [rsp + 232]
    inc r8d
    mov r9d, [rsp + 236]
    call Grimoire_NoiseHash
    and rax, 15
    shl rax, 4
    mov rcx, r10
    add rcx, rax
    movaps xmm0, [rcx]
    movaps xmm1, [rsp + 32]
    movaps xmm2, [rsp + 96]
    movaps xmm3, [rsp + 64]
    call Grimoire_Dot3    
    movaps [rsp + 192], xmm0

    mov ecx, [rsp + 224]
    mov edx, [rsp + 228]
    inc edx
    mov r8d, [rsp + 232]
    inc r8d
    mov r9d, [rsp + 236]
    call Grimoire_NoiseHash

    and rax, 15
    shl rax, 4
    mov rcx, r10
    add rcx, rax
    movaps xmm0, [rcx]
    movaps xmm1, [rsp + 80]
    movaps xmm2, [rsp + 96]
    movaps xmm3, [rsp + 64]
    call Grimoire_Dot3
    movaps xmm1, xmm0
    movaps xmm0, [rsp + 192]
    movaps xmm2, [rsp + 128]
    call Grimoire_NoiseLerp
    movaps xmm1, xmm0
    movaps xmm0, [rsp + 176]
    movaps xmm2, [rsp + 144]
    call Grimoire_NoiseLerp
    movaps [rsp + 176], xmm0

    mov ecx, [rsp + 224]
    mov edx, [rsp + 228]
    mov r8d, [rsp + 232]
    mov r9d, [rsp + 236]
    inc r9d
    mov [rsp + 236], r9d
    call Grimoire_NoiseHash
    and rax, 15
    shl rax, 4
    mov rcx, r10
    add rcx, rax
    movaps xmm0, [rcx]
    movaps xmm1, [rsp + 32]
    movaps xmm2, [rsp + 48]
    movaps xmm3, [rsp + 112]
    call Grimoire_Dot3
    movaps [rsp + 192], xmm0

    mov ecx, [rsp + 224]
    mov edx, [rsp + 228]
    inc edx
    mov r8d, [rsp + 232]
    mov r9d, [rsp + 236]
    call Grimoire_NoiseHash
    and rax, 15
    shl rax, 4
    mov rcx, r10
    add rcx, rax
    movaps xmm0, [rcx]
    movaps xmm1, [rsp + 80]
    movaps xmm2, [rsp + 48]
    movaps xmm3, [rsp + 112]
    call Grimoire_Dot3
    movaps xmm1, xmm0
    movaps xmm0, [rsp + 192]
    movaps xmm2, [rsp + 128]
    call Grimoire_NoiseLerp
    movaps [rsp + 192], xmm0

    mov ecx, [rsp + 224]
    mov edx, [rsp + 228]
    mov r8d, [rsp + 232]
    inc r8d
    mov [rsp + 232], r8d
    mov r9d, [rsp + 236]
    call Grimoire_NoiseHash
    and rax, 15
    shl rax, 4
    mov rcx, r10
    add rcx, rax
    movaps xmm0, [rcx]
    movaps xmm1, [rsp + 32]
    movaps xmm2, [rsp + 96]
    movaps xmm3, [rsp + 112]
    call Grimoire_Dot3
    movaps [rsp + 208], xmm0

    mov ecx, [rsp + 224]
    mov edx, [rsp + 228]
    inc edx
    mov r8d, [rsp + 232]
    mov r9d, [rsp + 236]
    call Grimoire_NoiseHash
    and rax, 15
    shl rax, 4
    mov rcx, r10
    add rcx, rax
    movaps xmm0, [rcx]
    movaps xmm1, [rsp + 80]
    movaps xmm2, [rsp + 96]
    movaps xmm3, [rsp + 112]
    call Grimoire_Dot3
    movaps xmm1, xmm0
    movaps xmm0, [rsp + 208]
    movaps xmm2, [rsp + 128]
    call Grimoire_NoiseLerp
    movaps xmm1, xmm0
    movaps xmm0, [rsp + 192]
    movaps xmm2, [rsp + 144]
    call Grimoire_NoiseLerp
    movaps xmm1, xmm0
    movaps xmm0, [rsp + 176]
    movaps xmm2, [rsp + 160]
    call Grimoire_NoiseLerp
    mulps xmm0, [rel half]
    addps xmm0, [rel half]
    add rsp, 248
    ret
MARKER Grimoire_Perlin3D_End

; END: Grimoire_Perlin3D -------------------------------------------------------

; START: Grimoire_Fbm ----------------------------------------------------------

GRIMOIRE_PUBLIC Grimoire_Fbm
    sub rsp, 136
    mov [rsp + 120], rbx
    mov [rsp + 128], rsi
    movaps [rsp + 32], xmm6
    movaps [rsp + 48], xmm7
    movaps [rsp + 64], xmm8
    movaps [rsp + 80], xmm9
    movaps [rsp + 96], xmm10
    movaps [rsp + 112], xmm11

    mov r10, r8
    mov r11d, edx

    mov rbx, rcx
    mov rsi, [r10 + Grimoire_FractalSettings_Octaves]

    movups xmm3, [r10 + Grimoire_FractalSettings_Frequency]
    mulps xmm0, xmm3
    mulps xmm1, xmm3
    mulps xmm2, xmm3

    xorps xmm6, xmm6
    movaps xmm7, [rel one]
    xorps xmm8, xmm8
    movaps xmm9, xmm0
    movaps xmm10, xmm1
    movaps xmm11, xmm2

.Grimoire_Fbm_Loop:
    mov ecx, r11d
    movaps xmm0, xmm9
    movaps xmm1, xmm10
    movaps xmm2, xmm11
    movups xmm3, [r10 + Grimoire_FractalSettings_Lacunarity]
    mulps xmm9, xmm3
    mulps xmm10, xmm3
    mulps xmm11, xmm3
    call rbx
    mulps xmm0, xmm7
    addps xmm6, xmm0
    addps xmm8, xmm7
    movups xmm3, [r10 + Grimoire_FractalSettings_Persistence]
    mulps xmm7, xmm3
    mov al, byte [r10 + Grimoire_FractalSettings_StaticSeed]
    not al
    and al, 1
    add r11d, eax

    dec rsi
    jnz .Grimoire_Fbm_Loop

    divps xmm6, xmm8
    movaps xmm0, xmm6

    movaps xmm6, [rsp + 32]
    movaps xmm7, [rsp + 48]
    movaps xmm8, [rsp + 64]
    movaps xmm9, [rsp + 80]
    movaps xmm10, [rsp + 96]
    movaps xmm11, [rsp + 112]
    mov rbx, [rsp + 120]
    mov rsi, [rsp + 128]
    add rsp, 136
    ret
MARKER Grimoire_Fbm_End

; END: Grimoire_Fbm ------------------------------------------------------------

; START: Grimoire_Billow -------------------------------------------------------

GRIMOIRE_PUBLIC Grimoire_Billow
    sub rsp, 136
    mov [rsp + 120], rbx
    mov [rsp + 128], rsi
    movaps [rsp + 32], xmm6
    movaps [rsp + 48], xmm7
    movaps [rsp + 64], xmm8
    movaps [rsp + 80], xmm9
    movaps [rsp + 96], xmm10
    movaps [rsp + 112], xmm11

    mov r10, r8
    mov r11d, edx

    mov rbx, rcx
    mov rsi, [r10 + Grimoire_FractalSettings_Octaves]

    movups xmm3, [r10 + Grimoire_FractalSettings_Frequency]
    mulps xmm0, xmm3
    mulps xmm1, xmm3
    mulps xmm2, xmm3

    xorps xmm6, xmm6
    movaps xmm7, [rel one]
    xorps xmm8, xmm8
    movaps xmm9, xmm0
    movaps xmm10, xmm1
    movaps xmm11, xmm2

.Grimoire_Billow_Loop:
    mov ecx, r11d
    movaps xmm0, xmm9
    movaps xmm1, xmm10
    movaps xmm2, xmm11
    movups xmm3, [r10 + Grimoire_FractalSettings_Lacunarity]
    mulps xmm9, xmm3
    mulps xmm10, xmm3
    mulps xmm11, xmm3
    call rbx
    mulps xmm0, [rel two]
    subps xmm0, [rel one]
    andps xmm0, [rel abs_mask]
    mulps xmm0, xmm7
    addps xmm6, xmm0
    addps xmm8, xmm7
    movups xmm3, [r10 + Grimoire_FractalSettings_Persistence]
    mulps xmm7, xmm3
    mov al, byte [r10 + Grimoire_FractalSettings_StaticSeed]
    not al
    and al, 1
    add r11d, eax

    dec rsi
    jnz .Grimoire_Billow_Loop

    divps xmm6, xmm8
    movaps xmm0, xmm6

    movaps xmm6, [rsp + 32]
    movaps xmm7, [rsp + 48]
    movaps xmm8, [rsp + 64]
    movaps xmm9, [rsp + 80]
    movaps xmm10, [rsp + 96]
    movaps xmm11, [rsp + 112]
    mov rbx, [rsp + 120]
    mov rsi, [rsp + 128]
    add rsp, 136
    ret
MARKER Grimoire_Billow_End

; END: Grimoire_Billow ---------------------------------------------------------

;-------------------------------------------------------------------------------
; Private Functions
;-------------------------------------------------------------------------------

section .text align=16

; START: Grimoire_WangHash -----------------------------------------------------

GRIMOIRE_PRIVATE Grimoire_WangHash
    ; ecx = uint32_t x
    mov eax, ecx
    xor eax, 61
    shr eax, 16
    xor eax, ecx
    imul eax, eax, 9
    mov ecx, eax
    shr ecx, 4
    xor eax, ecx
    imul eax, eax, 0x27d4eb2d
    mov ecx, eax
    shr ecx, 15
    xor eax, ecx
    ret
MARKER Grimoire_WangHash_End

; END: Grimoire_WangHash -------------------------------------------------------

; START: Grimoire_NoiseHash ----------------------------------------------------

GRIMOIRE_PRIVATE Grimoire_NoiseHash
    sub rsp, 40
    mov r10d, ecx
    mov ecx, edx
    call Grimoire_WangHash
    xor r10d, eax
    imul r10d, r10d, 0x27d4eb2d
    mov ecx, r8d
    call Grimoire_WangHash
    xor r10d, eax
    imul r10d, r10d, 0x165667b1
    mov ecx, r9d
    call Grimoire_WangHash
    xor r10d, eax
    imul r10d, r10d, 0x9e3779b1
    mov eax, r10d
    add rsp, 40
    ret
MARKER Grimoire_NoiseHash_End

; END: Grimoire_NoiseHash ------------------------------------------------------

; START: Grimoire_NoiseSmooth --------------------------------------------------

GRIMOIRE_PRIVATE Grimoire_NoiseSmooth
    movaps xmm2, xmm0
    mulps xmm0, xmm0
    movaps xmm1, xmm0
    mulps xmm0, xmm2
    
    mulps xmm1, [rel six]
    mulps xmm2, [rel fifteen]
    subps xmm1, xmm2
    addps xmm1, [rel ten]
    mulps xmm0, xmm1
    ret
MARKER Grimoire_NoiseSmooth_End

; END: Grimoire_NoiseSmooth ----------------------------------------------------

; START: Grimoire_NoiseLerp ----------------------------------------------------

GRIMOIRE_PRIVATE Grimoire_NoiseLerp
    subps xmm1, xmm0
    mulps xmm1, xmm2
    addps xmm0, xmm1
    ret
MARKER Grimoire_NoiseLerp_End

; END: Grimoire_NoiseLerp ------------------------------------------------------

; START: Grimoire_Dot2 ---------------------------------------------------------

GRIMOIRE_PRIVATE Grimoire_Dot2
    movaps xmm3, xmm0
    shufps xmm0, xmm0, 0b00_00_00_00
    shufps xmm3, xmm3, 0b01_01_01_01
    mulps xmm0, xmm1
    mulps xmm3, xmm2
    addps xmm0, xmm3
    ret
MARKER Grimoire_Dot2_End   

; END: Grimoire_Dot2 -----------------------------------------------------------

; START: Grimoire_Dot3 ---------------------------------------------------------

GRIMOIRE_PRIVATE Grimoire_Dot3
    movaps xmm4, xmm0
    movaps xmm5, xmm0
    shufps xmm0, xmm0, 0b00_00_00_00
    shufps xmm4, xmm4, 0b01_01_01_01
    shufps xmm5, xmm5, 0b10_10_10_10
    mulps xmm0, xmm1
    mulps xmm4, xmm2
    mulps xmm5, xmm3
    addps xmm0, xmm4
    addps xmm0, xmm5
    ret
MARKER Grimoire_Dot3_End

; END: Grimoire_Dot3 -----------------------------------------------------------