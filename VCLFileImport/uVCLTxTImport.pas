﻿unit uVCLTxTImport;

interface
Uses
  System.IOUtils,WinApi.Windows, System.Masks,System.Types,System.SysUtils, Vcl.StdCtrls, Vcl.Controls,Vcl.Dialogs,
  Classes,vcl.Graphics;
type

  
  TVCLTextFileImporter = class(TComponent)
  private
    FFormat:TFormatSettings;
    FFileStrings:TStringList;
    FFileName: string;
    FTmpRow:String;


    FidxRow, FidxCol, fStartRow, FStarCol:Integer;
    FSeparator: String;
    FStartCol: Integer;
 
    FThousandSeparator: char;
    FDecimalSeparator: char;


    procedure SetFileName(const Value: string);


    procedure doOpen;
    procedure doClose;

    function GetRowsCount: Integer;
    procedure SetSeparator(const Value: String);

    procedure SetStartRow(const Value: Integer);


    function GetNextFieldValue:String;
    procedure SetDecimalSeparator(const Value: char);

    procedure SetThousandSeparator(const Value: char);

    property FormatSettings:TFormatSettings read FFormat write FFormat;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetNextRow:Boolean;
    function Eof:Boolean;
    function NextInteger:Integer;
    function NextDate:TDate;
    function NextDateTime:TDateTime;
    function NextString:String;
    function NextCurrency:Currency;
    function NextFloat:Double;

    procedure FirstRow;
    procedure FirstCol;
    procedure LastCol;

    procedure Clear;
    procedure First;
    procedure Last;
  published
    property FileName:string read FFileName write SetFileName;
    property RowsCount:Integer read GetRowsCount;

    property IdxRow:Integer read FidxRow;
    property IdxCol:Integer read FidxCol;

    property Separator:String read FSeparator write SetSeparator;
    property StartRow:Integer read FStartRow write SetStartRow default 1;

    property DecimalSeparator:char read FDecimalSeparator write SetDecimalSeparator;
    property ThousandSeparator:char read FThousandSeparator write SetThousandSeparator;



  end;

  procedure Register;
implementation


procedure TVCLTextFileImporter.Clear;
begin

  FFileStrings.Clear;
  First;
end;

constructor TVCLTextFileImporter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FidxRow := 0;
  FidxCol := 1;

  fStartRow := 0;
  FStarCol  := 1;

  FSeparator := ';';

  FileName := '';

  FFileStrings := TStringList.Create;

  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT,FFormat);

  FDecimalSeparator   := FFormat.DecimalSeparator;
  FThousandSeparator  := FFormat.ThousandSeparator;

 end;


destructor TVCLTextFileImporter.Destroy;
begin
  doClose;
  inherited Destroy;
end;

procedure TVCLTextFileImporter.doClose;
begin
  FFileStrings.Free;
end;


procedure TVCLTextFileImporter.doOpen;
begin
  FFileStrings.Clear;
  FFileStrings.LoadFromFile(FileName);
end;


function TVCLTextFileImporter.Eof: Boolean;
begin
  Result := ( FidxRow >= FFileStrings.Count );
end;

procedure TVCLTextFileImporter.First;
begin
  FidxRow := fStartRow;
end;

procedure TVCLTextFileImporter.FirstRow;
begin
  FidxRow := 0;
end;

procedure TVCLTextFileImporter.FirstCol;
begin
  FidxCol := 1;
end;

function TVCLTextFileImporter.GetNextFieldValue: String;
var
  vEofLine:Boolean;
  iLenRow:Integer;
begin
  Result := '';
  iLenRow :=Length(FTmpRow);
  if ( iLenRow > 0 ) then
    begin
      // Testa se é o fim da linha/
      if FTmpRow[FidxCol] = fSeparator then
        Inc(FidxCol,1);
      //vEofLine := FidxCol >= Length(FTmpRow) ;
      While ((FTmpRow[FIdxCol]<>FSeparator) and (not (FidxCol >=iLenRow))) do
        begin
          Result := Result + FTmpRow[FIdxCol];
          Inc(FIdxCol,1);
        end;
  end;
end;

function TVCLTextFileImporter.GetNextRow: Boolean;
begin
  (* Importante: *)
  (* Quando a nova linha é chamada, é necessário reinicialiar as variáveis *)


  Result :=  not Eof;

  if Result  then
    begin
      FidxCol := 1;
      FTmpRow := FFileStrings.Strings[FidxRow];
      Inc(FidxRow);
    end;
end;

function TVCLTextFileImporter.GetRowsCount: Integer;
begin
  Result := FFileStrings.Count;
end;

procedure TVCLTextFileImporter.Last;
begin
  FidxRow := FFileStrings.Count {(-1)};
end;

procedure TVCLTextFileImporter.LastCol;
begin
  FidxCol := Length(FTmpRow) -1;

end;

function TVCLTextFileImporter.NextCurrency: Currency;
var
  s:string;


begin
  s := GetNextFieldValue;
  {Problema do ponto vs vírgula decimal vs milhar}

  Result := StrToCurr(s,FFormat);

end;

function TVCLTextFileImporter.NextDate: TDate;
var
  s:string;
begin
  s := GetNextFieldValue;
  Result :=StrToDate(s);
end;

function TVCLTextFileImporter.NextDateTime: TDateTime;
var
  s : string;
begin
  s := GetNextFieldValue;
  Result := StrToDateTime(s,FFormat);
end;

function TVCLTextFileImporter.NextFloat: Double;
var
  s: string;
begin
  s := GetNextFieldValue;
  Result :=  StrToFloat(s,FFormat);
end;

function TVCLTextFileImporter.NextInteger: Integer;
var
  s:string;
begin
  s := GetNextFieldValue;
  Result := StrToInt(S);
end;

function TVCLTextFileImporter.NextString: String;
begin
  Result := GetNextFieldValue;
end;


procedure TVCLTextFileImporter.SetDecimalSeparator(const Value: char);
begin
  FDecimalSeparator := Value;
  FFormat.DecimalSeparator := FDecimalSeparator;
end;

procedure TVCLTextFileImporter.SetFileName(const Value: string);
begin

  if ('' <> Trim(Value)) then
    begin
      FFileName :=  Trim(Value);
      doOpen;
    end;
end;


procedure TVCLTextFileImporter.SetSeparator(const Value: String);
begin
  FSeparator := Value;
end;



procedure TVCLTextFileImporter.SetStartRow(const Value: Integer);
begin
  FStartRow := Value;
end;

procedure TVCLTextFileImporter.SetThousandSeparator(const Value: char);
begin
  FThousandSeparator := Value;
  FFormat.ThousandSeparator := value;
end;

procedure Register;
begin
  RegisterComponents('VCL Utils',[TVCLTextFileImporter]);
end;


{ TMFSTextFileImporterFormat }



end.
