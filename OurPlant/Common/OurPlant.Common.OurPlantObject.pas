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
//    Gerrit Häcker (2020)
// *****************************************************************************

{-------------------------------------------------------------------------------
   The Unit is the general part of the micro cell architecture for Delphi.

   It contains:
   * IsiOurPlantObject - ist ein generelles Interface auf dem alle Interface der
     "alten" OurPlantWelt und das IsiCellObject Interface aufbaut

   * INameAble - ein Basis-Interface aus der "alten" Welt implementiert in einem
     Objekt die Fähigkeit eines Namen (GetName & Property)

   * TOurPlantObject - ist das generelle interfaecd Basis Object als kleinster
     Nenner (BasisKlasse) ziwschen den Object der "alten" OurPlant OS Welt und
     dem Basis Zellobjekt TCellObject, von dem alle Zellobjekte abgeleitet sind.

   * the global variables
       RunningAsUnitTest: Boolean;
       ExceptionText: string;

-------------------------------------------------------------------------------}
unit OurPlant.Common.OurPlantObject;

interface

{$REGION 'uses'}
uses
  System.SysUtils;
{$ENDREGION}

type
  {$REGION 'Forward types'}
  TOurPlantObject = class;
  {$ENDREGION}

  {$REGION 'IsiOurPlantObject'}
  IsiOurPlantObject = interface(IInvokable)
    ['{BC47BE11-941B-4E10-BE68-8B239993F480}']
    /// <summary>
    ///   siGetName get the name of ourplant object instance
    /// </summary>
    function siGetName: string;
    /// <summary>
    ///   Set the cell name of ourplant object instance
    /// </summary>
    /// <param name="aName">
    ///   The name of object instance
    /// </param>
    procedure siSetName(const aName: string);
    /// <summary>
    ///   read / write the name of ourplant object instance
    /// </summary>
    property siName : string read siGetName write siSetName;
  end;
  {$ENDREGION}

  INameAble = interface(IsiOurPlantObject)
    ['{BDC35B72-3551-4259-8646-263574B6DD2D}']
    function GetName: string;
    property Name: string read GetName;
  end;

  {$REGION 'TOurPlantObject'}
  TOurPlantObject = class(TInterfacedObject, IsiOurPlantObject, IUnknown)
  strict private
    fName : string;
  public
    constructor create; overload;
    constructor create(const aName:string); overload;

    class procedure AccessViolationDestruction(const aRefCount: Integer; const aDuringString: string; aObject: TObject);

    destructor Destroy; override;
    procedure BeforeDestruction; override;

  public // IsiOurPlantObject implementation
    /// <summary>
    ///   siGetName get the name of ourplant object instance
    /// </summary>
    function siGetName: string; virtual;
    /// <summary>
    ///   Set the cell name of ourplant object instance
    /// </summary>
    /// <param name="aName">
    ///   The name of object instance
    /// </param>
    procedure siSetName(const aName: string); virtual;
    /// <summary>
    ///   read / write the name of ourplant object instance
    /// </summary>
    /// <remarks>
    ///   siName ist Dominat, die Aufruf über andere Interface (GetName, etc)
    ///   rufen siName Methoden auf! <br />
    /// </remarks>
    property siName : string read siGetName write siSetName;

  public // INamable implementation of old OS structure
    /// <summary>
    ///   get the name of object instance over INamable interface reference
    /// </summary>
    function GetName: string; //virtual;  { TODO -oGerrit -cMicroCell Migration : GetName von TOurPlantObject ist noch nicht virtual, wird einfach von Erben überschrieben }
    /// <summary>
    ///   Get the name of object instance as property of GetName
    /// </summary>
    property Name: string read GetName;
  end;
  {$ENDREGION}

  /// <summary>
  ///   Access Violation at destruction of object / cell. calles at
  ///   BeforeDestruction and during destructor Destroy
  /// </summary>
  EAccessViolationDestruction = class abstract(EAccessViolation);

{$REGION 'Global variables'}
var
  RunningAsUnitTest: Boolean;
  ExceptionText: string;
{$ENDREGION}

implementation

{$REGION 'uses'}
//uses
//  MachineHistory;
{$ENDREGION}

{$REGION 'TOurPlantObject'}
constructor TOurPlantObject.create;
begin
  create('');
end;


constructor TOurPlantObject.create(const aName:string);
begin
  fName := aName;
end;

destructor TOurPlantObject.Destroy;
begin
  {Destroy checkt nur noch, ob der RefCount ungleich 0 ist}
  AccessViolationDestruction(FRefCount, 'Destroying', Self);
  {Destroy braucht seinen Vorgänger (inherited) nicht auf da dieser destructor
  keine weiteren Aufrufe besitzt}
end;

procedure TOurPlantObject.BeforeDestruction;
begin
  {BeforeDestruction muss am Ende seines Nachfolger aufgerufen werden und checkt
  nur noch, ob alle Referenzen ge-NIL-t wurden sind}
  AccessViolationDestruction(FRefCount, 'BeforeDestruction', Self);
  {BeforeDestruction ruft nicht seinen Vorgänger auf, um nicht eine zweite
  Exception zu erzeugen}
end;

function TOurPlantObject.siGetName: string;
begin
  Result := fName;
end;

procedure TOurPlantObject.siSetName(const aName: string);
begin
  fName := aName;
end;

function TOurPlantObject.GetName: string;
begin
  Result := fName;
end;

{$ENDREGION}

class procedure TOurPlantObject.AccessViolationDestruction(const aRefCount: Integer; const aDuringString: string; aObject: TObject);
var
  E: EAccessViolationDestruction;
begin
  if aRefCount <> 0 then
  try
    if aObject is TOurPlantObject then
      E := EAccessViolationDestruction.Create(
        (Format('During %s of object %s (%s) in unit %s with %d remaining references.',
        [aDuringString, aObject.ClassName, TOurPlantObject(aObject).siName, aObject.UnitName, aRefCount])))
    else
      E := EAccessViolationDestruction.Create(
        (Format('During %s of object %s in unit %s with %d remaining references.',
        [aDuringString, aObject.ClassName, aObject.UnitName, aRefCount])));

    raise E;
  except
    on E: Exception do
    begin
      if RunningAsUnitTest then
        ExceptionText := E.Message
      //else if DebugHook = 0 then
        //ErrorLog('CheckAccessViolationDestruction', E.Message); // sometimes fLogger is free...no LogInfo while shutting down
    end;
  end;
end;

initialization
  RunningAsUnitTest := False;

end.
