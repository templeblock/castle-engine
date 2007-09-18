{
  Copyright 2003-2007 Michalis Kamburelis.

  This file is part of "Kambi VRML game engine".

  "Kambi VRML game engine" is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  "Kambi VRML game engine" is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with "Kambi VRML game engine"; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

{ @abstract(Handle sound files in various formats.)

  While this unit does use some OpenAL constants, most parts of
  this unit can be used even when OpenAL is not initilized and not
  even available. The methods that require OpenAL to be available and
  initialized are clearly marked as such in the documentation. }
unit SoundFile;

interface

uses SysUtils, KambiUtils, Classes, OpenAL;

type
  ESoundFormatNotSupportedByOpenAL = class(Exception);

  TSoundFile = class
  protected
    procedure CheckALExtension(const S: string);
  public
    { This will load a sound from a stream. }
    constructor CreateFromStream(Stream: TStream); virtual; abstract;

    { This will load a file, given a filename. This just opens the file as
      TFileStream and then calls CreateFromStream of appropriate class,
      so see CreateFromStream for more info. For now, file format
      (which TSoundFile to use) is decided by the FileName extension. }
    class function CreateFromFile(const FileName: string): TSoundFile;

    { Call this on this sound always after OpenAL is initialized
      and before passing this sound data to OpenAL.
      This may fix or check some things for this sound, checking
      e.g. whether some OpenAL extensions are supported.

      @raises(ESoundFormatNotSupportedByOpenAL if some OpenAL extension
      required to support this format is not present.) }
    procedure PrepareOpenAL; virtual;

    { Sound data, according to DataFormat.
      Contents of Data are readonly. }
    function Data: Pointer; virtual; abstract;
    { Bytes allocated for @link(Data). }
    function DataSize: LongWord; virtual; abstract;
    { Data format, as understood by OpenAL. }
    function DataFormat: TALuint; virtual; abstract;
    function Frequency: LongWord; virtual; abstract;
  end;

  TSoundFileClass = class of TSoundFile;

  EInvalidSoundFormat = class(Exception);

  TSoundMP3 = class(TSoundFile)
  private
    FData: Pointer;
    FDataSize: LongWord;
  public
    constructor CreateFromStream(Stream: TStream); override;
    destructor Destroy; override;

    procedure PrepareOpenAL; override;

    function Data: Pointer; override;
    function DataSize: LongWord; override;
    function DataFormat: TALuint; override;
    function Frequency: LongWord; override;
  end;

  { OggVorbis file loader.

    Internally we can use two implementations of OggVorbis handling:

    @orderedList(
      @item(If AL_EXT_vorbis extension is available, then we will
        use this.

        The advantage of using AL_EXT_vorbis extension is that
        OpenAL does all the work, so 1. it's easy for us
        2. OpenAL does it in a best way (uses streaming inside,
        so the OggVorbis data in decoded partially, on as-needed basis).

        The disadvantage is obviously that AL_EXT_vorbis must be present...
        And on Windows there doesn't seem a way to get the extension
        working anymore with new OpenAL. This hilarious message
        [http://opensource.creative.com/pipermail/openal/2006-April/009488.html]
        basically says that Creative will not fix AL_EXT_vorbis extension
        in Windows, because it's @italic(too easy) to do.)

      @item(If AL_EXT_vorbis extension is not available but we
        have vorbisfile library available then we use vorbisfile
        functions to decode the file.

        While this works OK, the disadvantages of our current approach
        are that we decode the whole OggVorbis file in one go.
        This means that 1. we waste potentially a lot of memory to keep
        the whole uncompressed data --- 5 MB OggVorbis file can easily
        take 50 MB in memory after decoding 2. whole decoding is done in one go,
        so there is a noticeable time delay when this takes place.
      )
    )

    The check for AL_EXT_vorbis extension and eventual decompression
    using vorbisfile directly take place in the first DataFormat call.
    You can also call method VorbisMethod to check which approach
    (if any) will be used.

    Note that both approaches require vorbisfile library to be installed
    (OpenAL AL_EXT_vorbis extension also works using vorbisfile library).
    If vorbisfile is not available, we cannot load OggVorbis sounds. }
  TSoundOggVorbis = class(TSoundFile)
  private
    DataStream: TMemoryStream;
    FDataFormat: TALuint;
    FFrequency: LongWord;
  public
    constructor CreateFromStream(Stream: TStream); override;
    destructor Destroy; override;

    procedure PrepareOpenAL; override;

    function Data: Pointer; override;
    function DataSize: LongWord; override;
    function DataFormat: TALuint; override;
    function Frequency: LongWord; override;

    class function VorbisMethod: string;
  end;

  EInvalidOggVorbis = class(EInvalidSoundFormat);

  TSoundWAV = class(TSoundFile)
  private
    FData: Pointer;
    FDataSize: LongWord;
    FDataFormat: TALuint;
    FFrequency: LongWord;
  public
    { @raises(EInvalidWAV when loading will fail because the file
      is not a valid (and supported) WAV format.) }
    constructor CreateFromStream(Stream: TStream); override;

    destructor Destroy; override;

    function Data: Pointer; override;
    function DataSize: LongWord; override;
    function DataFormat: TALuint; override;
    function Frequency: LongWord; override;
  end;

  EInvalidWAV = class(EInvalidSoundFormat);

function ALDataFormatToStr(DataFormat: TALuint): string;

implementation

uses KambiStringUtils, VorbisDecoder, VorbisFile, DataErrors;

{ TSoundFile ----------------------------------------------------------------- }

class function TSoundFile.CreateFromFile(const FileName: string): TSoundFile;

  procedure DoIt(C: TSoundFileClass);
  var
    S: TFileStream;
  begin
    S := TFileStream.Create(FileName, fmOpenRead);
    try
      try
        Result := C.CreateFromStream(S);
      except
        on E: EReadError do
        begin
          { Add FileName to exception message }
          E.Message := 'Error while reading file "' + FileName + '": ' + E.Message;
          raise;
        end;
      end;
    finally S.Free end;
  end;

var
  Ext: string;
begin
  Ext := ExtractFileExt(FileName);
  if SameText(Ext, '.mp3') then
    DoIt(TSoundMP3) else
  if SameText(Ext, '.ogg') then
    DoIt(TSoundOggVorbis) else
    DoIt(TSoundWAV);
end;

procedure TSoundFile.CheckALExtension(const S: string);
begin
  if not alIsExtensionPresent(PChar(S)) then
    raise ESoundFormatNotSupportedByOpenAL.CreateFmt('OpenAL extension "%s" ' +
      'required to play this file is not available', [S]);
end;

procedure TSoundFile.PrepareOpenAL;
begin
  { Nothing to do in this class. }
end;

{ TSoundMP3 ------------------------------------------------------------------ }

constructor TSoundMP3.CreateFromStream(Stream: TStream);
begin
  inherited Create;
  FDataSize := Stream.Size;
  FData := GetMem(FDataSize);
  Stream.ReadBuffer(Data^, FDataSize);
end;

destructor TSoundMP3.Destroy;
begin
  FreeMemNiling(FData);
  inherited;
end;

function TSoundMP3.Data: Pointer;
begin
  Result := FData;
end;

function TSoundMP3.DataSize: LongWord;
begin
  Result := FDataSize;
end;

procedure TSoundMP3.PrepareOpenAL;
begin
  inherited;

  { Although my OpenAL under Debian reports this extension present,
    it's implementation is actually not finished (looking at the sources),
    and alBufferData raises always "Invalid Value" when passed AL_EXT_mp3.
    So for now, I always raise here ESoundFormatNotSupportedByOpenAL. }
  raise ESoundFormatNotSupportedByOpenAL.Create('MP3 playing not supported');
  { CheckALExtension('AL_EXT_mp3'); }
end;

function TSoundMP3.DataFormat: TALuint;
begin
  Result := AL_FORMAT_MP3_EXT;
end;

function TSoundMP3.Frequency: LongWord;
begin
  { Below is to be completed when MP3 support will be really implemented
    in OpenAL. }
  Result := 0;
end;

{ TSoundOggVorbis ------------------------------------------------------------ }

constructor TSoundOggVorbis.CreateFromStream(Stream: TStream);
begin
  inherited Create;
  DataStream := TMemoryStream.Create;
  DataStream.CopyFrom(Stream, 0);
  DataStream.Position := 0;

  { At the beginning, let's try to use AL_FORMAT_VORBIS_EXT extension.
    Later (in DataFormat call) we will actually check is extension
    present, and if not we will try to use vorbisfile directly. }
  FDataFormat := AL_FORMAT_VORBIS_EXT;
  { The way I understand this, there's no way and no need to pass here
    Frequency, since Ogg Vorbis file's frequency changes during the file.
    This is confirmed by tests (things work OK with returning 0 here),
    and by looking at OpenAL source code (
    openal-0.0.8/src/extensions/al_ext_vorbis.c from Debian libopenal0a
    package) :
      ALint Vorbis_Callback(UNUSED(ALuint sid),
                      ALuint bid,
                      ALshort *outdata,
                      ALenum format,
                      UNUSED(ALint freq),
                      ALint samples)
    ... and freq is really unused. }
  FFrequency := 0;
end;

destructor TSoundOggVorbis.Destroy;
begin
  FreeAndNil(DataStream);
  inherited;
end;

procedure TSoundOggVorbis.PrepareOpenAL;

  procedure ConvertToDirectVorbisFileUse;
  var
    NewDataStream: TMemoryStream;
  begin
    NewDataStream := VorbisDecode(DataStream, FDataFormat, FFrequency);
    FreeAndNil(DataStream);
    DataStream := NewDataStream;
  end;

begin
  inherited;

  if (FDataFormat = AL_FORMAT_VORBIS_EXT) and
    (not alIsExtensionPresent('AL_EXT_vorbis')) then
    ConvertToDirectVorbisFileUse;
end;

function TSoundOggVorbis.DataFormat: TALuint;
begin
  Result := FDataFormat;
end;

function TSoundOggVorbis.Frequency: LongWord;
begin
  Result := FFrequency;
end;

function TSoundOggVorbis.Data: Pointer;
begin
  Result := DataStream.Memory;
end;

function TSoundOggVorbis.DataSize: LongWord;
begin
  Result := DataStream.Size;
end;

class function TSoundOggVorbis.VorbisMethod: string;
begin
  if alIsExtensionPresent('AL_EXT_vorbis') then
    Result := 'AL_EXT_vorbis extension' else
  if VorbisFileInited then
    Result := 'vorbisfile library' else
    Result := 'none';
end;

{ TSoundWAV ------------------------------------------------------------ }

constructor TSoundWAV.CreateFromStream(Stream: TStream);
{ Odczytywanie plikow WAVe. Napisane na podstawie wielu zrodel -
  przede wszystkim jednej strony w Internecie
    http://www.technology.niagarac.on.ca/courses/comp630/WavFileFormat.html
  oraz takiego starego wydruku jaki zostal mi po starym.
  Zerkalem tez caly czas na implementacje alutLoadWAVFile aby sie upewnic
  czy wszystko dobrze rozumiem.
}

type
  TID = array[0..3]of char;

  function IdCompare(const id: TID; const s: string): boolean;
  begin
   result := (Length(s) = 4) and (id[0] = s[1]) and (id[1] = s[2])
                             and (id[2] = s[3]) and (id[3] = s[4]);
  end;

  function IdToStr(const id: TID): string;
  begin
   result := SReadableForm(id[0]+id[1]+id[2]+id[3]);
  end;

type
  TWavChunkHeader = record
    ID: TID;
    Len: LongWord; { NIE liczac samego SizeOf(TWavChunkHeader) }
  end;

  { caly plik WAV to jest jeden chunk RIFF }
  TWavRiffChunk = record
    Header: TWavChunkHeader; { Header.rID = 'RIFF' }
    wID: TID; { indicates RIFF type; in this case it must be 'WAVE' }
    { More chunks follow. Format and Data chunks are mandatory and
      Format _must_ be before Data. }
  end;

  { "_Cont" means that this structure does not contain field
    Header: TWavChunkHeader;. However, in a stream, a chunk must always be
    preceeded by appropriate header. Format chunk must have Header with
    ID = 'fmt ' }
  TWavFormatChunk_Cont = record
    FormatTag: Word; { 1 = PCM, but other values are also possible }
    { 1 = mono, 2 = stereo. I'm not sure, theoretically other values
      are probably possible ? }
    Channels: Word;
    SamplesPerSec: LongWord;
    AvgBytesPerSec: LongWord;
    BlockAlign: Word;
    { meaning of FormatSpecific depends on FormatTag value. For 1 (PCM)
      it means BitsPerSample. }
    FormatSpecific: Word;
  end;

var
  Riff: TWavRiffChunk;
  Format: TWavFormatChunk_Cont;
  Header: TWavChunkHeader;
begin
 inherited Create;
 Stream.ReadBuffer(Riff, SizeOf(Riff));
 if not (IdCompare(Riff.Header.ID, 'RIFF') and IdCompare(Riff.wID, 'WAVE')) then
  raise EInvalidWAV.Create('WAV file must start with RIFF....WAVE signature');

 { Workaround for buggy WAV files generated by OpenAL waveout device.
   gstreamer crashes on them, some other programs handle them.
   They contain fmt and data sections OK, but Riff.Header.Len is too large.
   So at the end, we stand at the end of the file but
   Stream.Position < Int64(Riff.Header.Len + SizeOf(TWavChunkHeader))
   says we can read another chunk.
   In general, these are invalid WAV files, but let's handle them... }
 if Riff.Header.Len = Stream.Size then
 begin
   Riff.Header.Len -= SizeOf(TWavChunkHeader);
   DataNonFatalError('Warning: WAV file is invalid ' +
     '(Riff.Header.Len equals Stream.Size, but it should be ' +
     '<= Stream.Size - SizeOf(TWavChunkHeader)). Reading anyway.');
 end;

 while Stream.Position < Int64(Riff.Header.Len + SizeOf(TWavChunkHeader)) do
 begin
  Stream.ReadBuffer(Header, SizeOf(Header));

  if IdCompare(Header.ID, 'fmt ') then
  begin
   Stream.ReadBuffer(Format, SizeOf(Format));
   { interpretuj dane w Format }
   if Format.FormatTag <> 1 then
    raise EInvalidWAV.Create('Loading WAV files not in PCM format not implemented');
   { ustal FDataFormat }
   case Format.Channels of
    1: if Format.FormatSpecific = 8 then
         FDataFormat := AL_FORMAT_MONO8 else
         FDataFormat := AL_FORMAT_MONO16;
    2: if Format.FormatSpecific = 8 then
         FDataFormat := AL_FORMAT_STEREO8 else
         FDataFormat := AL_FORMAT_STEREO16;
    else raise EInvalidWAV.Create('Only WAV files with 1 or 2 channels are allowed');
   end;
   { ustal FFrequency }
   FFrequency := Format.SamplesPerSec;
  end else

  if IdCompare(Header.ID, 'data') then
  begin
   if Data <> nil then
    raise EInvalidWAV.Create('WAV file must not contain mulitple data chunks');
   { ustal FDataSize i FData (i FData^) }
   FDataSize := Header.Len;
   FData := GetMem(DataSize);
   Stream.ReadBuffer(Data^, DataSize);
  end else

  begin
   { skip any unknown chunks }
   { Writeln('Skipping unknown chunk '+IdToStr(Header.ID)); }
   Stream.Seek(Header.Len, soFromCurrent);
  end;

 end;
end;

destructor TSoundWAV.Destroy;
begin
 FreeMemNiling(FData);
 inherited;
end;

function TSoundWAV.Data: Pointer;
begin
  Result := FData;
end;

function TSoundWAV.DataSize: LongWord;
begin
  Result := FDataSize;
end;

function TSoundWAV.DataFormat: TALuint;
begin
  Result := FDataFormat;
end;

function TSoundWAV.Frequency: LongWord;
begin
  Result := FFrequency;
end;

{ global functions ----------------------------------------------------------- }

function ALDataFormatToStr(DataFormat: TALuint): string;
begin
  case DataFormat of
    AL_FORMAT_MONO8: Result := 'mono 8';
    AL_FORMAT_MONO16: Result := 'mono 16';
    AL_FORMAT_STEREO8: Result := 'stereo 8';
    AL_FORMAT_STEREO16: Result := 'stereo 16';
    AL_FORMAT_MP3_EXT: Result := 'mp3';
    AL_FORMAT_VORBIS_EXT: Result := 'ogg vorbis';
    else raise EInternalError.CreateFmt('ALDataFormatToStr unknown parameter: %d',
      [DataFormat]);
  end;
end;

end.
