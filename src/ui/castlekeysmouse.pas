{
  Copyright 2001-2018 Michalis Kamburelis, Tomasz Wojtyś.

  This file is part of "Castle Game Engine".

  "Castle Game Engine" is free software; see the file COPYING.txt,
  included in this distribution, for details about the copyright.

  "Castle Game Engine" is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

  ----------------------------------------------------------------------------
}

{ Types and constants to handle keys and mouse.
  They are used throughout our engine, both by CastleControl (Lazarus component)
  and by non-Lazarus CastleWindow. }
unit CastleKeysMouse;

{$I castleconf.inc}

interface

uses Classes, CastleUtils, CastleStringUtils, CastleVectors, CastleXMLConfig;

type
  { Keys on the keyboard.

    Some properties of keyXxx constants that are guaranteed:

    @unorderedList(
      @item(keyNone means "no key". It's guaranteed that it's always equal to zero.)

      @item(Letters (constants keyA .. keyZ) are guaranteed to be always equal to
        TKey('A') .. TKey('Z') and digits (constants key0 .. key9) are
        guaranteed to be always equal to TKey('0') .. TKey('9').
        That is, their ordinal values are equal to their ASCII codes,
        and they are always ordered.

        Also keyF1 .. keyF12 (function keys) are guaranteed to be always nicely ordered
        (i.e. keyF2 = keyF1 + 1, keyF3 = keyF2 + 1 and so on).

        Also keyEscape, keyBackSpace, keyTab, keyEnter are guaranteed to be always equal
        to CharEscape, CharBackSpace, CharTab, CharEnter (well, typecasted to
        TKey type).)
    )

    Do not ever use keyReserved_Xxx for any purpose, they may be used
    for something in next CGE versions.
  }
  TKey = (
    keyNone,
    keyPrintScreen,
    keyCapsLock,
    keyScrollLock,
    keyNumLock,
    keyPause,
    keyApostrophe,
    keySemicolon,
    keyBackSpace, //< = Ord(CharBackSpace) = 8
    keyTab, //< = Ord(CharTab) = 9
    keySlash,
    keyBackQuote,
    keyMinus,
    keyEnter, //< = Ord(CharEnter) = 13
    keyEqual,
    keyBackSlash,
    keyShift,
    keyCtrl,
    keyAlt,
    keyPlus,
    keyReserved_20,
    keyReserved_21,
    keyReserved_22,
    keyReserved_23,
    keyReserved_24,
    keyReserved_25,
    keyReserved_26,
    keyEscape, //< = Ord(CharEscape) = 27
    keyReserved_28,
    keyReserved_29,
    keyReserved_30,
    keyReserved_31,
    keySpace, //< = Ord(' ') = 32
    keyPageUp,
    keyPageDown,
    keyEnd,
    keyHome,
    keyLeft,
    keyUp,
    keyRight,
    keyDown,
    keyReserved_41,
    keyReserved_42,
    keyReserved_43,
    keyReserved_44,
    keyInsert,
    keyDelete,
    keyReserved_47,
    key0, //< = Ord('0') = 48
    key1, //< = Ord('1')
    key2, //< = Ord('2')
    key3, //< = Ord('3')
    key4, //< = Ord('4')
    key5, //< = Ord('5')
    key6, //< = Ord('6')
    key7, //< = Ord('7')
    key8, //< = Ord('8')
    key9, //< = Ord('9') = 57
    keyReserved_58,
    keyReserved_59,
    keyReserved_60,
    keyReserved_61,
    keyReserved_62,
    keyReserved_63,
    keyReserved_64,
    keyA, //< = Ord('A') = 65
    keyB, //< = Ord('B')
    keyC, //< = Ord('C')
    keyD, //< = Ord('D')
    keyE, //< = Ord('E')
    keyF, //< = Ord('F')
    keyG, //< = Ord('G')
    keyH, //< = Ord('H')
    keyI, //< = Ord('I')
    keyJ, //< = Ord('J')
    keyK, //< = Ord('K')
    keyL, //< = Ord('L')
    keyM, //< = Ord('M')
    keyN, //< = Ord('N')
    keyO, //< = Ord('O')
    keyP, //< = Ord('P')
    keyQ, //< = Ord('Q')
    keyR, //< = Ord('R')
    keyS, //< = Ord('S')
    keyT, //< = Ord('T')
    keyU, //< = Ord('U')
    keyV, //< = Ord('V')
    keyW, //< = Ord('W')
    keyX, //< = Ord('X')
    keyY, //< = Ord('Y')
    keyZ, //< = Ord('Z') = 90
    keyLeftBracket,
    keyReserved_92,
    keyRightBracket,
    keyReserved_94,
    keyReserved_95,
    keyReserved_96,
    keyReserved_97,
    keyReserved_98,
    keyReserved_99,
    keyReserved_100,
    keyReserved_101,
    keyReserved_102,
    keyReserved_103,
    keyReserved_104,
    keyReserved_105,
    keyReserved_106,
    keyNumpadPlus ,
    keyReserved_108,
    keyNumpadMinus,
    keyReserved_110,
    keyReserved_111,
    keyF1,
    keyF2,
    keyF3,
    keyF4,
    keyF5,
    keyF6,
    keyF7,
    keyF8,
    keyF9,
    keyF10,
    keyF11,
    keyF12,
    keyReserved_124,
    keyReserved_125,
    keyReserved_126,
    keyReserved_127,
    keyReserved_128,
    keyReserved_129,
    keyReserved_130,
    keyReserved_131,
    keyReserved_132,
    keyReserved_133,
    keyReserved_134,
    keyReserved_135,
    keyReserved_136,
    keyReserved_137,
    keyReserved_138,
    keyReserved_139,
    keyNumpad0,
    keyNumpad1,
    keyNumpad2,
    keyNumpad3,
    keyNumpad4,
    keyNumpad5,
    keyNumpad6,
    keyNumpad7,
    keyNumpad8,
    keyNumpad9,
    keyNumpadEnd,
    keyNumpadDown,
    keyNumpadPageDown,
    keyNumpadLeft,
    keyNumpadBegin,
    keyNumpadRight,
    keyNumpadHome,
    keyNumpadUp,
    keyNumpadPageUp,
    keyNumpadInsert,
    keyNumpadDelete,
    keyNumpadEnter,
    keyNumpadMultiply,
    keyNumpadDivide,
    keyReserved_164,
    keyReserved_165,
    keyReserved_166,
    keyReserved_167,
    keyReserved_168,
    keyReserved_169,
    keyReserved_170,
    keyReserved_171,
    keyReserved_172,
    keyReserved_173,
    keyReserved_174,
    keyReserved_175,
    keyReserved_176,
    keyReserved_177,
    keyReserved_178,
    keyReserved_179,
    keyReserved_180,
    keyReserved_181,
    keyReserved_182,
    keyReserved_183,
    keyReserved_184,
    keyReserved_185,
    keyReserved_186,
    keyReserved_187,
    keyComma,
    keyReserved_189,
    keyPeriod,
    keyReserved_191
  );

{ Old key names (K_Xxx instead of keyXxx). }

const
  K_None                       = keyNone;
  K_PrintScreen                = keyPrintScreen;
  K_CapsLock                   = keyCapsLock;
  K_ScrollLock                 = keyScrollLock;
  K_NumLock                    = keyNumLock;
  K_Pause                      = keyPause;
  K_Apostrophe                 = keyApostrophe;
  K_Semicolon                  = keySemicolon;
  K_BackSpace                  = keyBackSpace;
  K_Tab                        = keyTab;
  K_Slash                      = keySlash;
  K_BackQuote                  = keyBackQuote;
  K_Minus                      = keyMinus;
  K_Enter                      = keyEnter;
  K_Equal                      = keyEqual;
  K_BackSlash                  = keyBackSlash;
  K_Shift                      = keyShift;
  K_Ctrl                       = keyCtrl;
  K_Alt                        = keyAlt;
  K_Plus                       = keyPlus;
  K_Reserved_20                = keyReserved_20;
  K_Reserved_21                = keyReserved_21;
  K_Reserved_22                = keyReserved_22;
  K_Reserved_23                = keyReserved_23;
  K_Reserved_24                = keyReserved_24;
  K_Reserved_25                = keyReserved_25;
  K_Reserved_26                = keyReserved_26;
  K_Escape                     = keyEscape;
  K_Reserved_28                = keyReserved_28;
  K_Reserved_29                = keyReserved_29;
  K_Reserved_30                = keyReserved_30;
  K_Reserved_31                = keyReserved_31;
  K_Space                      = keySpace;
  K_PageUp                     = keyPageUp;
  K_PageDown                   = keyPageDown;
  K_End                        = keyEnd;
  K_Home                       = keyHome;
  K_Left                       = keyLeft;
  K_Up                         = keyUp;
  K_Right                      = keyRight;
  K_Down                       = keyDown;
  K_Reserved_41                = keyReserved_41;
  K_Reserved_42                = keyReserved_42;
  K_Reserved_43                = keyReserved_43;
  K_Reserved_44                = keyReserved_44;
  K_Insert                     = keyInsert;
  K_Delete                     = keyDelete;
  K_Reserved_47                = keyReserved_47;
  K_0                          = key0;
  K_1                          = key1;
  K_2                          = key2;
  K_3                          = key3;
  K_4                          = key4;
  K_5                          = key5;
  K_6                          = key6;
  K_7                          = key7;
  K_8                          = key8;
  K_9                          = key9;
  K_Reserved_58                = keyReserved_58;
  K_Reserved_59                = keyReserved_59;
  K_Reserved_60                = keyReserved_60;
  K_Reserved_61                = keyReserved_61;
  K_Reserved_62                = keyReserved_62;
  K_Reserved_63                = keyReserved_63;
  K_Reserved_64                = keyReserved_64;
  K_A                          = keyA;
  K_B                          = keyB;
  K_C                          = keyC;
  K_D                          = keyD;
  K_E                          = keyE;
  K_F                          = keyF;
  K_G                          = keyG;
  K_H                          = keyH;
  K_I                          = keyI;
  K_J                          = keyJ;
  K_K                          = keyK;
  K_L                          = keyL;
  K_M                          = keyM;
  K_N                          = keyN;
  K_O                          = keyO;
  K_P                          = keyP;
  K_Q                          = keyQ;
  K_R                          = keyR;
  K_S                          = keyS;
  K_T                          = keyT;
  K_U                          = keyU;
  K_V                          = keyV;
  K_W                          = keyW;
  K_X                          = keyX;
  K_Y                          = keyY;
  K_Z                          = keyZ;
  K_LeftBracket                = keyLeftBracket;
  K_Reserved_92                = keyReserved_92;
  K_RightBracket               = keyRightBracket;
  K_Reserved_94                = keyReserved_94;
  K_Reserved_95                = keyReserved_95;
  K_Reserved_96                = keyReserved_96;
  K_Reserved_97                = keyReserved_97;
  K_Reserved_98                = keyReserved_98;
  K_Reserved_99                = keyReserved_99;
  K_Reserved_100               = keyReserved_100;
  K_Reserved_101               = keyReserved_101;
  K_Reserved_102               = keyReserved_102;
  K_Reserved_103               = keyReserved_103;
  K_Reserved_104               = keyReserved_104;
  K_Reserved_105               = keyReserved_105;
  K_Reserved_106               = keyReserved_106;
  K_Numpad_Plus                = keyNumpadPlus;
  K_Reserved_108               = keyReserved_108;
  K_Numpad_Minus               = keyNumpadMinus;
  K_Reserved_110               = keyReserved_110;
  K_Reserved_111               = keyReserved_111;
  K_F1                         = keyF1;
  K_F2                         = keyF2;
  K_F3                         = keyF3;
  K_F4                         = keyF4;
  K_F5                         = keyF5;
  K_F6                         = keyF6;
  K_F7                         = keyF7;
  K_F8                         = keyF8;
  K_F9                         = keyF9;
  K_F10                        = keyF10;
  K_F11                        = keyF11;
  K_F12                        = keyF12;
  K_Reserved_124               = keyReserved_124;
  K_Reserved_125               = keyReserved_125;
  K_Reserved_126               = keyReserved_126;
  K_Reserved_127               = keyReserved_127;
  K_Reserved_128               = keyReserved_128;
  K_Reserved_129               = keyReserved_129;
  K_Reserved_130               = keyReserved_130;
  K_Reserved_131               = keyReserved_131;
  K_Reserved_132               = keyReserved_132;
  K_Reserved_133               = keyReserved_133;
  K_Reserved_134               = keyReserved_134;
  K_Reserved_135               = keyReserved_135;
  K_Reserved_136               = keyReserved_136;
  K_Reserved_137               = keyReserved_137;
  K_Reserved_138               = keyReserved_138;
  K_Reserved_139               = keyReserved_139;
  K_Numpad_0                   = keyNumpad0;
  K_Numpad_1                   = keyNumpad1;
  K_Numpad_2                   = keyNumpad2;
  K_Numpad_3                   = keyNumpad3;
  K_Numpad_4                   = keyNumpad4;
  K_Numpad_5                   = keyNumpad5;
  K_Numpad_6                   = keyNumpad6;
  K_Numpad_7                   = keyNumpad7;
  K_Numpad_8                   = keyNumpad8;
  K_Numpad_9                   = keyNumpad9;
  K_Numpad_End                 = keyNumpadEnd;
  K_Numpad_Down                = keyNumpadDown;
  K_Numpad_PageDown            = keyNumpadPageDown;
  K_Numpad_Left                = keyNumpadLeft;
  K_Numpad_Begin               = keyNumpadBegin;
  K_Numpad_Right               = keyNumpadRight;
  K_Numpad_Home                = keyNumpadHome;
  K_Numpad_Up                  = keyNumpadUp;
  K_Numpad_PageUp              = keyNumpadPageUp;
  K_Numpad_Insert              = keyNumpadInsert;
  K_Numpad_Delete              = keyNumpadDelete;
  K_Numpad_Enter               = keyNumpadEnter;
  K_Numpad_Multiply            = keyNumpadMultiply;
  K_Numpad_Divide              = keyNumpadDivide;
  K_Reserved_164               = keyReserved_164;
  K_Reserved_165               = keyReserved_165;
  K_Reserved_166               = keyReserved_166;
  K_Reserved_167               = keyReserved_167;
  K_Reserved_168               = keyReserved_168;
  K_Reserved_169               = keyReserved_169;
  K_Reserved_170               = keyReserved_170;
  K_Reserved_171               = keyReserved_171;
  K_Reserved_172               = keyReserved_172;
  K_Reserved_173               = keyReserved_173;
  K_Reserved_174               = keyReserved_174;
  K_Reserved_175               = keyReserved_175;
  K_Reserved_176               = keyReserved_176;
  K_Reserved_177               = keyReserved_177;
  K_Reserved_178               = keyReserved_178;
  K_Reserved_179               = keyReserved_179;
  K_Reserved_180               = keyReserved_180;
  K_Reserved_181               = keyReserved_181;
  K_Reserved_182               = keyReserved_182;
  K_Reserved_183               = keyReserved_183;
  K_Reserved_184               = keyReserved_184;
  K_Reserved_185               = keyReserved_185;
  K_Reserved_186               = keyReserved_186;
  K_Reserved_187               = keyReserved_187;
  K_Comma                      = keyComma;
  K_Reserved_189               = keyReserved_189;
  K_Period                     = keyPeriod;
  K_Reserved_191               = keyReserved_191;

type
  TKeysBooleans = array [TKey] of Boolean;
  PKeysBooleans = ^TKeysBooleans;
  TKeysBytes = array [Byte] of TKey;
  PKeysBytes = ^TKeysBytes;

  TCharactersBooleans = array [Char] of Boolean;
  PCharactersBooleans = ^TCharactersBooleans;

  TMouseButton = (mbLeft, mbMiddle, mbRight, mbExtra1, mbExtra2);
  TMouseButtons = set of TMouseButton;

  { Look of the mouse cursor.
    Used for various properties:
    TCastleUserInterface.Cursor, TCastleTransform.Cursor, TCastleWindowBase.Cursor.

    mcDefault, mcNone, mcForceNone, mcCustom have somewhat special meanings.
    The rest are some cursor images will well-defined meanings for the user,
    their exact look may depend on current window manager theme etc.  }
  TMouseCursor = (
    { Leave cursor as default, decided by a window manager. }
    mcDefault,
    { Make cursor invisible. }
    mcNone,
    { Forcefully make cursor invisible.

      If *any* UI control under the cursor
      says that the cursor is mcForceNone, it will be invisible.
      This is in contrast to mcNone, that only hides the cursor if
      the currently focused control (under the mouse cursor) sets it. }
    mcForceNone,
    { Use a custom cursor image in TCastleWindowBase.CustomCursor.

      In normal circumstances, this should not be used for
      TCastleUserInterface.Cursor, TCastleTransform.Cursor and others, as they have no way
      to set TCastleWindowBase.CustomCursor. }
    mcCustom,
    { Standard arrow, indicates, well, that user can point / click something. }
    mcStandard,
    { Indicates the program is busy and user should wait. }
    mcWait,
    { Text cursor, indicates that there's text under the cursor,
      which usually means that it can be selected,
      or that user can click to set focus to the text area. }
    mcText,
    { Indicates something active is under cursor, usually for links. }
    mcHand,

    mcResizeVertical,
    mcResizeHorizontal,
    mcResizeTopLeft,
    mcResizeTop,
    mcResizeTopRight,
    mcResizeLeft,
    mcResizeRight,
    mcResizeBottomLeft,
    mcResizeBottom,
    mcResizeBottomRight
  );
const
  MouseButtonStr: array [TMouseButton] of string = (
    'left', 'middle', 'right', 'extra1', 'extra2');

type
  { Modifier keys are keys that, when pressed, modify the meaning of
    other keys. Of course, this is actually just a convention.
    The actual interpretation is left up to the final program
    -- there you have to decide when and how modifiers affect the
    meaning of other keys. }
  TModifierKey = (mkCtrl, mkShift, mkAlt);
  TModifierKeys = set of TModifierKey;

  { Tracking the "pressed" state of keys. Allows you to query is key (TKey)
    pressed, and is some character (Char type) pressed. }
  TKeysPressed = class
  private
    { Characters are updated on the basis that given
      TKey corresponds to character. PressedKeyToCharacter and
      PressedCharacterToKey arrays
      store 1-1 mapping between pressed keys and pressed characters.
      So at any given point, we consider that given character corresponds
      to only one key. So Characters may get fooled by user in some
      complicated cases, that's acceptable (since unavoidable,
      see Characters comments). If a new key corresponding to already
      pressed character is pressed, this new key replaces previous key
      in the mapping.

      PressedKeyToCharacter reverse each other, that is
        PressedCharacterToKey[PressedKeyToCharacter[Key]] = Key and
        PressedKeyToCharacter[PressedCharacterToKey[C]] = C
      for all keys and characters, assuming that
      PressedCharacterToKey[C] <> keyNone and
      PressedKeyToCharacter[Key] <> #0 (which indicate that no character
      is pressed / no character is pressed corresponding to this key).

      Storing correspondence means that if each KeyDown is paired by
      KeyUp, then each pressed Character will also be released.
      (Since each pressed Character *always* has a corresponding key
      that activated it.)

      PressedXxx arrays may seem complicated, but their programming
      is trivial and they allow me to update Characters array
      quickly and reliably. }
    PressedKeyToCharacter: array [TKey] of Char;
    PressedCharacterToKey: array [Char] of TKey;

    function GetItems(const Key: TKey): Boolean;
    function GetStrings(const KeyString: String): Boolean;
  public
    { Check is a key (TKey) pressed.

      This array is read-only from outside of this class!
      Always Keys[keyNone] = false. }
    Keys: TKeysBooleans;

    { Check is a character pressed.

      This array is read-only from outside of this class!
      Always Characters[#0] = false.

      Note that since a given character may be generated by various
      key combinations, this doesn't work as reliably as @link(Keys) array.
      For example, consider pressing a, then shift, then releasing a
      --- for a short time character 'A', and not 'a', should be pressed.

      Although we do our best (have some mapping tables to track characters),
      and in practice this works Ok. But still checking for keys
      on @link(Keys) array, when possible, is advised. }
    Characters: TCharactersBooleans;

    { Check is a key (TKey) pressed.
      Returns the same values as are in the @link(Keys) table.
      It's a default property of this class,
      so you can write e.g.
      @code(Window.Pressed[keyX]) instead of
      @code(Window.Pressed.Keys[keyX]). }
    property Items [const Key: TKey]: boolean read GetItems; default;

    { Does an UTF-8 key represented by this String is pressed.
      Note that internallly we only track 8-bit keys (Char) for now,
      but this will change some day. }
    property Strings [const KeyString: String]: Boolean read GetStrings;

    { Check which modifier keys are pressed.
      The result it based on current Keys[keyCtrl], Keys[keyShift] etc. values. }
    function Modifiers: TModifierKeys;

    { Call when key is pressed.
      Pass TKey, and corresponding character (as String, since it may be UTF-8 character).

      Pass Key = keyNone if this is not representable as TKey,
      pass KeyString = '' if this is not representable as String.
      But never pass both Key = keyNone and KeyString = ''
      (this would mean that nothing was pressed, as least nothing that can be
      represented by CGE). }
    procedure KeyDown(const Key: TKey; const KeyString: String);

    { Call when key is released.
      Never pass Key = keyNone here.

      It returns which character was released as a consequence of this
      key release. }
    procedure KeyUp(const Key: TKey; out KeyString: String);

    { Mark all keys as released. That is, this sets all @link(Keys) and
      @link(Characters) items to @false. Also resets internal arrays
      used to track @link(Characters) from KeyDown and KeyUp. }
    procedure Clear;
  end;

function KeyToStr(const Key: TKey; const Modifiers: TModifierKeys = [];
  const CtrlIsCommand: boolean = false): string;

const
  ModifierKeyToKey: array[TModifierKey]of TKey = (keyCtrl, keyShift, keyAlt);

{ Determine pressed modifier keys (ctrl, shift and so on).

  Overloaded version with TKeysPressed parameter allows the parameter to be @nil,
  and returns [] (empty set) then.

  @groupBegin }
function ModifiersDown(const KeysDown: TKeysBooleans): TModifierKeys; overload;
function ModifiersDown(const Pressed: TKeysPressed): TModifierKeys; overload;
{ @groupEnd }

function ModifierKeysToNiceStr(const MK: TModifierKeys): string;

{ Nice short description of the character.
  When Modifiers is not empty, these are the additional modifiers
  required to be pressed (although some C values, like CtrlA ... CtrlZ,
  may already indicate some modifier).

  For normal readable characters just returns them, for special
  characters returns short string like "Ctrl+C" or "Escape".

  The returned string doesn't contain any quotes around, doesn't
  contain any word merely stating "character" (for example argument 'c' just
  generates 'c', not 'character "c"').

  BackSpaceTabEnterString determines behavior on three special values:
  #8, #9, #13. These may be either described as Backspace/Tab/Enter
  (if BackSpaceTabEnterString = true)
  or as Ctrl+H, Ctrl+I, Ctrl+M (if BackSpaceTabEnterString = false). }
function CharToNiceStr(const C: char; const Modifiers: TModifierKeys = [];
  const BackSpaceTabEnterString: boolean = true;
  const CtrlIsCommand: boolean = false): string;

{ Like @link(CharToNiceStr), but accepts UTF-8 characters expressed as String.
  KeyString = '' means "none". }
function KeyStringToNiceStr(const KeyString: String;
  const Modifiers: TModifierKeys = [];
  const BackSpaceTabEnterString: boolean = true;
  const CtrlIsCommand: boolean = false): string;

type
  TMouseWheelDirection = (mwNone, mwUp, mwDown, mwLeft, mwRight);

const
  MouseWheelDirectionStr: array [TMouseWheelDirection] of string =
  ('none', 'up', 'down', 'left', 'right');

{ Determine simple mouse wheel direction from a Scroll and Vertical
  parameters received from TCastleWindowBase.OnMouseWheel.
  Assumes that Scroll <> 0, like TCastleWindowBase.OnMouseWheel guarantees. }
function MouseWheelDirection(const Scroll: Single; const Vertical: boolean): TMouseWheelDirection;

{ Convert string value back to a key name, reversing KeyToStr.
  If string does not contain any recognized key name, return DefaultKey. }
function StrToKey(const S: string; const DefaultKey: TKey): TKey;

type
  TInputPressReleaseType = (itKey, itMouseButton, itMouseWheel);

  TFingerIndex = Cardinal;

  { Input press or release event.
    Either key press/release or mouse button press/release or
    mouse wheel action.
    This is nicely matching with TInputShortcut processing in CastleInputs,
    so it allows to easily store and check for user actions. }
  TInputPressRelease = object
    EventType: TInputPressReleaseType;

    { When EventType is itKey, this is the key pressed or released.
      Either Key <> keyNone or KeyString <> '' in this case.
      When EventType <> itKey, then Key = keyNone and KeyString = ''.

      Both Key and KeyString represent the same action. Sometimes one,
      sometimes the other is useful.

      @bold(Not all key presses can be represented as TKey value.)
      For example, pressing '(' (opening parenthesis), which is done on most
      keyboards by pressing shift + zero, does not have any TKey value.
      So it will generate event with Key = keyNone, but KeyString = '('.

      @bold(Likewise, not all key presses can be represented as UTF8 char or
      simple char.) For example "up arrow" (Key = keyUp) doesn't have a char code
      (it will have KeyString = '' and KeyCharacter = #0).

      KeyString is a string (encoded using UTF-8, like all strings
      in Castle Game Engine) and is influenced by some other keys state,
      like Shift or Ctrl or CapsLock or some key to input localized characters
      (all dependent on your system settings, we don't deal with it in our engine,
      we merely take what system gives us). For example, you can get "a" or "A"
      depending of Shift and CapsLock state, or CtrlA if you hold Ctrl.

      When the user holds the key pressed, we will get consecutive
      key down events. Under some OSes, you will also get consecutive
      key up events, but it's not guaranteed (on some OSes, you may
      simply get only consecutive key down). So the more precise
      definition when key down occurs is: it's a notification that
      the key is (still) pressed down.
      @groupBegin }
    Key: TKey;
    KeyString: string;
    { @groupEnd }

    { ModifiersDown contains a set of modifier keys (i.e. Ctrl, Shift and Alt)
      which were pressed at the moment of this Event. }
    ModifiersDown: TModifierKeys;

    { Was this key already pressed before this event.
      May be @true only for key events, and only on press (not on release).
      Alllows to recognize "key repeat" that occurs when you press a key
      for some time. The keyboard generates "key down" events then
      (with delay and frequency depending on keyboard settings).
      Sometimes they are useful, sometimes not -- so you can recognize
      them using this field. }
    KeyRepeated: boolean;

    { When EventType is itMouseButton, this is the mouse button pressed or released.
      Always mbLeft for touch device press/release events.

      CastleWindow notes (but relevant also to other interfaces, like Lazarus
      component, although in that case it's beyond our control):
      When user presses the mouse over
      our control, mouse is automatically captured, so all further OnMotion
      following mouse release will be passed to this control (even if user moves mouse
      outside of this control), until user releases all mouse buttons.
      Note that this means that mouse positions may be outside
      of [0..Width - 1, 0..Height - 1] range. }
    MouseButton: TMouseButton;

    { When EventType is itMouseButton, this is the finger index pressed or
      released on a touch device. Always 0 for normal mouse events. }
    FingerIndex: TFingerIndex;

    { The position of the current mouse/finger on the window,
      for EventType = itMouseButton (in case of mouse press/release).

      For normal backends that simply support a single mouse device,
      this is just equivalent to TCastleWindow.MousePosition
      and TCastleControl.MousePosition, so it's not really interesting.

      For multi-touch devices, this is very useful, as it describes
      the position of the current finger (corresponding to FingerIndex).

      For other EventType values (not itMouseButton),
      this is the position of main mouse/finger.
      See TCastleWindow.MousePosition documentation for what it means,
      in particular what happens on touch devices. }
    Position: TVector2;

    { When EventType is itMouseWheel, this is the mouse wheel action.
      MouseWheel is mwNone if and only if EventType <> itMouseWheel.

      Positive value of Scroll means user scrolled up or left,
      negative means user scrolled down or right. It is never zero
      (as long as EventType = itMouseWheel of course).

      Scroll units are such that 1.0 should be treated like a "one operation",
      like a one click. On most normal mouses only an integer scroll will be
      possible to make. On the other hand, on touchpads it's common to be able
      to scroll by flexible amounts.

      CastleWindow backends notes:
      GTK and Xlib cannot generate Scroll values different than 1 or -1.

      @groupBegin }
    MouseWheelScroll: Single;
    MouseWheelVertical: boolean;
    function MouseWheel: TMouseWheelDirection;
    { @groupEnd }

    { Check is event type correct, and then check if event Key or KeyString
      matches. Always false for AKey = keyNone or AKeyString = ''.
      @groupBegin }
    function IsKey(const AKey: TKey): boolean; overload;
    function IsKey(AKeyString: String): boolean; overload;
    { @groupEnd }
    function IsMouseButton(const AMouseButton: TMouseButton): boolean;
    function IsMouseWheel(const AMouseWheel: TMouseWheelDirection): boolean;

    { Textual description of this event. }
    function ToString: string;
    { Character corresponding to EventType = itKey.
      Returns #0 if the event was not a keyboard event or it cannot be
      represented as a simple 8-bit character (e.g. it is a Cyrillic or Arabic
      character, or it is a special key like "up arrow"). }
    function KeyCharacter: char;
    { @deprecated Deprecated name for ToString. }
    function Description: string; deprecated;
  end;

  { Motion (movement) of mouse or a finger on a touch device. }
  TInputMotion = object
    OldPosition, Position: TVector2;
    Pressed: TMouseButtons;
    FingerIndex: TFingerIndex;
  end;

{ Construct TInputPressRelease corresponding to given event.
  @groupBegin }
function InputKey(const Position: TVector2; const Key: TKey;
  const KeyString: string;
  const ModifiersDown: TModifierKeys = []): TInputPressRelease;
function InputMouseButton(const Position: TVector2;
  const MouseButton: TMouseButton; const FingerIndex: TFingerIndex;
  const ModifiersDown: TModifierKeys = []): TInputPressRelease;
function InputMouseWheel(const Position: TVector2;
  const Scroll: Single; const Vertical: boolean;
  const ModifiersDown: TModifierKeys = []): TInputPressRelease;
{ @groupEnd }

{ Construct TInputMotion. }
function InputMotion(const OldPosition, Position: TVector2;
  const Pressed: TMouseButtons; const FingerIndex: TFingerIndex): TInputMotion;

type
  TCastleConfigKeysMouseHelper = class helper for TCastleConfig
    { Reading/writing key values to config file.
      Key names are expected to follow StrToKey and KeyToStr functions in CastleKeysMouse.

      @groupBegin }
    function GetKey(const APath: string;
      const ADefaultValue: TKey): TKey; overload;
    procedure SetKey(const APath: string;
      const AValue: TKey); overload;
    procedure SetDeleteKey(const APath: string;
      const AValue, ADefaultValue: TKey); overload;
    { @groupEnd }
  end;

  TCastleGestureType = (gtNone, gtPinch, gtPan);
  TCastleGestureRecognizerState = (grstInvalid, grstStarted, grstUpdate, grstFinished);

  { This gesture recognizer detects pan and pinch gesture, as both use two fingers,
    but cannot be done at the same time (to have only one active recognizer).

    Pass the input events using Press, Motion and Release functions, listen
    to recognized gestures in @link(OnGestureChanged) event.
    }
  TCastlePinchPanGestureRecognizer = class
  strict private
    FGesture: TCastleGestureType;
    FState: TCastleGestureRecognizerState;
    FPanOldOffset, FPanOffset: TVector2;   // for panning, use (PanOffset - PanOldOffset)
    FPinchScaleFactor: Single;
    FPinchCenter: TVector2;

    FOnGestureChanged: TNotifyEvent;

    FFinger0Pressed, FFinger1Pressed: boolean;
    FFinger0Pos, FFinger1Pos: TVector2;  // stored position of the fingers, we get only one of them in Motion event
    FFinger0StartPos, FFinger1StartPos: TVector2; // gesture start finger positions

  public
    constructor Create;

    { Functions to pass the input to the recognizer from some @link(TInputListener).
      @groupBegin }
    function Press(const Event: TInputPressRelease): boolean;
    function Release(const Event: TInputPressRelease): boolean;
    function Motion(const Event: TInputMotion; const Dpi: Single): boolean;
    { @groupEnd }

    { Gesture type once it's recognized. Check it inside OnGestureChanged event. }
    property Gesture: TCastleGestureType read FGesture;

    { Recognizer state. When not detected any gesture, it is in grstInvalid,
      grstStarted is when the gesture is first recognized, grstFinished is the
      last event of the recognized gesture, grstUpdate are all events between
      started and finished.

      As you get the @link(OnGestureChanged) event only when any gesture
      is recognized, you may ignore this RecognizerState property, as the
      gesture parameters are always valid and can be used for transformations.}
    property RecognizerState: TCastleGestureRecognizerState read FState;

    { Offset of the current pan gesture. To get the actual change, you have
    to calculate PanOffset - PanOldOffset. }
    property PanOffset: TVector2 read FPanOffset;

    { Previous pan gesture offset. }
    property PanOldOffset: TVector2 read FPanOldOffset;

    { Scale factor of the pinch gesture. I.e. 1.0 = no change, >1.0 zoom in. }
    property PinchScaleFactor: Single read FPinchScaleFactor;

    { Coordinates of the pinch gesture center. }
    property PinchCenter: TVector2 read FPinchCenter;

    { Listen to this evnt to receive updates on recognized gestures. }
    property OnGestureChanged: TNotifyEvent read FOnGestureChanged write FOnGestureChanged;
  end;

implementation

uses SysUtils, Math;

const
  KeyToStrTable: array [TKey] of string = (
  'None',
  'Print Screen',
  'Caps Lock',
  'Scroll Lock',
  'Num Lock',
  'Pause',
  'Apostrophe',
  'Semicolon',
  'BackSpace',
  'Tab',
  'Slash',
  'BackQuote',
  'Minus',
  'Enter',
  'Equal',
  'BackSlash',
  'Shift',
  'Ctrl',
  'Alt',
  'Plus',
  'Reserved_20',
  'Reserved_21',
  'Reserved_22',
  'Reserved_23',
  'Reserved_24',
  'Reserved_25',
  'Reserved_26',
  'Escape',
  'Reserved_28',
  'Reserved_29',
  'Reserved_30',
  'Reserved_31',
  'Space',
  'Page Up',
  'Page Down',
  'End',
  'Home',
  'Left',
  'Up',
  'Right',
  'Down',
  'Reserved_41',
  'Reserved_42',
  'Reserved_43',
  'Reserved_44',
  'Insert',
  'Delete',
  'Reserved_47',
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  'Reserved_58',
  'Reserved_59',
  'Reserved_60',
  'Reserved_61',
  'Reserved_62',
  'Reserved_63',
  'Reserved_64',
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
  '[',
  'Reserved_92',
  ']',
  'Reserved_94',
  'Reserved_95',
  'Reserved_96',
  'Reserved_97',
  'Reserved_98',
  'Reserved_99',
  'Reserved_100',
  'Reserved_101',
  'Reserved_102',
  'Reserved_103',
  'Reserved_104',
  'Reserved_105',
  'Reserved_106',
  'Numpad Plus',
  'Reserved_108',
  'Numpad Minus',
  'Reserved_110',
  'Reserved_111',
  'F1',
  'F2',
  'F3',
  'F4',
  'F5',
  'F6',
  'F7',
  'F8',
  'F9',
  'F10',
  'F11',
  'F12',
  'Reserved_124',
  'Reserved_125',
  'Reserved_126',
  'Reserved_127',
  'Reserved_128',
  'Reserved_129',
  'Reserved_130',
  'Reserved_131',
  'Reserved_132',
  'Reserved_133',
  'Reserved_134',
  'Reserved_135',
  'Reserved_136',
  'Reserved_137',
  'Reserved_138',
  'Reserved_139',
  'Numpad 0',
  'Numpad 1',
  'Numpad 2',
  'Numpad 3',
  'Numpad 4',
  'Numpad 5',
  'Numpad 6',
  'Numpad 7',
  'Numpad 8',
  'Numpad 9',
  'Numpad End',
  'Numpad Down',
  'Numpad PageDown',
  'Numpad Left',
  'Numpad Begin',
  'Numpad Right',
  'Numpad Home',
  'Numpad Up',
  'Numpad PageUp',
  'Numpad Insert',
  'Numpad Delete',
  'Numpad Enter',
  'Numpad Multiply',
  'Numpad Divide',
  'Reserved_164',
  'Reserved_165',
  'Reserved_166',
  'Reserved_167',
  'Reserved_168',
  'Reserved_169',
  'Reserved_170',
  'Reserved_171',
  'Reserved_172',
  'Reserved_173',
  'Reserved_174',
  'Reserved_175',
  'Reserved_176',
  'Reserved_177',
  'Reserved_178',
  'Reserved_179',
  'Reserved_180',
  'Reserved_181',
  'Reserved_182',
  'Reserved_183',
  'Reserved_184',
  'Reserved_185',
  'Reserved_186',
  'Reserved_187',
  'Comma',
  'Reserved_189',
  'Period',
  'Reserved_191'
  );

function KeyToStr(const Key: TKey; const Modifiers: TModifierKeys;
  const CtrlIsCommand: boolean): string;
begin
  { early exit, key keyNone means "no key", Modifiers are ignored }
  if Key = keyNone then Exit(KeyToStrTable[Key]);

  Result := '';

  { add modifiers description }
  if mkShift in Modifiers then
    Result := Result + 'Shift+';
  if mkAlt in Modifiers then
    Result := Result + 'Alt+';
  if mkCtrl in Modifiers then
  begin
    if CtrlIsCommand then
      Result := Result + 'Command+'
    else
      Result := Result + 'Ctrl+';
  end;

  Result := Result + KeyToStrTable[Key];
end;

function StrToKey(const S: string; const DefaultKey: TKey): TKey;
begin
  for Result := Low(Result) to High(Result) do
    if KeyToStrTable[Result] = S then
      Exit;
  Result := DefaultKey;
end;

function ModifiersDown(const KeysDown: TKeysBooleans): TModifierKeys;
var
  mk: TModifierKey;
begin
  Result := [];
  for mk := Low(TModifierKey) to High(TModifierKey) do
    if KeysDown[ModifierKeyToKey[mk]] then
      Include(Result, mk);
end;

function ModifiersDown(const Pressed: TKeysPressed): TModifierKeys;
begin
  if Pressed <> nil then
    Result := ModifiersDown(Pressed.Keys)
  else
    Result := [];
end;

function ModifierKeysToNiceStr(const MK: TModifierKeys): string;
var
  K: TModifierKey;
begin
  Result := '';
  for K in MK do
    Result := SAppendPart(Result, ', ', KeyToStr(ModifierKeyToKey[K]));
  Result := '[' + Result + ']';
end;

function KeyStringToNiceStr(const KeyString: String;
  const Modifiers: TModifierKeys = [];
  const BackSpaceTabEnterString: boolean = true;
  const CtrlIsCommand: boolean = false): string;
begin
  case Length(KeyString) of
    0: Result := 'none';
    1: Result := CharToNiceStr(KeyString[1], Modifiers, BackSpaceTabEnterString, CtrlIsCommand);
    else Result := KeyString; // UTF-8 multi-byte char, just show it
  end;
end;

function CharToNiceStr(const C: char; const Modifiers: TModifierKeys;
  const BackSpaceTabEnterString, CtrlIsCommand: boolean): string;
var
  CharactersImplicatingCtrlModifier: TSetOfChars;
begin
  { early exit, character #0 means "no key", Modifiers are ignored }
  if C = #0 then Exit('#0');

  Result := '';

  CharactersImplicatingCtrlModifier := [CtrlA .. CtrlZ];
  if BackSpaceTabEnterString then
    { do not show Tab and similar chars as Ctrl+Tab }
    CharactersImplicatingCtrlModifier := CharactersImplicatingCtrlModifier -
      [CharBackSpace, CharTab, CharEnter];

  { add modifiers description }
  if (mkShift in Modifiers) or (C in ['A'..'Z']) then
    Result := Result + 'Shift+';
  if mkAlt in Modifiers then
    Result := Result + 'Alt+';
  if (mkCtrl in Modifiers) or
     (C in CharactersImplicatingCtrlModifier) then
  begin
    if CtrlIsCommand then
      Result := Result + 'Command+'
    else
      Result := Result + 'Ctrl+';
  end;

  if BackSpaceTabEnterString then
  begin
    case C of
      CharBackSpace: begin Result := Result + 'BackSpace'; Exit; end;
      CharTab      : begin Result := Result + 'Tab'      ; Exit; end;
      CharEnter    : begin Result := Result + 'Enter'    ; Exit; end;
    end;
  end;

  case c of
    CharEscape: Result := Result + 'Esc';
    CharDelete: Result := Result + 'Delete';
    ' ' : Result := Result + 'Space';
    { Show lowercase letters as uppercase, this is standard for showing menu item shortcuts.
      Uppercase letters will be prefixed with Shift+. }
    'a' .. 'z': Result := Result + Chr(Ord(C) - Ord('a') + Ord('A'));
    CtrlA .. CtrlZ: Result := Result + Chr(Ord(C) - Ord(CtrlA) + Ord('A')); // we already added Ctrl+ prefix
    else Result := Result + C;
  end;
end;

function MouseWheelDirection(const Scroll: Single; const Vertical: boolean): TMouseWheelDirection;
begin
  if Scroll > 0 then
  begin
    if Vertical then Result := mwUp else Result := mwLeft;
  end else
    if Vertical then Result := mwDown else Result := mwRight;
end;

{ TKeysPressed --------------------------------------------------------------- }

function TKeysPressed.GetItems(const Key: TKey): Boolean;
begin
  Result := Keys[Key];
end;

function TKeysPressed.GetStrings(const KeyString: String): Boolean;
begin
  Result := (Length(KeyString) = 1) and Characters[KeyString[1]];
end;

function TKeysPressed.Modifiers: TModifierKeys;
begin
  Result := ModifiersDown(Keys);
end;

procedure TKeysPressed.KeyDown(const Key: TKey; const KeyString: String);
var
  KeyChar: Char;
begin
  if Key <> keyNone then
    Keys[Key] := true;

  { Although the API of TKeysPressed.KeyDown accepts String,
    we can actually store only Char as being pressed for now,
    in Characters and PressedCharacterToKey. }
  if Length(KeyString) = 1 then
    KeyChar := KeyString[1]
  else
    KeyChar := #0;

  if (Key <> keyNone) and
     (KeyChar <> #0) and
     (PressedKeyToCharacter[Key] = #0) then
  begin
    { update Characters and PressedXxx mapping arrays }
    if PressedCharacterToKey[KeyChar] = keyNone then
    begin
      Assert(not Characters[KeyChar]);
      Characters[KeyChar] := true;
    end else
    begin
      { some key already recorded as generating this character }
      Assert(Characters[KeyChar]);
      Assert(PressedKeyToCharacter[PressedCharacterToKey[KeyChar]] = KeyChar);

      PressedKeyToCharacter[PressedCharacterToKey[KeyChar]] := #0;
      PressedCharacterToKey[KeyChar] := keyNone;
    end;

    PressedKeyToCharacter[Key] := KeyChar;
    PressedCharacterToKey[KeyChar] := Key;
  end;
end;

procedure TKeysPressed.KeyUp(const Key: TKey; out KeyString: String);
var
  KeyChar: Char;
begin
  KeyChar := PressedKeyToCharacter[Key];
  if KeyChar <> #0 then
  begin
    { update Characters and PressedXxx mapping arrays }
    Assert(Characters[KeyChar]);
    Characters[KeyChar] := false;
    PressedCharacterToKey[KeyChar] := keyNone;
    PressedKeyToCharacter[Key] := #0;
    KeyString := KeyChar;
  end else
    KeyString := '';

  Keys[key] := false;
end;

procedure TKeysPressed.Clear;
begin
  FillChar(Keys, SizeOf(Keys), 0);
  FillChar(Characters, SizeOf(Characters), 0);
  FillChar(PressedKeyToCharacter, SizeOf(PressedKeyToCharacter), 0);
  FillChar(PressedCharacterToKey, SizeOf(PressedCharacterToKey), 0);
end;

{ TInputPressRelease --------------------------------------------------------- }

function TInputPressRelease.MouseWheel: TMouseWheelDirection;
begin
  if EventType = itMouseWheel then
    Result := MouseWheelDirection(MouseWheelScroll, MouseWheelVertical) else
    Result := mwNone;
end;

function TInputPressRelease.IsKey(const AKey: TKey): boolean;
begin
  Result := (AKey <> keyNone) and (EventType = itKey) and (Key = AKey);
end;

function TInputPressRelease.IsKey(AKeystring: String): boolean;
begin
  // only for backward compatibility (when this parameter was Char) convert #0 to ''
  if AKeystring = #0 then
    AKeystring := '';

  Result := (AKeystring <> '') and (EventType = itKey) and (KeyString = AKeystring);
end;

function TInputPressRelease.IsMouseButton(const AMouseButton: TMouseButton): boolean;
begin
  Result := (EventType = itMouseButton) and (MouseButton = AMouseButton);
end;

function TInputPressRelease.IsMouseWheel(const AMouseWheel: TMouseWheelDirection): boolean;
begin
  Result := (EventType = itMouseWheel) and (MouseWheel = AMouseWheel);
end;

function TInputPressRelease.ToString: string;
begin
  case EventType of
    itKey:
      Result := Format('key %s, character %s',
      [ KeyToStr(Key), KeyStringToNiceStr(KeyString) ]);
    itMouseButton:
      Result := 'mouse ' + MouseButtonStr[MouseButton];
    itMouseWheel:
      Result := Format('mouse wheel %s (amount %f, vertical: %s)',
      [ MouseWheelDirectionStr[MouseWheel],
        MouseWheelScroll,
        BoolToStr(MouseWheelVertical, true) ]);
    else raise EInternalError.Create('TInputPressRelease.Description: EventType?');
  end;
  if KeyRepeated then
    Result := Result + ', key repeated';
  if ModifiersDown <> [] then
    Result := Result + ', modifiers pressed ' + ModifierKeysToNiceStr(ModifiersDown);
end;

function TInputPressRelease.KeyCharacter: char;
begin
  {$ifdef MSWINDOWS}
  { It seems that GTK 1.3 for Windows cannot translate GDK_KEY_Escape and
    GDK_KEY_Return to standard chars (#13 and #27). So I'm fixing it here. }
  if Key = K_Escape then
    Result := CharEscape
  else
  if Key = K_Enter then
    Result := CharEnter
  else
  {$endif}
  { It seems that GTK 2 doesn't translate backspace and tab to
    appropriate chars. So I'm fixing it here. }
  if Key = K_Tab then
    Result := CharTab
  else
  if Key = K_BackSpace then
    Result := CharBackSpace
  else

  if Length(KeyString) = 1 then
    Result := KeyString[1]
  else
    Result := #0;
end;

function TInputPressRelease.Description: string;
begin
  Result := ToString;
end;

function InputKey(const Position: TVector2; const Key: TKey;
  const KeyString: string;
  const ModifiersDown: TModifierKeys): TInputPressRelease;
begin
  FillChar(Result, SizeOf(Result), 0);
  Result.Position := Position;
  Result.EventType := itKey;
  Result.Key := Key;
  Result.ModifiersDown := ModifiersDown;
  Result.KeyString := KeyString;
end;

function InputMouseButton(const Position: TVector2;
  const MouseButton: TMouseButton; const FingerIndex: TFingerIndex;
  const ModifiersDown: TModifierKeys): TInputPressRelease;
begin
  FillChar(Result, SizeOf(Result), 0);
  Result.Position := Position;
  Result.EventType := itMouseButton;
  Result.MouseButton := MouseButton;
  Result.FingerIndex := FingerIndex;
  Result.ModifiersDown := ModifiersDown;
end;

function InputMouseWheel(const Position: TVector2;
  const Scroll: Single; const Vertical: boolean;
  const ModifiersDown: TModifierKeys): TInputPressRelease;
begin
  FillChar(Result, SizeOf(Result), 0);
  Result.Position := Position;
  Result.EventType := itMouseWheel;
  Result.MouseWheelScroll := Scroll;
  Result.MouseWheelVertical := Vertical;
  Result.ModifiersDown := ModifiersDown;
end;

function InputMotion(const OldPosition, Position: TVector2;
  const Pressed: TMouseButtons; const FingerIndex: TFingerIndex): TInputMotion;
begin
  FillChar(Result, SizeOf(Result), 0);
  Result.OldPosition := OldPosition;
  Result.Position := Position;
  Result.Pressed := Pressed;
  Result.FingerIndex := FingerIndex;
end;

{ TCastleConfigKeysMouseHelper ----------------------------------------------- }

function TCastleConfigKeysMouseHelper.GetKey(const APath: string;
  const ADefaultValue: TKey): TKey;
begin
  Result := StrToKey(GetValue(APath, KeyToStr(ADefaultValue)), ADefaultValue);
end;

procedure TCastleConfigKeysMouseHelper.SetKey(const APath: string;
  const AValue: TKey);
begin
  SetValue(APath, KeyToStr(AValue));
end;

procedure TCastleConfigKeysMouseHelper.SetDeleteKey(const APath: string;
  const AValue, ADefaultValue: TKey);
begin
  SetDeleteValue(APath, KeyToStr(AValue), KeyToStr(ADefaultValue));
end;

{ TCastlePinchPanGestureRecognizer ------------------------------------------- }

constructor TCastlePinchPanGestureRecognizer.Create;
begin
  inherited;
  FGesture := gtNone;
  FState := grstInvalid;
  FOnGestureChanged := nil;
  FFinger0Pressed := false;
  FFinger1Pressed := false;
end;

function TCastlePinchPanGestureRecognizer.Press(const Event: TInputPressRelease): boolean;
begin
  if Event.FingerIndex = 0 then
  begin
    FFinger0StartPos := Event.Position;
    FFinger0Pos := Event.Position;
    FFinger0Pressed := true;
  end
  else if Event.FingerIndex = 1 then begin
    FFinger1StartPos := Event.Position;
    FFinger1Pos := Event.Position;
    FFinger1Pressed := true;
  end;
  Result := FFinger0Pressed and FFinger1Pressed;
end;

function TCastlePinchPanGestureRecognizer.Release(const Event: TInputPressRelease): boolean;
begin
  Result := false;

  if Event.FingerIndex = 0 then
    FFinger0Pressed := false
  else if Event.FingerIndex = 1 then
    FFinger1Pressed := false;

  // end gesture when any finger up
  if FState <> grstInvalid then
  begin
    if Assigned(FOnGestureChanged) then
    begin
      // send 'Finished' event
      if Gesture = gtPinch then
        FPinchScaleFactor := 1.0
      else if Gesture = gtPan then
        FPanOffset := FPanOldOffset;
      FState := grstFinished;
      FOnGestureChanged(Self);
    end;
    FGesture := gtNone;
    FState := grstInvalid;
    Result := true;
  end;
end;

function TCastlePinchPanGestureRecognizer.Motion(const Event: TInputMotion;
  const Dpi: Single): boolean;
var
  OldDist, NewDist: Single;
  Length0, Length1: Single;
  DpiScale: Single;

  function CosAngleBetweenVectors(const V1, V2: TVector2): Single;
  var
    LensSquared: Float;
  begin
    LensSquared := v1.LengthSqr * v2.LengthSqr;
    if IsZero(LensSquared) then
      Result := 1
    else
      Result := Clamped(TVector2.DotProduct(V1, V2) / Sqrt(LensSquared), -1.0, 1.0);
  end;

  function AngleRadBetweenVectors(const V1, V2: TVector2): Single;
  begin
    Result := ArcCos(CosAngleBetweenVectors(V1, V2));
  end;

begin
  Result := false;

  if Event.FingerIndex = 0 then
    FFinger0Pos := Event.Position
  else if Event.FingerIndex = 1 then
    FFinger1Pos := Event.Position
  else
    Exit(FState <> grstInvalid);  // moving with additional finger

  if (not FFinger0Pressed) or (not FFinger1Pressed) then
    Exit(false);

  if FState = grstInvalid then
  begin
    DpiScale := Dpi / 96.0;
    // test if gesture started
    OldDist := PointsDistance(FFinger0StartPos, FFinger1StartPos);
    NewDist := PointsDistance(FFinger0Pos, FFinger1Pos);
    if Abs(OldDist - NewDist) > (20 * DpiScale) then
    begin
      // pinch gesture recognized
      FGesture := gtPinch;
      FState := grstStarted;
      FPinchCenter := (FFinger0Pos + FFinger1Pos) / 2.0;
      FPinchScaleFactor := NewDist / OldDist;

      if Assigned(FOnGestureChanged) then
        FOnGestureChanged(Self);

      FState := grstUpdate;
      Result := true;
    end;

    // ﻿test if it is pan gesture - it should be parralel movement of all fingers
    Length0 := PointsDistance(FFinger0Pos, FFinger0StartPos);
    Length1 := PointsDistance(FFinger1Pos, FFinger1StartPos);

    if (Max(Length0, Length1) > (10 * DpiScale)) and (Min(Length0, Length1)*1.5 > Max(Length0, Length1))
       and (AngleRadBetweenVectors(FFinger0Pos - FFinger0StartPos, FFinger1Pos - FFinger1StartPos) < 1.0) then // angle less then 60 deg
    begin
      FGesture := gtPan;
      FState := grstStarted;
      FPanOldOffset := FFinger0StartPos;
      FPanOffset := FFinger0Pos;

      if Assigned(FOnGestureChanged) then
        FOnGestureChanged(Self);

      FState := grstUpdate;
      Result := true;
    end;
  end
  else if FState = grstUpdate then begin
    // update gestures
    if FGesture = gtPinch then
    begin
      NewDist := PointsDistance(FFinger0Pos, FFinger1Pos);
      if Event.FingerIndex = 0 then
        OldDist := PointsDistance(Event.OldPosition, FFinger1Pos)
      else
        OldDist := PointsDistance(FFinger0Pos, Event.OldPosition);

      FPinchScaleFactor := NewDist / OldDist;

      if Assigned(FOnGestureChanged) then
        FOnGestureChanged(Self);

      Result := true;
    end
    else if FGesture = gtPan then begin
      if Event.FingerIndex = 0 then // send only when 1st finger moved
      begin
        FPanOldOffset := Event.OldPosition;
        FPanOffset := Event.Position;

        if Assigned(FOnGestureChanged) then
          FOnGestureChanged(Self);
      end;
      Result := true;
    end;
  end;

  { Eat all 2 finger moves.
    Positive effect: camera does not change before the gesture is recognized.
    Negative effect: in theory, we might block some other two-finger gestures. }
  Result := true;
end;

end.
