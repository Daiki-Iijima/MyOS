BOOT_LOAD equ 0x7C00		;�u�[�g�v���O�����̃��[�h�ʒu

ORG BOOT_LOAD			;���[�h�A�h���X���A�Z���u���Ɏw�� (1�x�����w���ł��Ȃ�)

;****************************************************
;�y�G���g���|�C���g�z
;****************************************************

entry:


;----------------------------
;�yBPB(BIOS Parameter Block)�z
;----------------------------
jmp	ipl		;IPL�փW�����v
times 90 - ($ - $$) db 0x90


;----------------------------
;�yIPL(Initial Program Loader)�z
;----------------------------
ipl:
	cli			;���荞�ݏ����ɍ��͑Ή����Ă��Ȃ��̂ŁA���荞�ݏ������֎~�ɂ���
	
	mov ax,0x0000		;AX = 0x0000
	mov ds,ax		;DS = 0x0000
	mov es,ax		;ES = 0x0000
	mov ss,ax		;SS = 0x0000
	mov sp,BOOT_LOAD	;SP = 0x7C00

	sti			;���荞�݋���

	mov [BOOT.DRIVE],dl	;�u�[�g�h���C�u��ۑ�
	
	
	push word 'A'
	call putc
	add sp,2

	push word 'B'
	call putc
	add sp,2

	push word 'C'
	call putc
	add sp,2

	jmp $			;while(1); // �������[�v

ALIGN 2,db 0			;�f�[�^��2�o�C�g���E�Ŕz�u����悤�Ɏw��
BOOT:				;�u�[�g�h���C�u�Ɋւ�����
.DRIVE:		dw 0		;�h���C�u�ԍ�


;------------------------
;�y���W���[���z
;------------------------
%include "..\modules\real\putc.s"

;****************************************************
;�y�u�[�g�t���O�z(�擪512�o�C�g�̏I��)
;****************************************************
times 510 - ($ - $$) db 0x00
db 0x55,0xAA
