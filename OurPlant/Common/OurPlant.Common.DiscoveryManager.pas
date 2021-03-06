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

unit OurPlant.Common.DiscoveryManager;

interface

{$REGION 'uses'}
uses
  OurPlant.Common.CellObject,
  OurPlant.Common.CellTypeRegister,
  OurPlant.Common.LinkPlaceHolder,
  OurPlant.Common.DataCell,
  OurPlant.Common.TypesAndConst,
  OurPlant.SKILLInterface.DataManager,
  System.Rtti,
  System.SysUtils;
{$ENDREGION}

type
  {$REGION 'IsiDiscoveryManager - Cell Discovery Manager Skill-Interface'}
  /// <summary>
  /// Skill interface for Cell Discovery Manager
  /// </summary>
  IsiDiscoveryManager = interface(IsiCellObject)
  ['{E3F35ABC-B03F-49ED-9CF9-C4AA47DA857D}']
    /// <summary>
    ///   Get the skill interface reference for (main) data manager of discovery manger
    /// </summary>
    function siGetDataManager : IsiDataManager1;
    /// <summary>
    ///   Set the skill interface reference for (main) data manager of discovery manger
    /// </summary>
    procedure siSetDataManager( const aDataManager : IsiDataManager1);
    /// <summary>
    ///   Set and get the data manager cell of discovery manger
    /// </summary>
    property siDataManager : IsiDataManager1 read siGetDataManager write siSetDataManager;

    /// <summary>
    ///   Save the discovery manger content and sub cells (with sub cell
    ///   content flag). Start the main data manager with system file name and
    ///   start the siSave method in all sub cells.
    /// </summary>
    procedure siSaveSystem( const aName : string = '');
    /// <summary>
    ///   Restore the discovery manger content and sub cells (with sub cell
    ///   content flag). Start the main data manager with system file name and
    ///   start the siRestore method in all sub cells.
    /// </summary>
    procedure siRestoreSystem( const aName : string = '');

  end;
  {$ENDREGION}

  {$REGION 'IsiRTTI - Real Time Type Information Skill-Interface'}
  IsiRTTI = interface(IsiCellObject)
  ['{166CDE1F-A422-42AF-BF79-0D418D77F9E2}']
    /// <summary>
    ///   Get the record of RTTI context (system method without skill method cell)
    /// </summary>
    function siRTTI : TRttiContext;
  end;
  {$ENDREGION}

  {$REGION 'TcoDiscoveryManager - Cell Discovery Manager'}
  /// <summary>
  ///  The Cell Object Discovery Manager is the root of all free Cell Object
  ///  Controll the List, give references about all instances
  ///  load und restore the system
  /// </summary>
  [RegisterCellType('Discovery manager','{B2C66E5D-F763-4E09-A8EE-EC4ABFFEF706}')]
  TcoDiscoveryManager = class(TCellObject, IsiDiscoveryManager, IsiRTTI, IsiDataManager1)
  public // commons
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
    ///  construction of cell content & structures and set defaults
    ///  Are called at the end of AfterConstruction of TCellobject. Derivate's
    ///  overrides this method to define and construct the cell structure and
    ///  settings.
    /// </summary>
    procedure CellConstruction; override;
    /// <summary>
    ///   <para>
    ///     Function before destruction of Object instance.
    ///   </para>
    ///   <para>
    ///     clear list
    ///   </para>
    /// </summary>
    procedure BeforeDestruction; override;

  strict protected
    /// <summary>
    ///   contains the common data manager as IsiDataManager1
    /// </summary>
    fDataManagerRef : IsiCellReference;
    /// <summary>
    ///   Contains the cell type register as IsiCellTypeRegister.
    /// </summary>
    fCellTypeRegister: IsiCellTypeRegister;
    /// <summary>
    ///   Contains the place holder manager as IsiPlaceHolderManager
    /// </summary>
    fPlaceHolderManager: IsiPlaceHolderManager;
    /// <summary>
    ///   Contains the open instance of RTTI context.
    /// </summary>
    fRTTIContext : TRttiContext;

  strict protected // implementations
    /// <summary>
    ///   Check the this cell is valid (under control). The discovery manager
    ///   is always valid.
    /// </summary>
    function siIsValid : Boolean; override;
    /// <summary>
    ///   Return NO string as the long name of cell discovery manager
    /// </summary>
    /// <example>
    ///   long name of digital input (Input 1) of sample module (Modul 1)
    ///   "Modul 1.Input1"
    /// </example>
    function siLongName:string; override;

    /// <summary>
    ///   Get the skill interface reference for (main) data manager of discovery manger
    /// </summary>
    function siGetDataManager: IsiDataManager1;
    /// <summary>
    ///   Set the skill interface reference for (main) data manager of discovery manger
    /// </summary>
    procedure siSetDataManager( const aDataManager : IsiDataManager1);
    /// <summary>
    ///   Set and get the data manager cell of discovery manger
    /// </summary>
    property siDataManager : IsiDataManager1 read siGetDataManager write siSetDataManager
     implements IsiDataManager1;

    /// <summary>
    ///   Save the discovery manger content and sub cells (with sub cell
    ///   content flag). Start the main data manager with system file name and
    ///   start the siSave method in all sub cells.
    /// </summary>
    procedure siSaveSystem( const aName : string = '');
    /// <summary>
    ///   Restore the discovery manger content and sub cells (with sub cell
    ///   content flag). Start the main data manager with system file name and
    ///   start the siRestore method in all sub cells.
    /// </summary>
    procedure siRestoreSystem( const aName : string = '');

    /// <summary>
    ///  Get the record of RTTI context (system method without skill method cell)
    ///  Implementation of IsiRTTI
    /// </summary>
    function siRTTI : TRttiContext;

  strict protected // OnAction Methoden der Skill Cells
    procedure OnSaveSystem( const aSender : IsiCellObject);
    procedure OnRestoreSystem( const aSender : IsiCellObject);
  end;
  {$ENDREGION}

implementation

{$REGION 'uses'}
uses
  OurPlant.Common.DataManager;
{$ENDREGION}

{$REGION 'Cell Discovery Manager implemenation'}
procedure TcoDiscoveryManager.AfterConstruction;
begin
  GetInterface(IsiCellObject,fRootCell); // schreibt die eigene Instanz gleich am Anfang in die class var

  // SYSTEM Methoden des Discovery Manager (Sonderbehandlung)
  fRTTIContext := TRttiContext.Create;

  fCellTypeRegister := ConstructNewCellAs<IsiCellTypeRegister>( TcoCellTypeRegister, 'TypeRegister');
  fPlaceHolderManager := ConstructNewCellAs<IsiPlaceHolderManager>( TcoPlaceHolderManager, 'PlaceHolderManager');

  // inherited muss hinter fInstance und Context stehen, da TCellObject darauf zugreift
  inherited;
end;

procedure TcoDiscoveryManager.CellConstruction;
begin
  inherited;
  // konstruiert die skill method siDataManger von IsiDiscoveryManager as IsiCellReference
  // die skill method siDataManager ist gleichzeitig auch die gespeichert Ref. vom
  // gew�hlten DataManagers, tr�gt danach als default einen neuen Standard Data Manager ein
  fDataManagerRef := ConstructNewCellAs<IsiCellReference>(TcoCellReference,'siDataManager');
  fDataManagerRef.siAsCell := ConstructNewCell( TcoStandardDataManager, 'StandardDataManager');

  // lege die Skill-Methode siSaveSystem + siSaveSystem/aName an und setzte
  with ConstructNewCell(TCellObject, 'siSaveSystem') do
  begin
    siConstructNewSubCell(TcoString, 'aName').siAsString := '';
    siOnRead := OnSaveSystem;
    siIndependentCell;
  end;

  // lege die Skill-Methode siRestoreSystem + siRestoreSystem/aName an und setzte
  with ConstructNewCell(TCellObject, 'siRestoreSystem') do
  begin
    siConstructNewSubCell(TcoString, 'aName').siAsString := '';
    siOnRead := OnRestoreSystem;
    siIndependentCell;
  end;
end;

procedure TcoDiscoveryManager.BeforeDestruction;
begin
  inherited;         // the destruction of field of DM should be the last
  fRTTIContext.free; // gebe den Rtti frei - Achtung: bei inherited BeforeDestruction wird er noch ben�tigt -- letzte Handlung
end;

function TcoDiscoveryManager.siIsValid : Boolean;
begin
  // siIsValid check that cell is valid, the DM is always valid, its the root
  result:= True;
end;

function TcoDiscoveryManager.siLongName:string;
begin
  // only the discovery manager is the root of all cells an send "OP:"
  Result:= C_LONGNAME_ROOT; // only the Discovery Manager return no long name on siLongName request
end;

function TcoDiscoveryManager.siGetDataManager: IsiDataManager1;
begin
  if not isValidAs<IsiDataManager1>(fDataManagerRef.siAsCell, Result) then
    raise Exception.Create(
     'No Data manager setted in siGetDataManager of DiscoveryManager');
end;

procedure TcoDiscoveryManager.siSetDataManager( const aDataManager : IsiDataManager1);
begin
  if IsValidAs<IsiDataManager1>( aDataManager ) then
    fDataManagerRef.siAsCell := aDataManager
  else
    raise Exception.Create( 'Invalid Data manager setting in siSetDataManager of DiscoveryManager' );
end;

procedure TcoDiscoveryManager.siSaveSystem( const aName : string = '');
begin
  siDataManager.siSaveCellJSONContent( Self, aName);
  siSave;
end;

procedure TcoDiscoveryManager.siRestoreSystem( const aName : string = '');
begin
  siDataManager.siRestoreCellJSONContent( Self, aName);

  if IsValid(fPlaceHolderManager) then
    fPlaceHolderManager.siReconstructLinks;

  siRestore;
end;

function TcoDiscoveryManager.siRTTI : TRttiContext;
begin
  Result := fRTTIContext;
end;

procedure TcoDiscoveryManager.OnSaveSystem( const aSender : IsiCellObject);
begin
  siSaveSystem( ValidCell( aSender.siGetSubCell('aName')).siAsString );
end;

procedure TcoDiscoveryManager.OnRestoreSystem( const aSender : IsiCellObject);
begin
  siRestoreSystem( ValidCell( aSender.siGetSubCell('aName')).siAsString );
end;

{$ENDREGION}

initialization
  TcoDiscoveryManager.RegisterExplicit;

end.
