# Konventionen in der MicroCell Architektur

## Verzeichnis struktur und Dateien Namesgebung



```pascal
/OurPlant
	/Common
		OurPlant.Common.OurPlantObject.pas
		OurPlant.Common.CellObject.pas
		OurPlant.Common.DiscoveryManager.pas
		OurPlant.Common.DataCell.pas
	/SKILLInterface
		OurPlant.SkillInterface.MainSystem.pas
		OurPlant.SkillInterface.DataManager.pas
		OurPlant.SkillInterface.DigitalInput.pas
		OurPlant.SkillInterface.Viewer.pas
	/CELLObject
		/System
		/Process
		/Periphery
		/Data
	/CELLMigration

		
```



## Skill Interface

### Erstellung und Verwaltung von Skill-Interfaces

Grundsätzlich gilt der Standardisierungszwang von Skill-Interfaces. Sie sind die wichtigsten Elemente der Hülle einer Microcell.

Bezeichnung