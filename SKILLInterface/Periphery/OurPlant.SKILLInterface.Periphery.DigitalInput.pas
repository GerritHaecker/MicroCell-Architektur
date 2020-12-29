// *****************************************************************************
//
//                       OurPlant OS Architecture
//                             for Delphi
//                                2019
//
// Copyrights 2019 @ Häcker Automation GmbH
// *****************************************************************************
unit OurPlant.SKILLInterface.Periphery.DigitalInput;

interface

{$REGION 'uses'}
uses
  OurPlant.Common.CellObject,
  OurPlant.Common.CellAttributes,
  OurPlant.Common.DataCell;
{$ENDREGION}

type
  {$REGION 'Skill interface IsiDigitalInput in Release 1'}
  /// <summary>
  ///   Skill interface for digital input periphery in Release 1
  /// </summary>
  IsiDigitalInput1 = interface(IsiCellObject)
    ['{690960A1-EF15-4C6C-9CEB-76C30181727C}']
    /// <summary>
    ///   Get size of Input channel bits
    /// </summary>
    function siSize: Byte;
    /// <summary>
    ///   read current bit status of input channel on abit
    /// </summary>
    function siBit(const aBit:Byte): Boolean;
    /// <summary>
    ///   read current value of input channel as Integer (signed long)
    /// </summary>
    function siInteger: Integer;
  end;
  {$ENDREGION}

  {$REGION 'integrated skill interface implementation object of TsiDigitalInput1'}
  /// <summary>
  ///   Skill interface implemenation object of IsiDigitalInput (Release V1)
  /// </summary>
  [RegisterCellType('digital input','{3018513D-066D-4BE4-A77C-96F61E1EF43A}')]
  TsiDigitalInput1 = class(TSkillInterfaceCell, IsiDigitalInput1)
  strict protected
    fsiSize : IsiInteger;
    fsiBit : IsiBoolean;
    fsiBitAIndex : IsiInteger;
    fsiInteger : IsiInteger;
  public
    procedure CellConstruction; override;
    {$REGION 'IsiDigitalInput1 interface implementation'}
    /// <summary>
    ///   Get size of Input channel in bit
    /// </summary>
    function siSize: Byte;
    /// <summary>
    ///   read current bit status of input channel on abit
    /// </summary>
    function siBit(const aIndex: Byte): Boolean;
    /// <summary>
    ///   read current value of input channel as Integer (signed long)
    /// </summary>
    function siInteger: Integer;
    {$ENDREGION}
  end;
  {$ENDREGION}

  {$REGION 'Deposed skill interface implementation object of TsiDigitalInput1'}
  /// <summary>
  ///   Skill interface implemenation object of IsiDigitalInput (Release V1)
  /// </summary>
  [RegisterCellType('digital input (deposed)','{3018513D-066D-4BE4-A77C-96F61E1EF43A}')]
  TcoDigitalInput1 = class(TSkillInterfaceCell, IsiDigitalInput1)
  strict protected
    fsiSize : IsiInteger;            // skill method cell siSize
    fsiBit : IsiBoolean;             // skill method cell siBit
    fsiBitAIndex : IsiInteger;       // skill method parameter cell siSize/aIndex
    fsiInteger : IsiInteger;         // skill method cell siInteger

  public
    /// <summary>
    ///   Construct the cell structure during after construction. This method
    ///   override the virtual method of TCellObject.
    /// </summary>
    procedure CellConstruction; override;
    {$REGION 'IsiDigitalInput1 interface implementation'}
    /// <summary>
    ///   Get size of Input channel in bit
    /// </summary>
    function siSize: Byte; virtual; abstract;
    /// <summary>
    ///   read current bit status of input channel on abit
    /// </summary>
    function siBit(const aIndex: Byte): Boolean; virtual; abstract;
    /// <summary>
    ///   read current value of input channel as Integer (signed long)
    /// </summary>
    function siInteger: Integer; virtual; abstract;
    {$ENDREGION}
  private
    {$REGION 'IsiDigitalInput1 skill method cell procedures'}
    // siSize
    procedure OnGetSize(const aSender : IsiCellObject);
    // siBit
    procedure OnGetBit(const aSender : IsiCellObject);
    // siInteger
    procedure OnGetInteger(const aSender : IsiCellObject);
    {$ENDREGION}
  end;
  {$ENDREGION}


implementation

{$REGION 'uses'}
uses
  System.SysUtils;
{$ENDREGION}

const
{$REGION 'DEFAULT CONSTANTES'}
  C_DEFAULT_SIZE      = 1;
  C_DEFAULT_BIT       = False;
  C_DEFAULT_BIT_INDEX = 0;
  C_DEFAULT_INTEGER   = 0;
{$ENDREGION}

{$REGION 'TsiDigitalInput1 integrated skill cell implementation'}
procedure TsiDigitalInput1.CellConstruction;
begin
  inherited;

  // construct the skill method structure: function siSize: Byte
  fsiSize := ConstructNewCellAs<IsiInteger>(TcoInteger,'siSize');
  fsiSize.siAsInteger := C_DEFAULT_SIZE;

  // construct the skill method structure: function siBit(const aBit : Byte) : Boolean
  fsiBit := ConstructNewCellAs<IsiBoolean>(TcoBoolean,'siBit');
  fsiBit.siAsBoolean := C_DEFAULT_BIT;

  fsiBitAIndex := ConstructNewCellAs<IsiInteger>(TcoInteger,'siBit/aIndex');
  fsiBitAIndex.siAsInteger := C_DEFAULT_BIT_INDEX;

  // construct the skill method structure: property  siInteger : Integer (read/write)
  fsiInteger := ConstructNewCellAs<IsiInteger>(TcoInteger,'siInteger');
  fsiInteger.siAsInteger := C_DEFAULT_INTEGER;

end;

function TsiDigitalInput1.siSize: Byte;
begin
  Result := fsiSize.siAsInteger;
end;

function TsiDigitalInput1.siBit(const aIndex : Byte): Boolean;
begin
  fsiBitAIndex.siAsInteger := aIndex;
  Result := fsiBit.siAsBoolean;
end;

function TsiDigitalInput1.siInteger: Integer;
begin
  Result := fsiInteger.siAsInteger;
end;
{$ENDREGION}

{$REGION 'TcoDigitalInput1 deposed skill cell implementation'}
procedure TcoDigitalInput1.CellConstruction;
begin
  inherited;

  // construct the skill method structure: function siSize: Byte
  fsiSize := ConstructNewCellAs<IsiInteger>(TcoInteger,'siSize');
  fsiSize.siOnRead := OnGetSize;

  // construct the skill method structure: function siBit(const aBit : Byte) : Boolean
  fsiBit := ConstructNewCellAs<IsiBoolean>(TcoBoolean,'siBit');
  fsiBit.siOnRead := OnGetBit;

  // construct the skill method structure: property  siInteger : Integer
  fsiInteger := ConstructNewCellAs<IsiInteger>(TcoInteger,'siInteger');
  fsiInteger.siOnRead := OnGetInteger;

end;

{ abstract method definition

function TcoDigitalInput1.siSize: Byte;
begin
  Result := C_DEFAULT_SIZE;
end;

function TcoDigitalInput1.siBit(const aIndex : Byte): Boolean;
begin
  Result := C_DEFAULT_BIT;
end;

function TcoDigitalInput1.siInteger: Integer;
begin
  Result := C_DEFAULT_INTEGER;
end;}

procedure TcoDigitalInput1.OnGetSize(const aSender : IsiCellObject);
begin
  fsiSize.siAsInteger := siSize;
end;

procedure TcoDigitalInput1.OnGetBit(const aSender : IsiCellObject);
begin
  fsiBit.siAsBoolean := siBit(fsiBitAIndex.siAsInteger);
end;

procedure TcoDigitalInput1.OnGetInteger(const aSender : IsiCellObject);
begin
  fsiInteger.siAsInteger := siInteger;
end;

{$ENDREGION}


initialization
  TsiDigitalInput1.RegisterExplicit;

end.
