{
  Copyright 2001-2006 Michalis Kamburelis.

  This file is part of "Kambi's images Pascal units".

  "Kambi's images Pascal units" is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  "Kambi's images Pascal units" is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with "Kambi's images Pascal units"; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

{ Run with -h to get user help }

program image_convert;

uses SysUtils, KambiUtils, Images, ParseParametersUnit;

var
  { required params }
  InputImageName, OutputImageName: string;

  { optional params }
  ResizeX: Cardinal = 0;
  ResizeY: Cardinal = 0;
  RGBEScale: Single = 1.0;
  RGBEGamma: Single = 1.0;
  WasParam_GrayScale: boolean = false;
  Param_ConvertToChannel: Integer = -1; { -1 means "don't convert" }
  Param_StripToChannel: Integer = -1; { -1 means "don't convert" }

const
  Options: array[0..5] of TOption =
  (
    (Short:'h'; Long:'help'; Argument: oaNone),
    (Short:'s'; Long:'scale'; Argument: oaRequired),
    (Short:'g'; Long:'gamma'; Argument: oaRequired),
    (Short:#0 ; Long:'grayscale'; Argument: oaNone),
    (Short:#0 ; Long:'convert-to-channel'; Argument: oaRequired),
    (Short:#0 ; Long:'strip-to-channel'; Argument: oaRequired)
  );

  procedure OptionProc(OptionNum: Integer; HasArgument: boolean;
    const Argument: string; const SeparateArgs: TSeparateArgs; Data: Pointer);
  begin
   case OptionNum of
    0: begin
       Writeln(
         'image_convert <inputfile> <outputfile> [<resize-x> <resize-y>]' +nl+
         'will convert image in <inputfile> to image in <outputfile>.' +nl+
         'Format of both images will be recognized from file extension.' +nl+
         '<inputfile> and <outputfile> may be the same file, it doesn''t matter.' +nl+
         '' +nl+
         'If <resize-x> <resize-y> parameters are given then output image' +nl+
         'is scaled to that size. Size = 0 means "do not scale in this dimension",' +nl+
         'e.g. <resize-x> <resize-y> = 200 0 means "scale x dimension to 200' +nl+
         'and leave y dimension as is". (effectively, specifying' +nl+
         '<resize-x> <resize-y> = 0 0 has the same effect as omitting these' +nl+
         'parameters).' +nl+
         '' +nl+
         'Additional params with no fixed position:' +nl+
         '-s <float> or' +nl+
         '--scale <float>' +nl+
         '  Valid only if input file is in RGBE format (error will be raised' +nl+
         '  if this param is specified when input file is not in RGBE format).' +nl+
         '  Effect : before writing output image, scales each pixel color' +nl+
         '  (it''s red, green and blue value) by <float>.' +nl+
         '  Multiple --scale-rgbe _cummulate_ : e.g.' +nl+
         '  "--scale-rgbe 1.5 --scale-rgbe 2" would have the same effect as' +nl+
         '  "--scale-rgbe 3".' +nl+
         '-g <float>' +nl+
         '--gamma <float>' +nl+
         '  Similiar to --scale - valid only when input is RGBE,' +nl+
         '  multiple params are cummulated, default is 1.0.' +nl+
         '  Each component is raised to 1/<float>.' +nl+
         '' +nl+
         '--grayscale' +nl+
         '          Convert to grayscale.' +nl+
         '--convert-to-channel 0|1|2' +nl+
         '          Converts colors to red / green / blue channel,' +nl+
         '          it''s like converting to grayscale and then' +nl+
         '          writing output to only one channel.' +nl+
         '--strip-to-channel 0|1|2' +nl+
         '          Strips colors to only one channel, i.e.' +nl+
         '          sets to zero intensities of other two channels.' +nl+
         '');
       ProgramBreak;
      end;
    1: RGBEScale *= StrToFloat(Argument);
    2: RGBEGamma *= StrToFloat(Argument);
    3: WasParam_GrayScale := true;
    4: Param_ConvertToChannel := StrToInt(Argument);
    5: Param_StripToChannel := StrToInt(Argument);
    else raise EInternalError.Create('option not impl');
   end;
  end;

var
  { helper variables }
  Img: TImage;
begin
 { parse free position params }
 ParseParameters(Options, @OptionProc, nil);

 { parse fixed position params }
 if Parameters.High = 4 then
 begin
  ResizeX := StrToInt(Parameters[3]); Parameters.Delete(3, 1);
  ResizeY := StrToInt(Parameters[3]); Parameters.Delete(3, 1);
 end;
 Parameters.CheckHigh(2);
 InputImageName := Parameters[1];
 OutputImageName := Parameters[2];

 { do. }
 Img := LoadImage(InputImageName, [], [], ResizeX, ResizeY);
 try
  if RGBEScale <> 1.0 then
  begin
   Check(Img is TRGBEImage, '--scale <> 1.0 but input image is not in RGBE format');
   (Img as TRGBEImage).ScaleColors(RGBEScale);
  end;
  if RGBEGamma <> 1.0 then
  begin
   Check(Img is TRGBEImage, '--gamma <> 1.0 but input image is not in RGBE format');
   (Img as TRGBEImage).ExpColors(1/RGBEGamma);
  end;

  if WasParam_GrayScale then
   Img.Grayscale;
  if Param_ConvertToChannel <> -1 then
   Img.ConvertToChannelRGB(Param_ConvertToChannel);
  if Param_StripToChannel <> -1 then
    Img.StripToChannelRGB(Param_StripToChannel);

  SaveImage(Img, OutputImageName);
 finally Img.Free end;
end.
