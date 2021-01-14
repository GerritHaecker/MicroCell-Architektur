# Die MicroCell Architektur
## Vorwort

Wozu braucht es eine neue, eine andere Steuerungsarchitektur? Wohl stellt sich die Frage in Hinblick auf die Unmengen an Lösungen der Steuerungstechnik und der Softwarestrukturen. Und dennoch scheint es unter den Gesichtspunkten einer neuen Zeit Schranken in unserem Denken zu geben, die uns einen einfache evolutionäre Weiterentwicklung der bestehenden Basis verwehren.

"Never change a running system." Gilt sicher auch für die Entwicklung von neuen Systemen und Architekturen. Und so dürfen wir sicher davon ausgehen: Grundlos wird nichts verändert. 

Das Entwicklerteam der Häcker Automation kennt seit Jahren die Grenze der bestehenden Entwicklungsansätze. Die Hardware ist längst auf die neuen Anforderungen eingestellt. Auch das war kein ganz einfacher Weg. Modularität, Wandlungsfähigkeit und dezentrale mechatronische Systeme sind keinesfalls gängige Lösungsansätze des Maschinenbaues des späten zwanzigsten Jahrhunderts. Und dennoch ist es nach fast 25 Jahren gelungen, einen höchst modularen und austauschbaren Baukasten an unabhängigen Subsystemen aufzubauen. Der Softwareentwicklung war dieser gewaltige Schritt noch nicht gelungen. Ein organisch gewachsener Kern einer durchaus modular einstellbaren Gesamtlösung kommt immer häufiger an seine Grenzen. Überlagerte Funktionaltäten behindern und verfehlen sich mitunter. Eine Prüfbarkeit von scheinbar unendlich vielen Kombinationsmöglichkeiten der Hardwaremodule scheint chancenlos. 

Wer da glaubt, man könne die Anwendungsfälle vorhersehen und überprüfen, der weiß noch nicht, was wandlungsfähig wirklich bedeutet. Maschinen der OurPant-Plattform, die heute gebaut werden, werden nach zehn Jahren noch im Einsatz sein und Produkte produzieren, von denen wir heute noch gar nichts ahnen. In unserer schnelllebigen Technologiewelt werden sie dann Aufgaben erfüllen, von denen wir jetzt noch nicht wissen.  

## Einführung in die Architektur-Entwicklung 4.0

### [Grundlos wird nicht's verändert](Grundlos wird nichts verändert.md)

### [Auf dem Weg zur neuen Architektur](Auf dem Weg zur neuen Architektur.md)

------

# Die MicroCell unter Delphi

Die MicroCell Architektur wird erstmals in der [Delphi-Welt von Embarcadero](https://www.embarcadero.com/de/products/delphi) realisiert. Sie macht sich dabei die Interface Technologie zu nutze. 

Für die Verwendung gelten strikte [Architekturkonventionen](Architektur Konventionen.md). Sie sind wichtige Voraussetzung für eine dezentrale entwicklerunabhängige Architektur.

## TCellObject, IsiCellObject und seine Erben

Zur Umsetzung der MicroCell Architektur wird das **TCellObject** als Basisobjekt bzw. Stammzelle eingeführt. Das TCellObject implementiert das Basis-Skillinterface **IsiCellObject**. Alle Mikrozellen sind von TCellObject oder einer Ableitung abzuleiten. Somit besitzt jede Mikrozelle zukünftig die Fähigkeiten des TCellObject, indem sie das Skillinterface IsiCellObject unterstützen. Alle "ordentlichen" Skillinterface sind vom IsiCellObject oder einer Ableitung abgeleitet. Somit wird ebenfalls sichergestellt, dass alle Skillinterface immer auch die Fähigkeiten des IsiCellObject beinhalten und unterstützen. 

<img src="Illustration/TCellObject und IsiCellObject Schema.png" alt="TCellObject und IsiCellObject Schema" style="zoom:85%;" />

Kurz um: **IsiCellObject ist der kleinste Nenner der MicroCell Architektur unter Delphi**. Die Implementierung von IsiCellObject im TCellObject gewährleistet die Implementierung aller darin enthalten Methoden und Eigenschaften in allen Zellobjekten.

Auf Zellobjekte wird ausschließlich über Interface-Referenzierungen zugegriffen. Die Verwaltung der Zellen als Objekt-Instanzen ist nicht zulässig! Die Zellen werden ausschließlich unter den Konventionen der Interface-Technologie verwendet. Jede Zelle kann eine beliebige Anzahl von Skillinterface implementieren bzw. andocken.

```pascal
unit OurPlant.Common.CellObject;

uses
  OurPlant.Common.OurPlantObject;

type
  IsiCellObject = interface(IsiOurPlantObject)
    ['{D9E6C14F-B154-4753-8769-EF00978805E9}']
    function siSelf: IsiCellObject;
    function siIsSame(aCell:IsiCellObject): Boolean;
    function siIsValid : Boolean;
    ...
  end;

  [RegisterCellType('Standard cell','{09EDF8FC-2638-47F4-9332-928396A4F4B7}')]
  TCellObject = class(TOurPlantObject, IsiCellObject)
  public
    procedure AfterConstruction; override;
    procedure CellConstruction; virtual;
    procedure BeforeDestruction; override;
  strict protected
    function siSelf: IsiCellObject;
    function siIsSame(aCell:IsiCellObject): Boolean;
    function siIsValid : Boolean;
    ...
  end;
```

Die Unit [OurPlant.Common.CellObject.pas](OurPlant/Common/OurPlant.Common.CellObject.md) definiert das TCellObject und das Skillinterface IsiCellObject. Einige Details sind der Migration der Architektur in die bestehende OurPlant OS Architektur von 2020 geschuldet. So findet sich unter anderem eine Klasse TOurPlantObject mit dem Interface IsiOurPlantObject. Sie haben nur eine untergeordnete Rolle als Verbindungsschicht zwischen der "alten" Architektur und der neuen MicroCell Architektur.

Das Beispiel des Skillinterface **IsiDigitalInput1** und die universellen Adapter- und Vorlagenzellen **TsiDigitalInput1** und **TcoDigitalInput1** aus der Unit *OurPlant.SkillInterface.DigitalInput.pas* zeigt die Ableitung von IsiCellObject. Zu jedem Skillinterface gehören vorgefertigte Zellen, die die Skillinterface in andere Zellen implementieren können (später hierzu mehr). 

```pascal
unit OurPlant.SKILLInterface.DigitalInput;

uses
  OurPlant.Common.CellObject;

type
  IsiDigitalInput1 = interface(IsiCellObject)
  ['{690960A1-EF15-4C6C-9CEB-76C30181727C}']
    function siSize: Byte;
    function siBit(const aBit:Byte): Boolean;
    function siInteger: Integer;
  end;

  [RegisterCellType('Digital input adapter','{3018513D-066D-4BE4-A77C-96F61E1EF43A}')]
  TsiDigitalInput1 = class(TCellObject, IsiDigitalInput1)
  public
    procedure CellConstruction; override;
  strict protected
    function siSize: Byte;
    function siBit(const aBit:Byte): Boolean;
    function siInteger: Integer;
  end;
  
  TcoDigitalInput1 = class(TsiDigitalInput1, IsiDigitalInput1)
  public
    procedure CellConstruction; override;
  strict protected
    function siSize: Byte; virtual; abstract;
    function siBit(const aIndex: Byte): Boolean; virtual; abstract;
    function siInteger: Integer; virtual; abstract;
  strict private
    procedure OnGetSize(const aSender : IsiCellObject);
    procedure OnGetBit(const aSender : IsiCellObject);
    procedure OnGetInteger(const aSender : IsiCellObject);
  end;
  
```

Das Objekt **TsiDigitalInput1** aus dem Beispiel ist vom **TCellObject** abgeleitet und implementiert zusätzlich die Fähigkeit des Skillinterface **IsiDigitalInput1**. Über beide Pfade (Ableitung und Implementierung) wird immer auch sichergestellt, dass die Zelle auch als **IsiCellObject** angesprochen werden kann.  TsiDigitalInput1 ist der universelle Skillinterface Adapter von IsiDigitalInput1. Die Zelle realisiert vollständig das Skillinterface. Die Logik aus der Mutterzelle wird später über die OnRead und OnWrite Events der Skillmethod-Zellen angedockt. (Hierzu später mehr).  **TcoDigitalInput1** hingegen ist eine Skillinterface Zellenvorlage für Implementierungen von  IsiDigitalInput1.

## Die rekursive Zellenstruktur

Zellen sind immer Teil einer Subzellenstruktur. Hiervon gibt es nur eine gültige Ausnahme. Das ist der Discovery Manager als ROOT des Gesamtsystems. Alle anderen Zellen brauchen zur Gültigkeit in der Architektur eine übergeordnete Zelle als Controller. Jede Zelle hat von TCellObject ein dynamisches Array von Skillinterface-Referenzen als `TArray<IsiCellObject>` vererbt bekommen. Somit kann jede Zelle unbegrenzt Zellen beliebigen Typs verwalten.

<img src="Illustration/Rekursive Zellstruktur.png" alt="Rekursive Zellstruktur" style="zoom:100%;" />

IsiCellObject liefert über TCellObject bereits eine Vielzahl von Verwaltungsfunktionen zur Nutzung dieser rekursiven Subzellenstruktur mit. Wird eine neue Zelle erstmal in eine Liste eingefügt, so wird automatische die Zuordnung des Zellcontrollers vorgenommen. Zellen können aber auch in weitere Subzellen-Listen eingefügt werden. Dann werden sie jedoch nur noch als Link (fremde Zelle) in dieser Liste verwaltet. Die Architektur stellt sicher, dass jede Zelle genau nur eine Controllerzelle besitzt. Dies ist zur LongName Adressierung und zur Rekonstruktion des Systems notwendig.

Beim Hinzufügen von Zellen wird grundsätzlich zwischen dem Konstruieren oder Addieren von Zellen unterschieden. Beim Konstruieren (z.B. `siConstructNewSubCell`  oder  `siConstructSubCell` ) wird die Zelle im vorderen Listenbereich statisch eingefügt. Konstruierte Zellen werden bei der Listenbehandlung, insbesondere bei der Wiederherstellung (Restore) nicht überschrieben. Sie sind vom Zellenbauer als feste Subzellen zur Abboldung einer vorher bekannten Struktur bestimmt (zum Bespiel Datenzellen oder Skillinterface Zellen). Das Addieren (z.B. `siAddNewSubCell` oder `siAddSubCell`) hingegen ist zur Veränderung der Listen zur Laufzeit als dynamische Einträge vorgesehen. Dynamische Einträge werden beim Wiederherstellen tatsächlich auch wieder angelegt, gleich wann in wie sie entstanden sind.

## Implementierte und angedockte Skillinterface

Zur entwicklerunabhängigen Nutzung der Zellen implementiert jede Zelle vereinheitlichte Skillinterface. Die Skillinterface sind von **IsiCellObject** als Basis-Skillinterface abgeleitet. Sie repräsentiert die Fähigkeit eines Objektes eine Mikrozelle zu sein. 

Das Basis-Skillinterface IsiCellObject nimmt einen Sonderstatus in der MikroCell Architektur ein. Die im Skillinterface realisierten Methoden sind ausschließlich als Interfacefunktionen ansprechbar. Für sie existieren keine Skillmethod-Zellen. Jede Zelle kann über dieses Interface referenziert und verwaltet werden. IsiCellObject verfügt über eine Vielzahl von Grundfuntionalitäten:

- Allgemeine Zell Header Informationen (Name, Type, Klasse, Controller, etc.)
- Subzellen Verwaltung
- Verwaltung des allgememeinen Zellenwertes als TValue, als String und als JSON Object
- Verwaltung der OnRead und OnWrite Events
- Transport des Inhalts der Zelle und Subzellen als JSON Content
- und das rekursive Sichern und Wiederherstellen der Zellen und Subzellen

Skillinterface unterliegen klaren Namenskonventionen. Sie führen immer den Präfix **Isi**... voran (z.B. **Isi**CellObject oder **Isi**DigitalInput1). Sie sind in einem Skillinterface Register festgeschrieben und unterliegen einem Releasemanagement. Hierzu führen alle Skillinterface am Ende ihre Versionsnummer (z.B. IsiDigitalInput**1**). Skillinterface dürfen nur durch einen redaktionellen Freigabelauf verändert und weiterentwickelt werden. Jede Weiterentwicklung führt zu einer neuen Releasenummer. Somit sollen Inkombatibelitäten in der Verwendung durch unterschiedliche Zellen verhindert werden. 

Neben den offiziellen Skillinterface können vom Entwickler auch eigene private (nicht standardisierte) Interface implementiert werden. Diese müssen sich jedoch namentlich von den Konventionen der "offiziellen" Skillinterface (**Isi**) unterscheiden. "Private" Interface werden nicht registriert und sind somit auch nicht systemweit bzw. entwicklerübergreifend verwendbar.

Alle "offiziellen" Skillinterface sind von IsiCellObject oder einem Derivat abzuleiten. Für die "privaten" ist dies fakultativ, bietet sich aber durchaus auch an. 

Skillinterface sind entweder direkt in die Zelle zu implementieren oder als Skillinterface-Subzellen an die Hauptzelle anzudocken. Jede Zelle kann so eine beliebige Anzahl von Skillinterfaces implementieren.

<img src="Illustration/MicroCell TCellObject Schema.png" alt="MicroCell TCellObject Schema" style="zoom:75%;" />

Alle Methoden der offiziellen Skillinterface (außer IsiCellObject und Ausnahmen des Systems) müssen als Skillmethod-Subzellen vorgehalten werden. Diese Skillmethod-Zellen haben mehrere Bedeutungen. Zum Einem nehmen die Skillmethod-Zellen die OnRead und OnWrite Events der Skillmethoden auf. Diese Funktion wird benötigt, um die Skillinterface logisch und universell an die Hauptzelle andocken zu können. Des weiteren können die Methoden der Skillinterface auch über die Zellstruktur angesprochen werden. Auch die Parameter einer Skillmethod sind als Subzellen ausgeführt. Im Beispiel einer SampleCell, welche  ein Skillinterface IsiDigitalInput1 implementiert, sieht eine verwendete Subzellenstruktur wie folgt aus:

- CellA/**DigitalInput**

- CellA/DigitalInput/**siSize**

- CellA/DigitalInput/**siBit**

- CellA/DigitalInput/siBit/***aBit***

- CellA/DigitalInput/**siInteger**


Eine typische Interfaceausführung wie im Beispiel der Bitabfrage von IsiDigitalInput1: 

```pascal
TcoCellA = class(TCellObject)
private
  [NewCell( TsiDigitalInput1, 'Digital input 1' )]
  fsiDigitalInput : IsiDigitalInput1;
  function GetChannelState( const aChannel : byte) : boolean;
end;

function TcoCellA.GetChannelState( const aChannel : byte) : boolean;
begin
  Assert( isValid( fsiDigitalInput), 'Invalid cell reference in digital input of TcoCellA');
	Result := fsiDigitalInput.siBit(aChannel);
end;
```

kann auch als Zellstruktur ohne die Verwendung  von Interfacefunktionen ausgeführt werden.

```pascal
function TcoSampleCell.GetChannelState( const aChannel : byte) : boolean;
begin
  CellAs<IsiInteger>( 'OP:/CellA/Digital input 1/siBit/aBit' ).siAsInteger := aChannel;
  Result := CellAs<IsiBoolean>( 'OP:/CellA/Digital input 1/siBit' ).siAsBoolean;
end;

```

### Implementierungsformen

Skillinterface können auf mehrere verschiedene Arten in und an einer Zelle implementiert werden. Hierbei unterscheiden wir grundsätzlich,  

1. ob das Skillinterface direkt vom Zellobjekt implementiert wird, 
2. ob es durch eine angedockte Skillinterface-Zelle direkt von der Zelle implementiert wird (`property implements`) oder 
3. ob es durch eine  Skillinterface-Zelle indirekt an die Zelle nur angedockt ist.

 Für das Andocken stehen stehen üblicherweise zwei unterschiedliche Vorlagen zur Verfügung. Der universelle Skillinterface Adapter (z.B. TsiDigitalInput1) oder die echte Implementierungsvorlagen für Zellen mit Skillinterface (z.B. TcoDigitalInput1). Beide Vorlagen werden bei der Entwicklung des Skillinterface angelegt und den Entwicklern zur Verfügung gestellt. 

Die Implementierungsvorlagen können als Vorlage im Fall 1 verwendet werden um das Skillinterface direkt in der Zelle zu realisieren oder in Fällen 2 und 3 die angedockte Skillinterfacezelle die Logik des Interfaces abgesetzt (deposed) realisiert. 













------

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons Lizenzvertrag" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a>

Dieses Werk **OurPlant MicroCell Architektur** von [Häcker Automation GmbH](https://www.haecker-automation.de/) ist lizenziert unter einer <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Namensnennung - Weitergabe unter gleichen Bedingungen 4.0 International Lizenz</a>

Die Quellen dieser Arbeiten finden sich auf [Github](https://github.com/GerritHaecker/MicroCell-Architektur)
