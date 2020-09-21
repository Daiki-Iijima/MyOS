;--------------------------------------
; void itoa(num,buff,size,radix,flag)
;--------------------------------------
; 戻り値 : なし
; num    : 変換する値
; buff   : 保存先バッファアドレス
; size   : 保存先バッファサイズ
; radix  : 基数(2,8,10,16)を設定
; flags  : ビット定義のフラグ
;        : B2:空白を'0'で埋める
;        : B1:'+/-'記号を付加する
;        : B0:値を符号付き変数として扱う
;--------------------------------------

itoa:
    ;-------------------------------------
    ;【スタックフレームの構築】
    ; +12 | フラグ
    ; +10 | 基数
    ; +08 | バッファサイズ
    ; +06 | バッファアドレス
    ; +04 | 数値
    ; +02 | IP(戻り番地)
    ; BP+0| BP(元の値)
    ;-------------------------------------
    push bp
    mov bp,sp

    ;-------------------------------------
    ;【レジスタの保存】
    ;-------------------------------------
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    ;-------------------------------------
    ;【引数を取得】
    ; add : 第１オペランドに第２オペランドを足す
    ; dec : オペランドから1を引く
    ;-------------------------------------
    mov ax,[bp + 4]     ;数値
    mov si,[bp + 6]     ;バッファアドレス
    mov cx,[bp + 8]     ;バッファサイズ

    ;------ バッファの最後尾を取得 ------
    mov di,si           ;di = バッファアドレス
    add di,cx           ;バッファアドレス(di) + バッファサイズ(cx)
    dec di              ;バッファサイズ - 1

    mov bx,word[bp + 12];flags = オプション
    
;-----------------------
;【符号付き判定】
; je  : ZF = 1
; jge : 符号付き演算の場合の判定
;-----------------------

    test bx,0b0001      ;if(flags & 0x01)   // 最下位ビットを検査(符号付きの場合True)
.10Q: je  .10E          ;{
    cmp ax,0            ;    if(val < 0)
.12Q: jge .12E          ;    {
    or bx,0b0010        ;       flags |= 2; //  NEG命令(2の補数)符号表示
.12E:                   ;    }
.10E:                   ;}

;------------------------
;符号出力判定
;------------------------
    test bx,0b0010      ;if(flags & 0x02)   //  符号出力判定
.20Q: je .20E           ;{
    cmp ax,0            ;   if(val < 0)
.22Q: jge .22F          ;   {
    neg ax              ;       val *= -1;  //  符号反転
    mov [si],byte'-'    ;       *dst ='-';  //  符号表示
    jmp .22E            ;   }
.22F:                   ;   else{
    mov [si],byte'+'    ;       *dst='+';  //  符号表示
.22E:                   ;   }
    dec cx              ;   size-;             //  残りバッファサイズの減算
.20E:                   ;}

;------------------------
;ASCII変換
;div命令 : 【割り算】の答えと【余り】のために別々のレジスタに格納される
;------------------------
;cmp命令 : 第1オペランドと第二オペランドの引き算をして、結果を破棄し結果に基づいてフラグレジスタをセットする
;loopnz命令 : ECX（CX）をカウンタとして使用して、ループ操作を実行 
;             フラグレジスタの状態が【ZF=0】かつカウンタ
;------------------------
    mov bx,[bp + 10]            ;BX = 基数;
.30L:                           ;do{
    mov dx,0                    ;DX =0;
    div bx                      ;DX = DX:AX % 基数;
                                ;AX = DX:AX / 基数;
    mov si,dx                   ;テーブル参照
    mov dl,byte[.ascii + si]    ;DL = ASCII[DX];

    mov [di],dl                 ;*dst = DL;
    dec di                      ;dst--;

    cmp ax,0                    ;ax(変換対象)の値が0かチェック
    loopnz .30L                 ;}while(AX);
.30E:


;--------------------------
;空欄を埋める
;--------------------------
    cmp cx,0                    ;if(size)
.40Q:   je  .40E                ;{
    mov al,' '                   ;   AL = '';// 空白で埋める(デフォルト値)
    cmp [bp + 12],word 0b0100   ;   if(flags & 0x04)
.42Q:   jne .42E                ;   {
    mov al,'0'                          ;AL = '0';
.42E:                           ;   }
    std                         ;   DF = 1
    rep stosb                   ;   while(--CX)*DI--='';
.40E:                           ;}

    ;-------------------------------------
    ;【レジスタの保存】
    ;-------------------------------------
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax

    ;-------------------------------------
    ;【スタックフレームの破棄】
    ;-------------------------------------
    mov sp,bp
    pop bp

    ret

;--------------------------
;変換テーブル
;db疑似命令 : オペランドで指定された初期値で，メモリをバイト単位で初期化
;--------------------------
.ascii db "0123456789ABCDEF"
