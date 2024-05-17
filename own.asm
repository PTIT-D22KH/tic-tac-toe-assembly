.MODEL SMALL
.STACK 500H
.DATA 
NHAN_PHIM_BAT_KY DB 'Nhan phim bat ky de tiep tuc/bat dau....$'
; LUAT CHOI
R DB 'Luat choi Tic Tac Toe:$' 
R1 DB '1. Moi nguoi choi theo luot$'
R2 DB '2. Player 1 se choi truoc$'
R3 DB '3. Player 1 se la "X" va Player 2 se la "O".$'
R4 DB '4. Bang se duoc danh so$'
R5 DB '5. Nhap so tuong ung voi vi tri minh muon danh $'
R6 DB '6. Nguoi dau tien co 3 dau o hang doc, ngang hoac duong cheo se thang $'
R7 DB '7. Chuc ban may man!$'


; DANH DAU
PLAYER1 DB ' (X)$'
PLAYER2 DB ' (O)$' 

; DANH SO O
C1 DB '1$'
C2 DB '2$'
C3 DB '3$'
C4 DB '4$'
C5 DB '5$'
C6 DB '6$'
C7 DB '7$'
C8 DB '8$'
C9 DB '9$'

;DONG KE
L1 DB '   |   |   $'
L2 DB '-----------$';
N1 DB ' | $'

; PHAN INPUT
NHAP DB 32, '|| Nhap o ban muon danh: $'
DA_DANH DB 'O nay da danh! Nhan phim bat ky ...$'

; NGUOI CHOI, NUOC DI, FLAG
PLAYER DB 50, '$'
MOVES DB 0
DONE DB 0
DRAW_CHECK DB 0

; CURSOR(X / 0)
CURSOR DB 88 ; KHOI TAO CON TRO = 'X'


; FINAL MESSAGES
W1 DB 'Player $'
W2 DB ' chien thang!$'
DRAW_RES DB '         Hoa!$'

; NHAP LAI
CHOI_LAI_K DB 'Ban muon choi lai khong ? (y/n): $'
NHAP_SAI DB 32, 32, 32, 'Nhap sai! Nhan bat ky de tiep tuc...$'

;DONG THUA
EMPTY DB '                                                     $'



;-----------MACRO------------------- 


XOA_MAN_HINH_MACRO MACRO
    MOV AX, 0600H
    MOV BH, 07H
    MOV CX, 0000H
    MOV DX, 184FH
    INT 10H
ENDM
                                    
CHECK_CELL_MACRO MACRO cell
    CMP cell, 88  ; KIEM TRA XEM O DO CO BANG 'X' KHONG
    JE TAKEN
    CMP cell, 79  ; KIEM TRA XEM O DO CO BANG 'O' KHONG
    JE TAKEN
    MOV cell, CL
    JMP CHECK
ENDM            


DAT_CON_TRO_MACRO MACRO hang, cot
    MOV AH, 2
    MOV DH, hang
    MOV DL, cot
    INT 10H
ENDM

IN_DONG_MACRO MACRO luat
    LEA DX, luat
    MOV AH, 9
    INT 21H
ENDM     

IN_DAU_CACH_MACRO MACRO
    MOV AH, 2
    MOV DL, 32
    INT 21H
ENDM 

NHAP_KI_TU_MACRO MACRO
    MOV AH, 7
    INT 21H
ENDM 

MOV_MACRO MACRO C1, C2, C3
    MOV AL, C1
    MOV BL, C2 
    MOV CL, C3            
ENDM

DONE_BOARD_MACRO MACRO 
    MOV DONE, 1
    JMP BOARD    
ENDM 

DAT_CON_TRO_3_MACRO MACRO b, c, d 
    MOV AH, 2
    MOV BH, b
    MOV DH, c
    MOV DL, d
    INT 10H
ENDM 

NHAP_KI_TU_AH1_MACRO MACRO
    MOV AH, 1
    INT 21H
    ;KET QUA LUU VAO AL
ENDM 
                                    
;---------END MACRO-----------------

;--------------------------------------------------------------
.CODE
MAIN PROC    
    MOV AX, @DATA
    MOV DS, AX    
    LUAT_CHOI:
        ;SET CURSOR DUNG HAM NGAT 10H/AH = 2
        DAT_CON_TRO_3_MACRO 0,6,7         
        ; IN RA DONG R
        IN_DONG_MACRO R             
        ;SET CURSOR
        DAT_CON_TRO_MACRO 7, 7                      
        IN_DONG_MACRO R1        
        DAT_CON_TRO_MACRO 8,7
        IN_DONG_MACRO R2 
        DAT_CON_TRO_MACRO 9,7
        IN_DONG_MACRO R3
        DAT_CON_TRO_MACRO 10,7
        IN_DONG_MACRO R4
        DAT_CON_TRO_MACRO 11,7
        IN_DONG_MACRO R5    
        DAT_CON_TRO_MACRO 12,7
        IN_DONG_MACRO R6
        DAT_CON_TRO_MACRO 13, 7 
        IN_DONG_MACRO R7
        DAT_CON_TRO_MACRO 15, 7
        IN_DONG_MACRO NHAN_PHIM_BAT_KY        
        NHAP_KI_TU_MACRO
; KET THUC PHAN GIOI THIEU LUAT CHOI------------
; --- ------- KHOI TAO ------------        
    INIT:
        MOV PLAYER, 50
        MOV MOVES, 0
        MOV DONE, 0
        MOV DRAW_CHECK, 0
        
        MOV C1, 49 ; GIA TRI '1' TRONG ASCII
        MOV C2, 50 ; '2'
        MOV C3, 51 ; '3'
        MOV C4, 52
        MOV C5, 53
        MOV C6, 54
        MOV C7, 55
        MOV C8, 56
        MOV C9, 57
        
        JMP PLAYER_CHANGE
; ---------KET THUC KHOI TAO -------------

;-------------HIEN THI DONG CHU CHIEN THANG ------------

    VICTORY:
        
        IN_DONG_MACRO W1
        
        IN_DONG_MACRO PLAYER
        IN_DONG_MACRO W2
        
        DAT_CON_TRO_MACRO 17,28
        IN_DONG_MACRO NHAN_PHIM_BAT_KY
        NHAP_KI_TU_MACRO
        
        JMP THU_LAI
        
;-------------------KET THUC PHAN CHIEN THANG -------------   

;----KIEM TRA XEM DA THANG CHUA------

    CHECK:
        
        CHECK1:  ; CHECKING 1, 2, 3 
            MOV_MACRO C1, C2,C3
            
            CMP AL, BL
            JNE CHECK2
            
            CMP BL, CL
            JNE CHECK2
            
            DONE_BOARD_MACRO
            
        CHECK2:  ; CHECKING 4, 5, 6 
            MOV_MACRO C4, C5,C6
            
            CMP AL, BL
            JNE CHECK3
            
            CMP BL, CL
            JNE CHECK3
            
          
            DONE_BOARD_MACRO
            
           
       CHECK3:  ; CHECKING 7, 8, 9
            MOV_MACRO C7,C8,C9
            
            CMP AL, BL
            JNE CHECK4
            
            CMP BL, CL
            JNE CHECK4 
            
            DONE_BOARD_MACRO
            
             
       CHECK4:   ; CHECKING 1, 4, 7
            MOV_MACRO C1, C4,C7
            
            CMP AL, BL
            JNE CHECK5
            
            CMP BL, CL
            JNE CHECK5
        
            DONE_BOARD_MACRO
        
       
       CHECK5:   ; CHECKING 2, 5, 8
            MOV_MACRO C2, C5,C8
            
            CMP AL, BL
            JNE CHECK6
            
            CMP BL, CL
            JNE CHECK6
        
            DONE_BOARD_MACRO
            
       
       CHECK6:   ; CHECKING 3, 6, 9
            MOV_MACRO C3,C6,C9
            
            CMP AL, BL
            JNE CHECK7
            
            CMP BL, CL
            JNE CHECK7
        
            DONE_BOARD_MACRO
            
        
        CHECK7:   ; CHECKING 1, 5, 9
            MOV_MACRO C1, C5, C9
            
            CMP AL, BL
            JNE CHECK8
            
            CMP BL, CL
            JNE CHECK8
        
            DONE_BOARD_MACRO
        CHECK8:   ; CHECKING 3, 5, 7
            MOV_MACRO C3, C5, C7
            
            CMP AL, BL
            JNE KIEM_TRA_DRAW
            
            CMP BL, CL
            JNE KIEM_TRA_DRAW
            
            DONE_BOARD_MACRO   
        
    KIEM_TRA_DRAW:
        MOV AL, MOVES
        CMP AL, 9
        JL PLAYER_CHANGE
        
        MOV DRAW_CHECK, 1
        JMP BOARD
        
        JMP EXIT

;--------------HOA-------------

    DRAW:
        IN_DONG_MACRO DRAW_RES
        DAT_CON_TRO_MACRO 17, 28
        IN_DONG_MACRO NHAN_PHIM_BAT_KY    
        NHAP_KI_TU_MACRO
        
        JMP THU_LAI
            
;----------------NGUOI CHOI---------
    PLAYER_CHANGE: 
        ; DOI LUOT CUA 2 NGUOI CHOI
        ; VI DU X DANH THI DEN LUOT O
        CMP PLAYER, 49 ; GIA TRI '1' TRONG ASCII
        JE P2
        CMP PLAYER, 50 ;'2'
        JE P1
        
    P1:
        MOV PLAYER, 49 ;'1'
        MOV CURSOR, 88 ; 'X'
        
        JMP BOARD
        
    P2:
        MOV PLAYER, 50 ;'2'
        MOV CURSOR, 79 ; 'O'
        JMP BOARD
;-------------------KET THUC PHAN NGUOI CHOI---------------

;--------------------BOARD----------------
         
    BOARD:
        
        ;XOA MAN HINH 
        XOA_MAN_HINH_MACRO
        DAT_CON_TRO_3_MACRO 0,6,30
        IN_DONG_MACRO L1
        DAT_CON_TRO_MACRO 7,30
        
        IN_DAU_CACH_MACRO         
        
        
        ; CELL 1
        IN_DONG_MACRO C1
        IN_DONG_MACRO N1
        ;CELL 2
        IN_DONG_MACRO C2
        IN_DONG_MACRO N1
        ;CELL 3
        IN_DONG_MACRO C3
        DAT_CON_TRO_MACRO 8, 30
        IN_DONG_MACRO L2
        DAT_CON_TRO_MACRO 9,30
        IN_DONG_MACRO L1
        DAT_CON_TRO_MACRO 10,30
        IN_DAU_CACH_MACRO
        ;CELL 4
        IN_DONG_MACRO C4
        IN_DONG_MACRO N1
        ;CELL 5
        IN_DONG_MACRO C5
        IN_DONG_MACRO N1
        ;CELL 6
        IN_DONG_MACRO C6
        DAT_CON_TRO_MACRO 11, 30
        IN_DONG_MACRO L1
        DAT_CON_TRO_MACRO 12,30
        IN_DONG_MACRO L2
        DAT_CON_TRO_MACRO 13, 30 
        IN_DONG_MACRO L1
        DAT_CON_TRO_MACRO 14,30
        IN_DAU_CACH_MACRO
        ;CELL 7
        IN_DONG_MACRO C7
        IN_DONG_MACRO N1
        ;CELL8
        IN_DONG_MACRO C8
        IN_DONG_MACRO N1
        ;CELL 9
        IN_DONG_MACRO C9
        DAT_CON_TRO_MACRO 15,30  
        IN_DONG_MACRO L1
        DAT_CON_TRO_MACRO 16,20
        
        CMP DONE, 1
        JE VICTORY
        
        CMP DRAW_CHECK, 1
        JE DRAW
;---------------------KET  THUC PHAN BOARD--------------------------   

        
; -----------------INPUT---------------------

    INPUT:
        ;IN RA W1
        IN_DONG_MACRO W1
        
        
        ; LAY GIA TRI HIEN TAI CUA PLAYER DE IN RA MAN HINH
        MOV AH, 2
        MOV DL, PLAYER
        INT 21H
        
        
        CMP PLAYER, 49
        JE PL1  
        
        IN_DONG_MACRO PLAYER2; YEU CAU PLAYER2 NHAP O MUON DANH
        JMP NHAP_O
            
            
    PL1:
        IN_DONG_MACRO PLAYER1 ;YEU CAU PLAYER1 NHAP O MUON DANH
        
        
    NHAP_O:
        IN_DONG_MACRO NHAP
        
        NHAP_KI_TU_AH1_MACRO
        
        
        INC MOVES; MOVES = MOVES + 1
        
        MOV BL, AL
        SUB BL, 48; TRU DI '0' DE LAY GIA TRI
        
        MOV CL, CURSOR ; CL = CURSOR ( X / O)
        
        
        ;KIEM TRA DAU VAO CO HOP LE K (TU 1 - 9)
        CMP BL, 1
        JE C1U
        
        CMP BL, 2
        JE C2U
        
        CMP BL, 3
        JE C3U
        
        CMP BL, 4
        JE C4U
        
        CMP BL, 5
        JE C5U
        
        CMP BL, 6
        JE C6U
        
        CMP BL, 7
        JE C7U
        
        CMP BL, 8
        JE C8U
        
        CMP BL, 9
        JE C9U 
        
        ;NEU KHONG HOP LE:
        
        DEC MOVES ; TRU DI 1 VI KHONG HOP LE
        
        DAT_CON_TRO_MACRO 16, 20
        
        
        ;HIEN THI LOI NHAN NEU NHAP SAI
            
        IN_DONG_MACRO NHAP_SAI
           
        NHAP_KI_TU_MACRO
        
        DAT_CON_TRO_MACRO 16, 20
            
        IN_DONG_MACRO EMPTY
        
        
        DAT_CON_TRO_MACRO 16, 20
            
        JMP INPUT    
        
    TAKEN: ; O DA DUOC DANH
        DEC MOVES;
        DAT_CON_TRO_MACRO 16,20
        IN_DONG_MACRO DA_DANH
        NHAP_KI_TU_MACRO
        DAT_CON_TRO_MACRO 16,20
        IN_DONG_MACRO EMPTY
        DAT_CON_TRO_MACRO 16, 20
        JMP INPUT   
        ;KIEM TRA VI TRI
    
        C1U:
            CHECK_CELL_MACRO C1
        C2U:
            CHECK_CELL_MACRO C2
        C3U:
            CHECK_CELL_MACRO C3
        C4U:
            CHECK_CELL_MACRO C4
        C5U:
            CHECK_CELL_MACRO C5
        C6U:
            CHECK_CELL_MACRO C6
        C7U:
            CHECK_CELL_MACRO C7
        C8U:
            CHECK_CELL_MACRO C8
        C9U:
            CHECK_CELL_MACRO C9
        ;KET THUC KIEM TRA VI TRI
     
     
    ; -----THU LAI----------
    THU_LAI:
        ;XOA MAN HINH
        
        XOA_MAN_HINH_MACRO
        
        
        
        ;DAT CON TRO
        DAT_CON_TRO_3_MACRO 0, 10, 24
        
        
        IN_DONG_MACRO CHOI_LAI_K ;HOI CO MUON CHOI LAI K
        
        
        NHAP_KI_TU_AH1_MACRO; NHAP KI TU                                  
        
        
        ;NEU LA Y HOAC 'y' THI BAT DAU LAI
        CMP AL, 121 ; AL ? 'y'
        JE INIT
        
        CMP AL, 89; AL ? 'Y'
        JE INIT           
        
        
        ;NEU LA N hoac 'n' THI KET THUC CHUONG TRINH
        CMP AL, 110; AL ? 'n'
        JE EXIT
        CMP AL, 78
        JE EXIT 
        
        
        ;NEU K HOP LE
    
        ;DAT CON TRO
        DAT_CON_TRO_3_MACRO 0, 10, 24
        
        IN_DONG_MACRO NHAP_SAI
        
        NHAP_KI_TU_MACRO
    
        ;DAT CON TRO
        DAT_CON_TRO_3_MACRO 0, 10, 24
    
    
        IN_DONG_MACRO EMPTY ; IN DONG TRONG RA MAN HINH
        
        JMP THU_LAI
             
;--------KET THUC NHAP----------    
    EXIT:
    
        MOV AH, 4CH
        INT 21H
    
     
    MAIN ENDP 
END MAIN