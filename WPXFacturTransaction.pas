unit WPXFacturTransaction;
{ WPXOrder by WPCubed
  https://github.com/wpcubed/xorder
  https://www.wpcubed.com/xorder
  ---------------------------------

Copyright (C) 2024 WPCubed GmbH, developed by Julian Ziersch
  https://www.wpcubed.com/pdf/xorder/

  To embed XML into PDF files we recommend to use the product WPViewPDF Plus.
  You can download a demo at hhttps://www.wpcubed.com/pdf/products/pdf-edit/
  WPViewPDF can also be used to extract attached XML data and display a PDF.

  To create a new PDF with embedded XML data we recommend wPDF. This universal
  PDF creator is available here:  https://www.wpcubed.com/pdf/products/wpdf/

  The project WPXOrder with the X-Factur specification and is aimed at reading
  and creating XML invoice data in Delphi. It was developed utilizing
  modern compiler features like method overloading and generics. This enables
  the generation of XML data in Delphi code with the assistance of type checking.

  It is licensed under a dual-license model:

  1. **GNU General Public License, Version 3.0 or later (GPL-3.0-or-later)**:

  with the exception that it is not allowed to use the software in any component,
  open source, free or closed source. This disallows also to create a "fork".

  You can find a copy of the license at <http://www.gnu.org/licenses/gpl-3.0.html>.
  This allows you to freely use, modify, and distribute the software under
  the terms of the GPL, except components or "forks".
  (Your software must also be distributed under GNU License!)


  2. **Commercial License**: For those who prefer to use "WPXOrder" without the
  restrictions imposed by the GPL, a commercial license is available.
  Please contact WPCubed GmbH - support@wptools.de for terms and pricing.

  --------------------------------
  The code was created with the Information provided here
  https://xeinkauf.de/dokumente/

  Here you can validate the created XML / Invoice
  https://portal3.gefeg.com/invoice/page/validation

  Unless required by applicable law or agreed to in writing, software distributed
  under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES
  OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and limitations
  under the License. For inquiries or support, please contact support@wptools.de.

  For information about what information to include in the X-Factur data please
  refer to the offical information.
  Tip: You can download an spreadsheet with the possible values for the "codes".
  Note the possibility to load example files and create Delphi code automatically.
  This will help you to getyou  started.
}

{$SCOPEDENUMS ON} // Require the SCOPE

// Enable loading of XML Data
{$DEFINE ALLOWXMLREADING} // if disabled the XML Interface is not needed


interface

uses System.SysUtils, System.Rtti, System.TypInfo, System.IOUtils, System.Math,
  System.StrUtils, System.Types, System.Classes, System.Generics.Collections,
  {$IFDEF ALLOWXMLREADING}
  Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc,
  {$ENDIF}
  WPXFacturTypes,
  WPXFacturEN16931;

type
  EWPXorderXMLNotLinked = class(Exception);
  EWPXorderBadParams = class(Exception);
  TSupplyChainTradeTransaction = class;
  TWPXOrderBase = class;

  // Used by X-Factur only!
  TSupplyChainTradeItem = class(TCollectionItem)
  private
    FLine: TSupplyChainTradeLineItem;
    function getTotal : Double;
  protected
    function GetDisplayName: string; override;
    procedure SetLine(const Value: TSupplyChainTradeLineItem);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Line: TSupplyChainTradeLineItem read FLine write SetLine;
    property Total : Double read getTotal;
  end;

  TSupplyChainTradeCollection = class(TCollection)
  private
    fTransaction: TSupplyChainTradeTransaction;
    function GetItem(Index: Integer): TSupplyChainTradeItem;
    procedure SetItem(Index: Integer; Value: TSupplyChainTradeItem);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(ATransaction: TSupplyChainTradeTransaction);
    function Add: TSupplyChainTradeItem; overload;
    property Items[Index: Integer]: TSupplyChainTradeItem read GetItem write SetItem; default;
  end;

  TWPXOrderDumpMode = (
     Debug,
     XML,
     DelphiCode,
     DelphiCodeCompact
      );

  TWPXOrderCalcMode = (
        // deactivate the Handling of SpecifiedLogisticsServiceCharge
        SpecifiedLogisticsNettoMode,
        // Do not calculate the VAT on base of each line but using the total net sum
        VATAddRoundedOnLine
  );
  TWPXOrderCalcModes = set of TWPXOrderCalcMode;

  TWPXDumpXElementOption = (
    CompactCode
  );
  TDumpXElementOptions = set of TWPXDumpXElementOption;


  TSumRec = record
     netValue   : Double;
     grossValue : Double;
     VATRate    : Double;
     VATvalue   : Double;
     VATCategory : TTaxCategory;
  end;
  TSumRecList = class(TList<TSumRec>)
  public
     procedure AddToList( aVATCategory : TTaxCategory;
                     aVATRate, aNetValue, aVATvalue, aGrossValue : Double );
  end;
  // Written as SupplyChainTradeTransaction

  TSupplyChainTradeTransaction = class(TComponent)
  private
    fApplicableHeaderTradeAgreement: THeaderTradeAgreement;
    fApplicableHeaderTradeDelivery: THeaderTradeDelivery;
    fApplicableHeaderTradeSettlement: THeaderTradeSettlement;
    fMonetarySummation, fAllowanceSummation, fChargesSummation : TSumRecList;
    fCalcModes : TWPXOrderCalcModes;
    // written as IncludedSupplyChainTradeLineItem
    fItems: TSupplyChainTradeCollection;
    procedure SetItems(Value: TSupplyChainTradeCollection);
    procedure SetApplicableHeaderTradeAgreement
      (Value: THeaderTradeAgreement);
    procedure SetApplicableHeaderTradeDelivery(Value: THeaderTradeDelivery);
    procedure SetApplicableHeaderTradeSettlement
      (Value: THeaderTradeSettlement);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; virtual;
    procedure Assign(Source: TPersistent); override;
    procedure Dump( Mode : TWPXOrderDumpMode; aOrder : TWPXOrderBase; str : TStrings; level : Integer; path : string );
    procedure CalcSummation(messages : TStrings; alsoDelivery : Boolean = true);
    property  MonetarySummation : TSumRecList read fMonetarySummation;
    property  AllowanceSummation : TSumRecList read fAllowanceSummation;
    property  ChargesSummation : TSumRecList read fChargesSummation;

    { IncludedSupplyChainTradeLineItem
      ApplicableHeaderTradeAgreement
      ApplicableHeaderTradeDelivery }
    property ApplicableHeaderTradeAgreement: THeaderTradeAgreement
      read fApplicableHeaderTradeAgreement write SetApplicableHeaderTradeAgreement;
    property ApplicableHeaderTradeDelivery: THeaderTradeDelivery
      read fApplicableHeaderTradeDelivery write SetApplicableHeaderTradeDelivery;
    property ApplicableHeaderTradeSettlement: THeaderTradeSettlement
      read fApplicableHeaderTradeSettlement write SetApplicableHeaderTradeSettlement;
    property Items: TSupplyChainTradeCollection read fItems write SetItems;
  published
    property CalcModes : TWPXOrderCalcModes read fCalcModes write fCalcModes;
  end;

  TWPXOrderBase = class(TComponent)
  private
     FExchangedDocumentContext : TExchangedDocumentContext;
     FExchangedDocument : TExchangedDocument;
     FTransaction : TSupplyChainTradeTransaction;
     FDefaults : TWPXDocDefaults; // not created in "Base"
     FAsMemoryStream : TMemoryStream;
     procedure SetTranscation(Value : TSupplyChainTradeTransaction);
     procedure SetAsMemoryStream(x : TStream);
     function GetAsMemoryStream : TStream;
  protected
     {$IFDEF ALLOWXMLREADING}
     FXML : TXMLDocument;
     function  ProcessTagName(const n : String; var aName : String; var aNameSpace : String ) : TWPXElementNS;
     function  ReadElement( pNode : IXMLNode; ele : TWPXElement ) : Boolean;
     function  ReadSupplyChainTradeTransactionItem( pNode : IXMLNode; CurrTransaction : TSupplyChainTradeTransaction ) : Boolean;
     // procedure WriteXElement( pNode : IXMLNode; d : TWPXElement );
      {$ENDIF}
     procedure DumpXElement( Mode : TWPXOrderDumpMode; str : TStrings;
       d : TWPXElement; level : Integer; path : string; options : TDumpXElementOptions = [] );
  public
     constructor Create(AOwner : TComponent); override;
     destructor Destroy; override;
     procedure Clear; virtual;
     procedure LoadFromStream(Stream : TStream);
     procedure LoadFromFile(Filename : String);
     procedure SaveToStream(Stream : TStream);
     procedure SaveToFile(Filename : String; Mode : TWPXOrderDumpMode = TWPXOrderDumpMode.XML);
     // procedure WriteXML;
     // Clears data and fills from loaded XML.
     {$IFDEF ALLOWXMLREADING}
     procedure ReadXML;
     {$ENDIF}
     // saves as XML, debug or Delphicode
     procedure WriteToStrings( Mode : TWPXOrderDumpMode; str : TStrings );
     // Used during loading and writing for log data
     property Defaults : TWPXDocDefaults read FDefaults;

          //:: Creates and fills a memory stream. Do not free this!
     property AsMemoryStream : TStream read GetAsMemoryStream write SetAsMemoryStream;
  protected
     // The actual document - these are used by XFactur!
     property ExchangedDocumentContext : TExchangedDocumentContext read FExchangedDocumentContext;
     property ExchangedDocument : TExchangedDocument read FExchangedDocument;
     property Transaction : TSupplyChainTradeTransaction read FTransaction write SetTranscation;
  end;




implementation


resourcestring
  sNOXML = 'XMLSupport not linked';
  sXMLHeader = '<?xml version=' + #39 + '1.0' + #39 + ' encoding=' + #39 + 'UTF-8' + #39 + ' ?>';
  sXMLComment = '<!-- WPXOrder https://www.wpcubed.com/pdf/products/xorder/ -->';

{ TSupplyChainTradeTransaction }



procedure TSupplyChainTradeTransaction.Assign(Source: TPersistent);
begin
  if Source is TSupplyChainTradeTransaction then
  begin
      fApplicableHeaderTradeAgreement.Assign
        (TSupplyChainTradeTransaction(Source).ApplicableHeaderTradeAgreement);
      fApplicableHeaderTradeAgreement.Assign
        (TSupplyChainTradeTransaction(Source).ApplicableHeaderTradeAgreement);
      fApplicableHeaderTradeAgreement.Assign
        (TSupplyChainTradeTransaction(Source).ApplicableHeaderTradeAgreement);
      fItems.Assign(TSupplyChainTradeTransaction(Source).Items);
  end else inherited;
end;

constructor TSupplyChainTradeTransaction.Create(AOwner: TComponent);
begin
  inherited;
  fApplicableHeaderTradeAgreement := THeaderTradeAgreement.CreateAs('ApplicableHeaderTradeAgreement');
  fApplicableHeaderTradeDelivery := THeaderTradeDelivery.CreateAs('ApplicableHeaderTradeDelivery');
  fApplicableHeaderTradeSettlement := THeaderTradeSettlement.CreateAs('ApplicableHeaderTradeSettlement');
  fItems := TSupplyChainTradeCollection.Create(Self);
  fMonetarySummation  := TSumRecList.Create;
  fAllowanceSummation := TSumRecList.Create;
  fChargesSummation   := TSumRecList.Create;
end;

destructor TSupplyChainTradeTransaction.Destroy;
begin
  fApplicableHeaderTradeAgreement.Free;
  fApplicableHeaderTradeDelivery.Free;
  fApplicableHeaderTradeSettlement.Free;
  fItems.Free;
  fMonetarySummation.Free;
  fAllowanceSummation.Free;
  fChargesSummation.Free;
  inherited;
end;

procedure TSupplyChainTradeTransaction.Clear;
begin
  fApplicableHeaderTradeAgreement.Clear;
  fApplicableHeaderTradeDelivery.Clear;
  fApplicableHeaderTradeSettlement.Clear;
  fItems.Clear;
  fMonetarySummation.Clear;
  fAllowanceSummation.Clear;
  fChargesSummation.Clear;
end;

procedure TSupplyChainTradeTransaction.CalcSummation(messages : TStrings; alsoDelivery : Boolean = true);
var item : TSupplyChainTradeItem;
    i, j : Integer;
    netValue   : Double;
    grossValue : Double;
    VATRate    : Double;
    VATvalue   : Double;
    VATCategory: TTaxCategory;
    b, isCharge: Boolean;
    r : TSumRec;
begin
  fMonetarySummation.Clear;
  fAllowanceSummation.Clear;
  fChargesSummation.Clear;

  netValue := 0;
  grossValue := 0;
  VATvalue := 0;

  for I := 0 to Items.Count-1 do
  begin
      item := Items[i];
      with item.Line do
      begin
         item.Line.Anchestor.OnCreateElement := TWPXElementCreateEvent(
         procedure(nam : String) begin
            messages.Add('! Created ' + nam + ' in item ' + IntToStr(i) + ' !' );
         end);
         try
              if SpecifiedLineTradeSettlement.Has(TXLineTradeSettlement.ApplicableTradeTax) then
                   VATRate := SpecifiedLineTradeSettlement.ApplicableTradeTax.RateApplicablePercent.Value
              else VATRate := 0;

              // This line seems to works with special units, use the SpecifiedTradeSettlementLineMonetarySummation
              // We can ignore SpecifiedTradeAllowanceCharge now!
              if SpecifiedLineTradeSettlement.Has(TXLineTradeSettlement.SpecifiedTradeSettlementLineMonetarySummation) and
                 SpecifiedLineTradeSettlement.SpecifiedTradeSettlementLineMonetarySummation.Has(
                     TXTradeSettlementLineMonetarySummation.LineTotalAmount) then
                 netValue := SpecifiedLineTradeSettlement.SpecifiedTradeSettlementLineMonetarySummation.LineTotalAmount.Value
              else
              // Work with the chargeamount*BilledQuantity
              begin
                  netValue := SpecifiedLineTradeAgreement.NetPriceProductTradePrice.ChargeAmount.Value;
                  if SpecifiedLineTradeDelivery.Has(TXLineTradeDelivery.BilledQuantity) then
                       netValue := netValue * SpecifiedLineTradeDelivery.BilledQuantity.Value;

                  // There are special charges for this item
                  if SpecifiedLineTradeSettlement.Has(TXLineTradeSettlement.SpecifiedTradeAllowanceCharge) then
                  begin
                    for j := 1 to SpecifiedLineTradeSettlement.SpecifiedTradeAllowanceCharge.ListCount do
                    begin
                       if SpecifiedLineTradeSettlement.SpecifiedTradeAllowanceCharge[j].ChargeIndicator.Indicator.AsBoolean then
                            netValue := netValue + SpecifiedLineTradeSettlement.SpecifiedTradeAllowanceCharge[j].ActualAmount.Value
                       else netValue := netValue - SpecifiedLineTradeSettlement.SpecifiedTradeAllowanceCharge[j].ActualAmount.Value;
                    end;
                  end;
              end;

              VATCategory := SpecifiedLineTradeSettlement.ApplicableTradeTax.CategoryCode.value;
              VATvalue    := WPXCurrencyRound(netValue / 100 * VATRate);
              grossValue  := netValue + VATvalue;
              fMonetarySummation.AddToList( VATCategory, VATRate, NetValue, VATvalue, GrossValue  );
         finally
            item.Line.Anchestor.OnCreateElement := nil;
         end;
      end;
  end;

  // Sum up the Allowances and Charges  (SpecifiedTradeAllowanceCharge)
  with ApplicableHeaderTradeSettlement do
  if Has(TXHeaderTradeSettlement.SpecifiedTradeAllowanceCharge) then
  for I := 1 to SpecifiedTradeAllowanceCharge.ListCount do
  begin
      IsCharge    := SpecifiedTradeAllowanceCharge[i].ChargeIndicator.Indicator.AsBoolean;
      netValue    := SpecifiedTradeAllowanceCharge[i].ActualAmount.Value;
      VATRate     := SpecifiedTradeAllowanceCharge[i].CategoryTradeTax.RateApplicablePercent.Value;
      VATCategory := SpecifiedTradeAllowanceCharge[i].CategoryTradeTax.CategoryCode.value;
      VATvalue    := WPXCurrencyRound(netValue / 100 * VATRate);
      grossValue  := netValue + VATvalue;
      if IsCharge then
           fChargesSummation.AddToList( VATCategory, VATRate, NetValue, VATvalue, GrossValue  )
      else fAllowanceSummation.AddToList( VATCategory, VATRate, NetValue, VATvalue, GrossValue  );
  end;

  // By default we calculate the VAT based on the sum of all Items
  if not (TWPXOrderCalcMode.VATAddRoundedOnLine in CalcModes) then
  begin
     for I := 1 to fMonetarySummation.Count-1 do
     begin
       r :=  fMonetarySummation[i];
       r.VATvalue := WPXCurrencyRound(r.netValue/100*r.VATRate);
       r.grossValue := r.netValue + r.VATvalue;
       fMonetarySummation[i] := r;
     end;
     for I := 1 to fChargesSummation.Count-1 do
     begin
       r :=  fChargesSummation[i];
       r.VATvalue := WPXCurrencyRound(r.netValue/100*r.VATRate);
       r.grossValue := r.netValue + r.VATvalue;
       fChargesSummation[i] := r;
     end;
  end;


  // Also add the delivery cost - I assume there can be more than one
  if alsoDelivery and ApplicableHeaderTradeSettlement.Has(TXHeaderTradeSettlement.SpecifiedLogisticsServiceCharge) then
  begin
     with ApplicableHeaderTradeSettlement do
     for I := 1 to SpecifiedLogisticsServiceCharge.ListCount do
     begin
         grossValue := SpecifiedLogisticsServiceCharge[i].AppliedAmount.Value;
         VATRate    := SpecifiedLogisticsServiceCharge[i].AppliedTradeTax.RateApplicablePercent.Value;
         // This is logical but not consitent with example PDFs
         if  TWPXOrderCalcMode.SpecifiedLogisticsNettoMode in CalcModes then
              netValue   := (grossValue/(100+VATRate))*100 // DO NOT ROUND THIS!
         else
         begin
             // So we do this instead by default
             netValue := grossValue;
             grossValue := WPXCurrencyRound((netValue/100)*(100+VATRate));
         end;
         VATCategory:= SpecifiedLogisticsServiceCharge[i].AppliedTradeTax.CategoryCode.value;
         VATvalue   := WPXCurrencyRound(grossValue - netValue);
         fChargesSummation.AddToList( VATCategory, VATRate, NetValue, VATvalue, GrossValue  );
     end;
  end;
end;

procedure TSupplyChainTradeTransaction.SetApplicableHeaderTradeAgreement
  (Value: THeaderTradeAgreement);
begin
  fApplicableHeaderTradeAgreement.Assign(Value);
end;

procedure TSupplyChainTradeTransaction.SetApplicableHeaderTradeDelivery
  (Value: THeaderTradeDelivery);
begin
  fApplicableHeaderTradeDelivery.Assign(Value);
end;

procedure TSupplyChainTradeTransaction.SetApplicableHeaderTradeSettlement
  (Value: THeaderTradeSettlement);
begin
  fApplicableHeaderTradeSettlement.Assign(Value);
end;

procedure TSupplyChainTradeTransaction.SetItems
  (Value: TSupplyChainTradeCollection);
begin
  fItems.Assign(Value);
end;

{ TSupplyChainTradeCollection }

function TSupplyChainTradeCollection.Add: TSupplyChainTradeItem;
begin
   Result := TSupplyChainTradeItem(inherited Add);
end;

constructor TSupplyChainTradeCollection.Create(ATransaction
  : TSupplyChainTradeTransaction);
begin
   inherited Create(TSupplyChainTradeItem);
   fTransaction := ATransaction;
end;

function TSupplyChainTradeCollection.GetItem(Index: Integer)
  : TSupplyChainTradeItem;
begin
   Result := TSupplyChainTradeItem(inherited GetItem(Index));
end;

function TSupplyChainTradeCollection.GetOwner: TPersistent;
begin
  Result := fTransaction;
end;

procedure TSupplyChainTradeCollection.SetItem(Index: Integer;
  Value: TSupplyChainTradeItem);
begin
   inherited SetItem(Index, Value);
end;

{ TSupplyChainTradeItem }

procedure TSupplyChainTradeItem.Assign(Source: TPersistent);
begin
  if Source is TSupplyChainTradeItem then
  begin
     FLine.Assign(TSupplyChainTradeItem(Source).FLine);
  end else
  inherited;

end;

constructor TSupplyChainTradeItem.Create(Collection: TCollection);
begin
  inherited;
  FLine := TSupplyChainTradeLineItem.Create;
end;

destructor TSupplyChainTradeItem.Destroy;
begin
  FLine.Free;
  inherited;
end;

function TSupplyChainTradeItem.GetDisplayName: string;
begin
  if FLine.Has(TXSupplyChainTradeLineItem.SpecifiedTradeProduct) then
    Result := FLine.GetValue
      (TXSupplyChainTradeLineItem.SpecifiedTradeProduct);
end;

function TSupplyChainTradeItem.getTotal: Double;
var q : Double;
begin
  if Line.SpecifiedLineTradeDelivery.Has(TXLineTradeDelivery.BilledQuantity) then
      q := Line.SpecifiedLineTradeDelivery.BilledQuantity.Value else q := 1;
  Result := WPXCurrencyRound(Line.SpecifiedLineTradeAgreement.NetPriceProductTradePrice.ChargeAmount.Value*q);
end;

procedure TSupplyChainTradeItem.SetLine(const Value
  : TSupplyChainTradeLineItem);
begin
  FLine.Assign(Value);
end;

{ TWPXOrderBase }

constructor TWPXOrderBase.Create(AOwner: TComponent);
begin
  inherited;
  FDefaults := TWPXDocDefaults.Create;
  {$IFDEF ALLOWXMLREADING}
  FXML := TXMLDocument.Create(Self);
  {$ENDIF}
  // X-Factur Types
  FTransaction := TSupplyChainTradeTransaction.Create(Self);
  FExchangedDocumentContext := TExchangedDocumentContext.Create;
  FExchangedDocumentContext.GuidelineSpecifiedDocumentContextParameter.ID.ValueStr :=
      WPXGuideLineDef[TWPXOrderProfile.Extended];
  FExchangedDocument := TExchangedDocument.Create;
end;

procedure TWPXOrderBase.Clear;
begin
  FTransaction.Clear;
  FExchangedDocumentContext.Clear;
  FExchangedDocument.Clear;
end;

destructor TWPXOrderBase.Destroy;
begin
  {$IFDEF ALLOWXMLREADING}
  FXML.Free;
  {$ENDIF}
  FDefaults.Free;
  FAsMemoryStream.Free;
  FTransaction.Free;
  FExchangedDocumentContext.Free;
  FExchangedDocument.Free;
  inherited;
end;

procedure TWPXOrderBase.SetAsMemoryStream(x: TStream);
begin
  if Assigned(fAsMemoryStream) then
        fAsMemoryStream.Clear
  else fAsMemoryStream := TMemoryStream.Create;
  x.Position := 0;
  fAsMemoryStream.CopyFrom(x,x.Size);
  LoadFromStream(fAsMemoryStream);
end;

procedure TWPXOrderBase.SetTranscation(Value: TSupplyChainTradeTransaction);
begin
   FTransaction.Assign(Value);
end;

procedure TWPXOrderBase.LoadFromFile(Filename: String);
begin
  {$IFDEF ALLOWXMLREADING}
  FXML.LoadFromFile(Filename);
  ReadXML;
  {$ELSE}
  raise EWPXorderXMLNotLinked.Create( sNOXML);
  {$ENDIF}
end;

procedure TWPXOrderBase.LoadFromStream(Stream: TStream);
begin
  {$IFDEF ALLOWXMLREADING}
  FXML.LoadFromStream(Stream);
  ReadXML;
  {$ELSE}
  raise EWPXorderXMLNotLinked.Create( sNOXML);
  {$ENDIF}
end;

type
  TUTF8EncodingNoBOM = class(TUTF8Encoding)
  public
    function GetPreamble: TBytes; override;
  end;

function TUTF8EncodingNoBOM.GetPreamble: TBytes;
begin
  Result := nil;
end;

procedure TWPXOrderBase.SaveToFile(Filename: String; Mode : TWPXOrderDumpMode = TWPXOrderDumpMode.XML);
var str : TStringList;
    UTF8withoutBOM: TEncoding;
begin
  str := TStringList.Create;
  UTF8withoutBOM := TUTF8EncodingNoBOM.Create;
  try
     str.Add(sXMLHeader);
     if sXMLComment<>'' then str.Add(sXMLComment);
     WriteToStrings(Mode, str);
     str.SaveToFile(Filename, UTF8withoutBOM); // TEncoding.UTF8
  finally
     str.Free;
     UTF8withoutBOM.Free;
  end;
end;

procedure TWPXOrderBase.SaveToStream(Stream: TStream);
var str : TStringList;
    UTF8withoutBOM: TEncoding;
begin
  str := TStringList.Create;
  UTF8withoutBOM := TUTF8EncodingNoBOM.Create;
  try
     str.Add(sXMLHeader);
     if sXMLComment<>'' then str.Add(sXMLComment);
     WriteToStrings(TWPXOrderDumpMode.XML,  str);
     str.SaveToStream(Stream, UTF8withoutBOM); // TEncoding.UTF8
  finally
     str.Free;
     UTF8withoutBOM.Free;
  end;
end;



{$IFDEF ALLOWXMLREADING}
function TWPXOrderBase.ProcessTagName(const n : String; var aName : String; var aNameSpace : String ) : TWPXElementNS;
var i : Integer;
begin
  i := Pos(':',n);
  if i>0 then
  begin
     aName := Copy(n,i+1,Length(n));
     aNameSpace := Copy(n,1,i-1);
     Result := Low(TWPXElementNS);
     while (Result<TWPXElementNS.none) and (aNameSpace<>FDefaults.NS[Result]) do inc(Result);
  end else
  begin
     aNameSpace := '';
     aName := n;
     Result := TWPXElementNS.none;
  end;
end;

function TWPXOrderBase.ReadElement( pNode : IXMLNode; ele : TWPXElement ) : Boolean;
var Node : IXMLNode;
    i, j  : Integer;
    n, nsName : string;
    subele : TWPXElement;
    ns : TWPXElementNS;

    procedure ReadAttributes( currNode : IXMLNode; inEle : TWPXElement );
    var a : Integer;
        b : Boolean;
    begin
       for a:=0 to currNode.AttributeNodes.Count-1 do
       begin
               b := inEle.AttributeSet(
                   currNode.AttributeNodes.Get(a).NodeName,
                   currNode.AttributeNodes.Get(a).NodeValue );
               if not b then
               FDefaults.Messages.Add(
                     'Ignore Attribute "' + Node.AttributeNodes.Get(a).NodeName +
                         '" in ' + ele.XMLTagName + ' - ' + inEle.XMLTagName );
       end;
    end;

begin
  Result := false;
  if ele=nil then
       raise Exception.Create('provide TWPXElement');
  for I := 0 to pNode.ChildNodes.Count-1 do
  begin
     Node := pNode.ChildNodes[i];
     ns := ProcessTagName(Node.NodeName,n, nsName );
     j := ele.ElementId(n);
     if j<0 then
     begin
         FDefaults.Log('ERR>>> ' + Node.XML );
     end
     else
     begin
        Result := true;
        subele := ele.GetElementFor(j);
        if subele<>nil then
        begin
           if not subele.WasCreatedNew then
             subele := subele.ListAdd;
           subele.WasCreatedNew := false;

           if subele.XMLNameSpace<>ns then
              FDefaults.Log('Correct Namespace: ' + n + '->' + WPXElementNSDefs[ns].nam + ' instead of '
                 + WPXElementNSDefs[subele.XMLNameSpace].nam);

           if subele.ElementId('')=-2 then
           begin
               subele.ValueStr := Node.Text;
               ReadAttributes(Node, subele);
           end else
           if Node.ChildNodes.Count>0 then
           begin
              ReadElement( Node, subele );
           end
           else
           begin
              subele.ValueStr := Node.Text;
              ReadAttributes( Node, subele );
           end;
        end;
     end;
  end;
end;

function TWPXOrderBase.ReadSupplyChainTradeTransactionItem( pNode : IXMLNode; CurrTransaction : TSupplyChainTradeTransaction ) : Boolean;
var Node : IXMLNode;
    i : Integer;
    n : string;
    item : TSupplyChainTradeItem;
begin
  Result := false;
  for I := 0 to pNode.ChildNodes.Count-1 do
  begin
     //
     Node := pNode.ChildNodes[i];
     n := Node.NodeName;
      // Agreement  -> ApplicableHeaderTradeAgreement
     if FDefaults.SameTagname( CurrTransaction.ApplicableHeaderTradeAgreement.XMLTagName, n, CurrTransaction.ApplicableHeaderTradeAgreement.XMLNameSpace ) then
        ReadElement( Node, CurrTransaction.ApplicableHeaderTradeAgreement )
      // Delivery
     else if FDefaults.SameTagname( CurrTransaction.ApplicableHeaderTradeDelivery.XMLTagName, n, CurrTransaction.ApplicableHeaderTradeDelivery.XMLNameSpace ) then
        ReadElement( Node, CurrTransaction.ApplicableHeaderTradeDelivery )
     // Settlement
     else if FDefaults.SameTagname( CurrTransaction.ApplicableHeaderTradeSettlement.XMLTagName, n, CurrTransaction.ApplicableHeaderTradeSettlement.XMLNameSpace ) then
        ReadElement( Node, CurrTransaction.ApplicableHeaderTradeSettlement )
     // LineItems
     else if FDefaults.SameTagname( FDefaults.IncludedSupplyChainTradeLineItem, n, TWPXElementNS.ram ) then
     begin
        item := CurrTransaction.Items.Add;
        ReadElement( Node, item.Line );
        Result := true; // We added at least one item!
     end
     else FDefaults.Log('not expected ' + n );
  end;
end;

procedure TWPXOrderBase.ReadXML;
var Node : IXMLNode;
    i : Integer;
    n : string;
begin
  Clear;
  // Clear messages
  FDefaults.SetDefaults;
  if FXML.DocumentElement=nil then
     raise Exception.Create('XML Document is empty');
  if not FDefaults.SameTagname( 'CrossIndustryInvoice', FXML.DocumentElement.NodeName, TWPXElementNS.rsm ) then
     raise Exception.Create('XML Document is empty');
  for I := 0 to FXML.DocumentElement.ChildNodes.Count-1 do
  begin
     //
     Node := FXML.DocumentElement.ChildNodes[i];
     n := Node.NodeName;
     // Context
     if FDefaults.SameTagname( ExchangedDocumentContext.XMLTagName, n, ExchangedDocumentContext.XMLNameSpace ) then
        ReadElement( Node, ExchangedDocumentContext )
     // Document
     else if FDefaults.SameTagname( ExchangedDocument.XMLTagName, n, ExchangedDocument.XMLNameSpace ) then
        ReadElement( Node, ExchangedDocument )
     else
     // Transaction
     if FDefaults.SameTagname(  FDefaults.SupplyChainTradeTransaction, n, TWPXElementNS.rsm ) then
     begin
        // there should only be one!
        inc(FDefaults.SupplyChainTradeTransactionCount);
        if FDefaults.SupplyChainTradeTransactionCount=1 then
           ReadSupplyChainTradeTransactionItem( Node, Transaction )
        else
        FDefaults.Log('Additional ' + FDefaults.SupplyChainTradeTransaction + ' was ignored' );
     end
     else FDefaults.Log('not expected ' + n );
  end;
end;

(*  WriteXElement and  WriteXML is not used. The Dump() method works just fine
procedure TWPXOrderBase.WriteXElement( pNode : IXMLNode; d : TWPXElement );
var i, j : Integer;
    Node : IXMLNode;
    s, q : string;
    aSub : TSeqData;
    an,av : string;
begin
    s := d.XMLTagName;
    q := FDefaults.NS[d.XMLNamespace];
    if q<>'' then s := q + ':' + s;
    Node := pNode.AddChild(s,''); // do not add namespace here!
    // Write TWPXSequenceStringsURN - the standard types

    j := d.AttributeCount;
    for i := 0 to j-1 do
    begin
      if d.AttributeGet(i,an,av) and (av<>'') then
         Node.Attributes[an] := av;
    end;

      if d.Count=0 then
         Node.Text := d.ValueStr
      else
      for I := 0 to d.Count-1 do
      begin
         aSub := d.Child(I);
         if aSub<>nil then
         begin
           if aSub.HasData then
                WriteXElement(Node, aSub.data)
           else Node.Text := aSub.AsString;
         end;
      end;
end;

procedure TWPXOrderBase.WriteXML;
var Node : IXMLNode;
begin
  FXML.Version := '1.0';
  FXML.Encoding := 'UTF-8';
  FXML.StandAlone := 'yes';
  Node := FXML.CreateNode(FDefaults.NS[TWPXElementNS.rsm] + ':'
     + FDefaults.CrossIndustryInvoice, ntElement, '');
  WriteXElement(Node,FExchangedDocumentContext);
  WriteXElement(Node,FExchangedDocument);
end;
*)
{$ENDIF}

const aCommentLine = '// -----------------------------------------------';

procedure TWPXOrderBase.DumpXElement( Mode : TWPXOrderDumpMode; str : TStrings; d : TWPXElement;
   level : Integer; path : string; options : TDumpXElementOptions = [] );
var levels : String;
    function MakeXML( element : TWPXElement; startOnly : Boolean = false ):String;
    var i : Integer;
        attrName, attrValue, ns, val : string;
    begin
        ns := Defaults.NS[element.XMLNameSpace];
        if ns<>'' then ns := ns+':';
        Result:=  levels + '<' + ns + element.XMLTagName ;
        for I := 0 to element.AttributeCount-1 do
        begin
                  if element.AttributeGet(i,attrName,attrValue) and (attrValue<>'') then
                       Result := Result + #32 +  attrName + '="' + Trim(attrValue) + '"';
        end;
        if startOnly then
        begin
           Result := Result + '>';
        end
        else
        begin
          // Write CLOSED XML Tags
          val := TWPXMLMakeSaveString(d.ValueStr);
          if val='' then
               Result := Result + '/>'
          else Result := Result + '>' + TWPXMLMakeSaveString(d.ValueStr) + '</' + ns + element.XMLTagName + '>' ;
        end;
    end;
    var
    sNextInList, val : String;
    i : Integer;
    iCountInList : Integer;

    dCName : String;
    dTagName : String;
    npath : string;
    ASortedList : TList<TSeqData>;
    procedure SubDump(aSub : TSeqData);
    begin
      if aSub<>nil then
      begin
               if aSub.HasData then
                    DumpXElement(  Mode, str, aSub.data, level+1, npath + sNextInList )
               else
               begin
                  if Mode in [TWPXOrderDumpMode.XML,TWPXOrderDumpMode.Debug] then
                  str.Add( levels + '<!-- ' + dTagName + ' as ' + dCName + ' = "' + d.ValueStr  + '" -->' );
               end;
      end;
    end;
    var aSub : TSeqData;
begin
  SetLength(levels,level);
  for I := 1 to level do levels[i] := #32;

  // We use [1] for the first in case there are more!
  iCountInList := 1;
  if (Mode in [TWPXOrderDumpMode.DelphiCode,TWPXOrderDumpMode.DelphiCodeCompact]) and
     (d.ListNext<>nil) then
  begin
       str.Add( '');
       str.Add( levels + '// ' + IntToStr( d.ListCount ) + ' <' + FDefaults.NS[d.XMLNameSpace]+':'+ d.XMLTagName  + '>');
       sNextInList := '[' + IntToStr(iCountInList) + ']';
  end
  else sNextInList := '';

  repeat
  begin
      dCName := d.ClassName;
      dTagName := FDefaults.NS[d.XMLNameSpace]+':'+ d.XMLTagName;

      if d.Count=0 then
      begin
            // Create Code to SetValue( ... ) - makes it possible to override and also set numbers directly
            if Mode in [TWPXOrderDumpMode.DelphiCode,TWPXOrderDumpMode.DelphiCodeCompact] then
            begin
               val := d.Get_SetValueParams(FDefaults);
               if (val<>#39+#39) or (d.ElementId('')=-2)  then
               begin
                    if Trim(path)='' then npath := path + d.XMLTagName
                    else npath := path + '.' + d.XMLTagName;

                    if (d is TIDType) and (TIDType(d).schemeID='') and (Pos(#32,TIDType(d).ValueStr)=0) then
                         str.Add( npath + sNextInList + '.ValueStr := ' +#39 +
                             StringReplace( TIDType(d).ValueStr, #39, #39+#39+#39, [rfReplaceAll]) + #39 + ';' )
                    else str.Add( npath + sNextInList + '.SetValue(' +  val + ');');
               end
               else str.Add( path + sNextInList + '.Clear;//=empty!')
            end
            else
            begin
              if Mode in [TWPXOrderDumpMode.XML] then
                 str.Add(MakeXML(d))
              else str.Add( levels + '<' + dTagName + ' class="' + dCName + '">' + TWPXMLMakeSaveString(d.ValueStr)  + '</' + d.XMLTagName + '>' );
            end;

      end
      else
      begin
         if (Mode in [TWPXOrderDumpMode.DelphiCodeCompact]) and (TWPXDumpXElementOption.CompactCode in options) then
         begin
              if path='item' then
                  str.Add( 'with item.Line do' )
             else str.Add( 'with ' + path + ' do' );
             str.Add( 'begin' );
             npath := #9;
         end else
         if Mode in [TWPXOrderDumpMode.XML,TWPXOrderDumpMode.Debug] then
         begin
            if Mode in [TWPXOrderDumpMode.XML] then
               str.Add(MakeXML(d,true))
            else str.Add( levels + '<' + dTagName + ' class="' + dCName + '">' );
            npath := path + '.' + d.XMLTagName;
         end
         else
         begin
            // thats the SupplyChainTradeLine, make it "item.Line."
            if  (path='item') then npath := 'item.Line'
            else if Trim(path)='' then npath := path + d.XMLTagName
            else npath := path + '.' + d.XMLTagName;
         end;

         // Save childen, in XML usually sorted
         if (Mode in [TWPXOrderDumpMode.XML]) and d.SaveElementsInSchemeOrder then
         begin
           ASortedList := d.ElementsSortedList;
           for I := 0 to ASortedList.Count-1 do
              SubDump(ASortedList[i]);
         end else
         for I := 0 to d.Count-1 do
          begin
             SubDump(d.Child(I));
          end;



         if Mode in [TWPXOrderDumpMode.XML,TWPXOrderDumpMode.Debug] then
            str.Add( levels + '</' + dTagName + '>' )
         else if (Mode in [TWPXOrderDumpMode.DelphiCodeCompact]) and
               (TWPXDumpXElementOption.CompactCode in options) then
         begin
             str.Add( 'end;' );
             str.Add( '' );
         end else

      end;
      d := d.ListNext;
      inc(iCountInList);
      sNextInList := '[' + IntToStr(iCountInList) + ']';
  end
  until d = nil;
end;


function TWPXOrderBase.GetAsMemoryStream: TStream;
begin
  if Assigned(fAsMemoryStream) then
        fAsMemoryStream.Clear
  else fAsMemoryStream := TMemoryStream.Create;
  SaveToStream(fAsMemoryStream);
  Result := fAsMemoryStream;
end;

procedure TSupplyChainTradeTransaction.Dump(  Mode : TWPXOrderDumpMode; aOrder : TWPXOrderBase; str : TStrings; level : Integer; path : string );
var i : Integer;
    levels : String;
    fOldAssignedXMLTagName : String;
begin
   SetLength(levels,level);
   for I := 1 to level do levels[i] := #32;
   fOldAssignedXMLTagName := '';
    // rsm.SupplyChainTradeTransaction !
   if Mode in [TWPXOrderDumpMode.Debug,TWPXOrderDumpMode.XML] then
      str.Add(levels + '<' + aOrder.Defaults.NS[TWPXElementNS.rsm] + ':SupplyChainTradeTransaction>')
   else if Mode in [TWPXOrderDumpMode.DelphiCode,TWPXOrderDumpMode.DelphiCodeCompact] then
   begin
     { str.Add( aCommentLine );
      str.Add( '// now add all required IncludedSupplyChainTradeLineItem instances' );
      str.Add( '// requires variable' );
      str.Add( '// var item : TSupplyChainTradeItem;' );
      str.Add( aCommentLine );  }
   end;

   try
     for i := 0 to Items.Count-1 do
     try

        if Mode in [TWPXOrderDumpMode.Debug,TWPXOrderDumpMode.XML] then
        begin
                //str.Add(levels + '<' + aOrder.Defaults.NS[TWPXElementNS.ram] + ':IncludedSupplyChainTradeLineItem>');
                fOldAssignedXMLTagName := Items[i].Line.fAssignedXMLTagName;
                Items[i].Line.fAssignedXMLTagName := 'IncludedSupplyChainTradeLineItem';
                aOrder.DumpXElement( Mode, str, Items[i].Line, level+2, path  );
        end
        else
        begin
              str.Add( '' );
              str.Add( aCommentLine );
              str.Add( '// SupplyChainTradeLine ' + IntToStr(i+1) );
              str.Add( aCommentLine );
              str.Add( 'item:=' + path + '.Transaction.Items.Add;' );
              // Exported as item. instead of SupplyChainTradeLineItem
              aOrder.DumpXElement( Mode, str, Items[i].Line, level+2, 'item', [TWPXDumpXElementOption.CompactCode] );
        end;

     finally
        if Mode in [TWPXOrderDumpMode.Debug,TWPXOrderDumpMode.XML] then
            Items[i].Line.fAssignedXMLTagName := fOldAssignedXMLTagName;

        //if Mode in [TWPXOrderDumpMode.Debug,TWPXOrderDumpMode.XML] then
        //  str.Add(levels +' </' + aOrder.Defaults.NS[TWPXElementNS.ram] + ':IncludedSupplyChainTradeLineItem>');
     end;

     if Mode in [TWPXOrderDumpMode.DelphiCode,TWPXOrderDumpMode.DelphiCodeCompact] then
     begin
       str.Add('');
       str.Add('');
       str.Add( aCommentLine );
       str.Add( '// now add Transcation details' );
       str.Add( aCommentLine );

       path := path + '.Transaction';
     end;

     if Mode in [TWPXOrderDumpMode.DelphiCode,TWPXOrderDumpMode.DelphiCodeCompact] then
     begin
         aOrder.DumpXElement( Mode, str, ApplicableHeaderTradeAgreement, level+1, path+'.ApplicableHeaderTradeAgreement', [TWPXDumpXElementOption.CompactCode]  );
         aOrder.DumpXElement( Mode, str, ApplicableHeaderTradeDelivery, level+1, path+'.ApplicableHeaderTradeDelivery', [TWPXDumpXElementOption.CompactCode]  );
         aOrder.DumpXElement( Mode, str, ApplicableHeaderTradeSettlement, level+1, path+'.ApplicableHeaderTradeSettlement', [TWPXDumpXElementOption.CompactCode]  );
     end else
     begin
       aOrder.DumpXElement( Mode, str, ApplicableHeaderTradeAgreement, level+1, path  );
       aOrder.DumpXElement( Mode, str, ApplicableHeaderTradeDelivery, level+1, path  );
       aOrder.DumpXElement( Mode, str, ApplicableHeaderTradeSettlement, level+1, path );
     end;

   finally
     if Mode in [TWPXOrderDumpMode.Debug,TWPXOrderDumpMode.XML] then
        str.Add(levels +'</' + aOrder.Defaults.NS[TWPXElementNS.rsm] + ':SupplyChainTradeTransaction>');
   end;
end;

procedure TWPXOrderBase.WriteToStrings( Mode : TWPXOrderDumpMode; str : TStrings );
var aName : String;
begin
   str.BeginUpdate;
   try
      aName := Name;
      if aName='' then aName := 'WPXFactur1';


      if Mode = TWPXOrderDumpMode.Debug then
          str.Add('<debugout>')
      else if Mode = TWPXOrderDumpMode.XML then
           str.Add(WPXOrderXFacturNSHeader)
      else if Mode in [TWPXOrderDumpMode.DelphiCode,TWPXOrderDumpMode.DelphiCodeCompact] then
      begin
         str.Add(aCommentLine);
         str.Add('// Fill X-Factur - created on ' + DateToStr(Now) );
         str.Add('// ' + WPXOrderVersion + ' (https://github.com/wpcubed/xorder)');
         str.Add('// var ' + aName +' : TWPXFactur;');
         str.Add('// var item : TSupplyChainTradeItem;');
         str.Add(aCommentLine);
         str.Add('{$REGION Fill X-Factur}');
      end;

      if Mode in [TWPXOrderDumpMode.DelphiCodeCompact] then
      begin
         DumpXElement( Mode, str, FExchangedDocumentContext, 1, aName+'.ExchangedDocumentContext', [TWPXDumpXElementOption.CompactCode] );
         DumpXElement( Mode, str, FExchangedDocument, 1, aName+'.ExchangedDocument', [TWPXDumpXElementOption.CompactCode]  );
      end else
      begin
         DumpXElement( Mode, str, FExchangedDocumentContext, 1, aName );
         DumpXElement( Mode, str, FExchangedDocument, 1, aName  );
      end;

      Transaction.Dump( Mode, Self, str, 1, aName );

      if Mode = TWPXOrderDumpMode.Debug then
          str.Add('</debugout>')
      else if Mode = TWPXOrderDumpMode.XML then
          str.Add('</rsm:CrossIndustryInvoice>')
      else if Mode in [TWPXOrderDumpMode.DelphiCode,TWPXOrderDumpMode.DelphiCodeCompact] then
      begin
         str.Add('');
         str.Add('{$ENDREGION Fill X-Factur}');
         str.Add(aCommentLine);
         str.Add('');
      end;
   finally
     str.EndUpdate;
   end;
end;



{ TSumRecList }

procedure TSumRecList.AddToList( aVATCategory : TTaxCategory;
                     aVATRate, aNetValue, aVATvalue, aGrossValue : Double );
    var r : TSumRec;
        j : Integer;
    begin
          for j := 0 to Count-1 do
          begin
            if SameValue(list[j].VATRate,aVATRate) and
               (list[j].VATCategory=aVATCategory)
            then
            begin
               r := list[j];
               r.netValue := r.netValue + aNetValue;
               r.grossValue := r.grossValue + aGrossValue;
               r.VATvalue := r.VATvalue + aVATvalue;
               list[j] := r;
               exit;
            end;
          end;
          r.netValue   := aNetValue;
          r.grossValue := aGrossValue;
          r.VATRate    := aVATRate;
          r.VATvalue   := aVATvalue;
          r.VATCategory := aVATCategory;
          Add(r);
    end;

end.
