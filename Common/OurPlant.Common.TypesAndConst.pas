// *****************************************************************************
//
//                       OurPlant OS Architecture
//                             for Delphi
//                                2019
//
// Copyrights 2019 @ Häcker Automation GmbH
// *****************************************************************************
unit OurPlant.Common.TypesAndConst;

interface

{$REGION 'uses'}
uses
  System.SysUtils,
  {$IF CompilerVersion >= 28.0}System.Json,{$ENDIF}
  Data.DBXJSON;
{$ENDREGION}

const
  C_ROOT_NAME = 'root';

  C_LONGNAME_DELIMITER = '/';
  C_LONGNAME_ROOT = 'OP:';
  C_LONGNAME_ONE_LEVEL_UP = '..';

  C_DEFAULT_STRING = '';
  C_DEFAULT_INTEGER = 0;
  C_DEFAULT_FLOAT = 0;
  C_DEFAULT_BOOLEAN = False;

  C_FLOAT_TOLERANZ = 0.0000001;

  C_STRING_TYPE_NAME = 'String';

  // JSON Pair Names
  C_PV_CELL           = 'cell';
  C_PV_LINK           = 'link';
  C_PV_SYSTEM         = 'system';
  C_PV_EMPTY_POS      = 'empty.position';
  C_PV_GUID           = 'guid';
  C_PV_LONG_NAME      = 'long.name';
  C_PV_TYPE_NAME      = 'type.name';
  C_PV_TYPE_GUID      = 'type.guid';
  C_PV_TYPE_CLASS     = 'ERROR in type.class';
  C_PV_VALUE          = 'value';
  C_PV_STRING         = 'string';
  C_PV_SUB_CELL_COUNT = 'sub.cell.count';
  C_PV_CON_CELL_COUNT = 'constructor.cell.count';
  C_PV_SUB_CELL_LIST  = 'sub.cells';

  C_GET_CONTENT_AS_SUB_CELL = True;
  C_GET_NO_CONTENT_AS_SUB_CELL = False;

  C_CONTENT_MAIN_REQUEST = True;
  C_CONTENT_SUBCELL_REQUEST = False;

type


  TCellSaveMode = (NotSaved, SubSaved, SelfSaved);

  TJSONObjectHelper = class helper for TJSONObject
    procedure SetPairValue(const aPairName: string; const aValue : TJSONValue); overload;
    procedure SetPairValue(const aPairName: string; const aValue : string); overload;
    procedure SetPairValue(const aPairName: string; const aValue : TGuid); overload;
    procedure SetPairValue(const aPairName: string; const aValue : Integer); overload;

    function TryGetPairValue(const aPairName: string; out aValue : TJSONValue): Boolean; overload;
    function TryGetPairValue(const aPairName: string; out aValue : TJSONArray): Boolean; overload;
    function TryGetPairValue(const aPairName: string; out aValue : string): Boolean; overload;
    function TryGetPairValue(const aPairName: string; out aValue : Integer): Boolean; overload;
    function TryGetPairValue(const aPairName: string; out aValue : TGUID): Boolean; overload;
  end;

function LongNameSeparateLeft(const aLongName: string; out aRestLongName: string): string;
function LongNameSeparateRight(const aLongName: string; out aRestLongName: string): string;

function JSONStrDecode(const aString: string):string;
function JSONStrEncode(const aString: string):string;

function CompareFloat(const aValue1,aValue2 : Double) : Boolean;

function CompareNames(const aName1, aName2 : string) : Boolean;

implementation

{$REGION 'uses'}
//uses
//  System.TypInfo;
{$ENDREGION}

procedure TJSONObjectHelper.SetPairValue(const aPairName: string; const aValue : TJSONValue);
begin
  AddPair(aPairName, aValue);
end;

procedure TJSONObjectHelper.SetPairValue(const aPairName: string; const aValue : string);
begin
  AddPair(aPairName, TJSONString.Create(JSONStrDecode(aValue)));
end;

procedure TJSONObjectHelper.SetPairValue(const aPairName: string; const aValue : TGuid);
begin
  AddPair(aPairName, TJSONString.Create(aValue.ToString));
end;

procedure TJSONObjectHelper.SetPairValue(const aPairName: string; const aValue : Integer);
begin
  AddPair(aPairName, TJSONNumber.Create(aValue));
end;

function TJSONObjectHelper.TryGetPairValue(const aPairName: string; out aValue : TJSONValue): Boolean;
var
  vPair: TJSONPair;
begin
  vPair:= Get(aPairName);
  Result:= Assigned(vPair);

  if Result then
    aValue:= vPair.JsonValue;
end;

function TJSONObjectHelper.TryGetPairValue(const aPairName: string; out aValue : TJSONArray): Boolean;
var
  vJSONValue : TJSONValue;
begin
  Result:= TryGetPairValue(aPairName,vJSONValue) and (vJSONValue is TJSONArray);

  if Result then
    aValue:= vJsonValue as TJSONArray;
end;

function TJSONObjectHelper.TryGetPairValue(const aPairName: string; out aValue : string): Boolean;
var
  vJSONValue : TJSONValue;
begin
  Result:= TryGetPairValue(aPairName,vJSONValue);

  if Result then
    aValue:= JSONStrEncode(vJsonValue.Value);  // wird im string data cell schon aufgerufen
    //aValue:= vJsonValue.Value;
end;

function TJSONObjectHelper.TryGetPairValue(const aPairName: string; out aValue : Integer): Boolean;
var
  vJSONValue : TJSONValue;
begin
  Result:= TryGetPairValue(aPairName,vJSONValue) and (vJSONValue is TJSONNumber);

  if Result then
    aValue:= (vJsonValue as TJSONNumber).AsInt;
end;


function TJSONObjectHelper.TryGetPairValue(const aPairName: string; out aValue : TGUID): Boolean;
var
  vJSONValue : TJSONValue;
begin
  Result:= TryGetPairValue(aPairName,vJSONValue);

  if Result then
    aValue:= StringToGUID(vJsonValue.Value);
end;

function LongNameSeparateLeft(const aLongName: string; out aRestLongName: string): string;
var
  vCounter        : Integer;
  vDelimiterFound : Boolean;
begin
  vDelimiterFound:= False;
  Result:=          '';
  aRestLongName:=   '';

  if aLongName<>'' then
    for vCounter := 1 to High(aLongName) do
    begin
      if not vDelimiterFound then
      begin
        if aLongName[vCounter] = C_LONGNAME_DELIMITER then
          vDelimiterFound:=true
        else
          Result:= Result + aLongName[vCounter]
      end
      else
        aRestLongName:= aRestLongName + aLongName[vCounter];
    end;
end;


function LongNameSeparateRight(const aLongName: string; out aRestLongName: string): string;
var
  vCounter        : Integer;
  vDelimiterFound : Boolean;
begin
  vDelimiterFound:= False;
  Result:=          '';
  aRestLongName:=   '';

  if aLongName<>'' then
    for vCounter := High(aLongName) downto 1 do
    begin
      if not vDelimiterFound then
      begin
        if aLongName[vCounter] = C_LONGNAME_DELIMITER then
          vDelimiterFound:=true
        else
          Result:= aLongName[vCounter] + Result;
      end
      else
        aRestLongName:= aLongName[vCounter] + aRestLongName;
    end;
end;

function JSONStrDecode(const aString: string): string;
var
  vChar: Char;
  vStr:  string;
begin
  vStr:= aString; // UTF8Decode(aString);
  for vChar in vStr do
  begin
    if (vChar = '\') or (vChar = '"') then
      Result:= Result + '\' + vChar
    else
      Result:= Result + vChar;
  end;
end;

function JSONStrEncode(const aString: string): string;
var
  vChar:   Char;
  vStr:    string;
  vEscape: Boolean;
begin
  vStr:= aString; // UTF8Encode(aString);
  vEscape:= False;
  for vChar in aString do
  begin
    if vEscape then
    begin
      if (vChar = '\') or (vChar = '"') then
        Result:= Result + vChar
      else
        Result:= Result + '\' + vChar;

      vEscape:=False;
    end
    else if vChar = '\' then
      vEscape:=True
    else
      Result:= Result + vChar;
  end;
end;

function CompareFloat(const aValue1,aValue2 : Double) : Boolean;
begin
  Result := Abs(aValue1-aValue2) < C_FLOAT_TOLERANZ;
end;

function CompareNames(const aName1, aName2 : string) : Boolean;
begin
  Result := CompareText(Trim(aName1),Trim(aName2))=0;
end;


end.
