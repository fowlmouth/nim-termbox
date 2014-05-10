# 
#                AA-lib, an ascii-art gfx library
#                   Copyright (C) 1998,1999,2001 by
# 
#       Jan Hubicka          (hubicka@freesoft.cz)
#       Kamil Toman          (toman@artax.karlin.mff.cuni.cz)
# 
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU Library General Public License as published
#  by the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
# 
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
# 
#  You should have received a copy of the GNU Library General Public
#  License along with this program; if not, write to the Free Software
#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
# 

const 
  AA_LIB_VERSION* = 1
  AA_LIB_MINNOR* = 4 #lol.

when defined(Linux):
  const LibName* = "libaa.so.1.0.4"
else:
  const LibName* = "aa.dll.1.0.4"

{.push callconv:cdecl.}

const
  AA_LIB_VERSIONCODE* = 104000
  AA_NATTRS* = 5
  AA_NPARAMS* = 5
  AA_RESIZE* = 258
  AA_MOUSE* = 259
  AA_UP* = 300
  AA_DOWN* = 301
  AA_LEFT* = 302
  AA_RIGHT* = 303
  AA_BACKSPACE* = 304
  AA_ESC* = 305
  AA_UNKNOWN* = 400
  AA_RELEASE* = 65536
  AA_NORMAL_MASK* = 1
  AA_DIM_MASK* = 2
  AA_BOLD_MASK* = 4
  AA_BOLDFONT_MASK* = 8
  AA_REVERSE_MASK* = 16
  AA_ALL* = 128
  AA_EIGHT* = 256
  AA_EXTENDED* = (AA_ALL or AA_EIGHT)
# The characters may be output with following attributes:  
type 
  Tattribute* {.size:sizeof(cint).} = enum 
    AA_NORMAL = 0,          # Normal characters.  
    AA_DIM = 1,             # Dark characters.  
    AA_BOLD = 2,            # Bright characters.  
    AA_BOLDFONT = 3,        # Characters rendered in bold font.  
    AA_REVERSE = 4,         # Reversed (black on whilte) characters.  
    AA_SPECIAL = 5
const
    AA_NONE* = 0
    AA_ERRORDISTRIB* = 1 # Error distribution.  
    AA_FLOYD_S* = 2         # Floyd-Steinberg dithering.  
    AA_DITHERTYPES* = 3
const 
  AA_BUTTON1* = 1
  AA_BUTTON2* = 2
  AA_BUTTON3* = 4
  AA_MOUSEMOVEMASK* = 1
  AA_MOUSEPRESSMASK* = 2
  AA_PRESSEDMOVEMASK* = 4
  AA_MOUSEALLMASK* = 7
  AA_HIDECURSOR* = 8
  AA_SENDRELEASE* = 1
  AA_KBDALLMASK* = 1
  AA_USE_PAGES* = 1
  AA_NORMAL_SPACES* = 8
# These structures are subject to change in future. Thus they are hidden
#   behind final user.  

type 
  Tedit* = object 
  
type 
  Tfont* = object 
    data*: ptr cuchar       # Bitmap of 8xheight font.  
    height*: cint           # Height of font.  
    name*: cstring          # Long name of font.  
    shortname*: cstring     # One-word name of the font.  

type 
  Thardware_params* = object 
    font*: ptr Tfont         #Font bitmap used by hardware.  
    supported*: cint        #Mask of supported features.
                            #            Following masks are available:
                            #            AA_NORMAL_MASK, AA_DIM_MASK,
                            #     AA_BOLD_MASK, AA_BOLDFONT_MASK,
                            #            AA_REVERSE_MASK
                            #           
    minwidth*: cint
    minheight*: cint        #Minimal alowed screen size 
                            #     in characters  
    maxwidth*: cint
    maxheight*: cint        #Maximal alowed screen size 
                            #     in characters  
    recwidth*: cint
    recheight*: cint        #Recommended screen size (driver
                            #     attempts to find resolution nearest
                            #     to this value within given bounds
                            #     bit min and max fields  
    mmwidth*: cint
    mmheight*: cint         #Physical screen size  
    width*: cint
    height*: cint           #Current screen size  
    dimmul*: cdouble        #Bright value of dim characters (0 black,
                            #     1 white)  
    boldmul*: cdouble       #Bright value of bold characters 
                            #     (0 black, 1 white)  
  
#
#  aa_context contains information about the display. It is passed to most
#  of AA-lib functions.  The full definition of structure is present just
#  for compatibility with older programs. Dirrect access to it's fields
#  is not recommended, because you might surfer to problems with future
#  releases of AA-lib.  Use standard AA-lib functions instead.  
# 
type 
  Tcontext* = object 
    driver*: ptr Tdriver    #Current display driver  
    kbddriver*: ptr Tkbddriver #Current keyboard driver 
    mousedriver*: ptr Tmousedriver #Current mouse driver 
    params*: Thardware_params #Parameters of output
                              #           hardware used by AA-lib. 
    driverparams*: Thardware_params #Parameters of output
                                    #          hardware as reported
                                    #          by display driver. 
    mulx*: cint
    muly*: cint             # Ratio of character size over pixel size  
    imgwidth*: cint
    imgheight*: cint        # Dimensions of emulated image  
    imagebuffer*: ptr cuchar # Virtual buffer containing image 
    textbuffer*: ptr cuchar # Virtual buffer containing text 
    attrbuffer*: ptr cuchar # Virtual buffer containing attributes 
    table*: ptr cushort # Precalculated values used by rendering
                        #       algorithm.
                        #       
                        #       WARNING!
                        #       It is _strongly_ depreached
                        #       to access fields behind this point, because
                        #       they can change in future releases.
    filltable*: ptr cushort
    parameters*: pointer# TODO "struct paramaters" missing from aalib.h?? ptr parameters
    cursorx*: cint
    cursory*: cint
    cursorstate*: cint      # Cursor possition. 
    mousex*: cint
    mousey*: cint
    buttons*: cint
    mousemode*: cint        # Mouse state.  
    resizehandler*: proc (a2: ptr Tcontext) # Handler to be called when
                                            #          resize happends.  
    driverdata*: pointer    # Internal data used by hardware drivers.  
    kbddriverdata*: pointer
    mousedriverdata*: pointer

  #
  #  The hardware driver specification.  Used internally by AA-lib only.
  #  Provided for compatibility with older programs.
  # 
  Tdriver* = object 
    shortname*: cstring
    name*: cstring
    init*: proc (a2: ptr Thardware_params; a3: pointer; 
                 a4: ptr Thardware_params; a5: ptr pointer): cint
    uninit*: proc (a2: ptr Tcontext)
    getsize*: proc (a2: ptr Tcontext; a3: ptr cint; a4: ptr cint)
    setattr*: proc (a2: ptr Tcontext; a3: cint)
    print*: proc (a2: ptr Tcontext; a3: cstring)
    gotoxy*: proc (a2: ptr Tcontext; a3: cint; a4: cint)
    flush*: proc (a2: ptr Tcontext)
    cursormode*: proc (a2: ptr Tcontext; a3: cint)

  #
  #  The hardware driver specification.  Used internally by AA-lib only.
  #  Provided for compatibility with older programs.
  # 
  Tkbddriver* = object 
    shortname*: cstring
    name*: cstring
    flags*: cint
    init*: proc (a2: ptr Tcontext; mode: cint): cint
    uninit*: proc (a2: ptr Tcontext)
    getkey*: proc (a2: ptr Tcontext; a3: cint): cint

  #
  #  The hardware driver specification.  Used internally by AA-lib only.
  #  Provided for compatibility with older programs.
  # 
  Tmousedriver* = object 
    shortname*: cstring
    name*: cstring
    flags*: cint
    init*: proc (a2: ptr Tcontext; mode: cint): cint
    uninit*: proc (a2: ptr Tcontext)
    getmouse*: proc (a2: ptr Tcontext; a3: ptr cint; a4: ptr cint; 
                     a5: ptr cint)
    cursormode*: proc (a2: ptr Tcontext; a3: cint)

#
#  Parameters used for rendering.
# 
type 
  Trenderparams* = object 
    bright*: cint           # Brighness in range 0 (normal) to 255
                            #           (white)  
    contrast*: cint         # Contrast value in range 0 (normal)
                            #           to 127 (white)  
    gamma*: cfloat          # Gama value in the standard range  
    dither*: cint # Dithering algorithm 
    inversion*: cint        # Set 1 for inversed terminals (black on
                            #           white)  
    randomval*: cint        # Range of random value added to each
                            #           pixel. Used to crate random dithering
                            #           effect.  
  
  
#
#  Output format specification used by aa_save driver. 
# 
type 
  Tformat* = object 
    width*: cint
    height*: cint
    pagewidth*: cint
    pageheight*: cint
    flags*: cint
    supported*: cint
    font*: ptr Tfont
    formatname*: cstring
    extension*: cstring     #fields after this line may change in future versions
    head*: cstring
    `end`*: cstring
    newline*: cstring
    prints*: array[AA_NATTRS, cstring]
    begin*: array[AA_NATTRS, cstring]
    ends*: array[AA_NATTRS, cstring]
    conversions*: cstringArray

#
#  Initialization data used by aa_save driver. 
# 
type 
  Tsavedata* = object 
    name*: cstring # Base name of the output file. The page number and extension
                   #     is attached automatically.  
    format*: ptr Tformat    # Format to save into.  
    file*: TFILE         # You might specify output file by field too,
                            #     in case the name field is NULL
  
type 
  Tlinkedlist* = object
  #Treclist* = Tlinkedlist
  Tpalette* = array[256, cint]


{.push dynlib: libname, importc: "aa_$1".}
#
#  AA-lib driver used to save ascii-art image into file in used specified format. 
#  Initialize this driver using aa_init function and specify the driver
#  dependent parameters in aa_savedata structure to save image into file.
#  See the texinfo documentation for details.
# 
var save_d*: Tdriver
#
#  AA-lib memory driver.  
#  Used to render ascii-art images into memory. 
#  You might use this driver to render images into memory and then use your
#  own routines to handle them in case you want to avoid AA-lib's output
#  mechanizms.
# 
var mem_d*: Tdriver
#
#  AA-lib help string for the default command line parser.
# 
var help*: cstring
#
#  NULL terminated array of save formats supported by AA-lib.
# 
var formats*: ptr ptr Tformat
var 
  nhtml_format*: Tformat
  html_format*: Tformat
  html_alt_format*: Tformat
  ansi_format*: Tformat
  text_format*: Tformat
  more_format*: Tformat
  hp_format*: Tformat
  hp2_format*: Tformat
  irc_format*: Tformat
  zephyr_format*: Tformat
  htmlk_format*: Tformat
#
#  Null-terminated array of available fonts.
# 
var fonts*: ptr ptr Tfont
var 
  font8*: Tfont
  font14*: Tfont
  font16*: Tfont
  font9*: Tfont
  fontline*: Tfont
  fontgl*: Tfont
  fontX13*: Tfont
  fontX16*: Tfont
  fontX13B*: Tfont
  fontcourier*: Tfont
  fontvyhen*: Tfont
#
#  Names of dithering methods supported by AA-lib.
#  NULL terminated array containing the names of supported dithering methods
#  as ascii strings.
# 
var dithernames*: ptr array[aa_dithertypes, cstring]
#
#  NULL-terminated array of output drivers available in AA-lib.
# 
var drivers*: ptr ptr Tdriver
var 
  curses_d*: Tdriver
  dos_d*: Tdriver
  linux_d*: Tdriver
  slang_d*: Tdriver
  stdout_d*: Tdriver
  stderr_d*: Tdriver
  X11_d*: Tdriver
  os2vio_d*: Tdriver
#
#  NULL-terminated array of keyboard drivers available in AA_lib.
# 
var kbddrivers*: ptr ptr Tkbddriver
var 
  kbd_curses_d*: Tkbddriver
  kbd_slang_d*: Tkbddriver
  kbd_stdin_d*: Tkbddriver
  kbd_dos_d*: Tkbddriver
  kbd_X11_d*: Tkbddriver
  kbd_os2_d*: Tkbddriver
  kbd_linux_d*: Tkbddriver
#
#  NULL terminated array of mouse drivers supported by AA-lib.
# 
var mousedrivers*: ptr ptr Tmousedriver
var 
  mouse_curses_d*: Tmousedriver
  mouse_gpm_d*: Tmousedriver
  mouse_X11_d*: Tmousedriver
  mouse_dos_d*: Tmousedriver
  mouse_os2_d*: Tmousedriver
#
#  List of recommended drivers.
#  List of recommended drivers is used by aa_autoinit familly of functions
#  and altered by aa_recommend familly of functions.
# 
var 
  kbdrecommended*: ptr Tlinkedlist
  mouserecommended*: ptr Tlinkedlist
  displayrecommended*: ptr Tlinkedlist
#
#  default hardware paramters requested by AA-lib programs. Pa
#  Default hardware paramters requested by AA-lib programs. Passed to aa_init
#  function familly.
# 
var defparams*: Thardware_params

#
#  default rendering parameters.
#  Default rendering parameters. Passed to aa_render function familly.
# 
var defrenderparams*: Trenderparams
# returns width of the output screen in characters.  
proc scrwidth*(a: ptr Tcontext): cint
  # Specifies the AA-lib context to operate on. 
# returns height of the output screen in characters.  
proc scrheight*(a: ptr Tcontext): cint
  # Specifies the AA-lib context to operate on. 
# returns width of the output screen in millimeters.  
proc mmwidth*(a: ptr Tcontext): cint
  # Specifies the AA-lib context to operate on. 
# returns height of the output screen in millimeters.  
proc mmheight*(a: ptr Tcontext): cint
  # Specifies the AA-lib context to operate on. 
# returns width of the emulated image in pixels.  
proc imgwidth*(a: ptr Tcontext): cint
  # Specifies the AA-lib context to operate on. 
# returns height of the emulated image in pixels.  
proc imgheight*(a: ptr Tcontext): cint
  # Specifies the AA-lib context to operate on. 
#
#  returns pointer to the framebuffer emulated by AA-lib.
#  The framebuffer is simple array of characters specifying
#  the brightness value (or palette index depending on the aa_render
#  call). The array is organizated in the aa_imgheight (a) rows of
#  aa_imgwidth(a) characters.
#  Returns pointer to framebuffer emulated by AA-lib.
# 
proc image*(a: ptr Tcontext): cstring
  # Specifies the AA-lib context to operate on. 
#
#  returns pointer to the text output buffer used by AA-lib.
#  The text output buffer is simple array of characters specifying
#  the ascii-value of the characters.
#  The array is organizated in the aa_scrheight (a) rows of
#  aa_scrwidth(a) characters.
# 
#  Returns pointer the text output buffer used by AA-lib.
# 
proc text*(a: ptr Tcontext): cstring
  # Specifies the AA-lib context to operate on. 
#
#  returns pointer to the text output buffer used by AA-lib.
#  The attribute output buffer is simple array of characters specifying
#  the attributes.
#  The array is organizated in the aa_scrheight (a) rows of
#  aa_scrwidth(a) characters.
# 
#  Returns pointer the text output buffer used by AA-lib.
# 
proc attrs*(a: ptr Tcontext): cstring
  # Specifies the AA-lib context to operate on. 
#
#  returns specification of the fonts used by AA-lib rendering routines.
# 
proc currentfont*(a: ptr Tcontext): ptr Tfont
  # Specifies the AA-lib context to operate on. 
#
#  easy to use AA-lib initialization function. 
#  Attempts to find available output driver supporting the specified
#  parameters.  First attempts to initialize the recommended drivers
#  and then in order drivers available in the aa_drivers array
#  (all regular output drivers compiled into AA-lib).
#  Returns pointer to initialized context structure when succesfull or
#  NULL on failure.
# 
proc autoinit*(params: ptr Thardware_params): ptr Tcontext
  # Hardware parameters you want.  Use aa_defparams
  #             for default values.  
#
#  easy to use AA-lib keyboard initialization function. 
#  Attempts to find available keyboard driver supporting the specified
#  mode.  First attempts to initialize the recommended drivers
#  and then in order drivers available in the aa_kbddrivers array
#  (all regular output drivers compiled into AA-lib).
# 
#  Every AA-lib program ought to have call to aa_parseoptions before
#  first call to aa_init.
# 
#  Returns 1 when succesfull or 0 on failure.
# 
proc autoinitkbd*(context: ptr Tcontext; mode: cint): cint
  # Specifies the AA-lib context to operate on. 
  # Mask of extra features you request. Can contain
  #        AA_SENDRELEASE if you are interested in release events
  #        too. 
#
#  easy to use AA-lib mouse initialization function. 
#  Attempts to find available mouse driver supporting the specified
#  mode.  First attempts to initialize the recommended drivers
#  and then in order drivers available in the aa_kbddrivers array
#  (all regular output drivers compiled into AA-lib).
#  Returns 1 when succesfull or 0 on failure.
# 
proc autoinitmouse*(c: ptr Tcontext; mode: cint): cint
  # Specifies the AA-lib context to operate on. 
  # Mask of extra features you request.  No such features
  #          are available in the current AA-lib version.  
# insert the given driver on beggining of the list of recommended drivers.  
proc recommendhi*(l: ptr ptr Tlinkedlist; name: cstring)
  # List to operate on (aa_displayrecommended,
  #         aa_kbdrecommended or aa_mouserecommended) 
  # Name of the driver (ought to match the "shortname"
  #         field of the driver definition structure).  
# Add the given driver to the end of list of recommended drivers.  
proc recommendlow*(l: ptr ptr Tlinkedlist; name: cstring)
  # List to operate on (aa_displayrecommended,
  #         aa_kbdrecommended or aa_mouserecommended) 
  # Name of the driver (ought to match the "shortname"
  #         field of the driver definition structure).  
proc getfirst*(l: ptr ptr Tlinkedlist): cstring
#init functions 
#
#  open the output display for AA-lib. 
#  This is the most primitive AA-lib initialization function.
#  Allows better control over the process than the easier to use
#  aa_autoinit function.
# 
#  Every AA-lib program ought to have call to aa_parseoptions before
#  first call to aa_init.
# 
#  returns pointer to new AA-lib context or NULL if failed.  
# 
proc init*(driver: ptr Tdriver; defparams: ptr Thardware_params; 
           driverdata: pointer): ptr Tcontext
  # Driver you want to use.  Available drivers are listed
  #           in the NULL terminated aa_drivers array.  
  # Hardware parameters you want.  Use aa_defparams
  #           for default values.  
  # This pointer is passed dirrectly to driver used
  #           to specify additional driver dependent parameters. 
#
#  initialize the AA-lib keyboard driver. 
#  This is the most primitive AA-lib keyboard initialization function.
#  Allows better control over the process than the easier to use
#  aa_autoinitkbd function.
#  returns 1 on success and 0 on fail.  
# 
proc initkbd*(context: ptr Tcontext; drv: ptr Tkbddriver; mode: cint): cint
  # Specifies the AA-lib context to operate on.  
  # Driver you wish to use 
  # Mask of extra features you request. Can contain
  #    AA_SENDRELEASE if you are interested in release events
  #    too. 
#
#  initialize the AA-lib mouse driver. 
#  This is the most primitive AA-lib keyboard initialization function.
#  Allows better control over the process than the easier to use
#  aa_autoinitmouse function.
#  returns 1 on success and 0 on fail.  
# 
proc initmouse*(c: ptr Tcontext; d: ptr Tmousedriver; mode: cint): cint
  # Specifies the AA-lib context to operate on.  
  # Driver you wish to use.  
  # Mask of extra features you request.  No such features
  #        are available in the current AA-lib version.  
#uninicializing functions 
#
#  close the AA-lib context.
#  Uninitialize all activated drivers and frees the memory used by context
#  structures.
# 
proc close*(c: ptr Tcontext)
  # Specifies the AA-lib context to operate on.  
#
#  uninitialize the keyboard driver. 
#  Calls "uninitialize" function of the keyboard driver. It ought to undo
#  all actions done by "initialize" function.
# 
proc uninitkbd*(context: ptr Tcontext)
  # Specifies the AA-lib context to operate on.  
#
#  uninitialize the mouse driver. 
#  Calls "uninitialize" function of the mouse driver. It ought to undo
#  all actions done by "initialize" function.
# 
proc uninitmouse*(context: ptr Tcontext)
  # Specifies the AA-lib context to operate on.  
# simple and fast AA-lib rendering function.
#  This function does the trick of converting the emulated framebuffer
#  into high quality ASCII-art. It is slightly faster and less flexible
#  the aa_render function.
# 
#  Note that to see the effect you need to call aa_flush too.
# 
#  First call to this function may take a while, because the rendering
#  tables are produced.
# 
proc fastrender*(c: ptr Tcontext; x1: cint; y1: cint; x2: cint; y2: cint)
  # Specifies the AA-lib context to operate on.  
  # column of top left coner of rendered area
  #        (in characters!) 
  # row of top left coner of rendered area 
  # column of bottom right coner of rendered area 
  # row of bottom right coner of rendered area 
# convert image buffer to ASCII-art.
#  This function does the trick of converting the emulated framebuffer
#  into high quality ASCII-art. If you want to be really fast, you might
#  use aa_fastrender.  If you want to emulate palette, use aa_renderpalette.
# 
#  Note that to see the effect you need to call aa_flush too.
# 
#  First call to this function may take a while, because the rendering
#  tables are produced.
# 
proc render*(c: ptr Tcontext; p: ptr Trenderparams; x1: cint; y1: cint; 
             x2: cint; y2: cint)
  # Specifies the AA-lib context to operate on.  
  # Rendering parametters used to specify brightness, gamma
  #    correction and other usefull stuff. Use aa_defrenderparams
  #    for default values. 
  # column of top left coner of rendered area
  #           (in characters!) 
  # row of top left coner of rendered area 
  # column of bottom right coner of rendered area 
  # row of bottom right coner of rendered area 
proc renderpalette*(c: ptr Tcontext; table: Tpalette; p: ptr Trenderparams; 
                    x1: cint; y1: cint; x2: cint; y2: cint)
proc getrenderparams*(): ptr Trenderparams
proc flush*(c: ptr Tcontext)
# output string to AA-lib output buffers.
#   Output given string to AA-lib output buffers.  To see the effect you need to
#   call aa_flush too.  
proc puts*(c: ptr Tcontext; x: cint; y: cint; attr: Tattribute; s: cstring)
  # Specifies the AA-lib context to operate on.  
  # X coordinate of the first character.  
  # Y coordinate of the first character.  
  # Attribute to use.  
  # String to output.  
#
#  print text to AA-lib output buffers.
#  Print given text to AA-lib output buffers.  To see the effect you need to
#  call aa_flush too.  
# 
proc printf*(c: ptr Tcontext; x: cint; y: cint; attr: Tattribute; fmt: cstring): cint {.
    varargs.}
  # Specifies the AA-lib context to operate on.  
  # X coordinate of the first character.  
  # Y coordinate of the first character.  
  # Attribute to use.  
  # Text to output in standard printf format.  
#
#  move the hardware cursor (if any) to specified position. 
#  Move the hardware cursor (if any) to specified position. 
#  To see the effect you need to call aa_flush too.  
# 
proc gotoxy*(c: ptr Tcontext; x: cint; y: cint)
  # Specifies the AA-lib context to operate on.  
  # X coordinate of new position.  
  # Y coordinate of the position.  
#
#  hide the hardware cursor.
#  Hide the hardware cursor.
#  This function may be ignored by some drivers.
# 
proc hidecursor*(c: ptr Tcontext)
  # Specifies the AA-lib context to operate on.  
#
#  show the hardware cursor.
#  Show the hardware cursor.
#  This function may not be ignored by some drivers.
# 
proc showcursor*(c: ptr Tcontext)
  # Specifies the AA-lib context to operate on.  
#
#  Get mouse position as specified by last mouse event read by aa_getevent.
# 
proc getmouse*(c: ptr Tcontext; x: ptr cint; y: ptr cint; b: ptr cint)
  # Specifies the AA-lib context to operate on.  
  # Used to return X coordinate of mouse in characters.  
  # Used to return Y coordinate of mouse in characters.  
  # Used to return button mask of mouse. 
  #      (values used are AA_BUTTON1, AA_BUTTON2 and AA_BUTTON3)
#
#  hide the mouse cursor.
#  Hide the mouse cursor. 
#  This function may be ignored by some drivers.
# 
proc hidemouse*(c: ptr Tcontext)
#
#  show the mouse cursor.
#  Show the mouse cursor. 
#  This function may be ignored by some drivers.
# 
proc showmouse*(c: ptr Tcontext)
#
#  add new font specification to aa_fonts array.
#  Returns 1 when succesfull or 0 on failure.
# 
proc registerfont*(f: ptr Tfont): cint
  # Font specification structure. 
#
#  alter the "supported" field of hardware_params structure used by AA-lib
#  This function can be used to alter "supported" field of hardware-params
#  structure used by AA-lib. 
# 
proc setsupported*(c: ptr Tcontext; supported: cint)
  # Specifies the AA-lib context to operate on.  
  # New mask of requested features. Can contain
  #          AA_EXTENDED to enable use of all 256 characters
  #          and AA_EIGHT to enable use of the character numbered
  #          higher than 127.  
# set font specification to be used by rendering functions. 
proc setfont*(c: ptr Tcontext; font: ptr Tfont)
  # Specifies the AA-lib context to operate on.  
  # Font specification structure.  
#keyboard functions 
# return next event from queue.
#  Return next even from queue. Optionally wait for even when queue is
#  empty.
#  Returns next event from queue (values lower than 256 are used to report
#  ascii values of pressed keys and higher values have special meanings)
#  See the AA-lib texinfo documentation for more details.
#  0 is returned when queue is empty and wait is set to 0.
# 
proc getevent*(c: ptr Tcontext; wait: cint): cint
  # Specifies the AA-lib context to operate on.  
  # 1 if you wish to wait for the even when queue is empty.  
# return next keypress event from queue.
#  Returns next keypress event from queue (values lower than 256 are used
#  to report ascii values of pressed keys and higher values are used to
#  represent some special keys like arrows)
#  See the AA-lib texinfo documentation for more details.
# 
proc getkey*(c: ptr Tcontext; wait: cint): cint
  # Specifies the AA-lib context to operate on.  
  # 1 if you wish to wait for the even when queue is empty.  
#resize functions 
# 
#  Do resize action. This function ought to be called when application
#  takes into account the AA_RESIZE event.  The context is reinitialized
#  and set to new sizes.
#  Returns 0 when no resizing is done and 1 when resizing was succesfull.
# 
proc resize*(c: ptr Tcontext): cint
  # Specifies the AA-lib context to operate on.  
#
#  Set user handler to be called on resize event.
# 
proc resizehandler*(c: ptr Tcontext; handler: proc (a2: ptr Tcontext))
  # Specifies the AA-lib context to operate on.  
  # Function to be called when resize happends.  
#
#  parse the standard command line options used by AA-lib.
#  Use this function to parse the standard command line options used by
#  AA-lib. Every AA-lib program ought to call this function to let user
#  specify some extra parameters.  The function alters the aa_hardware_params
#  and aa_renderparams structures and removes known options from the
#  argc/argv lists. It also parse the AAOPTS environment variable.
#  When called with NULL for the argc/argv parameters, it parses AAOPTS
#  only. At least this call ought to be in every AA-lib program.
#  Returns 1 when sucesfull and 0 on failure. The program then can
#  print the help text available in aa_help variable.
# 
proc parseoptions*(p: ptr Thardware_params; r: ptr Trenderparams; 
                   argc: ptr cint; argv: cstringArray): cint
  # Hardware parameters structure to alter. It is expected
  #        that this structure only with necessary modifications
  #        will be later used to initialize the AA-lib context.  
  # Rendering prameters structure to alter. It is expected
  #        that this structure only with necessary modifications
  #        will be later used to render images.  
  # Pointer to argc parameter passed to function "main".  
  # Pointer to argv parameter passed to function "main".  
#
#  Simple interactive line editor.
#  This function produces the simple interactive line editor that can
#  be used by AA-lib programs to input strings.
# 
proc edit*(c: ptr Tcontext; x: cint; y: cint; size: cint; s: cstring; 
            maxsize: cint)
  # Specifies the AA-lib context to operate on.  
  # X coordinate of the edited text.  
  # Y coordinate of the edited text.  
  # Length of the editor window.  
  # Buffer to edit (containing default value).  
  # Size of the buffer.  
#
#  Simple interactive line editor provided as helper function.
# 
#  You might use this function to input strings in AA-lib programs.
#  This function initializes the aa_edit structure used by event-based
#  editor. You might then call the aa_editkey function when key is pressed.
# 
#  Returns pointer to edit context when succesfull and NULL on failure.
# 
proc createedit*(c: ptr Tcontext; x: cint; y: cint; size: cint; s: cstring; 
                 maxsize: cint): ptr Tedit
  # Specifies the AA-lib context to operate on.  
  # X coordinate of the edited text.  
  # Y coordinate of the edited text.  
  # Length of the editor window.  
  # Buffer to edit (containing default value).  
  # Size of the buffer.  
# Notify the line editor about keypress. 
proc editkey*(e: ptr Tedit; c: cint)
  # Editor context to use (see aa_createedit) 
  # Key pressed  
#
#  put pixel to emulated framebuffer
# 
proc putpixel*(c: ptr Tcontext; x: cint; y: cint; color: cint)
  # Specifies the AA-lib context to operate on.  
  # X coordinate. 
  # Y coordinate. 
  # Palette index or brightness value (0..255) 
# insert the given driver on beggining of the list of recommended keyboard drivers.  
proc recommendhikbd*(name: cstring)
  # Name of the driver (ought to match the "shortname"
  #         field of the driver definition structure).  
# Add the given driver to the end of list of keyboard recommended drivers.  
proc recommendlowkbd*(name: cstring)
  # Name of the driver (ought to match the "shortname"
  #         field of the driver definition structure).  
# insert the given driver on beggining of the list of recommended mouse drivers.  
proc recommendhimouse*(name: cstring)
  # Name of the driver (ought to match the "shortname"
  #         field of the driver definition structure).  
# Add the given driver to the end of list of mouse recommended drivers.  
proc recommendlowmouse*(name: cstring)
  # Name of the driver (ought to match the "shortname"
  #         field of the driver definition structure).  
# insert the given driver on beggining of the list of recommended display drivers.  
proc recommendhidisplay*(name: cstring)
  # Name of the driver (ought to match the "shortname"
  #         field of the driver definition structure).  
# Add the given driver to the end of list of display recommended drivers.  
proc recommendlowdisplay*(name: cstring)
  # Name of the driver (ought to match the "shortname"
  #         field of the driver definition structure).  
# This macro implementations are proved for faster compilation. 
#when defined(__GNUC__): 
# The putpixel macro can be implemented reliably only using GNU-C extension.  
##define aa_putpixel(c,x,y,color) ({aa_context *___aa_context=(c);  
#((___aa_context)->imagebuffer[(x)+(y)*(aa_imgwidth(___aa_context))]=(color)); 0;})
# #define aa_setpalette(palette,index,r,g,b) ((palette)[index]=(((r)*30+(g)*59+(b)*11)>>8))
##define aa_recommendhikbd(t) aa_recommendhi(&aa_kbdrecommended,t);
##define aa_recommendhimouse(t) aa_recommendhi(&aa_mouserecommended,t);
##define aa_recommendhidisplay(t) aa_recommendhi(&aa_displayrecommended,t);
##define aa_recommendlowkbd(t) aa_recommendlow(&aa_kbdrecommended,t);
##define aa_recommendlowmouse(t) aa_recommendlow(&aa_mouserecommended,t);
##define aa_recommendlowdisplay(t) aa_recommendlow(&aa_displayrecommended,t);
##define aa_scrwidth(a) ((a)->params.width)
##define aa_scrheight(a) ((a)->params.height)
##define aa_mmwidth(a) ((a)->params.mmwidth)
##define aa_mmheight(a) ((a)->params.mmheight)
##define aa_imgwidth(a) ((a)->imgwidth)
##define aa_imgheight(a) ((a)->imgheight)
##define aa_image(c) ((c)->imagebuffer)
##define aa_text(c) ((c)->textbuffer)
##define aa_attrs(c) ((c)->attrbuffer)

{.pop.}
{.pop.}

when isMainModule:
  const nimlogo = "http://nimrod-lang.org/assets/images/logo.png"
  
  var hwparams: THardwareParams
  hwparams.width = 80
  hwparams.height = 20
  let ctx = autoinit(hwparams.addr)

  ctx.close
 
