unit OurPlant.SkillInterface.DataManager;

interface

{$REGION 'uses'}
uses
  OurPlant.Common.CellObject,
  OurPlant.Common.DataCell;
{$ENDREGION}

type

  {$REGION 'IsiDataManager1 - Data manager skill interface Release 1'}
  /// <summary>
  ///  Skill interface for data manager in Release 1
  /// </summary>
  IsiDataManager1 = interface(IsiCellObject)
    ['{EE9289A8-B79C-4DB7-AEE4-197244A4EC27}']
    procedure siSaveCellJSONContent(const aCell: IsiCellObject; const aName: string = '');
    procedure siRestoreCellJSONContent(const aCell: IsiCellObject; const aName: string = '');
  end;
  {$ENDREGION}

  {$REGION 'TsiDataManager1 - Universal adapter cell for IsiDataManager1 '}
  [RegisterCellType( 'Data manager universal skill adapter', '{7C72B9E0-A077-4216-9DEB-7DB2CEA62C3A}' )]
  TsiDataManager1 = class(TCellObject, IsiDataManager1)
  strict protected
    [IndependentCell( TCellObject, 'siSaveCellJSONContent')]
    fsiSaveCellJSONContent : IsiCellObject;

    [IndependentCell( TcoCellReference, 'siSaveCellJSONContent/aCell' )]
    fsiSaveCellJSONContentACell : IsiCellReference;

    [IndependentCell( TcoString, 'siSaveCellJSONContent/aName')]
    fsiSaveCellJSONContentAName : IsiString;

    [IndependentCell( TCellObject, 'siRestoreCellJSONContent')]
    fsiRestoreCellJSONContent : IsiCellObject;

    [IndependentCell( TcoCellReference, 'siRestoreCellJSONContent/aCell')]
    fsiRestoreCellJSONContentACell : IsiCellReference;

    [IndependentCell( TcoString, 'siRestoreCellJSONContent/aName')]
    fsiRestoreCellJSONContentAName : IsiString;
  public
    /// <summary>
    ///  construction of cell content & structures and set defaults
    ///  Are called at the end of AfterConstruction of TCellobject. Derivate's
    ///  overrides this method to define and construct the cell structure and
    ///  settings.
    /// </summary>
    procedure CellConstruction; override;

  strict protected // implementation IsiDataManager1
    procedure siSaveCellJSONContent(const aCell: IsiCellObject; const aName: string = '');
    procedure siRestoreCellJSONContent(const aCell: IsiCellObject; const aName: string = '');

  end;
  {$ENDREGION}

  {$REGION 'TcoDataManager1 - Template cell for IsiDataManager1 support'}
  TcoDataManager1 = class(TsiDataManager1, IsiDataManager1)
  public
    /// <summary>
    ///  construction of cell content & structures and set defaults
    ///  Are called at the end of AfterConstruction of TCellobject. Derivate's
    ///  overrides this method to define and construct the cell structure and
    ///  settings.
    /// </summary>
    procedure CellConstruction; override;

  strict protected // implementation IsiDataManager1
    procedure siSaveCellJSONContent(const aCell: IsiCellObject; const aName: string = ''); virtual; abstract;
    procedure siRestoreCellJSONContent(const aCell: IsiCellObject; const aName: string = ''); virtual; abstract;

  private
    procedure OnSaveCellJSONContent( const aSender : IsiCellObject);
    procedure OnRestoreCellJSONContent( const aSender : IsiCellObject);
  end;
  {$ENDREGION}

implementation

{$REGION 'TsiDataManager1 implementation - Universal IsiDataManager1 adapter cell'}
procedure TsiDataManager1.CellConstruction;
begin
  inherited;

  // build skill method cells siSaveCellJSONContent
  //fsiSaveCellJSONContent := ConstructNewCell('siSaveCellJSONContent');
  //fsiSaveCellJSONContentACell := ConstructNewCellAs<IsiCellReference>(TcoCellReference,'siSaveCellJSONContent/aCell');
  //fsiSaveCellJSONContentAName := ConstructNewCellAs<IsiString>(TcoString,'siSaveCellJSONContent/aName');

  // build skill method cells siRestoreCellJSONContent
  //fsiRestoreCellJSONContent := ConstructNewCell('siRestoreCellJSONContent');
  //fsiRestoreCellJSONContentACell := ConstructNewCellAs<IsiCellReference>(TcoCellReference,'siRestoreCellJSONContent/aCell');
  //fsiRestoreCellJSONContentAName := ConstructNewCellAs<IsiString>(TcoString,'siRestoreCellJSONContent/aName');
end;

procedure TsiDataManager1.siSaveCellJSONContent(const aCell: IsiCellObject; const aName: string = '');
begin
  fsiSaveCellJSONContentACell.siAsCell := aCell;
  fsiSaveCellJSONContentAName.siAsString := aName;
  fsiSaveCellJSONContent.siCall;
end;

procedure TsiDataManager1.siRestoreCellJSONContent(const aCell: IsiCellObject; const aName: string = '');
begin
  fsiRestoreCellJSONContentACell.siAsCell := aCell;
  fsiRestoreCellJSONContentAName.siAsString := aName;
  fsiRestoreCellJSONContent.siCall;
end;
{$ENDREGION}

{$REGION 'TcoDataManager1 implementation - Template cell for IsiDataManager1 support'}
procedure TcoDataManager1.CellConstruction;
begin
  inherited;

  // Zuweisung der read event proceduren an die skill method cells
  fsiSaveCellJSONContent.siOnRead := OnSaveCellJSONContent;
  fsiRestoreCellJSONContent.siOnRead := OnRestoreCellJSONContent;
end;

procedure TcoDataManager1.OnSaveCellJSONContent( const aSender : IsiCellObject);
begin
  siSaveCellJSONContent(
   fsiSaveCellJSONContentACell.siAsCell, fsiSaveCellJSONContentAName.siAsString);
end;

procedure TcoDataManager1.OnRestoreCellJSONContent( const aSender : IsiCellObject);
begin
  siRestoreCellJSONContent(
   fsiRestoreCellJSONContentACell.siAsCell, fsiRestoreCellJSONContentAName.siAsString);
end;

{$ENDREGION}

end.
