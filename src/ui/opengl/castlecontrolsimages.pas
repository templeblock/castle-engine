{ -*- buffer-read-only: t -*- }

{ Unit automatically generated by image_to_pas tool,
  to embed images in Pascal source code.
  @exclude (Exclude this unit from PasDoc documentation.) }
unit CastleControlsImages;

interface

uses CastleImages;

var
  Panel: TRGBAlphaImage;

var
  WindowDarkTransparent: TRGBAlphaImage;

var
  Slider: TRGBAlphaImage;

var
  Tooltip: TRGBImage;

var
  TooltipRounded: TRGBAlphaImage;

var
  ButtonPressed: TRGBAlphaImage;

var
  ButtonFocused: TRGBAlphaImage;

var
  ButtonNormal: TRGBAlphaImage;

var
  FrameWhite: TRGBAlphaImage;

var
  FrameWhiteBlack: TRGBAlphaImage;

var
  FrameYellow: TRGBAlphaImage;

var
  FrameYellowBlack: TRGBAlphaImage;

var
  FrameThickWhite: TRGBAlphaImage;

var
  FrameThickYellow: TRGBAlphaImage;

var
  ProgressBar: TRGBAlphaImage;

var
  ProgressFill: TRGBAlphaImage;

var
  PanelSeparator: TRGBImage;

var
  WindowDark: TRGBImage;

var
  WindowGray: TRGBImage;

var
  ScrollbarFrame: TRGBImage;

var
  ScrollbarSlider: TRGBImage;

var
  SliderPosition: TRGBImage;

implementation

uses SysUtils;

{ Actual image data is included from another file, with a deliberately
  non-Pascal file extension ".image_data". This way ohloh.net will
  not recognize this source code as (uncommented) Pascal source code. }
{$I castlecontrolsimages.image_data}

initialization
  Panel := TRGBAlphaImage.Create(PanelWidth, PanelHeight);
  Move(PanelPixels, Panel.RawPixels^, SizeOf(PanelPixels));
  WindowDarkTransparent := TRGBAlphaImage.Create(WindowDarkTransparentWidth, WindowDarkTransparentHeight);
  Move(WindowDarkTransparentPixels, WindowDarkTransparent.RawPixels^, SizeOf(WindowDarkTransparentPixels));
  Slider := TRGBAlphaImage.Create(SliderWidth, SliderHeight);
  Move(SliderPixels, Slider.RawPixels^, SizeOf(SliderPixels));
  Tooltip := TRGBImage.Create(TooltipWidth, TooltipHeight);
  Move(TooltipPixels, Tooltip.RawPixels^, SizeOf(TooltipPixels));
  TooltipRounded := TRGBAlphaImage.Create(TooltipRoundedWidth, TooltipRoundedHeight);
  Move(TooltipRoundedPixels, TooltipRounded.RawPixels^, SizeOf(TooltipRoundedPixels));
  ButtonPressed := TRGBAlphaImage.Create(ButtonPressedWidth, ButtonPressedHeight);
  Move(ButtonPressedPixels, ButtonPressed.RawPixels^, SizeOf(ButtonPressedPixels));
  ButtonFocused := TRGBAlphaImage.Create(ButtonFocusedWidth, ButtonFocusedHeight);
  Move(ButtonFocusedPixels, ButtonFocused.RawPixels^, SizeOf(ButtonFocusedPixels));
  ButtonNormal := TRGBAlphaImage.Create(ButtonNormalWidth, ButtonNormalHeight);
  Move(ButtonNormalPixels, ButtonNormal.RawPixels^, SizeOf(ButtonNormalPixels));
  FrameWhite := TRGBAlphaImage.Create(FrameWhiteWidth, FrameWhiteHeight);
  Move(FrameWhitePixels, FrameWhite.RawPixels^, SizeOf(FrameWhitePixels));
  FrameWhiteBlack := TRGBAlphaImage.Create(FrameWhiteBlackWidth, FrameWhiteBlackHeight);
  Move(FrameWhiteBlackPixels, FrameWhiteBlack.RawPixels^, SizeOf(FrameWhiteBlackPixels));
  FrameYellow := TRGBAlphaImage.Create(FrameYellowWidth, FrameYellowHeight);
  Move(FrameYellowPixels, FrameYellow.RawPixels^, SizeOf(FrameYellowPixels));
  FrameYellowBlack := TRGBAlphaImage.Create(FrameYellowBlackWidth, FrameYellowBlackHeight);
  Move(FrameYellowBlackPixels, FrameYellowBlack.RawPixels^, SizeOf(FrameYellowBlackPixels));
  FrameThickWhite := TRGBAlphaImage.Create(FrameThickWhiteWidth, FrameThickWhiteHeight);
  Move(FrameThickWhitePixels, FrameThickWhite.RawPixels^, SizeOf(FrameThickWhitePixels));
  FrameThickYellow := TRGBAlphaImage.Create(FrameThickYellowWidth, FrameThickYellowHeight);
  Move(FrameThickYellowPixels, FrameThickYellow.RawPixels^, SizeOf(FrameThickYellowPixels));
  ProgressBar := TRGBAlphaImage.Create(ProgressBarWidth, ProgressBarHeight);
  Move(ProgressBarPixels, ProgressBar.RawPixels^, SizeOf(ProgressBarPixels));
  ProgressFill := TRGBAlphaImage.Create(ProgressFillWidth, ProgressFillHeight);
  Move(ProgressFillPixels, ProgressFill.RawPixels^, SizeOf(ProgressFillPixels));
  PanelSeparator := TRGBImage.Create(PanelSeparatorWidth, PanelSeparatorHeight);
  Move(PanelSeparatorPixels, PanelSeparator.RawPixels^, SizeOf(PanelSeparatorPixels));
  WindowDark := TRGBImage.Create(WindowDarkWidth, WindowDarkHeight);
  Move(WindowDarkPixels, WindowDark.RawPixels^, SizeOf(WindowDarkPixels));
  WindowGray := TRGBImage.Create(WindowGrayWidth, WindowGrayHeight);
  Move(WindowGrayPixels, WindowGray.RawPixels^, SizeOf(WindowGrayPixels));
  ScrollbarFrame := TRGBImage.Create(ScrollbarFrameWidth, ScrollbarFrameHeight);
  Move(ScrollbarFramePixels, ScrollbarFrame.RawPixels^, SizeOf(ScrollbarFramePixels));
  ScrollbarSlider := TRGBImage.Create(ScrollbarSliderWidth, ScrollbarSliderHeight);
  Move(ScrollbarSliderPixels, ScrollbarSlider.RawPixels^, SizeOf(ScrollbarSliderPixels));
  SliderPosition := TRGBImage.Create(SliderPositionWidth, SliderPositionHeight);
  Move(SliderPositionPixels, SliderPosition.RawPixels^, SizeOf(SliderPositionPixels));
finalization
  FreeAndNil(Panel);
  FreeAndNil(WindowDarkTransparent);
  FreeAndNil(Slider);
  FreeAndNil(Tooltip);
  FreeAndNil(TooltipRounded);
  FreeAndNil(ButtonPressed);
  FreeAndNil(ButtonFocused);
  FreeAndNil(ButtonNormal);
  FreeAndNil(FrameWhite);
  FreeAndNil(FrameWhiteBlack);
  FreeAndNil(FrameYellow);
  FreeAndNil(FrameYellowBlack);
  FreeAndNil(FrameThickWhite);
  FreeAndNil(FrameThickYellow);
  FreeAndNil(ProgressBar);
  FreeAndNil(ProgressFill);
  FreeAndNil(PanelSeparator);
  FreeAndNil(WindowDark);
  FreeAndNil(WindowGray);
  FreeAndNil(ScrollbarFrame);
  FreeAndNil(ScrollbarSlider);
  FreeAndNil(SliderPosition);
end.