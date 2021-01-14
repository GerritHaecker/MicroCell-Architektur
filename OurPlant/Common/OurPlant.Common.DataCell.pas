// *****************************************************************************
//
//                            OurPlant OS
//                       Micro Cell Architecture
//                             for Delphi
//                            2019 / 2020
//
// Copyright (c) 2019-2020 Gerrit Häcker
// Copyright (c) 2019-2020 Häcker Automation GmbH
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// Authors History:
//    Gerrit Häcker (2019 - 2020)
// *****************************************************************************

{-------------------------------------------------------------------------------
   The Unit is the general part of the micro cell architecture for Delphi.

   It contains:
     * The data skill interfaces
     * The data cell classes that supports and implement the data skill interfaces
-------------------------------------------------------------------------------}

unit OurPlant.Common.DataCell;

interface

{$REGION 'uses'}
uses
  System.Rtti,
  OurPlant.Common.CellObject,
  {$IF CompilerVersion >= 28.0}System.Json,{$ENDIF}
  Data.DBXJSON;
{$ENDREGION}

type
  {$REGION 'Data skill interfaces'}
  {$REGION 'IsiBooleanCell - data skill interface for boolean'}
  /// <summary>
  ///  Data skill interface for an boolean value
  /// </summary>
  IsiBoolean = interface(IsiCellObject)
    ['{03549A73-BBA7-4CD1-83AE-3DDA98E8B4FD}']
    /// <summary>
    ///   Return the boolean value
    /// </summary>
    function  siGetAsBoolean : Boolean;
    /// <summary>
    ///   set the boolean value as integer
    /// </summary>
    procedure siSetAsBoolean(const aValue: Boolean);
    /// <summary>
    ///   Read / write the boolean value
    /// </summary>
    property  siAsBoolean: Boolean read siGetAsBoolean write siSetAsBoolean;
  end;
  {$ENDREGION}

  {$REGION 'IsiString - data skill interface for string'}
  /// <summary>
  ///  Data skill interface for string value
  /// </summary>
  IsiString = interface(IsiCellObject)
    ['{F90A2C86-08BA-40D2-9F35-0BCF771DBAA6}']
  end;
  {$ENDREGION}

  {$REGION 'IsiInteger - data skill interface for integer'}
  /// <summary>
  ///  Data skill interface for an integer value
  /// </summary>
  IsiInteger = interface(IsiCellObject)
    ['{A59E6C7B-2F6C-4E2C-88DF-FC28E7B8FDDC}']
    /// <summary>
    ///   Return the integer value
    /// </summary>
    function  siGetAsInteger : Integer;
    /// <summary>
    ///   set the integer value as integer
    /// </summary>
    procedure siSetAsInteger(const aValue: Integer);
    /// <summary>
    ///   Read / write the integer value
    /// </summary>
    property  siAsInteger: Integer read siGetAsInteger write siSetAsInteger;
  end;
  {$ENDREGION}

  {$REGION 'IsiFloat - data skill interface for float'}
  /// <summary>
  ///  Data skill interface for an float value
  /// </summary>
  IsiFloat = interface(IsiCellObject)
    ['{9E2C9FCC-EB75-43D1-9371-9EE0AAB9D1B0}']
    /// <summary>
    ///   Return the float value as extended
    /// </summary>
    function  siGetAsFloat : Extended;
    /// <summary>
    ///   set the float value from extended
    /// </summary>
    procedure siSetAsFloat(const aValue: Extended);
    /// <summary>
    ///   Read / write the float value as extended
    /// </summary>
    property  siAsFloat: Extended read siGetAsFloat write siSetAsFloat;
  end;
  {$ENDREGION}

  {$REGION 'IsiDateTime - data skill interface for date & time'}
  /// <summary>
  ///  Data skill interface for an Date/Time value
  /// </summary>
  IsiDateTime = interface(IsiCellObject)
  ['{80DEEF03-AE96-4D61-98C6-4A5D052730CB}']
    /// <summary>
    ///   Return the date/time value as TDateTime
    /// </summary>
    function  siGetAsDateTime : TDateTime;
    /// <summary>
    ///   set the date/time value from TDateTime
    /// </summary>
    procedure siSetAsDateTime(const aValue: TDateTime);
    /// <summary>
    ///   Read / write the date/time value as TDateTime
    /// </summary>
    property  siAsDateTime: TDateTime read siGetAsDateTime write siSetAsDateTime;
  end;
  {$ENDREGION}

  {$REGION 'IsiCellClass - data skill interface for cell object class'}
  /// <summary>
  ///   Data skill interface for TcellObject class
  /// </summary>
  IsiCellClass = interface(IsiCellObject)
    ['{1EBD29C6-12BC-40EF-8B1B-E86D673A532B}']
    /// <summary>
    ///   Return the docked cell object class
    /// </summary>
    function siGetAsClass: TCellClass;
    /// <summary>
    ///   Set the docked cell object class
    /// </summary>
    procedure siSetAsClass(const aCellClass: TCellClass);
    /// <summary>
    ///   read / write the cell object class
    /// </summary>
    property siAsClass: TCellClass read siGetAsClass write siSetAsClass;
  end;
  {$ENDREGION}

  {$REGION 'IsiCellReference - data skill interface for IsiCellobject reference'}
  /// <summary>
  ///   Data skill interface for a IsicellObject reference as link to another cell
  /// </summary>
  IsiCellReference = interface(IsiCellObject)
    ['{ABF5565D-A7B2-45B3-B394-D022797EBD08}']
    /// <summary>
    ///   Get the docked cell as IsiCellObject interface reference.
    /// </summary>
    function siGetAsCell: IsiCellObject;
    /// <summary>
    ///   Set the docked cell from IsiCellObject interface reference.
    /// </summary>
    procedure siSetAsCell(const aCellRef: IsiCellObject);
    /// <summary>
    ///   Read / write the docked cell as IsiCellObject interface reference.
    property siAsCell: IsiCellObject read siGetAsCell write siSetAsCell;
  end;
  {$ENDREGION}


  {$ENDREGION}

  {$REGION 'Data cells - implementations of data skill interfaces'}
  {$REGION 'TcoBoolean - Boolean data cell object'}
  /// <summary>
  ///   <para>
  ///     Data cell object to Data skill interface IsiIntegerV1
  ///   </para>
  ///   <para>
  ///     Implementation of Data skill interface for an integer value with
  ///     ranges and default in Release V1.
  ///   </para>
  /// </summary>
  [RegisterCellType('Boolean','{9FF8DA22-9C7E-46DB-B782-1D04FC5BFD26}')]
  TcoBoolean = class(TCellObject, IsiBoolean)
  strict protected
    /// <summary>
    ///   <para>
    ///     return the integer value as string
    ///   </para>
    /// </summary>
    function  siGetAsString : string; override;
    /// <summary>
    ///   set the integer value as string
    /// </summary>
    procedure siSetAsString(const aValue:string); override;
    /// <summary>
    ///   Get the Value of cell object as JSON Value. The instance of Result is
    ///   a TJSONTrue or TJSONFalse. <br />
    /// </summary>
    function siGetAsJSON : TJSONValue; override;
    /// <summary>
    ///   Set the Value of cell object as JSON Value. The instance of parameter
    ///   should a TJSONTrue or TJSONFalse.
    /// </summary>
    procedure siSetAsJSON(aJSONValue : TJSONValue); override;

    /// <summary>
    ///   Return the boolean value
    /// </summary>
    function  siGetAsBoolean : Boolean; virtual;
    /// <summary>
    ///   set the boolean value as boolean
    /// </summary>
    procedure siSetAsBoolean(const aValue: Boolean); virtual;
    /// <summary>
    ///   Read / write the boolean value
    /// </summary>
    property  siAsBoolean: Boolean read siGetAsBoolean write siSetAsBoolean;
  end;
  {$ENDREGION}

  {$REGION 'TcoInteger - Integer data cell object'}
  /// <summary>
  ///   <para>
  ///     Data cell object to Data skill interface IsiIntegerV1
  ///   </para>
  ///   <para>
  ///     Implementation of Data skill interface for an integer value with
  ///     ranges and default in Release V1.
  ///   </para>
  /// </summary>
  [RegisterCellType('Integer','{5F30064A-2628-40EF-BFC2-F220A4754D49}')]
  TcoInteger = class(TCellObject, IsiInteger)
  strict protected
    // Content as String read / write
    /// <summary>
    ///   <para>
    ///     return the integer value as string
    ///   </para>
    /// </summary>
    function  siGetAsString : string; override;
    /// <summary>
    ///   set the integer value as string
    /// </summary>
    procedure siSetAsString(const aValue:string); override;

    // content as JSON Value
    /// <summary>
    ///   Get the Value of cell object as JSON Value. The instance of Result is
    ///   a TJSONNumber. <br />
    /// </summary>
    function siGetAsJSON : TJSONValue; override;
    /// <summary>
    ///   Set the Value of cell object as JSON Value. The instance of parameter
    ///   should a TJSONNumber.
    /// </summary>
    procedure siSetAsJSON(aJSONValue : TJSONValue); override;

    // Content as Integer read / write
    /// <summary>
    ///   Return the integer value
    /// </summary>
    function  siGetAsInteger : Integer; virtual;
    /// <summary>
    ///   set the integer value as integer
    /// </summary>
    procedure siSetAsInteger(const aValue: Integer); virtual;
    /// <summary>
    ///   Read / write the integer value
    /// </summary>
    property  siAsInteger: Integer read siGetAsInteger write siSetAsInteger;
  end;
  {$ENDREGION}

  {$REGION 'TcoFlaot - Float data cell object'}
  /// <summary>
  ///   <para>
  ///     Data cell object to Data skill interface IsiFloat
  ///   </para>
  ///   <para>
  ///     Implementation of Data skill interface for an float value.
  ///   </para>
  /// </summary>
  [RegisterCellType('Float','{72F21CFC-6B34-4ACE-B0DB-4AB388FEC627}')]
  TcoFloat = class(TCellObject, IsiFloat)
  strict protected
    // Content as String read / write
    /// <summary>
    ///   <para>
    ///     get the float value as string
    ///   </para>
    /// </summary>
    function  siGetAsString : string; override;
    /// <summary>
    ///   set the float value as string
    /// </summary>
    procedure siSetAsString(const aValue:string); override;

    // content as JSON Value
    /// <summary>
    ///   Get the Value of cell object as JSON Value. The instance of Result is
    ///   a TJSONNumber. <br />
    /// </summary>
    function siGetAsJSON : TJSONValue; override;
    /// <summary>
    ///   Set the Value of cell object as JSON Value. The instance of parameter
    ///   should a TJSONNumber.
    /// </summary>
    procedure siSetAsJSON(aJSONValue : TJSONValue); override;

    // Content as Float read / write
    /// <summary>
    ///   Return the float value
    /// </summary>
    function  siGetAsFloat : Extended; virtual;
    /// <summary>
    ///   set the flaot value as integer
    /// </summary>
    procedure siSetAsFloat(const aValue: Extended); virtual;
    /// <summary>
    ///   Read / write the float value
    /// </summary>
    property  siAsFloat: Extended read siGetAsFloat write siSetAsFloat;
  end;
  {$ENDREGION}

  {$REGION 'TcoString - String data cell object'}
  /// <summary>
  ///   <para>
  ///     String data cell object to string skill interface IsiStringV1
  ///   </para>
  ///   <para>
  ///     Implementation of Data skill interface for an string
  ///   </para>
  /// </summary>
  [RegisterCellType('String','{21EEC5E5-9A52-497A-82AA-0C81314E6B44}')]
  TcoString = class(TCellObject, IsiString)
  strict protected
    // Content as String read / write
    /// <summary>
    ///   <para>
    ///     return the cell value as string
    ///   </para>
    /// </summary>
    function  siGetAsString : string; override;
    /// <summary>
    ///   set the cell value from string
    /// </summary>
    procedure siSetAsString(const aValue:string); override;
    // content as JSON Value
    /// <summary>
    ///   Get the Value of cell object as JSON Value. The instance of Result is
    ///   a TJSONString. <br />
    /// </summary>
    function siGetAsJSON : TJSONValue; override;
    /// <summary>
    ///   Set the Value of cell object as JSON Value. The instance of parameter
    ///   should a TJSONString.
    /// </summary>
    procedure siSetAsJSON(aJSONValue : TJSONValue); override;
  end;
  {$ENDREGION}

  {$REGION 'TcoDateTime - Date/Time data cell object'}
  /// <summary>
  ///   Date/Time data cell object to string skill interface IsiDateTime
  /// </summary>
  [RegisterCellType('Date and time','{482AD7BE-2306-483C-9EE9-DECDF4C37CB3}')]
  TcoDateTime = class(TcoString, IsiDateTime)
  strict protected
    // override implementation of IsiCellObject
    /// <summary>
    ///   <para>
    ///     return the cell value as string
    ///   </para>
    /// </summary>
    function  siGetAsString : string; override;
    /// <summary>
    ///   set the cell value from string
    /// </summary>
    procedure siSetAsString(const aValue:string); override;

    // implementation of IsiDateTime
    /// <summary>
    ///   Return the date/time value as TDateTime
    /// </summary>
    function  siGetAsDateTime : TDateTime; virtual;
    /// <summary>
    ///   set the date/time value from TDateTime
    /// </summary>
    procedure siSetAsDateTime(const aValue: TDateTime); virtual;
    /// <summary>
    ///   Read / write the date/time value as TDateTime
    /// </summary>
    property  siAsDateTime: TDateTime read siGetAsDateTime write siSetAsDateTime;
  end;
  {$ENDREGION}

  {$REGION 'TcoTime - Time data cell object'}
  /// <summary>
  ///   Date data cell object to string skill interface IsiDateTime
  /// </summary>
  [RegisterCellType('Time','{40A98A48-A265-47A9-B6CB-53D6CE334B50}')]
  TcoTime = class(TcoDateTime)
  strict protected
    // override implementation of IsiCellObject
    /// <summary>
    ///   <para>
    ///     return the cell value as time string
    ///   </para>
    /// </summary>
    function  siGetAsString : string; override;
    /// <summary>
    ///   set the cell value from time string
    /// </summary>
    procedure siSetAsString(const aValue:string); override;
  end;
  {$ENDREGION}

  {$REGION 'TcoDate - Date data cell object'}
  /// <summary>
  ///   Date data cell object to string skill interface IsiDateTime
  /// </summary>
  [RegisterCellType('Date','{DBD48A80-53C1-498C-930F-6640D72884C4}')]
  TcoDate = class(TcoDateTime)
  strict protected
    // override implementation of IsiCellObject
    /// <summary>
    ///   <para>
    ///     return the cell value as date string
    ///   </para>
    /// </summary>
    function  siGetAsString : string; override;
    /// <summary>
    ///   set the cell value from date string
    /// </summary>
    procedure siSetAsString(const aValue:string); override;
  end;
  {$ENDREGION}

  {$REGION 'TcoCellClass - class of cell object data cell object'}
  /// <summary>
  ///   <para>
  ///     Data cell object to Data skill interface IsiClass
  ///   </para>
  ///   <para>
  ///     Implementation of Data skill interface for an cell object class
  ///   </para>
  /// </summary>
  [RegisterCellType('Cell class', '{E9EC283A-7BCA-432C-9ABA-B0E85046D4B0}' )]
  TcoCellClass = class(TcoString, IsiCellClass)
  strict protected
    /// <summary>
    ///   Get the cell class as string
    /// </summary>
    function  siGetAsString : string; override;
    /// <summary>
    ///   Set the cell calss from string
    /// </summary>
    procedure siSetAsString(const aValue:string); override;

    /// <summary>
    ///   Return the docked cell object class
    /// </summary>
    function siGetAsClass: TCellClass; virtual;
    /// <summary>
    ///   Set the docked cell object class
    /// </summary>
    procedure siSetAsClass(const aCellClass: TCellClass); virtual;
    /// <summary>
    ///   read / write the cell object class
    /// </summary>
    property siAsClass: TCellClass read siGetAsClass write siSetAsClass;
  end;
  {$ENDREGION}

  {$REGION 'TcoCellReference - IsiCellObject reference cell object'}
  /// <summary>
  ///   IsiCellObject reference cell object
  /// </summary>
  [RegisterCellType('Cell reference', '{7E64D16F-7942-4FB2-BA39-BFA2B59CD68D}' )]
  TcoCellReference = class(TcoString, IsiCellReference)
  public
    /// <summary>
    ///  Get the docked cell reference as string (siLongName)
    /// </summary>
    function  siGetAsString : string; override;
    /// <summary>
    ///  Set the docked cell calss from string (siLongName)
    ///  First set only as string and convert later at siGetAsCell request to
    ///  the docked cell reference as IsiCellObject in siValue
    /// </summary>
    procedure siSetAsString(const aValue:string); override;

    /// <summary>
    ///  Get the docked cell reference as IsiCellObject when cell ref. exist,
    ///  otherwise get nil
    /// </summary>
    function siGetAsCell: IsiCellObject; virtual;
    /// <summary>
    ///   Set the cell reference to be docked
    /// </summary>
    procedure siSetAsCell(const aCellRef: IsiCellObject); virtual;
    /// <summary>
    ///   read / write the cell reference as IsiCellObject
    /// </summary>
    property siAsCell: IsiCellObject read siGetAsCell write siSetAsCell;
  end;
  {$ENDREGION}


  {$ENDREGION}

implementation

{$REGION 'uses'}
uses
  OurPlant.Common.DiscoveryManager,
  OurPlant.Common.TypesAndConst,
  OurPlant.Common.CellTypeRegister,
  System.TypInfo,
  System.SysUtils;
{$ENDREGION}


{$REGION 'TcoBoolean implementation'}
function TcoBoolean.siGetAsString : string;
begin
  {if siAsBoolean then
    Result:='JA'            // Allgemeine Begriff Celle ?!?
  else
    Result:='NEIN'}
  Result:=BoolToStr(siAsBoolean,true);
end;

procedure TcoBoolean.siSetAsString(const aValue:string);
begin
  siAsBoolean:=StrToBoolDef(aValue,C_DEFAULT_BOOLEAN);
end;

function TcoBoolean.siGetAsJSON : TJSONValue;
begin
  if siAsBoolean then
    Result:= TJSONTrue.Create
  else
    Result:= TJSONFalse.Create
end;

procedure TcoBoolean.siSetAsJSON(aJSONValue : TJSONValue);
begin
  siAsBoolean:=aJSONValue is TJSONTrue
end;

function  TcoBoolean.siGetAsBoolean : Boolean;
begin
  if not siValue.TryAsType<Boolean>(Result) then
    Result := C_DEFAULT_BOOLEAN;
end;

procedure TcoBoolean.siSetAsBoolean(const aValue: Boolean);
begin
  siValue:= TValue.From<Boolean>(aValue);
end;
{$ENDREGION}

{$REGION 'TcoInteger implementation'}
function  TcoInteger.siGetAsString : string;
begin
  Result:= IntToStr(siAsInteger);
end;

procedure TcoInteger.siSetAsString(const aValue:string);
begin
  siAsInteger:=StrToIntDef(aValue,C_DEFAULT_INTEGER);
end;

function TcoInteger.siGetAsJSON : TJSONValue;
begin
  Result:=TJSONNumber.Create(siAsInteger)
end;

procedure TcoInteger.siSetAsJSON(aJSONValue : TJSONValue);
begin
  if aJSONValue is TJSONNumber then
    siAsInteger := (aJSONValue as TJSONNumber).AsInt
  else
    siAsInteger := C_DEFAULT_INTEGER;
end;

function TcoInteger.siGetAsInteger : Integer;
begin
  if not siValue.TryAsType<Integer>(Result) then
    Result:=C_DEFAULT_INTEGER;
end;

procedure TcoInteger.siSetAsInteger(const aValue: Integer);
begin
  siValue:=TValue.From<Integer>(aValue);
end;

{$ENDREGION}

{$REGION 'TcoFloat implementation'}
function TcoFloat.siGetAsString : string;
begin
  Result := FormatFloat(C_FLOAT_STR_FORMAT,siAsFloat);
end;

procedure TcoFloat.siSetAsString(const aValue:string);
begin
  siAsFloat:=StrToFloatDef(aValue,C_DEFAULT_FLOAT);
end;

function TcoFloat.siGetAsJSON : TJSONValue;
begin
  Result := TJSONNumber.Create(siAsFloat)
end;

procedure TcoFloat.siSetAsJSON(aJSONValue : TJSONValue);
begin
  if aJSONValue is TJSONNumber then
    siAsFloat := (aJSONValue as TJSONNumber).AsDouble
  else
    siAsFloat := C_DEFAULT_FLOAT;
end;

function TcoFloat.siGetAsFloat : Extended;
begin
  if not siValue.TryAsType<Extended>(Result) then
    Result := C_DEFAULT_FLOAT;
end;

procedure TcoFloat.siSetAsFloat(const aValue: Extended);
begin
  siValue := TValue.From<Extended>(aValue);
end;

{$ENDREGION}

{$REGION 'TcoString implementation'}
function TcoString.siGetAsString : string;
begin
  if not siValue.TryAsType<string>(Result) then
    Result := C_DEFAULT_STRING;
end;

procedure TcoString.siSetAsString(const aValue:string);
begin
  siValue := TValue.From<string>(aValue);
end;

function TcoString.siGetAsJSON : TJSONValue;
begin
  Result:=TJSONString.Create(JSONStrDecode(siAsString));
end;

procedure TcoString.siSetAsJSON(aJSONValue : TJSONValue);
begin
  if aJSONValue is TJSONString then
    siAsString := JSONStrEncode(aJSONValue.Value);
end;
{$ENDREGION}

{$REGION 'TcoDateTime implementation'}
function TcoDateTime.siGetAsString : string;
begin
  Result := DateTimeToStr(siAsDateTime);
end;

procedure TcoDateTime.siSetAsString(const aValue:string);
begin
  siAsDateTime := StrToDateTime(aValue);
end;

function TcoDateTime.siGetAsDateTime : TDateTime;
begin
  if not siValue.TryAsType<TDateTime>(Result) then
    Result := Now;
end;

procedure TcoDateTime.siSetAsDateTime(const aValue: TDateTime);
begin
  siValue := TValue.From<TDateTime>(aValue);
end;
{$ENDREGION}

{$REGION 'TcoDate implementation'}
function TcoDate.siGetAsString : string;
begin
  Result := DateToStr(siAsDateTime);
end;

procedure TcoDate.siSetAsString(const aValue:string);
begin
  siAsDateTime := StrToDate(aValue);
end;
{$ENDREGION}

{$REGION 'TcoTime implementation'}
function TcoTime.siGetAsString : string;
begin
  Result := TimeToStr(siAsDateTime);
end;

procedure TcoTime.siSetAsString(const aValue:string);
begin
  siAsDateTime := StrToTime(aValue);
end;
{$ENDREGION}

{$REGION 'TcoCellClass implemenation'}
function TcoCellClass.siGetAsString : string;
begin
  if siValue.IsType<TCellClass> then
    Result := siAsClass.ClassName
  else
    Result := '[EMPTY/leer]';
end;

procedure TcoCellClass.siSetAsString(const aValue : string);
var
  vTypeList:  TArray<TRttiType>;
  vCounter:   Integer;
  vType : TRttiType;
  vClass : TClass;
begin
  // siSetAsString sucht nicht im Register selbst, sondern sucht im gesamten
  // RTTI context und setzt somit auch unregistrierte cell classes
  // ALTERNATIVE: suche nur in den TypeRegister (nur registrierte)
  vTypeList := RootSkill<IsiRTTI>.siRTTI.GetTypes;
  for vCounter := 0 to High(vTypeList) do
  begin
    vType:= vTypeList[vCounter];

    if (vType.TypeKind = tkClass) and CompareNames(vType.Name, aValue) then
    begin
      vClass:=System.TypInfo.GetTypeData(vType.Handle)^.ClassType;

      if vClass.InheritsFrom(TCellObject) then
        siAsClass := TCellClass(vClass);

      Break;
    end;
  end;
end;

function TcoCellClass.siGetAsClass: TCellClass;
begin
  if siValue.IsType<TCellClass> then
    Result := siValue.AsType<TCellClass>
  else
    Result := nil;
end;

procedure TcoCellClass.siSetAsClass(const aCellClass: TCellClass);
begin
  siValue := TValue.From<TCellClass>(aCellClass);
end;

{$ENDREGION}

{$REGION 'TcoCellReference implementation'}
function  TcoCellReference.siGetAsString : string;
var
  vCell : IsiCellObject;
begin
  if siValue.TryAsType<IsiCellObject>(vCell) and Assigned(vCell) then
    Result := vCell.siLongName
  else if siValue.IsType<string> then
    Result := siValue.AsType<string>
  else
    Result := C_DEFAULT_STRING;
end;

procedure TcoCellReference.siSetAsString(const aValue:string);
begin
  siValue := TValue.From<string>(aValue);
end;

function TcoCellReference.siGetAsCell: IsiCellObject;
var
  vStr : string;
begin
  if not siValue.TryAsType<IsiCellObject>(Result) then
  begin
    if siValue.TryAsType<string>(vStr) and not vStr.IsEmpty then
    begin
      result := siFindCell(vStr);
    end
    else
      Result := nil;
  end;
end;

procedure TcoCellReference.siSetAsCell(const aCellRef: IsiCellObject);
begin
  siValue := TValue.From<IsiCellObject>(aCellRef);
end;


{$ENDREGION}

initialization
  TcoBoolean.RegisterExplicit;
  TcoInteger.RegisterExplicit;
  TcoFloat.RegisterExplicit;
  TcoString.RegisterExplicit;
  TcoDateTime.RegisterExplicit;
  TcoTime.RegisterExplicit;
  TcoDate.RegisterExplicit;
  TcoCellClass.RegisterExplicit;
  TcoCellReference.RegisterExplicit;
end.
