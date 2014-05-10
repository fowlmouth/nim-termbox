#
#   libcaca       Colour ASCII-Art library
#   Copyright (c) 2002-2012 Sam Hocevar <sam@hocevar.net>
#                 All Rights Reserved
# 
#   This library is free software. It comes without any warranty, to
#   the extent permitted by applicable law. You can redistribute it
#   and/or modify it under the terms of the Do What The Fuck You Want
#   To Public License, Version 2, as published by Sam Hocevar. See
#   http://sam.zoy.org/wtfpl/COPYING for more details.
# 
#* \file caca.h
#   \author Sam Hocevar <sam@hocevar.net>
#   \brief The \e libcaca public header.
# 
#   This header contains the public types and functions that applications
#   using \e libcaca may use.
# 

when defined(Linux):
  const LibName* = "libcaca.so"
else:
  const LibName* = "caca.dll"

{.push callconv: cdecl.}

# #undef __extern
##if defined _DOXYGEN_SKIP_ME
##elif defined _WIN32 && defined __LIBCACA__ && defined DLL_EXPORT
##   define __extern extern __declspec(dllexport)
##elif defined _WIN32 && !defined __LIBCACA__
##   define __extern extern __declspec(dllimport)
##else
##   define __extern extern
##endif
# 
#* libcaca API version 
const 
  CACA_API_VERSION_1* = true
#* dither structure 
type Tdither* = object
type Tcanvas* = object
type Tcharfont* = object
type Tfont* = object
type 
  Tfile = object
  PFile* = ptr caca.TFile
#type Tdither* = Tdither
#* character font structure 
#type  Tcharfont* = Tcharfont
#* bitmap font structure 
#type Tfont* = Tfont
#* file handle structure 
#type    caca.Tfile* = Tfile
#* \e libcaca display context 
type Tdisplay* = object
#type  Tevent_t* = Tevent
#* \defgroup caca_attr libcaca attribute definitions
# 
#   Colours and styles that can be used with caca_set_attr().
# 
#   @{ 
#* \e libcaca colour keyword 
type 
  Tcolor* = enum 
    CACA_BLACK = 0x00000000, #*< The colour index for black. 
    CACA_BLUE = 0x00000001, #*< The colour index for blue. 
    CACA_GREEN = 0x00000002, #*< The colour index for green. 
    CACA_CYAN = 0x00000003, #*< The colour index for cyan. 
    CACA_RED = 0x00000004,  #*< The colour index for red. 
    CACA_MAGENTA = 0x00000005, #*< The colour index for magenta. 
    CACA_BROWN = 0x00000006, #*< The colour index for brown. 
    CACA_LIGHTGRAY = 0x00000007, #*< The colour index for light gray. 
    CACA_DARKGRAY = 0x00000008, #*< The colour index for dark gray. 
    CACA_LIGHTBLUE = 0x00000009, #*< The colour index for blue. 
    CACA_LIGHTGREEN = 0x0000000A, #*< The colour index for light green. 
    CACA_LIGHTCYAN = 0x0000000B, #*< The colour index for light cyan. 
    CACA_LIGHTRED = 0x0000000C, #*< The colour index for light red. 
    CACA_LIGHTMAGENTA = 0x0000000D, #*< The colour index for light magenta. 
    CACA_YELLOW = 0x0000000E, #*< The colour index for yellow. 
    CACA_WHITE = 0x0000000F, #*< The colour index for white. 
    CACA_DEFAULT = 0x00000010, #*< The output driver's default colour. 
    CACA_TRANSPARENT = 0x00000020 #*< The transparent colour. 
converter to_u8* (col:Tcolor): uint8 = uint8(col)
#* \e libcaca style keyword 
type 
  Tstyle* = enum 
    CACA_BOLD = 0x00000001, #*< The style mask for bold. 
    CACA_ITALICS = 0x00000002, #*< The style mask for italics. 
    CACA_UNDERLINE = 0x00000004, #*< The style mask for underline. 
    CACA_BLINK = 0x00000008 #*< The style mask for blink. 
#  @} 
#* \brief User event type enumeration.
# 
#   This enum serves two purposes:
#   - Build listening masks for caca_get_event().
#   - Define the type of a \e caca_event_t.
# 
when false:
 type 
  Tevent_type* = enum 
    CACA_EVENT_NONE = 0x00000000, #*< No event. 
    CACA_EVENT_KEY_PRESS = 0x00000001, #*< A key was pressed. 
    CACA_EVENT_KEY_RELEASE = 0x00000002, #*< A key was released. 
    CACA_EVENT_MOUSE_PRESS = 0x00000004, #*< A mouse button was pressed. 
    CACA_EVENT_MOUSE_RELEASE = 0x00000008, #*< A mouse button was released. 
    CACA_EVENT_MOUSE_MOTION = 0x00000010, #*< The mouse was moved. 
    CACA_EVENT_RESIZE = 0x00000020, #*< The window was resized. 
    CACA_EVENT_QUIT = 0x00000040, #*< The user requested to quit. 
    CACA_EVENT_ANY = 0x0000FFFF
else:
  const
    CACA_EVENT_NONE* = 0x00000000 #*< No event. 
    CACA_EVENT_KEY_PRESS* = 0x00000001 #*< A key was pressed. 
    CACA_EVENT_KEY_RELEASE* = 0x00000002 #*< A key was released. 
    CACA_EVENT_MOUSE_PRESS* = 0x00000004 #*< A mouse button was pressed. 
    CACA_EVENT_MOUSE_RELEASE* = 0x00000008 #*< A mouse button was released. 
    CACA_EVENT_MOUSE_MOTION* = 0x00000010 #*< The mouse was moved. 
    CACA_EVENT_RESIZE* = 0x00000020 #*< The window was resized. 
    CACA_EVENT_QUIT* = 0x00000040 #*< The user requested to quit. 
    CACA_EVENT_ANY* = 0x0000FFFF
  type
    Tevent_type* = cint

#* \brief Handling of user events.
# 
#   This structure is filled by caca_get_event() when an event is received.
#   It is an opaque structure that should only be accessed through
#   caca_event_get_type() and similar functions. The struct members may no
#   longer be directly accessible in future versions.
# 
type 
  TEventData* = object{.union.}
    mouse*: tuple[x,y,button: cint]
    resize*: tuple[w,h:cint]
    key*: tuple[ch:cint, utf32:uint32, utf8:array[8,char]]
  Tevent* = object 
    kind*: Tevent_type
    data*: TEventData
  
#* \brief Option parsing.
# 
#  This structure contains commandline parsing information for systems
#  where getopt_long() is unavailable.
# 
type 
  Toption* = object 
    name*: cstring
    has_arg*: cint
    flag*: ptr cint
    val*: cint

#* \brief Special key values.
# 
#   Special key values returned by caca_get_event() for which there is no
#   printable ASCII equivalent.
# 
type 
  Tkey* = enum 
    CACA_KEY_UNKNOWN = 0x00000000, #*< Unknown key. 
                                   # The following keys have ASCII equivalents 
    CACA_KEY_CTRL_A = 0x00000001, #*< The Ctrl-A key. 
    CACA_KEY_CTRL_B = 0x00000002, #*< The Ctrl-B key. 
    CACA_KEY_CTRL_C = 0x00000003, #*< The Ctrl-C key. 
    CACA_KEY_CTRL_D = 0x00000004, #*< The Ctrl-D key. 
    CACA_KEY_CTRL_E = 0x00000005, #*< The Ctrl-E key. 
    CACA_KEY_CTRL_F = 0x00000006, #*< The Ctrl-F key. 
    CACA_KEY_CTRL_G = 0x00000007, #*< The Ctrl-G key. 
    CACA_KEY_BACKSPACE = 0x00000008, #*< The backspace key. 
    CACA_KEY_TAB = 0x00000009, #*< The tabulation key. 
    CACA_KEY_CTRL_J = 0x0000000A, #*< The Ctrl-J key. 
    CACA_KEY_CTRL_K = 0x0000000B, #*< The Ctrl-K key. 
    CACA_KEY_CTRL_L = 0x0000000C, #*< The Ctrl-L key. 
    CACA_KEY_RETURN = 0x0000000D, #*< The return key. 
    CACA_KEY_CTRL_N = 0x0000000E, #*< The Ctrl-N key. 
    CACA_KEY_CTRL_O = 0x0000000F, #*< The Ctrl-O key. 
    CACA_KEY_CTRL_P = 0x00000010, #*< The Ctrl-P key. 
    CACA_KEY_CTRL_Q = 0x00000011, #*< The Ctrl-Q key. 
    CACA_KEY_CTRL_R = 0x00000012, #*< The Ctrl-R key. 
    CACA_KEY_PAUSE = 0x00000013, #*< The pause key. 
    CACA_KEY_CTRL_T = 0x00000014, #*< The Ctrl-T key. 
    CACA_KEY_CTRL_U = 0x00000015, #*< The Ctrl-U key. 
    CACA_KEY_CTRL_V = 0x00000016, #*< The Ctrl-V key. 
    CACA_KEY_CTRL_W = 0x00000017, #*< The Ctrl-W key. 
    CACA_KEY_CTRL_X = 0x00000018, #*< The Ctrl-X key. 
    CACA_KEY_CTRL_Y = 0x00000019, #*< The Ctrl-Y key. 
    CACA_KEY_CTRL_Z = 0x0000001A, #*< The Ctrl-Z key. 
    CACA_KEY_ESCAPE = 0x0000001B, #*< The escape key. 
    CACA_KEY_DELETE = 0x0000007F, #*< The delete key. 
                                  # The following keys do not have ASCII equivalents but have been
                                  #      chosen to match the SDL equivalents 
    CACA_KEY_UP = 0x00000111, #*< The up arrow key. 
    CACA_KEY_DOWN = 0x00000112, #*< The down arrow key. 
    CACA_KEY_LEFT = 0x00000113, #*< The left arrow key. 
    CACA_KEY_RIGHT = 0x00000114, #*< The right arrow key. 
    CACA_KEY_INSERT = 0x00000115, #*< The insert key. 
    CACA_KEY_HOME = 0x00000116, #*< The home key. 
    CACA_KEY_END = 0x00000117, #*< The end key. 
    CACA_KEY_PAGEUP = 0x00000118, #*< The page up key. 
    CACA_KEY_PAGEDOWN = 0x00000119, #*< The page down key. 
    CACA_KEY_F1 = 0x0000011A, #*< The F1 key. 
    CACA_KEY_F2 = 0x0000011B, #*< The F2 key. 
    CACA_KEY_F3 = 0x0000011C, #*< The F3 key. 
    CACA_KEY_F4 = 0x0000011D, #*< The F4 key. 
    CACA_KEY_F5 = 0x0000011E, #*< The F5 key. 
    CACA_KEY_F6 = 0x0000011F, #*< The F6 key. 
    CACA_KEY_F7 = 0x00000120, #*< The F7 key. 
    CACA_KEY_F8 = 0x00000121, #*< The F8 key. 
    CACA_KEY_F9 = 0x00000122, #*< The F9 key. 
    CACA_KEY_F10 = 0x00000123, #*< The F10 key. 
    CACA_KEY_F11 = 0x00000124, #*< The F11 key. 
    CACA_KEY_F12 = 0x00000125, #*< The F12 key. 
    CACA_KEY_F13 = 0x00000126, #*< The F13 key. 
    CACA_KEY_F14 = 0x00000127, #*< The F14 key. 
    CACA_KEY_F15 = 0x00000128

template pp: stmt =
  {.push dynlib:libname, importc:"caca_$1".}
pp

#* \defgroup libcaca libcaca basic functions
# 
#   These functions provide the basic \e libcaca routines for library
#   initialisation, system information retrieval and configuration.
# 
#   @{ 
proc create_canvas*(a2: cint; a3: cint): ptr Tcanvas
proc manage_canvas*(a2: ptr Tcanvas; a3: proc (a2: pointer): cint; 
                    a4: pointer): cint
proc unmanage_canvas*(a2: ptr Tcanvas; a3: proc (a2: pointer): cint; 
                      a4: pointer): cint
proc set_canvas_size*(a2: ptr Tcanvas; a3: cint; a4: cint): cint
proc get_canvas_width*(a2: ptr Tcanvas): cint
proc get_canvas_height*(a2: ptr Tcanvas): cint
proc get_canvas_chars*(a2: ptr Tcanvas): ptr uint32
proc get_canvas_attrs*(a2: ptr Tcanvas): ptr uint32
proc free_canvas*(a2: ptr Tcanvas): cint
proc rand*(a2: cint; a3: cint): cint
proc get_version*(): cstring
#  @} 
#* \defgroup caca_canvas libcaca canvas drawing
# 
#   These functions provide low-level character printing routines and
#   higher level graphics functions.
# 
#   @{ 
const 
  CACA_MAGIC_FULLWIDTH* = 0x000FFFFE
proc gotoxy*(a2: ptr Tcanvas; a3: cint; a4: cint): cint
proc wherex*(a2: ptr Tcanvas): cint
proc wherey*(a2: ptr Tcanvas): cint
proc put_char*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: uint32): cint
proc get_char*(a2: ptr Tcanvas; a3: cint; a4: cint): uint32
proc put_str*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cstring): cint
proc printf*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cstring): cint {.
    varargs.}
proc vprintf*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cstring): cint{.varargs.}
proc clear_canvas*(a2: ptr Tcanvas): cint
proc set_canvas_handle*(a2: ptr Tcanvas; a3: cint; a4: cint): cint
proc get_canvas_handle_x*(a2: ptr Tcanvas): cint
proc get_canvas_handle_y*(a2: ptr Tcanvas): cint
proc blit*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: ptr Tcanvas; 
           a6: ptr Tcanvas): cint
proc set_canvas_boundaries*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cint; 
                            a6: cint): cint
#  @} 
#* \defgroup caca_dirty libcaca dirty rectangle manipulation
# 
#   These functions manipulate dirty rectangles for optimised blitting.
#   @{ 
proc disable_dirty_rect*(a2: ptr Tcanvas): cint
proc enable_dirty_rect*(a2: ptr Tcanvas): cint
proc get_dirty_rect_count*(a2: ptr Tcanvas): cint
proc get_dirty_rect*(a2: ptr Tcanvas; a3: cint; a4: ptr cint; a5: ptr cint; 
                     a6: ptr cint; a7: ptr cint): cint
proc add_dirty_rect*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cint; a6: cint): cint
proc remove_dirty_rect*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cint; 
                        a6: cint): cint
proc clear_dirty_rect_list*(a2: ptr Tcanvas): cint
#  @} 
#* \defgroup caca_transform libcaca canvas transformation
# 
#   These functions perform horizontal and vertical canvas flipping.
# 
#   @{ 
proc invert*(a2: ptr Tcanvas): cint
proc flip*(a2: ptr Tcanvas): cint
proc flop*(a2: ptr Tcanvas): cint
proc rotate_180*(a2: ptr Tcanvas): cint
proc rotate_left*(a2: ptr Tcanvas): cint
proc rotate_right*(a2: ptr Tcanvas): cint
proc stretch_left*(a2: ptr Tcanvas): cint
proc stretch_right*(a2: ptr Tcanvas): cint
#  @} 
#* \defgroup caca_attributes libcaca attribute conversions
# 
#   These functions perform conversions between attribute values.
# 
#   @{ 
proc get_attr*(a2: ptr Tcanvas; a3: cint; a4: cint): uint32
proc set_attr*(a2: ptr Tcanvas; a3: uint32): cint
proc unset_attr*(a2: ptr Tcanvas; a3: uint32): cint
proc toggle_attr*(a2: ptr Tcanvas; a3: uint32): cint
proc put_attr*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: uint32): cint
proc set_color_ansi*(a2: ptr Tcanvas; a3: uint8; a4: uint8): cint
proc set_color_argb*(a2: ptr Tcanvas; a3: uint16; a4: uint16): cint
proc attr_to_ansi*(a2: uint32): uint8
proc attr_to_ansi_fg*(a2: uint32): uint8
proc attr_to_ansi_bg*(a2: uint32): uint8
proc attr_to_rgb12_fg*(a2: uint32): uint16
proc attr_to_rgb12_bg*(a2: uint32): uint16
proc attr_to_argb64*(a2: uint32; a3: array[8, uint8])
#  @} 
#* \defgroup caca_charset libcaca character set conversions
# 
#   These functions perform conversions between usual character sets.
# 
#   @{ 
proc utf8_to_utf32*(a2: cstring; a3: ptr csize): uint32
proc utf32_to_utf8*(a2: cstring; a3: uint32): csize
proc utf32_to_cp437*(a2: uint32): uint8
proc cp437_to_utf32*(a2: uint8): uint32
proc utf32_to_ascii*(a2: uint32): char
proc utf32_is_fullwidth*(a2: uint32): cint
#  @} 
#* \defgroup caca_primitives libcaca primitives drawing
# 
#   These functions provide routines for primitive drawing, such as lines,
#   boxes, triangles and ellipses.
# 
#   @{ 
proc draw_line*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cint; a6: cint; 
                a7: uint32): cint
proc draw_polyline*(a2: ptr Tcanvas; x: ptr cint; y: ptr cint; a5: cint; 
                    a6: uint32): cint
proc draw_thin_line*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cint; a6: cint): cint
proc draw_thin_polyline*(a2: ptr Tcanvas; x: ptr cint; y: ptr cint; a5: cint): cint
proc draw_circle*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cint; 
                  a6: uint32): cint
proc draw_ellipse*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cint; a6: cint; 
                   a7: uint32): cint
proc draw_thin_ellipse*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cint; 
                        a6: cint): cint
proc fill_ellipse*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cint; a6: cint; 
                   a7: uint32): cint
proc draw_box*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cint; a6: cint; 
               a7: uint32): cint
proc draw_thin_box*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cint; a6: cint): cint
proc draw_cp437_box*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cint; a6: cint): cint
proc fill_box*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cint; a6: cint; 
               a7: uint32): cint
proc draw_triangle*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cint; a6: cint; 
                    a7: cint; a8: cint; a9: uint32): cint
proc draw_thin_triangle*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cint; 
                         a6: cint; a7: cint; a8: cint): cint
proc fill_triangle*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cint; a6: cint; 
                    a7: cint; a8: cint; a9: uint32): cint
proc fill_triangle_textured*(cv: ptr Tcanvas; coords: array[6, cint]; 
                             tex: ptr Tcanvas; uv: array[6, cfloat]): cint
#  @} 
#* \defgroup caca_frame libcaca canvas frame handling
# 
#   These functions provide high level routines for canvas frame insertion,
#   removal, copying etc.
# 
#   @{ 
proc get_frame_count*(a2: ptr Tcanvas): cint
proc set_frame*(a2: ptr Tcanvas; a3: cint): cint
proc get_frame_name*(a2: ptr Tcanvas): cstring
proc set_frame_name*(a2: ptr Tcanvas; a3: cstring): cint
proc create_frame*(a2: ptr Tcanvas; a3: cint): cint
proc free_frame*(a2: ptr Tcanvas; a3: cint): cint
#  @} 
#* \defgroup caca_dither libcaca bitmap dithering
# 
#   These functions provide high level routines for dither allocation and
#   rendering.
# 
#   @{ 
proc create_dither*(a2: cint; a3: cint; a4: cint; a5: cint; a6: uint32; 
                    a7: uint32; a8: uint32; a9: uint32): ptr Tdither
proc set_dither_palette*(a2: ptr Tdither; r: ptr uint32; g: ptr uint32; 
                         b: ptr uint32; a: ptr uint32): cint
proc set_dither_brightness*(a2: ptr Tdither; a3: cfloat): cint
proc get_dither_brightness*(a2: ptr Tdither): cfloat
proc set_dither_gamma*(a2: ptr Tdither; a3: cfloat): cint
proc get_dither_gamma*(a2: ptr Tdither): cfloat
proc set_dither_contrast*(a2: ptr Tdither; a3: cfloat): cint
proc get_dither_contrast*(a2: ptr Tdither): cfloat
proc set_dither_antialias*(a2: ptr Tdither; a3: cstring): cint
proc get_dither_antialias_list*(a2: ptr Tdither): cstringArray
proc get_dither_antialias*(a2: ptr Tdither): cstring
proc set_dither_color*(a2: ptr Tdither; a3: cstring): cint
proc get_dither_color_list*(a2: ptr Tdither): cstringArray
proc get_dither_color*(a2: ptr Tdither): cstring
proc set_dither_charset*(a2: ptr Tdither; a3: cstring): cint
proc get_dither_charset_list*(a2: ptr Tdither): cstringArray
proc get_dither_charset*(a2: ptr Tdither): cstring
proc set_dither_algorithm*(a2: ptr Tdither; a3: cstring): cint
proc get_dither_algorithm_list*(a2: ptr Tdither): cstringArray
proc get_dither_algorithm*(a2: ptr Tdither): cstring
proc dither_bitmap*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cint; a6: cint; 
                    a7: ptr Tdither; a8: pointer): cint
proc free_dither*(a2: ptr Tdither): cint
#  @} 
#* \defgroup caca_charfont libcaca character font handling
# 
#   These functions provide character font handling routines.
# 
#   @{ 
when false:
  proc load_charfont*(a2: pointer; a3: csize): ptr Tcharfont
  proc free_charfont*(a2: ptr Tcharfont): cint
#  @} 
#* \defgroup caca_font libcaca bitmap font handling
# 
#   These functions provide bitmap font handling routines and high quality
#   canvas to bitmap rendering.
# 
#   @{ 
proc load_font*(a2: pointer; a3: csize): ptr Tfont
proc get_font_list*(): cstringArray
proc get_font_width*(a2: ptr Tfont): cint
proc get_font_height*(a2: ptr Tfont): cint
proc get_font_blocks*(a2: ptr Tfont): ptr uint32
proc render_canvas*(a2: ptr Tcanvas; a3: ptr Tfont; a4: pointer; a5: cint; 
                    a6: cint; a7: cint): cint
proc free_font*(a2: ptr Tfont): cint
#  @} 
#* \defgroup caca_figfont libcaca FIGfont handling
# 
#   These functions provide FIGlet and TOIlet font handling routines.
# 
#   @{ 
proc canvas_set_figfont*(a2: ptr Tcanvas; a3: cstring): cint
proc set_figfont_smush*(a2: ptr Tcanvas; a3: cstring): cint
proc set_figfont_width*(a2: ptr Tcanvas; a3: cint): cint
proc put_figchar*(a2: ptr Tcanvas; a3: uint32): cint
proc flush_figlet*(a2: ptr Tcanvas): cint
#  @} 
#* \defgroup caca_file libcaca file IO
# 
#   These functions allow to read and write files in a platform-independent
#   way.
#   @{ 
proc file_open*(a2: cstring; a3: cstring): ptr caca.Tfile
proc file_close*(a2: ptr caca.Tfile): cint
proc file_tell*(a2: ptr caca.Tfile): uint64
proc file_read*(a2: ptr caca.Tfile; a3: pointer; a4: csize): csize
proc file_write*(a2: ptr caca.Tfile; a3: pointer; a4: csize): csize
proc file_gets*(a2: ptr caca.Tfile; a3: cstring; a4: cint): cstring
proc file_eof*(a2: ptr caca.Tfile): cint
#  @} 
#* \defgroup caca_importexport libcaca importers/exporters from/to various
#   formats
# 
#   These functions import various file formats into a new canvas, or export
#   the current canvas to various text formats.
# 
#   @{ 
proc import_canvas_from_memory*(a2: ptr Tcanvas; a3: pointer; a4: csize; 
                                a5: cstring): cint#scsize
proc import_canvas_from_file*(a2: ptr Tcanvas; a3: cstring; a4: cstring): cint#scsize
proc import_area_from_memory*(a2: ptr Tcanvas; a3: cint; a4: cint; 
                              a5: pointer; a6: csize; a7: cstring): cint#scsize
proc import_area_from_file*(a2: ptr Tcanvas; a3: cint; a4: cint; 
                            a5: cstring; a6: cstring): cint#scsize
proc get_import_list*(): cstringArray
proc export_canvas_to_memory*(a2: ptr Tcanvas; a3: cstring; a4: ptr csize): pointer
proc export_area_to_memory*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cint; 
                            a6: cint; a7: cstring; a8: ptr csize): pointer
proc get_export_list*(): cstringArray
#  @} 
#* \defgroup caca_display libcaca display functions
# 
#   These functions provide the basic \e libcaca routines for display
#   initialisation, system information retrieval and configuration.
# 
#   @{ 
proc create_display*(a2: ptr Tcanvas): ptr Tdisplay
proc create_display_with_driver*(a2: ptr Tcanvas; a3: cstring): ptr Tdisplay
proc get_display_driver_list*(): cstringArray
proc get_display_driver*(a2: ptr Tdisplay): cstring
proc set_display_driver*(a2: ptr Tdisplay; a3: cstring): cint
proc free_display*(a2: ptr Tdisplay): cint
proc get_canvas*(a2: ptr Tdisplay): ptr Tcanvas
proc refresh_display*(a2: ptr Tdisplay): cint
proc set_display_time*(a2: ptr Tdisplay; a3: cint): cint
proc get_display_time*(a2: ptr Tdisplay): cint
proc get_display_width*(a2: ptr Tdisplay): cint
proc get_display_height*(a2: ptr Tdisplay): cint
proc set_display_title*(a2: ptr Tdisplay; a3: cstring): cint
proc set_mouse*(a2: ptr Tdisplay; a3: cint): cint
proc set_cursor*(a2: ptr Tdisplay; a3: cint): cint
#  @} 
#* \defgroup caca_event libcaca event handling
# 
#   These functions handle user events such as keyboard input and mouse
#   clicks.
# 
#   @{ 
type PEvent* = (ptr Tevent)|(var Tevent)
proc get_event*(a2: ptr Tdisplay; a3: cint; a4: ptr Tevent; a5: cint): cint
proc get_mouse_x*(a2: ptr Tdisplay): cint
proc get_mouse_y*(a2: ptr Tdisplay): cint
proc get_event_type*(a2: ptr Tevent): Tevent_type
proc get_event_key_ch*(a2: ptr Tevent): cint
proc get_event_key_utf32*(a2: ptr Tevent): uint32
proc get_event_key_utf8*(a2: ptr Tevent; a3: cstring): cint
proc get_event_mouse_button*(a2: ptr Tevent): cint
proc get_event_mouse_x*(a2: Pevent): cint
proc get_event_mouse_y*(a2: Pevent): cint
proc get_event_resize_width*(a2: ptr Tevent): cint
proc get_event_resize_height*(a2: ptr Tevent): cint
#  @} 
#* \defgroup caca_process libcaca process management
# 
#   These functions help with various process handling tasks such as
#   option parsing, DLL injection.
# 
#   @{ 
var optind*: cint
var optarg*: cstring
proc getopt*(a2: cint; a3: ptr cstring; a4: cstring; a5: ptr Toption; 
             a6: ptr cint): cint

{.pop.}

#  @} 
#* \brief DOS colours
# 
#   This enum lists the colour values for the DOS conio.h compatibility
#   layer.
# 
type 
  TCACA_CONIO_COLORS* = enum 
    CACA_CONIO_BLACK = 0, CACA_CONIO_BLUE = 1, 
    CACA_CONIO_GREEN = 2, CACA_CONIO_CYAN = 3, CACA_CONIO_RED = 4, 
    CACA_CONIO_MAGENTA = 5, CACA_CONIO_BROWN = 6, CACA_CONIO_LIGHTGRAY = 7, 
    CACA_CONIO_DARKGRAY = 8, CACA_CONIO_LIGHTBLUE = 9, 
    CACA_CONIO_LIGHTGREEN = 10, CACA_CONIO_LIGHTCYAN = 11, 
    CACA_CONIO_LIGHTRED = 12, CACA_CONIO_LIGHTMAGENTA = 13, 
    CACA_CONIO_YELLOW = 14, CACA_CONIO_WHITE = 15,
    CACA_CONIO_BLINK = 128
#* \brief DOS cursor modes
# 
#   This enum lists the cursor mode values for the DOS conio.h compatibility
#   layer.
# 
type 
  TCACA_CONIO_CURSOR* = enum 
    CACA_CONIO_NOCURSOR = 0, CACA_CONIO_SOLIDCURSOR = 1, 
    CACA_CONIO_NORMALCURSOR = 2
#* \brief DOS video modes
# 
#   This enum lists the video mode values for the DOS conio.h compatibility
#   layer.
# 
type 
  TCACA_CONIO_MODE* = enum 
    CACA_CONIO_LASTMODE = - 1, CACA_CONIO_BW40 = 0, CACA_CONIO_C40 = 1, 
    CACA_CONIO_BW80 = 2, CACA_CONIO_C80 = 3, CACA_CONIO_MONO = 7, 
    CACA_CONIO_C4350 = 64
#* \brief DOS text area information
# 
#   This structure stores text area information for the DOS conio.h
#   compatibility layer.
# 
type 
  Tconio_text_info* = object 
    winleft*: cuchar        #*< left window coordinate 
    wintop*: cuchar         #*< top window coordinate 
    winright*: cuchar       #*< right window coordinate 
    winbottom*: cuchar      #*< bottom window coordinate 
    attribute*: cuchar      #*< text attribute 
    normattr*: cuchar       #*< normal attribute 
    currmode*: cuchar       #*< current video mode:
                            #                                       BW40, BW80, C40, C80, or C4350 
    screenheight*: cuchar   #*< text screen's height 
    screenwidth*: cuchar    #*< text screen's width 
    curx*: cuchar           #*< x-coordinate in current window 
    cury*: cuchar           #*< y-coordinate in current window 


var conio_wscroll*{.importc:"caca_conio__wscroll",dynlib:libname.}: cint
proc conio_setcursortype*(cur_t: cint){.importc:"caca_conio__setcursortype",dynlib:libname.}
pp

#* \brief DOS direct video control 
var conio_directvideo*: cint
#* \brief DOS scrolling control 
#* \defgroup conio libcaca DOS conio.h compatibility layer
# 
#   These functions implement DOS-like functions for high-level text
#   operations.
# 
#   @{ 
proc conio_cgets*(str: cstring): cstring
proc conio_clreol*()
proc conio_clrscr*()
proc conio_cprintf*(format: cstring): cint {.varargs.}
proc conio_cputs*(str: cstring): cint
proc conio_cscanf*(format: cstring): cint {.varargs.}
proc conio_delay*(a2: cuint)
proc conio_delline*()
proc conio_getch*(): cint
proc conio_getche*(): cint
proc conio_getpass*(prompt: cstring): cstring
proc conio_gettext*(left: cint; top: cint; right: cint; bottom: cint; 
                    destin: pointer): cint
proc conio_gettextinfo*(r: ptr Tconio_text_info)
proc conio_gotoxy*(x: cint; y: cint)
proc conio_highvideo*()
proc conio_insline*()
proc conio_kbhit*(): cint
proc conio_lowvideo*()
proc conio_movetext*(left: cint; top: cint; right: cint; bottom: cint; 
                     destleft: cint; desttop: cint): cint
proc conio_normvideo*()
proc conio_nosound*()
proc conio_printf*(format: cstring): cint {.varargs.}
proc conio_putch*(ch: cint): cint
proc conio_puttext*(left: cint; top: cint; right: cint; bottom: cint; 
                    destin: pointer): cint
proc conio_sleep*(a2: cuint)
proc conio_sound*(a2: cuint)
proc conio_textattr*(newattr: cint)
proc conio_textbackground*(newcolor: cint)
proc conio_textcolor*(newcolor: cint)
proc conio_textmode*(newmode: cint)
proc conio_ungetch*(ch: cint): cint
proc conio_wherex*(): cint
proc conio_wherey*(): cint
proc conio_window*(left: cint; top: cint; right: cint; bottom: cint)
#  @} 
when false:#not defined(DOXYGEN_SKIP_ME): 
  # Legacy stuff from beta versions, will probably disappear in 1.0 
  type 
    Tcucul_buffer_t* = Tcucul_buffer
  # #   if defined __GNUC__ && __GNUC__ >= 3
  ##       define CACA_DEPRECATED __attribute__ ((__deprecated__))
  ##   else
  ##       define CACA_DEPRECATED
  ##   endif
  #
  ##   if defined __GNUC__ && __GNUC__ > 3
  ##       define CACA_ALIAS(x) __attribute__ ((weak, alias(#x)))
  ##   else
  ##       define CACA_ALIAS(x)
  ##   endif
  # 
  # Aliases from old libcaca and libcucul functions 
  proc cucul_putchar*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: culong): cint
  proc cucul_getchar*(a2: ptr Tcanvas; a3: cint; a4: cint): culong
  proc cucul_putstr*(a2: ptr Tcanvas; a3: cint; a4: cint; a5: cstring): cint
  proc cucul_set_color*(a2: ptr Tcanvas; a3: cuchar; a4: cuchar): cint
  proc cucul_set_truecolor*(a2: ptr Tcanvas; a3: cuint; a4: cuint): cint
  proc cucul_get_canvas_frame_count*(a2: ptr Tcanvas): cuint
  proc cucul_set_canvas_frame*(a2: ptr Tcanvas; a3: cuint): cint
  proc cucul_create_canvas_frame*(a2: ptr Tcanvas; a3: cuint): cint
  proc cucul_free_canvas_frame*(a2: ptr Tcanvas; a3: cuint): cint
  proc cucul_load_memory*(a2: pointer; a3: culong): ptr Tcucul_buffer_t
  proc cucul_load_file*(a2: cstring): ptr Tcucul_buffer_t
  proc cucul_get_buffer_size*(a2: ptr Tcucul_buffer_t): culong
  proc cucul_get_buffer_data*(a2: ptr Tcucul_buffer_t): pointer
  proc cucul_free_buffer*(a2: ptr Tcucul_buffer_t): cint
  proc cucul_export_canvas*(a2: ptr Tcanvas; a3: cstring): ptr Tcucul_buffer_t
  proc cucul_import_canvas*(a2: ptr Tcucul_buffer_t; a3: cstring): ptr Tcanvas
  proc import_memory*(a2: ptr Tcanvas; a3: pointer; a4: csize; a5: cstring): cint#scsize
  proc import_file*(a2: ptr Tcanvas; a3: cstring; a4: cstring): cint#scsize
  proc export_memory*(a2: ptr Tcanvas; a3: cstring; a4: ptr csize): pointer
  proc cucul_rotate*(a2: ptr Tcanvas): cint
  proc cucul_set_dither_invert*(a2: ptr Tdither; a3: cint): cint
  proc cucul_set_dither_mode*(a2: ptr Tdither; a3: cstring): cint
  proc cucul_get_dither_mode_list*(a2: ptr Tdither): cstringArray
  const 
    CUCUL_COLOR_BLACK* = CACA_BLACK
    CUCUL_COLOR_BLUE* = CACA_BLUE
    CUCUL_COLOR_GREEN* = CACA_GREEN
    CUCUL_COLOR_CYAN* = CACA_CYAN
    CUCUL_COLOR_RED* = CACA_RED
    CUCUL_COLOR_MAGENTA* = CACA_MAGENTA
    CUCUL_COLOR_BROWN* = CACA_BROWN
    CUCUL_COLOR_LIGHTGRAY* = CACA_LIGHTGRAY
    CUCUL_COLOR_DARKGRAY* = CACA_DARKGRAY
    CUCUL_COLOR_LIGHTBLUE* = CACA_LIGHTBLUE
    CUCUL_COLOR_LIGHTGREEN* = CACA_LIGHTGREEN
    CUCUL_COLOR_LIGHTCYAN* = CACA_LIGHTCYAN
    CUCUL_COLOR_LIGHTRED* = CACA_LIGHTRED
    CUCUL_COLOR_LIGHTMAGENTA* = CACA_LIGHTMAGENTA
    CUCUL_COLOR_YELLOW* = CACA_YELLOW
    CUCUL_COLOR_WHITE* = CACA_YELLOW
    CUCUL_COLOR_DEFAULT* = CACA_DEFAULT
    CUCUL_COLOR_TRANSPARENT* = CACA_TRANSPARENT
  # Aliases from the libcucul/libcaca merge 
  const 
    cucul_canvas_t* = Tcanvas
    cucul_dither_t* = Tdither
    cucul_font_t* = Tfont
    cucul_file_t* = caca.Tfile
    cucul_display_t* = Tdisplay
    cucul_event_t* = Tevent_t
    CUCUL_BLACK* = CACA_BLACK
    CUCUL_BLUE* = CACA_BLUE
    CUCUL_GREEN* = CACA_GREEN
    CUCUL_CYAN* = CACA_CYAN
    CUCUL_RED* = CACA_RED
    CUCUL_MAGENTA* = CACA_MAGENTA
    CUCUL_BROWN* = CACA_BROWN
    CUCUL_LIGHTGRAY* = CACA_LIGHTGRAY
    CUCUL_DARKGRAY* = CACA_DARKGRAY
    CUCUL_LIGHTBLUE* = CACA_LIGHTBLUE
    CUCUL_LIGHTGREEN* = CACA_LIGHTGREEN
    CUCUL_LIGHTCYAN* = CACA_LIGHTCYAN
    CUCUL_LIGHTRED* = CACA_LIGHTRED
    CUCUL_LIGHTMAGENTA* = CACA_LIGHTMAGENTA
    CUCUL_YELLOW* = CACA_YELLOW
    CUCUL_WHITE* = CACA_YELLOW
    CUCUL_DEFAULT* = CACA_DEFAULT
    CUCUL_TRANSPARENT* = CACA_TRANSPARENT
    CUCUL_BOLD* = CACA_BOLD
    CUCUL_ITALICS* = CACA_ITALICS
    CUCUL_UNDERLINE* = CACA_UNDERLINE
    CUCUL_BLINK* = CACA_BLINK
  # #   if !defined __LIBCACA__
  ##       define caca_get_cursor_x caca_wherex
  ##       define caca_get_cursor_y caca_wherey
  ##       define cucul_draw_triangle caca_draw_triangle
  ##       define cucul_draw_thin_triangle caca_draw_thin_triangle
  ##       define cucul_fill_triangle caca_fill_triangle
  ##       define cucul_load_font caca_load_font
  ##       define cucul_get_font_list caca_get_font_list
  ##       define cucul_get_font_width caca_get_font_width
  ##       define cucul_get_font_height caca_get_font_height
  ##       define cucul_get_font_blocks caca_get_font_blocks
  ##       define cucul_render_canvas caca_render_canvas
  ##       define cucul_free_font caca_free_font
  ##       define cucul_gotoxy caca_gotoxy
  ##       define cucul_get_cursor_x caca_wherex
  ##       define cucul_get_cursor_y caca_wherey
  ##       define cucul_put_char caca_put_char
  ##       define cucul_get_char caca_get_char
  ##       define cucul_put_str caca_put_str
  ##       define cucul_printf caca_printf
  ##       define cucul_clear_canvas caca_clear_canvas
  ##       define cucul_set_canvas_handle caca_set_canvas_handle
  ##       define cucul_get_canvas_handle_x caca_get_canvas_handle_x
  ##       define cucul_get_canvas_handle_y caca_get_canvas_handle_y
  ##       define cucul_blit caca_blit
  ##       define cucul_set_canvas_boundaries caca_set_canvas_boundaries
  ##       define cucul_import_memory caca_import_memory
  ##       define cucul_import_file caca_import_file
  ##       define cucul_get_import_list caca_get_import_list
  ##       define cucul_create_canvas caca_create_canvas
  ##       define cucul_manage_canvas caca_manage_canvas
  ##       define cucul_unmanage_canvas caca_unmanage_canvas
  ##       define cucul_set_canvas_size caca_set_canvas_size
  ##       define cucul_get_canvas_width caca_get_canvas_width
  ##       define cucul_get_canvas_height caca_get_canvas_height
  ##       define cucul_get_canvas_chars caca_get_canvas_chars
  ##       define cucul_get_canvas_attrs caca_get_canvas_attrs
  ##       define cucul_free_canvas caca_free_canvas
  ##       define cucul_rand caca_rand
  ##       define cucul_export_memory caca_export_memory
  ##       define cucul_get_export_list caca_get_export_list
  ##       define cucul_get_version caca_get_version
  ##       define cucul_utf8_to_utf32 caca_utf8_to_utf32
  ##       define cucul_utf32_to_utf8 caca_utf32_to_utf8
  ##       define cucul_utf32_to_cp437 caca_utf32_to_cp437
  ##       define cucul_cp437_to_utf32 caca_cp437_to_utf32
  ##       define cucul_utf32_to_ascii caca_utf32_to_ascii
  ##       define cucul_utf32_is_fullwidth caca_utf32_is_fullwidth
  ##       define cucul_draw_circle caca_draw_circle
  ##       define cucul_draw_ellipse caca_draw_ellipse
  ##       define cucul_draw_thin_ellipse caca_draw_thin_ellipse
  ##       define cucul_fill_ellipse caca_fill_ellipse
  ##       define cucul_canvas_set_figfont caca_canvas_set_figfont
  ##       define cucul_put_figchar caca_put_figchar
  ##       define cucul_flush_figlet caca_flush_figlet
  ##       define cucul_putchar caca_putchar
  ##       define cucul_getchar caca_getchar
  ##       define cucul_get_attr caca_get_attr
  ##       define cucul_set_attr caca_set_attr
  ##       define cucul_put_attr caca_put_attr
  ##       define cucul_set_color_ansi caca_set_color_ansi
  ##       define cucul_set_color_argb caca_set_color_argb
  ##       define cucul_attr_to_ansi caca_attr_to_ansi
  ##       define cucul_attr_to_ansi_fg caca_attr_to_ansi_fg
  ##       define cucul_attr_to_ansi_bg caca_attr_to_ansi_bg
  ##       define cucul_attr_to_rgb12_fg caca_attr_to_rgb12_fg
  ##       define cucul_attr_to_rgb12_bg caca_attr_to_rgb12_bg
  ##       define cucul_attr_to_argb64 caca_attr_to_argb64
  ##       define cucul_invert caca_invert
  ##       define cucul_flip caca_flip
  ##       define cucul_flop caca_flop
  ##       define cucul_rotate_180 caca_rotate_180
  ##       define cucul_rotate_left caca_rotate_left
  ##       define cucul_rotate_right caca_rotate_right
  ##       define cucul_stretch_left caca_stretch_left
  ##       define cucul_stretch_right caca_stretch_right
  ##       define cucul_file_open caca_file_open
  ##       define cucul_file_close caca_file_close
  ##       define cucul_file_tell caca_file_tell
  ##       define cucul_file_read caca_file_read
  ##       define cucul_file_write caca_file_write
  ##       define cucul_file_gets caca_file_gets
  ##       define cucul_file_eof caca_file_eof
  ##       define cucul_create_dither caca_create_dither
  ##       define cucul_set_dither_palette caca_set_dither_palette
  ##       define cucul_set_dither_brightness caca_set_dither_brightness
  ##       define cucul_get_dither_brightness caca_get_dither_brightness
  ##       define cucul_set_dither_gamma caca_set_dither_gamma
  ##       define cucul_get_dither_gamma caca_get_dither_gamma
  ##       define cucul_set_dither_contrast caca_set_dither_contrast
  ##       define cucul_get_dither_contrast caca_get_dither_contrast
  ##       define cucul_set_dither_antialias caca_set_dither_antialias
  ##       define cucul_get_dither_antialias_list caca_get_dither_antialias_list
  ##       define cucul_get_dither_antialias caca_get_dither_antialias
  ##       define cucul_set_dither_color caca_set_dither_color
  ##       define cucul_get_dither_color_list caca_get_dither_color_list
  ##       define cucul_get_dither_color caca_get_dither_color
  ##       define cucul_set_dither_charset caca_set_dither_charset
  ##       define cucul_get_dither_charset_list caca_get_dither_charset_list
  ##       define cucul_get_dither_charset caca_get_dither_charset
  ##       define cucul_set_dither_algorithm caca_set_dither_algorithm
  ##       define cucul_get_dither_algorithm_list caca_get_dither_algorithm_list
  ##       define cucul_get_dither_algorithm caca_get_dither_algorithm
  ##       define cucul_dither_bitmap caca_dither_bitmap
  ##       define cucul_free_dither caca_free_dither
  ##       define cucul_draw_line caca_draw_line
  ##       define cucul_draw_polyline caca_draw_polyline
  ##       define cucul_draw_thin_line caca_draw_thin_line
  ##       define cucul_draw_thin_polyline caca_draw_thin_polyline
  ##       define cucul_draw_box caca_draw_box
  ##       define cucul_draw_thin_box caca_draw_thin_box
  ##       define cucul_draw_cp437_box caca_draw_cp437_box
  ##       define cucul_fill_box caca_fill_box
  ##       define cucul_get_frame_count caca_get_frame_count
  ##       define cucul_set_frame caca_set_frame
  ##       define cucul_get_frame_name caca_get_frame_name
  ##       define cucul_set_frame_name caca_set_frame_name
  ##       define cucul_create_frame caca_create_frame
  ##       define cucul_free_frame caca_free_frame
  ##   endif 

{.pop.}
{.pop.}

