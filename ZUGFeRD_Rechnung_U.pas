unit ZUGFeRD_Rechnung_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ValEdit, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Menus, Vcl.ExtCtrls,
  WPXFacturTransaction, WPXFacturTypes, WPXFactur;

type
  TInvoiceCompanyData = class(TCompanyData)
  public
    procedure ReadFromStrings(str: TStrings);
    procedure WriteToStrings(str: TStrings);
  end;

  TInvoiceForm = class(TForm)
    pagInvoiceDatra: TPageControl;
    tabAddr: TTabSheet;
    tabOrder: TTabSheet;
    tabXML: TTabSheet;
    valSeller: TValueListEditor;
    Label1: TLabel;
    Buyer: TLabel;
    valBuyer: TValueListEditor;
    taxCombo: TComboBox;
    Label2: TLabel;
    ItemGrid: TStringGrid;
    outText: TMemo;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    LoadXML1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    btnCalculate: TButton;
    btnGenerateInvoice: TButton;
    edREName: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edREID: TEdit;
    SaveXML1: TMenuItem;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LoadXML1Click(Sender: TObject);
    procedure btnGenerateInvoiceClick(Sender: TObject);
    procedure SaveXML1Click(Sender: TObject);
    procedure btnCalculateClick(Sender: TObject);
  private
    procedure ReadItems;
  public
    WPXFactur1 : TWPXFactur;

    WPXSeller : TInvoiceCompanyData;
    WPXBuyer  : TInvoiceCompanyData;
    WPXShipTo : TInvoiceCompanyData;
    WPXPaymentData : TPaymentData;
    WPXOrderData : TOrderData;
  end;

var
  InvoiceForm: TInvoiceForm;

implementation

{$R *.dfm}

{ TInvoiceCompanyData }
procedure TInvoiceCompanyData.ReadFromStrings(str: TStrings);
begin
  Name := str.Values['Name'];
  PostcodeCode := str.Values['PostcodeCode'];
  Addres := str.Values['Addres'];
  CityName := str.Values['CityName'];
  CountryIDText := str.Values['CountryID'];
  // Optional
  DepartmentName := str.Values['DepartmentName'];
  // Required for Seller
  TAXId := str.Values['TAXId'];
  // Required for EU Sales
  VATID := str.Values['VATID'];
  // Optional: Full text, several lines  for Seller!
  ContactInfo := str.Values['ContactInfo'];
  // Optional
  ID := str.Values['ID'];
  GlobalID := str.Values['GlobalID'];
  GlobalIDScheme := str.Values['GlobalIDScheme'];
  // Optional, Reg Nr
  SpecifiedLegalOrganization := str.Values['SpecifiedLegalOrganization'];
end;

procedure TInvoiceCompanyData.WriteToStrings(str: TStrings);
begin
  str.Values['Name'] := Name;
  str.Values['PostcodeCode'] := PostcodeCode;
  str.Values['Addres'] := Addres;
  str.Values['CityName'] := CityName;
  str.Values['CountryID'] := CountryIDText;
  // Optional
  str.Values['DepartmentName'] := DepartmentName;
  // Required for Seller
  str.Values['TAXId'] := TAXId;
  // Required for EU Sales
  str.Values['VATID'] := VATID;
  // Optional: Full text, several lines  for Seller!
  str.Values['ContactInfo'] := ContactInfo;
  // Optional
  str.Values['ID'] := ID;
  str.Values['GlobalID'] := GlobalID;
  str.Values['GlobalIDScheme'] := GlobalIDScheme;
  // Optional, Reg Nr
  str.Values['SpecifiedLegalOrganization'] := SpecifiedLegalOrganization;
end;

procedure TInvoiceForm.SaveXML1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
     WPXFactur1.SaveToFile(SaveDialog1.FileName);
end;

procedure TInvoiceForm.btnCalculateClick(Sender: TObject);
begin
   WPXFactur1.VerifySummation;
   outText.Lines  := WPXFactur1.Messages;
end;

procedure TInvoiceForm.btnGenerateInvoiceClick(Sender: TObject);
var i : Integer;
begin
   WPXPaymentData.DueDateDateTime :=  Now;
   WPXPaymentData.TAXCategory := TTaxCategory(taxCombo.ItemIndex);

   WPXFactur1.StartInvoice(
         TDocumentCode.c380_Commercial_invoice,
         WPXPaymentData.DueDateDateTime,
         edREID.Text,
         edREName.Text,
         WPXSeller, WPXBuyer, nil,
         nil, // from Order
         WPXOrderData,
         nil,
         WPXPaymentData
        );

   for I := 1 to ItemGrid.RowCount-1 do
   begin
      WPXFactur1.AddSale(
         ItemGrid.Cells[1,i],
         WPXCurrencyStrToFloat( ItemGrid.Cells[2,i] ),
         WPXCurrencyStrToFloat( ItemGrid.Cells[3,i] ),
         WPXCurrencyStrToFloat( ItemGrid.Cells[5,i] ),
         WPXPaymentData.TAXCategory );
   end;

   WPXFactur1.FinalizeInvoice(true,TCurrencyCode.EUR,0,WPXPaymentData);

   outText.Lines.Assign(WPXFactur1.Messages);
end;

procedure TInvoiceForm.FormCreate(Sender: TObject);
begin
  WPXFactur1 := TWPXFactur.Create(Self);

  WPXSeller := TInvoiceCompanyData.Create;
  WPXBuyer  := TInvoiceCompanyData.Create;
  WPXShipTo := TInvoiceCompanyData.Create;
  WPXPaymentData := TPaymentData.Create;
  WPXOrderData := TOrderData.Create;
end;

procedure TInvoiceForm.FormDestroy(Sender: TObject);
begin
  WPXFactur1.Free;

  WPXSeller.Free;
  WPXBuyer.Free;
  WPXShipTo.Free;
  WPXPaymentData.Free;
  WPXOrderData.Free;
end;

procedure TInvoiceForm.LoadXML1Click(Sender: TObject);
begin
   if OpenDialog1.Execute then
   begin
     WPXFactur1.LoadFromFile(OpenDialog1.FileName);
     WPXFactur1.ReadCompanyData(WPXSeller,TReadCompanyDataMode.Seller);
     WPXFactur1.ReadCompanyData(WPXBuyer,TReadCompanyDataMode.Buyer);
     WPXFactur1.ReadCompanyData(WPXShipTo,TReadCompanyDataMode.ShipTo);
     // WPXFactur1.ReadCompanyData(xxx,TReadCompanyDataMode.Payee);
     WPXSeller.WriteToStrings(valSeller.Strings);
     WPXBuyer.WriteToStrings(valBuyer.Strings);
     ReadItems;
   end;
end;

procedure TInvoiceForm.ReadItems;
var i : Integer;
    item : TSupplyChainTradeItem;
begin
    ItemGrid.RowCount := WPXFactur1.Transaction.Items.Count;
    ItemGrid.ColCount := 7;

    ItemGrid.Cells[0,0] := 'LineID';
    ItemGrid.Cells[1,0] := 'Name';
    ItemGrid.Cells[2,0] := 'Net Charge';
    ItemGrid.Cells[3,0] := 'Quantity';
    ItemGrid.Cells[4,0] := 'TAX Category';
    ItemGrid.Cells[5,0] := 'RateApplicablePercent';
    ItemGrid.Cells[6,0] := 'LineTotalAmount';

    for i := 1 to WPXFactur1.Transaction.Items.Count do
    begin
        item := WPXFactur1.Transaction.Items[i-1];
        with item.Line do
        begin
            ItemGrid.Cells[0,i] := AssociatedDocumentLineDocument.LineID.ValueStr;
            ItemGrid.Cells[1,i] := SpecifiedTradeProduct.Name.ValueStr;
            ItemGrid.Cells[2,i] := SpecifiedLineTradeAgreement.NetPriceProductTradePrice.ChargeAmount.ValueStr;
            ItemGrid.Cells[3,i] := SpecifiedLineTradeAgreement.NetPriceProductTradePrice.BasisQuantity.ValueStr;
            if ItemGrid.Cells[3,i]='' then ItemGrid.Cells[3,i] := '1';
            ItemGrid.Cells[4,i] := SpecifiedLineTradeSettlement.ApplicableTradeTax.CategoryCode.ValueStr;
            ItemGrid.Cells[5,i] := SpecifiedLineTradeSettlement.ApplicableTradeTax.RateApplicablePercent.ValueStr;
            ItemGrid.Cells[6,i] := SpecifiedLineTradeSettlement.SpecifiedTradeSettlementLineMonetarySummation.LineTotalAmount.ValueStr;
            // ItemGrid.Cells[7,i] := SpecifiedLineTradeDelivery.BilledQuantity.ValueStr;
            // ItemGrid.Cells[8,i] := SpecifiedLineTradeSettlement.ApplicableTradeTax.TypeCode.ValueStr;

        end;
    end;
end;


end.
