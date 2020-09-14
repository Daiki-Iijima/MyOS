;************************
; void puts(str)
;************************
; 戻り値 | なし
; str	 | 文字列アドレス
;************************

puts:

;------------------------
;【スタックフレームの構築】
;------------------------
; +4 	 | 文字列へのアドレス
; +2 	 | IP(戻り番地)
; BP + 0 | BP(元の値)
;--------|------------

push bp
mov bp,sp

;------------------------
;【レジスタの保存】
;------------------------
push ax
push bx
push si

;------------------------
;【引数を取得】
;------------------------
mov si,[bp + 4]

;------------------------
;【処理の開始】
;------------------------
mov ah,0x0E
mov bx,0x0000
cld         ;DFフラグを0に設定して、[lodsb命令の時に]アドレスを加算

.10L:       ;do{
lodsb       ;   AL = *SI++;
cmp al,0    ;   if(0 == AL)
je  .10E    ;       break;
int 0x10    ;   Int10(0x0E,AL); // 文字出力
jmp .10L    ;
.10E:       ;}while(1);
;------------------------
;【レジスタの復帰】
;------------------------
pop si
pop bx
pop ax
;------------------------
;【スタックフレームの破棄】
;------------------------
mov sp,bp
pop bp

ret