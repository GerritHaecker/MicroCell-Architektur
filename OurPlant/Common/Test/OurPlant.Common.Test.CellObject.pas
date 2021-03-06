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
unit OurPlant.Common.Test.CellObject;

interface

uses
  {$IF CompilerVersion >= 28.0}System.Json,{$ENDIF}
  DUnitX.TestFramework,
  OurPlant.Common.CellObject,
  OurPlant.Common.CellTypeRegister,
  OurPlant.Samples.CellObject;

type
  [TestFixture]
  TCellObjectTests = class(TObject)
  strict private
    fMainCell: IsiCellObject;
  const
    C_MEMEORY_LEAK_TEST = false;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    [Category('Develop')]
    procedure TestDiscoveryManager;
    [Test]
    [Category('Develop')]
    procedure TestBasicMethods;
    [Test]
    [Category('Develop')]
    procedure TestLongName;
    [Test]
    [Category('Develop')]
    procedure TestCellTypeRegister;
    [Test]
    [Category('Develop')]
    procedure TestCellController;
    [Test]
    [Category('Develop')]
    procedure TestSubCellListByInterface;
    [Test]
    [Category('Develop')]
    procedure TestSubCellGetter;
    [Test]
    [Category('Develop')]
    procedure TestSubCellSetter;
    [Test]
    [Category('Develop')]
    procedure TestSubCellAddition;
    [Test]
    [Category('Develop')]
    procedure TestSubCellRemoval;
    [Test]
    [Category('Develop')]
    procedure TestCellDelete;
    [Test]
    [Category('Develop')]
    procedure TestSubCellNesting;
    [Test]
    [Category('Develop')]
    procedure TestSubCellMultiReferencing;
    [Test]
    [Category('Develop')]
    procedure ValueTester;
    [Test]
    [Category('Develop')]
    procedure BooleanCellTester;
    [Test]
    [Category('Develop')]
    procedure IntegerCellTester;
    [Test]
    [Category('Develop')]
    procedure FloatCellTester;
    [Test]
    [Category('Develop')]
    procedure StringCellTester;
    [Test]
    [Category('Develop')]
    procedure CellClassCellTester;
    [Test]
    [Category('Develop')]
    procedure CellReferenceTester;

    [Test]
    [Category('Develop')]
    procedure SkillInterfaceTester;

    [Test]
    [Category('Develop')]
    procedure SaveDataCellTester;
    [Test]
    [Category('Develop')]
    procedure RestoreDataCellTester;
  end;

implementation

uses
  OurPlant.Common.DiscoveryManager,
  OurPlant.SkillInterface.DataManager,
  OurPlant.Common.DataManager,
  OurPlant.Common.DataCell,
  OurPlant.Common.TypesAndConst,
  OurPlant.Samples.CellObjectSample1,
  OurPlant.Samples.SkillInterface,
  System.SysUtils,
  System.Rtti,
  Data.DBXJSON,
  REST.Json,
  Classes,
  System.TypInfo;

const
  C_MAIN_CELL_NAME = 'main cell';
  C_SUBCELL_COUNT  = 5;

{ TCellObjectTests }

procedure TCellObjectTests.Setup;
var
  I:     Integer;
begin
  ReportMemoryLeaksOnShutdown := C_MEMEORY_LEAK_TEST;

{ Mit dem erstmaligen Aufruf von SubSystemSample wird die Instanz des
  TcoSubSystemManagerSample erstellt. SubSystemSample ist  eine SubZelle des
  Discovery Managers. Unter ihm werden die Samples und Tests durchgef�hrt.
  fMainCell ist eine Instanz von TcoCellSample1
  mit dem Namen C_MAIN_CELL_NAME (siehe const) }

  // create a new instance of TcoCellSample1 (cell) with cell name C_MAIN_CELL_NAME ('main cell')
  // Add the new cell under sub system sample instance and save in fMainCell
  fMainCell:=TCellObject.root.siAddNewSubCell( TcoCellSample1, C_MAIN_CELL_NAME);

  // Build C_SUBCELL_COUNT (5) times under fMainCell
  for I := 0 to C_SUBCELL_COUNT - 1 do
    fMainCell.siAddNewSubCell( TCellObject, 'sub cell');

  System.Assert(C_SUBCELL_COUNT > 0);
end;

procedure TCellObjectTests.TearDown;
begin
  // entferne aus der Subzell-Liste des SubSystemSample die Zelle fMainCell
  TCellObject.root.siRemoveSubCell(fMainCell);

  // gebe auch fMainCell frei (nil -> instanceCount = 0 -> destroy)
  fMainCell := nil; { BeforeDestruction cleans up sub-cells. }
end;

procedure TCellObjectTests.TestDiscoveryManager;
var
  vCell: IsiCellObject;
  vSampleCell : IsiStandardInterfaceSample;
  vDataManager : IsiDataManager1;
begin
  { Der Discovery Manager ist die Wurzel und somit das Anfangselement einer
  �C Struktur. Er ist �ber die globale Variable "DiscoveryManager" systemweit
  ansprechbar. Insofern er noch nicht angelegt ist, wird er beim ersten Aufruf
  gestartet. Der Discovery Manager unterst�tzt immer das Interface "IsiDiscoveryManager".
  Dieses Interface ist von "IsiCellObject abgeleitet".}

  // die erste Pr�fung checkt, ab der globale DiscoveryManager das IsiDiscoveryManager Interface unterst�tzt.
  Assert.IsTrue( TCellObject.TryCellAs<IsiDiscoveryManager>( TCellObject.Root ),
   'Discovery manager is not assigned or has no IsiDiscoveryManager interface');

  // Suche eine Zelle "SubSystemSample" im DiscoveryManager
  vCell := TCellObject.Root.siGetSubCell( C_MAIN_CELL_NAME );
  Assert.IsTrue( Assigned(vCell),'Main cell not assigned in discovery manager');

  vCell := nil;

  // teste die RootAs Funktion die �ber TrySkillInterfaceOf und siSkillInterface
  // das Skill Interface IsiStandardInterfaceSample von MainCell liefert

  // Assert.IsTrue( TCellObject.TryRootAs<IsiStandardInterfaceSample>(vSampleCell),
  //  'The IsiStandardInterfaceSample of Main cell ar not delivered from root (discovery manager)');

  vSampleCell := TCellObject.RootSkill<IsiStandardInterfaceSample>;

  Assert.IsTrue( vSampleCell.siIsSame(fMainCell),
   'The delivered IsiStandardInterfaceSample cell is not the MainCell');

  // Suche eine Zelle "SubSystemSample/main cell" im DiscoveryManager
  Assert.IsTrue( TCellObject.Root.siFindCell( C_MAIN_CELL_NAME, @vCell),
    'Bad Result during try of find of main cell');
  Assert.IsTrue( Assigned( vCell ),'Main cell not assigned after siFindCell');

  // Teste das DataManager Interface, hole Reference von root names StandardDataManager
  vDataManager := TCellObject.CellAs<IsiDataManager1>( 'StandardDataManager');

  Assert.isTrue( TCellObject.RootSkill<IsiDataManager1>.siIsSame(vDataManager) ,
    'The first found root skill of IsiDataManager1 is not DataManager');

  Assert.isTrue( TCellObject.RootSkill<IsiDiscoveryManager>.siDataManager.siIsSame(vDataManager) ,
   'siGetDataManager of Disscovery manager is not the setted DataManager');

  Assert.isTrue(
   TCellObject.CellAs<IsiCellReference>( 'siDataManager').siAsCell.siIsSame(vDataManager),
   'The skill interface cell siDataManager get not the same DataManager' );

  // konstruiere einen neuen DataManager in fMainCell
  fMainCell.siConstructNewCell(TcoStandardDataManager, 'MyDataManager', IsiDataManager1, @vDataManager);

  // wei�e dem Discovery Manager den neuen DataManager zu
  TCellObject.CellAs<IsiCellReference>( 'siDataManager').siAsCell := vDataManager;

  Assert.isTrue( TCellObject.RootSkill<IsiDataManager1>.siIsSame(vDataManager) ,
    'After setting the DataManager over skill interface cell the first found root skill of IsiDataManager1 is not DataManager');

  // setzte den Standard Data Manager wieder als DataManager des DM
  TCellObject.RootSkill<IsiDiscoveryManager>.siDataManager :=
   TCellObject.CellAs<IsiDataManager1>( 'StandardDataManager');

  // Gegen-Probe: wenn MainCell gel�scht ist, darf RootAs auch kein
  // IsiStandardInterfaceSample mehr liefern
  TCellObject.root.siRemoveSubCell(fMainCell);

  Assert.IsFalse( TCellObject.TryRootSkill<IsiStandardInterfaceSample>(vSampleCell),
   'The IsiStandardInterfaceSample are delivered from root after deleting of main cell');

end;

procedure TCellObjectTests.TestBasicMethods;
var
  vCell:     IsiCellObject;
  vSubCell:  IsiCellObject;
  vSubIntf:  IsiStandardInterfaceSample;
  vCellCopy: IsiCellObject;
const
  C_TEST_CELL_NAME_1 = 'TestCellName';
  C_TEST_CELL_NAME_2 = 'AnotherName';
begin
  // Test AssignedValidCell
  Assert.IsFalse( TCellObject.isValid( vCell ),
   'vCell is an cell without control and must be unvalid');

  vCell:= TcoCellSample1.Create(C_TEST_CELL_NAME_1);
  vSubCell:= vCell.siAddNewSubCell(TcoCellSample1,'SubCell');

  // Test AssignedValidCell
  Assert.IsFalse( TCellObject.isValid( vCell ),
   'vCell is an cell without control and must be unvalid');

  // Test siIsValid of SubCell
  Assert.IsFalse(vCell.siSubCell[0].siIsValid,
   'sub cell must be unvalid');

  // create a new sub cell with name C_TEST_CELL_NAME_1
  fMainCell.siAddSubCell(vCell);

  // Test AssignedValidCell
  Assert.IsTrue( TCellObject.isValid( vCell ),
   'vCell is now under control of MainCell but is still unvalid');

  // Test siIsValid
  Assert.IsTrue( TCellObject.TryCellAs<IsiStandardInterfaceSample> ( vCell.siSubCell[0], vSubIntf),
   'vCell is now under control of MainCell but the sub cell is still unvalid');

  Assert.IsTrue(Assigned(vSubIntf),'vSubIntf is not assigned');

  // Test siSelf
  Assert.AreEqual(vCell.siController,fMainCell.siSelf,
   'siSelf of test cell are not equal to vCell.siController reference');

  // check siName
  Assert.AreEqual(vCell.siName,C_TEST_CELL_NAME_1,
   'siName after create with name no equal!');

  // check setting and gettig of siName
  vCell.siName := C_TEST_CELL_NAME_2;
  Assert.AreEqual(vCell.siName,C_TEST_CELL_NAME_2,'Invalid setting of siName!');

  // check unique name setting
  vCell:= fMainCell.siAddSubCell(TcoCellSample1.Create(C_TEST_CELL_NAME_2));
  Assert.AreNotEqual(vCell.siName,C_TEST_CELL_NAME_2,
   'siName are not unique (C_TEST_CELL_NAME_2 exist 2 times)');
  Assert.AreEqual(vCell.siName,C_TEST_CELL_NAME_2+' 2',
   'Invalid auto unique setting of siName!');

  // create a cell with the same object class with siClass (create ist a method of TObject)
  Assert.IsTrue(Supports(vCell.siClass.Create,IsiCellObject,vCellCopy),
   'Invalid reference after creation of siClass');

  // check the equal of type guid
  Assert.AreEqual(vCell.siTypeGuid,vCellCopy.siTypeGuid,'Not equal type guid');

  // check the equal of type name
  Assert.AreEqual(vCell.siTypeName,vCellCopy.siTypeName,'Not equal type name');

end;

procedure TCellObjectTests.TestLongName;
var
  vCell: IsiCellObject;
  vLongName: string;
const
  C_TEST_CELL_NAME = 'TestSubCell';
begin
{ The long name of a cell describes the cell name in its structure tree.
  It contains all cell names in the structure based on the Discovery Manager.
  Cells can thus be addressed in the entire system.
  The delimiter of levels is C_LONGNAME_DELIMITER ("/").
  The Discovery as root of the structure tree names C_LONGNAME_DISCOVERY_MANAGER ("OP:")
  example: "OP:/sampleSystem/MainCell/SubCell" }

  // check the right long name of discovery manager (C_LONGNAME_DISCOVERY_MANAGER, "OP:")
  Assert.isTrue(TCellObject.Root.siLongName=C_LONGNAME_ROOT,
   'Discovery managers long name is not C_LONGNAME_DISCOVERY_MANAGER');

  // create a new sub cell
  vCell:=fMainCell.siAddSubCell(TCellObject.Create(C_TEST_CELL_NAME));

  // construct the right long name of fMainCell
  vLongName := C_LONGNAME_ROOT + C_LONGNAME_DELIMITER + C_MAIN_CELL_NAME;

  // check the long name of fMainCell
  Assert.AreEqual(fMainCell.siLongName,vLongName,'Invalid long name of MainCell');

  vLongName:=fMainCell.siLongName + C_LONGNAME_DELIMITER + vCell.siName;
  Assert.AreEqual(vCell.siLongName, vLongName, 'Invalid long name of added sub cell');

  // search with siSubCell in DiscoveryManager over the long name of vCell and
  // check the result with siIsSame of vCell
  Assert.IsTrue( vCell.siIsSame(TCellObject.Root.siFindCell(vCell.siLongName)),
   'The search result in discvovery manager over long name is not correct');
end;


procedure TCellObjectTests.TestCellTypeRegister;
var
  vCell:   IsiCellObject;
  vObject: TInterfacedObject;
begin

{ All cell object classes must be registered using the "RegisterCellTypeAttribute"
  attribute. The attribute defines the name and the GUID for the cell type.
  Registered cell objects can be reanimated from the registration at runtime. }

  // check whether the Discovery Manager cell type is registered in the type register
  Assert.IsTrue(Assigned(TCellObject.RootSkill<IsiCellTypeRegister>.siGetSubCell(TCellObject.Root.siTypeGuid)),
   'TcoDiscoveryManager not found in the cell type register');

  // check whether the fMainCell (TcoCellSample1) cell type is registered in the type register
  Assert.IsTrue(Assigned(TCellObject.RootSkill<IsiCellTypeRegister>.siGetSubCell(fMainCell.siTypeGuid)),
   'fMainCell (TcoCellSample1) not found in the cell type register');

  // build a new cell instance as same like fMainCell class over type guid
  vCell := TCellObject.RootSkill<IsiCellTypeRegister>.siBuildNewCell(fMainCell.siTypeGuid);

  // check the result of register type building
  Assert.IsTrue(Assigned(vCell),'Invalid cell interface building in type register');
  Assert.AreEqual(vCell.siTypeGuid,fMainCell.siTypeGuid,
   'The new cell of register builing is not the same cell type like fMainCell');

  vCell := nil;

end;

procedure TCellObjectTests.TestCellController;
var
  I: Integer;
  fControlList: TArray<IsiCellObject>;
  vCell:IsiCellObject;
begin
{ Except for the Discovery Manager, all cells are embedded in a cell structure
  as a tree. The Discovery Manager is the root of this. Subordinate cells are
  called subcells. Superordinate cells are called controllers or controller
  cells. Each cell has a controller and can itself manage any number of subcells
  as a controller. Every cell knows its controller and can address it via
  siController. }

  // check the controller of Discovery Manager, that maust be false
  Assert.IsFalse(TCellObject.Root.siIsControlled,'The discovery manager are controlled from everyone');

  // check the controller of fMainCell
  Assert.IsTrue(fMainCell.siIsControlled,'The MainCell are not controlled');

  // check siController, controller of fMainCell is the SubCellSample cell
  Assert.AreSame(fMainCell.siController, TCellObject.Root,
   'The MainCell are not controlled at root');

  // check siController with out parameter getted var for the controller cell
  Assert.IsTrue(fMainCell.siIsControlled(vCell),
   'Invalid result of siIsControlled(vCell)');

  // check that the out parameter of siIsControlled is the controller of fMainCell
  Assert.AreSame(vCell, TCellObject.Root,
   'vCell of siIsControlled(vCell) is not root');

  try
    // get the sub the list array of controlled sub cell entries
    fControlList:=TCellObject.Root.siControlledSubCells;

    // check the length of controlled cell list    
    Assert.IsTrue(Length(fControlList)>=1,
     'Not enough entries in controlled lsit of root');

    // fMainCell has C_SUBCELL_COUNT (5) times sub cells under control 
    Assert.IsTrue(Length(fMainCell.siControlledSubCells)=C_SUBCELL_COUNT,
     'Invalid length of siListOfControlledCells of fMainCell');

    // the SubSystemSample has as last entry the fMainCell, check the last entry    
    Assert.AreSame(fMainCell,fControlList[High(fControlList)],
     'MainCell not the first Entry in List of controlled Cells of SubSystemSample');
  finally
    // get the entries and temp. sub cell list free
    for I := 0 to High(fControlList) do
      fControlList[I] := nil;
    SetLength(fControlList, 0);
  end;
end;

procedure TCellObjectTests.TestSubCellListByInterface;
var
  vCount: Integer;
begin
  // create and add C_SUBCELL_COUNT new cells in fMainCell
  for vCount := 0 to C_SUBCELL_COUNT-1 do
    fMainCell.siAddSubCell(TcoCellSample1.Create);

  // get the count of cell whose supports IsiStandardInterfaceSample
  vCount:= fMainCell.siSubCellCount(IsiStandardInterfaceSample);

  Assert.AreEqual(C_SUBCELL_COUNT,vCount,
   'Invalid count of siCountOfInterface(IsiStandardInterfaceSample)');

  // check the list array out of IsiStandardInterfaceSample
  Assert.AreEqual(C_SUBCELL_COUNT,
   Length(fMainCell.siInterfacedSubCells(IsiStandardInterfaceSample)),
   'Invalid length of cell list whose supports IsiStandardInterfaceSample');

  // check the list array of cell whose supports IsiCellObject
  Assert.AreEqual(C_SUBCELL_COUNT + C_SUBCELL_COUNT,
   Length(fMainCell.siInterfacedSubCells(IsiCellObject)),
   'Invalid length of cell list whose supports IsiCellObject' );

end;



procedure TCellObjectTests.TestSubCellGetter;
var
  vSubCell: IsiCellObject;
  vStr:     string;
  vIdx:     Integer;
const
  C_TEST_SUB_CELL_NAME = 'TestCell';
begin
  // siSubCell fetches the cell whose matches different search options
  //   * Search options in the own sub cell list only
  //     a) via cell GUID
  //     b) via cell name
  //     c) via list index
  //   * search in all cell structures as long name
  //     a) in the own and deeper structure (relative path: "xxx/yyy")
  //     b) in the complete path from root (absolute path: "OP:/xxx/yyy")
  //     c) relative navigated in near structure (relative path. "../../xxx/yyy)"

  // create and add a new sub cell under fMainCell with Name of C_TEST_SUB_CELL_NAME
  vSubCell := fMainCell.siAddSubCell(TCellObject.Create(C_TEST_SUB_CELL_NAME));

  // get the Name of the cell
  vStr := vSubCell.siName;

  // fMainCell.siGetSubCell(Name) fetches the cell with the cell name
  // (only in the sub list of fMainCell)
  Assert.AreSame(fMainCell.siGetSubCell(vStr), vSubCell);

  // get the idx of cell (must be the last entry of sub cell list -> Count-1)
  vIdx := fMainCell.siSubCellCount - 1;

  // fMainCell.siSubCell(idx) fetches the cell with list index
  Assert.AreSame(fMainCell.siGetSubCell(vIdx), vSubCell);

  // get the long name (path from root to cell)
  vStr := vSubCell.siLongName;

  // fMainCell.siCell(LongName) fetches the cell with complete long name
  Assert.AreSame(fMainCell.siFindCell(vStr), vSubCell);

  // DiscoveryManager.siCell(LongName) fetches the cell with long name
  Assert.AreSame(TCellObject.Root.siFindCell(vStr), vSubCell);

  // set relative name with fMainCell and vSubCell ("main cell/TestCell")
  vStr := fMainCell.siName + C_LONGNAME_DELIMITER + vSubCell.siName;

  // fetches the cell with relative long name from the controller of fMainCell
  Assert.AreSame(fMainCell.siController.siFindCell(vStr), vSubCell);

  // set relative name for fetches from a bruch (from first entry in fMainCell list)
  vStr := C_LONGNAME_ONE_LEVEL_UP + C_LONGNAME_DELIMITER + vSubCell.siName;

  // fetches the cell with relative long name from brunch (first entry of fMainCell)
  Assert.AreSame(fMainCell.siSubCell[0].siFindCell(vStr), vSubCell);

end;

procedure TCellObjectTests.TestSubCellSetter;
var
  vNewCell: IsiCellObject;
  vOldCell: IsiCellObject;
begin
  // create a new test cell and hold it only in vNewSubCell
  vNewCell:= TcoCellSample1.Create();

  // get the sub cell of lis on idx 1
  vOldCell:= fMainCell.siSubCell[1];

  // check that the cell in sub sell list on idx 1 are not the same
  Assert.AreNotSame(vNewCell, fMainCell.siSubCell[1]);

  // swap the old cell with new Cell
  fMainCell.siSwapSubCell(vOldCell, vNewCell);

  // check that the cell in sub cell list in idx 1 are the same
  Assert.AreSame(vNewCell, fMainCell.siSubCell[1]);

  // set the old cell back in list on idx 1
  fMainCell.siSetSubCell(1, vOldCell);

  // check that the cell in sub cell list in idx 1 are the same like the vOldCell
  Assert.AreSame(vOldCell, fMainCell.siSubCell[1]);
end;

procedure TCellObjectTests.TestSubCellAddition;
var
  vAddCell: IsiCellObject;
  vGuid: TGUID;
begin
  // add create a cell instance of TCellObject and add it as sub cell in fMainCell
  vAddCell:=fMainCell.siAddSubCell(TCellObject.Create);

  // Cell(0..C_SUBCELL_COUNT-1)  ---> SubCells of adding in Setup (C_SUBCELL_COUNT)
  // Cell(C_SUBCELL_COUNT)       ---> vAdditionalSubCell

  // Check the count of sub cell of fMainCell
  Assert.IsTrue(fMainCell.siSubCellCount=C_SUBCELL_COUNT+1,
    'Invalid count of sub cells in fMainCell');

  // get the last entry of fMainCell with siSubCell(const idx : integer)
  Assert.AreSame(vAddCell, fMainCell.siGetSubCell(C_SUBCELL_COUNT),
    'vAdditionalSubCell not entry of C_SUBCELL_COUNT+1');

  // check that the controller of the cell is fMainCell
  Assert.isTrue(fMainCell.siIsSame(vAddCell.siController),
    'The added cell is not controlled by fMainCell');

  // ADD NEW CELL with class type

  // add a new cell in sub cell list of fMainCell with class type
  vAddCell:= fMainCell.siAddNewSubCell(TCellObject,'Test over class');

  // check assigning of new cell
  Assert.IsNotNull(vAddCell,
   'Not assigned cell after siAddNewSubCell with getted class');

  // check sub cell list entry
  Assert.IsNotNull(fMainCell.siGetSubCell(vAddCell.siName),
   'New cell from siAddNewCell with class not added in sub cell list');

  // ADD NEW CELL with type name

  // add a new cell in sub cell list of fMainCell with cell type name
  vAddCell:= fMainCell.siAddNewSubCell(C_TEST_CHILD_NAME,'Test over name');

  // check assigning of new cell
  Assert.IsNotNull(vAddCell,
   'Not assigned cell after siAddNewSubCell with type name');

  // check sub cell list entry
  Assert.IsNotNull(fMainCell.siGetSubCell(vAddCell.siName),
   'New cell from siAddNewCell with type name not added in sub cell list');

  // save the cell type GUID
  vGuid:= vAddCell.siTypeGuid;

  // ADD NEW CELL with type GUID

  // add a new cell in sub cell list of fMainCell with cell type GUID
  vAddCell:= fMainCell.siAddNewSubCell(vGuid,'Test over GUID');

  // check assigning of new cell
  Assert.IsNotNull(vAddCell,
   'Not assigned cell after siAddNewSubCell with type name');

  // check sub cell list entry
  Assert.IsNotNull(fMainCell.siGetSubCell(vAddCell.siName),
   'New cell from siAddNewCell with type name not added in sub cell list');

  // ADD NEW CELL with class type on position 0

  // add a new cell in sub cell list of fMainCell with class type
  vAddCell:= fMainCell.siInsertNewSubCell(TCellObject,'Test over class',0);

  // check assigning of new cell
  Assert.IsNotNull(vAddCell,
   'Not assigned cell after siAddNewSubCell with getted class on position');

  // check sub cell list entry
  Assert.IsNotNull(fMainCell.siSubCell[0],
   'New cell from siAddNewCell with class not added in sub cell list on position 0');

  // ADD NEW CELL with type name on position 0

  // add a new cell in sub cell list of fMainCell with cell type name
  vAddCell:= fMainCell.siInsertNewSubCell(C_TEST_CHILD_NAME,'Test over name',0);

  // check assigning of new cell
  Assert.IsNotNull(vAddCell,
   'Not assigned cell after siAddNewSubCell with type name on position');

  // check sub cell list entry
  Assert.IsNotNull(fMainCell.siSubCell[0],
   'New cell from siAddNewCell with type name not added in sub cell list on position 0');

  // ADD NEW CELL with type GUID on position 0

  // add a new cell in sub cell list of fMainCell with cell type GUID
  vAddCell:= fMainCell.siInsertNewSubCell(vGuid,'Test over GUID',0);

  // check assigning of new cell
  Assert.IsNotNull(vAddCell,
   'Not assigned cell after siAddNewSubCell with type name on position 0');

  // check sub cell list entry
  Assert.IsNotNull(fMainCell.siSubCell[0],
   'New cell from siAddNewCell with type name not added in sub cell list on position 0');

  // CONSTRUCT NEW CELL with class type

  // add a new cell in sub cell list of fMainCell with class type as constructed cell
  vAddCell:= fMainCell.siConstructNewSubCell(TCellObject,'CON0');

  // check assigning of new cell
  Assert.IsNotNull(vAddCell,
   'Not assigned cell after siConstructNewSubCell with getted class');

  // check sub cell list entry
  Assert.IsNotNull(fMainCell.siSubCell[0],
   'New cell from siConstructNewCell with class not added in sub cell list');
  { Remark: constructed cell will be insert in the first part of list before all
  other standard cells entries. -> the first constructed cell found in idx 0,
  the second constructed cell found in idx 1 ...}

  // CONSTRUCT NEW CELL with type name

  // construct a new cell in sub cell list of fMainCell with cell type name
  vAddCell:= fMainCell.siConstructNewSubCell(C_TEST_CHILD_NAME,'CON1');

  // check assigning of new cell
  Assert.IsNotNull(vAddCell,
   'Not assigned cell after siConstructNewSubCell with type name');

  // check sub cell list entry
  Assert.IsNotNull(fMainCell.siSubCell[1],
   'New cell from siConstructNewCell with type name not added in sub cell list');

  // save the cell type GUID
  vGuid:= vAddCell.siTypeGuid;

  // CONSTRUCT NEW CELL with type GUID

  // construct a new cell in sub cell list of fMainCell with cell type GUID
  vAddCell:= fMainCell.siConstructNewSubCell(vGuid,'CON2');

  // check assigning of new cell
  Assert.IsNotNull(vAddCell,
   'Not assigned cell after siConstructNewSubCell with type name');

  // check sub cell list entry
  Assert.IsNotNull(fMainCell.siSubCell[2],
   'New cell from siConstructNewCell with type name not added in sub cell list');

end;

procedure TCellObjectTests.TestSubCellRemoval;
begin
  // check the sub cell list count
  Assert.AreEqual(fMainCell.siSubCellCount, C_SUBCELL_COUNT);

  // check that the sub cell on index 0 is valid
  Assert.IsTrue(fMainCell.siSubCellValid(0));

  // remove sub cell on index 0 and check the new count of cell list
  Assert.IsTrue(fMainCell.siRemoveSubCell(0),'remove sub cell (0) was failed');

  // check the count of sub cell list -> -1
  Assert.AreEqual(fMainCell.siSubCellCount, C_SUBCELL_COUNT-1,
    'Invalid count after removal by cell idx');

  // remove the next first sub cell over his name
  Assert.IsTrue(fMainCell.siRemoveSubCell( fMainCell.siSubCell[0].siName),
    'Remove sub cell by name was failed');

    // check the count of sub cell list -> -2
  Assert.AreEqual(fMainCell.siSubCellCount, C_SUBCELL_COUNT-2,
    'Invalid count after removal by cell name');

  // remove the next first sub cell over his IsiCellObject
  Assert.IsTrue( fMainCell.siRemoveSubCell( fMainCell.siSubCell[0]),
    'Remove sub cell by reference was failed');

  // check the count of sub cell list -> -3
  Assert.AreEqual(fMainCell.siSubCellCount, C_SUBCELL_COUNT-3,
    'Invalid count after removal by IsiCellObject reference');

  // remove the rest of sub cells
  fMainCell.siRemoveAllSubCells;

  // check the count of sub cell list -> 0
  Assert.AreEqual(fMainCell.siSubCellCount, 0,
    'Invalid count after removal of all sub cells');

end;

procedure TCellObjectTests.TestCellDelete;
var vCell : IsiCellObject;
begin
  // check the sub cell list count
  Assert.AreEqual(fMainCell.siSubCellCount, C_SUBCELL_COUNT);

  // get first entry of sub list of MainCell
  vCell := fMainCell.siSubCell[0];

  // delete cell it self
  Assert.IsTrue(vCell.siDeleteCell,'deleting of it self was failed');

  // check the sub cell list count
  Assert.AreEqual(fMainCell.siSubCellCount, C_SUBCELL_COUNT-1,
    'count after first deleting failed');

  // get second entry of sub list of MainCell
  vCell := fMainCell.siSubCell[0];

  // delete referenced cell
  Assert.IsTrue(fMainCell.siDeleteCell(vCell),
    'deleting of cell (over ref) was failed');

  // check the sub cell list count
  Assert.AreEqual(fMainCell.siSubCellCount, C_SUBCELL_COUNT-2,
    'count after second deleting failed');

  // get third entry of sub list of MainCell
  vCell := fMainCell.siSubCell[0];

  // delete named cell
  Assert.IsTrue(TCellObject.Root.siDeleteCell(vCell.siLongName),
    'deleting of named cell was failed');

  // check the sub cell list count
  Assert.AreEqual(fMainCell.siSubCellCount, C_SUBCELL_COUNT-3,
    'count after third deleting failed');

end;

procedure TCellObjectTests.TestSubCellNesting;
var
  vSubCell:    IsiCellObject;
  vSubSubCell: IsiCellObject;
  vSubSubTest: IsiTestValueGetter;
begin
  // check the vality of the first entry in fMainCell sub cell list
  Assert.IsTrue(fMainCell.siSubCellValid(0));

  // get the first sub cell of fMainCell
  vSubCell := fMainCell.siSubCell[0];

  // create and add the sub sub cell
  vSubSubCell:=vSubCell.siAddNewSubCell(TCellObject,'');

  // create and add the sub sub test as IsiTestValueGetter 
  vSubSubTest:=vSubCell.siAddNewSubCell(C_TEST_CHILD_NAME,'') as IsiTestValueGetter;

  { Tree should look like this now:
    fMainCell
      fMainCell.fSubCells[0] <----------------- vSubCell
        fMainCell.fSubCells[0].fSubCells[0] <-- vSubSubCell
        fMainCell.fSubCells[0].fSubCells[1] <-- vSubSubTest
      fMainCell.fSubCells[1]
      ... }

  { Sub-cell count of fMainCell has not changed because the number of immediate child objects is
    the same. (C_SUBCELL_COUNT + Main self) }
  Assert.IsTrue(fMainCell.siSubCellCount() = C_SUBCELL_COUNT);

  { vSubCell has two sub-cells + self (3) of its own. Query this via fMainCell to make sure that vSubCell
    references the same object as fMainCell.fSubCells[1]. }
  Assert.IsTrue(fMainCell.siSubCell[0].siSubCellCount = 2);

  { vSubSubTest is the only sub-cell of vSubCell that supports IsiTestValueGetter. Make sure
    that that specific sub-sub-cell of fMainCell refers to the same object (instance) as
    vSubSubTest. }
  Assert.IsTrue(vSubCell.siSubCellCount(IsiTestValueGetter) = 1);

  // check the list of interfac of fMainCell sub cell 1
  Assert.AreSame(
    fMainCell.siSubCell[0].siInterfacedSubCells(IsiTestValueGetter)[0],vSubSubTest);

  { Show that both sub-sub-cells refer to the same objects as the local references. }
  Assert.AreSame(vSubSubCell,fMainCell.siSubCell[0].siSubCell[0]);
  Assert.AreSame(vSubSubTest,fMainCell.siSubCell[0].siSubCell[1]);
end;

procedure TCellObjectTests.TestSubCellMultiReferencing;
var
  vSubCell: IsiCellObject;
  vCount:   Integer;
const
  C_MIN_SUBCELLS = 2;
begin
  // create a new cell
  vSubCell := TCellObject.Create;

  // check the count of fMainCell list count
  Assert.IsTrue(fMainCell.siSubCellCount() >= C_MIN_SUBCELLS);

  for vCount := 0 to C_MIN_SUBCELLS-1 do
  begin
    // check the sub cell entry of <vCount> of fMainCell
    Assert.IsTrue(fMainCell.siSubCellValid(vCount));

    // add the sub cell in entry (0,1) of vCount of fMainCell
    fMainCell.siGetSubCell(vCount).siAddSubCell(vSubCell);
  end;

  // create and add a sub cell "ExtraSubCell" in fMainCell.siSubCell(1)
  fMainCell.siSubCell[1].siAddSubCell(TCellObject.create('ExtraSubCell'));

{ Tree should now look like this:
    fMainCell
      fMainCell.siSubCell[0]                                          Controller=fMainCell
        fMainCell.siSubCell[0].siSubCells[0] <-- vSubCell             Controller=fMainCell.siSubCell[0]
      fMainCell.siSubCells[1]                                         Controller=fMainCell
        fMainCell.siSubCells[1].siSubCells[0] <-- vSubCell            Controller=fMainCell.siSubCell[0] !
        fMainCell.siSubCells[1].siSubCells[1] <-- ExtraSubCell        Controller=fMainCell.siSubCell[1] !

  Comment: both SubCell are the same, the Controller is fMainCell.siSubCell[1] }

  // check the fMainCell.siSubCell(0).siSubCell(0) cell
  Assert.AreSame(fMainCell.siSubCell[0].siSubCell[0],vSubCell,
    'Unvalid setting of fMainCell.siSubCell(0).siSubCell(0)');

  // check fMainCell.siSubCell(1).siSubCell(0) cell
  Assert.AreSame(fMainCell.siSubCell[1].siSubCell[0],vSubCell,
    'Unvalid setting of fMainCell.siSubCell(1).siSubCell(0)');

  // check that vSubCell is controlled
  Assert.IsTrue(vSubCell.siIsControlled,
    'vSubCell are not controlled');

  // check that the controller of vSubCell is fMainCell.siSubCell(0)
  Assert.IsTrue(vSubCell.siController=fMainCell.siSubCell[0],
    'The controller of vSubCell are not correct');

  // check the controller of ExtraSubCell
  Assert.IsTrue(
    fMainCell.siSubCell[1].siSubCell[1].siController=fMainCell.siSubCell[1],
    'ExtraSubCell are not controlled from the right sub cell');

end;

procedure TCellObjectTests.ValueTester;
var
  vCell:        IsiCellObject;
  vLongName:    string;
  vIntegerCell: IsiInteger;
  vStr:         string;
const
  C_CELL_NAME = 'TestCell';
  C_TEST_INTEGER = 69;
  C_TEST_STRING  = '99';
begin
{ Each cell has at least one value for content use. The stem cell TCellObject
  holds an RTTI TValue regord ready for this purpose, which can be addressed via
  siAsValue. The siAsValue methods can also be used with cell long name. }

  // create and add a new cell
  Assert.IsTrue( fMainCell.siAddNewCell(TCellObject, C_CELL_NAME, @vCell),
    'Invalid add of new IsiCellObject cell');

  // write a integer C_TEST_INTEGER in the cell value
  vCell.siValue:= TValue.From<Integer>(C_TEST_INTEGER);

  // check the cell value content
  Assert.AreEqual(vCell.siValue.AsType<Integer>, C_TEST_INTEGER,
   'Incorrect setting or getting with siAsValue of test cell');

  // get the long name of cell
  vLongName := vCell.siLongName;

  // check the cell value content over long name of test cell requested in fMainCell
  Assert.AreEqual(fMainCell.siGetValue(vLongName).AsType<Integer>, C_TEST_INTEGER,
   'Incorrect value getting over long named cell request' );

  // check the cell validation and write value as 0 integer
  Assert.IsTrue( TCellObject.Root.siTrySetValue(vLongName,TValue.From<Integer>(0)),
   'Invalid long named value setting in discovery manager');

  // check the overwriting of the cell content integer
  Assert.AreNotEqual(vCell.siValue.AsType<Integer>, C_TEST_INTEGER,
   'Incorrect overwriting of test cell');

{ Data cells use the value to implent from corresponding data data streams.
  Your interface extends the methods for type handling. (e.g. TcoInteger supports
  IsiInteger and implements siAsInteger)}

  // create and add a integer data cell
  Assert.IsTrue( fMainCell.siAddNewCell(TcoInteger, 'integer cell', IsiInteger, @vIntegerCell),
    'Invalid add of new IsiInteger cell');

  //vIntegerCell := TcoInteger.create('integer cell'); // TcoInteger as IsiInteger
  //vCell := fMainCell.siAddSubCell(vIntegerCell);     // TcoInteger as IsiCellObject

  // set value of integer data cell over siAsInteger
  vIntegerCell.siAsInteger := C_TEST_INTEGER;

  vCell := vIntegerCell;

  // check that the data typ of TValue of the integer cell ist a integer
  Assert.IsTrue( vCell.siValue.IsType<Integer>,
   'vCell Value has incorrect data type');

  // check the value content over long name and AsValue
  vLongName := vIntegerCell.siLongName;

  Assert.AreEqual( TCellObject.Root.siGetValue(vLongName).AsType<Integer>, C_TEST_INTEGER,
   'invalid check of data cell content over siAsValueDiscoveryManager.siAsValue' );

{ All cells can return their value/content as a string. The set method siSetAsString
  changes values from a string to the corresponding type.
  This function is only predefined (virtual) in the root cell and must be
  inherited classes in detail.}

  // set value of integer data cell over siAsInteger
  vIntegerCell.siAsInteger := C_TEST_INTEGER;

  // get the value as string
  vStr := vCell.siAsString;

  // check that string content equal to integer setting
  Assert.AreEqual( StrToInt(vStr), C_TEST_INTEGER,
    'The string of integer data cell is not equal to setting');

  // set the value of integer cell as string
  vCell.siAsString := C_TEST_STRING;

  // check that string content equal to integer setting
  Assert.AreEqual( IntToStr(vIntegerCell.siAsInteger), C_TEST_STRING,
    'The integer of data cell is not equal to string setting');

end;

procedure TCellObjectTests.BooleanCellTester;
var
  vCell      : IsiCellObject;
  vBoolean   : IsiBoolean;
  vJSONValue : TJSONValue;
  vStr     : string;
const
  C_TEST_BOOLEAN = True;
begin
  // create ans add a boolean data cell
  vCell := fMainCell.siAddSubCell(TcoBoolean.create());

  Assert.IsTrue( TCellObject.TryCellAs<IsiBoolean>( vCell, vBoolean),
    'TcoBoolean dosnt supports IsiBoolean');

  // set the boolean value
  vBoolean.siAsBoolean := C_TEST_BOOLEAN;

  // check the boolean setting
  Assert.IsTrue(vBoolean.siAsBoolean=C_TEST_BOOLEAN, 'Invalid Boolean siAsBoolean');

  // Check the common data methods (AsString, AsJSON) over vCell to test the override

  // get the string of boolean cell content
  vStr:= vCell.siAsString;

  // reset boolean
  vBoolean.siAsBoolean := C_DEFAULT_BOOLEAN;

  // set the cell as String
  vCell.siAsString := vStr;

  // check the boolean setting
  Assert.IsTrue(vBoolean.siAsBoolean=C_TEST_BOOLEAN, 'Invalid Boolean siSetAsString');

  // get and check the content as string
  Assert.isTrue(vBoolean.siAsString=vStr, 'Invalid Boolean siGetAsString');

  // get content as JSON value
  vJSONValue := vCell.siAsJSON;

  // reset boolean
  vBoolean.siAsBoolean := C_DEFAULT_BOOLEAN;

  // set content as JSON value
  vCell.siAsJSON := vJSONValue;

  // check the boolean setting
  Assert.IsTrue(vBoolean.siAsBoolean=C_TEST_BOOLEAN, 'Invalid Boolean siSetAsJSON');
end;

procedure TCellObjectTests.IntegerCellTester;
var
  vCell      : IsiCellObject;
  vInteger   : IsiInteger;
  vJSONValue : TJSONValue;
  vStr     : string;
const
  C_TEST_INTEGER = 69;
begin
  // create ans add a boolean data cell
  vCell := fMainCell.siAddSubCell(TcoInteger.create());
  vInteger := vCell as IsiInteger;

  // set the integer value
  vInteger.siAsInteger := C_TEST_INTEGER;

  // check the integer setting
  Assert.IsTrue(vInteger.siAsInteger=C_TEST_INTEGER, 'Invalid Integer siAsInteger');

  // Check the common data methods (AsString, AsJSON) over vCell to test the override

  // get the string of cell content
  vStr:= vCell.siAsString;

  // reset value
  vInteger.siAsInteger := C_DEFAULT_INTEGER;

  // set the cell as String
  vCell.siAsString := vStr;

  // check the integer setting
  Assert.IsTrue(vInteger.siAsInteger=C_TEST_INTEGER, 'Invalid Integer in siSetAsString');

  // get and check the content as string
  Assert.isTrue(vInteger.siAsString=vStr, 'Invalid Integer siGetAsString');

  // get content as JSON value
  vJSONValue := vCell.siAsJSON;

  // reset boolean
  vInteger.siAsInteger := C_DEFAULT_INTEGER;

  // set content as JSON value
  vCell.siAsJSON := vJSONValue;

  // check the string setting
  Assert.IsTrue(vInteger.siAsInteger=C_TEST_INTEGER, 'Invalid Integer siSetAsJSON');
end;

procedure TCellObjectTests.FloatCellTester;
var
  vCell      : IsiCellObject;
  vFloat     : IsiFloat;
  vJSONValue : TJSONValue;
  vStr       : string;
const
  C_TEST_FLOAT = 6.9;
begin
  // create ans add a float data cell
  vCell := fMainCell.siAddSubCell(TcoFloat.create());

  // test assign and skill interface
  Assert.IsTrue( TCellObject.TryCellAs<IsiFloat>( vCell, vFloat),
   'TcoFloat dosnt supports IsiFloat');

  // set the float value
  vFloat.siAsFloat := C_TEST_FLOAT;

  // check the float setting with get as float
  // use compareFloat to compare a float value
  Assert.isTrue(CompareFloat(vFloat.siAsFloat,C_TEST_FLOAT), 'Invalid float siAsFloat');

  // Check the common data methods (AsString, AsJSON) over vCell to test the override

  // get the string of cell content
  vStr:= vCell.siAsString;

  // reset value
  vFloat.siAsFloat := C_DEFAULT_FLOAT;

  // set the cell as String
  vCell.siAsString := vStr;

  // check the float setting
  Assert.IsTrue(CompareFloat(vFloat.siAsFloat,C_TEST_FLOAT), 'Invalid float in siSetAsString');

  // get and check the content as string
  Assert.isTrue(vFloat.siAsString=vStr, 'Invalid float siGetAsString');

  // get content as JSON value
  vJSONValue := vCell.siAsJSON;

  // reset value
  vFloat.siAsFloat := C_DEFAULT_FLOAT;

  // set content as JSON value
  vCell.siAsJSON := vJSONValue;

  // check the string setting
  Assert.IsTrue(CompareFloat(vFloat.siAsFloat,C_TEST_FLOAT), 'Invalid float siSetAsJSON');
end;

procedure TCellObjectTests.StringCellTester;
var
  vCell      : IsiCellObject;
  vString    : IsiString;
  vJSONValue : TJSONValue;
  vStr       : string;
const
  C_TEST_STRING = 'test';
begin
  // create ans add a string data cell
  vCell := fMainCell.siAddSubCell(TcoString.create());

  // test assign and skill interface
  Assert.IsTrue( TCellObject.TryCellAs<IsiString>( vCell, vString),
   'TcoString dosnt supports IsiString');

  // set the string value
  vstring.siAsString := C_TEST_STRING;

  // check the string setting with get as string
  Assert.isTrue(vString.siAsString=C_TEST_STRING, 'Invalid string siAsString');

  // Check the common data methods (AsString, AsJSON) over vCell to test the override

  // get the string of cell content
  vStr:= vCell.siAsString;

  // reset value
  vString.siAsString := C_DEFAULT_STRING;

  // set the cell as String
  vCell.siAsString := vStr;

  // check the string setting
  Assert.IsTrue(vString.siAsString=C_TEST_STRING, 'Invalid string in siSetAsString');

  // get and check the content as string
  Assert.isTrue(vString.siAsString=vStr, 'Invalid string siGetAsString');

  // get content as JSON value
  vJSONValue := vCell.siAsJSON;

  // reset value
  vString.siAsString := C_DEFAULT_STRING;

  // set content as JSON value
  vCell.siAsJSON := vJSONValue;

  // check the string setting
  Assert.IsTrue(vString.siAsString=C_TEST_STRING, 'Invalid string siSetAsJSON');
end;


procedure TCellObjectTests.CellClassCellTester;
var
  vCell : IsiCellClass;
  vInt : IsiInteger;
const
  C_CLASS_NAME = 'classic';
  C_INT_NAME = 'integer';
begin
  // create and add a class data cell
  Assert.IsTrue( fMainCell.siAddNewCell(TcoCellClass,C_CLASS_NAME,IsiCellClass,@vCell),
   'add new cell in Maincell was failed');

  vCell.siAsClass := TcoBoolean;

  Assert.AreEqual(vCell.siAsClass,TcoBoolean,
   'Invalid siAsClass writing or reading');

  Assert.IsTrue( CompareNames(vCell.siAsString,'TcoBoolean'),
   'siAsString of cell class data cell was invalid');

  vCell.siAsString := 'TcoInteger';

  Assert.AreEqual(vCell.siAsClass,TcoInteger,
   'Convert of string to cell class in siAsSetAsString invalid');

  Assert.IsTrue( fMainCell.siAddNewCell(vCell.siAsClass,C_INT_NAME,IsiInteger,@vInt),
   'add new cell in Maincell from cell class was failed');
end;

procedure TCellObjectTests.CellReferenceTester;
var
  vCellRef1 : IsiCellReference;
  vCellRef2 : IsiCellReference;
const
  C_REF_NAME = 'RefCell';
begin
  // create and add a cell reference data cell
  Assert.IsTrue( fMainCell.siAddNewCell(TcoCellReference,C_REF_NAME,IsiCellReference,@vCellRef1),
   'add new cell in Maincell was failed');

  Assert.IsTrue( fMainCell.siAddNewCell(TcoCellReference,C_REF_NAME,IsiCellReference,@vCellRef2),
   'add new second cell in Maincell was failed');

  vCellRef1.siAsString := fMainCell.siLongName;

  Assert.AreEqual(vCellRef1.siAsString,fMainCell.siLongName,
    'string setting was failed');

  vCellRef2.siAsCell := vCellRef1.siAsCell;

  Assert.AreEqual(vCellRef2.siAsString,fMainCell.siLongName,
    'string setting was failed');

end;

procedure TCellObjectTests.SkillInterfaceTester;
var
  vCell : IsiCellObject;
  vFirstSkill : IsiFirstSkill1;
  vSecondSkill : IsiSecondSkill1;
  vInteger : IsiInteger;
  vSize : IsiInteger;
  vMask : Integer;
  vMaskedInteger : Integer;
const
  C_TEST_INTEGER   = 99;
  C_TEST_INTEGER_2 = 66;
  C_TEST_SIZE      = 2;
begin
  // TEST Use Cases Sample 1: derived IsiMyFirstSkill1 cell object +++++++++++++

  // build a sample cell from TTcoMyFirstSkillSampleUseCase
  vCell := fMainCell.siAddNewSubCell(TcoSkilledCellSample1,'Use Case Sample 1');

  // check and get the reference of FirstSkill - Interface
  Assert.IsTrue( TCellObject.TryCellAs<IsiFirstSkill1>( vCell, vFirstSkill),
    'Sample doesnt support My first skill sample interface');

  // check an get the skill method cell of FirstSkill/siMyInteger
  Assert.IsTrue(
   vFirstSkill.siFindCell('siInteger', IsiInteger, @vInteger),
   'FirstSkill has not a valid siInteger method cell as IsiInteger');

  vFirstSkill.siInteger := C_TEST_INTEGER;

  Assert.AreEqual(vInteger.siAsInteger, C_TEST_INTEGER,
   'invalid result in skill method cell 1');

  vInteger.siAsInteger := C_TEST_INTEGER_2;

  Assert.AreEqual(vFirstSkill.siInteger, C_TEST_INTEGER_2,
   'invalid result in skill method cell 2');

  vCell := nil;
  vInteger := nil;

  // TEST Use Cases Sample 2: cell with two adapted skill interfaces +++++++++++
  vCell := fMainCell.siAddNewSubCell(TcoSkilledCellSample2, 'Use Case Sample 2');

  // check and get the reference of FirstSkill - Interface
  Assert.IsTrue(
    TCellObject.TryCellSkill<IsiFirstSkill1>( vCell, vFirstSkill),
    'Connected skill cell sample doesnt support my first skill sample interface');

  // check and get the reference of SecondSkill - Interface
  Assert.IsTrue(
    TCellObject.TryCellSkill<IsiSecondSkill1>( vCell, vSecondSkill),
    'Connected skill cell sample doesnt support second skill sample interface');

  vFirstSkill.siInteger := C_TEST_INTEGER;

  Assert.IsTrue(
    vFirstSkill.siInteger = C_TEST_INTEGER,
    'vFirstSkill.siMyInteger invalid reading or writing');

  Assert.IsTrue(
    vSecondSkill.siInteger = C_TEST_INTEGER,
    'vSecondSkill.siInteger invalid transfer in cell procedures');

  Assert.IsTrue(
    vSecondSkill.siSize = C_SECOND_SKILL_SAMPLE_SIZE,
    'siSize not the right default sample value');

  Assert.IsTrue(
    TCellObject.TryCellAs<IsiInteger>( vCell.siGetSubCell('Size'), vSize),
    'method cell siSize of SeconSkill invalid IsiInteger' );

  vSize.siAsInteger := C_TEST_SIZE;

  Assert.IsTrue(
    vSecondSkill.siSize = C_TEST_SIZE,
    'siSize not the right test value');

  vSecondSkill.siInteger := C_TEST_INTEGER;

  vMask := (1 shl C_TEST_SIZE) - 1;

  vMaskedInteger := C_TEST_INTEGER and vMask;

  Assert.IsTrue(
    vSecondSkill.siInteger = vMaskedInteger,
    'vSecondSkill.siInteger not the masked result of C_TEST_INTEGER');

  Assert.IsTrue(
    vFirstSkill.siInteger = vMaskedInteger,
    'vFirstSkill.siInteger not the masked result of C_TEST_INTEGER');

  vFirstSkill.siInteger := C_TEST_INTEGER;

  Assert.IsTrue(
    vSecondSkill.siInteger = vMaskedInteger,
    'vSecondSkill.siInteger not the masked result after first skill writing');

  Assert.IsTrue(
    vFirstSkill.siInteger = C_TEST_INTEGER,
    'vFirstSkill.siInteger is masked result after firt skill writing');

  Assert.IsTrue(
    vSecondSkill.siBit(1),
    'vSecondSkill.siBit (1) not true');

  vSecondSkill.siInc;

  Assert.IsFalse(
    vSecondSkill.siBit(1),
    'vSecondSkill.siBit (1) after inc not false');

  vCell := nil;
  vFirstSkill := nil;
  vSecondSkill := nil;
  vInteger := nil;
  vSize := nil;

  // TEST Use Cases Sample 3: cell with deposed skill interfaces cell ++++++++++
  vCell := fMainCell.siAddNewSubCell(TcoSkilledCellSample3,'Use Case Sample 3');

  // check and get the reference of SecondSkill - Interface
  Assert.IsTrue( TCellObject.TryCellAs<IsiSecondSkill1>( vCell, vSecondSkill),
    'Deposed skill cell sample doesnt support second skill sample interface');

  Assert.IsTrue( TCellObject.TryCellAs<IsiInteger>(vCell.siFindCell('second skill/siInteger'), vInteger),
    'Deposed skill methode invalid');

  vInteger.siAsInteger := C_TEST_INTEGER;

  Assert.IsTrue(
    vSecondSkill.siInteger = C_TEST_INTEGER,
    'Deposed vSecondSkill.siInteger invalid transfer in cell procedures');

  Assert.IsTrue(
    vSecondSkill.siSize = C_SECOND_SKILL_SAMPLE_SIZE,
    'Deposed siSize not the right default sample value');

  Assert.IsTrue(
    vSecondSkill.siFindCell('Size', IsiInteger, @vSize),
    'Deposed method cell siSize of SeconSkill invalid IsiInteger' );

  vSize.siAsInteger := C_TEST_SIZE;

  Assert.IsTrue(
    vSecondSkill.siSize = C_TEST_SIZE,
    'Deposed siSize not the right test value');

  vSecondSkill.siInteger := C_TEST_INTEGER;

  vMask := (1 shl vSize.siAsInteger) - 1;

  vMaskedInteger := C_TEST_INTEGER and vMask;

  Assert.IsTrue(
    vSecondSkill.siInteger = vMaskedInteger,
    'Deposed vSecondSkill.siInteger not the masked result of C_TEST_INTEGER');

  Assert.IsTrue(
    vSecondSkill.siBit(1),
    'Deposed vSecondSkill.siBit (1) not true');

  vSecondSkill.siInc;

  Assert.IsFalse(
    vSecondSkill.siBit(1),
    'Deposed vSecondSkill.siBit (1) after inc not false');

  vCell := nil;
  vSecondSkill := nil;
  vInteger := nil;
  vSize := nil;
end;

procedure TCellObjectTests.SaveDataCellTester;
var
  vSubCell     : IsiCellObject;
begin
  fMainCell.siAddNewSubCell(TCellObjectTestChild,'SaveTestObject');

  vSubCell:= fMainCell.siFindCell('SaveTestObject/TestDate');
  fMainCell.siAddSubCell(vSubCell);

  TCellObject.Root.siAddNewSubCell(TcoInteger,'TestInteger');

  TCellObject.RootSkill<IsiDiscoveryManager>.siSaveSystem('Test');

  TCellObject.Root.siRemoveSubCell('TestInteger');

end;

procedure TCellObjectTests.RestoreDataCellTester;
var
  vSubCell     : IsiCellObject;
  //vDataManager : IsiDataManager1;
begin
  // restore construction of system from SaveDataCellTester
  TCellObject.RootSkill<IsiDiscoveryManager>.siRestoreSystem('Test');

  if not fMainCell.siIsValid then
    fMainCell := TCellObject.Root.siFindCell('OP:/main cell');

  Assert.IsNotNull( TCellObject.Root.siFindCell('TestInteger'),
   'TestInteger is null after restore system' );

  Assert.IsNotNull( TCellObject.Root.siFindCell('OP:/main cell/SaveTestObject'),
   'SaveTestObject is null before restore system' );

  Assert.IsNotNull( fMainCell.siFindCell('SaveTestObject'),
   'SaveTestObject (in fMainCell) not found' );

  Assert.IsNotNull( fMainCell.siFindCell('SaveTestObject/TestDate'),
    'Link to TestDate in SaveTestObject not found' );

  TCellObject.RootSkill<IsiDiscoveryManager>.siSaveSystem('Test2');


end;


end.
