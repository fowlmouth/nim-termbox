when defined(Linux):
  const LibName = "libtermbox.so"
else:
  {.error: "This platform has not been accounted for in the termbox wrapper.".}

# --------------- keys ---------------- 
# These are safe subset of terminfo keys, which exists on all popular terminals.
#   I think it's important to use only these and not others.
#
const 
  TB_KEY_F1* = (0x0000FFFF - 0)
  TB_KEY_F2* = (0x0000FFFF - 1)
  TB_KEY_F3* = (0x0000FFFF - 2)
  TB_KEY_F4* = (0x0000FFFF - 3)
  TB_KEY_F5* = (0x0000FFFF - 4)
  TB_KEY_F6* = (0x0000FFFF - 5)
  TB_KEY_F7* = (0x0000FFFF - 6)
  TB_KEY_F8* = (0x0000FFFF - 7)
  TB_KEY_F9* = (0x0000FFFF - 8)
  TB_KEY_F10* = (0x0000FFFF - 9)
  TB_KEY_F11* = (0x0000FFFF - 10)
  TB_KEY_F12* = (0x0000FFFF - 11)
  TB_KEY_INSERT* = (0x0000FFFF - 12)
  TB_KEY_DELETE* = (0x0000FFFF - 13)
  TB_KEY_HOME* = (0x0000FFFF - 14)
  TB_KEY_END* = (0x0000FFFF - 15)
  TB_KEY_PGUP* = (0x0000FFFF - 16)
  TB_KEY_PGDN* = (0x0000FFFF - 17)
  TB_KEY_ARROW_UP* = (0x0000FFFF - 18)
  TB_KEY_ARROW_DOWN* = (0x0000FFFF - 19)
  TB_KEY_ARROW_LEFT* = (0x0000FFFF - 20)
  TB_KEY_ARROW_RIGHT* = (0x0000FFFF - 21)
# These are all keys below SPACE character and BACKSPACE key 
const 
  TB_KEY_CTRL_TILDE* = 0x00000000
  TB_KEY_CTRL_2* = 0x00000000 # clash with 'CTRL_TILDE' 
  TB_KEY_CTRL_A* = 0x00000001
  TB_KEY_CTRL_B* = 0x00000002
  TB_KEY_CTRL_C* = 0x00000003
  TB_KEY_CTRL_D* = 0x00000004
  TB_KEY_CTRL_E* = 0x00000005
  TB_KEY_CTRL_F* = 0x00000006
  TB_KEY_CTRL_G* = 0x00000007
  TB_KEY_BACKSPACE* = 0x00000008
  TB_KEY_CTRL_H* = 0x00000008 # clash with 'CTRL_BACKSPACE' 
  TB_KEY_TAB* = 0x00000009
  TB_KEY_CTRL_I* = 0x00000009 # clash with 'TAB' 
  TB_KEY_CTRL_J* = 0x0000000A
  TB_KEY_CTRL_K* = 0x0000000B
  TB_KEY_CTRL_L* = 0x0000000C
  TB_KEY_ENTER* = 0x0000000D
  TB_KEY_CTRL_M* = 0x0000000D # clash with 'ENTER' 
  TB_KEY_CTRL_N* = 0x0000000E
  TB_KEY_CTRL_O* = 0x0000000F
  TB_KEY_CTRL_P* = 0x00000010
  TB_KEY_CTRL_Q* = 0x00000011
  TB_KEY_CTRL_R* = 0x00000012
  TB_KEY_CTRL_S* = 0x00000013
  TB_KEY_CTRL_T* = 0x00000014
  TB_KEY_CTRL_U* = 0x00000015
  TB_KEY_CTRL_V* = 0x00000016
  TB_KEY_CTRL_W* = 0x00000017
  TB_KEY_CTRL_X* = 0x00000018
  TB_KEY_CTRL_Y* = 0x00000019
  TB_KEY_CTRL_Z* = 0x0000001A
  TB_KEY_ESC* = 0x0000001B
  TB_KEY_CTRL_LSQ_BRACKET* = 0x0000001B # clash with 'ESC' 
  TB_KEY_CTRL_3* = 0x0000001B # clash with 'ESC' 
  TB_KEY_CTRL_4* = 0x0000001C
  TB_KEY_CTRL_BACKSLASH* = 0x0000001C # clash with 'CTRL_4' 
  TB_KEY_CTRL_5* = 0x0000001D
  TB_KEY_CTRL_RSQ_BRACKET* = 0x0000001D # clash with 'CTRL_5' 
  TB_KEY_CTRL_6* = 0x0000001E
  TB_KEY_CTRL_7* = 0x0000001F
  TB_KEY_CTRL_SLASH* = 0x0000001F # clash with 'CTRL_7' 
  TB_KEY_CTRL_UNDERSCORE* = 0x0000001F # clash with 'CTRL_7' 
  TB_KEY_SPACE* = 0x00000020
  TB_KEY_BACKSPACE2* = 0x0000007F
  TB_KEY_CTRL_8* = 0x0000007F # clash with 'DELETE' 
# These are fail ones (do not exist) 
# #define TB_KEY_CTRL_1 clash with '1' 
# #define TB_KEY_CTRL_9 clash with '9' 
# #define TB_KEY_CTRL_0 clash with '0' 
# Currently there is only one modificator 
const 
  TB_MOD_ALT* = 0x00000001
# colors 
const 
  TB_BLACK* = 0x00000000
  TB_RED* = 0x00000001
  TB_GREEN* = 0x00000002
  TB_YELLOW* = 0x00000003
  TB_BLUE* = 0x00000004
  TB_MAGENTA* = 0x00000005
  TB_CYAN* = 0x00000006
  TB_WHITE* = 0x00000007
  TB_DEFAULT* = 0x0000000F
# attributes 
const 
  TB_BOLD* = 0x00000010
  TB_UNDERLINE* = 0x00000020
type 
  tb_cell* {.pure, final.} = object 
    ch*: uint32
    fg*: uint16
    bg*: uint16

type 
  tb_event* {.pure, final.} = object 
    kind*: uint8
    modifier*: uint8
    key*: uint16
    ch*: uint32
    w*: int32
    h*: int32

const 
  TB_EUNSUPPORTED_TERMINAL* = - 1
  TB_EFAILED_TO_OPEN_TTY* = - 2
  TB_EPIPE_TRAP_ERROR* = - 3


{.push callConv: cdecl, dynlib: LibName.}

{.push importc: "tb_$1".}

proc init*(): cint
proc shutdown*()
proc width*(): cuint
proc height*(): cuint
proc clear*()
proc present*()
const 
  TB_HIDE_CURSOR* = - 1
proc set_cursor*(cx: cint; cy: cint)
proc put_cell*(x: cuint; y: cuint; cell: ptr tb_cell)
proc change_cell*(x: cuint; y: cuint; ch: uint32; fg: uint16; 
                     bg: uint16)
proc blit*(x: cuint; y: cuint; w: cuint; h: cuint; cells: ptr tb_cell)
const 
  TB_INPUT_ESC* = 1
  TB_INPUT_ALT* = 2
# with 0 returns current input mode 
proc select_input_mode*(mode: cint): cint
proc set_clear_attributes*(fg: uint16; bg: uint16)
const 
  TB_EVENT_KEY* = 1
  TB_EVENT_RESIZE* = 2
proc peek_event*(event: ptr tb_event; timeout: cuint): cint
proc poll_event*(event: ptr tb_event): cint
# these return:
# 0 - no events, no errors,
# 1 - key event
# 2 - resize event
# -1 - error (input buffer overflow, discarded input)
#
#   timeout in milliseconds
#
# glib based interface 
# TODO 
# utility utf8 functions 
const 
  TB_EOF* = - 1

proc utf8_char_length*(c: char): cint
proc utf8_char_to_unicode*(outp: ptr uint32; c: cstring): cint
proc utf8_unicode_to_char*(outp: cstring; c: uint32): cint

{.pop.}
{.pop.}