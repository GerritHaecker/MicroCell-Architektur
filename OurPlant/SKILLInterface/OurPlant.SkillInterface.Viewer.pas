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
//    Gerrit Häcker (2021)
// *****************************************************************************

unit OurPlant.SkillInterface.Viewer;
interface

{$REGION 'uses'}
uses
  Forms,
  extctrls,
  Vcl.Menus,
  Vcl.StdCtrls,
  OurPlant.Common.CellObject,
  OurPlant.Sample1.Main,
  OurPlant.Common.DataCell;
{$ENDREGION}

type
  {$REGION 'IsiViewer in Release 1'}
  IsiViewer1 = interface(IsiCellObject)
  ['{79E30E22-AE87-48BA-8F9A-F3187F50FF3F}']
    procedure siStart;
    procedure siStop;

    procedure siShowCell( const aCell : IsiCellObject);
  end;
  {$ENDREGION}

  {$REGION 'TCellMenuItem - helper object for menu item with cell content'}
   TCellMenuItem = class(TMenuItem)
     Cell : IsiCellObject;
   end;
  {$ENDREGION}

  {$REGION 'TsiViewer1 - skill interface cell'}
  {$ENDREGION}

  {$REGION 'TcoViewer1 - cell object with skill'}
  [RegisterCellType('Test viewer','{FB67FD65-81AC-4901-96BC-899B4866E6B8}')]
  TcoViewer1 = class(TCellObject, IsiViewer1)
  strict protected
    [NewCell( TcoInteger, 'Left', 197)]
    fsiLeft : IsiInteger;

    [NewCell( TcoInteger, 'Top', 111)]
    fsiTop : IsiInteger;

    [NewCell( TcoString, 'Caption', 'My First OurPlant Viewer Anwendung')]
    fsiCaption : IsiString;

    [NewCell( TcoInteger, 'ClientHeight', 462)]
    fsiClientHeight : IsiInteger;

    [NewCell( TcoInteger, 'ClientWidth', 824)]
    fsiClientWidth : IsiInteger;

    [NewCell (TcoInteger, 'WindowState', Ord(wsNormal))]
    fsiWindowState : IsiInteger;

    fCurrentCell : IsiCellObject;
    fDuringShowCell : Boolean;

    fMainForm: TSDIAppForm;

    fSubCellMenu : TCellMenuItem;

    fRegisterMenu : TMenuItem;

  public
    /// <summary>
    ///   Construct the cell structure during after construction. This method
    ///   override the virtual method of TCellObject.
    /// </summary>
    procedure CellConstruction; override;

  strict protected
    {$REGION 'IsiViewer1 implementation'}
    procedure siStart; virtual;
    procedure siStop; virtual;

    procedure siShowCell( const aCell : IsiCellObject); virtual;

    {$ENDREGION}
  private
    procedure OnZellenClick(Sender: TObject);
    procedure OnRegisterClick(Sender: TObject);

    procedure OnNameChange(Sender: TObject);
    procedure OnValueChange(Sender: TObject);

    procedure GenerateSubCellMenu(const aCellMenuItem : TCellMenuItem);

    {$REGION 'IsiViewer1 skill method cell procedures'}
    // OnStartViewer
    {$ENDREGION}
  end;
  {$ENDREGION}

implementation

{$REGION 'uses'}
uses
  Vcl.Graphics,
  System.UITypes,
  System.Classes,
  OurPlant.Common.CellTypeRegister;
{$ENDREGION}


{$REGION 'TsiViewer1 implementation'}
{procedure TsiViewer1.CellConstruction;
begin

end; }
{$ENDREGION}

{$REGION 'TcoViewer1 implementation'}
procedure TcoViewer1.CellConstruction;
begin
  inherited;

  Application.CreateForm(TSDIAppForm, fMainForm);

  fMainForm.eName.OnChange := OnNameChange;
  fMainForm.eString.OnChange := OnValueChange;

end;

procedure TcoViewer1.siStart;
var
  vCell : IsiCellObject;
  i     : Integer;
  vItem : TCellMenuItem;
begin
  with fMainForm do
  begin
    Left := fsiLeft.siAsInteger;
    Top := fsiTop.siAsInteger;
    Caption := fsiCaption.siAsString;
    ClientHeight := fsiClientHeight.siAsInteger;
    ClientWidth := fsiClientWidth.siAsInteger;
    WindowState := TWindowState( fsiWindowState.siAsInteger );
  end;

  siShowCell( Root );

  fSubCellMenu := TCellMenuItem.create(fMainForm);
  fSubCellMenu.Cell := Root;
  fSubCellMenu.Caption := 'Zell-Struktur';
  fMainForm.MainMenu.Items.Add(fSubCellMenu);
  GenerateSubCellMenu(fSubCellMenu);


  fRegisterMenu := TMenuItem.create(fMainForm);
  fRegisterMenu.Caption := 'Zell Typen Register';
  fMainForm.MainMenu.Items.Add(fRegisterMenu);

  for i := 0 to RootSkill<IsiCellTypeRegister>.siSubCellCount-1 do
  begin
    vCell := RootSkill<IsiCellTypeRegister>.siSubCell[i];

    if IsValid(vCell) then
    begin
      vItem := TCellMenuItem.create(fMainForm);
      vItem.Caption := vCell.siName;
      vItem.Cell := vCell;
      vItem.OnClick := OnRegisterClick;
      fRegisterMenu.Add(vItem);
    end;
  end;

end;

procedure TcoViewer1.GenerateSubCellMenu(const aCellMenuItem : TCellMenuItem);
var
  vCell : IsiCellObject;
  i     : Integer;
  vItem : TCellMenuItem;
begin
  if not Assigned(aCellMenuItem) then
    Exit;

  if aCellMenuItem.GetCount > 0 then
    aCellMenuItem.Clear;

  if IsValid( aCellMenuItem.Cell ) then
  begin
    for i := 0 to aCellMenuItem.Cell.siSubCellCount-1 do
    begin
      vCell := aCellMenuItem.Cell.siSubCell[i];

      if IsValid(vCell) then
      begin
        vItem := TCellMenuItem.create(fMainForm);
        vItem.Caption := vCell.siName;
        vItem.Cell := vCell;
        vItem.OnClick := OnZellenClick;
        aCellMenuItem.Add(vItem);
        GenerateSubCellMenu(vItem);
      end;
    end;
  end;
end;

procedure TcoViewer1.siStop;
begin
  if Assigned(fMainForm) then
    with fMainForm do
    begin
      fsiLeft.siAsInteger := Left;
      fsiTop.siAsInteger := Top;
      fsiClientHeight.siAsInteger := ClientHeight;
      fsiClientWidth.siAsInteger := ClientWidth;
      fsiWindowState.siAsInteger := Ord( WindowState);
    end;
end;

procedure TcoViewer1.siShowCell( const aCell : IsiCellObject);
begin
  fCurrentCell := aCell;

  fDuringShowCell := True;
  if IsValid(aCell) then
  begin
    fMainForm.eName.Text := fCurrentCell.siName;
    fMainForm.lLongName.Caption := fCurrentCell.siLongName;
    fMainForm.lTypeName.Caption := fCurrentCell.siTypeName;
    fMainForm.eString.Text := fCurrentCell.siAsString;
  end
  else
  begin
    fMainForm.eName.Text := 'invalid cell';
    fMainForm.lLongName.Caption := '';
    fMainForm.lTypeName.Caption := '';
    fMainForm.eString.Text := '';
  end;
  fDuringShowCell := false;
end;


procedure TcoViewer1.OnZellenClick(Sender: TObject);
begin
  siShowCell( TCellMenuItem(Sender).Cell );
end;

procedure TcoViewer1.OnRegisterClick(Sender: TObject);
var
  vRegCell : IsiRegisterEntry1;
  vCell    : IsiCellObject;
  vItem    : TCellMenuItem;
begin
  vRegCell := CellAs<IsiRegisterEntry1>( TCellMenuItem(Sender).Cell );

  vCell := Root.siAddNewSubCell( vRegCell.siAsClass, '' );

  GenerateSubCellMenu(fSubCellMenu);

  siShowCell(vCell);
end;

procedure TcoViewer1.OnNameChange(Sender: TObject);
begin
  if not fDuringShowCell and IsValid(fCurrentCell) then
  begin
    fCurrentCell.siName := fMainForm.eName.Text;
    fMainForm.lLongName.Caption := fCurrentCell.siLongName;
    GenerateSubCellMenu(fSubCellMenu);
  end;
end;

procedure TcoViewer1.OnValueChange(Sender: TObject);
begin
  if IsValid(fCurrentCell) then
    fCurrentCell.siAsString := fMainForm.eString.Text;
end;

{$ENDREGION}

end.
