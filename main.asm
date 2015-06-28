   .486                                      ; create 32 bit code
      .model flat, stdcall                      ; 32 bit memory model
      option casemap :none                      ; case sensitive 

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\gdi32.inc
include \masm32\include\masm32.inc 
includelib \masm32\lib\masm32.lib
;include \masm32\include\masm32rt.inc

;include new_counter.asm
.const
RECT_SIZE	equ	3
RECT_SIZE	equ	3
WINDOW_WIDTH	equ	800
WINDOW_HEIGHT	equ	600
LEFT	equ	1
RIGHT	equ	2
UP		equ	3
DOWN	equ	4
MAIN_TIMER_ID equ 0

.data
szFmt       db  "%#08x", 0
Buf         db  12 dup (?)
randomnumX DWORD	0
randomnumY DWORD	0

srandomnumX DWORD	0
srandomnumY DWORD	0
once DWORD 0

ScoreX DWORD	0
ScoreY DWORD	0

gamesp DWORD 100
newcounter DWORD 0


scoreText DB "Score:      ", 0 ;Text to show the score
	
score DWORD 0 ; acual score of player

play DWORD 1
counter DWORD 0
turntimes DWORD 0
Direction DWORD 3
Lenght DWORD 0
PlayerX	DWORD	400
PlayerY	DWORD	400
;Facing	DWORD	LEFT	;1	-	Right,	2	-Down,	3	-	Left,	4	-	Up
ClassName	DB	"TheClass",0
windowTitle	DB	"millen!",0
currentX DWORD 400
currentY DWORD 400
numTimesPaint DWORD 0
first DWORD 0
ngrow DWORD 1
counter2 DWORD 0
colision DWORD 0
 
snakepos DWORD 400, 400 , 415 ,400, 430, 400, 445,400,460,40 dup(0) ; [esi + ecx * c] mov esi , ofset snakepos
;jmp back

.code

;start:


DRAWRECT	PROC,	x:DWORD,	y:DWORD, h:DWORD,	w:DWORD,	hdc:HDC,	brush:HBRUSH
LOCAL rectangle:RECT
mov eax, x 
mov rectangle.left, eax
add eax, w
mov	rectangle.right, eax

mov eax, y
mov	rectangle.top, eax
add	eax,	h
mov rectangle.bottom, eax

invoke FillRect, hdc, addr rectangle, brush
ret
DRAWRECT ENDP


invoke GetTickCount
invoke nseed, eax


long PROC

mov esi, offset snakepos
mov edi, 1
mov ebx, 0
.while edi != 0
add ebx, 1

mov edi, [esi + 4  +  ebx * 8]
.endw




ret
long ENDP




Grow PROC, lenght:DWORD, x:DWORD, y:DWORD

	invoke long
	sub gamesp, 4
	add score, 1	


	mov counter, 0
	mov counter, ebx
	add counter, ebx
	mov edi, counter
	mov edx, counter
	
	mov ecx, [esi]
	mov ecx, [esi + 4 ]
	mov ecx, [esi + 8 ]
	mov ecx, [esi+ 12 ]
	mov ecx, [esi+ 16]
	mov ecx, [esi+ 20]
	mov ecx, [esi+ 24]
	mov ecx, [esi + 28]
	mov ecx, [esi + 32]
	mov ecx, [esi + 36]
	mov ecx, [esi+ 40 ]


	.while edx > 0
		
		mov ebx, [esi +  (edx) * 4]
		mov [esi +  (edx) * 4 + 8] , ebx
		sub edx, 1

	.endw
	
	mov edx, [esi]
	mov [esi + 8], edx
	
	mov ecx, [esi]
	mov ecx, [esi + 4 ]
	mov ecx, [esi + 8 ]
	mov ecx, [esi+ 12 ]
	mov ecx, [esi+ 16]
	mov ecx, [esi+ 20]
	mov ecx, [esi+ 24]
	mov ecx, [esi + 28]
	mov ecx, [esi + 32]
	mov ecx, [esi + 36]
	mov ecx, [esi+ 40 ]
	
.if Direction == RIGHT
	mov esp, [esi]
	add esp, 15
	mov [esi], esp

	mov esp, [esi + 4]
	mov [esi + 4], esp 

.endif

.if Direction == LEFT
mov esp, x 
sub esp, 15
mov [esi ], esp 

mov esp, y
mov [esi + 4], esp 

.endif

.if Direction == UP
mov esp, x 
mov [esi],  esp

mov esp, y 
sub esp, 15
mov [esi + 4], esp 

.endif

.if Direction == DOWN
mov esp, x
mov [esi],  esp

mov esp, y
add esp, 15
mov [esi + 4], esp 

.endif

mov ecx, [esi]
mov ecx, [esi + 4 ]
mov ecx, [esi + 8 ]
mov ecx, [esi+ 12 ]
mov ecx, [esi+ 16]
mov ecx, [esi+ 20]
mov ecx, [esi+ 24]
mov ecx, [esi + 28]
mov ecx, [esi + 32]
mov ecx, [esi + 36]
mov ecx, [esi+ 40 ]
	



ret
	Grow ENDP


Restart PROC,

invoke long
mov counter, ebx 
add counter, ebx

mov Direction, 3
.while counter > 0

mov eax, counter
mov edx, 0
mov [esi + eax * 4], edx
sub counter, 1
.endw
mov [esi], edx



mov edx, 400
mov  [esi], edx
mov [esi + 4 ], edx
mov  [esi + 8 ], edx
mov edx, 415

mov  [esi+ 12 ], edx


mov ecx, [esi]
mov ecx, [esi + 4 ]
mov ecx, [esi + 8 ]
mov ecx, [esi+ 12 ]
mov ecx, [esi+ 16]
mov ecx, [esi+ 20]
mov ecx, [esi+ 24]
mov ecx, [esi + 28]
mov ecx, [esi + 32]
mov ecx, [esi + 36]
mov ecx, [esi+ 40 ]

mov gamesp, 80
invoke Grow ,2, [esi] , [esi + 4]
invoke Grow ,3, [esi] , [esi + 4]
	


	mov once, 0
	
ret

Restart ENDP

FixPlacesList PROC
	
	invoke long

	mov counter, 0
	mov counter, ebx
	add counter, ebx
	mov edi, counter
		mov edx, counter
	
	.while edx > 0
		
		mov ebx, [esi +  (edx) * 4]
		mov [esi +  (edx) * 4 + 8] , ebx
		sub edx, 1

	.endw
	
	mov edx, [esi]
	mov [esi + 8], edx
	


	mov edx, [esi +  (edi) * 4]
	mov [esi], edx

	mov edx, 0
	mov [esi +  (edi) * 4], edx
	
	mov edx, [esi +  (edi) * 4 + 4]
	mov [esi + 4], edx
	
	mov edx, 0
	mov [esi +  (edi) * 4 + 4], edx
	
	
	.if play == 1
	mov edx, [esi]
	mov eax ,srandomnumX
	.if eax > edx
		sub srandomnumX , 4
	.endif



	mov eax ,srandomnumX
	mov edx, [esi]
	.if eax < edx
		add srandomnumX , 4
	.endif
	

	mov edx, [esi + 4]
	mov eax ,srandomnumY
	.if eax > edx
		sub srandomnumY , 4
	.endif



	mov eax ,srandomnumY
	mov edx, [esi + 4]
	.if eax < edx
		add srandomnumY , 4
	.endif
	.endif
	ret


FixPlacesList ENDP

DrawPlayer PROC,x:DWORD, y:DWORD, hdc:HDC, brushcolouring:HBRUSH , lenght:DWORD, wParam:WPARAM, hWnd:HWND
	start:
	mov score , 1
	

	
;	invoke crt__itoa, score, addr scoreText + 7, 10 ; Convert integer to string
;	invoke crt_strlen, addr scoreText ;Get the length of the scoreText string
;	invoke TextOutA, hdc, 10, 40, addr scoreText, eax ;Print the score




	add newcounter, 1
	mov esi, offset snakepos

	invoke GetStockObject,	DC_BRUSH
	mov brushcolouring, eax
	invoke SetDCBrushColor,	hdc,	00000000FF00h
	
	invoke  long
	;sub ebx, 1
	.if ngrow == 0 && play == 1
		
		.if Direction == RIGHT
			invoke  long
			

			mov eax, [esi] 
			add eax, 15
			


			mov [esi + ebx * 8 - 8], eax
			
			mov eax, [esi + 4]
			mov [esi + ebx * 8 - 4], eax 
		
		.endif

		.if Direction == LEFT
			mov eax, [esi] 
			sub eax, 15
			
			mov [esi + ebx * 8 - 8], eax
			
			mov eax, [esi + 4]
			mov [esi + ebx * 8 - 4], eax 
		.endif

		.if Direction == UP
			mov eax, [esi] 
			mov [esi + ebx * 8 - 8], eax
			
			mov eax, [esi + 4]
			sub eax, 15
			mov [esi + ebx * 8 - 4], eax 
 
		.endif

		.if Direction == DOWN
			mov eax, [esi] 
			mov [esi + ebx * 8 - 8], eax
			
			mov eax, [esi + 4]
			add eax, 15
			mov [esi + ebx * 8 - 4], eax 
		.endif


	.endif
	
	
	mov counter , ebx
	add counter, 1
	
	invoke SelectObject, hdc,brushcolouring
	invoke SetDCBrushColor, hdc, 0000ffffh
	mov brushcolouring, eax

	invoke DRAWRECT, randomnumX ,randomnumY ,  15,	15, 	hdc,  brushcolouring
	
	


	.if once == 0
		again:
		invoke GetTickCount
		add eax, eax
		add eax, 52389847

		invoke nseed, eax
		invoke nrandom, 750
			
		mov srandomnumX, eax
			
		invoke nrandom, 550
		mov srandomnumY, eax
		

		.if (srandomnumY < 500 && srandomnumY > 300)  
			jmp again
		.endif
		.if (srandomnumX < 500 && srandomnumX > 300)  
			jmp again
		.endif

		mov once, 1


	.endif


	invoke SelectObject, hdc,brushcolouring
	invoke SetDCBrushColor, hdc, 000000ffh
	mov brushcolouring, eax

	invoke DRAWRECT, srandomnumX ,srandomnumY ,  15,	15, 	hdc,  brushcolouring





	.while counter != 0
		
	
		mov edi, counter
		sub edi, 2
	
	invoke SelectObject, hdc,brushcolouring
	invoke SetDCBrushColor, hdc, 0000ff00h
	mov brushcolouring, eax

		
		
		.if Direction == RIGHT
		mov edx, [esi + edi * 8]
		add edx, 10

		mov ebx, [esi + edi * 8 + 4]
		invoke GetPixel, hdc , edx, ebx

		.endif

		.if Direction == LEFT
		mov edx, [esi + edi * 8]
		
		mov ebx, [esi + edi * 8 + 4]
		invoke GetPixel, hdc, edx, ebx

		.endif

		.if Direction == UP
		mov edx, [esi + edi * 8]
		
		mov ebx, [esi + edi * 8 + 4]
		
		invoke GetPixel, hdc, edx, ebx
		.endif

		.if Direction == DOWN
		
		mov edx, [esi + edi * 8]
		
		mov ebx, [esi + edi * 8 + 4]
		sub ebx, 10

		invoke GetPixel, hdc, edx, ebx
		.endif


		.if eax != 000000ffh 

			.if Direction == RIGHT
		mov edx, [esi + edi * 8]
		add edx, 10

		mov ebx, [esi + edi * 8 + 4]
		add ebx, 10
		invoke GetPixel, hdc , edx, ebx

		.endif

		.if Direction == LEFT
		mov edx, [esi + edi * 8]
		
		mov ebx, [esi + edi * 8 + 4]
		add ebx, 10
		invoke GetPixel, hdc, edx, ebx

		.endif

		.if Direction == UP
		mov edx, [esi + edi * 8]
		add edx, 10

		mov ebx, [esi + edi * 8 + 4]
		
		invoke GetPixel, hdc, edx, ebx
		.endif

		.if Direction == DOWN
		
		mov edx, [esi + edi * 8]
		add edx, 10
		mov ebx, [esi + edi * 8 + 4]
		add ebx, 10

		invoke GetPixel, hdc, edx, ebx
		.endif

		.endif

		.if eax == 000000ffh 
		jmp lost
		.endif
		
		
		.if Direction == RIGHT
		mov edx, [esi + edi * 8]
		add edx, 10

		mov ebx, [esi + edi * 8 + 4]
		invoke GetPixel, hdc , edx, ebx

		.endif

		.if Direction == LEFT
		mov edx, [esi + edi * 8]
		
		mov ebx, [esi + edi * 8 + 4]
		invoke GetPixel, hdc, edx, ebx

		.endif

		.if Direction == UP
		mov edx, [esi + edi * 8]
		
		mov ebx, [esi + edi * 8 + 4]
		
		invoke GetPixel, hdc, edx, ebx
		.endif

		.if Direction == DOWN
		
		mov edx, [esi + edi * 8]
		
		mov ebx, [esi + edi * 8 + 4]
		sub ebx, 10

		invoke GetPixel, hdc, edx, ebx
		.endif


		.if eax != 0000ffffh 

			.if Direction == RIGHT
		mov edx, [esi + edi * 8]
		add edx, 10

		mov ebx, [esi + edi * 8 + 4]
		add ebx, 10
		invoke GetPixel, hdc , edx, ebx

		.endif

		.if Direction == LEFT
		mov edx, [esi + edi * 8]
		
		mov ebx, [esi + edi * 8 + 4]
		add ebx, 10
		invoke GetPixel, hdc, edx, ebx

		.endif

		.if Direction == UP
		mov edx, [esi + edi * 8]
		add edx, 10

		mov ebx, [esi + edi * 8 + 4]
		
		invoke GetPixel, hdc, edx, ebx
		.endif

		.if Direction == DOWN
		
		mov edx, [esi + edi * 8]
		add edx, 10
		mov ebx, [esi + edi * 8 + 4]
		add ebx, 10

		invoke GetPixel, hdc, edx, ebx
		.endif

		.endif

		.if eax == 0000ffffh && Direction !=0 
		invoke GetTickCount
		invoke nseed, eax
		invoke nrandom, 750
			
		mov randomnumX, eax
			
		invoke nrandom, 550
		mov randomnumY, eax
		
		.if first == 1
			mov ngrow , 1
		.endif
		
		.endif		
		

	
	

		;check himself

		.if ngrow != 1
		
		.if Direction == RIGHT
		mov edx, [esi + edi * 8]
			
		add edx, 9		

		mov ebx, [esi + edi * 8 + 4]
		invoke GetPixel, hdc, edx, ebx

		.endif

		.if Direction == LEFT
		mov edx, [esi + edi * 8]
		
		mov ebx, [esi + edi * 8 + 4]
		invoke GetPixel, hdc, edx, ebx

		.endif

		.if Direction == UP
	mov edx, [esi + edi * 8]
		
		mov ebx, [esi + edi * 8 + 4]

		invoke GetPixel, hdc, edx, ebx
		
		.endif

		.if Direction == DOWN
		
		mov edx, [esi + edi * 8]
		
		mov ebx, [esi + edi * 8 + 4]
		

		invoke GetPixel, hdc, edx, ebx
		.endif


		.if eax != 0000ff00h 

			.if Direction == RIGHT
		mov edx, [esi + edi * 8]
		
		mov ebx, [esi + edi * 8 + 4]
		add ebx, 9
		invoke GetPixel, hdc, edx, ebx
		.endif

		.if Direction == LEFT
		mov edx, [esi + edi * 8]
		
		mov ebx, [esi + edi * 8 + 4]
		add ebx, 10
		invoke GetPixel, hdc, edx, ebx

		.endif

		.if Direction == UP
		
		mov edx, [esi + edi * 8]
		add edx, 10
		mov ebx, [esi + edi * 8 + 4]
		add ebx, 10

		invoke GetPixel, hdc, edx, ebx
		.endif

		.if Direction == DOWN
		
		mov edx, [esi + edi * 8]
		
		mov ebx, [esi + edi * 8 + 4]
		add ebx, 9

		invoke GetPixel, hdc, edx, ebx
		.endif

		.endif
		.endif
		
		
	
		.if ngrow == 1 && play == 1
			mov colision, 1
		
		.endif

		.if colision == 1
			add counter2, 1
		
		.endif
		.if counter2 == 2
			mov counter2, 0
			mov colision, 0
		.endif
		

		.if eax == 0000ff00h && Direction !=0 
			lost:
			invoke Restart
			
			mov play, 0
			jmp order
			
		.endif
		mov eax, [esi]
	.if eax > 800 ;|| [esi + 4] > 600 || [esi] < 0 || [esi + 4] < 0 
			
			invoke Restart
			
			mov play, 0
			jmp order
			
		.endif

		.if eax  < 0  
			
			invoke Restart
			
			mov play, 0
			jmp order
			
		.endif
		mov eax, [esi + 4]
		.if eax > 550
			
			invoke Restart
			
			mov play, 0
			jmp order
			
		.endif

		.if eax  < 0 
			
			invoke Restart
			
			mov play, 0
			jmp order
			
		.endif
		
	invoke SelectObject, hdc,brushcolouring
	invoke SetDCBrushColor, hdc, 0000ff00h
	mov brushcolouring, eax


		invoke DRAWRECT, [esi + edi * 8] , [esi + edi * 8 + 4] ,  10,	10, 	hdc,  brushcolouring


	invoke SelectObject, hdc,brushcolouring
	invoke SetDCBrushColor, hdc, 00000000h
	mov brushcolouring, eax

		
		invoke DRAWRECT, 0 , 0 ,  10,	10, 	hdc,  brushcolouring
		

		
		add [esi + edi * 8 ], edx
		
		mov edx ,[esi + (edi * 8)]
		
		sub counter, 1

	
	.endw

	.if Direction != 0 && ngrow == 0 && counter2 == 0
	invoke long
	invoke FixPlacesList
	.endif
	
	.if ngrow == 1
order:
		invoke long

		invoke Grow , ebx, [esi] , [esi + 4]
		mov eax, gamesp
		invoke SetTimer, hWnd, MAIN_TIMER_ID, eax, NULL ;Set the repaint timer

		mov ngrow , 0
	.endif

	;jmp	movement
	
	.if first == 0
	
	invoke GetTickCount
	invoke nseed, eax
	invoke nrandom, 750
			
	mov randomnumX, eax
			
	invoke nrandom, 550
	
	mov randomnumY, eax
	mov first, 1
	.endif


	


	ret 
DrawPlayer ENDP



ProjectWndProc	PROC,	hWnd:HWND, message:UINT, wParam:WPARAM, lParam:LPARAM
	local paint:PAINTSTRUCT
	local hdc:HDC
	local brushcolouring:HBRUSH





	jmp	movement
	endmovement:
	
	;cmp message

	cmp	message,	WM_PAINT
	je	painting
	cmp message,	WM_CLOSE
	je	closing
	cmp message,	WM_TIMER
	je	timing

	jmp OtherInstances
	
	
	closing:
	invoke ExitProcess, 0



	painting:
	invoke	BeginPaint,	hWnd,	addr paint
	mov hdc, eax
	invoke GetStockObject,	DC_BRUSH
	mov brushcolouring, eax
	invoke SetDCBrushColor,	hdc,	000000FF0000h
	mov brushcolouring, eax
	

    invoke DrawPlayer, currentX , currentY, hdc, brushcolouring, Lenght , wParam, hWnd
	
			
	invoke EndPaint, hWnd,	addr paint	
	ret
	movement:
	mov eax, 1
	
	;mov	FlagKeyPress,	eax
	
	
	
	
	
	
	moving:
	
	.if wParam == VK_SPACE
		mov play, 1
	.endif
			
	.if  wParam == VK_LEFT && Direction != RIGHT && newcounter > 0
		mov Direction, LEFT 
;		jmp moveleft
		mov newcounter, 0
	.endif
	.if  wParam == VK_RIGHT && Direction != LEFT && newcounter > 0
		mov Direction, RIGHT
;		jmp moveright
		mov newcounter, 0 
	.endif
	.if  wParam == VK_UP && Direction != DOWN && newcounter > 0
		mov Direction, UP
;		jmp moveup  
		mov newcounter, 0
	.endif
	.if  wParam == VK_DOWN && Direction != UP && newcounter > 0
		mov Direction, DOWN 
;		jmp movedown
		mov newcounter, 0
	.endif



	jmp endmovement
	

;	stopmovement:
;	mov FlagKeyPress,	eax
;	ret 



	timing:
	invoke InvalidateRect, hWnd, NULL, TRUE
	jmp OtherInstances
	ret
OtherInstances:
	invoke DefWindowProc, hWnd, message, wParam, lParam
	ret

ProjectWndProc	ENDP


main PROC


LOCAL wndcls:WNDCLASSA ; Class struct for the window

LOCAL hWnd:HWND ;Handle to the window

LOCAL msg:MSG 

invoke RtlZeroMemory, addr wndcls, SIZEOF wndcls ;Empty the window class

mov eax, offset ClassName

mov wndcls.lpszClassName, eax ;Set the class name

invoke GetStockObject, BLACK_BRUSH

mov wndcls.hbrBackground, eax ;Set the background color as black

mov eax, ProjectWndProc

mov wndcls.lpfnWndProc, eax ;Set the procedure that handles the window messages

invoke RegisterClassA, addr wndcls ;Register the class

invoke CreateWindowExA, WS_EX_COMPOSITED, addr ClassName, addr windowTitle, WS_SYSMENU, 100, 100, WINDOW_WIDTH, WINDOW_HEIGHT, 0, 0, 0, 0 ;Create the window

mov hWnd, eax ;Save the handle
invoke ShowWindow, eax, SW_SHOW ;Show it

mov eax, gamesp

invoke SetTimer, hWnd, MAIN_TIMER_ID, eax, NULL ;Set the repaint timer






msgLoop:

 ; PeekMessage
invoke GetMessage, addr msg, hWnd, 0, 0 ;Retrieve the messages from the window

invoke DispatchMessage, addr msg ;Dispatches a message to the window procedure

jmp msgLoop

invoke ExitProcess, 1

main ENDP


;main PROC
;main ENDP


end main



