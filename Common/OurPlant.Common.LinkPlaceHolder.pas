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
//
// *****************************************************************************

unit OurPlant.Common.LinkPlaceHolder;

interface

{$REGION 'uses'}
uses
  OurPlant.Common.CellObject,
  OurPlant.Common.CellAttributes,
  OurPlant.Common.DataCell,
  OurPlant.Common.TypesAndConst;
{$ENDREGION}

type

  {$REGION 'IsiPlaceHolderManager - skill interface for link placeholder manager'}
  IsiPlaceHolderManager = interface(IsiCellObject)
  ['{F69DE101-9382-45D3-B2C3-95BE13EA3BBC}']
    function siNewPlaceHolder( const aDestinationCell: IsiCellObject;
      const aDestinationListIdx: Integer; const aLinkedCellName: string): IsiCellObject;
    function siReconstructLinks : boolean;
  end;
  {$ENDREGION}

  {$REGION 'TcoLinkPlaceHolderManager - cell object for link placeholder management'}
  [RegisterCellType('placeholder manager','{045F27A6-6C1A-494D-BB48-14C71D89C877}')]
  TcoPlaceHolderManager = class(TCellObject, IsiPlaceHolderManager)
  public
    /// <summary>
    ///  construction of cell content & structures and set defaults
    ///  Are called at the end of AfterConstruction of TCellobject. Derivate's
    ///  overrides this method to define and construct the cell structure and
    ///  settings.
    /// </summary>
    procedure CellConstruction; override;

  strict protected
    function siNewPlaceHolder( const aDestinationCell: IsiCellObject;
      const aDestinationListIdx: Integer; const aLinkedCellName: string): IsiCellObject;
    function siReconstructLinks : boolean;
  end;
  {$ENDREGION}

  {$REGION 'IsiLinkPlaceHolder - skill interface for link placeholder entry'}
  IsiLinkPlaceHolder = interface(IsiCellObject)
  ['{66B08852-8021-4108-A833-C8DB325CF6EC}']
    function  siGetLinkedCellName : string;
    procedure siSetLinkedCellName(const aCellName: string);
    property  siLinkedCellName : string read siGetLinkedCellName write siSetLinkedCellName;
  end;
  {$ENDREGION}

  {$REGION 'TcoLinkPlaceHolder - cell object for link placeholder entry'}
  [RegisterCellType('placeholder','{4B590D5C-A1BB-4AC9-B3AB-7E3232349E45}')]
  //[NoContentAtSubCellRequest]
  TcoLinkPlaceHolder = class(TcoString, IsiLinkPlaceHolder)
  strict protected
    function  siGetLinkedCellName : string;
    procedure siSetLinkedCellName(const aCellName: string);
    property  siLinkedCellName : string read siGetLinkedCellName write siSetLinkedCellName;
  end;
  {$ENDREGION}

implementation

{$REGION 'uses'}
uses
  System.SysUtils;
{$ENDREGION}

{$REGION 'TcoLinkPlaceHolderManager implementation'}
procedure TcoPlaceHolderManager.CellConstruction;
begin
  inherited;

  fSubCellContent := False; // nicht als sub cell content speichern
end;

function TcoPlaceHolderManager.siNewPlaceHolder( const aDestinationCell: IsiCellObject;
  const aDestinationListIdx: Integer; const aLinkedCellName: string): IsiCellObject;
var vPlaceHolder : IsiLinkPlaceHolder;
begin
  Assert(Assigned(aDestinationCell),'Invalid destination cell in NewPlaceHolder');
  Assert(aLinkedCellName<>'','Invalid empty linked cell name in NewPlaceHolder of '+aDestinationCell.siLongName);

  vPlaceHolder:= TcoLinkPlaceHolder.create('['+aLinkedCellName+']');

  if Assigned(vPlaceHolder) then
  begin
    vPlaceHolder.siLinkedCellName := aLinkedCellName;

    Result:= aDestinationCell.siAddSubCell(vPlaceHolder);  // add first in destination cell sub list (setzt controller)

    siAddSubCell(vPlaceHolder); // add then in placerholer manager list
  end
  else
    Result:=nil;
end;

function TcoPlaceHolderManager.siReconstructLinks : boolean;
var
  vLastIdx :      Integer;
  vCount :        Integer;
  vLinkCellName : string;
  vPlaceHolder :  IsiLinkPlaceHolder;
  vDestination :  IsiCellObject;
  vSubCell :      IsiCellObject;
begin
  vLastIdx := High(fSubCells);

  for vCount := vLastIdx downto 0 do     // count backward from end the placeholder list
    if Supports(fSubCells[vCount],IsiLinkPlaceHolder,vPlaceHolder) then // when sub cell entry valid
    begin
      vLinkCellName := vPlaceHolder.siLinkedCellName;

      // check Linked cell name empty
      Assert(vLinkCellName <> '',
       'Invalid empty LinkedCellName in placeholder '+vPlaceHolder.siLongName);

      // Destination is the controller cell of placeholder
      vDestination := vPlaceHolder.siController;

      // check validity of destination cell
      Assert(Assigned(vDestination),
       'Unvalid destination cell in placeholder '+vPlaceHolder.siLongName);

      // search cell in destination cell the linked cell with longname (relative longnames are possible)
      vSubCell:= vDestination.siFindCell(vLinkCellName);

      if vDestination.siSwapSubCell(vPlaceHolder,vSubCell) then
        siRemoveSubCell(vCount);                // remove reconstructed placeholder freom list

    end;
  Result := True;
end;

{$ENDREGION}

{$REGION 'TcoLinkPlaceHolder implementation'}
function  TcoLinkPlaceHolder.siGetLinkedCellName : string;
begin
  Result:= siAsString;
end;

procedure TcoLinkPlaceHolder.siSetLinkedCellName(const aCellName: string);
begin
  siAsString:= aCellName;
end;

{$ENDREGION}

end.
