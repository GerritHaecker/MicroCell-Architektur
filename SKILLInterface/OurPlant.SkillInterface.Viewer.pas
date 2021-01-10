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
  OurPlant.Common.CellObject,
  OurPlant.Common.DataCell;
{$ENDREGION}

type
  {$REGION 'IsiViewer in Release 1'}
  IsiViewer1 = interface(IsiCellObject)
  ['{79E30E22-AE87-48BA-8F9A-F3187F50FF3F}']
    procedure siStart;
    procedure siStop;
    //procedure siStopViewer;

  end;
  {$ENDREGION}

  {$REGION 'TsiViewer1 - skill interface cell'}
//  [RegisterCellType('Viewer','{B91B7AAE-7906-48DD-9A34-5B8FD3FBCCEE}')]
//  TsiViewer1 = class(TCellObject, IsiViewer1)
//  strict protected
//  public
    /// <summary>
    ///   Construct the cell structure during after construction. This method
    ///   override the virtual method of TCellObject.
    /// </summary>
//    procedure CellConstruction; override;
//  strict protected
    {$REGION 'IsiViewer1 interface implementation'}
    {$ENDREGION}
//  end;
  {$ENDREGION}

  {$REGION 'TcoViewer1 - cell object with skill'}
  [RegisterCellType('My first viewer','{FB67FD65-81AC-4901-96BC-899B4866E6B8}')]
  [UserInterface()]

  TcoViewer1 = class(TCellObject, IsiViewer1)
  strict protected
    [NewCell( TcoInteger, 'Left', 197)]
    fsiLeft : IsiInteger;

    [NewCell( TcoInteger, 'Top', 111)]
    fsiTop : IsiInteger;

    [NewCell( TcoString, 'Caption', 'My First OurPlant Viewer Anwendung')]
    [UserInterface()]
    fsiCaption : IsiString;

    [NewCell( TcoInteger, 'ClientHeight', 462)]
    fsiClientHeight : IsiInteger;

    [NewCell( TcoInteger, 'ClientWidth', 824)]
    fsiClientWidth : IsiInteger;

    [NewCell (TcoInteger, 'WindowState', Ord(wsNormal))]
    fsiWindowState : IsiInteger;

  strict protected
    fMainForm : TForm;
    fMainMenu : TMainMenu;

    fMyFirstPanel : TPanel;
    fTimer : TTimer;

    procedure fOnTimer( Sender: TObject);
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
    {$ENDREGION}
  private
    procedure OnEndeClick(Sender: TObject);

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
end;

procedure TcoViewer1.siStart;
var
  vCell : IsiCellObject;
  i : Integer;
  vMenu : TMenuItem;
  vItem : TMenuItem;
begin
  Application.CreateForm(TForm, fMainForm);

  with fMainForm do
  begin
    Left := fsiLeft.siAsInteger;
    Top := fsiTop.siAsInteger;
    Caption := fsiCaption.siAsString;
    ClientHeight := fsiClientHeight.siAsInteger;
    ClientWidth := fsiClientWidth.siAsInteger;
    Color := clBtnFace;
    Font.Color := clNavy;
    Font.Height := -13;
    Font.Name := 'Arial';
    Font.Style := [];
    Menu := fMainMenu;
    OldCreateOrder := False;
    WindowState := TWindowState( fsiWindowState.siAsInteger );
    PixelsPerInch := 96;
    BorderStyle := bsSizeable;
  end;

  fMainMenu := TMainMenu.create(fMainForm);

  vMenu := TMenuItem.create(fMainForm);
  vMenu.Caption := 'Datei';
  fMainMenu.Items.Add(vMenu);

  vItem := TMenuItem.create(fMainForm);
  vItem.Caption := 'Ende';
  vItem.OnClick := OnEndeClick;
  vMenu.Add(vItem);

  vMenu := TMenuItem.create(fMainForm);
  vMenu.Caption := 'Zellen im Root';
  fMainMenu.Items.Add(vMenu);

  for i := 0 to Root.siSubCellCount-1 do
  begin
    vCell := Root.siSubCell[i];

    if IsValid(vCell) then
    begin
      vItem := TMenuItem.create(fMainForm);
      vItem.Caption := vCell.siName;
      vMenu.Add(vItem);
    end;
  end;

  vMenu := TMenuItem.create(fMainForm);
  vMenu.Caption := 'Zell Typen Register';
  fMainMenu.Items.Add(vMenu);

  for i := 0 to RootSkill<IsiCellTypeRegister>.siSubCellCount-1 do
  begin
    vCell := RootSkill<IsiCellTypeRegister>.siSubCell[i];

    if IsValid(vCell) then
    begin
      vItem := TMenuItem.create(fMainForm);
      vItem.Caption := vCell.siName;
      vItem.Tag := i;
      vMenu.Add(vItem);
    end;
  end;


{  fMyFirstPanel := TPanel.create(fMainForm);
  with fMyFirstPanel do
  begin
    Parent := fMainForm;
    Left := 100;
    Top := 100;
    Width := 300;
    Height := 300;
    Color := clRed;
    Caption := 'TEST';
  end;

  fTimer := TTimer.Create(fMainForm);
  with fTimer do
  begin
    Enabled := true;
    OnTimer := fOnTimer;
  end;  }

end;

procedure TcoViewer1.siStop;
begin
  with fMainForm do
  begin
    fsiLeft.siAsInteger := Left;
    fsiTop.siAsInteger := Top;
    fsiClientHeight.siAsInteger := ClientHeight;
    fsiClientWidth.siAsInteger := ClientWidth;
    fsiWindowState.siAsInteger := Ord( WindowState);
  end;

end;

procedure TcoViewer1.OnEndeClick( Sender: TObject);
begin
  fMainForm.Close;
end;

procedure TcoViewer1.fOnTimer( Sender: TObject);
begin
  fMyFirstPanel.Caption := siLongName;
end;

{$ENDREGION}

end.
