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
The Unit is part of migration fro OurPlant 2019 to the micro cell architecture.

It contains:

  - ImiRGBI and TmoRGBI the migration of TRGBI record for light colors and values

-------------------------------------------------------------------------------}

unit OurPlant.Migration.Common.SysTypes;

interface

{$REGION 'uses'}
uses
  libraries.SysTypes,
  system.Types;
{$ENDREGION}

type
  {$REGION 'ImiXYZABC - Migration interface to Txyzabc record'}
  {-----------------------------------------------------------------------------
  ImiXYZABC migriert den Record Txyzabc in die MicroCell Welt. Das Interface löst
  die globalen Variablen in der alten Welt ab und präsentiert den Zugriff als
  entsprechndes Interface. Um auf das alte Txyzabc zugreifen zu können bietet das
  Interface eine XYZABC property mit Getter & Setter. Der TXYZABC Record enthält
  die 6 Koordninaten Werte und bietet eine Reihe von Koordinatentransformationen an.
  -----------------------------------------------------------------------------}
  /// <summary>
  ///   Migrates the record Txyzabc to the MicroCell world. The interface
  ///   replaces the global variables in the old world and presents the access
  ///   as a corresponding interface. To access the old Txyzabc, the interface
  ///   offers an XYZABC property with Getter &amp; Setter. The TXYZABC Record
  ///   contains the 6 coordinate values and provides a series of coordinate
  ///   transformations.
  /// </summary>
  ImiXYZABC = interface(IInterface)
    ['{41449F72-D087-4487-885A-45C0F8831F59}']
    /// <summary>
    ///   Get the X value of coordinate
    /// </summary>
    function GetX : Extended;
    /// <summary>
    ///   Set the X value of coordinate
    /// </summary>
    procedure SetX (const aValue : Extended);
    /// <summary>
    ///   Read / write the X value of coordinate
    /// </summary>
    property X : Extended read GetX write SetX;

    /// <summary>
    ///   Get the Y value of coordinate
    /// </summary>
    function GetY : Extended;
    /// <summary>
    ///   Set the Y value of coordinate
    /// </summary>
    procedure SetY (const aValue : Extended);
    /// <summary>
    ///   Read / write the Y value of coordinate
    /// </summary>
    property Y : Extended read GetY write SetY;

    /// <summary>
    ///   Get the Z value of coordinate
    /// </summary>
    function GetZ : Extended;
    /// <summary>
    ///   Set the Z value of coordinate
    /// </summary>
    procedure SetZ (const aValue : Extended);
    /// <summary>
    ///   Read / write the Z value of coordinate
    /// </summary>
    property Z : Extended read GetZ write SetZ;

    /// <summary>
    ///   Get the A value of coordinate
    /// </summary>
    function GetA : Extended;
    /// <summary>
    ///   Set the A value of coordinate
    /// </summary>
    procedure SetA (const aValue : Extended);
    /// <summary>
    ///   Read / write the A value of coordinate
    /// </summary>
    property A : Extended read GetA write SetA;

    /// <summary>
    ///   Get the B value of coordinate
    /// </summary>
    function GetB : Extended;
    /// <summary>
    ///   Set the B value of coordinate
    /// </summary>
    procedure SetB (const aValue : Extended);
    /// <summary>
    ///   Read / write the B value of coordinate
    /// </summary>
    property B : Extended read GetB write SetB;

    /// <summary>
    ///   Get the C value of coordinate
    /// </summary>
    function GetC : Extended;
    /// <summary>
    ///   Set the C value of coordinate
    /// </summary>
    procedure SetC (const aValue : Extended);
    /// <summary>
    ///   Read / write the C value of coordinate
    /// </summary>
    property C : Extended read GetC write SetC;

    /// <summary>
    ///   Get the old world record XYZABC of coordinate set
    /// </summary>
    function GetXYZABC : Txyzabc;
    /// <summary>
    ///   Set the old world record XYZABC of coordinate set
    /// </summary>
    procedure SetXYZABC (const aValue : Txyzabc);
    /// <summary>
    ///   Read / write the old world record XYZABC of coordinate set
    /// </summary>
    property XYZABC : Txyzabc read GetXYZABC write SetXYZABC;

    /// <summary>
    ///   Set the coordinate set to default (0 0 0 0 0 0)
    /// </summary>
    procedure SetDefaultValue;
    /// <summary>
    ///   check the coordinate set is zero
    /// </summary>
    function IsZero: Boolean;

    /// <summary>
    ///   Get the negative of the coordinate set
    /// </summary>
    function Negativ: Txyzabc;
    /// <summary>
    ///   Get the Txyzabc record only with x,y,z values (the rest is zero)
    /// </summary>
    function GetXyzOnly: Txyzabc;
    /// <summary>
    ///   Get the Txyzabc record only with a,b,c values (the rest is zero)
    /// </summary>
    function GetAbcOnly: Txyzabc;
    /// <summary>
    ///   Get the Txyzabc record only with a,b,c,a values (the rest is zero)
    /// </summary>
    function GetXyzaOnly: Txyzabc;
    /// <summary>
    ///   Get the coordinate set as Txyzabc with inverted y value
    /// </summary>
    function InvertY: Txyzabc;
    /// <summary>
    ///   get the coordinate set as Txyzabc with added z value
    /// </summary>
    function AddZ(const AZValue: Extended): Txyzabc;
    /// <summary>
    ///   Rotate the coordinate set around zero with setted angle of A
    /// </summary>
    function RotateAAxis(const AAngle: Extended): Txyzabc;
    /// <summary>
    ///   Get the vector length of x,y,z
    /// </summary>
    function VectorLength: Extended;
    /// <summary>
    ///   Get the vector length of x,y
    /// </summary>
    function XYvectorLength: Extended;
    /// <summary>
    ///   Get the angle of x and y
    /// </summary>
    function GetXYAngle(): Extended;
    /// <summary>
    ///   Get the coordinate set as Txyzabc record with absolute value (even
    ///   positive)
    /// </summary>
    function AbsoluteValue: Txyzabc;

    /// <summary>
    ///   Get the coordinate set as string
    /// </summary>
    function ToString: string;
    /// <summary>
    ///   Set the coordinate set from string
    /// </summary>
    procedure FromString(const AString: string);

    /// <summary>
    ///   get the coordinate set as TPointF record (2 dimensional xy coordinate)
    /// </summary>
    function ToFloatPoint: TPointF;
  end;
  {$ENDREGION}

  {$REGION 'TmoXYZABC - Migration object to deliver a XYZABC interface refer to record'}
  {-----------------------------------------------------------------------------
  TmoXYZABC liefert das Migrations-Interface ImiXYZABC zur Integration in der alten
  Welt. Dabei dockt sich das Objekt an ein bestehenden Txyzabc Record an oder
  greift alternativ auf einen eigenen XYZABC Record zu.
  -----------------------------------------------------------------------------}
  /// <summary>
  ///   Provides the ImiXYZABC migration interface for integration in the old
  ///   World. The object docks to an existing Txyzabc record or alternatively
  ///   accesses its own XYZABC record.
  /// </summary>
  TmoXYZABC = class(TInterfacedObject, ImiXYZABC)
  strict protected
    /// <summary>
    ///   contains the pointer to the Txyzabc record (extern or internal)
    /// </summary>
    fpXYZABC : Pxyzabc;
    /// <summary>
    ///   contains the alternative internal XYZABC record
    /// </summary>
    fXYZABC  : Txyzabc;
  public
    /// <summary>
    ///   Create the migration object of XYZABC in use of the internal record
    ///   Txyzabc.
    /// </summary>
    constructor create; overload;
    /// <summary>
    ///   Create the migration object of XYZABC in use of the original XYZABC
    ///   record as Pointer.
    /// </summary>
    constructor create(aPointer : Pxyzabc); overload;

    /// <summary>
    ///   check after construction the assigning of the XYZABC record pointer
    /// </summary>
    procedure AfterConstruction; override;
    /// <summary>
    ///   Before destruction only to check the destroying of object.
    /// </summary>
    procedure BeforeDestruction; override;

    /// <summary>
    ///   Get the X value of coordinate
    /// </summary>
    function GetX : Extended;
    /// <summary>
    ///   Set the X value of coordinate
    /// </summary>
    procedure SetX (const aValue : Extended);
    /// <summary>
    ///   Read / write the X value of coordinate
    /// </summary>
    property X : Extended read GetX write SetX;

    /// <summary>
    ///   Get the Y value of coordinate
    /// </summary>
    function GetY : Extended;
    /// <summary>
    ///   Set the Y value of coordinate
    /// </summary>
    procedure SetY (const aValue : Extended);
    /// <summary>
    ///   Read / write the Y value of coordinate
    /// </summary>
    property Y : Extended read GetY write SetY;

    /// <summary>
    ///   Get the Z value of coordinate
    /// </summary>
    function GetZ : Extended;
    /// <summary>
    ///   Set the Z value of coordinate
    /// </summary>
    procedure SetZ (const aValue : Extended);
    /// <summary>
    ///   Read / write the Z value of coordinate
    /// </summary>
    property Z : Extended read GetZ write SetZ;

    /// <summary>
    ///   Get the A value of coordinate
    /// </summary>
    function GetA : Extended;
    /// <summary>
    ///   Set the A value of coordinate
    /// </summary>
    procedure SetA (const aValue : Extended);
    /// <summary>
    ///   Read / write the A value of coordinate
    /// </summary>
    property A : Extended read GetA write SetA;

    /// <summary>
    ///   Get the B value of coordinate
    /// </summary>
    function GetB : Extended;
    /// <summary>
    ///   Set the B value of coordinate
    /// </summary>
    procedure SetB (const aValue : Extended);
    /// <summary>
    ///   Read / write the B value of coordinate
    /// </summary>
    property B : Extended read GetB write SetB;

    /// <summary>
    ///   Get the C value of coordinate
    /// </summary>
    function GetC : Extended;
    /// <summary>
    ///   Set the C value of coordinate
    /// </summary>
    procedure SetC (const aValue : Extended);
    /// <summary>
    ///   Read / write the C value of coordinate
    /// </summary>
    property C : Extended read GetC write SetC;

    /// <summary>
    ///   Get the old world record XYZABC of coordinate set
    /// </summary>
    function GetXYZABC : Txyzabc;
    /// <summary>
    ///   Set the old world record XYZABC of coordinate set
    /// </summary>
    procedure SetXYZABC (const aValue : Txyzabc);
    /// <summary>
    ///   Read / write the old world record XYZABC of coordinate set
    /// </summary>
    property XYZABC : Txyzabc read GetXYZABC write SetXYZABC;

    /// <summary>
    ///   Set the coordinate set to default (0 0 0 0 0 0)
    /// </summary>
    procedure SetDefaultValue;
    /// <summary>
    ///   check the coordinate set is zero
    /// </summary>
    function IsZero: Boolean;

    /// <summary>
    ///   Get the negative of the coordinate set
    /// </summary>
    function Negativ: Txyzabc;
    /// <summary>
    ///   Get the Txyzabc record only with x,y,z values (the rest is zero)
    /// </summary>
    function GetXyzOnly: Txyzabc;
    /// <summary>
    ///   Get the Txyzabc record only with a,b,c values (the rest is zero)
    /// </summary>
    function GetAbcOnly: Txyzabc;
    /// <summary>
    ///   Get the Txyzabc record only with a,b,c,a values (the rest is zero)
    /// </summary>
    function GetXyzaOnly: Txyzabc;
    /// <summary>
    ///   Get the coordinate set as Txyzabc with inverted y value
    /// </summary>
    function InvertY: Txyzabc;
    /// <summary>
    ///   get the coordinate set as Txyzabc with added z value
    /// </summary>
    function AddZ(const AZValue: Extended): Txyzabc;
    /// <summary>
    ///   Rotate the coordinate set around zero with setted angle of A
    /// </summary>
    function RotateAAxis(const AAngle: Extended): Txyzabc;
    /// <summary>
    ///   Get the vector length of x,y,z
    /// </summary>
    function VectorLength: Extended;
    /// <summary>
    ///   Get the vector length of x,y
    /// </summary>
    function XYvectorLength: Extended;
    /// <summary>
    ///   Get the angle of x and y
    /// </summary>
    function GetXYAngle: Extended;
    /// <summary>
    ///   Get the coordinate set as Txyzabc record with absolute value (even
    ///   positive)
    /// </summary>
    function AbsoluteValue: Txyzabc;

    /// <summary>
    ///   Get the coordinate set as string
    /// </summary>
    function ToString: string; override;
    /// <summary>
    ///   Set the coordinate set from string
    /// </summary>
    procedure FromString(const AString: string);

    /// <summary>
    ///   get the coordinate set as TPointF record (2 dimensional xy coordinate)
    /// </summary>
    function ToFloatPoint: TPointF;
  end;

  {$ENDREGION}

  {$REGION 'ImiRGBI - Migration interface to TRGBI record'}
  {-----------------------------------------------------------------------------
  ImiRGBI migriert den Record TRGBI in die MicroCell Welt. Das Interface löst
  die globalen Variablen in der alten Welt ab und präsentiert den Zugriff als
  entsprechndes Interface. Um auf das alte TRGBI zugreifen zu können bietet das
  Interface eine RGBI property mit Getter & Setter. Der TRGBI Record enthält alle
  Werte für die Lichtsteuerung für Kameras und Erkennungssystemen
  -----------------------------------------------------------------------------}
  /// <summary>
  ///   <para>
  ///     ImiRGBI migrates the Record TRGBI to the MicroCell world. The
  ///     interface replace global variables in the old world and presents
  ///     access as a equivalent interface. In order to be able to access the
  ///     old TRGBI, the interface an RGBI property with Get &amp; Set.
  ///   </para>
  ///   <para>
  ///     TRGBI contains all light values for cam and recognition.
  ///   </para>
  /// </summary>
  ImiRGBI = interface(IInterface)
  ['{A510F824-2A7D-4EE3-8007-9F4610CE9028}']
    /// <summary>
    ///   Get the TRGBI record for using in the old world.
    /// </summary>
    function GetRGBI : TRGBI;
    /// <summary>
    ///   Set the value from TRGBI Record from the old world
    /// </summary>
    procedure SetRGBI(const aRGBI : TRGBI);
    /// <summary>
    ///   Read / write the values over TRGBI record from the old world.
    /// </summary>
    property RGBI : TRGBI read GetRGBI write SetRGBI;

    /// <summary>
    ///   Get the amplitude for red color
    /// </summary>
    function GetRot : Integer;
    /// <summary>
    ///   Set the amplitude for red color <br />
    /// </summary>
    procedure SetRot(const aValue : Integer);
    /// <summary>
    ///   Read / write the amplitude for red color <br />
    /// </summary>
    property Rot : Integer read GetRot write SetRot;

    /// <summary>
    ///   Get the amplitude of green color <br />
    /// </summary>
    function GetGruen : Integer;
    /// <summary>
    ///   Set the amplitude of green color <br />
    /// </summary>
    procedure SetGruen(const aValue : Integer);
    /// <summary>
    ///   Read / write the amplitude of green color <br />
    /// </summary>
    property Gruen : Integer read GetGruen write SetGruen;

    /// <summary>
    ///   Get the amplitude of blue color <br />
    /// </summary>
    function GetBlau : Integer;
    /// <summary>
    ///   Set the amplitude of blue color <br />
    /// </summary>
    procedure SetBlau(const aValue : Integer);
    /// <summary>
    ///   Read / write the amplitude of blue color
    /// </summary>
    property Blau : Integer read GetBlau write SetBlau;

    /// <summary>
    ///   Get the amplitude of inner co-axial light
    /// </summary>
    function GetInnen : Integer;
    /// <summary>
    ///   Set the amplitude of inner co-axial light
    /// </summary>
    procedure SetInnen(const aValue : Integer);
    /// <summary>
    ///   Read / write the amplitude of inner co-axial light
    /// </summary>
    property Innen : Integer read GetInnen write SetInnen;

    /// <summary>
    ///   Get the amplitude of extra light
    /// </summary>
    function GetExtra : Integer;
    /// <summary>
    ///   Set the amplitude of extra light
    /// </summary>
    procedure SetExtra(const aValue : Integer);
    /// <summary>
    ///   Read / write the amplitude of extra light
    /// </summary>
    property Extra : Integer read GetExtra write SetExtra;

    /// <summary>
    ///   Get the balance value of cam
    /// </summary>
    function GetBalance : Integer;
    /// <summary>
    ///   Set the balance value of cam
    /// </summary>
    procedure SetBalance(const aValue : Integer);
    /// <summary>
    ///   Read / write the balance value of cam
    /// </summary>
    property Balance : Integer read GetBalance write SetBalance;

    /// <summary>
    ///   Get the gain value of cam
    /// </summary>
    function GetGain : Integer;
    /// <summary>
    ///   Set the gain value of cam
    /// </summary>
    procedure SetGain(const aValue : Integer);
    /// <summary>
    ///   Read / write the gain value of cam
    /// </summary>
    property Gain : Integer read GetGain write SetGain;

    /// <summary>
    ///   Set all values to default
    /// </summary>
    procedure SetDefault;
    /// <summary>
    ///   Get the values as string
    /// </summary>
    function ToString : string;
  end;
  {$ENDREGION}

  {$REGION 'TmoRGBI - Migration object to deliver a RGBI interface refer to record'}
  {-----------------------------------------------------------------------------
  TmoRGBI liefert das Migrations-Interface ImiRGBI zur Integration in der alten
  Welt. Dabei dockt sich das Objekt an ein bestehenden TRGBI Record an oder
  greift alternativ auf einen eigenen RGBI Record zu.
  -----------------------------------------------------------------------------}
  /// <summary>
  ///   Provides the ImiRGBI migration interface for integration in the old
  ///   world. The object docks to an existing TRGBI record or uses an internal
  ///   TRGBI record.
  /// </summary>
  TmoRGBI = class(TInterfacedObject, ImiRGBI)
  strict protected
    /// <summary>
    ///   contains the pointer to the TRGBI record (extern or internal)
    /// </summary>
    fpRGBI : PRGBI;
    /// <summary>
    ///   contains the alternative internal RGBI record
    /// </summary>
    fRGBI  : TRGBI;
  public
    /// <summary>
    ///   Create the migration object of RGBI in use of the internal record
    ///   TRGBI.
    /// </summary>
    constructor create; overload;
    /// <summary>
    ///   Create the migration object of RGBI in use of the original RGBI
    ///   record as Pointer.
    /// </summary>
    constructor create(aPointer : PRGBI); overload;

    /// <summary>
    ///   check after construction the assigning of the RGBI record pointer
    /// </summary>
    procedure AfterConstruction; override;
    /// <summary>
    ///   Before destruction only to check the destroying of object.
    /// </summary>
    procedure BeforeDestruction; override;

    /// <summary>
    ///   Get the TRGBI record for using in the old world.
    /// </summary>
    function GetRGBI : TRGBI;
    /// <summary>
    ///   Set the value from TRGBI Record from the old world
    /// </summary>
    procedure SetRGBI(const aRGBI : TRGBI);
    /// <summary>
    ///   Read / write the values over TRGBI record from the old world.
    /// </summary>
    property RGBI : TRGBI read GetRGBI write SetRGBI;

    /// <summary>
    ///   Get the amplitude for red color
    /// </summary>
    function GetRot : Integer;
    /// <summary>
    ///   Set the amplitude for red color <br />
    /// </summary>
    procedure SetRot(const aValue : Integer);
    /// <summary>
    ///   Read / write the amplitude for red color <br />
    /// </summary>
    property Rot : Integer read GetRot write SetRot;

    /// <summary>
    ///   Get the amplitude of green color <br />
    /// </summary>
    function GetGruen : Integer;
    /// <summary>
    ///   Set the amplitude of green color <br />
    /// </summary>
    procedure SetGruen(const aValue : Integer);
    /// <summary>
    ///   Read / write the amplitude of green color <br />
    /// </summary>
    property Gruen : Integer read GetGruen write SetGruen;

    /// <summary>
    ///   Get the amplitude of blue color <br />
    /// </summary>
    function GetBlau : Integer;
    /// <summary>
    ///   Set the amplitude of blue color <br />
    /// </summary>
    procedure SetBlau(const aValue : Integer);
    /// <summary>
    ///   Read / write the amplitude of blue color
    /// </summary>
    property Blau : Integer read GetBlau write SetBlau;

    /// <summary>
    ///   Get the amplitude of inner co-axial light
    /// </summary>
    function GetInnen : Integer;
    /// <summary>
    ///   Set the amplitude of inner co-axial light
    /// </summary>
    procedure SetInnen(const aValue : Integer);
    /// <summary>
    ///   Read / write the amplitude of inner co-axial light
    /// </summary>
    property Innen : Integer read GetInnen write SetInnen;

    /// <summary>
    ///   Get the amplitude of extra light
    /// </summary>
    function GetExtra : Integer;
    /// <summary>
    ///   Set the amplitude of extra light
    /// </summary>
    procedure SetExtra(const aValue : Integer);
    /// <summary>
    ///   Read / write the amplitude of extra light
    /// </summary>
    property Extra : Integer read GetExtra write SetExtra;

    /// <summary>
    ///   Get the balance value of cam
    /// </summary>
    function GetBalance : Integer;
    /// <summary>
    ///   Set the balance value of cam
    /// </summary>
    procedure SetBalance(const aValue : Integer);
    /// <summary>
    ///   Read / write the balance value of cam
    /// </summary>
    property Balance : Integer read GetBalance write SetBalance;

    /// <summary>
    ///   Get the gain value of cam
    /// </summary>
    function GetGain : Integer;
    /// <summary>
    ///   Set the gain value of cam
    /// </summary>
    procedure SetGain(const aValue : Integer);
    /// <summary>
    ///   Read / write the gain value of cam
    /// </summary>
    property Gain : Integer read GetGain write SetGain;

    /// <summary>
    ///   Set all values to default
    /// </summary>
    procedure SetDefault;
    /// <summary>
    ///   Get the values as string
    /// </summary>
    function ToString : string; overload; override;
  end;
  {$ENDREGION}


implementation

{$REGION 'Implementation of TmoXYZABC'}
constructor TmoXYZABC.create;
begin
  // create without parameter set the alternative internal record to pointer
  fpXYZABC := @fXYZABC;
end;

constructor TmoXYZABC.create(aPointer : PXYZABC);
begin
  if Assigned(aPointer) then
    fpXYZABC := aPointer  // set the assigned parameter as external record
  else
    fpXYZABC := @fXYZABC; // set the alternative internal record
end;

procedure TmoXYZABC.AfterConstruction;
begin
  Assert(Assigned(fpXYZABC),'Pointer to XYZABC record are not assigned after construction!');
  inherited;
end;

procedure TmoXYZABC.BeforeDestruction;
begin
  Assert(Assigned(fpXYZABC),'Pointer to XYZABC record are not assigned before destruction!');
  inherited;
end;

function TmoXYZABC.GetX : Extended;
begin
  Result := fpXYZABC^.x;
end;

procedure TmoXYZABC.SetX (const aValue : Extended);
begin
  fpXYZABC^.x := aValue;
end;

function TmoXYZABC.GetY : Extended;
begin
  Result := fpXYZABC^.y;
end;

procedure TmoXYZABC.SetY (const aValue : Extended);
begin
  fpXYZABC^.y := aValue;
end;

function TmoXYZABC.GetZ : Extended;
begin
  Result := fpXYZABC^.z;
end;

procedure TmoXYZABC.SetZ (const aValue : Extended);
begin
  fpXYZABC^.z := aValue;
end;

function TmoXYZABC.GetA : Extended;
begin
  Result := fpXYZABC^.a;
end;

procedure TmoXYZABC.SetA (const aValue : Extended);
begin
  fpXYZABC^.a := aValue;
end;

function TmoXYZABC.GetB : Extended;
begin
  Result := fpXYZABC^.b;
end;

procedure TmoXYZABC.SetB (const aValue : Extended);
begin
  fpXYZABC^.b := aValue;
end;

function TmoXYZABC.GetC : Extended;
begin
  Result := fpXYZABC^.c;
end;

procedure TmoXYZABC.SetC (const aValue : Extended);
begin
  fpXYZABC^.c := aValue;
end;


function TmoXYZABC.GetXYZABC : Txyzabc;
begin
  Result := fpXYZABC^;
end;

procedure TmoXYZABC.SetXYZABC (const aValue : Txyzabc);
begin
  fpXYZABC^ := aValue;
end;

procedure TmoXYZABC.SetDefaultValue;
begin
  fpXYZABC^.SetDefaultValue;
end;

function TmoXYZABC.IsZero: Boolean;
begin
  Result := fpXYZABC^.IsZero;
end;

function TmoXYZABC.Negativ: Txyzabc;
begin
  Result := fpXYZABC^.Negativ;
end;

function TmoXYZABC.GetXyzOnly: Txyzabc;
begin
  Result := fpXYZABC^.GetXyzOnly;
end;

function TmoXYZABC.GetAbcOnly: Txyzabc;
begin
  Result := fpXYZABC^.GetAbcOnly;
end;

function TmoXYZABC.GetXyzaOnly: Txyzabc;
begin
  Result := fpXYZABC^.GetXyzaOnly;
end;

function TmoXYZABC.InvertY: Txyzabc;
begin
  Result := fpXYZABC^.InvertY;
end;

function TmoXYZABC.AddZ(const AZValue: Extended): Txyzabc;
begin
  Result := fpXYZABC^.AddZ(AZValue);
end;

function TmoXYZABC.RotateAAxis(const AAngle: Extended): Txyzabc;
begin
  Result := fpXYZABC^.RotateAAxis(AAngle);
end;

function TmoXYZABC.VectorLength: Extended;
begin
  Result := fpXYZABC^.VectorLength;
end;

function TmoXYZABC.XYvectorLength: Extended;
begin
  Result := fpXYZABC^.XYvectorLength;
end;

function TmoXYZABC.GetXYAngle: Extended;
begin
  Result := fpXYZABC^.GetXYAngle;
end;

function TmoXYZABC.AbsoluteValue: Txyzabc;
begin
  Result := fpXYZABC^.AbsoluteValue;
end;

function TmoXYZABC.ToString: string;
begin
  Result := fpXYZABC^.ToString;
end;

procedure TmoXYZABC.FromString(const AString: string);
begin
  fpXYZABC^.FromString(AString);
end;

function TmoXYZABC.ToFloatPoint: TPointF;
begin
  Result := fpXYZABC^.ToFloatPoint;
end;



{$ENDREGION}

{$REGION 'Implementation of TmoRGBI'}
constructor TmoRGBI.create;
begin
  // create without parameter set the alternative internal record to pointer
  fpRGBI := @fRGBI;
end;

constructor TmoRGBI.create(aPointer : PRGBI);
begin
  if Assigned(aPointer) then
    fpRGBI := aPointer  // set the assigned parameter as external record
  else
    fpRGBI := @fRGBI; // set the alternative internal record
end;

procedure TmoRGBI.AfterConstruction;
begin
  Assert(Assigned(fpRGBI),'Pointer to RGBI record are not assigned after construction!');
  inherited;
end;

procedure TmoRGBI.BeforeDestruction;
begin
  Assert(Assigned(fpRGBI),'Pointer to RGBI record are not assigned before destruction!');
  inherited;
end;

function TmoRGBI.GetRGBI : TRGBI;
begin
  Result := fpRGBI^;
end;

procedure TmoRGBI.SetRGBI(const aRGBI : TRGBI);
begin
  fpRGBI^ := aRGBI;
end;

function TmoRGBI.GetRot : Integer;
begin
  Result := fpRGBI^.Rot;
end;

procedure TmoRGBI.SetRot(const aValue : Integer);
begin
  fpRGBI^.Rot := aValue;
end;

function TmoRGBI.GetGruen : Integer;
begin
  Result := fpRGBI^.Gruen;
end;

procedure TmoRGBI.SetGruen(const aValue : Integer);
begin
  fpRGBI^.Gruen := aValue;
end;

function TmoRGBI.GetBlau : Integer;
begin
  Result := fpRGBI^.Blau;
end;

procedure TmoRGBI.SetBlau(const aValue : Integer);
begin
  fpRGBI^.Blau := aValue;
end;

function TmoRGBI.GetInnen : Integer;
begin
  Result := fpRGBI^.Innen
end;

procedure TmoRGBI.SetInnen(const aValue : Integer);
begin
  fpRGBI^.Innen := aValue;
end;

function TmoRGBI.GetExtra : Integer;
begin
  Result := fpRGBI^.Extra;
end;

procedure TmoRGBI.SetExtra(const aValue : Integer);
begin
  fpRGBI^.Extra := aValue;
end;

function TmoRGBI.GetBalance : Integer;
begin
  Result := fpRGBI^.Balance;
end;

procedure TmoRGBI.SetBalance(const aValue : Integer);
begin
  fpRGBI^.Balance := aValue;
end;

function TmoRGBI.GetGain : Integer;
begin
  Result := fpRGBI^.Gain;
end;

procedure TmoRGBI.SetGain(const aValue : Integer);
begin
  fpRGBI^.Gain := aValue;
end;

procedure TmoRGBI.SetDefault;
begin
  fpRGBI^.SetDefault;
end;

function TmoRGBI.ToString : string;
begin
  Result:= fpRGBI^.ToString;
end;
{$ENDREGION}

end.
