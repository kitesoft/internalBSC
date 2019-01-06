unit DataModule.CenericCollection;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.StorageBin, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TDataModule1 = class(TDataModule)
    dsOrders: TFDMemTable;
    dsOrdersORDERID: TIntegerField;
    dsOrdersCUSTOMERID: TStringField;
    dsOrdersEMPLOYEEID: TIntegerField;
    dsOrdersEMPLOYEENAME: TStringField;
    dsOrdersORDERDATE: TDateField;
    dsOrdersREQUIREDDATE: TDateField;
    dsOrdersSHIPPEDDATE: TDateField;
    dsOrdersSHIPVIA: TIntegerField;
    dsOrdersFREIGHT: TBCDField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

end.
