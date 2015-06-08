   .486                                      ; create 32 bit code
      .model flat, stdcall                      ; 32 bit memory model
      option casemap :none                      ; case sensitive 

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\gdi32.inc
include \masm32\include\Advapi32.inc
;include \masm32\include\masm32rt.inc
include \masm32\include\winmm.inc
includelib \masm32\lib\winmm.lib

	 include \masm32\include\masm32.inc 
	 include \masm32\include\dialogs.inc       ; macro file for dialogs
     include \masm32\macros\macros.asm         ; masm32 macro file
	 includelib \masm32\lib\gdi32.lib
     includelib \masm32\lib\user32.lib
     includelib \masm32\lib\kernel32.lib
     includelib \masm32\lib\Comctl32.lib
     includelib \masm32\lib\comdlg32.lib
     includelib \masm32\lib\shell32.lib
     includelib \masm32\lib\oleaut32.lib
     includelib \masm32\lib\ole32.lib
     includelib \masm32\lib\msvcrt.lib
	 includelib \masm32\lib\masm32.lib
     
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

ScoreX DWORD	0
ScoreY DWORD	0

counter DWORD 0
turntimes DWORD 0
Direction DWORD 0
Lenght DWORD 1
PlayerX	DWORD	400
PlayerY	DWORD	400
;Facing	DWORD	LEFT	;1	-	Right,	2	-Down,	3	-	Left,	4	-	Up
ClassName	DB	"TheClass",0
windowTitle	DB	"A Game!",0
currentX DWORD 400
currentY DWORD 400
numTimesPaint DWORD 0
first DWORD 0
ngrow DWORD 0
snakepos DWORD 400, 400 , 415 ,400, 430, 400, 445, 400, 460 ,400 ,40 dup(0) ; [esi + ecx * c] mov esi , ofset snakepos


.code
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
mov esi , offset snakepos
mov edi, lenght
sub edi, 1
.if Direction == RIGHT
mov esp, x 
add esp, 15
mov [esi +  (edi) * 8], esp

mov esp, y
mov [esi +  (edi) * 8 + 4], esp 

.endif

.if Direction == LEFT
mov esp, x 
add esp, 15
mov [esi +  (edi) * 8], esp 

mov esp, y
mov [esi +  (edi) * 8 + 4], esp 

.endif

.if Direction == UP
mov esp, x 
mov [esi +  (edi) * 8],  esp

mov esp, y 
add esp, 15
mov [esi +  (edi) * 8 + 4], esp 

.endif

.if Direction == DOWN
mov esp, x
mov [esi + (edi) * 8],  esp

mov esp, y
sub esp, 10
mov [esi +  (edi) * 8 + 4], esp 

.endif


	Grow ENDP


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
	
	
	ret
FixPlacesList ENDP


IsCollision PROC, x:DWORD, y:DWORD, w:DWORD, h:DWORD, hdc:HDC

		.if Direction == RIGHT
		mov edx, x
		add edx, 16
		

		mov edi, y
		sub edi, 5
		invoke GetPixel, hdc , edx, edi

		.endif

		.if Direction == LEFT
		mov edx, x
		sub edx, 6
		

		mov edi, y
		sub edi, 5
		invoke GetPixel, hdc, edx, edi

		.endif

		.if Direction == UP
		mov edx, x
		add edx, 5

		mov edi, y
		sub edi, 6

		invoke GetPixel, hdc, edx, edi
		.endif

		.if Direction == DOWN
		
		mov edx, x		
		add edx, 16
		mov edi, y		
		add edi, 10

		invoke GetPixel, hdc, edx, edi
		.endif



		ret
IsCollision ENDP

DrawPlayer PROC,x:DWORD, y:DWORD, hdc:HDC, brushcolouring:HBRUSH , lenght:DWORD, wParam:WPARAM
	mov esi, offset snakepos

	invoke GetStockObject,	DC_BRUSH
	mov brushcolouring, eax
	invoke SetDCBrushColor,	hdc,	00000000FF00h
	
	invoke  long
	;sub ebx, 1
	.if ngrow == 0
		
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
	
	.if ngrow == 1
	
	.endif
	mov counter , ebx
	add counter, 1
	
	invoke SelectObject, hdc,brushcolouring
	invoke SetDCBrushColor, hdc, 0000ffffh
	mov brushcolouring, eax

	invoke DRAWRECT, randomnumX ,randomnumY ,  100,	100, 	hdc,  brushcolouring
	
	.while counter != 0
		
	
		mov edi, counter
		sub edi, 2
	
	invoke SelectObject, hdc,brushcolouring
	invoke SetDCBrushColor, hdc, 0000ff00h
	mov brushcolouring, eax

		
		invoke GetPixel, hdc, [esi + edi * 8], [esi + edi * 8 + 4]
		
		.if eax == 0000ffffh 
		invoke GetTickCount
		invoke nseed, eax
		invoke nrandom, 800
			
		mov randomnumX, eax
			
		invoke nrandom, 600
		mov randomnumY, eax
		.endif		
		
		
		invoke DRAWRECT, [esi + edi * 8] , [esi + edi * 8 + 4] ,  10,	10, 	hdc,  brushcolouring
		

		
		add [esi + edi * 8 ], edx
		
		mov edx ,[esi + (edi * 8)]
		
		sub counter, 1

	
	.endw
	.if Direction != 0
	invoke long
	invoke FixPlacesList
	.endif
	


	;jmp	movement
	
	.if first == 0
	
	invoke GetTickCount
	invoke nseed, eax
	invoke nrandom, 800
			
	mov randomnumX, eax
			
	invoke nrandom, 600
	
	mov randomnumY, eax
	mov first, 1
	.endif


	;invoke IsCollision, [esi] , [esi + 4], 10, 10, hdc

	
	.if eax != 00000000h && Direction == 77
	
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
	

    invoke DrawPlayer, currentX , currentY, hdc, brushcolouring, Lenght , wParam
	
			
	invoke EndPaint, hWnd,	addr paint	
	ret
	movement:
	mov eax, 1
	
	;mov	FlagKeyPress,	eax
	moving:
	
	
	.if  wParam == VK_LEFT && Direction != RIGHT
		mov Direction, LEFT 
;		jmp moveleft
	.endif
	.if  wParam == VK_RIGHT && Direction != LEFT
		mov Direction, RIGHT
;		jmp moveright 
	.endif
	.if  wParam == VK_UP && Direction != DOWN
		mov Direction, UP
;		jmp moveup  
	.endif
	.if  wParam == VK_DOWN && Direction != UP
		mov Direction, DOWN 
;		jmp movedown
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

invoke SetTimer, hWnd, MAIN_TIMER_ID, 100, NULL ;Set the repaint timer






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



