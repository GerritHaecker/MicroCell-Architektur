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

unit OurPlant.Migration.Common.Test.KomItemTest;

interface

uses
  DUnitX.TestFramework,
  OurPlant.Migration.Common.KomItem,
  OurPlant.Common.DiscoveryManager;

type
  [TestFixture]
  TMigrationKomItemTests = class(TObject)
  strict private
    fKomItemObject    : TmoKomItem;
    fKomItemInterface : ImiKomItem1;
  const
    C_KOM_ITEM_NAME = 'KomItemSample';
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [test]
//    [Category('Develop')]
    procedure TestMigrationInterface;
    [test]
//    [Category('Develop')]
    procedure TestRGBIMigrationObject;
    [test]
//    [Category('Develop')]
    procedure TestXYZABCMigrationObject;
  end;

implementation

uses
  OurPlant.Common.CellObject,
  System.SysUtils,
  libraries.SysTypes,
  OurPlant.Migration.Common.SysTypes;

procedure TMigrationKomItemTests.Setup;
begin
  fKomItemObject := TmoKomItem.Create(C_KOM_ITEM_NAME, nil);

  Assert.IsTrue( Supports(fKomItemObject,ImiKomItem1,fKomItemInterface),
    'Migration object dosent supports ImiKomItem' );
end;

procedure TMigrationKomItemTests.TearDown;
begin
  fKomItemInterface := nil;

  fKomItemObject.Free;
end;

procedure TMigrationKomItemTests.TestMigrationInterface;
begin
  Assert.AreEqual(fKomItemInterface.siName,C_KOM_ITEM_NAME);

  Assert.AreEqual(fKomItemObject.IdName,C_KOM_ITEM_NAME);

  fKomItemObject.siName := 'Test';

  Assert.AreEqual(fKomItemObject.IdName,fKomItemInterface.siName,
    'KomItem.IdName are not equal with common IsiOurPlantObject siName');

end;

procedure TMigrationKomItemTests.TestRGBIMigrationObject;
var
  fOrgRGBI : TRGBI;
  fmiRGBI  : ImiRGBI;
begin
  fOrgRGBI.SetDefault;

  fmiRGBI := TmoRGBI.create(@fOrgRGBI);
  Assert.IsTrue(Supports(fmiRGBI,ImiRGBI),'fmoRGBI is not assigned or doesnt support ImiRGBI');

  fmiRGBI.Rot     := 1;
  fmiRGBI.Gruen   := 2;
  fmiRGBI.Blau    := 3;
  fmiRGBI.Innen   := 4;
  fmiRGBI.Extra   := 5;
  fmiRGBI.Balance := 6;
  fmiRGBI.Gain    := 7;

  Assert.IsTrue(fmiRGBI.RGBI = fOrgRGBI, 'Invalid content in org record after writing in mig interface');

  Assert.IsTrue(fmiRGBI.Rot = fOrgRGBI.Rot, 'Invalid ROT value in org record after writing in mig interface');

  Assert.IsTrue(fmiRGBI.Innen = fOrgRGBI.Innen, 'Invalid INNEN value in org record after writing in mig interface');

  Assert.IsTrue(fmiRGBI.Gain = fOrgRGBI.Gain, 'Invalid GAIN value in org record after writing in mig interface');

  fmiRGBI.SetDefault;

  Assert.IsTrue(fOrgRGBI.Rot = 0, 'Invalid ROT value in org record after set default in mig interface');

  fmiRGBI := nil;

end;

procedure TMigrationKomItemTests.TestXYZABCMigrationObject;
var
  fOrgXYZABC : Txyzabc;
  fmiXYZABC  : ImiXYZABC;
  ca, cb     : Txyzabc;
begin
  fOrgXYZABC.SetDefaultValue;

  fmiXYZABC := TmoXYZABC.create(@fOrgXYZABC);

  Assert.IsTrue(Supports(fmiXYZABC,ImiXYZABC),'fmiXYZABC is not assigned or doesnt support ImiXYZABC');

  fmiXYZABC.X := 1;
  fmiXYZABC.Y := 2;
  fmiXYZABC.Z := 3;
  fmiXYZABC.A := 4;
  fmiXYZABC.B := 5;
  fmiXYZABC.C := 6;

  Assert.AreEqual(fmiXYZABC.XYZABC,fOrgXYZABC, 'not equal org record after writing in mig interface');
  Assert.IsTrue(fmiXYZABC.X = fOrgXYZABC.X, 'Invalid X value in org record after writing in mig interface');
  Assert.IsTrue(fmiXYZABC.Y = fOrgXYZABC.Y, 'Invalid Y value in org record after writing in mig interface');
  Assert.IsTrue(fmiXYZABC.Z = fOrgXYZABC.Z, 'Invalid Z value in org record after writing in mig interface');
  Assert.IsTrue(fmiXYZABC.A = fOrgXYZABC.A, 'Invalid A value in org record after writing in mig interface');
  Assert.IsTrue(fmiXYZABC.B = fOrgXYZABC.B, 'Invalid B value in org record after writing in mig interface');
  Assert.IsTrue(fmiXYZABC.C = fOrgXYZABC.C, 'Invalid C value in org record after writing in mig interface');

  // Assert.AreEqual does not work for records, so manual test...
  ca := fmiXYZABC.Negativ;
  cb := fOrgXYZABC.Negativ;
  if ca = cb then
  begin
    Assert.IsTrue(true, 'Negativ are not equal to org record');
  end else
  begin
    Assert.IsTrue(false, 'Negativ are not equal to org record');
  end;
  Assert.AreEqual(fmiXYZABC.GetXyzOnly,fOrgXYZABC.GetXyzOnly, 'GetXYZOnly are not equal to org record');
  Assert.AreEqual(fmiXYZABC.GetAbcOnly,fOrgXYZABC.GetAbcOnly, 'GetAbcOnly are not equal to org record');
  Assert.AreEqual(fmiXYZABC.GetXyzaOnly,fOrgXYZABC.GetXyzaOnly, 'GetXYZAOnly are not equal to org record');
  Assert.AreEqual(fmiXYZABC.InvertY,fOrgXYZABC.InvertY, 'InvertY are not equal to org record');
  Assert.AreEqual(fmiXYZABC.AddZ(99),fOrgXYZABC.AddZ(99), 'AddZ are not equal to org record');
  Assert.AreEqual(fmiXYZABC.RotateAAxis(10),fOrgXYZABC.RotateAAxis(10),'RotateAAxis are not equal to org record');
  Assert.AreEqual(fmiXYZABC.VectorLength,fOrgXYZABC.VectorLength, 'VectorLength are not equal to org record');
  Assert.AreEqual(fmiXYZABC.XYvectorLength,fOrgXYZABC.XYvectorLength, 'xyVectorLength are not equal to org record');
  Assert.AreEqual(fmiXYZABC.GetXYAngle,fOrgXYZABC.GetXYAngle, 'GetXYAngle are not equal to org record');
  Assert.AreEqual(fmiXYZABC.AbsoluteValue,fOrgXYZABC.AbsoluteValue, 'AbsoluteValue are not equal to org record');
  Assert.AreEqual(fmiXYZABC.ToString,fOrgXYZABC.ToString, 'ToString are not equal to org record');

  fmiXYZABC.SetDefaultValue;

  Assert.IsTrue(fmiXYZABC.IsZero,' isZero is not true after default set of interface ref');

  fmiXYZABC := nil;
end;



end.
