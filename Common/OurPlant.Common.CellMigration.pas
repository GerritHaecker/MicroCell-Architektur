// *****************************************************************************
//
//                       OurPlant OS Architecture
//                             for Delphi
//                                2019
//
// Copyrights 2019 @ Häcker Automation GmbH
// *****************************************************************************
unit OurPlant.Common.CellMigration;

interface

uses
  OurPlant.Common.CellObject,
  MPKomponenten, MPCANKomponente,
  System.SysUtils;

type

{$REGION 'Migration cell object TcoKomItem'}
  /// <summary>
  ///   Migration class for cell objects support KomItem and cell object
  /// </summary>
  TcoKomItem = class(TKomItem,IsiCellObject)
  strict protected
    {$REGION 'TsiCellObject Privat and protected region'}
    fController : IsiCellObject; // Controller Cell object interface
    fCellObjectSubCellControl: TCellObjectSubCellControl;
    fBaseName   : string;        // base name of Cell object or skill interface type
    fLogName    : string;        // logical name = fBaseName + number
    fCellGuid   : TGuid;         // GUID of Cell Instance
    fTag        : Integer;       // Integer Cell for Tag
    {$ENDREGION}
  public
    {$REGION 'TCellObject Operations'}
    /// <summary>
    ///   <para>
    ///     Constructor create the KomItem migration cell object instance
    ///   </para>
    ///   <para>
    ///     Set Controller to coDiscoveryManager and add the cell object into
    ///     the sub cell list of Discovery Manager
    ///   </para>
    /// </summary>
    /// <param name="CreateName">
    ///   IdName from old class KomItem
    /// </param>
    /// <param name="CreateOwner">
    ///   The KomList from old architecture
    /// </param>
    /// <remarks>
    ///   AfterConstruction add the cell object in the sub cell list of
    ///   Discovery Manager
    /// </remarks>
    constructor Create(const CreateName: string; const CreateOwner: TKomList); overload;
    /// <summary>
    ///   <para>
    ///     Function behind construction of Object instance.
    ///   </para>
    ///   <para>
    ///     Create and set up all intern variables and lists
    ///   </para>
    /// </summary>
    procedure AfterConstruction; override;
    /// <summary>
    ///   <para>
    ///     Function before destruction of Object instance.
    ///   </para>
    ///   <para>
    ///     clear list
    ///   </para>
    /// </summary>
    procedure BeforeDestruction; override;
    {$ENDREGION}
    {$REGION 'IsiCellObject Getters'}
    /// <summary>
    ///   Return the controller as cell object interface
    ///   Get the founder and can be find back the way to the root
    /// </summary>
    function siGetController:IsiCellObject;
    /// <summary>
    ///   Return the common skill interface name of cell object or skill interface
    ///   reference
    /// </summary>
    function siGetSkillName:string; virtual;
    /// <summary>
    ///   Return the logical Name of the cell object instance
    ///   reference
    /// </summary>
    function siGetLogName:string; virtual;
    /// <summary>
    ///   Return the Name space of the cell object instance behind the interface
    ///   reference
    /// </summary>
    function siGetLongName:string; virtual;
    /// <summary>
    ///   <para>
    ///     Return the tag number of the cell object instance behind the
    ///     interface reference
    ///   </para>
    ///   <para>
    ///     The Tag number is free for use and will setting in
    ///     siCellObjectSetTag
    ///   </para>
    /// </summary>
    function siGetTag:Integer; virtual;
    /// <summary>
    ///  Returns GUID object of the instance behind the interface reference.
    /// </summary>
    /// <remarks>
    ///  This is used to uniquely identify individual cells. GUID is set after creation of an
    ///  instance.
    /// </remarks>
    function siGetCellGuid: TGuid; virtual;
    /// <summary>
    ///   Return the Status read to use (in process) of skill interface
    ///   reference and / or cell object instance
    /// </summary>
    function siGetReadyToUse: Boolean; virtual;
    {$ENDREGION}
    {$REGION 'IsiCellObject Setters'}
    /// <summary>
    ///   Set the logical Name of the cell object instance
    ///  Name + [Base Name]
    /// </summary>
    /// <param name="aName">
    ///   The logical name of cell object instance
    /// </param>
    procedure siSetLogNameFree(const aName:string);  virtual;
    /// <summary>
    ///   Set the locical name of the cell object instance
    ///  Base Name + number (count the Interfaces of Sub cell list)
    /// </summary>
    /// <param name="aName">
    ///   The base of name of cell object interface
    /// </param>
    procedure siSetLogNameOfInterface(const aInterface:TGuid); virtual;
    /// <summary>
    ///   <para>
    ///     set the tag number of the cell object instance behind the
    ///     interface reference
    ///   </para>
    ///   <para>
    ///     The Tag number is free for use and will setting in
    ///     siCellObjectSetTag
    ///   </para>
    /// </summary>
    procedure siSetTag(aValue:Integer); virtual;
    {$ENDREGION}
    {$REGION 'Cub Cell List control'}
    function siSubCell: TCellObjectSubCellControl;
    {$ENDREGION}
  end;
{$ENDREGION}

{$REGION 'Migration cell object TcoCANItem'}
  /// <summary>
  /// Migration class for cell objects support TCANItem (TInterfacedCANItem)
  /// and cell object
  /// </summary>
  TcoCANItem = class(TCANItem)
  end;
{$ENDREGION}


implementation

uses
  OurPlant.Common.DiscoveryManager,
  OurPlant.Common.DataCell,
  PPSprache;

const
  C_DEFAULT_CELL_TAG = 0;

{$REGION 'TcoKomItem implementation'}
constructor TcoKomItem.Create(const CreateName: string; const CreateOwner: TKomList);
begin
  inherited Create(CreateName,CreateOwner); // Anbindung an das alte System
  // Standardmäßig setze Controller auf coDiscoveryManager
  fController:=coDiscoveryManager;
end;

procedure TcoKomItem.AfterConstruction;
begin
  inherited;
  fCellObjectSubCellControl:= TCellObjectSubCellControl.Create(Self); // Sub Cell Controller

  // wenn aController gültig, dann trage dich automatisch in die Liste des Controllers ein
  // Create führt mit zugeordneten Controller ein AddCell im Controller aus!
  // bei Aufruf von create() wird der coDiscoveryManager als Controller zugeordnet
  if Assigned(fController) then
  begin
    fLogName:=IntToStr(siGetController.siSubCell.GetCount);
    siGetController.siSubCell.AddCell(Self as IsiCellObject);
  end;

  // vergibt erstmal eine neue GUID
  CreateGuid(fCellGuid);

  fLogName:= siGetSkillName+fLogName;

end;

procedure TcoKomItem.BeforeDestruction;
begin
  fCellObjectSubCellControl.destroy;
  inherited;
end;

function TcoKomItem.siGetController:IsiCellObject;
begin
  Result:=fController;
end;

function TcoKomItem.siGetSkillName:string;
begin
  // im generischen TcoKomItem ist der Name unklar und muss später noch überschrieben werden
  Result:=Sprache.ItemDef(8610, 'Modul');
end;

function TcoKomItem.siGetLogName:string;
begin
  Result:=IDName;  // Übernehme Namen aus KomItem
end;

function TcoKomItem.siGetLongName:string;
begin
  Result:=IDName;     // muss noch angepasst werden !!!
end;

function TcoKomItem.siGetTag:Integer;
begin
  Result:=fTag;
end;

function TcoKomItem.siGetCellGuid: TGuid;
begin
  Result := fCellGuid;
end;

function TcoKomItem.siGetReadyToUse: Boolean;
begin
  Result:=ProzessBereitschaft;
end;


procedure TcoKomItem.siSetLogNameFree(const aName:string);
begin
  IDName:=aName;           // BaseName und LogName wieder einführen
end;

procedure TcoKomItem.siSetLogNameOfInterface(const aInterface:TGuid);
begin
  //fLogName:=fBaseName+' '+IntToStr(siCellObjectSubCell.GetCountOfInterface(aInterface)+1);
end;

procedure TcoKomItem.siSetTag(aValue:Integer);
begin
  fTag:=aValue;
end;

function TcoKomItem.siSubCell:TCellObjectSubCellControl;
begin
  Result:=fCellObjectSubCellControl;
end;
{$ENDREGION}

{$REGION 'TcoCANItem implementation'}
{$ENDREGION}



end.
