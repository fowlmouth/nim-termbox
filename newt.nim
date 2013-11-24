# https://fedorahosted.org/newt/
# http://gnewt.sourceforge.net/index_en.html

when defined(LINUX):
  const DLL_NAME = "libnewt.so"
else:
  {.error: "Newt is not set up for your operating system.".}

const 
  NEWT_COLORSET_ROOT* = 2
  NEWT_COLORSET_BORDER* = 3
  NEWT_COLORSET_WINDOW* = 4
  NEWT_COLORSET_SHADOW* = 5
  NEWT_COLORSET_TITLE* = 6
  NEWT_COLORSET_BUTTON* = 7
  NEWT_COLORSET_ACTBUTTON* = 8
  NEWT_COLORSET_CHECKBOX* = 9
  NEWT_COLORSET_ACTCHECKBOX* = 10
  NEWT_COLORSET_ENTRY* = 11
  NEWT_COLORSET_LABEL* = 12
  NEWT_COLORSET_LISTBOX* = 13
  NEWT_COLORSET_ACTLISTBOX* = 14
  NEWT_COLORSET_TEXTBOX* = 15
  NEWT_COLORSET_ACTTEXTBOX* = 16
  NEWT_COLORSET_HELPLINE* = 17
  NEWT_COLORSET_ROOTTEXT* = 18
  NEWT_COLORSET_EMPTYSCALE* = 19
  NEWT_COLORSET_FULLSCALE* = 20
  NEWT_COLORSET_DISENTRY* = 21
  NEWT_COLORSET_COMPACTBUTTON* = 22
  NEWT_COLORSET_ACTSELLISTBOX* = 23
  NEWT_COLORSET_SELLISTBOX* = 24
template NEWT_COLORSET_CUSTOM*(x: expr): expr = 
  (30 + (x))

const 
  NEWT_ARG_LAST* = - 100000
  NEWT_ARG_APPEND* = - 1
type 
  newtColors* {.pure, final.} = object 
    rootFg*: cstring
    rootBg*: cstring
    borderFg*: cstring
    borderBg*: cstring
    windowFg*: cstring
    windowBg*: cstring
    shadowFg*: cstring
    shadowBg*: cstring
    titleFg*: cstring
    titleBg*: cstring
    buttonFg*: cstring
    buttonBg*: cstring
    actButtonFg*: cstring
    actButtonBg*: cstring
    checkboxFg*: cstring
    checkboxBg*: cstring
    actCheckboxFg*: cstring
    actCheckboxBg*: cstring
    entryFg*: cstring
    entryBg*: cstring
    labelFg*: cstring
    labelBg*: cstring
    listboxFg*: cstring
    listboxBg*: cstring
    actListboxFg*: cstring
    actListboxBg*: cstring
    textboxFg*: cstring
    textboxBg*: cstring
    actTextboxFg*: cstring
    actTextboxBg*: cstring
    helpLineFg*: cstring
    helpLineBg*: cstring
    rootTextFg*: cstring
    rootTextBg*: cstring
    emptyScale*: cstring
    fullScale*: cstring
    disabledEntryFg*: cstring
    disabledEntryBg*: cstring
    compactButtonFg*: cstring
    compactButtonBg*: cstring
    actSelListboxFg*: cstring
    actSelListboxBg*: cstring
    selListboxFg*: cstring
    selListboxBg*: cstring

  newtFlagsSense* = enum 
    NEWT_FLAGS_SET, NEWT_FLAGS_RESET, NEWT_FLAGS_TOGGLE
const 
  NEWT_FLAG_RETURNEXIT* = (1 shl 0)
  NEWT_FLAG_HIDDEN* = (1 shl 1)
  NEWT_FLAG_SCROLL* = (1 shl 2)
  NEWT_FLAG_DISABLED* = (1 shl 3)
# OBSOLETE #define NEWT_FLAG_NOSCROLL 	(1 << 4)	for listboxes 
const 
  NEWT_FLAG_BORDER* = (1 shl 5)
  NEWT_FLAG_WRAP* = (1 shl 6)
  NEWT_FLAG_NOF12* = (1 shl 7)
  NEWT_FLAG_MULTIPLE* = (1 shl 8)
  NEWT_FLAG_SELECTED* = (1 shl 9)
  NEWT_FLAG_CHECKBOX* = (1 shl 10)
  NEWT_FLAG_PASSWORD* = (1 shl 11) # draw '*'  of chars in entrybox 
  NEWT_FLAG_SHOWCURSOR* = (1 shl 12) # Only applies to listbox for now 
  NEWT_FD_READ* = (1 shl 0)
  NEWT_FD_WRITE* = (1 shl 1)
  NEWT_FD_EXCEPT* = (1 shl 2)
  NEWT_CHECKBOXTREE_UNSELECTABLE* = (1 shl 12)
  NEWT_CHECKBOXTREE_HIDE_BOX* = (1 shl 13)
  NEWT_CHECKBOXTREE_COLLAPSED* = '\0'
  NEWT_CHECKBOXTREE_EXPANDED* = '\x01'
  NEWT_CHECKBOXTREE_UNSELECTED* = ' '
  NEWT_CHECKBOXTREE_SELECTED* = '*'
# Backwards compatibility 
const 
  NEWT_LISTBOX_RETURNEXIT* = NEWT_FLAG_RETURNEXIT
  NEWT_ENTRY_SCROLL* = NEWT_FLAG_SCROLL
  NEWT_ENTRY_HIDDEN* = NEWT_FLAG_HIDDEN
  NEWT_ENTRY_RETURNEXIT* = NEWT_FLAG_RETURNEXIT
  NEWT_ENTRY_DISABLED* = NEWT_FLAG_DISABLED
  NEWT_TEXTBOX_WRAP* = NEWT_FLAG_WRAP
  NEWT_TEXTBOX_SCROLL* = NEWT_FLAG_SCROLL
  NEWT_FORM_NOF12* = NEWT_FLAG_NOF12
type 
  newtComponent* = distinct pointer #ptr newtComponent_struct
  newtWinEntry* {.pure.} = object 
    text*: cstring
    value*: cstringArray  # may be initialized to set default 
    flags*: cint
  newtCallback* = proc (a2: newtComponent; a3: pointer)
  newtSuspendCallback* = proc (data: pointer)
 
  newtEntryFilter* = proc (entry: newtComponent; data: pointer; ch: cint; 
                           cursor: cint): cint

  newtGrid* = distinct pointer #ptr grid_s
 
  newtGridElement* = enum 
    NEWT_GRID_EMPTY = 0, NEWT_GRID_COMPONENT, NEWT_GRID_SUBGRID

  newtExitReason* = enum 
    NEWT_EXIT_HOTKEY, NEWT_EXIT_COMPONENT, NEWT_EXIT_FDREADY, NEWT_EXIT_TIMER, 
    NEWT_EXIT_ERROR
  newtExitStruct* = object{.pure.}
    case reason*: newtExitReason
    of NEWT_EXIT_COMPONENT: 
      co*: newtComponent
    else:
      watchKey*: cint
#
#struct newtExitStruct {
#    enum newtExitReason reason;
#    union {
# int watch;
# int key;
# newtComponent co;
#    } u;
#} ; 


{.push dynlib: DLL_NAME, callconv: cdecl.}
{.push importc: "newt$1".}

var DefaultColorPalette* {.nodecl.}: newtColors
proc Init*(): cint {.discardable.}
proc Finished*(): cint {.discardable.}
proc Cls*()
proc ResizeScreen*(redraw: cint)
proc WaitForKey*()
proc ClearKeyBuffer*()
proc Delay*(usecs: cuint)
# top, left are *not* counting the border 
proc OpenWindow*(left: cint; top: cint; width: cuint; height: cuint; 
                     title: cstring): cint
proc CenteredWindow*(width: cuint; height: cuint; title: cstring): cint
proc PopWindow*()
proc PopWindowNoRefresh*()
proc SetColors*(colors: newtColors)
proc SetColor*(colorset: cint; fg: cstring; bg: cstring)
proc Refresh*()
proc Suspend*()
proc SetSuspendCallback*(cb: newtSuspendCallback; data: pointer)
proc SetHelpCallback*(cb: newtCallback)
proc Resume*(): cint
proc PushHelpLine*(text: cstring)
proc RedrawHelpLine*()
proc PopHelpLine*()
proc DrawRootText*(col: cint; row: cint; text: cstring)
proc Bell*()
proc CursorOff*()
proc CursorOn*()
# Components 
proc CompactButton*(left: cint; top: cint; text: cstring): newtComponent
proc Button*(left: cint; top: cint; text: cstring): newtComponent
proc Checkbox*(left: cint; top: cint; text: cstring; defValue: char; 
                   seq: cstring; result: cstring): newtComponent
proc CheckboxGetValue*(co: newtComponent): char
proc CheckboxSetValue*(co: newtComponent; value: char)
proc CheckboxSetFlags*(co: newtComponent; flags: cint; 
                           sense: newtFlagsSense)
proc Radiobutton*(left: cint; top: cint; text: cstring; isDefault: cint; 
                      prevButton: newtComponent): newtComponent
proc RadioGetCurrent*(setMember: newtComponent): newtComponent
proc RadioSetCurrent*(setMember: newtComponent)
#proc Listitem*(left: cint; top: cint; text: cstring; isDefault: cint; 
#                   prevItem: newtComponent; data: pointer; flags: cint): newtComponent
#proc ListitemSet*(co: newtComponent; text: cstring)
#proc ListitemGetData*(co: newtComponent): pointer
proc GetScreenSize*(cols: ptr cint; rows: ptr cint)
proc Label*(left: cint; top: cint; text: cstring): newtComponent
proc LabelSetText*(co: newtComponent; text: cstring)
proc LabelSetColors*(co: newtComponent; colorset: cint)
proc VerticalScrollbar*(left: cint; top: cint; height: cint; 
                            normalColorset: cint; thumbColorset: cint): newtComponent
proc ScrollbarSet*(co: newtComponent; where: cint; total: cint)
proc ScrollbarSetColors*(co: newtComponent; normal: cint; thumb: cint)
proc Listbox*(left: cint; top: cint; height: cint; flags: cint): newtComponent
proc ListboxGetCurrent*(co: newtComponent): pointer
proc ListboxSetCurrent*(co: newtComponent; num: cint)
proc ListboxSetCurrentByKey*(co: newtComponent; key: pointer)
proc ListboxSetEntry*(co: newtComponent; num: cint; text: cstring)
proc ListboxSetWidth*(co: newtComponent; width: cint)
proc ListboxSetData*(co: newtComponent; num: cint; data: pointer)
proc ListboxAppendEntry*(co: newtComponent; text: cstring; data: pointer): cint

# Send the key to insert after, or NULL to insert at the top 
proc ListboxInsertEntry*(co: newtComponent; text: cstring; data: pointer; 
                             key: pointer): cint
proc ListboxDeleteEntry*(co: newtComponent; data: pointer): cint
proc ListboxClear*(co: newtComponent)
# removes all entries from listbox 
proc ListboxGetEntry*(co: newtComponent; num: cint; text: cstringArray; 
                          data: ptr pointer)
# Returns an array of data pointers from items, last element is NULL 
proc ListboxGetSelection*(co: newtComponent; numitems: ptr cint): ptr pointer
proc ListboxClearSelection*(co: newtComponent)
proc ListboxSelectItem*(co: newtComponent; key: pointer; 
                            sense: newtFlagsSense)
# Returns number of items currently in listbox. 
proc ListboxItemCount*(co: newtComponent): cint
proc CheckboxTree*(left: cint; top: cint; height: cint; flags: cint): newtComponent
proc CheckboxTreeMulti*(left: cint; top: cint; height: cint; seq: cstring; 
                            flags: cint): newtComponent
proc CheckboxTreeGetSelection*(co: newtComponent; numitems: ptr cint): ptr pointer
proc CheckboxTreeGetCurrent*(co: newtComponent): pointer
proc CheckboxTreeSetCurrent*(co: newtComponent; item: pointer)
proc CheckboxTreeGetMultiSelection*(co: newtComponent; numitems: ptr cint; 
    seqnum: char): ptr pointer
# last item is NEWT_ARG_LAST for all of these 
proc CheckboxTreeAddItem*(co: newtComponent; text: cstring; data: pointer; 
                              flags: cint; index: cint): cint {.varargs.}
proc CheckboxTreeAddArray*(co: newtComponent; text: cstring; 
                               data: pointer; flags: cint; indexes: ptr cint): cint
proc CheckboxTreeFindItem*(co: newtComponent; data: pointer): ptr cint
proc CheckboxTreeSetEntry*(co: newtComponent; data: pointer; text: cstring)
proc CheckboxTreeSetWidth*(co: newtComponent; width: cint)
proc CheckboxTreeGetEntryValue*(co: newtComponent; data: pointer): char
proc CheckboxTreeSetEntryValue*(co: newtComponent; data: pointer; 
                                    value: char)
proc TextboxReflowed*(left: cint; top: cint; text: cstring; width: cint; 
                          flexDown: cint; flexUp: cint; flags: cint): newtComponent
proc Textbox*(left: cint; top: cint; width: cint; height: cint; 
                  flags: cint): newtComponent
proc TextboxSetText*(co: newtComponent; text: cstring)
proc TextboxSetHeight*(co: newtComponent; height: cint)
proc TextboxGetNumLines*(co: newtComponent): cint
proc TextboxSetColors*(co: newtComponent; normal: cint; active: cint)
proc ReflowText*(text: cstring; width: cint; flexDown: cint; flexUp: cint; 
                     actualWidth: ptr cint; actualHeight: ptr cint): cstring


proc Form*(vertBar: newtComponent; helpTag: pointer; flags: cint): newtComponent
proc FormSetTimer*(form: newtComponent; millisecs: cint)
proc FormWatchFd*(form: newtComponent; fd: cint; fdFlags: cint)
proc FormSetSize*(co: newtComponent)
proc FormGetCurrent*(co: newtComponent): newtComponent
proc FormSetBackground*(co: newtComponent; color: cint)
proc FormSetCurrent*(co: newtComponent; subco: newtComponent)
proc FormAddComponent*(form: newtComponent; co: newtComponent)
proc FormAddComponents*(form: newtComponent) {.varargs.}
proc FormSetHeight*(co: newtComponent; height: cint)
proc FormSetWidth*(co: newtComponent; width: cint)
proc RunForm*(form: newtComponent): newtComponent
# obsolete 
proc FormRun*(co: newtComponent; es: ptr newtExitStruct)
proc DrawForm*(form: newtComponent)
proc FormAddHotKey*(co: newtComponent; key: cint)

proc Entry*(left: cint; top: cint; initialValue: cstring; width: cint; 
                resultPtr: cstringArray; flags: cint): newtComponent
proc EntrySet*(co: newtComponent; value: cstring; cursorAtEnd: cint)
proc EntrySetFilter*(co: newtComponent; filter: newtEntryFilter; 
                         data: pointer)
proc EntryGetValue*(co: newtComponent): cstring
proc EntrySetFlags*(co: newtComponent; flags: cint; sense: newtFlagsSense)
proc EntrySetColors*(co: newtComponent; normal: cint; disabled: cint)
proc Scale*(left: cint; top: cint; width: cint; fullValue: clonglong): newtComponent
proc ScaleSet*(co: newtComponent; amount: culonglong)
proc ScaleSetColors*(co: newtComponent; empty: cint; full: cint)
proc ComponentAddCallback*(co: newtComponent; f: newtCallback; 
                               data: pointer)
proc ComponentTakesFocus*(co: newtComponent; val: cint)
# This callback is called when a component is destroyed. 
proc ComponentAddDestroyCallback*(co: newtComponent; f: newtCallback; 
                                      data: pointer)
# this also destroys all of the components (including other forms) on the 
#   form 
proc FormDestroy*(form: newtComponent)
# NB: You SHOULD NOT call this for components which have been added
#  to a form (ie. almost all components).  They are destroyed along
#  with the form when you call newtFormDestroy.
# 
proc ComponentDestroy*(co: newtComponent)
# Key codes 
const 
  NEWT_KEY_TAB* = '\x09'
  NEWT_KEY_ENTER* = '\x0D'
  NEWT_KEY_SUSPEND* = '\x1A' # ctrl - z
  NEWT_KEY_ESCAPE* = '\x1B'
  NEWT_KEY_RETURN* = NEWT_KEY_ENTER
  NEWT_KEY_EXTRA_BASE* = 0x00008000
  NEWT_KEY_UP* = NEWT_KEY_EXTRA_BASE + 1
  NEWT_KEY_DOWN* = NEWT_KEY_EXTRA_BASE + 2
  NEWT_KEY_LEFT* = NEWT_KEY_EXTRA_BASE + 4
  NEWT_KEY_RIGHT* = NEWT_KEY_EXTRA_BASE + 5
  NEWT_KEY_BKSPC* = NEWT_KEY_EXTRA_BASE + 6
  NEWT_KEY_DELETE* = NEWT_KEY_EXTRA_BASE + 7
  NEWT_KEY_HOME* = NEWT_KEY_EXTRA_BASE + 8
  NEWT_KEY_END* = NEWT_KEY_EXTRA_BASE + 9
  NEWT_KEY_UNTAB* = NEWT_KEY_EXTRA_BASE + 10
  NEWT_KEY_PGUP* = NEWT_KEY_EXTRA_BASE + 11
  NEWT_KEY_PGDN* = NEWT_KEY_EXTRA_BASE + 12
  NEWT_KEY_INSERT* = NEWT_KEY_EXTRA_BASE + 13
  NEWT_KEY_F1* = NEWT_KEY_EXTRA_BASE + 101
  NEWT_KEY_F2* = NEWT_KEY_EXTRA_BASE + 102
  NEWT_KEY_F3* = NEWT_KEY_EXTRA_BASE + 103
  NEWT_KEY_F4* = NEWT_KEY_EXTRA_BASE + 104
  NEWT_KEY_F5* = NEWT_KEY_EXTRA_BASE + 105
  NEWT_KEY_F6* = NEWT_KEY_EXTRA_BASE + 106
  NEWT_KEY_F7* = NEWT_KEY_EXTRA_BASE + 107
  NEWT_KEY_F8* = NEWT_KEY_EXTRA_BASE + 108
  NEWT_KEY_F9* = NEWT_KEY_EXTRA_BASE + 109
  NEWT_KEY_F10* = NEWT_KEY_EXTRA_BASE + 110
  NEWT_KEY_F11* = NEWT_KEY_EXTRA_BASE + 111
  NEWT_KEY_F12* = NEWT_KEY_EXTRA_BASE + 112
# not really a key, but newtGetKey returns it 
const 
  NEWT_KEY_RESIZE* = NEWT_KEY_EXTRA_BASE + 113
  NEWT_KEY_ERROR* = NEWT_KEY_EXTRA_BASE + 114
  NEWT_ANCHOR_LEFT* = (1 shl 0)
  NEWT_ANCHOR_RIGHT* = (1 shl 1)
  NEWT_ANCHOR_TOP* = (1 shl 2)
  NEWT_ANCHOR_BOTTOM* = (1 shl 3)
  NEWT_GRID_FLAG_GROWX* = (1 shl 0)
  NEWT_GRID_FLAG_GROWY* = (1 shl 1)

proc CreateGrid*(cols: cint; rows: cint): newtGrid
# TYPE, what, TYPE, what, ..., NULL 
proc GridVStacked*(`type`: newtGridElement; what: pointer): newtGrid {.
    varargs.}
proc GridVCloseStacked*(`type`: newtGridElement; what: pointer): newtGrid {.
    varargs.}
proc GridHStacked*(type1: newtGridElement; what1: pointer): newtGrid {.
    varargs.}
proc GridHCloseStacked*(type1: newtGridElement; what1: pointer): newtGrid {.
    varargs.}
proc GridBasicWindow*(text: newtComponent; middle: newtGrid; 
                          buttons: newtGrid): newtGrid
proc GridSimpleWindow*(text: newtComponent; middle: newtComponent; 
                           buttons: newtGrid): newtGrid
proc GridSetField*(grid: newtGrid; col, row: cint; 
                       `type`: newtGridElement; val: pointer;
                       padLeft, padTop, padRight, padBottom: cint; 
                       anchor, flags: cint)
proc GridPlace*(grid: newtGrid; left, top: cint)
proc GridFree*(grid: newtGrid; recurse: cint)
proc GridGetSize*(grid: newtGrid; width: ptr cint; height: ptr cint)
proc GridWrappedWindow*(grid: newtGrid; title: cstring)
proc GridWrappedWindowAt*(grid: newtGrid; title: cstring; left: cint; 
                              top: cint)
proc GridAddComponentsToForm*(grid: newtGrid; form: newtComponent; 
                                  recurse: cint)
# convienve 
proc ButtonBarv*(button1: cstring; b1comp: ptr newtComponent): newtGrid {.varargs.} 
#                     args: va_list): newtGrid
### CHECK THIS ^
proc ButtonBar*(button1: cstring; b1comp: ptr newtComponent): newtGrid {.
    varargs.}
# automatically centered and shrink wrapped 
proc WinMessage*(title: cstring; buttonText: cstring; text: cstring) {.
    varargs.}
proc WinMessagev*(title: cstring; buttonText: cstring; text: cstring) {.varargs.} 
#                      argv: va_list)
### CHECK THIS ^
# having separate calls for these two seems silly, but having two separate
#   variable length-arg lists seems like a bad idea as well 
# Returns 0 if F12 was pressed, 1 for button1, 2 for button2 
proc WinChoice*(title: cstring; button1: cstring; button2: cstring; 
                    text: cstring): cint {.varargs.}
# Returns 0 if F12 was pressed, 1 for button1, 2 for button2, 
#   3 for button3 
proc WinTernary*(title: cstring; button1: cstring; button2: cstring; 
                     button3: cstring; message: cstring): cint {.varargs.}
# Returns the button number pressed, 0 on F12 
proc WinMenu*(title: cstring; text: cstring; suggestedWidth: cint; 
                  flexDown: cint; flexUp: cint; maxListHeight: cint; 
                  items: cstringArray; listItem: ptr cint; button1: cstring): cint {.
    varargs.}

# Returns the button number pressed, 0 on F12. The final values are
#   dynamically allocated, and need to be freed. 
proc WinEntries*(title: cstring; text: cstring; suggestedWidth: cint; 
                     flexDown: cint; flexUp: cint; dataWidth: cint; 
                     items: ptr newtWinEntry; button1: cstring): cint {.
    varargs.}

{.pop.}
{.pop.}

#shortcuts
proc GetScreenSize*: tuple[cols, rows: cint] {.inline.}=
  newt.getScreenSize result.cols.addr, result.rows.addr

proc ListboxAddEntry*(co: newtComponent; text: cstring; data: pointer): cint {.inline.} = 
  newt.ListboxAppendEntry(co, text, data)

proc GridDestroy*(grid: newtGrid; recurse: cint) {.inline.} =
  newt.GridFree grid, recurse

when isMainModule:
  from os import sleep
  
  newt.Init()
  finally: newt.Finished()
  newt.CLS()
  
  let sz = getScreenSize()
  let form1 = newt.form(nil.newtComponent, nil.pointer, 0)
  
  let b1 = newt.button(2, 2, "Button 1")
  let b2 = newt.compact_button(2, 6, "Button 2")
  form1.formAddComponents b1, b2, nil
  
  var res = form1.runForm
  res = form1.runForm
  #form1.formDestroy
  
  newt.WaitForKey()


