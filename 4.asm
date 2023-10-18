.386
.MODEL FLAT, STDCALL

; ��������� ������� ������� (��������) ����������� ���������� EXTERN,
; ����� ����� @ ����������� ����� ����� ������������ ����������,
; ����� ��������� ����������� ��� �������� ������� � ���������
EXTERN GetStdHandle@4: PROC
EXTERN WriteConsoleA@20: PROC
EXTERN CharToOemA@8: PROC
EXTERN ReadConsoleA@20: PROC
EXTERN ExitProcess@4: PROC; ������� ������ �� ���������
EXTERN lstrlenA@4: PROC; ������� ����������� ����� ������

.DATA; ������� ������
STRN DB "������� �����: ",13,10,0; ��������� ������, � ����� ���������
; ����������� �������: 13 � ������� �������, 10 � ������� �� �����
; ������, 0 � ����� ������; � �������������� ��������� DB
; ������������� ������ ������
DIN DD ?; ���������� �����; ��������� DD ����������� ������ �������
; 32 ���� (4 �����), ���� �?� ������������ ��� �������������������� ������
DOUT DD ?; ���������� ������
BUF DB 200 dup (?); ����� ��� ��������/��������� ����� ������ 200 ������
BUF2 DB 200 dup (?); ����� ��� ��������/��������� ����� ������ 200 ������
LENS1 DD ?; ���������� ��� ���������� ���������� ��������
LENS2 DD ?; ���������� ��� ���������� ���������� ��������
SIGN DD ?
SIGN2 DD ?
ZNAK DD ?
ZNAK2 DD ?
ZNAK_RES DW ?
CNTR DD ?
AHAHA DD ?
FLAG DB ?
S_16 DD 16
ERROR_STR	DB "��������� ������ � ������� ������", 0
ERROR_STR2	DB "�������� ������ �����", 0

.CODE; ������� ����
MAIN PROC; �������� ���������

MOV EAX, OFFSET ERROR_STR
PUSH EAX
PUSH EAX
CALL CharToOemA@8

MOV EAX, OFFSET ERROR_STR2
PUSH EAX
PUSH EAX
CALL CharToOemA@8

; ������������ ������ STRN
MOV EAX, OFFSET STRN; �������� MOV �������� ������� ��������
; ������������ � ������, OFFSET � ��������, ������������ �����
PUSH EAX; ��������� ������� ���������� � ���� �������� PUSH
PUSH EAX
CALL CharToOemA@8; ����� �������


; ������� ���������� �����
PUSH -10
CALL GetStdHandle@4
MOV DIN, EAX ; ����������� ��������� �� �������� EAX
; � ������ ������ � ������ DIN

; ������� ���������� ������
PUSH -11
CALL GetStdHandle@4
MOV DOUT, EAX
; ��������� ����� ������ STRN
PUSH OFFSET STRN; � ���� ���������� ����� ������
CALL lstrlenA@4; ����� � EAX

; ����� ������� WriteConsoleA ��� ������ ������ STRN
PUSH 0; � ���� ���������� 5-� ��������
PUSH OFFSET LENS1; 4-� ��������
PUSH EAX; 3-� ��������
PUSH OFFSET STRN; 2-� ��������
PUSH DOUT; 1-� ��������
CALL WriteConsoleA@20

; ���� ������
PUSH 0; � ���� ���������� 5-� ��������
PUSH OFFSET LENS1; 4-� ��������
PUSH 200; 3-� ��������
PUSH OFFSET BUF; 2-� ��������
PUSH DIN; 1-� ��������
CALL ReadConsoleA@20 ; �������� ��������: LENS ������ ����� ���������
; �������� �� ���, ������������� ��������� �������: 13 � ������� ������� �
; 10 � ������� �� ����� ������

; ���� ������
PUSH 0; � ���� ���������� 5-� ��������
PUSH OFFSET LENS2; 4-� ��������
PUSH 200; 3-� ��������
PUSH OFFSET BUF2; 2-� ��������
PUSH DIN; 1-� ��������
CALL ReadConsoleA@20 ; �������� ��������: LENS ������ ����� ���������
; �������� �� ���, ������������� ��������� �������: 13 � ������� ������� �
; 10 � ������� �� ����� ������

;����������� ������ � 10-��� �����
MOV DI, 10					; ��������� ������� ���������
DEC LENS1
DEC LENS1
MOV ECX, LENS1				; ������� ����� (������ ����� ����� LENS)
MOV ESI, OFFSET BUF			; ������ ������ �������� � ���������� BUF
XOR BX, BX					; �������� ������� BX �������� XOR, ����������� ������� �������� ������������ ���
XOR AX, AX					; �������� ������� AX

MOV BL, [ESI]				; ��������� ������ �� ��������� ������ � ������� BL, ��������� ��������� ���������
CMP BL, '-'
JNE PLUS
DEC LENS1
MOV ZNAK, 1
SUB BL, '-'
INC ESI
CMP LENS1, 3
JB ERROR2
CMP LENS1, 8
JA ERROR2
DEC ECX
JMP CONVERT
PLUS:
	MOV ZNAK, 0
	CMP LENS1, 3
	JB ERROR2
	CMP LENS1, 8
	JA ERROR2
CONVERT:					; ����� ������ ���� �����
	MOV BL, [ESI]				; ��������� ������ �� ��������� ������ � ������� BL, ��������� ��������� ���������
	SUB BL, '0'					; ������� �� ���������� ������� ��� ����
	CMP BL, 0
	JB ERROR
	CMP BL, 9
	JA ERROR
	MUL DI						; �������� �������� AX �� 10, ��������� � � AX
	ADD AX, BX					; �������� � ����������� � AX ����� ����� �����
	INC ESI						; ������� �� ��������� ������ ������
	LOOP CONVERT				; ������� �� ��������� �������� �����
CWDE
MOV CNTR, EAX
; � CNTR ����� ���� 10-��� �����


;����������� ������ � 10-��� �����

DEC LENS2
DEC LENS2
MOV ECX, LENS2				; ������� ����� (������ ����� ����� LENS)
MOV ESI, OFFSET BUF2			; ������ ������ �������� � ���������� BUF2
XOR BX, BX					; �������� ������� BX �������� XOR, ����������� ������� �������� ������������ ���
XOR AX, AX					; �������� ������� AX

MOV BL, [ESI]				; ��������� ������ �� ��������� ������ � ������� BL, ��������� ��������� ���������
CMP BL, '-'
JNE PLUS1
DEC LENS2
MOV ZNAK2, 1
SUB BL, '-'
INC ESI
CMP LENS2, 3
JB ERROR2
CMP LENS2, 8
JA ERROR2
DEC ECX
JMP CONVERT2
PLUS1:
	MOV ZNAK2, 0
	CMP LENS2, 3
	JB ERROR2
	CMP LENS2, 8
	JA ERROR2
CONVERT2:					; ����� ������ ���� �����
	MOV BL, [ESI]				; ��������� ������ �� ��������� ������ � ������� BL, ��������� ��������� ���������
	SUB BL, '0'					; ������� �� ���������� ������� ��� ����
	CMP BL, 0
	JB ERROR
	CMP BL, 9
	JA ERROR
	MUL DI						; �������� �������� AX �� 10, ��������� � � AX
	ADD AX, BX					; �������� � ����������� � AX ����� ����� �����
	INC ESI						; ������� �� ��������� ������ ������
	LOOP CONVERT2				; ������� �� ��������� �������� �����
			; ������� �� ��������� �������� �����
; B AX ����� ���� 10-��� �����

MOV EBX, CNTR
MOV ECX, ZNAK
MOV EDX, ZNAK2
CMP EBX, EAX ; � EBX ������ ����� B EAX ������
JA FIRST_BIGGER
JB SEC_BIGGER
JE EQUAL2
	FIRST_BIGGER:
		CMP ECX, EDX
		JA NEGATIVE11
		JB NEGATIVE22
		JE EQUAL123
		NEGATIVE11:
			CMP FLAG, 1
			JE SEB
			JNE SEB97
			SEB: 
				MOV ZNAK_RES, 0
				ADD EBX, EAX
				JMP EXIT000
			SEB97:
				MOV ZNAK_RES, 1
				ADD EBX, EAX
				JMP EXIT000
		NEGATIVE22:
			CMP FLAG, 1
			JE SEB2
			JNE SEB98
			SEB2:
				MOV ZNAK_RES, 1
				ADD EBX, EAX
				JMP EXIT000
			SEB98:
				MOV ZNAK_RES, 0
				ADD EBX, EAX
				JMP EXIT000
		EQUAL123:
			CMP ECX, 1
			JE METKA1
			JNE METKA2
			METKA1:
				CMP FLAG, 1
				JE SEB3
				JNE SEB99
				SEB3:
					MOV ZNAK_RES, 0
					SUB EBX,EAX
					JMP EXIT000
				SEB99:
					MOV ZNAK_RES, 1
					SUB EBX,EAX
					JMP EXIT000
			METKA2:
				CMP FLAG, 1
				JE SEB4
				JNE SEB100
				SEB4:
					MOV ZNAK_RES, 1
					SUB EBX, EAX
					JMP EXIT000
				SEB100:
					SUB EBX, EAX
					MOV ZNAK_RES, 0
					JMP EXIT000
	SEC_BIGGER:
		MOV FLAG, 1
		MOV EDI, EAX ;������ ������� �
		MOV EAX, EBX
		MOV EBX, EDI

		MOV EDI, ECX
		MOV ECX, EDX
		MOV EDX, EDI
		JMP FIRST_BIGGER
	EQUAL2:
		MOV EBX, 0
		MOV ZNAK_RES, 0
	EXIT000:


XOR ESI, ESI

SIXTEEN:
	MOV ESI, OFFSET BUF
	;MOV AHAHA, EAX
	XOR ECX, ECX
	CMP ZNAK_RES, 1
	JNE FUNC
	PUSH EAX
	MOV EAX, '-'
	MOV [ESI], EAX
	POP EAX
	INC ESI

	FUNC:	
	MOV EAX, EBX
	XOR EDX, EDX
	XOR EDI, EDI
	
	CONVERT_FROM10TO16:
		CMP EBX, S_16
		JAE FUNC1
		JB FUNC5
		FUNC1:
			DIV S_16
			ADD DX, '0'
		CMP DX, '9'
		JA FUNC2
		JBE FUNC3
		FUNC2:
			ADD DX, 7
		FUNC3:
			PUSH EDX ; ������ ������ � ����, ��� ��������������
			ADD EDI, 1
			XOR EDX, EDX
			XOR EBX,EBX
			MOV BX, AX
			MOV ECX, 2
	LOOP CONVERT_FROM10TO16
	FUNC5:
		ADD AX, '0'
		CMP AX, '9'
		JA FUNC6
		JBE FUNC7
		FUNC6:
			ADD AX, 7

	FUNC7:
		PUSH EAX ; ������ ������ � ����, ��� ��������������
		ADD EDI, 1
		MOV ECX, EDI
		CONVERTS:
			POP [ESI]
			INC ESI
		LOOP CONVERTS
		
PUSH OFFSET BUF
CALL lstrlenA@4
PUSH 0
PUSH OFFSET LENS1
PUSH EAX
PUSH OFFSET BUF
PUSH DOUT
CALL WriteConsoleA@20
PUSH 0
CALL ExitProcess@4

PUSH 0
CALL ExitProcess@4

ERROR:
	PUSH OFFSET ERROR_STR
	CALL lstrlenA@4
	PUSH 0
	PUSH OFFSET LENS1
	PUSH EAX
	PUSH OFFSET ERROR_STR
	PUSH DOUT
	CALL WriteConsoleA@20
	PUSH 0
	CALL ExitProcess@4

ERROR2:
	PUSH OFFSET ERROR_STR2
	CALL lstrlenA@4
	PUSH 0
	PUSH OFFSET LENS1
	PUSH EAX
	PUSH OFFSET ERROR_STR2
	PUSH DOUT
	CALL WriteConsoleA@20
	PUSH 0
	CALL ExitProcess@4

MAIN ENDP
END MAIN