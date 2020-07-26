entry:
	jmp	$		;while (1);//–³ŒÀƒ‹[ƒv

	times 510 - ($ - $$) db 0x00
	db 0x55, 0xAA
