program OurPlant.Sample;

uses
  Forms,
  OurPlant.Samples.SDIMain in 'OurPlant.Samples.SDIMain.PAS' {SDIAppForm},
  ABOUT in 'ABOUT.PAS' {AboutBox};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TSDIAppForm, SDIAppForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
 
