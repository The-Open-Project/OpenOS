[BITS 32]

[section .text]

[global _internal_memcpy]
[global _internal_memset]

; param 1 - dest
; param 2 - src
; param 3 - num bytes
_internal_memcpy:
    push ebp
    mov ebp, esp

    push esi
    push edi

    mov esi, [ebp + 12]
    mov edi, [ebp + 8]
    mov ecx, [ebp + 16]
    cld

    rep movsb

    pop edi
    pop esi

    mov esp, ebp
    pop ebp
    ret

; param 1 - dest
; param 2 - fill
; param 3 - num bytes
_internal_memset:
    push ebp
    mov ebp, esp

    push edi

    mov eax, [ebp + 12]
    mov edi, [ebp + 8]
    mov ecx, [ebp + 16]
    cld
    
    rep stosd

    pop edi

    mov esp, ebp
    pop ebp
    ret
