memcpy:
;-------------------
;�y�X�^�b�N�t���[���̍\�z�z
;-------------------
		;BP+8|�o�C�g��
		;BP+6|�R�s�[��
		;BP+4|�R�s�[��
		;----|---------
push bp		;BP+2|IP(�߂�l�Ԓn)
mov bp,ps	;BP+0|BP(���̒l)


;-------------------
;�y���W�X�^�̕ۑ��z
;-------------------
push cx
push si
push di


;-------------------
;�y�o�C�g�P�ʂł̃R�s�[�z
;-------------------
cld		;DF=0;+����
mov di,[bp + 4] ;DI = �R�s�[��
mov si,[bp + 6] ;SI = �R�s�[��
mov cx,[bp + 8] ;CX = �o�C�g��

req movsb	;while(*DI++ = *SI++)


;-------------------
;�y���W�X�^�̕��A�z�ۑ����̋t����pop
;-------------------
pop di
pop si
pop cx


;-------------------
;�y�X�^�b�N�t���[���̔j���z
;-------------------
mov sp,bp
pop bp

ret
