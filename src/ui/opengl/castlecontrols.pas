{
  Copyright 2010-2013 Michalis Kamburelis.

  This file is part of "Castle Game Engine".

  "Castle Game Engine" is free software; see the file COPYING.txt,
  included in this distribution, for details about the copyright.

  "Castle Game Engine" is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

  ----------------------------------------------------------------------------
}

{ Controls drawn inside OpenGL context. }
unit CastleControls;

interface

uses Classes, GL, CastleVectors, CastleUIControls, CastleGLBitmapFonts,
  CastleKeysMouse, CastleImages, CastleUtils, CastleGLImages,
  CastleRectangles, CastleBitmapFonts, CastleColors;

type
  TCastleLabel = class;

  { Base class for all controls inside an OpenGL context using a font. }
  TUIControlFont = class(TUIControlPos)
  private
    FTooltip: string;
    TooltipLabel: TCastleLabel;
  protected
    { Font custom to this control. By default this returns UIFont,
      you can override this to return your font.
      It's OK to return here @nil if font is not ready yet,
      but during Draw (when OpenGL context is available) font must be ready. }
    function Font: TGLBitmapFontAbstract; virtual;
  public
    procedure GLContextClose; override;
    function TooltipStyle: TUIControlDrawStyle; override;
    procedure DrawTooltip; override;
  published
    { Tooltip string, displayed when user hovers the mouse over a control.

      Note that you can override TUIControl.TooltipStyle and
      TUIControl.DrawTooltip to customize the tooltip drawing. }
    property Tooltip: string read FTooltip write FTooltip;
  end;

  TCastleButtonImageLayout = (ilTop, ilBottom, ilLeft, ilRight);

  { Button inside OpenGL context.

    This is TUIControl descendant, so to use it just add it to
    the TCastleWindowCustom.Controls or TCastleControlCustom.Controls list.
    You will also usually want to adjust position (TCastleButton.Left,
    TCastleButton.Bottom), TCastleButton.Caption,
    and assign TCastleButton.OnClick (or ovevrride TCastleButton.DoClick). }
  TCastleButton = class(TUIControlFont)
  private
    FWidth: Cardinal;
    FHeight: Cardinal;
    FOnClick: TNotifyEvent;
    FCaption: string;
    FAutoSize, FAutoSizeWidth, FAutoSizeHeight: boolean;
    TextWidth, TextHeight: Cardinal;
    FPressed: boolean;
    FOwnsImage: boolean;
    FImage: TCastleImage;
    FGLImage: TGLImage;
    FToggle: boolean;
    ClickStarted: boolean;
    FMinImageWidth: Cardinal;
    FMinImageHeight: Cardinal;
    FImageLayout: TCastleButtonImageLayout;
    FImageAlphaTest: boolean;
    FMinWidth, FMinHeight: Cardinal;
    procedure SetCaption(const Value: string);
    procedure SetAutoSize(const Value: boolean);
    procedure SetAutoSizeWidth(const Value: boolean);
    procedure SetAutoSizeHeight(const Value: boolean);
    { Calculate TextWidth, TextHeight and call UpdateSize. }
    procedure UpdateTextSize;
    { If AutoSize, update Width, Height.
      This depends on Caption, AutoSize*, Font availability. }
    procedure UpdateSize;
    procedure SetImage(const Value: TCastleImage);
    procedure SetPressed(const Value: boolean);
    procedure SetImageLayout(const Value: TCastleButtonImageLayout);
    procedure SetWidth(const Value: Cardinal);
    procedure SetHeight(const Value: Cardinal);
    procedure SetMinWidth(const Value: Cardinal);
    procedure SetMinHeight(const Value: Cardinal);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function DrawStyle: TUIControlDrawStyle; override;
    procedure Draw; override;
    function PositionInside(const X, Y: Integer): boolean; override;
    procedure GLContextOpen; override;
    procedure GLContextClose; override;
    function Press(const Event: TInputPressRelease): boolean; override;
    function Release(const Event: TInputPressRelease): boolean; override;

    { Called when user clicks the button. In this class, simply calls
      OnClick callback. }
    procedure DoClick; virtual;
    procedure SetFocused(const Value: boolean); override;
    { Set this to non-nil to display an image on the button. }
    property Image: TCastleImage read FImage write SetImage;
    { Should we free the @link(Image) when you set another one or at destructor. }
    property OwnsImage: boolean read FOwnsImage write FOwnsImage default false;

    { Auto-size routines (see @link(AutoSize)) may treat the image
      like always having at least these minimal sizes.
      Even if the @link(Image) is empty (@nil).
      This is useful when you have a row of buttons (typical for toolbar),
      and you want them to have the same height, and their captions
      to be displayed at the same level, regardless of their images sizes. }
    property MinImageWidth: Cardinal read FMinImageWidth write FMinImageWidth default 0;
    property MinImageHeight: Cardinal read FMinImageHeight write FMinImageHeight default 0;

    { Position and size of this control, ignoring GetExists. }
    function Rect: TRectangle;
  published
    property Width: Cardinal read FWidth write SetWidth default 0;
    property Height: Cardinal read FHeight write SetHeight default 0;

    { When AutoSize is @true (the default) then Width/Height are automatically
      adjusted when you change the Caption and @link(Image).
      They take into account
      Caption width/height with current font, @link(Image) width/height,
      and add some margin to make it look good.

      To be more precise, Width is adjusted only when AutoSize and AutoSizeWidth.
      And Height is adjusted only when AutoSize and AutoSizeHeight.
      This way you can turn off auto-sizing in only one dimension if you
      want (and when you don't need such flexibility, leave
      AutoSizeWidth = AutoSizeHeight = @true and control both by simple
      AutoSize).

      Note that this adjustment happens only when OpenGL context is initialized
      (because only then we actually know the font used).
      So don't depend on Width/Height values calculated correctly before
      OpenGL context is ready. }
    property AutoSize: boolean read FAutoSize write SetAutoSize default true;
    property AutoSizeWidth: boolean read FAutoSizeWidth write SetAutoSizeWidth default true;
    property AutoSizeHeight: boolean read FAutoSizeHeight write SetAutoSizeHeight default true;

    { When auto-size is in effect, these properties may force
      a minimal width/height of the button. This is useful if you want
      to use auto-size (to make sure that the content fits inside),
      but you want to force filling some space. }
    property MinWidth: Cardinal read FMinWidth write SetMinWidth default 0;
    property MinHeight: Cardinal read FMinHeight write SetMinHeight default 0;

    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property Caption: string read FCaption write SetCaption;

    { Can the button be permanently pressed. Good for making a button
      behave like a checkbox, that is indicate a boolean state.
      When @link(Toggle) is @true, you can set the @link(Pressed) property,
      and the clicks are visualized a little differently. }
    property Toggle: boolean read FToggle write FToggle default false;

    { Is the button pressed down. If @link(Toggle) is @true,
      you can read and write this property to set the pressed state.

      When not @link(Toggle), this property isn't really useful to you.
      The pressed state is automatically managed then to visualize
      user clicks. In this case, you can read this property,
      but you cannot reliably set it. }
    property Pressed: boolean read FPressed write SetPressed default false;

    { Where the @link(Image) is drawn on a button. }
    property ImageLayout: TCastleButtonImageLayout
      read FImageLayout write SetImageLayout default ilLeft;

    { If the image has alpha channel, should we render with alpha test
      (simple yes/no transparency) or alpha blending (smootly mix
      with background using full transparency). }
    property ImageAlphaTest: boolean
      read FImageAlphaTest write FImageAlphaTest default false;
  end;

  { Panel inside OpenGL context.
    Use as a comfortable (and with matching colors) background
    for other controls like buttons and such.
    May be used as a toolbar, together with appropriately placed
    TCastleButton over it. }
  TCastlePanel = class(TUIControlPos)
  private
    FWidth: Cardinal;
    FHeight: Cardinal;
    FVerticalSeparators: TCardinalList;
    procedure SetWidth(const Value: Cardinal);
    procedure SetHeight(const Value: Cardinal);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function DrawStyle: TUIControlDrawStyle; override;
    procedure Draw; override;
    function PositionInside(const X, Y: Integer): boolean; override;
    { Position and size of this control, ignoring GetExists. }
    function Rect: TRectangle;

    { Separator lines drawn on panel. Useful if you want to visually separate
      groups of contols (like a groups of buttons when you use
      this panel as a toolbar).

      Values are the horizontal positions of the separators (with respect
      to this panel @link(Left)). Width of the separator is in SeparatorSize. }
    property VerticalSeparators: TCardinalList read FVerticalSeparators;
    class function SeparatorSize: Cardinal;
  published
    property Width: Cardinal read FWidth write SetWidth default 0;
    property Height: Cardinal read FHeight write SetHeight default 0;
  end;

  { Image control inside OpenGL context.
    Size is automatically adjusted to the image size.
    You should set TCastleImageControl.Left, TCastleImageControl.Bottom properties,
    and load your image by setting TCastleImageControl.URL property
    or straight TCastleImageControl.Image.

    We automatically use alpha test or alpha blending based
    on loaded image alpha channel (see TGLImage.Alpha). }
  TCastleImageControl = class(TUIControlPos)
  private
    FURL: string;
    FImage: TCastleImage;
    FGLImage: TGLImage;
    procedure SetURL(const Value: string);
    procedure SetImage(const Value: TCastleImage);
  public
    destructor Destroy; override;
    function DrawStyle: TUIControlDrawStyle; override;
    procedure Draw; override;
    function PositionInside(const X, Y: Integer): boolean; override;
    procedure GLContextOpen; override;
    procedure GLContextClose; override;
    function Width: Cardinal;
    function Height: Cardinal;

    { Image displayed, or @nil if none.
      This image is owned by this component. If you set this property
      to your custom TCastleImage instance you should
      leave memory management of this instance to this component.
      If necessary, you can always create a copy by TCastleImage.MakeCopy
      if you want to give here only a copy. }
    property Image: TCastleImage read FImage write SetImage;

  published
    { URL of the image. Setting this also sets @link(Image).
      Set this to '' to clear the image. }
    property URL: string read FURL write SetURL;
    { Deprecated name for @link(URL). }
    property FileName: string read FURL write SetURL; deprecated;
  end;

  { Simple background fill. Using OpenGL glClear, so unconditionally
    clears things underneath. In simple cases, you don't want to use this:
    instead you usually have TCastleSceneManager that fill the whole screen,
    and it provides a background already. }
  TCastleSimpleBackground = class(TUIControl)
  private
    FColor: TCastleColor;
  public
    constructor Create(AOwner: TComponent); override;
    function DrawStyle: TUIControlDrawStyle; override;
    procedure Draw; override;
    { Background color. By default, this is black color with opaque alpha. }
    property Color: TCastleColor read FColor write FColor;
  end;

  { Text alignment for TCastleDialog. }
  TTextAlign = (taLeft, taMiddle, taRight);

  { Dialog box that can display a long text, with automatic vertical scrollbar.
    You can also add buttons at the bottom.
    You can also have an input text area.
    This can be used to make either a modal or non-modal dialog boxes.

    See CastleMessages for routines that intensively use this dialog underneath,
    giving you easy MessageXxx routines that ask user for confirmation and such. }
  TCastleDialog = class abstract(TUIControl)
  strict private
    const
      BoxMargin = 10;
      WindowMargin = 10;
      ScrollBarWholeWidth = 20;
      ButtonHorizontalMargin = 10;
    var
    FScroll: Single;
    FInputText: string;

    { Broken Text. }
    Broken_Text: TStringList;
    { Ignored (not visible) if not DrawInputText.
      Else broken InputText. }
    Broken_InputText: TStringList;

    MaxLineWidth: integer;
    { Sum of all Broken_Text.Count + Broken_InputText.Count.
      In other words, all lines that are scrolled by the scrollbar. }
    AllScrolledLinesCount: integer;
    VisibleScrolledLinesCount: integer;

    { Min and max sensible values for @link(Scroll). }
    ScrollMin, ScrollMax: integer;
    ScrollInitialized: boolean;

    ScrollMaxForScrollbar: integer;

    ScrollbarVisible: boolean;
    ScrollbarFrame: TRectangle;
    ScrollbarSlider: TRectangle;
    ScrollBarDragging: boolean;

    { Things below set in MessageCore, readonly afterwards. }
    { Main text to display. Read-only contents. }
    Text: TStringList;
    { Drawn as window background. @nil means there is no background
      (use only if there is always some other 2D control underneath TCastleDialog). }
    Background: TGLImage;
    Align: TTextAlign;
    { Should we display InputText }
    DrawInputText: boolean;
    Buttons: array of TCastleButton;

    procedure SetScroll(Value: Single);
    { How many pixels up should be move the text.
      Kept as a float, to allow smooth time-based changes.
      Note that setting Scroll always clamps the value to sensible range. }
    property Scroll: Single read FScroll write SetScroll;
    procedure ScrollPageDown;
    procedure ScrollPageUp;

    procedure SetInputText(const value: string);

    { Calculate height in pixels needed to draw Buttons.
      Returns 0 if there are no Buttons = ''. }
    function ButtonsHeight: Integer;
    procedure UpdateSizes;
    { The whole rectangle where we draw dialog box. }
    function WholeMessageRect: TRectangle;
    { If ScrollBarVisible, ScrollBarWholeWidth. Else 0. }
    function RealScrollBarWholeWidth: Integer;
    function Font: TGLBitmapFont;
  public
    { Set this to @true to signal that modal dialog window should be closed.
      This is not magically handled --- if you implement a modal dialog box,
      you should check in your loop whether something set Answered to @true. }
    Answered: boolean;

    { Input text. Displayed only if DrawInputText. }
    property InputText: string read FInputText write SetInputText;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Assign display stuff. Call this before adding control to Controls list. }
    procedure Initialize(
      const TextList: TStringList; const ATextAlign: TTextAlign;
      const AButtons: array of TCastleButton;
      const ADrawInputText: boolean; const AInputText: string;
      const ABackground: TGLImage);
    procedure ContainerResize(const AContainerWidth, AContainerHeight: Cardinal); override;
    function Press(const Event: TInputPressRelease): boolean; override;
    function Release(const Event: TInputPressRelease): boolean; override;
    function MouseMove(const OldX, OldY, NewX, NewY: Integer): boolean; override;
    procedure Update(const SecondsPassed: Single; var HandleInput: boolean); override;
    function DrawStyle: TUIControlDrawStyle; override;
    procedure Draw; override;
    function PositionInside(const X, Y: Integer): boolean; override;
  end;

  TThemeImage = (
    tiPanel, tiPanelSeparator, tiProgressBar, tiProgressFill,
    tiButtonPressed, tiButtonFocused, tiButtonNormal,
    tiWindow, tiScrollbarFrame, tiScrollbarSlider,
    tiSlider, tiSliderPosition, tiLabel, tiActiveFrame, tiTooltip);

  { Label with possibly multiline text, in a box. }
  TCastleLabel = class(TUIControlFont)
  private
    FText: TStrings;
    FPadding: Integer;
    FLineSpacing: Integer;
    FColor: TCastleColor;
    FTags: boolean;
  protected
    ImageType: TThemeImage;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function DrawStyle: TUIControlDrawStyle; override;
    procedure Draw; override;
    { Position and size of this control, ignoring GetExists. }
    function Rect: TRectangle;

    { Text color. By default it's white. }
    property Color: TCastleColor read FColor write FColor;
  published
    property Text: TStrings read FText;

    { Inside the label box, padding between rect borders and text. }
    property Padding: Integer read FPadding write FPadding default 0;

    { Extra spacing between lines (may also be negative to squeeze lines
      tighter). }
    property LineSpacing: Integer read FLineSpacing write FLineSpacing default 0;

    { Does the text use HTML-like tags. This is very limited for now,
      see TGLBitmapFontAbstract.PrintStrings documentation. }
    property Tags: boolean read FTags write FTags default false;
  end;

  { Theme for 2D GUI controls.
    Should only be used through the single global instance @link(Theme). }
  TCastleTheme = class
  private
    FImages: array [TThemeImage] of TCastleImage;
    FCorners: array [TThemeImage] of TVector4Integer;
    FGLImages: array [TThemeImage] of TGLImage;
    FOwnsImages: array [TThemeImage] of boolean;
    FMessageFont: TBitmapFont;
    FGLMessageFont: TGLBitmapFont;
    function GetImages(const ImageType: TThemeImage): TCastleImage;
    procedure SetImages(const ImageType: TThemeImage; const Value: TCastleImage);
    function GetOwnsImages(const ImageType: TThemeImage): boolean;
    procedure SetOwnsImages(const ImageType: TThemeImage; const Value: boolean);
    function GetCorners(const ImageType: TThemeImage): TVector4Integer;
    procedure SetCorners(const ImageType: TThemeImage; const Value: TVector4Integer);
    function GetGLImages(const ImageType: TThemeImage): TGLImage;
    procedure GLContextClose;
    { TGLImage instances fast and easy drawing of images on 2D screen.
      Reading them for the 1st time means that the TGLImage instance is created,
      so use them only when OpenGL context is already active (window is open etc.).
      Changing the TCastleImage instance will automatically free (and recreate
      at next access) the corresponding TGLImage instance. }
    property GLImages[const ImageType: TThemeImage]: TGLImage read GetGLImages;
    procedure SetMessageFont(const Value: TBitmapFont);
  public
    TooltipTextColor: TCastleColor;
    TextColor: TCastleColor;
    MessageTextColor: TCastleColor;
    MessageInputTextColor: TCastleColor;

    BarEmptyColor: TVector3Byte;
    BarFilledColor: TVector3Byte;

    constructor Create;
    destructor Destroy; override;

    { 2D GUI images, represented as TCastleImage.
      Although they all have sensible defaults, you can also change them
      at any time. Simply create TCastleImage instance (e.g. by LoadImage
      function) and assign it here. Be sure to adjust also @link(OwnsImage)
      if you want the theme to automatically free the image when it's no longer
      used.

      The alpha channel of the image, if any, is automatically correctly used
      (for alpha test or alpha blending, see TGLImage). }
    property Images[const ImageType: TThemeImage]: TCastleImage read GetImages write SetImages;

    property OwnsImages[const ImageType: TThemeImage]: boolean read GetOwnsImages write SetOwnsImages;

    { Corners that determine how image on @link(Images) is stretched.
      Together with assigning @link(Images), adjust also this property.
      It is used for images rendered using TGLImage.Draw3x3,
      it determines how the image is stretched.
      The corners are specified as 4D vector, order like in CSS: top, right, down,
      left. }
    property Corners[const ImageType: TThemeImage]: TVector4Integer read GetCorners write SetCorners;

    { Draw the selected theme image on screen. }
    procedure Draw(const Rect: TRectangle; const ImageType: TThemeImage);

    { Font used by dialogs.
      Note that it doesn't have to be mono-spaced. }
    property MessageFont: TBitmapFont read FMessageFont write SetMessageFont;
    function GLMessageFont: TGLBitmapFont;
  end;

{ The bitmap fonts used throughout UI interface.

  They work fast. Actually, only the first "create" call does actual work.
  The font is kept until the GL context is destroyed.
  (We used to have reference-counting for this, but actually just keeping
  the resource for the rest of GL context life is 1. easier and 2. better,
  because we want to keep the resource even if you destroy and then recreate
  all your controls.)

  @groupBegin }
function GetUIFont: TGLBitmapFontAbstract;
procedure SetUIFont(const Value: TGLBitmapFontAbstract);

function GetUIFontSmall: TGLBitmapFontAbstract;
procedure SetUIFontSmall(const Value: TGLBitmapFontAbstract);

property UIFont: TGLBitmapFontAbstract read GetUIFont write SetUIFont;
property UIFontSmall: TGLBitmapFontAbstract read GetUIFontSmall write SetUIFontSmall;
{ @groupEnd }

function Theme: TCastleTheme;

procedure Register;

implementation

uses SysUtils, CastleControlsImages, CastleBitmapFont_BVSans_m10,
  CastleBitmapFont_BVSans, CastleGLUtils, Math,
  CastleBitmapFont_BVSansMono_m18;

procedure Register;
begin
  RegisterComponents('Castle', [TCastleButton, TCastleImageControl]);
end;

{ Specify vertex at given pixel.

  With standard OpenGL ortho projection,
  glVertex takes coordinates in float [0..Width, 0..Height] range.
  To reliably draw on (0,0) pixel you should pass (0+epsilon, 0+epsilon)
  to glVertex. This procedure takes care of adding this epsilon. }
procedure glVertexPixel(const X, Y: Integer);
begin
  glVertex2f(X + 0.1, Y + 0.1);
end;

{ TUIControlFont ---------------------------------------------------------- }

function TUIControlFont.TooltipStyle: TUIControlDrawStyle;
begin
  if Tooltip <> '' then
    Result := ds2D else
    Result := dsNone;
end;

procedure TUIControlFont.DrawTooltip;
var
  X, Y: Integer;
  TooltipRect: TRectangle;
begin
  if TooltipLabel = nil then
  begin
    TooltipLabel := TCastleLabel.Create(nil);
    TooltipLabel.ImageType := tiTooltip;
    { we know that GL context now exists, so just directly call GLContextOpen }
    TooltipLabel.GLContextOpen;
  end;

  { assign TooltipLabel.Text first, to get TooltipRect.Width/Height }
  TooltipLabel.Padding := 5;
  TooltipLabel.Color := Theme.TooltipTextColor;
  TooltipLabel.Text.Clear;
  TooltipLabel.Text.Append(Tooltip);
  TooltipRect := TooltipLabel.Rect;

  X := Container.TooltipX;
  Y := ContainerHeight - Container.TooltipY;

  { now try to fix X, Y to make tooltip fit inside a window }
  MinTo1st(X, ContainerWidth - TooltipRect.Width);
  MinTo1st(Y, ContainerHeight - TooltipRect.Height);
  MaxTo1st(X, 0);
  MaxTo1st(Y, 0);

  TooltipLabel.Left := X;
  TooltipLabel.Bottom := Y;

  { just explicitly call Draw method of TooltipLabel }
  TooltipLabel.Draw;
end;

procedure TUIControlFont.GLContextClose;
begin
  { make sure to call GLContextClose on TooltipLabel,
    actually we can just free it now }
  FreeAndNil(TooltipLabel);
  inherited;
end;

function TUIControlFont.Font: TGLBitmapFontAbstract;
begin
  if GLInitialized then
    Result := UIFont else
    Result := nil;
end;

{ TCastleButton --------------------------------------------------------------- }

const
  ButtonCaptionImageMargin = 10;

constructor TCastleButton.Create(AOwner: TComponent);
begin
  inherited;
  FAutoSize := true;
  FAutoSizeWidth := true;
  FAutoSizeHeight := true;
  FImageLayout := ilLeft;
  { no need to UpdateTextSize here yet, since Font is for sure not ready yet. }
end;

destructor TCastleButton.Destroy;
begin
  if OwnsImage then FreeAndNil(FImage);
  FreeAndNil(FGLImage);
  inherited;
end;

function TCastleButton.DrawStyle: TUIControlDrawStyle;
begin
  if GetExists then
    Result := ds2D else
    Result := dsNone;
end;

procedure TCastleButton.Draw;
var
  TextLeft, TextBottom, ImgLeft, ImgBottom: Integer;
  Background: TThemeImage;
begin
  if not GetExists then Exit;

  if Pressed then
    Background := tiButtonPressed else
  if Focused then
    Background := tiButtonFocused else
    Background := tiButtonNormal;
  Theme.Draw(Rect, Background);

  TextLeft := Left + (Width - TextWidth) div 2;
  if (FImage <> nil) and (FGLImage <> nil) and (ImageLayout = ilLeft) then
    TextLeft += (FImage.Width + ButtonCaptionImageMargin) div 2 else
  if (FImage <> nil) and (FGLImage <> nil) and (ImageLayout = ilRight) then
    TextLeft -= (FImage.Width + ButtonCaptionImageMargin) div 2;

  TextBottom := Bottom + (Height - TextHeight) div 2;
  if (FImage <> nil) and (FGLImage <> nil) and (ImageLayout = ilBottom) then
    TextBottom += (FImage.Height + ButtonCaptionImageMargin) div 2 else
  if (FImage <> nil) and (FGLImage <> nil) and (ImageLayout = ilTop) then
    TextBottom -= (FImage.Height + ButtonCaptionImageMargin) div 2;

  Font.Print(TextLeft, TextBottom, Theme.TextColor, Caption);

  if (FImage <> nil) and (FGLImage <> nil) then
  begin
    { update FGLImage.Alpha based on ImageAlphaTest }
    if FImage.HasAlpha then
    begin
      if ImageAlphaTest then
        FGLImage.Alpha := acSimpleYesNo else
        FGLImage.Alpha := acFullRange;
    end;
    case ImageLayout of
      ilLeft         : ImgLeft := TextLeft - FImage.Width - ButtonCaptionImageMargin;
      ilRight        : ImgLeft := TextLeft + TextWidth + ButtonCaptionImageMargin;
      ilBottom, ilTop: ImgLeft := Left + (Width - FImage.Width) div 2;
    end;
    case ImageLayout of
      ilBottom       : ImgBottom := TextBottom - FImage.Height - ButtonCaptionImageMargin;
      ilTop          : ImgBottom := TextBottom + TextHeight + ButtonCaptionImageMargin;
      ilLeft, ilRight: ImgBottom := Bottom + (Height - FImage.Height) div 2;
    end;
    FGLImage.Draw(ImgLeft, ImgBottom);
  end;
end;

function TCastleButton.PositionInside(const X, Y: Integer): boolean;
begin
  Result := GetExists and
    (X >= Left) and
    (X  < Left + Width) and
    (ContainerHeight - Y >= Bottom) and
    (ContainerHeight - Y  < Bottom + Height);
end;

procedure TCastleButton.GLContextOpen;
begin
  inherited;
  if (FGLImage = nil) and (FImage <> nil) then
    FGLImage := TGLImage.Create(FImage);
  UpdateTextSize;
end;

procedure TCastleButton.GLContextClose;
begin
  FreeAndNil(FGLImage);
  inherited;
end;

function TCastleButton.Press(const Event: TInputPressRelease): boolean;
begin
  Result := inherited;
  if Result or (not GetExists) or (Event.EventType <> itMouseButton) then Exit;

  Result := ExclusiveEvents;
  if not Toggle then FPressed := true;
  ClickStarted := true;
  { We base our Draw on Pressed value. }
  VisibleChange;
end;

function TCastleButton.Release(const Event: TInputPressRelease): boolean;
begin
  Result := inherited;
  if Result or (not GetExists) or (Event.EventType <> itMouseButton) then Exit;

  if ClickStarted then
  begin
    Result := ExclusiveEvents;

    if not Toggle then FPressed := false;
    ClickStarted := false;
    { We base our Draw on Pressed value. }
    VisibleChange;

    { This is normal behavior of buttons: to click them, you have to make
      mouse down on the button, and then release mouse while still over
      the button.

      (Larger UI toolkits have also the concept of "capturing",
      that a Focused control with Pressed captures remaining
      mouse/key events even when mouse goes out. This allows the user
      to move mouse out from the control, and still go back to make mouse up
      and make "click". }
    DoClick;
  end;
end;

procedure TCastleButton.DoClick;
begin
  if Assigned(OnClick) then
    OnClick(Self);
end;

procedure TCastleButton.SetCaption(const Value: string);
begin
  if Value <> FCaption then
  begin
    FCaption := Value;
    UpdateTextSize;
  end;
end;

procedure TCastleButton.SetAutoSize(const Value: boolean);
begin
  if Value <> FAutoSize then
  begin
    FAutoSize := Value;
    UpdateTextSize;
  end;
end;

procedure TCastleButton.SetAutoSizeWidth(const Value: boolean);
begin
  if Value <> FAutoSizeWidth then
  begin
    FAutoSizeWidth := Value;
    UpdateTextSize;
  end;
end;

procedure TCastleButton.SetAutoSizeHeight(const Value: boolean);
begin
  if Value <> FAutoSizeHeight then
  begin
    FAutoSizeHeight := Value;
    UpdateTextSize;
  end;
end;

procedure TCastleButton.UpdateTextSize;
begin
  if Font <> nil then
  begin
    TextWidth := Font.TextWidth(Caption);
    TextHeight := Font.RowHeightBase;
    UpdateSize;
  end;
end;

procedure TCastleButton.UpdateSize;
const
  HorizontalMargin = 10;
  VerticalMargin = 10;
var
  ImgSize: Cardinal;
begin
  if AutoSize then
  begin
    { We modify FWidth, FHeight directly,
      to avoid causing UpdateFocusAndMouseCursor too many times.
      We'll call it at the end explicitly. }
    if AutoSizeWidth then FWidth := TextWidth + HorizontalMargin * 2;
    if AutoSizeHeight then FHeight := TextHeight + VerticalMargin * 2;
    if (FImage <> nil) or
       (MinImageWidth <> 0) or
       (MinImageHeight <> 0) then
    begin
      if AutoSizeWidth then
      begin
        if FImage <> nil then
          ImgSize := Max(FImage.Width, MinImageWidth) else
          ImgSize := MinImageWidth;
        case ImageLayout of
          ilLeft, ilRight: FWidth := Width + ImgSize + ButtonCaptionImageMargin;
          ilTop, ilBottom: FWidth := Max(Width, ImgSize + HorizontalMargin * 2);
        end;
      end;
      if AutoSizeHeight then
      begin
        if FImage <> nil then
          ImgSize := Max(FImage.Height, MinImageHeight) else
          ImgSize := MinImageHeight;
        case ImageLayout of
          ilLeft, ilRight: FHeight := Max(Height, ImgSize + VerticalMargin * 2);
          ilTop, ilBottom: FHeight := Height + ImgSize + ButtonCaptionImageMargin;
        end;
      end;
    end;

    { at the end apply MinXxx properties }
    if AutoSizeWidth then
      MaxTo1st(FWidth, MinWidth);
    if AutoSizeHeight then
      MaxTo1st(FHeight, MinHeight);

    if (AutoSizeWidth or AutoSizeHeight) and (Container <> nil) then
      Container.UpdateFocusAndMouseCursor;
  end;
end;

procedure TCastleButton.SetImage(const Value: TCastleImage);
begin
  if FImage <> Value then
  begin
    if OwnsImage then FreeAndNil(FImage);
    FreeAndNil(FGLImage);

    FImage := Value;

    if GLInitialized and (FImage <> nil) then
      FGLImage := TGLImage.Create(FImage);

    UpdateSize;
  end;
end;

procedure TCastleButton.SetFocused(const Value: boolean);
begin
  if Value <> Focused then
  begin
    if not Value then
    begin
      if not Toggle then FPressed := false;
      ClickStarted := false;
    end;

    { We base our Draw on Pressed and Focused value. }
    VisibleChange;
  end;

  inherited;
end;

procedure TCastleButton.SetPressed(const Value: boolean);
begin
  if FPressed <> Value then
  begin
    if not Toggle then
      raise Exception.Create('You cannot modify TCastleButton.Pressed value when Toggle is false');
    FPressed := Value;
    VisibleChange;
  end;
end;

procedure TCastleButton.SetImageLayout(const Value: TCastleButtonImageLayout);
begin
  if FImageLayout <> Value then
  begin
    FImageLayout := Value;
    UpdateSize;
    VisibleChange;
  end;
end;

procedure TCastleButton.SetWidth(const Value: Cardinal);
begin
  if FWidth <> Value then
  begin
    FWidth := Value;
    if Container <> nil then Container.UpdateFocusAndMouseCursor;
  end;
end;

procedure TCastleButton.SetHeight(const Value: Cardinal);
begin
  if FHeight <> Value then
  begin
    FHeight := Value;
    if Container <> nil then Container.UpdateFocusAndMouseCursor;
  end;
end;

procedure TCastleButton.SetMinWidth(const Value: Cardinal);
begin
  if FMinWidth <> Value then
  begin
    FMinWidth := Value;
    UpdateSize;
    VisibleChange;
  end;
end;

procedure TCastleButton.SetMinHeight(const Value: Cardinal);
begin
  if FMinHeight <> Value then
  begin
    FMinHeight := Value;
    UpdateSize;
    VisibleChange;
  end;
end;

function TCastleButton.Rect: TRectangle;
begin
  Result := Rectangle(Left, Bottom, Width, Height);
end;

{ TCastlePanel ------------------------------------------------------------------ }

constructor TCastlePanel.Create(AOwner: TComponent);
begin
  inherited;
  FVerticalSeparators := TCardinalList.Create;
end;

destructor TCastlePanel.Destroy;
begin
  FreeAndNil(FVerticalSeparators);
  inherited;
end;

function TCastlePanel.DrawStyle: TUIControlDrawStyle;
begin
  if GetExists then
    Result := ds2D else
    Result := dsNone;
end;

procedure TCastlePanel.Draw;
const
  SeparatorMargin = 8;
var
  I: Integer;
begin
  if not GetExists then Exit;

  Theme.Draw(Rect, tiPanel);

  for I := 0 to VerticalSeparators.Count - 1 do
    Theme.Draw(Rectangle(
      Left + VerticalSeparators[I], Bottom + SeparatorMargin,
      Theme.Images[tiPanelSeparator].Width, Height - 2 * SeparatorMargin),
      tiPanelSeparator);
end;

function TCastlePanel.PositionInside(const X, Y: Integer): boolean;
begin
  Result := GetExists and
    (X >= Left) and
    (X  < Left + Width) and
    (ContainerHeight - Y >= Bottom) and
    (ContainerHeight - Y  < Bottom + Height);
end;

class function TCastlePanel.SeparatorSize: Cardinal;
begin
  Result := 2;
end;

procedure TCastlePanel.SetWidth(const Value: Cardinal);
begin
  if FWidth <> Value then
  begin
    FWidth := Value;
    if Container <> nil then Container.UpdateFocusAndMouseCursor;
  end;
end;

procedure TCastlePanel.SetHeight(const Value: Cardinal);
begin
  if FHeight <> Value then
  begin
    FHeight := Value;
    if Container <> nil then Container.UpdateFocusAndMouseCursor;
  end;
end;

function TCastlePanel.Rect: TRectangle;
begin
  Result := Rectangle(Left, Bottom, Width, Height);
end;

{ TCastleImageControl ---------------------------------------------------------------- }

destructor TCastleImageControl.Destroy;
begin
  FreeAndNil(FImage);
  FreeAndNil(FGLImage);
  inherited;
end;

procedure TCastleImageControl.SetURL(const Value: string);
begin
  if Value <> '' then
    Image := LoadImage(Value, []) else
    Image := nil;

  { only once new Image is successfully loaded, change property value.
    If LoadImage raised exception, URL will remain unchanged. }
  FURL := Value;
end;

procedure TCastleImageControl.SetImage(const Value: TCastleImage);
begin
  if FImage <> Value then
  begin
    FreeAndNil(FImage);
    FreeAndNil(FGLImage);

    FImage := Value;
    if GLInitialized and (FImage <> nil) then
      FGLImage := TGLImage.Create(FImage);
  end;
end;

function TCastleImageControl.DrawStyle: TUIControlDrawStyle;
begin
  if GetExists and (FGLImage <> nil) then
    Result := ds2D else
    Result := dsNone;
end;

procedure TCastleImageControl.Draw;
begin
  if not (GetExists and (FGLImage <> nil)) then Exit;
  FGLImage.Draw(Left, Bottom);
end;

function TCastleImageControl.PositionInside(const X, Y: Integer): boolean;
begin
  Result := GetExists and
    (FImage <> nil) and
    (X >= Left) and
    (X  < Left + FImage.Width) and
    (ContainerHeight - Y >= Bottom) and
    (ContainerHeight - Y  < Bottom + FImage.Height);
end;

procedure TCastleImageControl.GLContextOpen;
begin
  inherited;
  if (FGLImage = nil) and (FImage <> nil) then
    FGLImage := TGLImage.Create(FImage);
end;

procedure TCastleImageControl.GLContextClose;
begin
  FreeAndNil(FGLImage);
  inherited;
end;

function TCastleImageControl.Width: Cardinal;
begin
  if FImage <> nil then
    Result := FImage.Width else
    Result := 0;
end;

function TCastleImageControl.Height: Cardinal;
begin
  if FImage <> nil then
    Result := FImage.Height else
    Result := 0;
end;

{ TCastleSimpleBackground ---------------------------------------------------- }

constructor TCastleSimpleBackground.Create(AOwner: TComponent);
begin
  inherited;
  FColor := Black;
end;

function TCastleSimpleBackground.DrawStyle: TUIControlDrawStyle;
begin
  if GetExists then
    { 3D, because we want to be drawn before other 3D objects }
    Result := ds3D else
    Result := dsNone;
end;

procedure TCastleSimpleBackground.Draw;
begin
  if not GetExists then Exit;
  glPushAttrib(GL_COLOR_BUFFER_BIT);
    glClearColor(
      Color[0] / 255,
      Color[1] / 255,
      Color[2] / 255,
      Color[3] / 255); // saved by GL_COLOR_BUFFER_BIT
    glClear(GL_COLOR_BUFFER_BIT);
  glPopAttrib;
end;

{ TCastleDialog -------------------------------------------------------------- }

constructor TCastleDialog.Create(AOwner: TComponent);
begin
  inherited;
  { Contents of Broken_xxx will be initialized in TCastleDialog.UpdateSizes. }
  Broken_Text := TStringList.Create;
  Broken_InputText := TStringList.Create;
end;

procedure TCastleDialog.Initialize(const TextList: TStringList;
  const ATextAlign: TTextAlign; const AButtons: array of TCastleButton;
  const ADrawInputText: boolean; const AInputText: string;
  const ABackground: TGLImage);
var
  I: Integer;
begin
  Text := TextList;
  Background := ABackground;
  Align := ATextAlign;
  DrawInputText := ADrawInputText;
  FInputText := AInputText;
  SetLength(Buttons, Length(AButtons));
  for I := 0 to High(AButtons) do
    Buttons[I] := AButtons[I];
end;

destructor TCastleDialog.Destroy;
begin
  FreeAndNil(Broken_Text);
  FreeAndNil(Broken_InputText);
  inherited;
end;

procedure TCastleDialog.SetScroll(Value: Single);
begin
  Clamp(Value, ScrollMin, ScrollMax);
  if Value <> Scroll then
  begin
    FScroll := Value;
    VisibleChange;
  end;
end;

procedure TCastleDialog.ScrollPageDown;
var
  PageHeight: Single;
begin
  PageHeight := VisibleScrolledLinesCount * Font.RowHeight;
  Scroll := Scroll + PageHeight;
end;

procedure TCastleDialog.ScrollPageUp;
var
  PageHeight: Single;
begin
  PageHeight := VisibleScrolledLinesCount * Font.RowHeight;
  Scroll := Scroll - PageHeight;
end;

procedure TCastleDialog.SetInputText(const value: string);
begin
  FInputText := value;
  VisibleChange;
  UpdateSizes;
end;

function TCastleDialog.ButtonsHeight: Integer;
var
  Button: TCastleButton;
begin
  Result := 0;
  for Button in Buttons do
    MaxTo1st(Result, Button.Height + 2 * BoxMargin);
end;

procedure TCastleDialog.ContainerResize(const AContainerWidth, AContainerHeight: Cardinal);
var
  MessageRect: TRectangle;
  X, Y, I: Integer;
  Button: TCastleButton;
begin
  inherited;
  UpdateSizes;

  { Reposition Buttons. }
  if Length(Buttons) <> 0 then
  begin
    MessageRect := WholeMessageRect;
    X := MessageRect.Right  - BoxMargin;
    Y := MessageRect.Bottom + BoxMargin;
    for I := Length(Buttons) - 1 downto 0 do
    begin
      Button := Buttons[I];
      X -= Button.Width;
      Button.Left := X;
      Button.Bottom := Y;
      X -= ButtonHorizontalMargin;
    end;
  end;
end;

procedure TCastleDialog.UpdateSizes;
var
  BreakWidth, ButtonsWidth: integer;
  WindowScrolledHeight: Integer;
  Button: TCastleButton;
begin
  { calculate BreakWidth, which is the width at which we should break
    our string lists Broken_Xxx. We must here always subtract
    ScrollBarWholeWidth to be on the safe side, because we don't know
    yet is ScrollBarVisible. }
  BreakWidth := Max(0, ContainerWidth - BoxMargin * 2
    - WindowMargin * 2 - ScrollBarWholeWidth);

  { calculate MaxLineWidth and AllScrolledLinesCount }

  { calculate Broken_Text }
  Broken_Text.Clear;
  font.BreakLines(Text, Broken_Text,  BreakWidth);
  MaxLineWidth := font.MaxTextWidth(Broken_Text);
  AllScrolledLinesCount := Broken_Text.count;

  ButtonsWidth := 0;
  for Button in Buttons do
    ButtonsWidth += Button.Width + ButtonHorizontalMargin;
  if ButtonsWidth > 0 then
    ButtonsWidth -= ButtonHorizontalMargin; // extract margin from last button
  MaxTo1st(MaxLineWidth, ButtonsWidth);

  if DrawInputText then
  begin
    { calculate Broken_InputText }
    Broken_InputText.Clear;
    Font.BreakLines(InputText, Broken_InputText, BreakWidth);
    { It's our intention that if DrawInputText then *always*
      at least 1 line of InputText (even if it's empty) will be shown.
      That's because InputText is the editable text for the user,
      so there should be indication of "empty line". }
    if Broken_InputText.count = 0 then Broken_InputText.Add('');
    MaxLineWidth := max(MaxLineWidth, font.MaxTextWidth(Broken_InputText));
    AllScrolledLinesCount += Broken_InputText.count;
  end;

  { Now we have MaxLineWidth and AllScrolledLinesCount calculated }

  { Calculate WindowScrolledHeight --- number of pixels that are controlled
    by the scrollbar. }
  WindowScrolledHeight := ContainerHeight - BoxMargin * 2
    - WindowMargin * 2 - ButtonsHeight;

  { calculate VisibleScrolledLinesCount, ScrollBarVisible }

  VisibleScrolledLinesCount := Clamped(WindowScrolledHeight div Font.RowHeight,
    0, AllScrolledLinesCount);
  ScrollBarVisible := VisibleScrolledLinesCount < AllScrolledLinesCount;
  { if ScrollBarVisible changed from true to false then we must make
    sure that ScrollBarDragging is false. }
  if not ScrollBarVisible then
    ScrollBarDragging := false;

  { Note that when not ScrollBarVisible,
    then VisibleScrolledLinesCount = AllScrolledLinesCount,
    then ScrollMin = 0
    so ScrollMin = ScrollMax,
    so Scroll will always be 0. }
  ScrollMin := -Font.RowHeight *
    (AllScrolledLinesCount - VisibleScrolledLinesCount);
  { ScrollMax jest stale ale to nic; wszystko bedziemy pisac
    tak jakby ScrollMax tez moglo sie zmieniac - byc moze kiedys zrobimy
    z tej mozliwosci uzytek. }
  ScrollMax := 0;
  ScrollMaxForScrollbar := ScrollMin + Font.RowHeight * AllScrolledLinesCount;

  if ScrollInitialized then
    { This clamps Scroll to proper range }
    Scroll := Scroll else
  begin
    { Need to initalize Scroll, otherwise default Scroll = 0 means were
      at the bottom of the text. }
    Scroll := ScrollMin;
    ScrollInitialized := true;
  end;
end;

function TCastleDialog.Press(const Event: TInputPressRelease): boolean;
var
  MY: Integer;
begin
  Result := inherited;
  if Result or (not GetExists) then Exit;

  { if not ScrollBarVisible then there is no point in changing Scroll
    (because always ScrollMin = ScrollMax = Scroll = 0).

    This way we allow descendants like TCastleKeyMouseDialog
    to handle K_PageDown, K_PageUp, K_Home and K_End keys
    and mouse wheel. And this is very good for MessageKey,
    when it's used e.g. to allow user to choose any TKey.
    Otherwise MessageKey would not be able to return
    K_PageDown, K_PageUp, etc. keys. }

  if ScrollBarVisible then
    case Event.EventType of
      itKey:
        case Event.Key of
          K_PageUp:   begin ScrollPageUp;        Result := true; end;
          K_PageDown: begin ScrollPageDown;      Result := true; end;
          K_Home:     begin Scroll := ScrollMin; Result := true; end;
          K_End:      begin Scroll := ScrollMax; Result := true; end;
        end;
      itMouseButton:
        begin
          MY := ContainerHeight - Container.MouseY;
          if (Event.MouseButton = mbLeft) and ScrollBarVisible and
            ScrollbarFrame.Contains(Container.MouseX, MY) then
          begin
            if MY < ScrollbarSlider.Bottom then
              ScrollPageDown else
            if MY >= ScrollbarSlider.Top then
              ScrollPageUp else
              ScrollBarDragging := true;
            Result := true;
          end;
        end;
      itMouseWheel:
        if Event.MouseWheelVertical then
        begin
          Scroll := Scroll - Event.MouseWheelScroll * Font.RowHeight;
          Result := true;
        end;
    end;
end;

function TCastleDialog.Release(const Event: TInputPressRelease): boolean;
begin
  Result := inherited;
  if Result or (not GetExists) then Exit;

  if Event.IsMouseButton(mbLeft) then
  begin
    ScrollBarDragging := false;
    Result := true;
  end;
end;

function TCastleDialog.MouseMove(const OldX, OldY, NewX, NewY: Integer): boolean;
begin
  Result := inherited;
  if Result or (not GetExists) then Exit;

  Result := ScrollBarDragging;
  if Result then
    Scroll := Scroll + (NewY- OldY) / ScrollbarFrame.Height *
      (ScrollMaxForScrollbar - ScrollMin);
end;

procedure TCastleDialog.Update(const SecondsPassed: Single;
  var HandleInput: boolean);

  function Factor: Single;
  begin
    result := 200.0 * SecondsPassed;
    if mkCtrl in Container.Pressed.Modifiers then result *= 6;
  end;

begin
  inherited;

  if HandleInput then
  begin
    if Container.Pressed[K_Up  ] then Scroll := Scroll - Factor;
    if Container.Pressed[K_Down] then Scroll := Scroll + Factor;
    HandleInput := not ExclusiveEvents;
  end;
end;

function TCastleDialog.DrawStyle: TUIControlDrawStyle;
begin
  if GetExists then
    Result := ds2D else
    Result := dsNone;
end;

procedure TCastleDialog.Draw;

  { Render a Text line, and move Y up to the line above. }
  procedure DrawString(X: Integer; var Y: Integer; const Color: TCastleColor;
    const text: string; TextAlign: TTextAlign);
  begin
    { change X only locally, to take TextAlign into account }
    case TextAlign of
      taMiddle: X += (MaxLineWidth - font.TextWidth(text)) div 2;
      taRight : X +=  MaxLineWidth - font.TextWidth(text);
    end;
    Font.Print(X, Y, Color, text);
    { change Y for caller, to print next line higher }
    Y += font.RowHeight;
  end;

  { Render all lines in S, and move Y up to the line above. }
  procedure DrawStrings(const X: Integer; var Y: Integer;
    const Color: TCastleColor; const s: TStrings; TextAlign: TTextAlign);
  var
    i: integer;
  begin
    for i := s.count-1 downto 0 do
      { each DrawString call will move Y up }
      DrawString(X, Y, Color, s[i], TextAlign);
  end;

var
  MessageRect: TRectangle;
  { InnerRect to okienko w ktorym mieszcza sie napisy,
    a wiec WholeMessageRect zmniejszony o BoxMargin we wszystkich kierunkach
    i z ew. obcieta prawa czescia przeznaczona na ScrollbarFrame. }
  InnerRect: TRectangle;
  ScrollBarLength: integer;
  TextX, TextY: Integer;
const
  { odleglosc paska ScrollBara od krawedzi swojego waskiego recta
    (prawa krawedz jest zarazem krawedzia duzego recta !) }
  ScrollBarMargin = 2;
  { szerokosc paska ScrollBara }
  ScrollBarInternalWidth = ScrollBarWholeWidth - ScrollBarMargin * 2;
begin
  inherited;
  if not GetExists then Exit;

  if Background <> nil then
  begin
    { Make clear since Background make not cover whole window. }
    glClear(GL_COLOR_BUFFER_BIT);
    glLoadIdentity;
    Background.Draw(0, 0);
  end;

  MessageRect := WholeMessageRect;
  Theme.Draw(MessageRect, tiWindow);

  MessageRect := MessageRect.RemoveBottom(ButtonsHeight);

  { calculate InnerRect }
  InnerRect := MessageRect.Grow(-BoxMargin);
  InnerRect.Width -= RealScrollBarWholeWidth;

  { draw scrollbar, and calculate it's rectangles }
  if ScrollBarVisible then
  begin
    ScrollbarFrame := MessageRect.RightPart(ScrollBarWholeWidth).
      RemoveRight(Theme.Corners[tiWindow][1]).
      RemoveTop(Theme.Corners[tiWindow][0]);
    Theme.Draw(ScrollbarFrame, tiScrollbarFrame);

    ScrollBarLength := MessageRect.Height - ScrollBarMargin*2;
    ScrollbarSlider := ScrollbarFrame;
    ScrollbarSlider.Height := VisibleScrolledLinesCount * ScrollBarLength
      div AllScrolledLinesCount;
    ScrollbarSlider.Bottom += Round(MapRange(Scroll,
      ScrollMin, ScrollMax, ScrollbarFrame.Height - ScrollbarSlider.Height, 0));
    Theme.Draw(ScrollbarSlider, tiScrollbarSlider);
  end else
  begin
    ScrollbarFrame := TRectangle.Empty;
    ScrollbarSlider := TRectangle.Empty;
  end;

  { Make scissor to cut off text that is too far up/down.
    We subtract Font.Descend from Y0, to see the descend of
    the bottom line (which is below InnerRect.Bottom, and would not be
    ever visible otherwise). }
  glScissor(InnerRect.Left, InnerRect.Bottom - Font.Descend,
    InnerRect.Width, InnerRect.Height + Font.Descend);
  glEnable(GL_SCISSOR_TEST);

  TextX := InnerRect.Left;
  TextY := InnerRect.Bottom + Round(Scroll);

  { draw Broken_InputText and Broken_Text.
    Order matters, as it's drawn from bottom to top. }
  if DrawInputText then
    DrawStrings(TextX, TextY, Theme.MessageInputTextColor, Broken_InputText, Align);
  DrawStrings(TextX, TextY, Theme.MessageTextColor, Broken_Text, Align);

  glDisable(GL_SCISSOR_TEST);
end;

function TCastleDialog.PositionInside(const X, Y: Integer): boolean;
begin
  Result := true;
end;

function TCastleDialog.RealScrollBarWholeWidth: Integer;
begin
  Result := Iff(ScrollBarVisible, ScrollBarWholeWidth, 0);
end;

function TCastleDialog.WholeMessageRect: TRectangle;
begin
  Result := Rectangle(0, 0, ContainerWidth, ContainerHeight).Center(
    Min(MaxLineWidth + BoxMargin * 2 + RealScrollBarWholeWidth,
      ContainerWidth  - WindowMargin * 2),
    Min(AllScrolledLinesCount * Font.RowHeight + BoxMargin * 2 + ButtonsHeight,
      ContainerHeight - WindowMargin * 2));
end;

function TCastleDialog.Font: TGLBitmapFont;
begin
  Result := Theme.GLMessageFont;
end;

{ TCastleLabel --------------------------------------------------------------- }

constructor TCastleLabel.Create(AOwner: TComponent);
begin
  inherited;
  FText := TStringList.Create;
  FColor := White;
  ImageType := tiLabel;
end;

destructor TCastleLabel.Destroy;
begin
  FreeAndNil(FText);
  inherited;
end;

function TCastleLabel.DrawStyle: TUIControlDrawStyle;
begin
  if GetExists then
    Result := ds2D else
    Result := dsNone;
end;

function TCastleLabel.Rect: TRectangle;
begin
  Result := Rectangle(Left, Bottom,
    Font.MaxTextWidth(Text, Tags) + 2 * Padding,
    (Font.RowHeight + LineSpacing) * Text.Count + 2 * Padding + Font.Descend);
end;

procedure TCastleLabel.Draw;
var
  R: TRectangle;
begin
  if (not GetExists) or (Text.Count = 0) then Exit;
  R := Rect;
  Theme.Draw(Rect, ImageType);
  Font.PrintStrings(R.Left + Padding,
    R.Bottom + Padding + Font.Descend, Color, Text, Tags, LineSpacing);
end;

{ TCastleTheme --------------------------------------------------------------- }

constructor TCastleTheme.Create;
begin
  inherited;
  TooltipTextColor := Vector4Byte(  0,   0,   0);
  TextColor        := Vector4Byte(  0,   0,   0);
  BarEmptyColor    := Vector3Byte(192, 192, 192);
  BarFilledColor   := Vector3Byte(Round(0.2 * 255), Round(0.5 * 255), 0);
  MessageInputTextColor := Vector4Byte( 85, 255, 255);
  MessageTextColor      := Vector4Byte(255, 255, 255);

  MessageFont := BitmapFont_BVSansMono_M18;

  FImages[tiPanel] := Panel;
  FCorners[tiPanel] := Vector4Integer(0, 0, 0, 0);
  FImages[tiPanelSeparator] := PanelSeparator;
  FCorners[tiPanelSeparator] := Vector4Integer(0, 0, 0, 0);
  FImages[tiProgressBar] := ProgressBar;
  FCorners[tiProgressBar] := Vector4Integer(7, 7, 7, 7);
  FImages[tiProgressFill] := ProgressFill;
  FCorners[tiProgressFill] := Vector4Integer(1, 1, 1, 1);
  FImages[tiButtonNormal] := ButtonNormal;
  FCorners[tiButtonNormal] := Vector4Integer(2, 2, 2, 2);
  FImages[tiButtonPressed] := ButtonPressed;
  FCorners[tiButtonPressed] := Vector4Integer(2, 2, 2, 2);
  FImages[tiButtonFocused] := ButtonFocused;
  FCorners[tiButtonFocused] := Vector4Integer(2, 2, 2, 2);
  FImages[tiWindow] := WindowDark;
  FCorners[tiWindow] := Vector4Integer(2, 2, 2, 2);
  FImages[tiScrollbarFrame] := ScrollbarFrame;
  FCorners[tiScrollbarFrame] := Vector4Integer(1, 1, 1, 1);
  FImages[tiScrollbarSlider] := ScrollbarSlider;
  FCorners[tiScrollbarSlider] := Vector4Integer(2, 2, 2, 2);
  FImages[tiSlider] := Slider;
  FCorners[tiSlider] := Vector4Integer(4, 7, 4, 7);
  FImages[tiSliderPosition] := SliderPosition;
  FCorners[tiSliderPosition] := Vector4Integer(1, 1, 1, 1);
  FImages[tiLabel] := FrameWhiteBlack;
  FCorners[tiLabel] := Vector4Integer(2, 2, 2, 2);
  FImages[tiActiveFrame] := FrameWhite;
  FCorners[tiActiveFrame] := Vector4Integer(2, 2, 2, 2);
  FImages[tiTooltip] := Tooltip;
  FCorners[tiTooltip] := Vector4Integer(1, 1, 1, 1);
end;

destructor TCastleTheme.Destroy;
var
  I: TThemeImage;
begin
  for I in TThemeImage do
    if FOwnsImages[I] then
      FreeAndNil(FImages[I]) else
      FImages[I] := nil;
  inherited;
end;

function TCastleTheme.GetImages(const ImageType: TThemeImage): TCastleImage;
begin
  Result := FImages[ImageType];
end;

procedure TCastleTheme.SetImages(const ImageType: TThemeImage;
  const Value: TCastleImage);
begin
  if FImages[ImageType] <> Value then
  begin
    { free previous image }
    if FOwnsImages[ImageType] then
      FreeAndNil(FImages[ImageType]);
    FImages[ImageType] := Value;
    FreeAndNil(FGLImages[ImageType]);
  end;
end;

function TCastleTheme.GetOwnsImages(const ImageType: TThemeImage): boolean;
begin
  Result := FOwnsImages[ImageType];
end;

procedure TCastleTheme.SetOwnsImages(const ImageType: TThemeImage;
  const Value: boolean);
begin
  FOwnsImages[ImageType] := Value;
end;

function TCastleTheme.GetCorners(const ImageType: TThemeImage): TVector4Integer;
begin
  Result := FCorners[ImageType];
end;

procedure TCastleTheme.SetCorners(const ImageType: TThemeImage; const Value: TVector4Integer);
begin
  FCorners[ImageType] := Value;
end;

function TCastleTheme.GetGLImages(const ImageType: TThemeImage): TGLImage;
begin
  if FGLImages[ImageType] = nil then
    FGLImages[ImageType] := TGLImage.Create(FImages[ImageType], true);
  Result := FGLImages[ImageType];
end;

procedure TCastleTheme.GLContextClose;
var
  ImageType: TThemeImage;
begin
  for ImageType in TThemeImage do
    FreeAndNil(FGLImages[ImageType]);
  FreeAndNil(FGLMessageFont);
end;

procedure TCastleTheme.Draw(const Rect: TRectangle; const ImageType: TThemeImage);
begin
  GLImages[ImageType].Draw3x3(Rect, Corners[ImageType]);
end;

procedure TCastleTheme.SetMessageFont(const Value: TBitmapFont);
begin
  if FMessageFont <> Value then
  begin
    FMessageFont := Value;
    FreeAndNil(FGLMessageFont);
  end;
end;

function TCastleTheme.GLMessageFont: TGLBitmapFont;
begin
  if FGLMessageFont = nil then
    FGLMessageFont := TGLBitmapFont.Create(FMessageFont);
  Result := FGLMessageFont;
end;

var
  FTheme: TCastleTheme;

function Theme: TCastleTheme;
begin
  Result := FTheme;
end;

{ UIFont --------------------------------------------------------------------- }

var
  FUIFont: TGLBitmapFontAbstract;
  FUIFontSmall: TGLBitmapFontAbstract;

function GetUIFont: TGLBitmapFontAbstract;
begin
  if FUIFont = nil then
    FUIFont := TGLBitmapFont.Create(BitmapFont_BVSans);
  Result := FUIFont;
end;

procedure SetUIFont(const Value: TGLBitmapFontAbstract);
begin
  if FUIFont <> Value then
  begin
    FreeAndNil(FUIFont);
    FUIFont := Value;
  end;
end;

function GetUIFontSmall: TGLBitmapFontAbstract;
begin
  if FUIFontSmall = nil then
    FUIFontSmall := TGLBitmapFont.Create(BitmapFont_BVSans_m10);
  Result := FUIFontSmall;
end;

procedure SetUIFontSmall(const Value: TGLBitmapFontAbstract);
begin
  if FUIFontSmall <> Value then
  begin
    FreeAndNil(FUIFontSmall);
    FUIFontSmall := Value;
  end;
end;

procedure WindowClose(const Container: IUIContainer);
begin
  FreeAndNil(FUIFont);
  FreeAndNil(FUIFontSmall);
  if FTheme <> nil then
    FTheme.GLContextClose;
end;

initialization
  OnGLContextClose.Add(@WindowClose);
  FTheme := TCastleTheme.Create;
finalization
  FreeAndNil(FTheme);
end.
