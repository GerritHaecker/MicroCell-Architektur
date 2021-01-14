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
     * The skill interface "IsiCellSocket"

     * The class "TCellSocket"

   Beschreibung:

   Der Zell-Socket ist die grundsätzliche Verbindungsstelle von Zellen Interfaces
   an andere Zellen oder Listen. Er stellt zum einem sicher, dass die Interface
   Referenzen (Felder) immer angesprochen werden können. Wenn keine Zelle verbunden
   ist, gibt der Socket Defaultwerte als Dummyersatz zurück. Desweiteren stellt
   er das rückwärtige Verbindungsglied zur Zelle. Wenn die verbundene Zelle zur
   Laufzeit gelöscht wird (aus der SubListe des Controllers) wird automatisch
   auch die Verbindung im Socket gekappt. Alle Sockets werden zu diesem Zweck in
   der verbundenen Zelle registriert. Die Verbindung und der Zugriff der Zelle
   muss daher immer über den Socket stattfinden.

   Es gilt in der Archtektur, dass Verbindungen, Verwaltung von Zellen und ihr
   Zugriff in Objekten grundsätzlich über einen Zell-Socket stattfinden.
   In temporären Variablen innerhalb von Funktionen ist es empfehlenswert.

   Der Socket wird für registrierte Zellen und Interface Feldern vom Typ
   IsiCellSocket automatisch im AfterConstruction angelegt.

   .............................................................................
   Beispiel:
     const
       NO_LIST = false;
     var
       MyIntegerCell       : IsiCellSocket;
       MyInteger           : Integer;

     MyIntegerCell := TCellSocket.Create(NO_LIST);

     MyIntegerCell.siCell := DiscoveryManager.AddNewSubCell('integer');
     MyIntegerCell.siCellAs(IsiInteger1).siInteger := 1;

     MyInteger := MyIntegerCell.siCellAs<IsiInteger1>.siInteger; // Ergebnis = 1

     DiscoveryManager.siRemoveSubCell(MyIntegerCell.siCell);
     // löscht Zelle im CDM und führt zu MyIntegerCell.siCell = nil;

     MyInteger :=siCellAs<IsiInteger1>.siInteger;  // gibt default (0) zurück

     MyIntegerCell := nil;        // Ruft auch selbstständig siCell := nil auf
   .............................................................................


-------------------------------------------------------------------------------}

unit OurPlant.Common.CellSocket;

interface

{$REGION 'uses'}
uses
  OurPlant.Common.OurPlantObject,
  OurPlant.Common.CellObject;
{$ENDREGION}

type
  {$REGION 'IsiCellSocket - Socket interface of cell interconnection'}
  IsiCellSocket = interface(IsiOurPlantObject)
    ['{5864C6A9-B926-47A1-A765-53670CA411E5}']
    function  siGetCell : IsiCellObject;
    procedure siSetCell(const aCell : IsiCellObject);
    procedure siResetCell;

    property  siCell : IsiCellObject read siGetCell write siSetCell;

    function  siBusy : Boolean;
  end;
  {$ENDREGION}

  {$REGION 'TCellSocket - Socket object for cell interconnection'}
  TCellSocket = class(TOurPlantObject, IsiCellSocket)
  strict protected
    fCell    : IsiCellObject;
    fVirtual : IsiCellObject;
  public
    procedure BeforeDestruction; override;

    function  siGetCell : IsiCellObject;
    procedure siSetCell(const aCell : IsiCellObject);
    procedure siResetCell;

    property  siCell : IsiCellObject read siGetCell write siSetCell;

    function  siBusy : Boolean;

  end;

  TSubCellSocket = class(TCellSocket);


  {$ENDREGION}

implementation

procedure TCellSocket.BeforeDestruction;
begin
  fVirtual := nil; // gebe virtual dummy frei

  // Bereinige den Socket aus einer bestehenden Verbindung zu einer Zelle
end;

function TCellSocket.siGetCell : IsiCellObject;
begin
  if Assigned(fCell) then
    Result := fCell
  else
  begin
    if not Assigned(fVirtual) then
       fVirtual := TCellObject.create('Keine Auswahl');

    Result := fVirtual;
  end;
end;

procedure TCellSocket.siSetCell(const aCell : IsiCellObject);
var
  fCellSocket : IsiCellSocket;
begin
  if aCell <> fCell then
  begin
    // Bereinige den Socket aus der alten Verbindung
    if Assigned(fCell) then
    begin
      fVirtual := nil; // zerstöre den Dummy, wenn eine reale Zelle gedockt wird

      GetInterface(IsiCellSocket,fCellSocket);

      if fCell.siIsSame(aCell) then
      begin
        // fCell.siRemoveSocket(Pointer(fCellSocket));
      end;
    end;

    fCell := aCell;

    // Registriere Socket in der neu verbundenen Zelle
    if Assigned(aCell) then
    begin
      aCell.siAddSocket(Pointer(fCellSocket));
    end;
  end;
end;

procedure TCellSocket.siResetCell;
begin
  fCell := nil;
end;

function  TCellSocket.siBusy : Boolean;
begin
  Result := Assigned(fCell);
end;

end.
