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
// Authors History:
//    Gerrit H�cker (2020)
// *****************************************************************************

unit OurPlant.Samples.CellObjectSample1;

{-------------------------------------------------------------------------------
Die Unit OurPlant.Samples.CellObjectSample1 beschreibt das erste Anwendungs-
beispiel f�r die Mikrozell-Architektur (kurz MCA)

Das zentrale Element der Architektur ist das Zellobjekt mit seinem generischen
Skill-Interface IsiCellObject. Alle Objekte der MCA werden von TCellObjekt ab-
geleitet. Sie ist die Stammzelle und beinhaltet alle Grundf�higkeiten.

TCellObject implementiert alle diese Methoden von IsiCellObject mit Basis-
funktionalt�ten. Die Verwaltung werden standardm��ig somit durch TCellObject
realisiert.

Zellobjekte m�ssen in der Registrierung des Discoverymanagers registriert werden.

Soweit nicht �berschrieben und anders durch Attribute gesetzt, werden Zellobjekte
von den �bergeordneten Zellen als Subzellen mitgespeichert
-------------------------------------------------------------------------------}

interface

uses
  OurPlant.Common.CellObject,
  System.Rtti,
  {$IF CompilerVersion >= 28.0}System.Json,{$ENDIF}
  Data.DBXJSON;
type

{-------------------------------------------------------------------------------
Klassen, die von TCellObject abgeleitet sind, unterst�tzen immer mindestens
IsiCellObject. Sie ist das Basisinterface der MCA. Alle Zellen sind �ber dieses
Interface ansprechbar und Instanzen werden in der Regel auch als dieses verwaltet.
Alle SkillInterface der Architektur werden von diesem Basis-Interface abgeleitet.
IsiCellObject beinhaltet alle grunds�tzlich notwendgen Methoden eines
Objektes.

ACHTUNG:
Skill-Interface mit dem Pr�fix "si" sind �ffentlich und standardiert. Sie d�rfen
nur im Rahmen der Architektur Entwicklung und nach redaktioneller Freigabe im
System verwendet werden. Eigene zus�tzliche Interface k�nnen frei in die Objekte
eingebunden werden. Sie d�rfen jedoch nur innerhalb einer Aufgabe / L�sung ver-
wendet werden. Sie tragen nicht den Pr�fix (si)
-------------------------------------------------------------------------------}

  IsiStandardInterfaceSample = interface(IsiCellObject)
    ['{1616C5ED-7C5F-4EFA-A3D1-EE0778F64D5F}']
    function siStandardInterfaceSample : string;
  end;

{-------------------------------------------------------------------------------
Alle Zellobjekte werden von TCellObject oder einer Ableitung davon abgeleitet.
Somit enthalten sie alle Grundfunktionalit�ten zur Verwaltung und Nutzung.

Soll die neue Zelle neben der Basisf�higkeit (IsiCellObject) noch weitere F�hig-
keiten besitzen, kann noch ein zus�tzliches Skill-Interface angegeben werden.
Grunds�tzlich ist die Angabe von mehreren Skill-Interface NICHT zul�ssig. Werden
f�r ein Zellobjekt mehrere Skill-Interface ben�tigt, sind diese immer als
Subzellen anzulegen. Eigen definierte Interface k�nnen zus�tzlich und in der
Anzahl frei erg�nzt werden.

Um sp�ter vom System verwaltet und dynamisch eingesetzt werden zu k�nnen, m�ssen
sie registriert werden. Der Zelltype (das Objekt) wird durch seinen Typbezeichner
und durch eine eineindeutige Typ-GUID beschrieben. �ber diese beiden Bezeichner
kann ein Zelle sp�ter mit dem richtigen Typ (Klasse) reproduziert werden.
--------------------------------------------------------------------------------}

  /// <summary>
  ///   <para>
  ///     Beschreibt das erste Anwenungsbeispiel. TcoCellSample1 ist direkt
  ///     von TCellObject abgeleitet. Erg�nzend zum Basis-Skill-Interface
  ///     IsiCellObject unterst�tzt das Beispiel das Skill-Interface
  ///     IsiStandardInterfaceSample an. <br />
  ///   </para>
  ///   <para>
  ///     In der Typregistrierung wird die Zelle unter dem Typnamen <b>
  ///     CellSample1</b> und unter der Typ-GUID <b>
  ///     4B8EF4B7-490B-47E0-B3C8-075F4822E768</b> gef�hrt. <br />
  ///   </para>
  /// </summary>
  /// <remarks>
  ///   Alle Zellobjekte werden von TCellObject oder einer Ableitung davon
  ///   abgeleitet. Somit enthalten sie alle Grundfunktionalit�ten zur
  ///   Verwaltung und Nutzung. Soll die neue Zelle neben der Basisf�higkeit
  ///   (IsiCellObject) noch weitere F�higkeiten besitzen, kann noch ein
  ///   zus�tzliches Skill-Interface angegeben werden. Grunds�tzlich ist die
  ///   Angabe von mehreren Skill-Interface NICHT zul�ssig. Werden f�r ein
  ///   Zellobjekt mehrere Skill-Interface ben�tigt, sind diese immer als
  ///   Subzellen anzulegen. Eigen definierte Interface k�nnen zus�tzlich und
  ///   in der Anzahl frei erg�nzt werden. <br /><br />Um sp�ter vom System
  ///   verwaltet und dynamisch eingesetzt werden zu k�nnen, m�ssen sie
  ///   registriert werden. Der Zelltype (das Objekt) wird durch seinen
  ///   Typbezeichner und durch eine eineindeutige Typ-GUID beschrieben. �ber
  ///   diese beiden Bezeichner <br />kann ein Zelle sp�ter mit dem richtigen
  ///   Typ (Klasse) reproduziert werden.
  /// </remarks>
  /// <example>
  ///   <code lang="Delphi">var
  ///   vCell: IsiCellObject;
  ///   vFSI: IsiStandardInterfaceSample;
  /// begin
  ///   vCell:= DiscoveryManager.siTypeRegister.siBuildCellObject('My first cell');
  ///
  ///   if Supports(vCell, IsiStandardInterfaceSample, vFSI) then
  ///     Result:= vFSI.siInterfaceMethod
  ///   else
  ///     Result:='';
  ///
  ///   vCell:= nil;
  /// end;</code>
  /// </example>
  [RegisterCellType('cell sample1','{4B8EF4B7-490B-47E0-B3C8-075F4822E768}')]
  TcoCellSample1 = class(TCellObject, IsiStandardInterfaceSample)
  public
    function siStandardInterfaceSample : string;

    {---------------------------------------------------------------------------
    Jede Zelle kann aus TCellObject einen Wert (Value) und eine Liste von Sub-
    zellen enthalten. Ableitungen k�nnen dies erg�nzen.
    Der Wert der Stammzelle TCellObject ist ein generischer Rtti Value (TValue)
    und kann jegliche Type annehmen.
    Er wird �ber die Set und Get von siAsValue genutzt. Soll ein anderer Wert
    oder ein anderes Ergebnis als allgemeiner siValue verarbeitet werden, m�ssen
    die Funktion siGetValue und siSetValue �berschrieben werden. Somit kann auch
    auf diese Ergebnisse �ber das Basisinterface IsiCellObject zugegriffen werden.
    Der Wert des Zellobjektes kann von IsiCellObject auch als String (siAsString)
    und als JSON Value (siAsJSON) behandelt werden. Die Get Funktionen dieser
    beiden anderen Typen werden aus siAsValue gebildet. Will man die Behandlung
    dieser Methoden effektiver machen, kann man auch diese Methoden des
    TCellObject �berschreiben.
    ---------------------------------------------------------------------------}

    {Die Funktion "siGetAsValue" gibt den Inhalt der Zelle als TValue aus. Im
    Beispiel wird die generische Methode des TCellObject �berschrieben und
    durch das Ergebnis von siInterfaceMethod (als string) ersetzt}
    /// <summary>
    ///   The <b>siGetAsValue</b> function get the content of the cell as a <b>
    ///   TValue</b>. In the example, the generic method of the <b>TCellObject</b>
    ///    is overwritten and replaced by the result of <b>siInterfaceMethod</b>
    ///    (as string). <br />
    /// </summary>
    function siGetValue : TValue; overload; override;

    {Die Funktion "siGetString" gibt den Inhalt der Zelle als String aus. Im
    Beispiel wird die generische Methode des TCellObject �berschrieben und
    durch das Ergebnis von siInterfaceMethod (als string) ersetzt. Das
    gleiche Ergbnis wird auch durch die Grundmethode von TCellObject entstehen.
    Es wird jedoch effizienter, wenn man die Antwort nicht aus der generischen
    Methode siAsValue erst bilden muss.}
    /// <summary>
    ///   The "siGetString" function get the content of the cell as a string.
    ///   In the example, the generic method of the TCellObject is overwritten
    ///   and replaced by the result of siInterfaceMethod (as a string). The
    ///   same result will result from the basic method of TCellObject.
    ///   However, it becomes more efficient if you don't have to build the
    ///   answer from the generic siAsValue method first.
    /// </summary>
    function siGetAsString : string; override;

    {Die Funktion "siGetJSON" gibt den Inhalt der Zelle als JSON Value aus.
    Im Beispiel wird die generische Methode des TCellObject �berschrieben und
    durch das Ergebnis von siInterfaceMethod ersetzt. Das gleiche Ergbnis
    wird auch durch die Grundmethode von TCellObject entstehen.
    Es wird jedoch effizienter, wenn man die Antwort nicht aus der generischen
    Methode siAsValue erst bilden muss.}
    /// <summary>
    ///   The "siGetJSON" function get the content of the cell as a JSON
    ///   value. In the example, the generic method of the TCellObject is
    ///   overwritten and replaced by the result of siInterfaceMethod. The same
    ///   result will result from the basic method of TCellObject. However, it
    ///   becomes more efficient if you don't have to build the answer from the
    ///   generic siAsValue method first.
    /// </summary>
    function siGetAsJSON : TJSONValue; override;

  end;

  function MyFirstCellAndTheDiscoveryManager: string;

  function RegisterBuilderAndCommunicationWithMyFirstCell: string;

implementation

uses
  OurPlant.Common.DiscoveryManager,
  OurPlant.Common.CellTypeRegister,
  OurPlant.Common.TypesAndConst,
  System.SysUtils;


// Implementierung von TcoMyFirstCellObject ------------------------------------

// im neuen Zellobjekt m�ssen alle Methoden des extra zugewiesenen Interface
// implemntiert werden.
function TcoCellSample1.siStandardInterfaceSample : string;
begin
  Result:='Hello world!'
end;

function TcoCellSample1.siGetValue : TValue;
begin
  Result:= TValue.From<string>(siStandardInterfaceSample);
end;

function TcoCellSample1.siGetAsString : string;
begin
  Result:= siStandardInterfaceSample;
end;

function TcoCellSample1.siGetAsJSON : TJSONValue;
begin
  Result:= TJSONString.Create(JSONStrDecode(siStandardInterfaceSample));
end;

// Einige Anwendungsbeispiele f�r die Nutzung der Zellen -----------------------
function MyFirstCellAndTheDiscoveryManager : string;
var
  vCell: IsiCellObject;
begin
{ Der DiscoveryManager ist die Wurzel der gesamten Zellstruktur. Die globale
  Die globale Variable stellt f�r alle einen Zugriffe auf ihn zur Verf�gung

  Mit siAddSubCell lassen sich neue Zellen unterhalb einbinden. Der Aufruf von
  Create mit einem Namen (string) erzeugt eine Zelle mit dem Namen (siName) }
  vCell := TCellObject.Root.siAddSubCell( TcoCellSample1.create('MyFirstCell') );

  // siSubCell findet in der Zellstruktur des DiscoveryManagers die Zelle wieder
  vCell:= TCellObject.Root.siFindCell('OP:/MyFirstCell');

  // nach Zuweisung und Suche muss immer die Belegung gepr�ft werden
  if Assigned(vCell) then
    Result := vCell.siName;

end;

function RegisterBuilderAndCommunicationWithMyFirstCell: string;
var
  vCell: IsiCellObject;
  vFSI: IsiStandardInterfaceSample;
begin
  // die Type-Register-Zelle des Discovery Managers bildet Zellen aus Typ-Namen
  // oder Typ-Guid. Vorraussetzung daf�r ist die Registrierung der Zelle.
  // Als R�ckgabe wird die Referenz auf IsiCellObject verwendet.
  vCell:= TCellObject.RootSkill<IsiCellTypeRegister>.siBuildNewCell('MyFirstCell');

  // um die Zell-Referenz als IsiFirstStandardInterface Interface ansprechen zu
  // k�nnen, kann sie �ber Supports abgefragt werden. vFSI zeigt dann auf das
  // gew�nschte Interface und l��t spezifische Methodenaufrufe zu.
  if Supports(vCell, IsiStandardInterfaceSample, vFSI) then
    Result:= vFSI.siStandardInterfaceSample
  else
    Result:='';
end;

end.
