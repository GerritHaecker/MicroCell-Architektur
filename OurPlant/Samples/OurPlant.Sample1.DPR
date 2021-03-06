program OurPlant.Sample1;

uses
  Forms,
  OurPlant.Sample1.Main in 'OurPlant.Sample1.Main.PAS' {SDIAppForm},
  OurPlant.Common.CellObject in '..\Common\OurPlant.Common.CellObject.pas',
  OurPlant.Common.CellTypeRegister in '..\Common\OurPlant.Common.CellTypeRegister.pas',
  OurPlant.Common.DataCell in '..\Common\OurPlant.Common.DataCell.pas',
  OurPlant.Common.DataManager in '..\Common\OurPlant.Common.DataManager.pas',
  OurPlant.Common.DiscoveryManager in '..\Common\OurPlant.Common.DiscoveryManager.pas',
  OurPlant.Common.LinkPlaceHolder in '..\Common\OurPlant.Common.LinkPlaceHolder.pas',
  OurPlant.Common.OurPlantObject in '..\Common\OurPlant.Common.OurPlantObject.pas',
  OurPlant.Common.TypesAndConst in '..\Common\OurPlant.Common.TypesAndConst.pas',
  OurPlant.SkillInterface.DataManager in '..\SKILLInterface\OurPlant.SkillInterface.DataManager.pas',
  OurPlant.SkillInterface.Viewer in '..\SKILLInterface\OurPlant.SkillInterface.Viewer.pas',
  OurPlant.Sample.CellSample1 in 'OurPlant.Sample.CellSample1.pas',
  OurPlant.Samples.SkillInterface in 'OurPlant.Samples.SkillInterface.pas';

{$R *.RES}

begin
  Application.Initialize;

  TCellObject.RootSkill<IsiDiscoveryManager>.siRestoreSystem('Sample No1');

  if not TCellObject.TryRootSkill<IsiViewer1> then
  begin
    TCellObject.Root.siAddNewSubCell(TcoViewer1,'Standard SDI Viewer');
  end;

  TCellObject.RootSkill<IsiViewer1>.siStart;

  Application.Run;

  TCellObject.RootSkill<IsiViewer1>.siStop;

  TCellObject.RootSkill<IsiDiscoveryManager>.siSaveSystem('Sample No1');
end.
 
