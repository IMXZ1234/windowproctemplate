.386
.model Flat,stdcall
option casemap:none ;DISCRIMINATE BETWEEN UPPER/LOWERCASES
include C:\masm32\include\windows.inc ;INCLUDES CONSTANTS AND STRUCTS USED BY WINDOWS API

include C:\masm32\include\kernel32.inc ;FUNCTION PROTOS
include C:\masm32\include\user32.inc

includelib C:\masm32\lib\kernel32.lib ;LIBS USED
includelib C:\masm32\lib\user32.lib

WinMain PROTO   :DWORD,:DWORD,:DWORD,:DWORD

;EQUS
ID_TIMER    EQU 1

.DATA
ClassName       DB  "TEMPLATE",0
StaticClassName DB  "STATIC",0
szBuffer		DB	256	DUP(?)	
szTestBuffer	DB	256	DUP(?)

MsgBoxName		DB  "INFO",0
MsgBoxTextEAX		DB	"EAX %d",0
MsgBoxTextEBX		DB	"EBX %d",0
MsgBoxTextEDX		DB	"EDX %d",0

.DATA?
hInstance   DD  ?
hWinMain    DD  ?
hStatic     DD  ?
StaticID    DD  ?
hSetStatic	DD	7	DUP(?)

.CODE
START:

INVOKE  GetModuleHandle,NULL
MOV     hInstance,EAX
INVOKE  WinMain,hInstance,NULL,NULL,SW_SHOWDEFAULT
INVOKE  ExitProcess,EAX ;PROGRAM EXIT

WinMain     PROC    hInst:HINSTANCE,hPreInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
        LOCAL   @wc:WNDCLASSEX
        LOCAL   @msg:MSG
        LOCAL   @hwnd:HWND
    
    MOV     @wc.cbSize,SIZEOF WNDCLASSEX
    MOV     @wc.style,CS_HREDRAW or CS_VREDRAW
    MOV     @wc.lpfnWndProc,OFFSET MainWndProc
    MOV     @wc.cbClsExtra,NULL
    MOV     @wc.cbWndExtra,NULL
    MOV     EAX,hInstance
    MOV     @wc.hInstance,EAX
    MOV     @wc.hbrBackground,COLOR_WINDOW+1
    MOV     @wc.lpszMenuName,NULL
    MOV     @wc.lpszClassName,OFFSET ClassName
    
    ;LOAD RESOURCES
    INVOKE  LoadIcon,NULL,IDI_APPLICATION               ;WINDOWS DEFAULT ICON
    MOV     @wc.hIcon,EAX
    MOV     @wc.hIconSm,EAX
    
    INVOKE  LoadCursor,NULL,IDC_ARROW                   ;WINDOWS DEFAULT CURSOR
    MOV     @wc.hCursor,EAX

    INVOKE  RegisterClassEx,ADDR @wc
    INVOKE  CreateWindowEx,NULL,\
                    ADDR    ClassName,\
                    ADDR    ClassName,\
                    WS_OVERLAPPEDWINDOW,\
                    10,10,500,400,\
                    NULL,\
                    NULL,\
                    hInstance,\
                    NULL
    MOV @hwnd,EAX
    ;REFRESH THE CLIENT RECT OF WINDOW
    INVOKE  ShowWindow,@hwnd,CmdShow
    INVOKE  UpdateWindow,@hwnd
	
    ;ENTER MESSAGE LOOP
    .WHILE  TRUE
            INVOKE  GetMessage,ADDR @msg,NULL,0,0
            .BREAK .IF EAX==0
            INVOKE  TranslateMessage,ADDR @msg
            INVOKE  DispatchMessage,ADDR @msg
    .ENDW
    
    MOV     EAX,@msg.wParam
    RET
WinMain ENDP


MainWndProc PROC    hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
            LOCAL   @stPos:PAINTSTRUCT
    MOV     EAX,uMsg
    .IF     EAX==WM_TIMER
		;TO DO
    .ELSEIF EAX==WM_DESTROY
        INVOKE  KillTimer,hWinMain,ID_TIMER 
        INVOKE  DestroyWindow,hWnd
        INVOKE  PostQuitMessage,NULL
    .ELSEIF EAX==WM_CREATE
        MOV     EAX,hWnd
        MOV     hWinMain,EAX
        INVOKE  SetTimer,hWinMain,ID_TIMER,1000,NULL
        INVOKE  CreateWindowEx,NULL,ADDR StaticClassName,NULL,\
                WS_CHILD or WS_VISIBLE,\
                10,10,470,370,\
                hWinMain,\
                ADDR StaticID,\
                hInstance,\
                NULL
        MOV     hStatic,EAX
		;INVOKE	MessageBox,hWnd,szMessageBoxTextCREATE,szMessageBoxCaption,MB_OK
		;INVOKE	PostMessage,hWinMain,WM_TIMER,ID_TIMER,NULL
    .ELSE
        INVOKE  DefWindowProc,hWnd,uMsg,wParam,lParam
        RET
    .ENDIF
    
    XOR     EAX,EAX
    RET
MainWndProc ENDP

END START;½áÊø



