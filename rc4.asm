.CODE

RC4_Crypt	PROC	lpText:DWORD, lpKey:DWORD, dwSize:DWORD
LOCAL	i:DWORD, j:DWORD, z:DWORD
S db 256 dup (?)
K db 256 dup (?)
	pushad
    mov	edi, lpKey		
    mov ecx, 256
    xor	eax, eax
    repnz scasb									
    mov	eax, 255
    sub eax, ecx
	xchg eax, edi
	xor	eax, eax
	xor	esi, esi
	mov	ecx, lpKey	
	.WHILE	eax<256								
		mov byte ptr [offset S+eax], al
		mov bl, byte ptr [ecx+esi]
		mov byte ptr [offset K+eax], bl
		inc eax
		inc esi
		.IF esi==edi
			xor esi, esi
		.ENDIF
	.ENDW
	xor	ecx, ecx
	.WHILE ecx<256							
		xor ebx, ebx
		xor edx, edx
		mov bl, byte ptr [offset S+ecx]
		mov dl, byte ptr [offset K+ecx]
		add	ebx, edx					
		mov eax, j
		add	eax, ebx					
		mov ecx, 256
		xor	edx, edx
		div ecx									
		mov j, edx
		mov ecx, i
		mov	bl, byte ptr [offset S+ecx]			
		mov	al, byte ptr [offset S+edx]
		mov	byte ptr [offset S+edx], bl
		mov byte ptr [offset S+ecx], al
		inc ecx
		mov i, ecx
	.ENDW
	mov i, 0
	mov j, 0
	mov	esi, lpText
	mov	edi, dwSize
	.WHILE	!edi==z
		mov eax, i
		add eax, 1			
		xor edx, edx
		mov ecx, 256
		div ecx									
		mov i, edx
		xor ebx, ebx
		mov bl, byte ptr [offset S+edx]
		mov eax, j
		add eax, ebx
		xor edx, edx
		div ecx
		mov j, edx
		mov ecx, i
		mov	bl, byte ptr [offset S+ecx]
		mov	al, byte ptr [offset S+edx]
		mov	byte ptr [offset S+edx], bl
		mov byte ptr [offset S+ecx], al		
		add eax, ebx
		mov ecx, 256
		xor edx, edx
		div ecx
		mov al, byte ptr [offset S+edx]
		xor byte ptr [esi], al
		inc esi
		inc	z
	.ENDW
	mov j, 0
	mov i, 0
	mov	z, 0
	popad
	ret
RC4_Crypt	ENDP