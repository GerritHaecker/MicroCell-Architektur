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
     * The skill interface "IsiCellObject" as the central interface
       supported by all micro cells and origin of all skill interfaces

     * The class "TCellObject" as the base cell and origin of all micro cells

     * The pointer type "PsiCellObject", the pointer type that points to an
         IsiCellObject interface

     * And the class type "TCellClass", which describes a class of TCellObject

     * TSkillInterfaceCell as derivate for skill interface cell use

-------------------------------------------------------------------------------}
unit OurPlant.Common.CellObject;

interface

{$REGION 'uses'}
uses
  System.Rtti,
  System.SysUtils,
  {$IF CompilerVersion >= 28.0}System.Json,{$ENDIF}
  Data.DBXJSON,
  Classes,
  OurPlant.Common.OurPlantObject,
  OurPlant.Common.CellAttributes;
{$ENDREGION}

type
  {$REGION 'Pointer types, forwards & procedure types'}
  TCellObject = class;        // forward declaration of cell object
  /// <summary>
  ///   Class type to cell object.
  /// </summary>
  TCellClass = class of TCellObject;

  IsiCellObject = interface;  // forward declaration of cell interface
  /// <summary>
  ///   Pointer type on an <b>IsiCellObject</b>
  /// </summary>
  PsiCellObject = ^IsiCellObject;

  /// <summary>
  ///   Cell procedure type define the call on call, read and write (set/get)
  ///   of cell as procedure of object
  /// </summary>
  /// <example>
  ///   <para>
  ///     MySkillMethod.siOnRead := OnMethod;
  ///   </para>
  ///   <para>
  ///     procedure OnMethode(cont aSender : IsiCellObject);
  ///   </para>
  /// </example>
  /// <seealso cref="IsiCellObject.siOnRead" />
  /// <seealso cref="IsiCellObject.siOnWrite" />
  TOnCellProcedure = procedure (const aSender : IsiCellObject) of object;
  {$ENDREGION}

  {$REGION 'IsiCellObject - Base Skill Interface'}
  /// <summary>
  ///   The <b>IsiCellObject</b> interface is the base interface (skill
  ///   Interface) of the micro cell architecture for Delphi. Basically, all
  ///   cell objects support this interface and can be addressed via it. It
  ///   represents the ability of an object to be a micro cell in the OurPlant
  ///   OS architecture.
  /// </summary>
  /// <remarks>
  ///   All cell objects must support at least this skill interface.
  ///   All public skill interfaces of the architecture are derivated from this interface
  ///   and support all properties and methods of this skill interfaces.
  /// </remarks>
  /// <example>
  ///   <code lang="Delphi">uses
  ///   OurPlant.Common.CellObject;
  /// type
  /// TCellObject = class(TInterfacedObject, IsiCellObject)
  ///   function siDiscoveryManager:IsiCellObject;
  ///   function siSelf:IsiCellObject;
  ///   // etc.
  /// end;</code>
  /// </example>
  IsiCellObject = interface(IsiOurPlantObject)
    ['{D9E6C14F-B154-4753-8769-EF00978805E9}']
    {$REGION 'Basic operations'}
    /// <summary>
    ///   siSelf get the reference of the own cell as IsiCellObject.
    /// </summary>
    function siSelf: IsiCellObject;
    /// <summary>
    ///   siIsSame check the specified cell reference is it self.
    /// </summary>
    /// <param name="aCell">
    ///   the reference to be checked as IsiCellOpbject
    /// </param>
    function siIsSame(aCell:IsiCellObject): Boolean;
    /// <summary>
    ///   Check the this cell is valid (under control) and that the controller
    ///   cell is under control too
    /// </summary>
    function siIsValid : Boolean;

    /// <summary>
    ///   Get the class of the cell object behind this cell object
    ///   interface.
    /// </summary>
    function siClass: TCellClass;

    /// <summary>
    ///   siTypeName get the cell type name from cell object class
    /// </summary>
    function siTypeName:string;
    /// <summary>
    ///   Get the global unique id (GUID) of cell object class type
    /// </summary>
    function siTypeGuid:TGUID;

    /// <summary>
    ///   get the name of cell for displaying (name and controller name)
    /// </summary>
    function siDisplayName: string;

    /// <summary>
    ///   <para>
    ///     The long name of a cell describes the cell name in its structure tree.
    ///   </para>
    ///   <para>
    ///     It contains all cell names in the structure based on the Discovery Manager.
    ///     Cells can thus be addressed in the entire system. The delimiter of
    ///     levels is "/". The Discovery as root of the structure tree names "OP:"
    ///     (example: "OP:/sampleSystem/MainCell/SubCell")
    ///   </para>
    /// </summary>
    function siLongName:string;

    /// <summary>
    ///   siIsControlled checks the the registration of a controller of cell
    ///   instance and get so the status that the instance is part of a sub cell tree.
    /// </summary>
    function siIsControlled: Boolean; overload;
    /// <summary>
    ///   siIsControlled checks the the registration of a controller of cell
    ///   instance and get so the status that the instance is part of a sub cell tree.
    /// </summary>
    /// <param name="aCell">
    ///   if the result is true, the our parameter get back the cell instance of
    ///   controller as IsiCellObject
    /// </param>
    function siIsControlled(out aCell:IsiCellObject):Boolean; overload;
    /// <summary>
    ///   siGetController get the instance of controller cell instance as IsiCellObject
    /// </summary>
    function siGetController: IsiCellObject;
    /// <summary>
    ///   <para>
    ///     iSetController set the controller cell as IsiCellObject reference
    ///   </para>
    /// </summary>
    /// <param name="aCell">
    ///   the controller cell instance as IsiCellObject reference
    /// </param>
    procedure siSetController(const aCell:IsiCellObject);
    /// <summary>
    ///   siController property read / write the controller cell instance as IsiCellObject
    /// </summary>
    property siController:IsiCellObject read siGetController write siSetController;
    {$ENDREGION}

    {$REGION 'Sub cell list operations'}
    /// <summary>
    ///   siSubCellCount get the count of sub cell entries.
    /// </summary>
    /// <remarks>
    ///   There is no guarantee that there isactually an object assigned to the
    ///   reference to a sub cell. Check this with siSubCellValid. <br />
    /// </remarks>
    function siSubCellCount : Integer; overload;
    /// <summary>
    ///  get the count of all sub cells that support a given interface.
    /// </summary>
    /// <remarks>
    ///  Array elements have the basic interface type and must be cast to aInterface
    ///  before the methods defined in it can be accessed.
    /// </remarks>
    function siSubCellCount(const aGUID : TGUID) : Integer; overload;

    /// <summary>
    ///  Checks whether aIdx is within the range of cells and whether an object is assigned to
    ///  the interface reference there.
    /// </summary>
    function siSubCellValid(const aIdx: Integer): Boolean;

    /// <summary>
    ///   Get the first founded kill interface of the this cell and sub cells.
    /// </summary>
    /// <param name="aSkillInterface">
    ///   GUID of skill interface as TGUID record
    /// </param>
    /// <returns>
    ///   the skill interface of first founded implementation as IsiCellObject
    /// </returns>
    function siSkillInterface(const aSkillInterface : TGUID; const aInterfacePtr : PsiCellObject) : Boolean;

    /// <summary>
    ///   Returns an array of all sub cells, that supports
    ///   the given interface.
    /// </summary>
    /// <param name="aInterface">
    ///   a skill interface derivated by IsiCellObject
    /// </param>
    /// <remarks>
    ///   Array elements have the basic interface type and must be cast to
    ///   aIntf before the methods defined in it can be accessed.
    /// </remarks>
    function siInterfacedSubCells(const aInterface: TGuid): TArray<IsiCellObject>;

    /// <summary>
    ///  get a list of sub cells they are controlled by this cell
    /// </summary>
    /// <remarks>
    ///  Array elements have the basic interface type and must be cast to aIntf before the methods
    ///  defined in it can be accessed.
    /// </remarks>
    function siControlledSubCells: TArray<IsiCellObject>;

    /// <summary>
    ///  Fetches the cell whose cell name matches aName.
    /// </summary>
    function siGetSubCell(const aName: string): IsiCellObject; overload;
    /// <summary>
    ///  Fetches the cell from sub cell list with the given index.
    /// </summary>
    /// <remarks>
    ///  Return type is the basic interface type. Result must be cast to the appropriate interface
    ///  type so that its methods can be accessed.
    /// </remarks>
    function siGetSubCell(const aIdx: Integer): IsiCellObject; overload;
    /// <summary>
    ///   Save the interface reference in the cell list position of idx
    /// </summary>
    /// <param name="aIdx">
    ///   sub cell listing index
    /// </param>
    /// <param name="aReference">
    ///   interface reference
    /// </param>
    /// <remarks>
    ///   <para>
    ///     ACHTUNG! NOT FOR PUBLIC USE!
    ///   </para>
    ///   <para>
    ///     The list will be writen by siAddSubCell
    ///   </para>
    /// </remarks>
    procedure siSetSubCell(const aIdx: Integer; const aReference: IsiCellObject);
    /// <summary>
    ///   Read / write the cell reference on sub cell list on position aIdx
    /// </summary>
    property siSubCell[const aIdx : integer] : IsiCellObject read siGetSubCell write siSetSubCell;

    /// <summary>
    ///   siSwapSubCell exchange an existing cell with a cell to be changed
    /// </summary>
    /// <param name="aOldCell">
    ///   a existing cell as IsiCellObject reference
    /// </param>
    /// <param name="aNewCell">
    ///   a cell to be changed as IsiCellObject reference
    /// </param>
    function siSwapSubCell(const aOldCell: IsiCellObject; const aNewCell: IsiCellObject): Boolean;

    /// <summary>
    ///   <para>
    ///     Add the cell as IsiCellObject reference at the end of the sub
    ///     cell list.
    ///   </para>
    ///   <para>
    ///     The add option is the default as dynamic entry.
    ///   </para>
    /// </summary>
    /// <param name="aCell">
    ///   a cell as IsiCellObject reference or NIL
    /// </param>
    function siAddSubCell(const aCell: IsiCellObject): IsiCellObject;

    /// <summary>
    ///   Create a cell of cell class, set the name of new cell and add its in
    ///   sub cell list
    /// </summary>
    /// <param name="aCellClass">
    ///   The cell object class (TCellObject or derivate)
    /// </param>
    /// <param name="aName">
    ///   The name of new cell or empty string for auto naming
    /// </param>
    function siAddNewSubCell(const aCellClass: TCellClass; const aName: string): IsiCellObject; overload;
    /// <summary>
    ///   Build a cell from cell type register with type name, set the name of
    ///   new cell and add its in sub cell list
    /// </summary>
    /// <param name="aTypeName">
    ///   cell type name
    /// </param>
    /// <param name="aName">
    ///   position in sub cell list
    /// </param>
    function siAddNewSubCell(const aTypeName: string; const aName: string): IsiCellObject; overload;
    /// <summary>
    ///   Build a new cell from cell type register with type GUID, set the name
    ///   of new cell and add it in sub cell list
    /// </summary>
    /// <param name="aTypeGuid">
    ///   cell type GUID
    /// </param>
    /// <param name="aName">
    ///   Position in sub cell list
    /// </param>
    function siAddNewSubCell(const aTypeGuid: TGUID; const aName: string): IsiCellObject; overload;

    /// <summary>
    ///   Insert the cell as IsiCellObject reference at the given position of
    ///   the sub cell list. <br />
    /// </summary>
    /// <param name="aCell">
    ///   cell as IsiCellObject reference
    /// </param>
    /// <param name="aPosition">
    ///   insert position as index of list (first position = 0)
    /// </param>
    function siInsertSubCell(const aCell: IsiCellObject; const aPosition: Integer): IsiCellObject;

    /// <summary>
    ///   Create a cell of cell class, set the name of new cell and insert its in
    ///   sub cell list on defined position.
    /// </summary>
    /// <param name="aCellClass">
    ///   The cell object class (TCellObject or derivate)
    /// </param>
    /// <param name="aName">
    ///   The name of new cell or empty string for auto naming
    /// </param>
    /// <param name="aPosition">
    ///   The position in sub cell list
    /// </param>
    function siInsertNewSubCell(const aCellClass: TCellClass; const aName: string; const aPosition: Integer): IsiCellObject; overload;
    /// <summary>
    ///   Build a cell from cell type register with type name, set the name of
    ///   new cell and insert its in sub cell list on position
    /// </summary>
    /// <param name="aTypeName">
    ///   cell type name
    /// </param>
    function siInsertNewSubCell(const aTypeName: string; const aName: string; const aPosition: Integer): IsiCellObject; overload;
    /// <summary>
    ///   Build a new cell from cell type register with type GUID, set the name
    ///   of new cell and insert it in sub cell list on position.
    /// </summary>
    /// <param name="aTypeGuid">
    ///   cell type GUID
    /// </param>
    function siInsertNewSubCell(const aTypeGuid: TGUID; const aName: string; const aPosition: Integer): IsiCellObject; overload;

    /// <summary>
    ///   Construct (add) the cell as IsiCellObject reference in the sub cell
    ///   list. <br /><br />The add option is constructed as fixed cell. <br />
    /// </summary>
    /// <param name="aCell">
    ///   cell as IsiCellObject reference
    /// </param>
    /// <remarks>
    ///   This function is used when sub cells are added to the list by during
    ///   construction (i.e. in the compiler). The entry is inserted into the
    ///   front (constructed) part of the list and an internal counter is
    ///   incremented. These constructed cells are fixed entries and are only
    ///   treated in terms of content but not existentially by list functions. <br />
    /// </remarks>
    function siConstructSubCell(const aCell: IsiCellObject): IsiCellObject;

    /// <summary>
    ///   build a new cell and add it in sub cell list as construced cell
    /// </summary>
    /// <param name="aCellClass">
    ///   The cell object class (TCellObject or derivate)
    /// </param>
    /// <param name="aName">
    ///   The name of new cell or empty string for auto naming
    /// </param>
    function siConstructNewSubCell(const aCellClass: TCellClass; const aName: string): IsiCellObject; overload;
    /// <summary>
    ///   Build a cell from cell type register with type name, set the name of
    ///   new cell and add its in sub cell list as constructed cell
    /// </summary>
    /// <param name="aTypeName">
    ///   cell type name
    /// </param>
    /// <param name="aName">
    ///   position in sub cell list
    /// </param>
    function siConstructNewSubCell(const aTypeName: string; const aName: string): IsiCellObject; overload;
    /// <summary>
    ///   Build a new cell from cell type register with type GUID, set the name
    ///   of new cell and add it in sub cell list as constructed cell.
    /// </summary>
    /// <param name="aTypeGuid">
    ///   cell type GUID
    /// </param>
    /// <param name="aName">
    ///   Position in sub cell list
    /// </param>
    function siConstructNewSubCell(const aTypeGuid: TGUID; const aName: string): IsiCellObject; overload;

    /// <summary>
    ///   Remove the entry on index from the cell list and get the new cell
    ///   list count.
    /// </summary>
    /// <param name="aIdx">
    ///   index in sub cell list
    /// </param>
    function siRemoveSubCell(const aIdx: Integer): Boolean; overload;
    /// <summary>
    ///   Remove the entry with name from the sub cell list and get the new
    ///   cell list count.
    /// </summary>
    function siRemoveSubCell(const aName: string): Boolean; overload;
    /// <summary>
    ///   Remove the given cell with IsiCellObject reference from the list and
    ///   return the new cell list count.
    /// </summary>
    function siRemoveSubCell(const aCell: IsiCellObject): Boolean; overload;

    /// <summary>
    ///   Remove all entries from sub cell list.
    /// </summary>
    procedure siRemoveAllSubCells;

    /// <summary>
    ///   find a cell with long name in sub tree or cell tree
    /// </summary>
    /// <param name="aLongName">
    ///   the name of the cell as LongName
    /// </param>
    /// <remarks>
    ///   <para>
    ///     Return type is the IsiCellObject. Result must be cast to the
    ///     appropriate interface type so that its methods can be accessed.
    ///   </para>
    ///   <para>
    ///     Possible syntax for long names:
    ///   </para>
    ///   <list type="bullet">
    ///     <item>
    ///       (empty) -&gt; get the one cell reference
    ///     </item>
    ///     <item>
    ///       'CellName' -&gt; search the cell name in the sub cell list of
    ///       one cell
    ///     </item>
    ///     <item>
    ///       'OP:/CellName/...' or '/CellName/...' search cell name from
    ///       root (Discovery Manager)
    ///     </item>
    ///     <item>
    ///       '../CellName/...' search cell name in one level deeper
    ///       (controller)
    ///     </item>
    ///   </list>
    /// </remarks>
    function siFindCell(const aLongName: string): IsiCellObject; overload;
    /// <summary>
    ///   Try to find the cell by long name and write in pointer the reference
    ///   as IsiCellobjet
    /// </summary>
    function siFindCell(const aLongName: string; const aIntf : PsiCellObject) : Boolean; overload;
    /// <summary>
    ///   Try to find the cell by long name and try to get a reference of aGuid
    ///   interface in pointer PsiCellObject
    /// </summary>
    function siFindCell( const aLongName: string; const aInterfaceGuid : TGUID;
      const aIntf : PsiCellObject) : Boolean; overload;

    /// <summary>
    ///   Create a new cell instance of TCellClass with name from longname in
    ///   sub cell tree of longname and get out in Pointer of Interface the
    ///   reference of named interface by GUID. Add this new cell as dynamic
    ///   entry in the destination tree and get true result when all criteria
    ///   was successful.
    /// </summary>
    /// <param name="aCellClass">
    ///   The class of to created cell object instance
    /// </param>
    /// <param name="aLongName">
    ///   the long name of new cell with destination tree and cell name
    /// </param>
    /// <param name="aGUID">
    ///   The Guid of the classified interface
    /// </param>
    /// <param name="aIntf">
    ///   Pointer to variable of classified interface
    /// </param>
    /// <example>
    ///   Assert ( siAddNewCell( TcoInteger, 'SamplePath/MyInteger',
    ///   IsiInteger, @fsiMyInteger), 'Invalid addition of SamplePath/MyInteger
    ///   in TDemoCellObject');
    /// </example>
    function siAddNewCell( const aCellClass: TCellClass; const aLongName: string;
      const aInterfaceGUID : TGUID; const aIntf : PsiCellObject) : Boolean; overload;
    /// <summary>
    ///   Create a new cell instance of TCellClass with name from longname in
    ///   sub cell tree of longname and get out in Pointer of IsiCellObject.
    ///   Add this new cell as dynamic entry in the destination tree and get
    ///   true result when all criteria was successful.
    /// </summary>
    /// <param name="aCellClass">
    ///   The class of to created cell object instance
    /// </param>
    /// <param name="aLongName">
    ///   the long name of new cell with destination tree and cell name
    /// </param>
    /// <param name="aIntf">
    ///   Pointer to variable of classified interface
    /// </param>
    /// <param name="aInterfaceGUID">
    ///   Skill interface GUID
    /// </param>
    /// <param name="aGUID">
    ///   The Guid of the classified interface
    /// </param>
    /// <example>
    ///   Assert ( siAddNewCell( TcoInteger, 'SamplePath/MyInteger',
    ///   IsiInteger, @fsiMyInteger), 'Invalid addition of SamplePath/MyInteger
    ///   in TDemoCellObject');
    /// </example>
    function siAddNewCell( const aCellClass: TCellClass; const aLongName: string;
      const aIntf : PsiCellObject) : Boolean; overload;

    /// <summary>
    ///   Create a new cell instance of TCellClass with name from longname in
    ///   sub cell tree of longname and get out in Pointer of Interface the
    ///   reference of named interface by GUID. Construct (Add) this new cell as
    ///   fixed construstion entry in the destination tree and get true result
    ///   when all criteria was successful.
    /// </summary>
    /// <param name="aCellClass">
    ///   The class of to created cell object instance
    /// </param>
    /// <param name="aLongName">
    ///   the long name of new cell with destination tree and cell name
    /// </param>
    /// <param name="aGUID">
    ///   The Guid of the classified interface
    /// </param>
    /// <param name="aIntf">
    ///   Pointer to variable of classified interface
    /// </param>
    /// <example>
    ///   Assert ( siAddNewCell( TcoInteger, 'SamplePath/MyInteger',
    ///   IsiInteger, @fsiMyInteger), 'Invalid addition of SamplePath/MyInteger
    ///   in TDemoCellObject');
    /// </example>
    function siConstructNewCell( const aCellClass: TCellClass; const aLongName: string;
      const aInterfaceGUID : TGUID; const aIntf : PsiCellObject) : Boolean; overload;
    /// <summary>
    ///   Create a new cell instance of TCellClass with name from longname in
    ///   sub cell tree of longname and get out in Pointer of IsiCellObject
    ///   Construct (Add) this new cell as fixed construstion entry in the
    ///   destination tree and get true result when all criteria was successful.
    /// </summary>
    /// <param name="aCellClass">
    ///   The class of to created cell object instance
    /// </param>
    /// <param name="aLongName">
    ///   the long name of new cell with destination tree and cell name
    /// </param>
    /// <param name="aGUID">
    ///   The Guid of the classified interface
    /// </param>
    /// <param name="aIntf">
    ///   Pointer to variable of classified interface
    /// </param>
    /// <example>
    ///   Assert ( siAddNewCell( TcoInteger, 'SamplePath/MyInteger',
    ///   IsiInteger, @fsiMyInteger), 'Invalid addition of SamplePath/MyInteger
    ///   in TDemoCellObject');
    /// </example>
    function siConstructNewCell( const aCellClass: TCellClass; const aLongName: string;
      const aIntf : PsiCellObject) : Boolean; overload;

    /// <summary>
    ///   Delete the named cell from his controller sub cell list and get
    ///   success as result.
    /// </summary>
    function siDeleteCell( const aLongName : string) : boolean; overload;
    /// <summary>
    ///   Delete cell from his controller sub cell list and get success as
    ///   result.
    /// </summary>
    function siDeleteCell( const aCell : IsiCellObject) : boolean; overload;
    /// <summary>
    ///   Delete this cell from his controller sub cell list and get success as
    ///   result.
    /// </summary>
    function siDeleteCell : boolean; overload;
    {$ENDREGION}

    {$REGION 'On cell call procedure'}
    /// <summary>
    ///   Get the cell call procedure of siGetValue or siCall
    /// </summary>
    function siGetOnRead : TOnCellProcedure;
    /// <summary>
    ///   Set the cell call procedure of siGetValue or siCall
    /// </summary>
    procedure siSetOnRead(const aOnCellProcedure : TOnCellProcedure);
    /// <summary>
    ///   Read / write the cell call procedure of siGetValue or siCall
    /// </summary>
    property siOnRead : TOnCellProcedure read siGetOnRead write siSetOnRead;

    /// <summary>
    ///   Get the cell call procedure of siSetValue
    /// </summary>
    function siGetOnWrite : TOnCellProcedure;
    /// <summary>
    ///   Set the cell call procedure of siSetValue
    /// </summary>
    procedure siSetOnWrite(const aOnCellProcedure : TOnCellProcedure);
    /// <summary>
    ///   Read / write the cell call procedure of siSetValue
    /// </summary>
    property siOnWrite : TOnCellProcedure read siGetOnWrite write siSetOnWrite;

    /// <summary>
    ///   call the cell call procedure
    /// </summary>
    procedure siCall;
    {$ENDREGION}

    {$REGION 'Value content operations'}
    /// <summary>
    ///   Get the the value as RTTI TValue.
    /// </summary>
    function siGetValue : TValue; overload;
    /// <summary>
    ///   Get the value of the long namend cell as RTTI TValue.
    /// </summary>
    /// <param name="aLongName">
    ///   Describe the long name of cell started from the cell object reference
    ///   (relative) or from root or with relative structure orientation ("../").
    /// </param>
    /// <remarks>
    ///   The long name describe the cell in the sub cell structure.
    ///   Empty String '' is self.
    /// </remarks>
    function siGetValue(const aLongName: string) : TValue; overload;
    /// <summary>
    ///   Set the value of cell as RTTI TValue.
    /// </summary>
    /// <param name="aValue">
    ///   cell value as RTTI TValue
    /// </param>
    procedure siSetValue(const aValue: TValue); overload;
    /// <summary>
    ///   Set the value of the long namend cell as RTTI TValue.
    /// </summary>
    /// <param name="aLongName">
    ///   Describe the long name of cell started from the cell (self).
    /// </param>
    /// <param name="aValue">
    ///   The cell value as RTTI TValue
    /// </param>
    procedure siSetValue(const aLongName: string; const aValue: TValue); overload;
    /// <summary>
    ///   Read and write the value content of self as RTTI TValue
    /// </summary>
    property siValue:TValue read siGetValue write siSetValue;

    /// <summary>
    ///   Try to get the Value of a long named cell. Get the result, whose
    ///   the named cell is valid and get the value as RTTI TValue in aResult.
    /// </summary>
    /// <param name="aLongName">
    ///   Descripe the sub cell as long name
    /// </param>
    /// <param name="aResult">
    ///   Result as out parameter with the Value as TValue
    /// </param>
    /// <remarks>
    ///   The long name describe the cell in the sub cell structure.
    ///   Empty String '' is self.
    /// </remarks>
    function siTryGetValue(const aLongName: string; out aResult: TValue) : Boolean;
    /// <summary>
    ///   Try to set the value of a long named sub cell. Check that when the
    ///   named cell is valid and value is setted.
    /// </summary>
    /// <param name="aLongName">
    ///   Descripe the sub cell as longname string
    /// </param>
    /// <param name="aValue">
    ///   cell value as RTTI TValue
    /// </param>
    function siTrySetValue(const aLongName: string; const aValue: TValue) : Boolean;

    /// <summary>
    ///   <para>
    ///     get the cell value or content as string, can be a data value or the
    ///     specific content of a cell as string
    ///   </para>
    ///   <para>
    ///     TCellObject return the RTTI Value as string as default
    ///   </para>
    /// </summary>
    function  siGetAsString : string;
    /// <summary>
    ///   Set the cell value or content from string.
    /// </summary>
    /// <param name="aValue">
    ///   value
    /// </param>
    procedure siSetAsString(const aValue: String);
    /// <summary>
    ///   Read / write the value or content of cell as string.
    /// </summary>
    property siAsString : string read siGetAsString write siSetAsString;

    /// <summary>
    ///   Get the value of cell object as JSON Value. The virtual function of
    ///   base cell object get the value in JSON. Override in deviated cells.
    /// </summary>
    function siGetAsJSON : TJSONValue;
    /// <summary>
    ///   Set the value of cell object as JSON Value. The virtual function is only
    ///   predefined and must be overrided in derivated cell with detail content.
    /// </summary>
    procedure siSetAsJSON(aJSONValue : TJSONValue);
    /// <summary>
    ///   Read and write the value of cell object as JSON value.
    /// </summary>
    property siAsJSON : TJSONValue read siGetAsJSON write siSetAsJSON;

    /// <summary>
    ///   Get the cell value and sub cell structure as JSON Object as MainRequest
    /// </summary>
    function siGetCellContentAsJSONObject: TJSONObject; overload;
    /// <summary>
    ///   Get the cell value and sub cell structure as JSON Object
    /// </summary>
    /// <param name="aMainRequest">
    ///   set the request as Main request, otherwise as sub cell request
    /// </param>
    /// <remarks>
    ///   They differentiate between main requests or sub cell requests. The
    ///   master data (name and type) are always supplied. For main request,
    ///   the values and structures are always supplied. In the case of sub
    ///   cell request, the values and structures are only supplied if the
    ///   NoContentAtSubCellRequest attribute has not been set.
    /// </remarks>
    function siGetCellContentAsJSONObject(const aMainRequest: Boolean): TJSONObject; overload;
    /// <summary>
    ///   Set the cell value and sub cell structure from JSON Object as MainRequest
    /// </summary>
    /// <param name="aJSONObject">
    ///   the source for content as JSON Object
    /// </param>
    procedure siSetCellContentFromJSONObject(const aJSONObject: TJSONObject); overload;
    /// <summary>
    ///   Set the cell value and sub cell structure from JSON Object
    /// </summary>
    /// <param name="aJSONObject">
    ///   the source for content as JSON Object
    /// </param>
    /// <param name="aMainRequest">
    ///   set the request as Main request, otherwise as sub cell request
    /// </param>
    /// <remarks>
    ///   They differentiate between main requests or sub cell requests. The
    ///   master data (name and type) are always supplied. For main request,
    ///   the values and structures are always supplied. In the case of sub
    ///   cell request, the values and structures are only supplied if the
    ///   NoContentAtSubCellRequest attribute has not been set.
    /// </remarks>
    procedure siSetCellContentFromJSONObject(const aJSONObject: TJSONObject; const aMainRequest: Boolean); overload;
    {$ENDREGION}

    {$REGION 'Save and restore operations'}
    /// <summary>
    ///   Call in the save method parent cells (beginning by discovery manager)
    ///   and call the save method of each sub cells.
    /// </summary>
    /// <remarks>
    ///   To overwrite for own storage management.
    /// </remarks>
    procedure siSave;
    /// <summary>
    ///   Call in the restore method parent cells (beginning by discovery
    ///   manager) and call the restore method of each sub cells.
    /// </summary>
    /// <remarks>
    ///   To overwrite for own storage management.
    /// </remarks>
    procedure siRestore;
    {$ENDREGION}
  end;
  {$ENDREGION}

  {$REGION 'TCellObject - Base cell object'}
  /// <summary>
  ///   Is the base cell object and ancestor of all cell object classes. It
  ///   supports the basic skill interface. It implements all the necessary
  ///   basic functions of a micro cell. In the registry, it is listed under
  ///   the type name "cell" and can also be identified by its type GUID
  ///   09EDF8FC-2638-47F4-9332-928396A4F4B7.
  /// </summary>
  /// <remarks>
  ///   A cell can contain logic that links its sub-cells to each other.
  ///   Sub-cells do not communicate directly with each other. A cell can
  ///   interact with its sub-cells by calling their methods. For example, the
  ///   cell can send information to a sub-cell by calling a setter method of
  ///   the sub-cell. Sub-cells are always accessed via appropriate skill
  ///   interfaces.
  ///   For proper registration, each derived cell object class must be registered in
  ///   cell type registers. The RegisterCellType attribute is used for this purpose.
  ///   The parameters must be type name and type GUID. A new unique GUID can be
  ///   created via CTRL + SHIFT + G. The square brackets must be removed manually.
  /// </remarks>
  [RegisterCellType('cell','{09EDF8FC-2638-47F4-9332-928396A4F4B7}')]
  TCellObject = class(TOurPlantObject, IsiCellObject)
  strict protected
    {$REGION 'TsiCellObject protected internal vars'}
    /// <summary>
    ///   contain the type name of this cell object
    /// </summary>
    fCellTypeName         : string;
    /// <summary>
    ///   contain the GUID of this cell object
    /// </summary>
    fCellTypeGuid         : TGUID;
    /// <summary>
    ///   CellValue is implemented in TCellObject as RTTI value
    ///   for individual use. Even cell can handle one value in basically. The
    ///   type is defined in derivation or in run time.
    /// </summary>
    fCellValue            : TValue;
    /// <summary>
    ///   fSubCells is strict protect implemented in TCellObject and is the sub
    ///   cell list of the cell. Even cell can handle on sub cell list. <br />
    /// </summary>
    fSubCells             : TArray<IsiCellObject>;
    /// <summary>
    ///   fConstructedCellCount is strict protect implemented in TCellObject
    ///   and get count of constructed sub cells. <br />
    /// </summary>
    fConstructedCellCount : Integer;
    /// <summary>
    ///   fController is strict protect implemented in TCellObject and hold the
    ///   controller cell of cell as Pointer. <br />
    /// </summary>
    fController           : Pointer;
    /// <summary>
    ///   Is strict protect implemented in TCellObject and contains the cell
    ///   procedure to execute direct (siExecute) and on get / get value event.
    /// </summary>
    fOnRead               : TOnCellProcedure;
    fOnWrite              : TOnCellProcedure;
    /// <summary>
    ///   contain status, that cell during the execution of call procedure
    /// </summary>
    fDuringCellCall       : Boolean;
    /// <summary>
    ///   cell get content during a sub cell request
    /// </summary>
    fSubCellContent       : Boolean;
    /// <summary>
    ///   flag get the status, that the cell is bhind the construction. Need
    ///   the isValid check of controlling this cell
    /// </summary>
    fIsAfterConstruction  : Boolean;
    {$ENDREGION}
  public
    {$REGION 'TCellObject public commons'}
    /// <summary>
    ///   <para>
    ///     AfterConstruction will construct the content and structure of cell.
    ///   </para>
    /// </summary>
    procedure AfterConstruction; override;
    /// <summary>
    ///  construction of cell content & structures and set defaults
    ///  Are called at the end of AfterConstruction of TCellobject. Derivate's
    ///  overrides this method to define and construct the cell structure and
    ///  settings.
    /// </summary>
    procedure CellConstruction; virtual;
    /// <summary>
    ///   <para>
    ///     BeforeDestruction to call before destruction of Object instance.
    ///   </para>
    ///   <para>
    ///     clear list
    ///   </para>
    /// </summary>
    procedure BeforeDestruction; override;
    {$ENDREGION}

    {$REGION 'TCellObject public class methods'}
    /// <summary>
    ///   check the valid of a cell (Assigning and supports as IsiCellObject
    ///   and has a controller)
    /// </summary>
    class function IsValid( const aCell : IsiCellObject) : boolean;
    /// <summary>
    ///   check the assign of the cell interface reference, the control of the
    ///   cell and that the cell supports the typed skill interface
    /// </summary>
    class function IsValidAs<T : IsiCellObject>( const aCell : IsiCellObject) : Boolean; overload;
    /// <summary>
    ///   check the assign of the cell interface reference, the control of the
    ///   cell and that the cell supports the typed skill interface and get in aResult
    /// </summary>
    class function IsValidAs<T : IsiCellObject>( const aCell : IsiCellObject; out aResult : T) : Boolean; overload;

    /// <summary>
    ///  get the first valid reference of cell or sub cell from the type skill interface
    /// </summary>
    class function CellSkill<T : IsiCellObject>( const aCell : IsiCellObject) : T;
    /// <summary>
    ///  check precence and validation of typed skill interface in cell or in sub cell list of cell
    /// </summary>
    class function TryCellSkill<T : IsiCellObject>( const aCell : IsiCellObject) : Boolean; overload;
    /// <summary>
    ///  check precence and validation of typed skill interface in cell or in sub cell list of cell
    ///  and get the first valid reference (first in cell then in sub cell list´)
    /// </summary>
    class function TryCellSkill<T : IsiCellObject>( const aCell : IsiCellObject; out aResult : T) : Boolean; overload;

    /// <summary>
    ///   Get the root of MicroCell System as IsiCellObject. The root is the
    ///   discovery manager and fix point (root) of the cell structure. Create
    ///   the standard TcoDiscoveryManager, when nil. <br />
    /// </summary>
    class function  Root : IsiCellObject;
    /// <summary>
    ///   Set the root cell of MicroCell system. The referenced cell must
    ///   support the IsiDiscoveryManager.
    /// </summary>
    class procedure SetRootCell( const aCell : IsiCellObject);

    /// <summary>
    ///   Get the first reference of typed skill interface of root or sub list of root. The root
    ///   is the discovery manager and fix point (root) of the MicroCell structure.
    ///   Create the standard TcoDiscoveryManager, when nil.
    /// </summary>
    class function  RootSkill<T : IsiCellObject> : T;
    /// <summary>
    ///   Check the validation and support of typed skill interface in root or sub list of root.
    ///   When valid the get the root of MicroCell System as IsiCellObject in aCResult.
    ///   The root is the discovery manager and fix point (root) of the cell
    ///   structure. Create the standard TcoDiscoveryManager, when nil.
    /// </summary>
    class function  TryRootSkill<T : IsiCellObject> : Boolean; overload;
    /// <summary>
    ///   Check the validation and support of typed skill interface in root or sub list of root.
    ///   The root is the discovery manager and fix point (root) of the cell
    ///   structure. Create the standard TcoDiscoveryManager, when nil.
    /// </summary>
    class function  TryRootSkill<T : IsiCellObject>( out aResult : T ) : Boolean; overload;

    /// <summary>
    ///   <para>
    ///     RegisterExplicit forces the cell to be called in initialization
    ///     and thus also forces registration
    ///   </para>
    ///   <para>
    ///     Start this class procedure for the inherited class in
    ///     initialization.
    ///   </para>
    /// </summary>
    /// <remarks>
    ///   Cell object, they will used only in run time are invisible for the
    ///   RTTI context. The code optimization of delphi compile only object,
    ///   they are used in other source code.
    /// </remarks>
    /// <example>
    ///   initialization <br />TcoLink.RegisterExplicit; <br />
    /// </example>
    class procedure RegisterExplicit;
    {$ENDREGION}
  strict protected
    {$REGION 'TCellObject protected cell methods for cell management'}
    // eigene und nicht Interface unterstützte Methoden zur internen Verwaltung der Zellen
    /// <summary>
    ///   check the presence of typed attribute in the given RTTI type, get the
    ///   attribute, when exist.
    /// </summary>
    function FindAttribute<T: TCustomAttribute>( const aRTTIType : TRttiType; out aResult : T) : Boolean;

    /// <summary>
    ///   Add the existing cell reference as construction (fix) sub cell in the 
    ///   destination named cell structure (by cell long name of destination) 
    ///   and check the validation and support of the typed skill interface, 
    ///   when successful get the typed skill interface in aResult.
    /// </summary>
    function TryConstructCellAs<T : IsiCellObject>( const aExistingCell: IsiCellObject;
      const aDestinationName: string; out aResultCell : T ): Boolean;

    /// <summary>
    ///   Add the existing cell reference as construction (fix) sub cell in the 
    ///   destination named cell structure (by cell long name of destination) 
    ///   and check the validation and support of the typed skill interface and 
    ///   get the typed skill interface when successful. The destination name 
    ///   is optional, when empty add the cell in the own sub cell list.
    /// </summary>
    /// <typeparam name="T">
    ///   Typed skill interface
    /// </typeparam>
    /// <param name="aExistingCell">
    ///   Reference of present exist cell as IsiCellObject
    /// </param>
    /// <param name="aDestinationName">
    ///   a long named destination sub cell list, when empty the the own sub 
    ///   cell list
    /// </param>
    /// <returns>
    ///   the added cell reference as typed skill interface
    /// </returns>
    function ConstructCellAs<T : IsiCellObject>( const aExistingCell: IsiCellObject;
      const aDestinationName: string = '' ): T; overload;
    /// <summary>
    ///   Add the long named existing cell reference as construction (fix) sub 
    ///   cell in the destination named cell structure (by cell long name of 
    ///   destination) and check the validation and support of the typed skill 
    ///   interface and get the typed skill interface when successful. The 
    ///   destination name is optional, when empty add the cell in the own sub 
    ///   cell list.
    /// </summary>
    /// <typeparam name="T">
    ///   Typed skill interface
    /// </typeparam>
    /// <param name="aExistingName">
    ///   a long named existing cell
    /// </param>
    /// <param name="aDestinationName">
    ///   a long named destination sub cell list, when empty the the own sub 
    ///   cell list
    /// </param>
    /// <param name="aExistingCell">
    ///   Reference of present exist cell as IsiCellObject
    /// </param>
    /// <returns>
    ///   the added cell reference as typed skill interface
    /// </returns>
    function ConstructCellAs<T : IsiCellObject>( const aExistingName: string;
      const aDestinationName: string = '' ): T; overload;

    /// <summary>
    ///   Add the existing cell reference as construction (fix) sub cell in the 
    ///   destination named cell structure (by cell long name of destination) 
    ///   and check the validation of IsiCellObject. Get the IsiCellObject 
    ///   skill interface when successful. The destination name is optional, 
    ///   when empty add the cell in the own sub cell list.
    /// </summary>
    /// <param name="aExistingCell">
    ///   Reference of present exist cell as IsiCellObject
    /// </param>
    /// <param name="aDestinationName">
    ///   a long named destination sub cell list, when empty the the own 
    ///   subcell list
    /// </param>
    /// <returns>
    ///   the added cell reference as IsiCellObject interface
    /// </returns>
    function ConstructCell( const aExistingCell: IsiCellObject;
      const aDestinationName: string = '' ): IsiCellObject; overload;
    /// <summary>
    ///   Add the long named existing cell reference as construction (fix) sub 
    ///   cell in the destination named cell structure (by cell long name of 
    ///   destination) and check the validation of IsiCellObject. Get the 
    ///   IsiCellObject skill interface when successful. The destination name 
    ///   is optional, when empty add the cell in the own sub cell list.
    /// </summary>
    /// <param name="aExistingName">
    ///   a long named existing cell
    /// </param>
    /// <param name="aDestinationName">
    ///   a long named destination sub cell list, when empty the the own 
    ///   subcell list
    /// </param>
    /// <param name="aExistingCell">
    ///   Reference of present exist cell as IsiCellObject
    /// </param>
    /// <returns>
    ///   the added cell reference as IsiCellObject interface
    /// </returns>
    function ConstructCell( const aExistingName: string;
      const aDestinationName: string = '' ): IsiCellObject; overload;

    /// <summary>
    ///   Create a new classified cell and add the cell as construction (fix)
    ///   sub cell in the destination named cell structure (by cell long name
    ///   of destination) and check the validation and support of the typed
    ///   skill interface, when successful get the typed skill interface in
    ///   aResult.
    /// </summary>
    function TryConstructNewCellAs<T : IsiCellObject>( const aCellClass: TCellClass;
      const aLongName: string; out aResultCell : T ): Boolean; overload;

    /// <summary>
    ///   Create a new classified cell and add the cell as construction (fix)
    ///   sub cell in the destination long named cell structure and check the
    ///   validation and support of the typed skill interface and get the typed
    ///   skill interface when successful. The destination name is optional,
    ///   when empty add the cell in the own sub cell list. The name of the new
    ///   cell will separated from long name
    /// </summary>
    /// <typeparam name="T">
    ///   Typed skill interface
    /// </typeparam>
    /// <param name="aCellClass">
    ///   cell class for new cell type
    /// </param>
    /// <param name="aLongName">
    ///   long name for destination and new cell name
    /// </param>
    /// <returns>
    ///   the added cell reference as typed skill interface
    /// </returns>
    function ConstructNewCellAs<T : IsiCellObject>( const aCellClass: TCellClass;
      const aLongName: string = '' ): T;
    /// <summary>
    ///   Create a new classified cell and add the cell as construction (fix)
    ///   sub cell in the destination long named cell structure and check the
    ///   validation and get the IsiCellObject interface when successful. The
    ///   destination name is optional, when empty add the cell in the own sub
    ///   cell list. The name of the new cell will separated from long name.
    /// </summary>
    /// <typeparam name="T">
    ///   Typed skill interface
    /// </typeparam>
    /// <param name="aCellClass">
    ///   cell class for new cell type
    /// </param>
    /// <param name="aLongName">
    ///   long name for destination and new cell name
    /// </param>
    /// <returns>
    ///   the added cell reference as typed skill interface
    /// </returns>
    function ConstructNewCell( const aCellClass: TCellClass;
      const aLongName: string = '' ): IsiCellObject; overload;
    /// <summary>
    ///   Create a new cell from TCellObject and add the cell as construction (fix)
    ///   sub cell in the destination long named cell structure and check the
    ///   validation and get the IsiCellObject interface when successful. The
    ///   destination name is optional, when empty add the cell in the own sub
    ///   cell list. The name of the new cell will separated from long name.
    /// </summary>
    /// <typeparam name="T">
    ///   Typed skill interface
    /// </typeparam>
    /// <param name="aLongName">
    ///   long name for destination and new cell name
    /// </param>
    /// <returns>
    ///   the added cell reference as typed skill interface
    /// </returns>
    function ConstructNewCell( const aLongName: string = ''): IsiCellObject; overload;

    /// <summary>
    ///   Delete all not constructed entries from sub cell list.
    /// </summary>
    procedure ClearRunTimeSubCells;
    {$ENDREGION}
  strict protected
    {$REGION 'IsiCellObject implementation - Basic operations'}
    /// <summary>
    ///   The implementation siSelf get the reference of the own cell as IsiCellObject.
    /// </summary>
    function siSelf:IsiCellObject;
    /// <summary>
    ///   The implementation siIsSame check the cell reference to it self.
    /// </summary>
    /// <param name="aCell">
    ///   the reference to be checked as IsiCellOpbject
    /// </param>
    function siIsSame(aCell:IsiCellObject): Boolean;
    /// <summary>
    ///   Check the this cell is valid (under control) and that the controller
    ///   cell is under control too
    /// </summary>
    function siIsValid : Boolean; virtual;

    /// <summary>
    ///   The implemantation get the class of the cell
    ///   interface.
    /// </summary>
    function siClass : TCellClass;

    /// <summary>
    ///   The implementation siTypeName get the type name of cell
    /// </summary>
    function siTypeName:string;
    /// <summary>
    ///   The implementation get the global unique id (GUID) of cell type
    /// </summary>
    function siTypeGuid:TGUID;

    /// <summary>
    ///   The implemenation set the cell name of the cell
    /// </summary>
    /// <param name="aName">
    ///   The name of cell object instance
    /// </param>
    /// <remarks>
    ///   The cell name must be unique in the sub cell structure of controller.
    ///   TCellObject check it and add a counting number if necessary.
    /// </remarks>
    procedure siSetName(const aName:string); override;
    /// <summary>
    ///   get the name of cell for displaying (name and controller name)
    /// </summary>
    function siDisplayName: string; virtual;
    /// <summary>
    ///   <para>
    ///     The implemenation describes the cell name in its structure tree.
    ///   </para>
    ///   <para>
    ///     It contains all cell names in the structure based on the Discovery Manager.
    ///     Cells can thus be addressed in the entire system. The delimiter of
    ///     levels is "/". The Discovery as root of the structure tree names "OP:"
    ///     (example: "OP:/sampleSystem/MainCell/SubCell")
    ///   </para>
    /// </summary>
    function siLongName:string; virtual;

    /// <summary>
    ///   The implementation checks the the registration of a controller of cell
    ///   instance and get so the status that the instance is part of a sub cell tree.
    /// </summary>
    function siIsControlled: Boolean; overload;
    /// <summary>
    ///   The implementation checks the the registration of a controller of cell
    ///   instance and get so the status that the instance is part of a sub cell tree.
    /// </summary>
    /// <param name="aCell">
    ///   if the result is true, the our parameter get back the cell instance of
    ///   controller as IsiCellObject
    /// </param>
    function siIsControlled(out aCell:IsiCellObject):Boolean; overload;
    /// <summary>
    ///   The implementation get the instance of controller cell as IsiCellObject
    /// </summary>
    function siGetController: IsiCellObject;
    /// <summary>
    ///   <para>
    ///     The implemenation set the controller cell as IsiCellObject
    ///   </para>
    /// </summary>
    /// <param name="aCell">
    ///   the controller cell instance as IsiCellObject reference
    /// </param>
    procedure siSetController(const aCell:IsiCellObject);
    /// <summary>
    ///   siController property read / write the controller cell instance as IsiCellObject
    /// </summary>
    property siController:IsiCellObject read siGetController write siSetController;
    {$ENDREGION}

    {$REGION 'IsiCellObject implementation - Sub cell list operations'}
    /// <summary>
    ///   The implementation get the the count of sub cell entries
    /// </summary>
    /// <remarks>
    ///   There is no guarantee that there isactually an object assigned to the
    ///   reference to a sub cell. Check this with siSubCellValid. <br />
    /// </remarks>
    function siSubCellCount: Integer; overload;
    /// <summary>
    ///  get the count of all sub cells that support a given interface.
    /// </summary>
    /// <remarks>
    ///  Array elements have the basic interface type and must be cast to aInterface
    ///  before the methods defined in it can be accessed.
    /// </remarks>
    function siSubCellCount(const aGUID : TGUID) : Integer; overload;

    /// <summary>
    ///  Checks whether aIdx is within the range of cells and whether an object is assigned to
    ///  the interface reference there.
    /// </summary>
    function siSubCellValid(const aIdx: Integer): Boolean;

    /// <summary>
    ///   Get the first founded kill interface of the this cell and sub cells.
    /// </summary>
    /// <param name="aSkillInterface">
    ///   GUID of skill interface as TGUID record
    /// </param>
    /// <returns>
    ///   the skill interface of first founded implementation as IsiCellObject
    /// </returns>
    function siSkillInterface(const aSkillInterface : TGUID; const aInterfacePtr : PsiCellObject) : Boolean;

    /// <summary>
    ///   Get an list of all cells, that supports the given skill interface.
    /// </summary>
    /// <param name="aInterface">
    ///   a skill interface derivated by IsiCellObject
    /// </param>
    /// <remarks>
    ///   Array elements have the basic interface type and must be cast to
    ///   aIntf before the methods defined in it can be accessed.
    /// </remarks>
    function siInterfacedSubCells(const aInterface: TGuid): TArray<IsiCellObject>;

    /// <summary>
    ///  get a list of sub cells they are controlled by this cell
    /// </summary>
    /// <remarks>
    ///  Array elements have the basic interface type and must be cast to aIntf before the methods
    ///  defined in it can be accessed.
    /// </remarks>
    function siControlledSubCells: TArray<IsiCellObject>;

    /// <summary>
    ///  Fetches the cell whose cell name matches aName.
    /// </summary>
    function siGetSubCell(const aName: string): IsiCellObject; overload;
    /// <summary>
    ///  Fetches the cell from sub cell list with the given index.
    /// </summary>
    /// <remarks>
    ///  Return type is the basic interface type. Result must be cast to the appropriate interface
    ///  type so that its methods can be accessed.
    /// </remarks>
    function siGetSubCell(const aIdx: Integer): IsiCellObject; overload;
    /// <summary>
    ///   The implementation save the interface reference in the cell list position of idx
    /// </summary>
    /// <param name="aIdx">
    ///   sub cell listing index
    /// </param>
    /// <param name="aReference">
    ///   interface reference
    /// </param>
    /// <remarks>
    ///   <para>
    ///     ACHTUNG! NOT FOR PUBLIC USE!
    ///   </para>
    ///   <para>
    ///     The list will be writen by siAddSubCell
    ///   </para>
    /// </remarks>
    procedure siSetSubCell(const aIdx: Integer; const aReference: IsiCellObject);
    /// <summary>
    ///   Read / write the cell reference on sub cell list on position aIdx
    /// </summary>
    property siSubCell[const aIdx : integer] : IsiCellObject read siGetSubCell write siSetSubCell;

    /// <summary>
    ///   The implementation exchange an existing cell with a cell to be changed
    /// </summary>
    /// <param name="aOldCell">
    ///   a existing cell as IsiCellObject reference
    /// </param>
    /// <param name="aNewCell">
    ///   a cell to be changed as IsiCellObject reference
    /// </param>
    function siSwapSubCell(const aOldCell: IsiCellObject; const aNewCell: IsiCellObject): Boolean;

    /// <summary>
    ///   <para>
    ///     Add the cell as IsiCellObject reference at the end of the sub
    ///     cell list.
    ///   </para>
    ///   <para>
    ///     The add option is the default as dynamic entry.
    ///   </para>
    /// </summary>
    /// <param name="aCell">
    ///   a cell as IsiCellObject reference or NIL
    /// </param>
    function siAddSubCell(const aCell: IsiCellObject): IsiCellObject;

    /// <summary>
    ///   Create a cell of cell class, set the name of new cell and add its in
    ///   sub cell list
    /// </summary>
    /// <param name="aCellClass">
    ///   The cell object class (TCellObject or derivate)
    /// </param>
    /// <param name="aName">
    ///   The name of new cell or empty string for auto naming
    /// </param>
    function siAddNewSubCell(const aCellClass: TCellClass; const aName: string): IsiCellObject; overload;
    /// <summary>
    ///   Build a cell from cell type register with type name, set the name of
    ///   new cell and add its in sub cell list on end of list.
    /// </summary>
    /// <param name="aTypeName">
    ///   cell type name
    /// </param>
    function siAddNewSubCell(const aTypeName: string; const aName: string): IsiCellObject; overload;
    /// <summary>
    ///   Build a new cell from cell type register with type GUID, set the name
    ///   of new cell and add it in sub cell list on end.
    /// </summary>
    /// <param name="aTypeGuid">
    ///   cell type GUID
    /// </param>
    function siAddNewSubCell(const aTypeGuid: TGUID; const aName: string): IsiCellObject; overload;

    /// <summary>
    ///   Add the cell as IsiCellObject reference at the given position of the
    ///   sub cell list. <br /><br />The add option is the default as dynamic
    ///   entry. <br />
    /// </summary>
    /// <param name="aCell">
    ///   cell as IsiCellObject reference
    /// </param>
    /// <param name="aPosition">
    ///   the position as index of list
    /// </param>
    function siInsertSubCell(const aCell: IsiCellObject; const aPosition: Integer): IsiCellObject;

    /// <summary>
    ///   Create a cell of cell class, set the name of new cell and insert its in
    ///   sub cell list on defined position.
    /// </summary>
    /// <param name="aCellClass">
    ///   The cell object class (TCellObject or derivate)
    /// </param>
    /// <param name="aName">
    ///   The name of new cell or empty string for auto naming
    /// </param>
    /// <param name="aPosition">
    ///   The position in sub cell list
    /// </param>
    function siInsertNewSubCell(const aCellClass: TCellClass; const aName: string; const aPosition: Integer): IsiCellObject; overload;
    /// <summary>
    ///   Build a cell from cell type register with type name, set the name of
    ///   new cell and insert in sub cell list on position.
    /// </summary>
    /// <param name="aTypeName">
    ///   cell type name
    /// </param>
    function siInsertNewSubCell(const aTypeName: string; const aName: string; const aPosition: Integer): IsiCellObject; overload;
    /// <summary>
    ///   Build a new cell from cell type register with type GUID, set the name
    ///   of new cell and insert it in sub cell list on position.
    /// </summary>
    /// <param name="aTypeGuid">
    ///   cell type GUID
    /// </param>
    function siInsertNewSubCell(const aTypeGuid: TGUID; const aName: string; const aPosition: Integer): IsiCellObject; overload;

    /// <summary>
    ///   Construct (add) the cell as IsiCellObject reference in the sub cell
    ///   list. <br /><br />The add option is constructed as fixed cell. <br />
    /// </summary>
    /// <param name="aCell">
    ///   cell as IsiCellObject reference
    /// </param>
    /// <remarks>
    ///   This function is used when sub cells are added to the list by during
    ///   construction (i.e. in the compiler). The entry is inserted into the
    ///   front (constructed) part of the list and an internal counter is
    ///   incremented. These constructed cells are fixed entries and are only
    ///   treated in terms of content but not existentially by list functions. <br />
    /// </remarks>
    function siConstructSubCell(const aCell: IsiCellObject): IsiCellObject;

    /// <summary>
    ///   build a new cell and add it in sub cell list as construced cell
    /// </summary>
    /// <param name="aCellClass">
    ///   The cell object class (TCellObject or derivate)
    /// </param>
    /// <param name="aName">
    ///   The name of new cell or empty string for auto naming
    /// </param>
    function siConstructNewSubCell(const aCellClass: TCellClass; const aName: string): IsiCellObject; overload;
    /// <summary>
    ///   Build a cell from cell type register with type name, set the name of
    ///   new cell and add its in sub cell list as constructed cell
    /// </summary>
    /// <param name="aTypeName">
    ///   cell type name
    /// </param>
    /// <param name="aName">
    ///   position in sub cell list
    /// </param>
    function siConstructNewSubCell(const aTypeName: string; const aName: string): IsiCellObject; overload;
    /// <summary>
    ///   Build a new cell from cell type register with type GUID, set the name
    ///   of new cell and add it in sub cell list as constructed cell.
    /// </summary>
    /// <param name="aTypeGuid">
    ///   cell type GUID
    /// </param>
    /// <param name="aName">
    ///   Position in sub cell list
    /// </param>
    function siConstructNewSubCell(const aTypeGuid: TGUID; const aName: string): IsiCellObject; overload;

    /// <summary>
    ///   This implemenation remove the entry on index from the cell list and get the new cell
    ///   list count.
    /// </summary>
    /// <param name="aIdx">
    ///   index in sub cell list
    /// </param>
    function siRemoveSubCell(const aIdx: Integer): Boolean; overload;
    /// <summary>
    ///   This implementation remove the entry with name from the sub cell list and get the new
    ///   cell list count.
    /// </summary>
    function siRemoveSubCell(const aName: string): Boolean; overload;
    /// <summary>
    ///   This implemenation remove the given cell with IsiCellObject reference from the list and
    ///   return the new cell list count.
    /// </summary>
    function siRemoveSubCell(const aCell: IsiCellObject): Boolean; overload;

    /// <summary>
    ///   This Implementation remove all entries from sub cell list.
    /// </summary>
    procedure siRemoveAllSubCells;

    /// <summary>
    ///  find a cell with long name in sub tree or common tree
    /// </summary>
    /// <remarks>
    ///  Return type is the IsiCellObject. Result must be cast to the appropriate interface
    ///  type so that its methods can be accessed.
    /// </remarks>
    function siFindCell(const aLongName: string): IsiCellObject; overload;
    /// <summary>
    ///   Try to find the cell by long name and write in pointer the reference
    ///   as IsiCellobjet
    /// </summary>
    function siFindCell(const aLongName: string;
      const aIntf : PsiCellObject) : Boolean; overload;
    /// <summary>
    ///   Try to find the cell by long name and try to get a reference of aGuid
    ///   interface in pointer PsiCellObject
    /// </summary>
    function siFindCell( const aLongName: string; const aInterfaceGuid : TGUID;
      const aIntf : PsiCellObject) : Boolean; overload;

    /// <summary>
    ///   Create a new cell instance of TCellClass with name from longname in
    ///   sub cell tree of longname and get out in Pointer of Interface the
    ///   reference of named interface by GUID. Add this new cell as dynamic
    ///   entry in the destination tree and get true result when all criteria
    ///   was successful.
    /// </summary>
    /// <param name="aCellClass">
    ///   The class of to created cell object instance
    /// </param>
    /// <param name="aLongName">
    ///   the long name of new cell with destination tree and cell name
    /// </param>
    /// <param name="aGUID">
    ///   The Guid of the classified interface
    /// </param>
    /// <param name="aIntf">
    ///   Pointer to variable of classified interface
    /// </param>
    /// <example>
    ///   Assert ( siAddNewCell( TcoInteger, 'SamplePath/MyInteger',
    ///   IsiInteger, @fsiMyInteger), 'Invalid addition of SamplePath/MyInteger
    ///   in TDemoCellObject');
    /// </example>
    function siAddNewCell( const aCellClass: TCellClass; const aLongName: string;
      const aInterfaceGUID : TGUID; const aIntf : PsiCellObject) : Boolean; overload;
    /// <summary>
    ///   Create a new cell instance of TCellClass with name from longname in
    ///   sub cell tree of longname and get out in Pointer of IsiCellObject.
    ///   Add this new cell as dynamic entry in the destination tree and get
    ///   true result when all criteria was successful.
    /// </summary>
    /// <param name="aCellClass">
    ///   The class of to created cell object instance
    /// </param>
    /// <param name="aLongName">
    ///   the long name of new cell with destination tree and cell name
    /// </param>
    /// <param name="aIntf">
    ///   Pointer to variable of classified interface
    /// </param>
    /// <param name="aInterfaceGUID">
    ///   Skill interface GUID
    /// </param>
    /// <param name="aGUID">
    ///   The Guid of the classified interface
    /// </param>
    /// <example>
    ///   Assert ( siAddNewCell( TcoInteger, 'SamplePath/MyInteger',
    ///   IsiInteger, @fsiMyInteger), 'Invalid addition of SamplePath/MyInteger
    ///   in TDemoCellObject');
    /// </example>
    function siAddNewCell( const aCellClass: TCellClass; const aLongName: string;
      const aIntf : PsiCellObject) : Boolean; overload;

    /// <summary>
    ///   Create a new cell instance of TCellClass with name from longname in
    ///   sub cell tree of longname and get out in Pointer of Interface the
    ///   reference of named interface by GUID. Construct (Add) this new cell as
    ///   fixed construstion entry in the destination tree and get true result
    ///   when all criteria was successful.
    /// </summary>
    /// <param name="aCellClass">
    ///   The class of to created cell object instance
    /// </param>
    /// <param name="aLongName">
    ///   the long name of new cell with destination tree and cell name
    /// </param>
    /// <param name="aGUID">
    ///   The Guid of the classified interface
    /// </param>
    /// <param name="aIntf">
    ///   Pointer to variable of classified interface
    /// </param>
    /// <example>
    ///   Assert ( siAddNewCell( TcoInteger, 'SamplePath/MyInteger',
    ///   IsiInteger, @fsiMyInteger), 'Invalid addition of SamplePath/MyInteger
    ///   in TDemoCellObject');
    /// </example>
    function siConstructNewCell( const aCellClass: TCellClass; const aLongName: string;
      const aInterfaceGUID : TGUID; const aIntf : PsiCellObject) : Boolean; overload;
    /// <summary>
    ///   Create a new cell instance of TCellClass with name from longname in
    ///   sub cell tree of longname and get out in Pointer of IsiCellObject
    ///   Construct (Add) this new cell as fixed construstion entry in the
    ///   destination tree and get true result when all criteria was successful.
    /// </summary>
    /// <param name="aCellClass">
    ///   The class of to created cell object instance
    /// </param>
    /// <param name="aLongName">
    ///   the long name of new cell with destination tree and cell name
    /// </param>
    /// <param name="aGUID">
    ///   The Guid of the classified interface
    /// </param>
    /// <param name="aIntf">
    ///   Pointer to variable of classified interface
    /// </param>
    /// <example>
    ///   Assert ( siAddNewCell( TcoInteger, 'SamplePath/MyInteger',
    ///   IsiInteger, @fsiMyInteger), 'Invalid addition of SamplePath/MyInteger
    ///   in TDemoCellObject');
    /// </example>
    function siConstructNewCell( const aCellClass: TCellClass; const aLongName: string;
      const aIntf : PsiCellObject) : Boolean; overload;

    /// <summary>
    ///   Delete the named cell from his controller sub cell list and get
    ///   success as result.
    /// </summary>
    function siDeleteCell( const aLongName : string) : boolean; overload;
    /// <summary>
    ///   Delete cell from his controller sub cell list and get success as
    ///   result.
    /// </summary>
    function siDeleteCell( const aCell : IsiCellObject) : boolean; overload;
    /// <summary>
    ///   Delete this cell from his controller sub cell list and get success as
    ///   result.
    /// </summary>
    function siDeleteCell : boolean; overload;
    {$ENDREGION}

    {$REGION 'IsiCellObject implementation - Cell OnRead/OnWrite/siCall procedure'}
    /// <summary>
    ///   Get the cell call procedure of siGetValue or siCall
    /// </summary>
    function siGetOnRead : TOnCellProcedure;
    /// <summary>
    ///   Set the cell call procedure of siGetValue or siCall
    /// </summary>
    procedure siSetOnRead(const aOnCellProcedure : TOnCellProcedure);
    /// <summary>
    ///   Read / write the cell call procedure of siGetValue or siCall
    /// </summary>
    property siOnRead : TOnCellProcedure read siGetOnRead write siSetOnRead;

    /// <summary>
    ///   Get the cell call procedure of siSetValue
    /// </summary>
    function siGetOnWrite : TOnCellProcedure;
    /// <summary>
    ///   Set the cell call procedure of siSetValue
    /// </summary>
    procedure siSetOnWrite(const aOnCellProcedure : TOnCellProcedure);
    /// <summary>
    ///   Read / write the cell call procedure of siSetValue
    /// </summary>
    property siOnWrite : TOnCellProcedure read siGetOnWrite write siSetOnWrite;

    /// <summary>
    ///   call the cell call procedure
    /// </summary>
    procedure siCall;
    {$ENDREGION}

    {$REGION 'IsiCellObject implementation - Value content operations'}
    /// <summary>
    ///   Get the the value as RTTI TValue.
    /// </summary>
    function siGetValue : TValue; overload; virtual;
    /// <summary>
    ///   Get the value of the long namend cell as RTTI TValue.
    /// </summary>
    /// <param name="aLongName">
    ///   Describe the long name of cell started from the cell object reference
    ///   (relative) or from root or with relative structure orientation ("../").
    /// </param>
    /// <remarks>
    ///   The long name describe the cell in the sub cell structure.
    ///   Empty String '' is self.
    /// </remarks>
    function siGetValue(const aLongName: string) : TValue; overload;
    /// <summary>
    ///   Set the value of cell as RTTI TValue.
    /// </summary>
    /// <param name="aValue">
    ///   cell value as RTTI TValue
    /// </param>
    procedure siSetValue(const aValue: TValue); overload; virtual;
    /// <summary>
    ///   Set the value of the long namend cell as RTTI TValue.
    /// </summary>
    /// <param name="aLongName">
    ///   Describe the long name of cell started from the cell (self).
    /// </param>
    /// <param name="aValue">
    ///   The cell value as RTTI TValue
    /// </param>
    procedure siSetValue(const aLongName: string; const aValue: TValue); overload;
    /// <summary>
    ///   Read and write the value content of self as RTTI TValue
    /// </summary>
    property siValue:TValue read siGetValue write siSetValue;

    /// <summary>
    ///   Try to get the Value of a long named cell. Get the result, whose
    ///   the named cell is valid and get the value as RTTI TValue in aResult.
    /// </summary>
    /// <param name="aLongName">
    ///   Descripe the sub cell as long name
    /// </param>
    /// <param name="aResult">
    ///   Result as out parameter with the Value as TValue
    /// </param>
    /// <remarks>
    ///   The long name describe the cell in the sub cell structure.
    ///   Empty String '' is self.
    /// </remarks>
    function siTryGetValue(const aLongName: string; out aResult: TValue) : Boolean;
    /// <summary>
    ///   Try to set the value of a long named sub cell. Check that when the
    ///   named cell is valid and value is setted.
    /// </summary>
    /// <param name="aLongName">
    ///   Descripe the sub cell as longname string
    /// </param>
    /// <param name="aValue">
    ///   cell value as RTTI TValue
    /// </param>
    function siTrySetValue(const aLongName: string; const aValue: TValue) : Boolean;

    /// <summary>
    ///   <para>
    ///     get the cell value or content as string, can be a data value or the
    ///     specific content of a cell as string
    ///   </para>
    ///   <para>
    ///     TCellObject return the RTTI Value as string as default
    ///   </para>
    /// </summary>
    function siGetAsString : string; virtual;
    /// <summary>
    ///   Set the cell value or content from string.
    /// </summary>
    /// <param name="aValue">
    ///   value
    /// </param>
    procedure siSetAsString(const aValue: String); virtual;
    /// <summary>
    ///   Read / write the value or content of cell as string.
    /// </summary>
    property siAsString : string read siGetAsString write siSetAsString;

    /// <summary>
    ///   Get the value of cell object as JSON Value. The virtual function of
    ///   base cell object get the value in JSON. Override in deviated cells.
    /// </summary>
    function siGetAsJSON : TJSONValue; virtual;
    /// <summary>
    ///   Set the value of cell object as JSON Value. The virtual function is only
    ///   predefined and must be overrided in derivated cell with detail content.
    /// </summary>
    procedure siSetAsJSON(aJSONValue : TJSONValue); virtual;
    /// <summary>
    ///   Read and write the value of cell object as JSON value.
    /// </summary>
    property siAsJSON : TJSONValue read siGetAsJSON write siSetAsJSON;

    /// <summary>
    ///   Get the cell value and sub cell structure as JSON Object as MainRequest
    /// </summary>
    function siGetCellContentAsJSONObject: TJSONObject; overload;
    /// <summary>
    ///   Get the cell value and sub cell structure as JSON Object
    /// </summary>
    /// <param name="aMainRequest">
    ///   set the request as Main request, otherwise as sub cell request
    /// </param>
    /// <remarks>
    ///   They differentiate between main requests or sub cell requests. The
    ///   master data (name and type) are always supplied. For main request,
    ///   the values and structures are always supplied. In the case of sub
    ///   cell request, the values and structures are only supplied if the
    ///   NoContentAtSubCellRequest attribute has not been set.
    /// </remarks>
    function siGetCellContentAsJSONObject(const aMainRequest: Boolean): TJSONObject; overload; virtual;
    /// <summary>
    ///   Set the cell value and sub cell structure from JSON Object as MainRequest
    /// </summary>
    /// <param name="aJSONObject">
    ///   the source for content as JSON Object
    /// </param>
    procedure siSetCellContentFromJSONObject(const aJSONObject: TJSONObject); overload;
    /// <summary>
    ///   Set the cell value and sub cell structure from JSON Object
    /// </summary>
    /// <param name="aJSONObject">
    ///   the source for content as JSON Object
    /// </param>
    /// <param name="aMainRequest">
    ///   set the request as Main request, otherwise as sub cell request
    /// </param>
    /// <remarks>
    ///   They differentiate between main requests or sub cell requests. The
    ///   master data (name and type) are always supplied. For main request,
    ///   the values and structures are always supplied. In the case of sub
    ///   cell request, the values and structures are only supplied if the
    ///   NoContentAtSubCellRequest attribute has not been set.
    /// </remarks>
    procedure siSetCellContentFromJSONObject(const aJSONObject: TJSONObject; const aMainRequest: Boolean); overload; virtual;
    {$ENDREGION}

    {$REGION 'IsiCellObject implementation - Save and restore operations'}
    /// <summary>
    ///   The Implementation call only the save method of each sub cells.
    /// </summary>
    /// <remarks>
    ///   overwrite for own storage management.
    /// </remarks>
    procedure siSave; virtual;
    /// <summary>
    ///   The implementation call only the restore method of each sub cells.
    /// </summary>
    /// <remarks>
    ///   overwrite for own storage management.
    /// </remarks>
    procedure siRestore; virtual;
    {$ENDREGION}
  strict protected
    {$REGION 'TsiCellObject protected internal class vars'}
    /// <summary>
    ///   contain the µCell system root cell (as Discovery Manager and
    ///   friends)
    /// </summary>
    class var fRootCell   : IsiCellObject;
    {$ENDREGION}
  end;
  {$ENDREGION}

  {$REGION 'General derivatives as general cell objects'}
  [RegisterCellType('skill cell','{FCC5A68D-20B4-4C40-B00E-806628FDEAB7}')]
  TSkillInterfaceCell = class(TCellObject)
  public
    procedure CellConstruction; override;
  end;
  {$ENDREGION}

implementation

{$REGION 'uses for implementation'}
uses
  OurPlant.Common.DiscoveryManager,
  OurPlant.Common.LinkPlaceHolder,
  OurPlant.Common.TypesAndConst,
  OurPlant.Common.CellTypeRegister,
  System.TypInfo,
  System.IOUtils,
  REST.Json;
{$ENDREGION}

{$REGION 'private constance '}
const
  C_DEFAULT_SUBCELL_CONTENT = True; // Status: Inhalt zurückgegen, wenn Abfragen als Sub Cell
{$ENDREGION}

{$REGION 'class operations'}

class function TCellObject.IsValid( const aCell : IsiCellObject) : boolean;
begin
  Result := Assigned(aCell) and aCell.siIsValid;
end;

class function TCellObject.IsValidAs<T>( const aCell : IsiCellObject) : Boolean;
var
  vTypeInfo : PTypeInfo;
  vIntf     : T;
begin
  vTypeInfo := TypeInfo( T );
  Result := IsValid( aCell ) and (aCell.QueryInterface( vTypeInfo.TypeData.Guid, vIntf) = 0);
end;

class function TCellObject.IsValidAs<T>( const aCell : IsiCellObject; out aResult : T) : Boolean;
var
  vTypeInfo : PTypeInfo;
begin
  vTypeInfo := TypeInfo( T );
  Result := IsValid( aCell ) and (aCell.QueryInterface( vTypeInfo.TypeData.Guid, aResult) = 0);
end;

class function TCellObject.CellSkill<T>( const aCell : IsiCellObject) : T;
var
  vTypeInfo : PTypeInfo;
begin
  vTypeInfo := TypeInfo( T );
  if IsValid( aCell) then
  begin
    if not aCell.siSkillInterface( vTypeInfo.TypeData.Guid, @Result) then
      raise Exception.CreateFmt( 'No supported skill interface %s in cell %s', [vTypeInfo.Name, aCell.siName] );
  end
  else
    raise Exception.CreateFmt( 'No valid cell at skill request of %s', [vTypeInfo.Name]);
end;

class function TCellObject.TryCellSkill<T>( const aCell : IsiCellObject) : Boolean;
var
  vTypeInfo : PTypeInfo;
  vIntf     : T;
begin
  vTypeInfo := TypeInfo( T );

  Result := IsValid( aCell) and aCell.siSkillInterface( vTypeInfo.TypeData.Guid, @vIntf) and Assigned(vIntf);
end;

class function TCellObject.TryCellSkill<T>( const aCell : IsiCellObject; out aResult : T) : Boolean;
var
  vTypeInfo : PTypeInfo;
begin
  vTypeInfo := TypeInfo( T );

  Result := IsValid( aCell) and aCell.siSkillInterface( vTypeInfo.TypeData.Guid, @aResult) and Assigned(aResult);
end;

class function TCellObject.Root : IsiCellObject;
begin
  if not Assigned( fRootCell) then
    SetRootCell( TcoDiscoveryManager.Create( C_ROOT_NAME ));

  Result := fRootCell;
end;

class procedure TCellObject.SetRootCell( const aCell : IsiCellObject);
begin
  if Supports( aCell, IsiDiscoveryManager ) then
    fRootCell := aCell
  else
    Assert(false, 'No valid root cell for OurPlant µCell system or not supported IsiDiscoveryManager');
end;

class function TCellObject.RootSkill<T> : T;
var
  vTypeInfo : PTypeInfo;
begin
  Result := CellSkill<T>(Root);

  if not Assigned(result) then
  begin
    vTypeInfo := TypeInfo( T );
    raise Exception.CreateFmt('Not supported skill interface %s in discovery manager or invalid root cell',
     [vTypeInfo.Name]);
  end;
end;

class function TCellObject.TryRootSkill<T>( out aResult : T ) : Boolean;
begin
  Result := TryCellSkill<T>(Root, aResult);
end;

class function TCellObject.TryRootSkill<T> : Boolean;
begin
  Result := TryCellSkill<T>(Root);
end;


{$ENDREGION}

{$REGION 'TCellObject protected implementation'}

function TCellObject.FindAttribute<T>( const aRTTIType : TRttiType; out aResult : T) : Boolean;
var
  vAttrList :    TArray<TCustomAttribute>;
  vAttrCounter : Integer;
begin
  Result := False;

  if not Assigned(aRTTIType) then
    Exit(False);

  vAttrList := aRTTIType.GetAttributes;

  if Length(vAttrList) = 0 then
    Exit(False);

  for vAttrCounter := 0 to High(vAttrList) do
    if vAttrList[vAttrCounter] is T then
    begin
      aResult := vAttrList[vAttrCounter] as T;
      Exit (True);
    end;
end;

procedure TCellObject.ClearRunTimeSubCells;
var
  vIdx: Integer;
  vController : IsiCellObject;
begin
  if Length(fSubCells)>fConstructedCellCount then
  begin
    for vIdx := fConstructedCellCount to High(fSubCells) do
    begin
      if fSubCells[vIdx].siIsControlled(vController) and siIsSame(vController) then
        fSubCells[vIdx].siController:=nil;

      fSubCells[vIdx]:=nil;
    end;
    SetLength(fSubCells,fConstructedCellCount);
  end;
end;

{$ENDREGION}

{$REGION 'TCellObject Operations implementation'}
{constructor TCellObject.create(const aCellName:string);
begin
  inherited siName := aCellName;
end;}

procedure TCellObject.AfterConstruction;
var
  vAttribute: RegisterCellTypeAttribute;
begin

  // suche nach der Registrierung
  if FindAttribute<RegisterCellTypeAttribute>(
   RootSkill<IsiRTTI>.siRTTI.GetType(ClassType),vAttribute) then
   begin
     fCellTypeName := vAttribute.TypeName;
     fCellTypeGuid := vAttribute.TypeGuid;
   end
   else
   begin
     fCellTypeName := '';
     fCellTypeGuid := TGUID.Empty;
   end;

  // run the cell construction routine
  CellConstruction;

  {inherited (TInterfaced.AfterConstruction) dekrementiert den RefCOunt nach der Konstruktion,
  kann zur Aufgabe der Instance führen und darf daher erst am Ende ausgeführt werden,
  danach dürfen keine Áufrufe von Supports und Co mehr folgen}
  inherited;

  // set the status of cell to IsAfterConstruction
  fIsAfterConstruction := True;
end;

procedure TCellObject.CellConstruction;
begin
  // set internal saving state to default
  fSubCellContent := C_DEFAULT_SUBCELL_CONTENT;

end;

procedure TCellObject.BeforeDestruction;
var
  vCount : Integer;
begin
  // clear the controller link - Achtung fController ist ein Pointer (kein Interface), wird durch vorher nicht bedient
  fController:=nil;

  // clear the sub cell list & entries
  if Length(fSubCells)>0 then
  begin
    for vCount := 0 to High(fSubCells) do   // gebe alle Zuweisungen auf die sub cell interface ref. auf
      fSubCells[vCount] := nil;
    SetLength(fSubCells, 0); // setze die Sub cell Liste zurück
  end;

  inherited;
end;
{$ENDREGION}

{$REGION 'class methods of TCellObject'}
class procedure TCellObject.RegisterExplicit;
begin
  // wird nur für rein dynamische Zellobject benötigt, die vom Compiler sonst wegoptimiert werden
  // Aufruf für abgeleitete Classen im initialization Teil reicht aus
end;

function TCellObject.TryConstructCellAs<T>( const aExistingCell: IsiCellObject; const aDestinationName: string; out aResultCell : T ): Boolean;
var
  vTypeInfo        : PTypeInfo;
  vGuid            : TGUID;
  vDestinationCell : IsiCellObject;
begin
  vTypeInfo := TypeInfo(T);
  // check the generic type is a interface
  if vTypeInfo.Kind = tkInterface then
  begin
    // get the guid of interface
    vGuid := vTypeInfo.TypeData.Guid;

    // check the validation of cell as typed interface
    if Supports(aExistingCell, vGuid, aResultCell) then
    begin
      // get the destination tree position cell
      vDestinationCell := siFindCell(aDestinationName);

      // add the existing cell as constructed cell
      Result := Assigned(vDestinationCell) and
        Assigned(vDestinationCell.siConstructSubCell(aExistingCell));
    end
    else
      Result := False; // no valid cell
  end
  else
    Result := False; // no interface type
end;

function TCellObject.ConstructCellAs<T>( const aExistingCell: IsiCellObject; const aDestinationName: string = '' ): T;
begin
  if not TryConstructCellAs<T>( aExistingCell, aDestinationName, Result ) then
    raise Exception.CreateFmt('Invalid construction of %s in %s',
      [aDestinationName, ClassName]);
end;

function TCellObject.ConstructCellAs<T>( const aExistingName: string; const aDestinationName: string = '' ): T;
begin
  Result := ConstructCellAs<T>( siFindCell(aExistingName), aDestinationName );
end;

function TCellObject.ConstructCell( const aExistingCell: IsiCellObject; const aDestinationName: string = '' ): IsiCellObject;
begin
  Result := ConstructCellAs<IsiCellObject>( aExistingCell, aDestinationName);
end;

function TCellObject.ConstructCell( const aExistingName: string; const aDestinationName: string = '' ): IsiCellObject;
begin
  Result := ConstructCellAs<IsiCellObject>( aExistingName, aDestinationName);
end;

function TCellObject.TryConstructNewCellAs<T>( const aCellClass: TCellClass; const aLongName: string; out aResultCell : T ): Boolean;
var
  vNewCellName : string;
  vDestinationName : string;
begin
  // separate name of new sub cell and rest of long name as main cell
  vNewCellName := LongNameSeparateRight(aLongName,vDestinationName);

  // create a named cell and construct this in destination cell
  Result := Assigned(aCellClass) and
    TryConstructCellAs<T>( aCellClass.create(vNewCellName), vDestinationName, aResultCell);
end;

function TCellObject.ConstructNewCellAs<T>( const aCellClass: TCellClass; const aLongName: string = ''): T;
begin
  if not TryConstructNewCellAs<T>( aCellClass, aLongName, Result ) then
    raise Exception.CreateFmt('Invalid construction of %s in %s',
      [aLongName,ClassName]);
end;

function TCellObject.ConstructNewCell( const aCellClass: TCellClass; const aLongName: string = ''): IsiCellObject;
begin
  Result := ConstructNewCellAs<IsiCellObject>(aCellClass, aLongName);
end;

function TCellObject.ConstructNewCell( const aLongName: string = ''): IsiCellObject;
begin
  Result := ConstructNewCellAs<IsiCellObject>(TCellObject, aLongName);
end;

{function TCellObject.ConstructNewCell<T>( const aTypeName: string; const aLongName: string = '' ): T;
begin

end;}

{$ENDREGION}

{$REGION 'Common operations of IsiCellObject'}
function TCellObject.siSelf : IsiCellObject;
begin
  GetInterface(IsiCellObject,Result);
end;

function TCellObject.siIsSame(aCell:IsiCellObject): Boolean;
begin
  Result:= aCell.siSelf = siSelf;
end;

function TCellObject.siIsValid : Boolean;
var
  vController : IsiCellObject;
begin
  if fIsAfterConstruction then
    if siIsControlled(vController) then
      Result := vController.siIsValid
    else
      Result := False
  else
    Result := true;
end;

function TCellObject.siTypeName:string;
begin
  Result := fCellTypeName;
end;

function TCellObject.siTypeGuid:TGUID;
begin
  Result := fCellTypeGuid;
end;

function TCellObject.siClass : TCellClass;
begin
  Result := TCellClass(ClassType);
end;

procedure TCellObject.siSetName(const aName:string);
var
  vName   : string;
  vIndex  : Integer;
begin
  if (aName = siGetName) and (siGetName <> '') then
    Exit;

  if siIsControlled then // wenn controlled, check unique Name setting
  begin
    if aName<>'' then
      vName:= aName
    else
      vName:= siTypeName;

    vIndex := 1;
    vName  := aName;
    while true do
    begin
      if (siController.siGetSubCell(vName)=nil) then
        Break
      else
      begin
        inc(vIndex);
        vName:= aName + ' ' + IntToStr(vIndex);
      end;
    end;

    inherited siSetName(vName);   // set a unique name
  end
  else
    inherited siSetName(aName);   // no control -> no restrictions for aName
end;

function TCellObject.siDisplayName: string;
var
  vControl: IsiCellObject;
begin
  if siIsControlled(vControl) then
    Result:= vControl.siName + ' / ' + siName
  else
    Result:= siName+' (unclaimed)';
end;

function TCellObject.siLongName:string;
var
  vControl: IsiCellObject;
begin
  if siIsControlled(vControl) and (vControl.siLongName<>'') then
    Result:= vControl.siLongName + C_LONGNAME_DELIMITER + siName
  else
    Result:= siName;
end;


function TCellObject.siIsControlled: Boolean;
begin
  Result:=Supports(IsiCellObject(fController),IsiCellObject);
end;

function TCellObject.siIsControlled(out aCell:IsiCellObject):Boolean;
begin
  Result:=Supports(IsiCellObject(fController),IsiCellObject,aCell);
end;

function TCellObject.siGetController: IsiCellObject;
begin
  Supports(IsiCellObject(fController),IsiCellObject,Result);
end;

procedure TCellObject.siSetController(const aCell:IsiCellObject);
var
  vName  : string;
  vIndex  : Integer;
begin
  if (aCell<>nil) and (fController<>Pointer(aCell)) then    // check unique cell name for new controlles cell structure
  begin
    fController:=nil;

    if siName='' then
      siName:= siTypeName;  // when empty name then set Name to type name

    vIndex := 1;
    vName := siName;
    while true do
    begin
      if aCell.siGetSubCell(vName)=nil then
        Break
      else
      begin
        inc(vIndex);
        vName:= siName + ' ' + IntToStr(vIndex);
      end;
    end;

    siName:= vName; // set a unique name

  end;

  fController:=Pointer(aCell);
end;

{$ENDREGION}

{$REGION 'Cell/Interface list operations of IsiCellObject'}
function TCellObject.siSubCellCount: Integer;
begin
  Result := Length(fSubCells);
end;

function TCellObject.siSubCellCount(const aGUID : TGUID) : Integer;
var
  I: Integer;
begin
  Result:=0;

  // check the list of sub cells
  for I := 0 to High(fSubCells) do
  begin
    if Supports(fSubCells[I], aGUID) then
      Inc(Result);
  end;
end;

function TCellObject.siSubCellValid(const aIdx: Integer): Boolean;
begin
  Result := Assigned(fSubCells) and (aIdx >= 0) and (aIdx < siSubCellCount) and
    Assigned(fSubCells[aIdx]);
end;

function TCellObject.siSkillInterface(const aSkillInterface : TGUID; const aInterfacePtr : PsiCellObject) : Boolean;
var
  I : Integer;
begin
  Result := Supports( Self, aSkillInterface, aInterfacePtr^ );

  if not Result then
    for I := 0 to High( fSubCells ) do
      if Supports( fSubCells[I], aSkillInterface, aInterfacePtr^ ) then
        Exit (True);
end;

function TCellObject.siInterfacedSubCells(const aInterface: TGuid): TArray<IsiCellObject>;
var
  I, J: Integer;
begin
  // Initialize to maximum possible length, i.e. all elements support the requested interface.
  SetLength(Result, Length(fSubCells)+1);

  J := 0; // Result count reset

  // check the list of sub cells
  for I := 0 to High(fSubCells) do
    if Supports(fSubCells[I], aInterface, Result[J]) then
      Inc(J);

  // Trim to final size. Note that J is always 1 higher than index of last added element.
  SetLength(Result, J);
end;

function TCellObject.siControlledSubCells: TArray<IsiCellObject>;
var
  I, J: Integer;
  vController:IsiCellObject;
begin
  // Initialize to maximum possible length, i.e. all elements support the requested interface.
  SetLength(Result, Length(fSubCells));

  J := 0; // Result count reset

  for I := 0 to High(fSubCells) do // check the list of sub cells
  begin
    if Assigned(fSubCells[I]) and fSubCells[I].siIsControlled(vController) and
      siIsSame(vController) then
    begin
      Result[J] := fSubCells[I];
      Inc(J);
    end;
  end;

  // Trim to final size. Note that J is always 1 higher than index of last added element.
  SetLength(Result, J);
end;

function TCellObject.siFindCell(const aLongName: string): IsiCellObject;
var
  vLeftSeparatedName : string;
  vRestOfName : string;
begin
  Result := nil;

  if aLongName='' then
    Result:=siSelf
  else
  begin
    vLeftSeparatedName:= LongNameSeparateLeft( aLongName, vRestOfName);

    if vLeftSeparatedName<>'' then
    begin
      if CompareNames( vLeftSeparatedName, C_LONGNAME_ROOT) then
        // 'OP:/CellName/...' -> search cell from root
        Result:= root
      else if CompareNames( vLeftSeparatedName, C_LONGNAME_ONE_LEVEL_UP) then
        // '../CellName/... -> search cell from one level deeper
        Result:= siController
      else
        // 'CellName/...' -> search cell in sub cell list of this cell
        Result := siGetSubCell(vLeftSeparatedName);
    end
    // '/CellName1/...' -> search cell from root (Discovery Manager)
    else
      Result := root;

    if (Result<>nil) and (vRestOfName<>'') then
      Result:= Result.siFindCell(vRestOfName);
  end;
end;

function TCellObject.siFindCell(const aLongName: string; const aIntf : PsiCellObject) : Boolean;
begin
  Result := Assigned(aIntf) and Supports( siFindCell(aLongName), IsiCellObject, aIntf^);
end;

function TCellObject.siFindCell( const aLongName: string; const aInterfaceGuid : TGUID;
                                    const aIntf : PsiCellObject) : Boolean;
begin
  Result := Assigned(aIntf) and Supports(siFindCell(aLongName), aInterfaceGuid, aIntf^);
end;

function TCellObject.siGetSubCell(const aName: string): IsiCellObject;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to High(fSubCells) do
    if siSubCellValid(I) and CompareNames( fSubCells[I].siName, aName) then
      Exit(fSubCells[I])
end;

function TCellObject.siGetSubCell(const aIdx: Integer): IsiCellObject;
begin
  if siSubCellValid(aIdx) then
    Result := fSubCells[aIdx]
  else
    Result := nil;
end;

procedure TCellObject.siSetSubCell(const aIdx: Integer; const aReference: IsiCellObject);
begin
  Assert(siSubCellValid(aIdx), Format('Tried to modify nonexistent sub-cell no. %d!', [aIdx]));
  fSubCells[aIdx] := aReference;
end;

function TCellObject.siSwapSubCell(const aOldCell: IsiCellObject; const aNewCell: IsiCellObject): Boolean;
var
  vCount:     integer;
begin
  Result:= False;

  if Assigned(aOldCell) and Assigned(aNewCell) then
    for vCount:= 0 to High(fSubCells) do
      if aOldCell.siIsSame(fSubCells[vCount]) then
      begin
        fSubCells[vCount] := aNewCell;
        if not aNewCell.siIsControlled then
          aNewCell.siController:=siSelf;       // when aCell have no controller

        Result:= True;
        Break;
      end;
end;

function TCellObject.siAddSubCell(const aCell: IsiCellObject): IsiCellObject;
begin
  if Assigned(aCell) then
  begin
    if not aCell.siIsControlled then
      aCell.siController:=siSelf;       // when aCell have no controller

    SetLength(fSubCells, Length(fSubCells) + 1);
    fSubCells[High(fSubCells)] := aCell;
  end;
  Result := aCell;
end;

function TCellObject.siInsertSubCell(const aCell: IsiCellObject; const aPosition: Integer): IsiCellObject;
var
  I: Integer;
begin
  Assert(aPosition>=fConstructedCellCount,
   'Add sub cells on position under 0 or in constructed section! '+siName);

  Assert(aPosition<=Length(fSubCells),'Add sub cells out of range! '+siName);

  if Assigned(aCell) then
  begin
    if not aCell.siIsControlled then
      aCell.siController:=siSelf;                 // when aCell have no controller

    SetLength(fSubCells, Length(fSubCells) + 1);  // add a new entry pos

    if aPosition < High(fSubCells) then
      for I := High(fSubCells) downto aPosition+1 do
        fSubCells[I] := fSubCells[I-1];

    fSubCells[aPosition]:=aCell;
  end;

  Result := aCell;
end;

function TCellObject.siAddNewSubCell(const aCellClass: TCellClass; const aName: string): IsiCellObject;
begin
  if Assigned(aCellClass) and aCellClass.Create(aName).GetInterface(IsiCellObject, Result) then
    siAddSubCell(Result)
  else
    Result := nil;
end;

function TCellObject.siAddNewSubCell(const aTypeName: string; const aName: string): IsiCellObject;
begin
  Result := siAddSubCell( RootSkill<IsiCellTypeRegister>.siBuildNewCell( aTypeName, aName));
end;

function TCellObject.siAddNewSubCell(const aTypeGuid: TGUID; const aName: string): IsiCellObject;
begin
  Result := siAddSubCell( RootSkill<IsiCellTypeRegister>.siBuildNewCell(aTypeGuid,aName));
end;

function TCellObject.siInsertNewSubCell(const aCellClass: TCellClass; const aName: string; const aPosition: Integer): IsiCellObject;
begin
  if Assigned(aCellClass) and aCellClass.Create(aName).GetInterface(IsiCellObject, Result) then
    siInsertSubCell(Result,aPosition)
  else
    Result:= nil;
end;

function TCellObject.siInsertNewSubCell(const aTypeName: string; const aName: string; const aPosition: Integer): IsiCellObject;
begin
  Result:= siInsertSubCell(
   RootSkill<IsiCellTypeRegister>.siBuildNewCell( aTypeName, aName), aPosition);
end;

function TCellObject.siInsertNewSubCell(const aTypeGuid: TGUID; const aName: string; const aPosition: Integer): IsiCellObject;
begin
  Result:= siInsertSubCell(
   RootSkill<IsiCellTypeRegister>.siBuildNewCell( aTypeGuid, aName), aPosition);
end;

function TCellObject.siConstructSubCell(const aCell: IsiCellObject): IsiCellObject;
begin
  Result:=siInsertSubCell(aCell,fConstructedCellCount);
  Inc(fConstructedCellCount);
end;

function TCellObject.siConstructNewSubCell(const aCellClass: TCellClass; const aName: string): IsiCellObject;
begin
  Result:=siInsertNewSubCell(aCellClass,aName,fConstructedCellCount);
  Inc(fConstructedCellCount);
end;

function TCellObject.siConstructNewSubCell(const aTypeName: string; const aName: string): IsiCellObject;
begin
  Result:=siInsertNewSubCell(aTypeName,aName,fConstructedCellCount);
  Inc(fConstructedCellCount);
end;

function TCellObject.siConstructNewSubCell(const aTypeGuid: TGUID; const aName: string): IsiCellObject;
begin
  Result:=siInsertNewSubCell(aTypeGuid,aName,fConstructedCellCount);
  Inc(fConstructedCellCount);
end;

function TCellObject.siAddNewCell( const aCellClass: TCellClass;
  const aLongName: string; const aInterfaceGUID : TGUID; const aIntf : PsiCellObject) : Boolean;
var
  vMainCell : IsiCellObject;
  vNewCellName : string;
  vDestinationName : string;
begin
  if Assigned(aCellClass) and
   aCellClass.create.GetInterface( aInterfaceGUID, aIntf^) then
  begin
    // separate name of new sub cell and rest of long name as main cell
    vNewCellName := LongNameSeparateRight(aLongName,vDestinationName);

    aIntf^.siName := vNewCellName;

    // search and set the main cell
    if vDestinationName = '' then
      vMainCell := siSelf
    else
      vMainCell := siFindCell(vDestinationName);

    Result := Assigned(vMainCell) and Assigned(vMainCell.siAddSubCell(aIntf^));
  end
  else
    Result := False;
end;

function TCellObject.siAddNewCell( const aCellClass: TCellClass;
  const aLongName: string; const aIntf : PsiCellObject) : Boolean;
begin
  Result := siAddNewCell( aCellClass, aLongName, IsiCellObject, aIntf);
end;

function TCellObject.siConstructNewCell( const aCellClass: TCellClass;
  const aLongName: string; const aInterfaceGUID : TGUID; const aIntf : PsiCellObject) : Boolean;
var
  vMainCell : IsiCellObject;
  vNewCellName : string;
  vDestinationName : string;
begin
  if Assigned(aCellClass) and
   aCellClass.create.GetInterface( aInterfaceGUID, aIntf^) then
  begin
    // separate name of new sub cell and rest of long name as main cell
    vNewCellName := LongNameSeparateRight(aLongName,vDestinationName);

    aIntf^.siName := vNewCellName;

    // search and set the main cell
    if vDestinationName = '' then
      vMainCell := siSelf
    else
      vMainCell := siFindCell(vDestinationName);

    Result := Assigned(vMainCell) and Assigned(vMainCell.siConstructSubCell(aIntf^));
  end
  else
    Result := False;
end;

function TCellObject.siConstructNewCell( const aCellClass: TCellClass;
  const aLongName: string; const aIntf : PsiCellObject) : Boolean;
begin
  Result := siConstructNewCell( aCellClass, aLongName, IsiCellObject, aIntf);
end;



function TCellObject.siRemoveSubCell(const aIdx: Integer): Boolean;
var
  I: Integer;
  vController: IsiCellObject;
begin
  Result := siSubCellValid(aIdx);

  if Result then
  begin
    // sub cell is an entry in constructed list block
    if aIdx < fConstructedCellCount then
      Dec(fConstructedCellCount);

    // if this cell the controller, then reset controller connection
    if fSubCells[aIdx].siIsControlled(vController) and siIsSame(vController) then
      fSubCells[aIdx].siController:=nil;

    // clear ref in list entry
    fSubCells[aIdx] := nil;

    // pack list
    for I := aIdx + 1 to High(fSubCells) do
      fSubCells[I - 1] := fSubCells[I];
    SetLength(fSubCells, siSubCellCount - 1);
  end;
end;

function TCellObject.siRemoveSubCell(const aName: string): Boolean;
var
  vName:          string;
  vCount:         Integer;
  vRemoveIdx:     Integer;
begin
  Result := False; // not entry found status
  vName:=Trim(UpperCase(aName));

  for vCount:= 0 to High(fSubCells) do { Find element to remove. }

    if CompareNames(fSubCells[vCount].siName, aName) then
    begin
      vRemoveIdx := vCount;
      Result := siRemoveSubCell(vRemoveIdx);
      Break;
    end;
end;

function TCellObject.siRemoveSubCell(const aCell: IsiCellObject): Boolean;
var
  vCount:         Integer;
  vRemoveIdx:     Integer;
begin
  Result := False; // not entry found status

  if Assigned(aCell) then
    for vCount:= 0 to High(fSubCells) do { Find element to remove. }
      if fSubCells[vCount].siIsSame(aCell) then
      begin
        vRemoveIdx := vCount;
        Result := siRemoveSubCell(vRemoveIdx);
        Break;
      end;
end;

procedure TCellObject.siRemoveAllSubCells;
var
  vIdx: Integer;
begin
  if Length(fSubCells)>0 then
  begin
    for vIdx := 0 to High(fSubCells) do
      fSubCells[vIdx]:=nil;
    SetLength(fSubCells,0);
  end;
  fConstructedCellCount := 0;
end;

function TCellObject.siDeleteCell( const aLongName : string) : boolean;
var vCell : IsiCellObject;
begin
  Result := siFindCell(aLongName,@vCell) and vCell.siDeleteCell;
end;

function TCellObject.siDeleteCell( const aCell : IsiCellObject) : boolean;
begin
  Result := Assigned(aCell) and aCell.siDeleteCell;
end;

function TCellObject.siDeleteCell : boolean;
var vControl : IsiCellObject;
begin
  Result := siIsControlled(vControl) and vControl.siRemoveSubCell(siSelf);
end;

{$ENDREGION}

{$REGION 'Cell procedure execution'}
function TCellObject.siGetOnRead : TOnCellProcedure;
begin
  Result:= fOnRead;
end;

procedure TCellObject.siSetOnRead(const aOnCellProcedure : TOnCellProcedure);
begin
  fOnRead := aOnCellProcedure;
end;

function TCellObject.siGetOnWrite : TOnCellProcedure;
begin
  Result:= fOnWrite;
end;

procedure TCellObject.siSetOnWrite(const aOnCellProcedure : TOnCellProcedure);
begin
  fOnWrite := aOnCellProcedure;
end;


procedure TCellObject.siCall;
begin
  siGetValue;
end;
{$ENDREGION}

{$REGION 'content of IsiCellOBject'}
// Content as Value read / write
function TCellObject.siGetValue : TValue;
begin
  if Assigned(fOnRead) and not fDuringCellCall then
  try
    fDuringCellCall := True;
    fOnRead(Self);
  finally
    fDuringCellCall := False;
  end;
  Result := fCellValue;
end;

procedure TCellObject.siSetValue(const aValue: TValue);
begin
  fCellValue := aValue;
  if Assigned(fOnWrite) and not fDuringCellCall then
  try
    fDuringCellCall := True;
    fOnWrite(Self);
  finally
    fDuringCellCall := False;
  end;
end;

function TCellObject.siGetValue(const aLongName: string) : TValue;
begin
  if not siTryGetValue(aLongName,Result) then
    Result:=TValue.Empty;
end;

procedure TCellObject.siSetValue(const aLongName: string; const aValue: TValue);
begin
  siTrySetValue(aLongName,aValue);
end;

function TCellObject.siTryGetValue(const aLongName: string; out aResult: TValue) : Boolean;
var
  vCell:  IsiCellObject;
begin
  vCell:= siFindCell(aLongName);        // find the long named cell
  Result:=Assigned(vCell);

  if Result then
    aResult:=vCell.siGetValue;       // get value as RTTI TValue independed of type
end;

function TCellObject.siTrySetValue(const aLongName: string; const aValue: TValue) : Boolean;
var
  vCell:  IsiCellObject;
begin
  vCell:= siFindCell(aLongName);      // find the long named cell
  Result:=Assigned(vCell);

  if Result then
    vCell.siSetValue(aValue);      // set value as RTTI TValue independed of type
end;

function TCellObject.siGetAsString : string;
//var vValue : TValue;
begin
  Result := siGetValue.ToString;

  { vollständig Umwandlung des Value zum string (vom Orig) - Sonderhanhabung möglich
  vValue := siGetValue;


  if vValue.IsEmpty then
    Exit(''); // do not localize

  case vValue.Kind of
    tkUnknown: Result := '(type unknown)'; // do not localize
    tkInteger:
      case GetTypeData(vValue.TypeInfo)^.OrdType of
        otSByte,
        otSWord,
        otSLong: Result := IntToStr(vValue.AsType<Int64>);
        otUByte,
        otUWord,
        otULong: Result := UIntToStr(vValue.AsType<uint64>);
      end;
    tkChar: Result := string(vValue.AsType<AnsiChar>);
    tkEnumeration:
      Result := GetEnumName(vValue.TypeInfo, vValue.AsOrdinal); // fRttiValue.ToString;
    tkFloat:
      case GetTypeData(vValue.TypeInfo)^.FloatType of
        ftSingle: Result := FloatToStr(vValue.AsType<Single>);
        ftDouble:
        begin
          if vValue.Typeinfo = System.TypeInfo(TDate) then
            Result := DateToStr(vValue.AsType<Double>)
          else if vValue.Typeinfo = System.TypeInfo(TTime) then
            Result := TimeToStr(vValue.AsType<Double>)
          else if vValue.Typeinfo = System.TypeInfo(TDateTime) then
            Result := DateTimeToStr(vValue.AsType<Double>)
          else
            Result := FloatToStr(vValue.AsType<Double>);
        end;
        ftExtended: Result := FloatToStr(vValue.AsType<Extended>);
        ftComp: Result := IntToStr(vValue.AsType<Int64>);
        ftCurr: Result := CurrToStr(vValue.AsType<Currency>);
      end;
    tkString, tkLString, tkUString, tkWString: Result := vValue.AsType<string>;
    tkSet: Result := SetToString(vValue.TypeInfo, vValue.AsOrdinal, True);
    tkClass:
      if vValue.AsObject = nil then
        Result := '(empty object)' // do not localize
      else
        Result := vValue.AsObject.ClassName;
    tkMethod: Result := Format('(method code=%p, data=%p)', [vValue.AsType<TMethod>.Code, vValue.AsType<TMethod>.Data]); // do not localize
    tkWChar: Result := vValue.AsType<WideChar>;  // ACHTUNG: Könnte vielleicht auch Memory Leaks erzeugen!
    tkVariant: Result := '(variant)'; // do not localize
    tkArray: Result := '(array)'; // do not localize
    tkRecord: Result := '(record)'; // do not localize
    tkProcedure: Result := Format('(procedure @ %p)', [Pointer(vValue.AsType<Pointer>)]); // do not localize
    tkPointer: Result := Format('(pointer @ %p)', [Pointer(vValue.AsType<Pointer>)]); // do not localize
    tkInterface: Result := Format('(interface @ %p)', [PPointer(vValue.GetReferenceToRawData)^]); // do not localize
    tkInt64:
      with GetTypeData(vValue.TypeInfo)^ do
        if MinInt64Value > MaxInt64Value then
          Result := UIntToStr(vValue.AsType<UInt64>)
        else
          Result := IntToStr(vValue.AsType<Int64>);
    tkDynArray: Result := '(dynamic array)'; // do not localize
    tkClassRef:
      if vValue.AsClass = nil then
        Result := '(empty class reference)' // do not localize
      else
        Result := Format('(class ''%s'' @ %p)', [vValue.AsClass.ClassName, Pointer(vValue.AsClass)]); // do not localize
  end; }

end;

procedure TCellObject.siSetAsString(const aValue: String);
begin
  // to be override in derivated objects !!!
  // siValue := TValue.From<string>(aValue);
end;

function TCellObject.siGetAsJSON : TJSONValue;
//var vValue : TValue;
begin
  Result:=nil;

{ content as JSON Value is to be override in derivated objects
  vValue := siGetValue;

  if not vValue.IsEmpty then
  begin
    case vValue.Kind of
      tkUnknown: Result := nil; // do not localize
      tkInteger:
        case GetTypeData(vValue.TypeInfo)^.OrdType of
          otSByte, otSWord, otSLong:
            Result := TJSONNumber.Create(vValue.AsType<Int64>);
          otUByte, otUWord, otULong:
            Result := TJSONNumber.Create(vValue.AsType<uint64>);
        end;
      //tkChar: Result := TJSONString.Create(JSONStrDecode(vValue.AsType<AnsiChar>));
      tkChar: Result := TJSONString.Create(JSONStrDecode(vValue.AsType<String>));
      tkEnumeration:
        if vValue.Typeinfo = System.TypeInfo(Boolean) then
        begin
          if vValue.AsBoolean then
            Result:=TJSONTrue.Create
          else
            Result:=TJSONFalse.Create;
        end
        else
          Result := TJSONString.Create(JSONStrDecode(GetEnumName(vValue.TypeInfo, vValue.AsOrdinal)));
      tkFloat:
        case GetTypeData(vValue.TypeInfo)^.FloatType of
          ftSingle: Result := TJSONNumber.Create(vValue.AsType<Single>);
          ftDouble:
          begin
            if vValue.Typeinfo = System.TypeInfo(TDate) then
              Result := TJSONString.Create(DateToStr(vValue.AsType<Double>))
            else if vValue.Typeinfo = System.TypeInfo(TTime) then
              Result := TJSONString.Create(TimeToStr(vValue.AsType<Double>))
            else if vValue.Typeinfo = System.TypeInfo(TDateTime) then
              Result := TJSONString.Create(DateTimeToStr(vValue.AsType<Double>))
            else
              Result := TJSONNumber.Create(vValue.AsType<Double>);
          end;
          ftExtended: Result := TJSONNumber.Create(vValue.AsType<Extended>);
          ftComp: Result := TJSONNumber.Create(vValue.AsType<Int64>);
          ftCurr: Result := TJSONString.Create(CurrToStr(vValue.AsType<Currency>));
        end;
      tkString, tkLString, tkUString, tkWString:
        Result := TJSONString.Create(JSONStrDecode(vValue.AsType<string>));
      tkSet:
        Result := TJSONString.Create(JSONStrDecode(SetToString(vValue.TypeInfo, vValue.AsOrdinal, True)));
      tkClass:
        if vValue.AsObject = nil then
          Result := nil // do not localize
        else
          Result := TJSONString.Create(vValue.AsObject.ClassName);

      tkMethod: Result := nil; // do not localize

      tkWChar: Result := TJSONString.Create(JSONStrDecode(vValue.AsType<WideChar>));

      tkVariant: Result := nil; // do not localize
      tkArray: Result := nil; // do not localize
      tkRecord: Result := nil; // do not localize
      tkProcedure: Result := nil; // do not localize
      tkPointer: Result := nil; // do not localize
      tkInterface: Result := nil; // do not localize

      tkInt64:
        with GetTypeData(vValue.TypeInfo)^ do
          if MinInt64Value > MaxInt64Value then
            Result := TJSONNumber.Create(vValue.AsType<UInt64>)
          else
            Result := TJSONNumber.Create(vValue.AsType<Int64>);

      tkDynArray: Result := nil; // do not localize

      tkClassRef:
        if vValue.AsClass = nil then
          Result := nil // do not localize
        else
          Result := TJSONString.Create(vValue.AsClass.ClassName);
    end;
  end; }
end;

procedure TCellObject.siSetAsJSON(aJSONValue : TJSONValue);
begin
  { to be Override in deviated object !!!
  if Assigned(aJSONValue) then
    siAsString := aJSONValue.Value; }
end;

// CELL content and structure as JSON
function TCellObject.siGetCellContentAsJSONObject: TJSONObject;
begin
  Result:= siGetCellContentAsJSONObject(C_CONTENT_MAIN_REQUEST);
end;

function TCellObject.siGetCellContentAsJSONObject(const aMainRequest: Boolean): TJSONObject;
var
  vSubCellArray : TJSONArray;
  vCount        : Integer;
  vCell         : IsiCellObject;
  vSubJSON      : TJSONObject;
begin
  Result:= TJSONObject.Create();

  // common and public cell information as cell header information
  Result.SetPairValue(C_PV_CELL, siName);
  //Result.SetPairValue(C_PV_LONG_NAME, siLongName);

  if not fCellTypeName.IsEmpty then
  begin
    Result.SetPairValue(C_PV_TYPE_NAME, fCellTypeName);
    Result.SetPairValue(C_PV_TYPE_GUID, fCellTypeGuid);
  end
  else
    Result.SetPairValue(C_PV_TYPE_CLASS, 'unregistred class: ' + UnitName+' '+ClassName);

  if aMainRequest or fSubCellContent then
  begin

    // cell object value
    Result.SetPairValue(C_PV_VALUE, siAsJSON);
    //Result.SetPairValue(C_PV_STRING, siGetAsString);

    if siSubCellCount>0 then
    begin
      // sub cell list informations
      Result.SetPairValue(C_PV_SUB_CELL_COUNT, siSubCellCount);

      if fConstructedCellCount>0 then
        Result.SetPairValue(C_PV_CON_CELL_COUNT, fConstructedCellCount);

      vSubCellArray:= TJSONArray.Create();

      for vCount := 0 to High(fSubCells) do // check the list of sub cells
      begin
        if Supports(fSubCells[vCount],IsiCellObject,vCell) then // when sub cell entry valid
        begin

          if vCell.siGetController <> siSelf then  // when sub cell not controlled by self, then link entry
          begin
            vSubJSON:= TJSONObject.Create();
            vSubJSON.SetPairValue(C_PV_LINK, vCell.siLongName);
            //vSubJSON.SetPairValue(C_PV_GUID, vCell.siGuid);
          end
          else
            // save deeper cell as subCellContent
            vSubJSON:= vCell.siGetCellContentAsJSONObject(C_CONTENT_SUBCELL_REQUEST);
            if not (vSubJSON is TJSONObject) then   // when result nil, then empty entry
            begin
              vSubJSON:= TJSONObject.Create();
              vSubJSON.SetPairValue(C_PV_EMPTY_POS, vCell.siName);
            end;
        end
        else  // when no cell on list position, then empty entry
        begin
          vSubJSON:= TJSONObject.Create();
          vSubJSON.SetPairValue(C_PV_EMPTY_POS, vCount);
        end;

        Assert(Assigned(vSubJSON),'Undefined JSON object in sub cell saving! '+siLongName);

        vSubCellArray.AddElement(vSubJSON);      // and element, when assigned
      end;

      if vSubCellArray.Size>0 then // when sometimes assigned vSubJSON (array count >= 1)
        Result.SetPairValue(C_PV_SUB_CELL_LIST, vSubCellArray) // add Array as sub.cell to content object
      else
        vSubCellArray.Free;                       // get free when not need
    end;
  end;
end;

procedure TCellObject.siSetCellContentFromJSONObject(const aJSONObject: TJSONObject);
begin
  siSetCellContentFromJSONObject(aJSONObject,C_CONTENT_MAIN_REQUEST);
end;

procedure TCellObject.siSetCellContentFromJSONObject(const aJSONObject: TJSONObject; const aMainRequest: Boolean);
var
  vRegister :         IsiCellTypeRegister;
  vPlaceHolder :      IsiPlaceHolderManager;
  vRestorable:        Boolean;
  vStr:               string;
  vGuid:              TGUID;
  vValue:             TJSONValue;
  vConstructedCell :  Boolean;
  vSubCellArray:      TJSONArray;
  vCount:             Integer;
  vConCellCount:      Integer;
  vObject:            TJSONObject;
  vCell:              IsiCellObject;
  vCellName:          string;
  vSize:              Integer;
begin
  vRegister := RootSkill<IsiCellTypeRegister>;
  vPlaceHolder := RootSkill<IsiPlaceHolderManager>;

  if Assigned(aJSONObject) then
  begin
    // cell only restorable, when cell type the same - check first GUID then Name
    if aJSONObject.TryGetPairValue(C_PV_TYPE_GUID,vGuid) then
      vRestorable:= vGuid=siTypeGuid
    else if aJSONObject.TryGetPairValue(C_PV_TYPE_NAME,vStr) then
      vRestorable:= vStr=siTypeName
    else
      vRestorable:=True;

    if vRestorable then
    begin
      if aJSONObject.TryGetPairValue(C_PV_CELL, vStr) then
        siName:= vStr;

      if aMainRequest or fSubCellContent then
      begin

        if aJSONObject.TryGetPairValue(C_PV_VALUE, vValue) then
          siAsJSON:= vValue;

        ClearRunTimeSubCells; // gibt es Laufzeit Zellen in der Liste, dann lösche sie aus der SubCellList

        if aJSONObject.TryGetPairValue(C_PV_SUB_CELL_LIST,vSubCellArray) and  // wenn Array existiert und size > 0
          (vSubCellArray.Size>0) then
        begin
          if not aJSONObject.TryGetPairValue(C_PV_CON_CELL_COUNT,vConCellCount) then // lese construceted cellCount aus JSON
            vConCellCount:=0;

          //Assert(vConCellCount<=vSubCellArray.Size,'constructor.cell.count is higher as sub.cells array size! '+siLongName);

          vSize:= vSubCellArray.Size;

          for vCount := 0 to vSize-1 do
          begin
            vConstructedCell:= vCount < vConCellCount;

            vObject:= vSubCellArray.Get(vCount) as TJSONObject;

            if vConstructedCell then // für Konstrukteur Zelle im JSON Object
            begin
              vCell:= siSubCell[vCount];

              // wenn cell in der Liste existiert und controlled ist
              if Assigned(vCell) and siIsSame(vCell.siController) and
               vObject.TryGetPairValue(C_PV_CELL,vCellName) then
                vCell.siSetCellContentFromJSONObject(vObject,C_CONTENT_SUBCELL_REQUEST);

            end
            else
            begin // für Laufzeit Zelle
              if vObject.TryGetPairValue(C_PV_LINK,vCellName) then // für verlinkte Zellen
              begin
                vCell:= vPlaceHolder.siNewPlaceHolder(siSelf,siSubCellCount,vCellName);
              end
              // für eigene Zellen
              else
              begin
                if vObject.TryGetPairValue(C_PV_CELL,vCellName) then
                begin

                  if vObject.TryGetPairValue(C_PV_TYPE_GUID,vGuid) then // bilde in der Registry aus der Type Guid
                    vCell:=siAddSubCell(
                     vRegister.siBuildNewCell(vGuid,vCellName))
                  else if vObject.TryGetPairValue(C_PV_TYPE_NAME,vStr) then // bilde in der Registry aus dem Type Namen
                    vCell:=siAddSubCell(
                     vRegister.siBuildNewCell(vStr,vCellName))
                  else // ansonsten bilde ein allg. Zellobjekt
                    vCell:= siAddSubCell(TCellObject.create(vCellName));

                  if Assigned(vCell) then
                    vCell.siSetCellContentFromJSONObject(vObject, C_CONTENT_SUBCELL_REQUEST);

                end
                else
                  vCell:= nil;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TCellObject.siSave;
var
  vCount      : Integer;
  vController : IsiCellObject;
begin
  for vCount := 0 to High(fSubCells) do // check the list of sub cells
    if Assigned(fSubCells[vCount]) and fSubCells[vCount].siIsControlled(vController) and
     siIsSame(vController) then
      fSubCells[vCount].siSave;
end;

procedure TCellObject.siRestore;
var
  vCount      : Integer;
  vController : IsiCellObject;
begin
  for vCount := 0 to High(fSubCells) do // check the list of sub cells
    if Assigned(fSubCells[vCount]) and fSubCells[vCount].siIsControlled(vController) and
     siIsSame(vController) then
      fSubCells[vCount].siRestore;
end;

{$ENDREGION}

{$REGION 'implementation of first derivatives'}
procedure TSkillInterfaceCell.CellConstruction;
begin
  inherited;
  fSubCellContent := false;
end;

{$ENDREGION}

end.
