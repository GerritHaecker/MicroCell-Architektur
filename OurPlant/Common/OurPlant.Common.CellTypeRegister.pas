// *****************************************************************************
//
//                            OurPlant OS
//                       Micro Cell Architecture
//                             for Delphi
//                            2019 / 2020
//
// Copyright (c) 2019-2020 Gerrit H�cker
// Copyright (c) 2019-2020 H�cker Automation GmbH
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
// *****************************************************************************

{-------------------------------------------------------------------------------


   Das Zell-Klassen-Register registriert alle Zellen (Klassen) �ber die
   RTTI Attributf�higkeit. Voraussetzung f�r die Registrierung ist der Eintrag
   [RegisterCellObject] an erster Stelle (vor der Klassendefinition notwendig).


-------------------------------------------------------------------------------}

unit OurPlant.Common.CellTypeRegister;

interface

{$REGION 'uses'}
uses
  OurPlant.Common.CellObject,
  OurPlant.Common.TypesAndConst,
  OurPlant.Common.DataCell,
  System.Rtti,
  System.SysUtils;
{$ENDREGION}

type
  {$REGION 'IsiCellTypeRegister - cell type register (ctr) Skill-Interface'}
  /// <summary>
  /// Skill interface for Cell Type Register of Cell Discovery Manager
  /// </summary>
  IsiCellTypeRegister = interface(IsiCellObject)
  ['{23572DE8-740B-4805-BE2E-EFBC4B89CF95}']
    /// <summary>
    ///  Fetches the first cell whose GUID matches aGuid.
    /// </summary>
    function siGetSubCell(const aGuid: TGuid): IsiCellObject; overload;
    /// <summary>
    ///  Fetches the cell whose contained class matches aCellClass.
    /// </summary>
    function siGetSubCell(const aCellClass: TCellClass): IsiCellObject; overload;

    /// <summary>
    ///   Add a new cell type in the register and get the register entry as
    ///   IsiCellObject
    /// </summary>
    /// <param name="aCellClass">
    ///   cell class as TCellClass (class of TCellObject)
    /// </param>
    /// <param name="aTypeName">
    ///   cell type name
    /// </param>
    /// <param name="aTypeGuid">
    ///   cell type GUID
    /// </param>
    /// <returns>
    ///   get the cell type register entry as IsiCellObject
    /// </returns>
    function siAddNewCellType( const aCellClass : TCellClass;
      const aTypeName : string; const aTypeGuid : TGUID): IsiCellObject;

    /// <summary>
    ///   Build a new cell over cell type GUID, search the GUID in the cell
    ///   type register and get the reference of the new cell as IsiCellObject
    /// </summary>
    function siBuildNewCell(const aGuid: TGuid; const aCellName: string = '') : IsiCellObject; overload;
    /// <summary>
    ///   Build a new cell over cell type name, search the name in the cell
    ///   type register and get the reference of the new cell as IsiCellObject.
    /// </summary>
    function siBuildNewCell(const aTypeName: string; const aCellName: string = '') : IsiCellObject; overload;

  end;
  {$ENDREGION}

  {$REGION 'TcoCellTypeRegister - cell type register of cell discovery manager'}
  /// <summary>
  ///   cell object for cell type register implement IsiCellTypeRegister. The
  ///   cell type register is a system cell of discovery manager.
  /// </summary>
  [RegisterCellType('Cell type register','{D93364D5-C2AC-4DC4-B4CA-4BA22FDD59B9}')]
  TcoCellTypeRegister = class(TCellObject, IsiCellTypeRegister)

  public
    /// <summary>
    ///  construction of cell content & structures and set defaults
    ///  Are called at the end of AfterConstruction of TCellobject. Derivate's
    ///  overrides this method to define and construct the cell structure and
    ///  settings.
    /// </summary>
    procedure CellConstruction; override;

  strict protected
    /// <summary>
    ///   Save the cell type register as info list in register.json.
    /// </summary>
    procedure siSave; override;

    /// <summary>
    ///   Fetches the first cell whose GUID matches aGuid.
    /// </summary>
    /// <param name="aGuid">
    ///   a cell type GUID
    /// </param>
    function siGetSubCell(const aGuid: TGuid): IsiCellObject; overload;
    /// <summary>
    ///   Fetches the cell whose contained class matches aCellClass.
    /// </summary>
    /// <param name="aCellClass">
    ///   a cell class as TCellClass (class of TCellObject)
    /// </param>
    function siGetSubCell(const aCellClass: TCellClass): IsiCellObject; overload;

    /// <summary>
    ///   Add a new cell type in the register and get the register entry as
    ///   IsiCellObject
    /// </summary>
    /// <param name="aCellClass">
    ///   cell class as TCellClass (class of TCellObject)
    /// </param>
    /// <param name="aTypeName">
    ///   cell type name
    /// </param>
    /// <param name="aTypeGuid">
    ///   cell type GUID
    /// </param>
    /// <returns>
    ///   get the cell type register entry as IsiCellObject
    /// </returns>
    function siAddNewCellType( const aCellClass : TCellClass;
      const aTypeName : string; const aTypeGuid : TGUID): IsiCellObject;

    /// <summary>
    ///   Build a new cell over cell type GUID, search the GUID in the cell
    ///   type register and get the reference of the new cell as IsiCellObject
    /// </summary>
    function siBuildNewCell(const aGuid: TGuid; const aCellName: string = '') : IsiCellObject; overload;
    /// <summary>
    ///   Build a new cell over cell type name, search the name in the cell
    ///   type register and get the reference of the new cell as IsiCellObject.
    /// </summary>
    function siBuildNewCell(const aTypeName: string; const aCellName: string = '') : IsiCellObject; overload;
  end;
  {$ENDREGION}

  {$REGION 'IsiRegisterEntry - Cell type register entry Skill-Interface in Release 1'}
  /// <summary>
  ///   Skill interface for Cell Type Register Entries of Cell Type Register
  ///   (for Discovery Manager)
  /// </summary>
  IsiRegisterEntry1 = interface(IsiCellClass)
  ['{9ECAF858-77B9-4F70-836D-A38CC941DAE4}']
    /// <summary>
    ///   Get the cell type GUID
    /// </summary>
    /// <returns>
    ///   the cell type GUID of entry cell
    /// </returns>
    function siGetGuid: TGuid;
    /// <summary>
    ///   Set the cell type GUID
    /// </summary>
    /// <param name="aGuid">
    ///   a cell type GUID
    /// </param>
    procedure siSetGuid(const aGuid:TGUID);
    /// <summary>
    ///   read / write cell type GUID
    /// </summary>
    property siGuid:TGUID read siGetGuid write siSetGuid;
  end;
  {$ENDREGION}

  {$REGION 'TcoCellTypeRegisterEntry - Cell Type Register Entry of Discovery Manager'}
  /// <summary>
  ///   The cell object for a cell type register entry is derived fro TcoCell
  ///   class as data cell object to hold a TCellClass as vlaue
  /// </summary>
  [RegisterCellType('Cell type entry','{0AE4F7B2-F8E2-4F14-942A-99D49AE48592}')]
  TcoCellTypeRegisterEntry = class(TcoCellClass, IsiRegisterEntry1)
  strict protected
    /// <summary>
    ///   contain then cell type GUID
    /// </summary>
    fCellGuid : TGuid;
  strict protected
    /// <summary>
    ///   Get the cell type GUID
    /// </summary>
    /// <returns>
    ///   the cell type GUID of entry cell
    /// </returns>
    function siGetGuid: TGuid;
    /// <summary>
    ///   Set the cell type GUID
    /// </summary>
    /// <param name="aGuid">
    ///   a cell type GUID
    /// </param>
    procedure siSetGuid(const aGuid:TGUID);
    /// <summary>
    ///   read / write cell type GUID
    /// </summary>
    property siGuid:TGUID read siGetGuid write siSetGuid;
  end;
  {$ENDREGION}

implementation

{$REGION 'uses'}
uses
  OurPlant.Common.DiscoveryManager,
  OurPlant.SkillInterface.DataManager,
  System.TypInfo;
{$ENDREGION}

{$REGION 'Cell Type Register implementation'}
procedure TcoCellTypeRegister.CellConstruction;
var
  vTypeList:    TArray<TRttiType>;
  vAttrList:    TArray<TCustomAttribute>;
  vTypeCounter: Integer;
  vAttrCounter: Integer;
  vType:        TRttiType;
  vClass:       TClass;
  vAttribute:   RegisterCellTypeAttribute;
  vEntry:       TcoCellTypeRegisterEntry;
begin
  inherited;

  // this cell ge now content to controller as subcell (own data saving)
  siIndependentCell; // eigene Speicherung, nicht als sub cell content speichern

  // fish all registred cell object classes from RTTI context and construct the
  // cell type register as sub list
  vTypeList := RootSkill<IsiRTTI>.siRTTI.GetTypes;
  for vTypeCounter := 0 to High(vTypeList) do
  begin
    vType:= vTypeList[vTypeCounter];

    if (vType.TypeKind = tkClass) then
    begin

      vClass := System.TypInfo.GetTypeData(vType.Handle)^.ClassType;

      if vClass.InheritsFrom(TCellObject) then
        if FindAttribute<RegisterCellTypeAttribute>(vType, vAttribute) then
          siAddNewCellType( TCellClass(vClass), vAttribute.TypeName, vAttribute.TypeGuid);
    end;
  end;
end;


procedure TcoCellTypeRegister.siSave;
begin
  RootSkill<IsiDataManager1>.siSaveCellJSONContent( Self, 'register.json');

  // siSave wird eigentlich nicht weiter gebraucht, da es nur zur Info gespeichert wird
  // inherited siSave;
end;


function TcoCellTypeRegister.siGetSubCell(const aGuid: TGuid): IsiCellObject;
var
  vCount: Integer;
  vEntry: IsiRegisterEntry1;
begin
  Result := nil;

  for vCount := 0 to High(fSubCells) do

    if IsValidAs<IsiRegisterEntry1>( fSubCells[vCount], vEntry) and
     (vEntry.siGuid = aGuid) then

      Exit(fSubCells[vCount]);
end;

function TcoCellTypeRegister.siGetSubCell(const aCellClass: TCellClass): IsiCellObject;
var
  vCount: Integer;
  vEntry: IsiRegisterEntry1;
begin
  Result := nil;

  for vCount := 0 to High(fSubCells) do

    if IsValidAs<IsiRegisterEntry1>( fSubCells[vCount], vEntry) and
     (vEntry.siAsClass = aCellClass) then

      Exit(fSubCells[vCount]);
end;

function TcoCellTypeRegister.siAddNewCellType(const aCellClass : TCellClass;
 const aTypeName : string; const aTypeGuid : TGUID): IsiCellObject;
var
  vEntry: IsiRegisterEntry1;
begin
  if IsValidAs<IsiRegisterEntry1>( siAddNewSubCell( TcoCellTypeRegisterEntry, aTypeName), vEntry) then
  begin
    vEntry.siGuid := aTypeGuid;
    vEntry.siAsClass := aCellClass;
  end;
end;


function TcoCellTypeRegister.siBuildNewCell(const aGuid: TGuid; const aCellName: string = '') : IsiCellObject;
var
  vEntry: IsiRegisterEntry1;
begin
  if IsValidAs<IsiRegisterEntry1>( siGetSubCell(aGuid), vEntry) and
   (vEntry.siAsClass.InheritsFrom(TCellObject)) then

    Result:= vEntry.siAsClass.create(aCellName);
end;


function TcoCellTypeRegister.siBuildNewCell(const aTypeName: string; const aCellName: string = '') : IsiCellObject;
var
  vEntry: IsiRegisterEntry1;
begin
  if IsValidAs<IsiRegisterEntry1>( siGetSubCell(aTypeName), vEntry) and
   (vEntry.siAsClass.InheritsFrom(TCellObject)) then

    Result:= vEntry.siAsClass.create(aCellName);
end;

{$ENDREGION}

{$REGION 'Cell Type Register Entry implementation '}
function TcoCellTypeRegisterEntry.siGetGuid: TGuid;
begin
  Result := fCellGuid;
end;

procedure TcoCellTypeRegisterEntry.siSetGuid(const aGuid:TGUID);
begin
  fCellGuid:=aGuid;
end;


{$ENDREGION}


end.
