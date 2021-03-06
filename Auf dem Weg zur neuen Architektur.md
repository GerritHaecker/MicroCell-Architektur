# Auf dem Weg zur neuen Architektur

## Ziel dieser Architektur Entwicklung

+ Wandlungsfähiges und flexibles Steuerungssystem
+ Dezentral, Anbieter unabhängig, verteilte Ressourcen
+ Modular und modifizierbar, skalierbar
+ Entwickler unabhängig
+ Offen dezentral entwickelt und dennoch hohe Stabilität und Qualität

Die MicroCell Architektur ist eine offene, unabhängige dezentrale Systemarchitektur. Sie ist entwickelt, um unbegrenzt und unabhängig Entwickler für eine gemeinsame Lösung zu vereinen. 

Sie hat den Anspruch ganzheitlich auf die gesamte Herausforderung der Automatisierung zu wirken.

## RAMI 4.0 zeigt die Dimensionen und das Ausmaß

Das [Referentarchitektur-Modell Industrie 4.0](https://de.wikipedia.org/wiki/Referenzarchitekturmodell_Industrie_4.0) (kurz  RAMI 4.0) stellt als dreidimensionales Schichtenmodell eine grundlegende Architektur für Industrie 4.0 zur Verfügung. Es zeigt sehr anschaulich, dass sich die Architektur von Industrie 4.0 Systemen tatsächlich nicht nur über Hierarchien, Schichten und Gegenstände hinweg bezieht, sondern auch den zeitlichen Verlauf als Lebenszyklen oder Wertstrom mit einbezieht.

<img src="Illustration/RAMI4.0.png" alt="RAMI4.0" style="zoom:67%;" />

Mit RAMI 4.0 wurde ein branchenübergreifendes Modell geschaffen, das als Diskussionsgrundlage dient und ein gemeinsames Verständnis für Standrads, Normen und praktische Fallstudien schafft. (Quelle Wikipedia)

## Die Hierarchie der Automatisierungspyramide

Aus der vorerst abgeleiteten Automatisierungspyramide ist der eigentliche Umfang einer Architekturanforderung bereits ganz gut abzulesen. Die Betrachtung bezieht tatsächlich alle Schichten und Systemebenen mit ein. Bislang zeichnet sich jede Schicht nicht nur über seine eigene Spezifikation und Herausforderung ab. Vielmehr wirken auch in allen Ebenen völlig unterschiedliche Architekturen und Interaktionsansätzen.

<img src="Illustration/Automatisierungspyramide.png" alt="Automatisierungspyramide" style="zoom:67%;" />

Es fällt deutlich auf, dass es sich in der gesamten Automatisierungspyramide im wesentlich um die grundsätzlichen systemtheoretischen Ansätze handelt. Interessanterweise werden sie in der konventionellen "analogen" Welt von völlig unterschiedlichen Anbietern besetzt. Diese haben über Jahre hinweg Architekturen und Geschäftsmodelle aufeinander abgestimmt. Sie trennen sich somit nicht nur von ihren anderen Marktteilnehmern, sondern auch von den darüber oder darunterliegenden Schichten ab.

## Ein kurzer Blick auf Systemtheorie und andere Modelle

Eine neue und dezentrale Architektur kann und muss sich über diese ehr kommerziellen Schranken hinweg setzen. Sie darf die gesamte Automatisierungsaufgabe gesamtheitlich, interdisziplinär und Systemübergreifend betrachten.  

> Das Ganze ist mehr als die Summe seiner Teile. *(Aristoteles)*

In der Kombination der Fähigkeiten einzelner Anbieter und deren Teilsysteme ergeben sich zwangläufig Skaleneffekte und Lösungen, die einzelne System durch diskretes koppeln und adaptieren nicht erreichen können.  

<img src="Illustration/Systemaufbau einfach.png" alt="Systemaufbau einfach" style="zoom:67%;" />

Der Systemtheoretische Ansatz zeigt uns die Stellung der Elemente in seinen Hierarchien. Er kann jedoch nicht die Vernetzung und Beziehungen seiner Teilnehmer deutlich machen.

Streift man so durch die Welt der Darstellungsmodelle so fallen eine einige schlüssige Konzepte in Auge. Eines der wohl bekanntesten in der Softwareszene dürfte immer noch das ERM (Entity-Relationchip-Modell) zur Darstellung von Datenmodellen sein.

Lehnen wir uns an diese Form der Abbildung von Beziehung zwischen Systemen kommen wir einem möglichen architektonischen Ansatz schon etwas näher. Stellt sich nur noch die Frage, was als Entität abstrakt und generisch genug ist, um ein ganzheitliches und vollständiges digitales Abbild einer Automatisierungswelt zu liefern.

## Alles eine Frage von Fähigkeiten

Gemeinschaftliche Synergien eines Systems durch das Zusammenfügen unterschiedlicher Fähigkeiten. Betrachtet man den Begriff der Fähigkeiten (Skill) hinsichtlich eines systematischen Ansatzes näher, so stößt man auf die Tatsache, dass ein System hervorragend durch seine Fähigkeiten beschrieben werden kann. Der Nutzer  eines Systems ist auch ausschließlich von außen gesehen an diesen Fähigkeiten interessiert. Es ist also quasi die nutzerorientierte Beschreibung eines Systems. Bringe ich Subsysteme mit ihren Fähigkeiten auf die richtige Weise zusammen, entsteht eine neue Fähigkeit die ein übergeordnetes oder benachbartes System nützlich finden könnte. Arbeitsteilung durch Synergien unterschiedlicher Fähigkeiten - wie im wahren Leben. Und selbst eine Fähigkeit zu besitzen, ist schon eine Fähigkeit. Einen Integer zu repräsentieren, ist ebenso eine Fähigkeit, wie in einem Kamerabild ein Objekt zu finden, den Hauptschalter abzufragen oder selbst das Gesamtsystem einer Produktionsanlage zu sein. Man ahnt schon, Fähigkeiten wohin das Auge reicht. Egal wie tief man eintaucht, immer kommen neue Fähigkeiten zum Vorschein. Gerade so, wie beim Apfelmännchen.

<img src="Illustration/Skillanordnung physisch.png" alt="Skillanordnung physisch" style="zoom:67%;" />

Physisch angeordnet macht es gar keinen Sinn, Fähigkeiten hierarchisch durch unterschiedliche Kommunikationsarten und Standards zu verbinden. All das würde völlig unnötig einschränken und dem System an anderer Stelle klassisch den Weg abschneiden. 

## Vordefinierte Interface zur Verbindung der Fähigkeiten untereinander

Spannend wird jetzt die Beziehungen zwischen den Fähigkeiten zu betrachten. Unabhängig und dezentral heißt, die Hersteller der Fähigkeiten kennen sich nicht zwangsläufig und können sich somit wenig aufeinander abstimmen. Sie sind darauf angewiesen, vereinheitlichte normierte Verbindung- und Kommunikationskanäle zu verwenden. Dies macht die Bedeutung vereinheitlichter Kommunikationsstandards deutlich. Nun sind aber Fähigkeiten so individuell wie die Systemteilnehmer selbst.  

<img src="Illustration/Skill Verbindung.png" alt="Skill Verbindung" style="zoom:67%;" />

Bei näherer Betrachtung kann man Fähigkeiten beschreiben. Diese Beschreibungen sind für Fähigkeiten, ganz gleich, wie sie letztlich realisiert sind. Fähigkeiten sind somit durch Skillinterface erklärbar. Sie können normiert und vereinheitlicht vereinbart werden. Skillinterface sind mit Eigenschaften versehen, sogenannte Skillmethod.

Fähigkeiten wirken aber nicht nur auf den unterschiedlichen Systemebenen gleichermaßen sondern entfalten sich auch in alle systemischen Betrachtungsrichtungen (360°):

- Prozess Logik
- System- und Datenstruktur
- UI (User Interaktion)
- Dokumentation
- Safty- und Security
- uns so weiter.

Systeme können offensichtlich nicht nur durch eine Fähigkeit, sondern durch beliebig viele Fähigkeiten beschrieben werden. Je nach Bedarf docken sich andere Konsumenten (andere Systemteilnehmer) nur an die für sie relevante Fähigkeiten an. Die Vernetzung der Systemteilnehmer ist somit nicht nur hierarchisch sondern räumlich. 

<img src="Illustration/HIrnzelle.png" alt="HIrnzelle" style="zoom: 67%;" />

Die Vernetzung erinnert dabei sehr stark an die neuronale Vernetzung von Zellen. Auch innert die Anordnung vereinheitlichter Skillinterface um eine individuelle Realisierung im Kern an die Struktur und den Aufbau von Zellen. 

## Die MicroCell (Mikrozelle) als Basisbaustein der neuen Systemarchitektur

Diese Parallelen in die Organismen der Natur sind eine große Triebkraft für die Namensgebung des Basisbausteins der neuen Systemarchitektur. Aber auch die Namensnähe zum Begriff des MicroServices ist nicht ungewollt. Die konsequente Kapselung von Code und Logik in dezentrale unabhängige MicroServices sind ebenso ein Grundmotiv der MicroCell. 

<img src="Illustration/MicroCell einfach.png" alt="MicroCell einfach" style="zoom:67%;" />

Dennoch geht die MicroCell einen bedeutenden Schritt weiter. Während MicroServices sich vorrangig in seiner Umsetzung nur der Dimension der Prozesslogik widmen und die anderen systemischen Dimensionen auf anderen Lösungsebenen (UI, Saefty, Dokumente) wiederfinden, bedient die MicroCell alle diese Ebenen gleichermaßen. Somit wird ein System durch das Hinzufügen einer Microzelle durch Fähigkeiten aus allen Bereichen und Betrachtungsrichtungen erweitert.

Jede MicroCell kapselt Fähigkeiten (Skills) ein Systemelements. Der Kern einer MicroCell ist dabei geschützt (IP Schutz des Entwickler Know how). Die Zelle ist nach Außen als Hülle über Interface (Skillinterface) sichtbar. Die Hülle und Interface sind standardisiert, der Kern (die Umsetzung) ist individuell. Basis einer jeden MicroCell ist eine Art Stammzelle. Sie verkörpert die Grundfähigkeit, eine MicroCell zu sein. Alle Zellen können immer über dieses Basis-Skillinterface angesprochen und verwaltet werden.

### Alle MicroCells habens's in sich

<img src="Illustration/Zellkern Schema.png" alt="Zellkern Schema" style="zoom:50%;" />

Bereits die Basiszelle und somit auch jede abgeleitete Zelle hat eine Vielzahl von Grundfähigkeiten. Jeder Kern enthält  eine dynamische Liste von Zellen zum Aufbau rekursiver Zellstrukturen und einen [RTTI-Value](https://de.wikipedia.org/wiki/Runtime_Type_Information)  (Run Time Type Information) zur Verarbeitung eines beliebigen Wertes. Dazu ist jede Zelle im Stande diesen Wert bereits als String oder als JSON Block zu liefern. Und auch die Fähigkeit, eine zugewiesene OnAction Methode bei Aufruf (Lesen oder Schreiben) aufzurufen, ist allen Zellen eigen.

## Der Systemische Aufbau einer Zellarchitektur

Eine wohl brennende Fragestellung bietet die Anordnung und Interaktion von Mikrozellen. Wir erinnern uns an den allgemeinen systemtheoretischen Ansatz und an die Automatisierungspyramide aus der RAMI 4.0 Diskussion.

Entscheidend für eine ganzheitliche Architektur scheint erstmal die Frage zu sein, wie die Mikrozellen in Kommunikation zueinander stehen. Grundsätzlich gilt hier: Alle Zellen, ganz gleich welche Fähigkeit, Komplexität und  Einsatzbereich (Level und Zeitpunkt) stehen alle Zellen auf der gleichen Kommunikationsschicht. Jede Zelle verfügt über die Fähigkeit, mit genau ein und demselben Protokoll zu kommunizieren. Hier stelle ich gerne die Überlegung zur Diskussion, dafür das allgemein im Internet verbreitete JSON Protokoll zu verwenden. Natürlich können Zellen untereinander zur Effizienzsteigerung auch andere Protokolle zum Austausch von Service- und Prozessdaten nutzen. Diese können sie dann untereinander aushandeln. Das Urprotokoll zur "einfachen" Verbindung muss jedoch für alle Zellen einheitlich sein.

<img src="Illustration/Kommunikationebenen der MicroZellen.png" alt="Kommunikationebenen der MicroZellen" style="zoom:67%;" />

### Der systemische Aufbau ist virtuell und wandelbar

Der hierarchische Ansatz als Systemaufbau ergibt sich nur virtuell in der Systemdomain. Er wird im System durch dynamische Verbindungen zwischen den Zellen beschrieben und kann somit beliebig verwandelt werden. Selbst Systemumbauten während der Laufzeit gelten als architektonisch gewollt.

<img src="Illustration/System Domain Schema.png" alt="System Domain Schema" style="zoom:100%;" />

### Der Discovery Manager ist die "Root"

Ein besondere Rolle kommt im virtuellen Systemaufbau dem Discovery Manager zu. Er ist die Wurzel (Root) und einzige wirkliche Konstante des MicroCell Systems. Jede Zelle kann ihn und seine Fähigkeiten über den Aufruf von **Root** erreichen. Jede Zelle ist über ihn erreichbar. Der Discovery Manager wird zu Beginn jeder Anwendung statisch gestartet und aufgefordert seine Struktur durch Restore zu reaktivieren. Er ist auch dafür verantwortlich, dass anschließend das System gestartet wird. Was immer das auch ist. Am Ende einer Anwendung ist es auch der Discovery Manager der konstante Teil, der das System stoppt und alle Zelle inklusive sich selbst zum Sichern seiner Struktur auffordert. Der Discovery Manager selbst ist eine Mikrozelle mit den Fähigkeiten eines Discovery Managers. Er bringt Subzellen mit Systemfunktionen als abgesetzte (deposed) Skillinterface mit. Die wichtigste zusätzliche Fähigkeit ist das Zelltypenregister. Sie verwaltet alle registrierten Zellen mit Name und ID und wird zur Speicherung und Wiederherstellung von Zellen benötigt. Auch die Platzhalterverwaltung ist eine zusätzliche Fähigkeit, die an den Discovery Manager angedockt ist. Sie verwaltet die Verlinkung von Zellen in den Listen.

### Die Viewer Zellen sind das Fenster zur Bedienerwelt

Eine weitere Sonderrolle kommt der Viewer Mikrozelle zu. Ausschließlich Viewer-Zellen bauen die Verbindung zum Bedienerinterface (UI) auf. Sie fordern von den anderen Zellen im System die UI Informationen ab und stellen sie einheitlich nach den notwendigen Nutzerreglungen dar und geben Eingaben und Nutzeraktionen an die Zellen zurück. Zellen kapseln somit die Fähigkeit der eigenen Bedienung ohne je eigenständig mit der "Außenwelt" in Verbindung treten zu müssen. Die komplexe Fähigkeit des UI eines Gesamtsystems wird somit zwischen der Design- und Rules-  Fähigkeiten der Viewer-Mikrozelle und dem User-Content (Bedieninhalt) getrennt. Am Rand noch eine wesentliche Eigenheit dieser Systematik: Jede Zelle bringt ihr UI auch zur Konfiguration selbst mit. Die Verbindung zwischen den Zellen zu beschreiben, ist Fähigkeit einer Zelle selbst und somit individuell. Noch sehr abstrakt, aber anders gesagt, dass System muss nicht länger zwangsläufig von Außen beschrieben werden.

## Die rekursive Anordnung von Mikrozellen

Mikrozellen werden in rekursiven Listen angeordnet. Da jede Zelle dynamische Subzellen aufnehmen kann, können sie beliebig in tiefe und breite angeordnet werden. Aus dem Discovery Manager hat jede Mikrozelle eine übergeordnete kontrollierende Zelle (Controller). "Freie" Zellen sind üblicherweise nicht gültig. Microzellen werden in den Listen grundsätzlich mit dem Basis-Stillinterface der "Stammzelle" abgelegt. Somit können also Zellen und Listenstrukturen mit beliebigen Fähigkeiten aufgebaut werden.

<img src="Illustration/Rekursive Zellstruktur.png" alt="Rekursive Zellstruktur" style="zoom:90%;" />  

Die oberste Zelle ist der Discovery Manager. Er wird im System als Root geführt. Von ihr aus sind über die rekursive Struktur alle Zellen erreichbar. Zellen die in das System eingefügt werden, können eine beliebig große Struktur an Subzellen mit beliebiger Tiefe mitbringen. Somit können einem System, durch hinzufügen einer einzigen Zelle ein ganzes Subsystem mit einem ganzen Komplex an Fähigkeiten und deren logischen Verknüpfung mitbringen.

## Skillinterface sind standardisiert - Informationen sind einheitlich

 Ein vorerst letzter wichtiger Bedingung zur dezentralen wandlungsfähigen Struktur ist die Art und der Aufbau von Informationen, die über die standardisierten Interface ausgetauscht werden. Es ist nicht nur entscheidend, dass die Kommunikationswege und der Aufbau der Kommunikation vereinheitlicht sind. Auch der Aufbau und der Bezug der ausgetauschten Information muss festgelegt sein. 

<img src="Illustration/Skill Interface Information mit Bezug.png" alt="Skill Interface Information mit Bezug" style="zoom:80%;" />

Bei der Umsetzung von Fähigkeiten (Skills) in Zellen, haben die Entwickler in ihrer Logik sicherzustellen, dass die vorgegebenen Informationen in den Skillinterface den realen und erwarteten Verhalten des Systems nach Außen entspricht. Hierzu zählt auch die Umsetzung geeigneter Einstellmöglichkeiten oder Kalibrierfunktionalitäten. Eine Abgleich von Informationen außerhalb ist grundsätzlich in dezentralen Systemen nicht zulässig.  

------

### [zurück -> Hauptdokument](README.md)

------

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons Lizenzvertrag" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a>

Dieses Werk **OurPlant MicroCell Architektur** von [Häcker Automation GmbH](https://www.haecker-automation.de/) ist lizenziert unter einer <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Namensnennung - Weitergabe unter gleichen Bedingungen 4.0 International Lizenz</a>

Die Quellen dieser Arbeiten finden sich auf [Github](https://github.com/GerritHaecker/MicroCell-Architektur)