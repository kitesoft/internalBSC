﻿unit Frame.OrderEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.IB,
  FireDAC.Phys.IBDef, FireDAC.VCLUI.Wait, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls,
  Wrapper.Vcl.DBDatePicker;

type
  TFrameOrderEdit = class(TFrame)
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    GridPanel1: TGridPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label7: TLabel;
    DBEdit7: TDBEdit;
    btnCalcFreight: TButton;
    DateTimePicker1: TDateTimePicker;
    GroupBox4: TGroupBox;
    btnClose: TButton;
    DBNavigator1: TDBNavigator;
    tmrReady: TTimer;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    DateTimePicker2: TDateTimePicker;
    CheckBox3: TCheckBox;
    DateTimePicker3: TDateTimePicker;
    procedure btnCloseClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure tmrReadyTimer(Sender: TObject);
  private
    OrderID: integer;
    // {{ Переключиться на UTF-8 }} - Przełącza zapisywanie plików PAS na UTF-8
    // TODO: Usuń zalezność od FDConnection
    CurrentConnection: TFDConnection;
    isClosing: Boolean;
    OrderDateWrapper: TDBDatePickerWrapper;
    RequiredDateWrapper: TDBDatePickerWrapper;
    ShippedDateWrapper: TDBDatePickerWrapper;
  public
    { Public declarations }
    class procedure ShowFrame(AContainer: TWinControl;
      AConnection: TFDConnection; OrderID: integer);
  end;

implementation

{$R *.dfm}

procedure TFrameOrderEdit.btnCloseClick(Sender: TObject);
begin
  isClosing := True;
end;

class procedure TFrameOrderEdit.ShowFrame(AContainer: TWinControl;
  AConnection: TFDConnection; OrderID: integer);
var
  frm: TFrameOrderEdit;
begin
  frm := TFrameOrderEdit.Create(AContainer);
  frm.OrderID := OrderID;
  frm.CurrentConnection := AConnection;
  frm.AlignWithMargins := True;
  frm.Align := alClient;
  frm.Parent := AContainer;
  repeat
    Application.HandleMessage;
  until frm.isClosing or Application.Terminated;
  frm.Free;
end;

procedure TFrameOrderEdit.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  if Assigned(OrderDateWrapper) then
    OrderDateWrapper.DataSourceOnChange(Sender, Field);
  if Assigned(RequiredDateWrapper) then
    RequiredDateWrapper.DataSourceOnChange(Sender, Field);
  if Assigned(ShippedDateWrapper) then
    ShippedDateWrapper.DataSourceOnChange(Sender, Field);
end;

procedure TFrameOrderEdit.tmrReadyTimer(Sender: TObject);
var
  // TODO: Usuń zalezność od TFDQuery (powinien wystarczyć TDataSet)
  fdq1: TFDQuery;
  fdq2: TFDQuery;
begin
  tmrReady.Enabled := False;
  // --------------------------------------------------------------
  GridPanel1.AlignWithMargins := True;
  GridPanel1.Align := alTop;
  // --------------------------------------------------------------
  // Zbuduj, podepnij i otwórz query dla bierzącego zamówienia (OrderID)
  fdq1 := TFDQuery.Create(self);
  fdq1.Connection := CurrentConnection;
  fdq1.Open('select OrderID,CustomerID, EmployeeID, OrderDate, ' +
    'RequiredDate, ShippedDate, Freight from {id Orders} where ' +
    'OrderID = :OrderID', [OrderID]);
  // --------------------------------------------------------------
  // Zbuduj, podepnij i otwórz query dla listy pracowników
  fdq2 := TFDQuery.Create(self);
  fdq2.Connection := CurrentConnection;
  fdq2.Open('select EmployeeID, FirstName||'' ''||LastName||''  ' +
    ' (ID:''||EmployeeID||'')'' as EmployeeName from {id Employees} ' +
    ' order by EmployeeID');
  // --------------------------------------------------------------
  DataSource1.DataSet := fdq1;
  DataSource2.DataSet := fdq2;
  // --------------------------------------------------------------
  // Konfiguracja OrderDateWrapper: TDBDatePickerWrapper
  OrderDateWrapper := TDBDatePickerWrapper.Create(DateTimePicker1);
  OrderDateWrapper.SetDBDatePickerControls(CheckBox1, DateTimePicker1);
  OrderDateWrapper.ConnectToDataSource(DataSource1, 'OrderDate');
  RequiredDateWrapper := TDBDatePickerWrapper.Create(DateTimePicker2);
  RequiredDateWrapper.SetDBDatePickerControls(CheckBox2, DateTimePicker2);
  RequiredDateWrapper.ConnectToDataSource(DataSource1, 'RequiredDate');
  ShippedDateWrapper := TDBDatePickerWrapper.Create(DateTimePicker2);
  ShippedDateWrapper.SetDBDatePickerControls(CheckBox3, DateTimePicker3);
  ShippedDateWrapper.ConnectToDataSource(DataSource1, 'ShippedDate');
end;

end.
