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
// *****************************************************************************

unit OurPlant.Common.DataManager;

interface

{$REGION 'uses'}
uses
  System.Rtti,
  {$IF CompilerVersion >= 28.0}System.Json,{$ENDIF}
  OurPlant.Common.CellObject,
  OurPlant.Common.DataCell,
  OurPlant.Common.CellAttributes,
  OurPlant.Common.TypesAndConst;
{$ENDREGION}

const
  C_STANDARD_FILE_DIR = 'C:\data\ourplant';
  C_FILE_DELIMITER = '\';
  C_FILE_DEFAULT_NAME = 'index';
  C_FILE_DEFAULT_EXT = '.json';

type
  {$REGION 'IsiDataManager1 - Data manager skill interface Release 1'}
  /// <summary>
  ///  Data skill interface for data manager in Release 1
  /// </summary>
  IsiDataManager1 = interface(IsiCellObject)
    ['{EE9289A8-B79C-4DB7-AEE4-197244A4EC27}']
    procedure siSaveCellJSONContent(const aCell: IsiCellObject; const aName: string = '');
    procedure siRestoreCellJSONContent(const aCell: IsiCellObject; const aName: string = '');
  end;
  {$ENDREGION}

  {$REGION 'TcoStandardDataManager - Standard Data Manager with JSON File'}
  [RegisterCellType('standard data manager','{999FDEF4-BA2B-494A-87BF-085EA2E20538}')]
  TcoStandardDataManager = class(TCellObject, IsiDataManager1)
  public
    /// <summary>
    ///  construction of cell content & structures and set defaults
    ///  Are called at the end of AfterConstruction of TCellobject. Derivate's
    ///  overrides this method to define and construct the cell structure and
    ///  settings.
    /// </summary>
    procedure CellConstruction; override;

  strict protected
    fDataRoot:IsiString;

    function GetPathName(const aCell: IsiCellObject): string; virtual;
    function GetValidFileName(const aCell: IsiCellObject): string; overload;
    function GetValidFileName(const aCell: IsiCellObject; const aFileName: string): string; overload; virtual;

  strict protected // implementation IsiDataManager1
    procedure siSaveCellJSONContent(const aCell: IsiCellObject; const aName: string = ''); overload; virtual;
    procedure siRestoreCellJSONContent(const aCell: IsiCellObject; const aName: string = ''); overload; virtual;
  end;
  {$ENDREGION}

implementation

{$REGION 'uses'}
uses
  System.IOUtils,
  System.SysUtils,
  Data.DBXJSON,
  REST.Json;
{$ENDREGION}

{$REGION 'TcoStandardDataManager implementation'}
procedure TcoStandardDataManager.CellConstruction;
begin
  inherited;

  // construct fDataRoot as string cell
  fDataRoot := ConstructNewCellAs<IsiString>( TcoString, 'FileDir');
  fDataRoot.siAsString := C_STANDARD_FILE_DIR; // set data to default
end;

function TcoStandardDataManager.GetPathName(const aCell: IsiCellObject): string;
var
  vCell, vController: IsiCellObject;
begin
  if Assigned(aCell) and siIsControlled then
  begin
    if not siController.siIsSame(aCell) then
    begin
      vCell:= aCell;
      Result:= vCell.siName;

      // gehe im Pfad eine Ebene tiefer, solange ein Controller definiert ist und
      // der Controller nicht der Controller von DataManager ist
      while vCell.siIsControlled(vController) and not siController.siIsSame(vController) do
      begin
        Result:= vController.siName + C_FILE_DELIMITER + Result;
        vCell:= vController;
      end;
      Result:= fDataRoot.siAsString + C_FILE_DELIMITER + Result;
    end
    else
      Result:= fDataRoot.siAsString;
  end
  else
    Result:= fDataRoot.siAsString + C_FILE_DELIMITER + 'WOM';
end;

function TcoStandardDataManager.GetValidFileName(const aCell: IsiCellObject): string;
begin
  Result:= GetPathName(aCell) + C_FILE_DELIMITER + C_FILE_DEFAULT_NAME + C_FILE_DEFAULT_EXT;
end;

function TcoStandardDataManager.GetValidFileName(const aCell: IsiCellObject; const aFileName: string): string;
begin
  if aFileName<>'' then
  begin
    if ExtractFileDir(aFileName) = '' then
    begin
      Result:= GetPathName(aCell) + C_FILE_DELIMITER + aFileName;
      if ExtractFileExt(Result)='' then
        Result := Result + C_FILE_DEFAULT_EXT;
    end
    else
      Result:= aFileName;
  end
  else
    Result := GetValidFileName(aCell)
end;

procedure TcoStandardDataManager.siSaveCellJSONContent(const aCell: IsiCellObject; const aName: string = '');
var
  vFileName: string;
  vFileDir : string;
  vContent : string;
begin
  Assert(Assigned(aCell),'Unassigned cell reference in siSaveCell of data manager '+siLongName);

  vFileName:= GetValidFileName( aCell, aName); // convert to a valid file name with path
  vFileDir:= ExtractFileDir( vFileName);      // exctract dir from file name string

  if (vFileDir<>'') and ForceDirectories(vFileDir) then
  begin
    vContent := TJson.Format(aCell.siGetCellContentAsJSONObject);
    TFile.WriteAllText( vFileName, vContent);
  end;

end;

procedure TcoStandardDataManager.siRestoreCellJSONContent(const aCell: IsiCellObject; const aName: string = '');
var
  vFileName : string;
  vContent  : string;
begin
  Assert(Assigned(aCell),'Unassigned cell reference in siRestoreCellFrom of data manager '+siLongName);

  vFileName:= GetValidFileName( aCell, aName); // convert to a valid file name with path

  //Assert(FileExists(vFileName,true),'Non existing file in siRestoreCellFromJSONFile from cell '+siLongName);
  if FileExists(vFileName,true) then
  begin
    vContent := TFile.ReadAllText( vFileName);
    aCell.siSetCellContentFromJSONObject( TJSONObject.ParseJSONValue( vContent) as TJSONObject);
  end;
end;
{$ENDREGION}

end.
