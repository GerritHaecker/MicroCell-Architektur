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
//    Gerrit Häcker (2019 - 2021)
// *****************************************************************************

unit OurPlant.Samples.SkillInterface;

interface

{$REGION 'uses'}
uses
  OurPlant.Common.CellObject,
  OurPlant.Common.DataCell;
{$ENDREGION}

const
  C_FIRST_SKILL_SAMPLE_INTEGER = 99;
  C_SECOND_SKILL_SAMPLE_SIZE = 8;

type
{$REGION 'First Skill interface sample'}
  /// <summary>
  ///  First SKILL Interface Sample
  ///  hat eine property siMyFirstInteger mit Getter und Setter
  /// </summary>
  IsiFirstSkill1 = interface(IsiCellObject)
    ['{E8458E19-7C19-4584-B006-0FA02BA021AC}']
    /// <summary>
    ///   Get the integer of first skill interface
    /// </summary>
    function  siGetInteger : Integer;
    /// <summary>
    ///   Set the integer of first skill interface
    /// </summary>
    procedure siSetInteger(const aInteger : Integer);
    /// <summary>
    ///   read / write the integer from first skill interface
    /// </summary>
    property siInteger : Integer read siGetInteger write siSetInteger;
  end;

  /// <summary>
  ///  TsiMyFirstSkill1 ist die universelle skill interface adapter cell von IsiMyFirstSkill1
  ///  hat eine Subzelle als Methode mit dem Namen siInteger. Sie kann über
  ///  die Interface Funktion siMyFirstInteger (auch get/set) aufgerufen werden
  ///  oder über die Subzellenstruktur .../siMyFirstSkillSample/siMyFirstInteger
  /// </summary>
  [RegisterCellType('First skill sample','{F66D575B-457F-43A9-A3BA-C16B58C75569}')]
  TsiFirstSkill1 = class(TCellObject, IsiFirstSkill1)
  public
    /// <summary>
    ///   Construct the cell structure during after construction. This method
    ///   override the virtual method of TCellObject.
    /// </summary>
    procedure CellConstruction; override;

  strict protected
    /// <summary>
    ///   Contain the siInteger skill method cell. Construct a independent (no
    ///   content as sub cell) new cell from TcoInteger with name 'siInteger'
    /// </summary>
    [IndependentCell( TcoInteger, 'siInteger')]
    fsiInteger : IsiInteger;

    /// <summary>
    ///   Get the integer of first skill. This implementation get the value
    ///   from the siInteger skill method cell as universal adapter
    /// </summary>
    function siGetInteger : Integer;
    /// <summary>
    ///   Set the integer of first skill. This implementation use the siInteger
    ///   skill method cell as universal adapter
    /// </summary>
    procedure siSetInteger(const aInteger : Integer);
  end;

  /// <summary>
  ///  TcoFirstSkill1 ist die allgemeine Vorlage für eine cell die IsiMyFirstSkill1
  ///  implementiert. Sie wird von TsiMyFirstSkill1 abgeleitet und erbt damit die
  ///  Subzellen Struktur des Adapters.
  ///  TcoFirstSkill1 ist für die direkte Umsetzung von SI Logik vorgesehen, durch die
  ///  Event Routinen OnGetInteger und OnSetInteger werden die Aufrufe über die skill
  ///  method cell's direkt auf die Interface Methoden ungeleitet.
  ///  in Nachfolgern müssen die Interface Methoden siGetInteger, siSetInteger
  ///  überschrieben werden.
  /// </summary>
  TcoFirstSkill1 = class(TsiFirstSkill1, IsiFirstSkill1)
  public
    /// <summary>
    ///   Construct the cell structure during after construction. This method
    ///   override the virtual method of TCellObject.
    /// </summary>
    procedure CellConstruction; override;

  strict protected
    /// <summary>
    ///   abstract pre defined getter for siGetInteger to later override of use
    ///   cases of this template
    /// </summary>
    function siGetInteger : Integer; virtual; abstract;
    // Implementierung der Skill-Interface-Methoden
    /// <summary>
    ///   abstract pre defined setter for siSetInteger to later override of use
    ///   cases of this template
    /// </summary>
    procedure siSetInteger(const aInteger : Integer); virtual; abstract;

  strict private
    /// <summary>
    ///   The OnRead Event of the skill method cell of siInteger
    /// </summary>
    procedure OnGetInteger(const aSender : IsiCellObject);
    /// <summary>
    ///   The OnWrite Event of the skill method cell of siInteger
    /// </summary>
    procedure OnSetInteger(const aSender : IsiCellObject);
  end;
{$ENDREGION}

{$REGION 'Second Skill interface sample'}
  IsiSecondSkill1 = interface(IsiCellObject)
    ['{19D0FCD1-24D3-40E5-BEF4-1B42B1F5314B}']
    function  siSize: Byte;
    function  siBit(const aIndex : Byte) : Boolean;
    function  siGetInteger : Integer;
    procedure siSetInteger(const aValue : Integer);
    property  siInteger : Integer read siGetInteger write siSetInteger;
    procedure siInc;
  end;

  // TsiSecondSkill1 is the universal skill interface adapter cell of IsiSecondSkill1
  [RegisterCellType('Second skill sample','{82195BA7-E3B3-4856-A6A8-D2F29BEEFE68}')]
  TsiSecondSkill1 = class(TCellObject, IsiSecondSkill1)
  public
    /// <summary>
    ///   Construct the cell structure during after construction. This method
    ///   override the virtual method of TCellObject.
    /// </summary>
    procedure CellConstruction; override;

  strict protected
    [IndependentCell( TcoInteger, 'siSize', C_SECOND_SKILL_SAMPLE_SIZE)]
    fsiSize : IsiInteger;

    [IndependentCell( TcoBoolean, 'siBit', false)]
    fsiBit : IsiBoolean;

    [IndependentCell( TcoInteger, 'siBit/aIndex', 0)]
    fsiBitAIndex : IsiInteger;

    [IndependentCell( TcoInteger, 'siInteger', C_FIRST_SKILL_SAMPLE_INTEGER)]
    fsiInteger : IsiInteger;

    [IndependentCell( TCellObject, 'siInc')]
    fsiInc : IsiCellObject;

    // Implementierung der Skill-Interface-Methoden
    function  siSize: Byte;
    function  siBit(const aIndex : Byte) : Boolean;
    function  siGetInteger : Integer;
    procedure siSetInteger(const aValue : Integer);
    property  siInteger : Integer read siGetInteger write siSetInteger;
    procedure siInc;
  end;

  // TcoSecondSkill1 is the template cell object of skill interface IsiSecondSkill1
  TcoSecondSkill1 = class(TsiSecondSkill1, IsiSecondSkill1)
  public
    /// <summary>
    ///   Construct the cell structure during after construction. This method
    ///   override the virtual method of TCellObject.
    /// </summary>
    procedure CellConstruction; override;

  strict protected
    // Implementierung der Skill-Interface-Methoden
    function  siSize: Byte; virtual; abstract;
    function  siBit(const aIndex : Byte) : Boolean; virtual; abstract;
    function  siGetInteger : Integer; virtual; abstract;
    procedure siSetInteger(const aValue : Integer); virtual; abstract;
    procedure siInc; virtual; abstract;

  strict private
    // on Read/write Events der skill method cell
    procedure OnGetSize(const aSender : IsiCellObject);
    procedure OnGetBit(const aSender : IsiCellObject);
    procedure OnGetInteger(const aSender : IsiCellObject);
    procedure OnSetInteger(const aSender : IsiCellObject);
    procedure OnGetInc(const aSender : IsiCellObject);
  end;
{$ENDREGION}

{$REGION 'Use Cases Sample 1: derived IsiMyFirstSkill1 cell object'}
  /// <summary>
  ///  TcoSkilledCellSample1 erbt die Fähigkeiten der Zellen TcoFirstSkill1 und TsiMyFirstSkill1
  ///  implementiert somit IsiMyFirstSkill1 und stellt auch die skill interface cell
  ///  Struktur zur Verfügung, Hier muss jetzt den Interface Methoden Code gegeben werden.
  /// </summary>
  [RegisterCellType('skilled cell sample 1','{1213430C-757F-4461-B221-8055D458086F}')]
  TcoSkilledCellSample1 = class(TcoFirstSkill1, IsiFirstSkill1)
  public
    /// <summary>
    ///   Construct the cell structure during after construction. This method
    ///   override the virtual method of TCellObject.
    /// </summary>
    procedure CellConstruction; override;
  strict protected
    fInteger : Integer;
    // Implementierung der Skill-Interface-Methoden
    function siGetInteger : Integer; override;
    procedure siSetInteger(const aInteger : Integer); override;
  end;
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{$ENDREGION}

{$REGION 'Use Cases Sample 2: cell with two adapted skill interfaces'}
  [RegisterCellType('skilled cell sample 2','{BF5F5D02-C14A-462C-B702-D8EB03CAC00E}')]
  TcoSkilledCellSample2 = class(TCellObject, IsiFirstSkill1, IsiSecondSkill1)
  public
    /// <summary>
    ///   Construct the cell structure during after construction. This method
    ///   override the virtual method of TCellObject.
    /// </summary>
    procedure CellConstruction; override;

  strict protected
    [NewCell( TcoInteger, 'Integer', C_FIRST_SKILL_SAMPLE_INTEGER)]
    fInteger : IsiInteger;

    [NewCell( TcoInteger,'Size', C_SECOND_SKILL_SAMPLE_SIZE)]
    fSize    : IsiInteger;

    // implemented Skill Interfaces
    [NewCell( TsiFirstSkill1, 'first skill')]
    fsiFirstSkill : IsiFirstSkill1;

    [NewCell( TsiSecondSkill1, 'second skill')]
    fsiSecondSkill : IsiSecondSkill1;

    // properties of implemented skill interfaces
    property FirstSkill : IsiFirstSkill1 read fsiFirstSkill implements IsiFirstSkill1;
    property SecondSkill : IsiSecondSkill1 read fsiSecondSkill implements IsiSecondSkill1;

  strict private
    // on Read/write Events der skill method cell von FirstSkill & SecondSkill
    procedure OnGetSize(const aSender : IsiCellObject);    // SecondSkill
    procedure OnGetBit(const aSender : IsiCellObject);     // SecondSkill
    procedure OnGetInteger(const aSender : IsiCellObject); // FirstSkill & SecondSkill
    procedure OnSetInteger(const aSender : IsiCellObject); // FirstSkill & SecondSkill
    procedure OnGetInc(const aSender : IsiCellObject);     // SecondSkill
  end;
{$ENDREGION}

{$REGION 'Use Cases Sample 3: cell with deposed skill interfaces cell'}
  // TcoDeposedSecondSkill1 is a disposed skill cell with logic for IsiSecondSkill1
  [RegisterCellType('second skill','{C7E27783-746B-4CC4-B3C9-10F6C92CE4D4}')]
  TcoDeposedSecondSkill = class(TcoSecondSkill1, IsiSecondSkill1)
  public
    /// <summary>
    ///   Construct the cell structure during after construction. This method
    ///   override the virtual method of TCellObject.
    /// </summary>
    procedure CellConstruction; override;

  strict protected
    [NewCell( TcoInteger, 'Integer', C_FIRST_SKILL_SAMPLE_INTEGER)]
    fInteger : IsiInteger;

    [NewCell( TcoInteger, 'Size', C_SECOND_SKILL_SAMPLE_SIZE)]
    fSize : IsiInteger;

    // Implementierung der Skill-Interface-Methoden
    function  siSize: Byte; override;
    function  siBit(const aIndex : Byte) : Boolean; override;
    function  siGetInteger : Integer; override;
    procedure siSetInteger(const aValue : Integer); override;
    property  siInteger : Integer read siGetInteger write siSetInteger;
    procedure siInc; override;
  end;

  // TcoSkilledCellSample3 as sample for use the deposed skill cell for IsiSecondSkill1
  [RegisterCellType('skilled cell sample 3','{C7E27783-746B-4CC4-B3C9-10F6C92CE4D4}')]
  TcoSkilledCellSample3 = class(TCellObject, IsiSecondSkill1)
  public
    /// <summary>
    ///   Construct the cell structure during after construction. This method
    ///   override the virtual method of TCellObject.
    /// </summary>
    procedure CellConstruction; override;

  strict protected
    [NewCell( TcoDeposedSecondSkill, 'second skill')]
    fsiSecondSkill : IsiSecondSkill1;

    property SecondSkill : IsiSecondSkill1 read fsiSecondSkill implements IsiSecondSkill1;
  end;
{$ENDREGION}

implementation

{$REGION 'uses'}
uses
  System.SysUtils,
  System.RTTI;
{$ENDREGION}

const
{$REGION 'DEFAULT CONSTANTES'}
  C_DEFAULT_BIT = False;
  C_DEFAULT_INTEGER = 0;
{$ENDREGION}


{$REGION 'First Skill interface sample implementation'}
// TsiMyFirstSkill1 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TsiFirstSkill1.CellConstruction;
begin
  inherited;
  // skill method cell for the getter and setter of siInteger of result type integer
  //fsiInteger := ConstructNewCellAs<IsiInteger>(TcoInteger,'siInteger');
end;

function TsiFirstSkill1.siGetInteger : Integer;
begin
  // the getter get the value (integer) from the skill method siMyInteger
  Result := fsiInteger.siAsInteger;
end;

procedure TsiFirstSkill1.siSetInteger(const aInteger : Integer);
begin
  // the setter set the value (integer) of the skill method siMyInteger
  fsiInteger.siAsInteger := aInteger;
end;

// TcoMyFirstSkill1 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TcoFirstSkill1.CellConstruction;
begin
  inherited;
  // setzte Event Procedure für die Skill Interface Methode siInteger
  fsiInteger.siOnRead := OnGetInteger;
  fsiInteger.siOnWrite := OnSetInteger;
end;

procedure TcoFirstSkill1.OnGetInteger(const aSender : IsiCellObject);
begin
  // der Aufruf der Interface Methode über die skill method cell siInteger (Sender)
  CellAs<IsiInteger>(aSender).siAsInteger := siGetInteger;

  // ODER: fsiInteger.siAsInteger := siGetInteger;
end;

procedure TcoFirstSkill1.OnSetInteger(const aSender : IsiCellObject);
begin
  // der Aufruf der Interface Methode über die skill method cell siInteger (Sender)
  siSetInteger( CellAs<IsiInteger>( aSender).siAsInteger );

  // ODER: siSetInteger( fsiInteger.siAsInteger );
end;

{$ENDREGION}

{$REGION 'Second Skill interface sample implementation'}
// TsiSecondSkill1 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TsiSecondSkill1.CellConstruction;
begin
  inherited;
  // construct the skill method: function siSize: Byte
  //fsiSize := ConstructNewCellAs<IsiInteger>(TcoInteger,'siSize');

  // construct the skill method: function siBit(const aBit : Byte) : Boolean
  //fsiBit := ConstructNewCellAs<IsiBoolean>(TcoBoolean,'siBit');
  //fsiBitAIndex := ConstructNewCellAs<IsiInteger>(TcoInteger,'siBit/aIndex');

  // construct the skill method: property  siInteger : Integer (read/write)
  //fsiInteger := ConstructNewCellAs<IsiInteger>(TcoInteger,'siInteger');

  // construct the skill method: procedure siInc
  //fsiInc := ConstructNewCell('siInc');
end;

function TsiSecondSkill1.siSize: Byte;
begin
  Result := fsiSize.siAsInteger;
end;

function TsiSecondSkill1.siBit(const aIndex : Byte) : Boolean;
begin
  fsiBitAIndex.siAsInteger := aIndex;
  Result := fsiBit.siAsBoolean;
end;

function TsiSecondSkill1.siGetInteger : Integer;
begin
  Result := fsiInteger.siAsInteger;
end;

procedure TsiSecondSkill1.siSetInteger(const aValue : Integer);
begin
  fsiInteger.siAsInteger := aValue;
end;

procedure TsiSecondSkill1.siInc;
begin
  fsiInc.siCall;
end;

// TcoSecondSkill1 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TcoSecondSkill1.CellConstruction;
begin
  inherited;
  fsiSize.siOnRead := OnGetSize;
  fsiBit.siOnRead := OnGetBit;
  fsiInteger.siOnRead := OnGetInteger;
  fsiInteger.siOnWrite := OnSetInteger;
  fsiInc.siOnRead := OnGetInc;
end;

// on Read/write Events der siInteger skill method cell
procedure TcoSecondSkill1.OnGetSize(const aSender : IsiCellObject);
begin
  // der Aufruf der Interface Methode über die skill method cell siSize (Sender)
  CellAs<IsiInteger>(aSender).siAsInteger := siSize;
end;

procedure TcoSecondSkill1.OnGetBit(const aSender : IsiCellObject);
begin
  // der Aufruf der Interface Methode über die skill method cell siBit(aIndex) (Sender)
  CellAs<IsiBoolean>(aSender).siAsBoolean := siBit( fsiBitAIndex.siAsInteger );
end;

procedure TcoSecondSkill1.OnGetInteger(const aSender : IsiCellObject);
begin
  // der Aufruf der Interface Methode über die skill method cell siGetInteger (Sender)
  CellAs<IsiInteger>(aSender).siAsInteger := siGetInteger;
end;

procedure TcoSecondSkill1.OnSetInteger(const aSender : IsiCellObject);
begin
  // der Aufruf der Interface Methode über die skill method cell siSetInteger (Sender)
  siSetInteger( CellAs<IsiInteger>(aSender).siAsInteger );
end;

procedure TcoSecondSkill1.OnGetInc(const aSender : IsiCellObject);
begin
  // der Aufruf der Interface Methode über die skill method cell siInc (Sender)
  siInc;
end;
{$ENDREGION}

{$REGION 'TcoSkilledCellSample1 - Use cases sample 1 implementation'}
// TcoSkilledCellSample1 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TcoSkilledCellSample1.CellConstruction;
const MY_DEFAULT_INT = 0;
begin
  inherited;
  fInteger := MY_DEFAULT_INT;
end;

function TcoSkilledCellSample1.siGetInteger : Integer;
begin
  Result := fInteger;
end;

procedure TcoSkilledCellSample1.siSetInteger(const aInteger : Integer);
begin
  fInteger := aInteger;
end;


{$ENDREGION}

{$REGION 'TcoSkilledCellSample2 - Use Cases Sample 2 implementation'}
procedure TcoSkilledCellSample2.CellConstruction;
var vIntCell : IsiInteger;
    vCell : IsiCellObject;
begin
  inherited;

  // construct data cells for own vars and set the default values
  //fInteger := ConstructNewCellAs<IsiInteger>(TcoInteger,'Integer');
 // fInteger.siAsInteger:=C_FIRST_SKILL_SAMPLE_INTEGER;

  //fSize := ConstructNewCellAs<IsiInteger>(TcoInteger,'Size');
  //fSize.siAsInteger:=C_SECOND_SKILL_SAMPLE_SIZE;

  // adapt and implement the first skill over TsiFirstSkill1
  //fsiFirstSkill := ConstructNewCellAs<IsiFirstSkill1>(TsiFirstSkill1,'first skill');

  // set the read/write Events to skill method siInteger of FirstSkill
  with ValidCell( fsiFirstSkill.siGetSubCell('siInteger')) do
  begin
    siOnRead  := OnGetInteger;
    siOnWrite := OnSetInteger;
  end;

  // adapt and implement the second skill over TsiSecondSkill1
  //fsiSecondSkill := ConstructNewCellAs<IsiSecondSkill1>(TsiSecondSkill1,'second skill');

  // set the read/write Events to skill methods SecondSkill
  ValidCell( fsiSecondSkill.siGetSubCell('siSize')).siOnRead := OnGetSize;
  ValidCell( fsiSecondSkill.siGetSubCell('siBit')).siOnRead := OnGetBit;
  with ValidCell( fsiSecondSkill.siGetSubCell('siInteger')) do
  begin
    siOnRead  := OnGetInteger;
    siOnWrite := OnSetInteger;
  end;
  ValidCell( fsiSecondSkill.siGetSubCell('siInc')).siOnRead := OnGetInc;

end;

procedure TcoSkilledCellSample2.OnGetSize(const aSender : IsiCellObject);
begin
  CellAs<IsiInteger>( aSender).siAsInteger := fSize.siAsInteger;
end;

procedure TcoSkilledCellSample2.OnGetBit(const aSender : IsiCellObject);
var
  vBit : IsiBoolean;
  vIndex : IsiInteger;
begin
  vBit := CellAs<IsiBoolean>( aSender);
  vIndex := CellAs<IsiInteger>( vBit.siGetSubCell('aIndex'));

  // check aIndex is smaller then value of Skill-Method SecondSkill/siSize
  if vIndex.siAsInteger < fSize.siAsInteger then
    // the Result from SecondSkill/siBit is the masked integer value
    vBit.siAsBoolean := (fInteger.siAsInteger and (1 shl vIndex.siAsInteger)) > 0
  else
    vBit.siAsBoolean :=False;
end;

procedure TcoSkilledCellSample2.OnGetInteger(const aSender : IsiCellObject);
begin
  if aSender.siController.siIsSame(fsiSecondSkill) then
    // OnGetInteger wurde von siGetInteger aus dem Second skill aufgerufen
    CellAs<IsiInteger>( aSender).siAsInteger :=
      fInteger.siAsInteger and ((1 shl fSize.siAsInteger) - 1)
  else
    // OnGetInteger wurde von siGetInteger aus dem First skill aufgerufen
    CellAs<IsiInteger>( aSender).siAsInteger := fInteger.siAsInteger;
end;

procedure TcoSkilledCellSample2.OnSetInteger(const aSender : IsiCellObject);
begin
  if aSender.siController.siIsSame(fsiSecondSkill) then
    // OnSetInteger wurde von siSetInteger aus dem Second skill aufgerufen
    fInteger.siAsInteger :=
      CellAs<IsiInteger>( aSender).siAsInteger and ((1 shl fSize.siAsInteger) - 1)
  else
    // OnSetInteger wurde von siSetInteger aus dem First skill aufgerufen
    fInteger.siAsInteger := CellAs<IsiInteger>( aSender).siAsInteger;
end;


procedure TcoSkilledCellSample2.OnGetInc(const aSender : IsiCellObject);
begin
  fInteger.siAsInteger := fInteger.siAsInteger + 1; // increment internal integer
end;
{$ENDREGION}

{$REGION 'TcoSkilledCellSample3 - Use Cases Sample 3 implementation'}
procedure TcoDeposedSecondSkill.CellConstruction;
begin
  inherited;

  // construct data cells for own vars and set the default values
  //fInteger := ConstructNewCellAs<IsiInteger>(TcoInteger,'Integer');
  //fInteger.siAsInteger:=C_FIRST_SKILL_SAMPLE_INTEGER;

  //fSize := ConstructNewCellAs<IsiInteger>(TcoInteger,'Size');
  //fSize.siAsInteger:=C_SECOND_SKILL_SAMPLE_SIZE;

end;

function TcoDeposedSecondSkill.siSize: Byte;
begin
  Result := fSize.siValue.AsType<Byte>;
end;

function TcoDeposedSecondSkill.siBit(const aIndex : Byte) : Boolean;
begin
  // check aIndex is smaller then value of Skill-Method siSize (cell)
  if aIndex < fSize.siAsInteger then
    // the Result from SecondSkill/siBit is the masked integer value
    result := (fInteger.siAsInteger and (1 shl aIndex)) > 0
  else
    result :=False;
end;

function TcoDeposedSecondSkill.siGetInteger : Integer;
begin
  Result := fInteger.siAsInteger and ((1 shl fSize.siAsInteger) - 1);
end;

procedure TcoDeposedSecondSkill.siSetInteger(const aValue : Integer);
begin
  fInteger.siAsInteger := aValue and ((1 shl fSize.siAsInteger) - 1);
end;

procedure TcoDeposedSecondSkill.siInc;
begin
  fInteger.siAsInteger := fInteger.siAsInteger + 1;
end;

procedure TcoSkilledCellSample3.CellConstruction;
begin
  inherited;
  // construct the second skill interface SecondSkill
  //fsiSecondSkill := ConstructNewCellAs<IsiSecondSkill1>(TcoDeposedSecondSkill,'second skill');
end;
{$ENDREGION}


end.
