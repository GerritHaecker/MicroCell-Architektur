// *****************************************************************************
//
//                       OurPlant OS Architecture
//                             for Delphi
//                                2019
//
// Copyrights 2019 @ Häcker Automation GmbH
// *****************************************************************************
unit OurPlant.Samples.SkillInterface;

interface

{$REGION 'uses'}
uses
  OurPlant.Common.CellObject,
  OurPlant.Common.CellAttributes,
  OurPlant.Common.DataCell;
{$ENDREGION}

const
  C_FIRST_SKILL_SAMPLE_INTEGER = 99;
  C_SECOND_SKILL_SAMPLE_SIZE = 8;

type

{$REGION 'First Skill interface sample'}
// First SKILL Interface Sample ++++++++++++++++++++++++++++++++++++++++++++++++
// hat eine property siMyFirstInteger mit Getter und Setter
  IsiMyFirstSkillSampleV1 = interface(IsiCellObject)
    ['{E8458E19-7C19-4584-B006-0FA02BA021AC}']
    function  siGetMyInteger : Integer;                    // Hilfs-Getter für siMyInteger
    procedure siSetMyInteger(const aInteger : Integer);    // Hilfs-Setter für siMyInteger
    property  siMyInteger : Integer read siGetMyInteger write siSetMyInteger;
  end;

// First SKILL Interface Connector Cell for IsiMyFirstSkillSampleV1 ++++++++++++
// hat eine Subzelle als Methode mit dem Namen siMyFirstInteger. Sie kann über
// die Interface Funktion siMyFirstInteger (auch get/set) aufgerufen werden
// oder über die Subzellenstruktur .../siMyFirstSkillSample/siMyFirstInteger
  [RegisterCellType('MyFirstSkillSample1','{F66D575B-457F-43A9-A3BA-C16B58C75569}')]
  TsiMyFirstSkillSampleV1 = class(TSkillInterfaceCell, IsiMyFirstSkillSampleV1)
  strict protected
    fsiMyInteger : IsiInteger;
  public
    // allgemeiner Teil - Konstruktion der Skill-Interface-Zelle
    procedure CellConstruction; override;
    // individueller Teil - Implementierung der Skill-Interface-Methoden
    function siGetMyInteger : Integer;
    procedure siSetMyInteger(const aInteger : Integer);
  end;

// First Cell Object that use SKILL Interface Sample and the Connector Cell ++++
// Implementieren eines Skill Interfaces als SubZelle. Die Zelle selbst unterstützt
// das Skill-Interface und auch die Subzelle /siMyFirstSkillSample.
  [RegisterCellType('MyFirstSkillSampleUseCase','{1213430C-757F-4461-B221-8055D458086F}')]
  TcoMyFirstSkillSampleUseCase = class(TSkillInterfaceCell, IsiMyFirstSkillSampleV1)
  strict protected
    fInteger : Integer;
    fsiFirstSkill : IsiMyFirstSkillSampleV1;
    procedure OnGetMyInteger(const aSender : IsiCellObject);
    procedure OnSetMyInteger(const aSender : IsiCellObject);
  public
    procedure CellConstruction; override;
    // durch die Implementierung wird das Skill Interface der Subzelle zum eigenem Interface
    property FirstSkill : IsiMyFirstSkillSampleV1 read fsiFirstSkill implements IsiMyFirstSkillSampleV1;
  end;
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{$ENDREGION}

{$REGION 'Second Skill interface sample'}
  IsiSecondSkillSampleV1 = interface(IsiCellObject)
    ['{19D0FCD1-24D3-40E5-BEF4-1B42B1F5314B}']
    function  siSize: Byte;
    function  siBit(const aIndex : Byte) : Boolean;

    function  siGetInteger : Integer;
    procedure siSetInteger(const aValue : Integer);
    property  siInteger : Integer read siGetInteger write siSetInteger;

    procedure siInc;
  end;
{$ENDREGION}

{$REGION 'integrated skill cell sample'}
  // TsiSecondSkillSampleV1 is a connected skill cell for common usability
  [RegisterCellType('SecondSkillSampleV1','{82195BA7-E3B3-4856-A6A8-D2F29BEEFE68}')]
  TsiSecondSkillSampleV1 = class(TSkillInterfaceCell, IsiSecondSkillSampleV1)
  strict protected
    fsiSize      : IsiInteger;
    fsiBit       : IsiBoolean;
    fsiBitAIndex : IsiInteger;
    fsiInteger   : IsiInteger;
    fsiInc       : IsiCellObject;
  public
    // allgemeiner Teil - Konstruktion der Skill-Interface-Zelle
    procedure CellConstruction; override;

    // individueller Teil - Implementierung der Skill-Interface-Methoden
    function  siSize: Byte;
    function  siBit(const aIndex : Byte) : Boolean;

    function  siGetInteger : Integer;
    procedure siSetInteger(const aValue : Integer);
    property  siInteger : Integer read siGetInteger write siSetInteger;

    procedure siInc;
  end;

  // Use case of a main cell that use the TsiSecondSkillSampleV1 as connected skill cell
  [RegisterCellType('ConnectedSkillSample','{BF5F5D02-C14A-462C-B702-D8EB03CAC00E}')]
  TcoUseConnectedSkillSample = class(TCellObject, IsiMyFirstSkillSampleV1, IsiSecondSkillSampleV1)
  strict protected
    // protected internal integer
    fInteger : Integer;

    // implemented Skill Interfaces
    fsiFirstSkill : IsiMyFirstSkillSampleV1;
    fsiSecondSkill : IsiSecondSkillSampleV1;

    // cell procedure for FirstSkill/siMyInteger
    procedure OnGetMyInteger(const aSender : IsiCellObject);
    procedure OnSetMyInteger(const aSender : IsiCellObject);

    // cell procedure for SecondSkill/siBit
    procedure OnGetBit(const aSender : IsiCellObject);
    // cell procedure for SecondSkill/siInteger (getter and setter)
    procedure OnGetInteger(const aSender : IsiCellObject);
    procedure OnsetInteger(const aSender : IsiCellObject);
    // cell procedure for SecondSkill/siIncrement
    procedure OnInc(const aSender : IsiCellObject);
  public
    // common part of cell construction
    procedure CellConstruction; override;

    // properties of implemented skill interfaces
    property FirstSkill : IsiMyFirstSkillSampleV1 read fsiFirstSkill implements IsiMyFirstSkillSampleV1;
    property SecondSkill : IsiSecondSkillSampleV1 read fsiSecondSkill implements IsiSecondSkillSampleV1;
  end;
{$ENDREGION}

{$REGION 'Deposed skill cell sample'}
  // TcoDeposedSkillSample is a disposed skill cell with logic for IsiSecondSkillSampleV1
  [RegisterCellType('DeposedSkillSample','{C7E27783-746B-4CC4-B3C9-10F6C92CE4D4}')]
  TcoDeposedSkillSample = class(TSkillInterfaceCell, IsiSecondSkillSampleV1)
  strict protected
    fInteger     : Integer; // internal integer;

    fsiSize      : IsiInteger;
    fsiBit       : IsiBoolean;
    fsiBitAIndex : IsiInteger;
    fsiInteger   : IsiInteger;
    fsiInc       : IsiCellObject;

    // cell procedure for SecondSkill/siBit
    procedure OnGetBit(const aSender : IsiCellObject);
    // cell procedure for SecondSkill/siInteger (getter and setter)
    procedure OnGetInteger(const aSender : IsiCellObject);
    procedure OnsetInteger(const aSender : IsiCellObject);
    // cell procedure for SecondSkill/siIncrement
    procedure OnInc(const aSender : IsiCellObject);

  public
    // allgemeiner Teil - Konstruktion der Skill-Interface-Zelle
    procedure CellConstruction; override;

    // individueller Teil - Implementierung der Skill-Interface-Methoden
    function  siSize: Byte;
    function  siBit(const aIndex : Byte) : Boolean;

    function  siGetInteger : Integer;
    procedure siSetInteger(const aValue : Integer);
    property  siInteger : Integer read siGetInteger write siSetInteger;

    procedure siInc;
  end;
{$ENDREGION}

{$REGION 'User sample for deposed skill cell sample'}
  // TcoUseDeposedSkillSample as sample for use the disposed skill cell for IsiSecondSkillSampleV1
  [RegisterCellType('DeposedSkillSample','{C7E27783-746B-4CC4-B3C9-10F6C92CE4D4}')]
  TcoUseDeposedSkillSample = class(TCellObject, IsiSecondSkillSampleV1)
  strict protected
    fsiSecondSkill : IsiSecondSkillSampleV1;

  public
    // allgemeiner Teil - Konstruktion der Skill-Interface-Zelle
    procedure CellConstruction; override;

    property SecondSkill : IsiSecondSkillSampleV1 read fsiSecondSkill implements IsiSecondSkillSampleV1;
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


{$REGION 'TsiMyFirstSkillSampleV1 implementation'}
procedure TsiMyFirstSkillSampleV1.CellConstruction;
begin
  inherited;

  // skill method cell for the getter and setter of siMyInteger of result type integer
  // property siMyInteger : Integer read siGetMyInteger write siSetMyInteger;
  fsiMyInteger := ConstructNewCellAs<IsiInteger>(TcoInteger,'siMyInteger');
end;

function TsiMyFirstSkillSampleV1.siGetMyInteger : Integer;
begin
  // the getter get the value (integer) from the skill method siMyInteger
  Result := fsiMyInteger.siAsInteger;
end;

procedure TsiMyFirstSkillSampleV1.siSetMyInteger(const aInteger : Integer);
begin
  // the setter set the value (integer) of the skill method siMyInteger
  fsiMyInteger.siAsInteger := aInteger;
end;
{$ENDREGION}

{$REGION 'TcoMyFirstSkillSampleUseCase implementation'}
procedure TcoMyFirstSkillSampleUseCase.CellConstruction;
begin
  inherited;
  fInteger := C_FIRST_SKILL_SAMPLE_INTEGER;

  // construct a new skill interface and implemented in the cell of siFirstSkill
  fsiFirstSkill := ConstructNewCellAs<IsiMyFirstSkillSampleV1>(TsiMyFirstSkillSampleV1,'FirstSkill');

  // setzte Execute Porcedure für die Skill Interface Methode siMyFirstInteger
  fsiFirstSkill.siGetSubCell('siMyInteger').siOnRead := OnGetMyInteger;
  fsiFirstSkill.siGetSubCell('siMyInteger').siOnWrite := OnSetMyInteger;
end;

procedure TcoMyFirstSkillSampleUseCase.OnGetMyInteger(const aSender : IsiCellObject);
var
  vMyInteger : IsiInteger;
begin
  Assert( isValidAs<IsiInteger>( aSender, vMyInteger),
   'Invalid sender of OnGetMyInteger' );

  // the call of OnRead write the siMyInteger value (sender as IsiInteger) with internal integer
  vMyInteger.siAsInteger := fInteger;
end;

procedure TcoMyFirstSkillSampleUseCase.OnSetMyInteger(const aSender : IsiCellObject);
var
  vMyInteger : IsiInteger;
begin
  Assert( isValidAs<IsiInteger>( aSender, vMyInteger),
   'Invalid sSender or no IsiInteger in OnSetMyInteger' );

  // the call of OnWrite write the internal integer with siMyInteger value (Sender as IsiInteger)
  fInteger := vMyInteger.siAsInteger
end;

{$ENDREGION}

{$REGION 'TsiSecondSkillSampleV1 implementation'}
procedure TsiSecondSkillSampleV1.CellConstruction;
begin
  inherited;
  // construct the skill method: function siSize: Byte
  fsiSize := ConstructNewCellAs<IsiInteger>(TcoInteger,'siSize');

  // construct the skill method: function siBit(const aBit : Byte) : Boolean
  fsiBit := ConstructNewCellAs<IsiBoolean>(TcoBoolean,'siBit');
  fsiBitAIndex := ConstructNewCellAs<IsiInteger>(TcoInteger,'siBit/aIndex');

  // construct the skill method: property  siInteger : Integer (read/write)
  fsiInteger := ConstructNewCellAs<IsiInteger>(TcoInteger,'siInteger');

  // construct the skill method: procedure siInc
  fsiInc := ConstructNewCell('siInc');

end;

function TsiSecondSkillSampleV1.siSize: Byte;
begin
  Result := fsiSize.siAsInteger;
end;

function TsiSecondSkillSampleV1.siBit(const aIndex : Byte) : Boolean;
begin
  fsiBitAIndex.siAsInteger := aIndex;
  Result := fsiBit.siAsBoolean;
end;

function TsiSecondSkillSampleV1.siGetInteger : Integer;
begin
  Result := fsiInteger.siAsInteger;
end;

procedure TsiSecondSkillSampleV1.siSetInteger(const aValue : Integer);
begin
  fsiInteger.siAsInteger := aValue;
end;

procedure TsiSecondSkillSampleV1.siInc;
begin
  fsiInc.siCall;
end;

{$ENDREGION}

{$REGION 'TcoUseConnectedSkillSample implementation'}
procedure TcoUseConnectedSkillSample.CellConstruction;
var vIntCell : IsiInteger;
    vCell : IsiCellObject;
begin
  inherited;
  // set the default values
  fInteger := C_FIRST_SKILL_SAMPLE_INTEGER;

  // construct the first skill interface FirstSkill
  fsiFirstSkill := ConstructNewCellAs<IsiMyFirstSkillSampleV1>(TsiMyFirstSkillSampleV1,'FirstSkill');

  // beispielhaft verwendet siMyInteger eine interne Integer Variable,
  // fMyIntegerProc wird aufgerufen, um den Inhalt zwischen der Zelle und der Variable
  // zu synchronisieren
  Assert( siFindCell( 'FirstSkill/siMyInteger', @vCell),
    'Invalid construction of method cell FirstSkill/siMyInteger');
  vCell.siOnRead := OnGetMyInteger;
  vCell.siOnWrite := OnSetMyInteger;

  // construct the second skill interface SecondSkill
  fsiSecondSkill := ConstructNewCellAs<IsiSecondSkillSampleV1>(TsiSecondSkillSampleV1,'SecondSkill');

  // die Methoden Zelle siSize von MySecondSkill ist eine Integerzelle,
  // Sie übernimmt auch die Funktion als Speicerstelle für die Size,
  // damit wird keine eigene Zell-Procedure zur Speicherung benötigt
  // der Default Wert wird der IntegerZelle vorgegeben,
  //   fsiSecondSkillSample.siSize := C_SECOND_SKILL_SAMPLE_SIZE;
  // --> Da siSize keine write Rechte hat, muss jedoch die Zelle angesprochen werden
  Assert( siFindCell('SecondSkill/siSize', IsiInteger, @vIntCell),
   'SecondSkill/siSize is unvalid IsiInteger');
  vIntCell.siAsInteger := C_SECOND_SKILL_SAMPLE_SIZE; // set the default of size

  // set the cell procedures for the skill methods of SecondSkill
  SecondSkill.siGetSubCell('siBit').siOnRead := OnGetBit;
  SecondSkill.siGetSubCell('siInteger').siOnRead := OnGetInteger;
  SecondSkill.siGetSubCell('siInteger').siOnWrite := OnSetInteger;
  SecondSkill.siGetSubCell('siInc').siOnRead := OnInc;

end;

procedure TcoUseConnectedSkillSample.OnGetMyInteger(const aSender : IsiCellObject);
begin
  // Skill interface:     FirstSkill
  // Skill method:        function siGetMyInteger : integer;
  // Skill method cell:   FirstSkill/siMyInteger

  // bevor der Getter von siMyInteger ausgelesen wird, wird er mit fInteger beschrieben
  FirstSkill.siMyInteger := fInteger;
end;

procedure TcoUseConnectedSkillSample.OnSetMyInteger(const aSender : IsiCellObject);
begin
  // Skill interface:     FirstSkill
  // Skill method:        procedure siSetMyInteger (const aInteger : integer);
  // Skill method cell:   FirstSkill/siMyInteger

  // nachdem der Setter von siMyInteger geschrieben wurde, wird der Wert in fInteger geschrieben
  fInteger := FirstSkill.siMyInteger;
end;

procedure TcoUseConnectedSkillSample.OnGetBit(const aSender : IsiCellObject);
var
  vBit : IsiBoolean;
  vIndex : IsiInteger;
begin
  // Skill interface:     SecondSkill
  // Skill method:        function siBit(const aIndex : Byte) : integer;
  // skill method cell:   SecondSkill/siBit

  // aSender is SecondSkill/siBit as Type IsiBoolean;
  Assert( IsValidAs<IsiBoolean>( aSender, vBit), 'aSender is not a boolean cell');

  // vBit is now SecondSkill/isBit as IsiBoolean

  // SecondSkill/siBit/aIndex is the Parameter (const aIndex : Byte) of siBit
  Assert( IsValidAs<IsiInteger>( vBit.siGetSubCell('aIndex'), vIndex),
    'Invalid SecondSkill/aIndex in OnGetBit');

  // check aIndex is smaller then value of Skill-Method SecondSkill/siSize
  if vIndex.siAsInteger < SecondSkill.siSize then
    // the Result from SecondSkill/siBit is the masked integer value
    vBit.siAsBoolean := (fInteger and (1 shl vIndex.siAsInteger)) > 0
  else
    vBit.siAsBoolean :=False;

end;

procedure TcoUseConnectedSkillSample.OnGetInteger(const aSender : IsiCellObject);
begin
  // Skill interface:     SecondSkill
  // Skill method:        function siInteger : integer;
  // Skill method cell:   SecondSkill/siInteger

  // siGetInteger of skill interface SecondSkill are called or value of method
  // cell Second/siInteger is in reading

  Assert( isValid( SecondSkill ), 'Unvalid SecondSkill in OnGetInteger' );

  // set the skill method cell (secondSkill/siInteger) masked by size to internal integer
  SecondSkill.siInteger := fInteger and ((1 shl SecondSkill.siSize) - 1);
end;

procedure TcoUseConnectedSkillSample.OnSetInteger(const aSender : IsiCellObject);
begin
  // Skill interface:     SecondSkill
  // Skill method:        procedure siInteger(const aInteger : integer);
  // Skill method cell:   SecondSkill/siInteger

  // siSetInteger of skill interface SecondSkill are called or value of method
  // cell Second/siInteger is in writing

  Assert( isValid( SecondSkill ), 'Unvalid SecondSkill in OnSetInteger' );

  // --> set internal integer masked with siSize
  fInteger := SecondSkill.siInteger and ((1 shl SecondSkill.siSize) - 1);
end;


procedure TcoUseConnectedSkillSample.OnInc(const aSender : IsiCellObject);
begin
  // Skill interface:     SecondSkill
  // Skill method:        procedure siInk;
  // Skill method cell:   SecondSkill/siInk

  // siInc of skill interface SecondSkill are called or
  // method cell SecondSkill/siInk siCall are called or value (siGetValue) is in reading

  Inc(fInteger); // increment internal integer
end;
{$ENDREGION}

{$REGION 'TcoDeposedSkillSample implemenation - Deposed interface sample'}
procedure TcoDeposedSkillSample.CellConstruction;
begin
  inherited;

  // set the default values
  fInteger := C_FIRST_SKILL_SAMPLE_INTEGER;

  // construct the skill method structure: function siSize: Byte
  fsiSize := ConstructNewCellAs<IsiInteger>(TcoInteger,'siSize');
  fsiSize.siAsInteger := C_SECOND_SKILL_SAMPLE_SIZE; // default value of Size

  // construct the skill method structure: function siBit(const aBit : Byte) : Boolean
  fsiBit := ConstructNewCellAs<IsiBoolean>(TcoBoolean,'siBit');
  fsiBitAIndex := ConstructNewCellAs<IsiInteger>(TcoInteger,'siBit/aIndex');

  // construct the skill method structure: property  siInteger : Integer (read/write)
  fsiInteger := ConstructNewCellAs<IsiInteger>(TcoInteger,'siInteger');

  // construct the skill method structure: procedure siInc
  fsiInc := ConstructNewCell('siInc');
end;

function TcoDeposedSkillSample.siSize: Byte;
begin
  Result := fsiSize.siValue.AsType<Byte>;
end;

function TcoDeposedSkillSample.siBit(const aIndex : Byte) : Boolean;
begin
  // check aIndex is smaller then value of Skill-Method siSize (cell)
  if aIndex < fsiSize.siAsInteger then
    // the Result from SecondSkill/siBit is the masked integer value
    result := (fInteger and (1 shl aIndex)) > 0
  else
    result :=False;
end;

function TcoDeposedSkillSample.siGetInteger : Integer;
begin
  Result := fInteger and ((1 shl fsiSize.siAsInteger) - 1);
end;

procedure TcoDeposedSkillSample.siSetInteger(const aValue : Integer);
begin
  fInteger := aValue and ((1 shl fsiSize.siAsInteger) - 1);
end;

procedure TcoDeposedSkillSample.siInc;
begin
  inc(fInteger);
end;

procedure TcoDeposedSkillSample.OnGetBit(const aSender : IsiCellObject);
begin
  fsiBit.siAsBoolean := siBit(fsiBitAIndex.siAsInteger);
end;

procedure TcoDeposedSkillSample.OnGetInteger(const aSender : IsiCellObject);
begin
  fsiInteger.siAsInteger := siInteger;
end;

procedure TcoDeposedSkillSample.OnSetInteger(const aSender : IsiCellObject);
begin
  siInteger := fsiInteger.siAsInteger;
end;

procedure TcoDeposedSkillSample.OnInc(const aSender : IsiCellObject);
begin
  siInc;
end;

{$ENDREGION}

{$REGION 'TcoUseDeposedSkillSample implementation - User sample for deposed skill cell'}
procedure TcoUseDeposedSkillSample.CellConstruction;
begin
  inherited;
  // construct the second skill interface SecondSkill
  fsiSecondSkill := ConstructNewCellAs<IsiSecondSkillSampleV1>(TcoDeposedSkillSample,'SecondSkill');
end;
{$ENDREGION}


end.
