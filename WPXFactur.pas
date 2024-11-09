unit WPXFactur;

{ WPXOrder by WPCubed
  https://github.com/wpcubed/xorder
  https://www.wpcubed.com/xorder
  Copyright (C) 2024 WPCubed GmbH, developed by Julian Ziersch
  https://www.wpcubed.com/pdf/xorder/

  The project WPXOrder with the X-Factur specification and is aimed at reading
  and creating XML invoice data in Delphi. It was developed utilizing
  modern compiler features like method overloading and generics. This enables
  the generation of XML data in Delphi code with the assistance of type checking.

  **********************************************
  This unit calculates the sums in an invoice.
  Please use at your own risk since we found out, that the
  provided examples ado not produce results wich are consistent with this calulation.
  Please report errors you find!
  **********************************************

  The code was created with the Information provided here
  https://xeinkauf.de/dokumente/

  Here you can validate the created XML / Invoice
  https://portal3.gefeg.com/invoice/page/validation
}

{$SCOPEDENUMS ON} // Require the SCOPE

interface

uses System.SysUtils, System.Rtti, System.TypInfo, System.IOUtils, System.Math,
  System.StrUtils, System.Types, System.Classes, System.Generics.Collections,
  WPXFacturTransaction, WPXFacturTypes, WPXFacturEN16931;



type
  TCompanyData = class
  private
      function getCountryIDText : String;
      procedure setCountryIDText(x : String);
  public
      // Mandatory Fields
      Name  : String;
      PostcodeCode : String;
      Addres : String; // Addres LineOne
      CityName : String;
      CountryID : TCountryID;
      // Optional
      DepartmentName : String;
      // Required for Seller
      TAXId : String;
      // Required for EU Sales
      VATID : String;
      // Optional: Full text, several lines  for Seller!
      ContactInfo : String;
      // Optional
      ID, GlobalID, GlobalIDScheme : String;
      // Optional, Reg Nr
      SpecifiedLegalOrganization : String;

      // Resets this record
      procedure Clear;
      procedure Assign(const Source : TCompanyData);
      procedure AssignTo(Dest : TTradeParty);
      procedure AssignFrom(Source: TTradeParty);
      property  CountryIDText : String read getCountryIDText write setCountryIDText;
  end;

  TDeliveryData = class
     OccurrenceDateTime : TDateTime;
     ReferencedDocument : String;
  end;

  TPaymentData = class
    TAXCategory : TTaxCategory;
    DueDateDateTime : TDateTime;
    // -or-
    PaymentTerms : String;
    Days         : Integer;
    // SKONTO
    PaymentDiscountTermsDays : Integer; // i.e. 14. Must be >0
    PaymentDiscountTermsDescription : String; // 'Bei Zahlung innerhalb 14 Tagen gewähren wir 2,0% Skonto.'
    PaymentDiscountTermsPercent : Double;
  end;

  TOrderData = class
      // that goes it BuyerOrderReferencedDocument.IssuerAssignedID
      // Should be the postal order
      IssuerAssignedID : String;
      // TODO: List of AdditionalReferencedDocument  -also with
      // binary data to attach documents
  end;

  TReadCompanyDataMode = (
    Seller,
    Buyer,
    Payee,
    ShipTo
  );


  /// <summary>
  ///  TWPXFactur is the base class to create a EN16931 (ZUGFeRD)
  ///  Invoice. It allows access to the data structures using
  ///   property ExchangedDocumentContext;
  ///   property ExchangedDocument;
  ///   property Defaults;
  ///   property Transaction;
  ///  and also includes High level functions to help with the
  ///  initialisation, creations and also calculation of an invoice.
  ///  </summary>

  TWPXFactur = class( TWPXOrderBase )
  private
      // Date of current invoice - needed to finalize the invoice
      fCreateInvoiceDemoMode : Boolean;
      fSelectedProfile : TWPXOrderProfile;
      fMessages : TStringList;
      FInVerifySummation : Boolean;
  public
     procedure Clear; override;

     // Reads address information from Invoice in Memory
     function ReadCompanyData( data : TCompanyData; Sel : TReadCompanyDataMode ) : Boolean;

     // Initialize the objects with required Seller and Buyer data.
     // call FinalizeInvoice at the end
     procedure StartInvoice(
        DocumentCode : TDocumentCode; // i.e. TDocumentCode.c380_Commercial_invoice
        IssueDate : TDateTime;
        InvoiceNr : String; // = ID
        InvoiceName : String; // i.e. Warenrechnung
        const Seller : TCompanyData;
        const Buyer  : TCompanyData;
        const ShipTo : TCompanyData;
        // Optional Fields (or nil)
        IncludedNotes : TStrings; // optional notes, one by one. Can start with a Code, i.e.  EEV,AAJ=Der Verkäufer bleibt Eigentümer
        OrderData : TOrderData;
        DeliveryData : TDeliveryData;
        PaymentData : TPaymentData
      ); virtual;

      // Helper function to add a product Sale
      function AddSale(
           const ProductName    : String;
           const SinglePriceNET : Double;
           const Quantity       : Double;
           const VATRate        : Double;
           const VATCategory    : TTaxCategory;
           const QuantityCode   : String = 'H87'; // 'H87' = A Piece
           const Total          : Double = 0
      ) : TSupplyChainTradeItem;

      // Add rebatte, extra charge, delivery etc
      function AddAllowanceCharge(
         IsCharge : Boolean; // true for surcharge!
         const CalculationPercent : Double;
         const BasisAmount : Double;
         const Reason : String;
         const VATRate        : Double;
         const VATCategory    : TTaxCategory
      ) : TTradeAllowanceCharge;

      // Add delivery cost - not that this is a NET Value
      function AddLogisticsServiceCharge(
         const Description : String;
         const Value : Double;
         const VATRate        : Double;
         const VATCategory    : TTaxCategory
      ) : TLogisticsServiceCharge;

      // Add skonto
      function AddPaymentTerm(
         const Description : String;
         const BasisPeriodMeasurDays : Integer; // must be >0
         const CalculationPercent : Double
      ) : TTradePaymentTerms;

     // ApplicableHeaderTradeSettlement
     function FinalizeInvoice(
          CalcApplicableTradeTax : Boolean;
          InvoiceCurrencyCode : TCurrencyCode;
          PrepaidAmount : Double;
          PaymentData : TPaymentData ) : TTradeSettlementHeaderMonetarySummation;

     {:: Calculate the summation in the invoice and compare with the exisint values }
     procedure VerifySummation;



     constructor Create(AOwner : TComponent); override;
     destructor Destroy; Override;


     property ExchangedDocumentContext;
     property ExchangedDocument;
     property Defaults;
     property Transaction;

     /// <summary>
     /// if CreateInvoiceDemoMode is true than the TestIndicator will be set to true.
     ///  </summary>
     property CreateInvoiceDemoMode : Boolean read fCreateInvoiceDemoMode write fCreateInvoiceDemoMode;

    published
     property SelectedProfile : TWPXOrderProfile read fSelectedProfile write fSelectedProfile;
     property Messages : TStringList read fMessages;
  end;

procedure Register;

{ Use this information with wPDF (PDF Creator by WPCubed)

  WPPDFExport1.AddXMPExtra( pdfa_xfactur_schema, pdfa_xfactur_info  );
  WPPDFExport1.AddFileAttachment(pdfa_xfactur_filename, pdfa_xfactur_description, stream);
}

var pdfa_xfactur_schema : String;
    pdfa_xfactur_info : String;
    pdfa_xfactur_filename, pdfa_xfactur_LEVEL, pdfa_xfactur_description : String;

implementation

resourcestring
    wpx_tax_no_vat = 'Kein Ausweis der Umsatzsteuer bei innergemeinschaftlichen Lieferungen';

procedure Register;
begin
  RegisterComponents('WPXOrder', [TWPXFactur,TSupplyChainTradeTransaction]);
end;


{ TWPXFactur }

constructor TWPXFactur.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fMessages := TStringList.Create;
  fSelectedProfile := TWPXOrderProfile.Extended;
end;

destructor TWPXFactur.Destroy;
begin
  fMessages.Free;
  inherited;
end;

procedure TWPXFactur.Clear;
begin
  inherited;
  fMessages.Clear;
end;

function TWPXFactur.ReadCompanyData( data : TCompanyData; Sel : TReadCompanyDataMode ) : Boolean;
begin
   case Sel of
      TReadCompanyDataMode.Seller :
         if Transaction.ApplicableHeaderTradeAgreement.Has(TXHeaderTradeAgreement.SellerTradeParty) then
             data.AssignFrom( Transaction.ApplicableHeaderTradeAgreement.SellerTradeParty ) else data.Clear;
      TReadCompanyDataMode.Buyer:
         if Transaction.ApplicableHeaderTradeAgreement.Has(TXHeaderTradeAgreement.BuyerTradeParty) then
             data.AssignFrom( Transaction.ApplicableHeaderTradeAgreement.BuyerTradeParty ) else data.Clear;
      TReadCompanyDataMode.Payee:
         if Transaction.ApplicableHeaderTradeAgreement.Has(TXHeaderTradeAgreement.BuyerTradeParty) then
             data.AssignFrom( Transaction.ApplicableHeaderTradeAgreement.BuyerTradeParty ) else data.Clear;
      TReadCompanyDataMode.ShipTo:
         if Transaction.ApplicableHeaderTradeSettlement.Has(TXHeaderTradeSettlement.PayeeTradeParty) then
             data.AssignFrom( Transaction.ApplicableHeaderTradeSettlement.PayeeTradeParty ) else data.Clear;
   end;
end;

procedure TWPXFactur.StartInvoice(
  DocumentCode : TDocumentCode;
  IssueDate: TDateTime;
  InvoiceNr, InvoiceName: String;
  const Seller, Buyer, ShipTo: TCompanyData;
  IncludedNotes: TStrings;
  OrderData : TOrderData;
  DeliveryData : TDeliveryData;
  PaymentData : TPaymentData);
  // Split a note string up
  // Expected Syntax
  // ContentCode,sSubjectCode=Text
  function SplitNoteString( const sIn : String; var sContentCode, sSubjectCode : String ) : String;
  var i : Integer;
  begin
     i := Pos('=',sIn);
     if (i<2) or (i>7) then // 2 * 3 letter codes
     begin
         Result := sIn;
         sSubjectCode := '';
         sSubjectCode := '';
         if i=1 then Delete(Result,1,1);
     end else
     begin
        Result := Copy(sIn,i+1, Length(sIn));
        sContentCode := Copy(sIn,1, i-1);
        i := Pos(',',sContentCode);
        if i>0 then
        begin
           sSubjectCode := Copy(sContentCode,i+1,3);
           Delete(sContentCode,1, i);
        end else sSubjectCode := '';
     end;
  end;

var
  I: Integer;
  s, sContentCode, sSubjectCode : String;
begin
  Clear;

  with ExchangedDocumentContext do
  begin
      if CreateInvoiceDemoMode then
      begin
         TestIndicator.Indicator.SetValue(true);
         fMessages.Add('*** Create Test invoice');
      end;
      GuidelineSpecifiedDocumentContextParameter.ID.ValueStr :=
          WPXGuideLineDef[ SelectedProfile ];
  end;

  // -- Fill the document info --
  // the cast() is not necessary of course, but
  // feel free to CTRL+CLICK to go to definition!
  with TExchangedDocument(ExchangedDocument) do
  begin
      ID.ValueStr := InvoiceNr;
      fMessages.Add('Create: ' + InvoiceName);

	    Name.SetValue(InvoiceName);
      TypeCode.SetValue(DocumentCode);
      IssueDateTime.DateTimeString.value := IssueDate;


      if IncludedNotes<>nil then
      for I := 0 to IncludedNotes.Count-1 do
      begin
         s := Trim(IncludedNotes[i]);
         if s<>'' then
         begin
            with IncludedNote.ListIsFirstOrAdd as TNote do
            begin
                Content.SetValue(SplitNoteString(s,sContentCode, sSubjectCode));
                ContentCode.SetValue(sContentCode);
                SubjectCode.SetValue(sSubjectCode);
            end;
         end;
      end;

      // Add long Address
      if Seller.ContactInfo<>'' then
      with IncludedNote.ListIsFirstOrAdd as TNote do
      begin
        Content.SetValue(Seller.ContactInfo);
        SubjectCode.SetValue('REG');
      end;
  end;


  with THeaderTradeAgreement(Transaction.ApplicableHeaderTradeAgreement) do
  begin
    Seller.AssignTo(SellerTradeParty);
    Buyer.AssignTo(BuyerTradeParty);
    if OrderData<>nil then
    begin
      if OrderData.IssuerAssignedID<>'' then
    	   BuyerOrderReferencedDocument.IssuerAssignedID.ValueStr := OrderData.IssuerAssignedID;
      // TODO - add other items
      // AdditionalReferencedDocument.IssuerAssignedID.ValueStr := 'A456123';
      // AdditionalReferencedDocument.TypeCode.SetValue('130');
    end;
  end;

  // NOW add Delivery
  with THeaderTradeDelivery(Transaction.ApplicableHeaderTradeDelivery) do
  begin
    if ShipTo<>nil then  ShipTo.AssignTo(ShipToTradeParty)
    else
    // EU Invoices NEED Desitnation Country ID
    if (PaymentData<>nil) and (PaymentData.TAXCategory in
       [ TTaxCategory.K_VAT_exempt_for_EEA ]) then
        ShipToTradeParty.PostalTradeAddress.CountryID.Value :=
           Buyer.CountryID;

    if DeliveryData<>nil then
    begin
       ActualDeliverySupplyChainEvent.OccurrenceDateTime.DateTimeString.value := DeliveryData.OccurrenceDateTime;
       if DeliveryData.ReferencedDocument<>'' then
       DeliveryNoteReferencedDocument.IssuerAssignedID.ValueStr := DeliveryData.ReferencedDocument;
    end
    else
    // If not specified assign the same data as order
    ActualDeliverySupplyChainEvent.OccurrenceDateTime.DateTimeString.value := IssueDate;
  end;

  // NOW add the addres to the Settlement
  with THeaderTradeSettlement(Transaction.ApplicableHeaderTradeSettlement) do
  begin
     // THIS must be set at first! We can refine it later in Finalize!
     Transaction.ApplicableHeaderTradeSettlement.InvoiceCurrencyCode.SetValue( TCurrencyCode.EUR );
   //  Buyer.AssignTo(InvoiceeTradeParty);

     Buyer.AssignTo( PayeeTradeParty );
     // ApplicableTradeTax and SpecifiedTradeAllowanceCharge are
     // added in FinalizeInvoice
  end;
end;

function TWPXFactur.AddSale(
           const ProductName    : String;
           const SinglePriceNET : Double;
           const Quantity       : Double;
           const VATRate        : Double;
           const VATCategory    : TTaxCategory;
           const QuantityCode   : String = 'H87'; // 'H87' = A Piece
           const Total          : Double = 0
          ): TSupplyChainTradeItem;
begin
  if (SinglePriceNET<0) or (Quantity<0) then
  raise EWPXorderBadParams.Create('The price or quantity may not be negative. Consider AddAllowanceCharge');
  Result := Transaction.Items.Add;
  with Result.Line do
  begin
      AssociatedDocumentLineDocument.LineID.SetValue(1);
      SpecifiedTradeProduct.Name.SetValue(ProductName);
      // The price of an item, exclusive of VAT, after subtracting any item price discount.
      SpecifiedLineTradeAgreement.NetPriceProductTradePrice.ChargeAmount.SetValue(SinglePriceNET);
      // The unit of measure that applies to the Item price base quantity.
      SpecifiedLineTradeAgreement.NetPriceProductTradePrice.BasisQuantity.SetValue(1.0, {unitCode=}QuantityCode );
      // The quantity of items (goods or services) that is charged in the Invoice line.
      SpecifiedLineTradeDelivery.BilledQuantity.SetValue(Quantity,QuantityCode);
      // The TAX for this Item
      SpecifiedLineTradeSettlement.ApplicableTradeTax.TypeCode.SetValue('VAT');
      SpecifiedLineTradeSettlement.ApplicableTradeTax.CategoryCode.SetValue(VATCategory);
      SpecifiedLineTradeSettlement.ApplicableTradeTax.RateApplicablePercent.SetValue(VATRate);
      // Attention - if you add charges/surcharges this must be updated!
      // If 0 was provided we calculate ourselves
      if SameValue(Total,0) then
         SpecifiedLineTradeSettlement.SpecifiedTradeSettlementLineMonetarySummation.
             LineTotalAmount.SetValue(WPXCurrencyRound(Quantity*SinglePriceNET))
      else SpecifiedLineTradeSettlement.SpecifiedTradeSettlementLineMonetarySummation.
             LineTotalAmount.SetValue(Total);
  end;
end;

function TWPXFactur.AddAllowanceCharge(
  IsCharge: Boolean; // TURE means it is added to the invoice
  const CalculationPercent, BasisAmount: Double;
  const Reason: String;
  const VATRate: Double;
  const VATCategory: TTaxCategory): TTradeAllowanceCharge;
begin
  Result := (Transaction.ApplicableHeaderTradeSettlement.SpecifiedTradeAllowanceCharge.ListIsFirstOrAdd
              as TTradeAllowanceCharge);
  Result.ChargeIndicator.Indicator.SetValue(IsCharge);
	Result.CalculationPercent.SetValue(CalculationPercent);
	Result.BasisAmount.SetValue(BasisAmount);
	Result.ActualAmount.SetValue(
     WPXCurrencyRound(BasisAmount/100*CalculationPercent));
	Result.Reason.SetValue(Reason);
	Result.CategoryTradeTax.TypeCode.SetValue('VAT');
	Result.CategoryTradeTax.CategoryCode.SetValue(VATCategory);
	Result.CategoryTradeTax.RateApplicablePercent.SetValue(VATRate);
end;

// Logistic Costs
function TWPXFactur.AddLogisticsServiceCharge(const Description: String;
  const Value, VATRate: Double;
  const VATCategory: TTaxCategory): TLogisticsServiceCharge;
begin
   Result := Transaction.ApplicableHeaderTradeSettlement.SpecifiedLogisticsServiceCharge.ListIsFirstOrAdd
              as TLogisticsServiceCharge;
   Result.Description.SetValue(Description);
   Result.AppliedAmount.SetValue( Value +  WPXCurrencyRound(Value/100*VATRate)  );
	 Result.AppliedTradeTax.TypeCode.SetValue('VAT');
   Result.AppliedTradeTax.CategoryCode.SetValue(VATCategory);
	 Result.AppliedTradeTax.RateApplicablePercent.SetValue(VATRate);
end;

function TWPXFactur.AddPaymentTerm(
   const Description: String;
  const BasisPeriodMeasurDays: Integer;
  const CalculationPercent: Double): TTradePaymentTerms;
begin
  Result := Transaction.ApplicableHeaderTradeSettlement.SpecifiedTradePaymentTerms.ListIsFirstOrAdd
              as TTradePaymentTerms;
  Result.Description.SetValue(Description);
  Result.ApplicableTradePaymentDiscountTerms.BasisPeriodMeasure.SetValue( IntToStr(BasisPeriodMeasurDays),'DAY');
  Result.ApplicableTradePaymentDiscountTerms.CalculationPercent.Value := CalculationPercent;
end;

procedure TWPXFactur.VerifySummation;
var aInvoiceCurrencyCode : TCurrencyCode;
    aPrepaidAmount : Double;
begin
  // Check the compiler and rounding code
  if not SameValue( WPXCurrencyRound(13.455), 13.46)  or
     not SameValue( WPXCurrencyRound(-13.455), -13.46) then
        raise Exception.Create('Rounding does not work as expected');

  FInVerifySummation := true;
  fMessages.Clear;
  try
     aInvoiceCurrencyCode := Transaction.ApplicableHeaderTradeSettlement.InvoiceCurrencyCode.value;
     if Transaction.ApplicableHeaderTradeSettlement.SpecifiedTradeSettlementHeaderMonetarySummation.Has(
       TXTradeSettlementHeaderMonetarySummation.TotalPrepaidAmount) then
          aPrepaidAmount := Transaction.ApplicableHeaderTradeSettlement.SpecifiedTradeSettlementHeaderMonetarySummation.TotalPrepaidAmount.Value
     else aPrepaidAmount := 0;
     FinalizeInvoice( true, aInvoiceCurrencyCode, aPrepaidAmount, nil );
  finally
    FInVerifySummation := false;
  end;
end;


function TWPXFactur.FinalizeInvoice(
    CalcApplicableTradeTax : Boolean;
    InvoiceCurrencyCode : TCurrencyCode;
    PrepaidAmount : Double;
    PaymentData : TPaymentData ): TTradeSettlementHeaderMonetarySummation;
var i : Integer;
    r : TSumRec;
    tax : TTradeTax;
    LineitemTotal, ChargesTotal, AllowanceTotal : Double;
    grossLineitemTotal, grossChargesTotal, grossAllowanceTotal : Double;
    vattotal, grossGrandtotal, netGrandtotal : Double;
    // conversionrate : Double;
    // r.gross value is used for the allowance/Charge!
    summationApplicableTradeTax : TSumRecList;
    currency : String;
begin
  if not FInVerifySummation then
  Transaction.ApplicableHeaderTradeSettlement.InvoiceCurrencyCode.SetValue(InvoiceCurrencyCode);
  currency := Transaction.ApplicableHeaderTradeSettlement.InvoiceCurrencyCode.ValueStr;
  summationApplicableTradeTax := TSumRecList.Create;
  try
      LineitemTotal       := 0;
      AllowanceTotal      := 0;
      grossLineitemTotal  := 0;
      grossAllowanceTotal := 0;
      vattotal            := 0;
      grossGrandtotal     := 0;
      netGrandtotal       := 0;

      if CalcApplicableTradeTax then
      begin
        // Clear ApplicableTradeTax
        if FInVerifySummation then tax := nil else
        begin
            tax := Transaction.ApplicableHeaderTradeSettlement.ApplicableTradeTax;
            tax.Clear;
        end;

        // Fills the lists MonetarySummation, AllowanceSummation and also ChargesSummation
        Transaction.CalcSummation(fMessages, true); // ALSO Delivery!
        for I := 0 to Transaction.MonetarySummation.Count-1 do
        begin
           r := Transaction.MonetarySummation[i];
           if (tax=nil) and not FInVerifySummation then
              tax := TTradeTax(Transaction.ApplicableHeaderTradeSettlement.ApplicableTradeTax.ListAdd);

           // SKIPPED FOR 0 TAX - that still add to total!
           if not SameValue(r.VATRate,0) and (tax<>nil) then
           with tax do
           begin
                CalculatedAmount.Value := r.VATvalue;
                TypeCode.SetValue('VAT');
                BasisAmount.Value := r.netValue;
                RateApplicablePercent.Value := r.netValue;
                CategoryCode.value := r.VATCategory;
                tax := nil;
           end;

           // summationApplicableTradeTax also containes 0 TAX Lines
           summationApplicableTradeTax.AddToList(
                    r.VATCategory,
                    r.VATRate,
                    r.netValue, //--> LineTotalBasisAmount
                    r.VATvalue, //--> CalculatedAmount
                    0  //--> AllowanceChargeBasisAmount
                    );

           LineitemTotal := LineitemTotal + r.netValue;

           netGrandtotal := netGrandtotal + r.netValue;
           // For use in  SpecifiedTradeSettlementHeaderMonetarySummation
           // Usually we throw away those values and recalculate on basis of sums  (#VATAddRoundedOnLine)
           grossLineitemTotal := grossLineitemTotal + r.grossValue;
           grossGrandtotal := grossGrandtotal + r.grossValue;
           fMessages.Add(Format('# Line: net %f gross %f VAT %f = %f',[r.netValue,r.grossValue,r.VATRate,r.VATvalue]));
        end;

        // Add rebates - AllowanceTotalAmount  (subtracted!)
        if Transaction.AllowanceSummation.Count>0 then
        begin
           // Subtract the Allowances = Rebatte!
           for I := 0 to Transaction.AllowanceSummation.Count-1 do
           begin
               r := Transaction.AllowanceSummation[i];
               AllowanceTotal := AllowanceTotal - r.netValue;
               grossAllowanceTotal := grossAllowanceTotal - r.grossValue;
               // Allowance SUBTRACT
               summationApplicableTradeTax.AddToList(
                    r.VATCategory,
                    r.VATRate,
                    0, //--> LineTotalBasisAmount
                    -r.VATvalue, //--> CalculatedAmount
                    -r.netValue  //--> AllowanceChargeBasisAmount
                    );
               grossGrandtotal := grossGrandtotal - r.grossValue;
               netGrandtotal := netGrandtotal - r.netValue;
           end;
           if not FInVerifySummation then
           Transaction.ApplicableHeaderTradeSettlement.SpecifiedTradeSettlementHeaderMonetarySummation.AllowanceTotalAmount.Value
                := grossAllowanceTotal; // POSITIVE!
           fMessages.Add(Format('# Allowance: net %f gross %f ',[allowanceTotal,grossAllowanceTotal]));
        end;

        chargesTotal := 0;
        grossChargesTotal := 0;
        if Transaction.ChargesSummation.Count>0 then
        begin
            // Add additional costs!  ChargeTotalAmount =  GROSS!
            for I := 0 to Transaction.ChargesSummation.Count-1 do
             begin
               r := Transaction.ChargesSummation[i];
               // Charges ADD
               summationApplicableTradeTax.AddToList(
                    r.VATCategory,
                    r.VATRate,
                    0, //--> LineTotalBasisAmount
                    r.VATvalue, //--> CalculatedAmount
                    r.netValue  //--> AllowanceChargeBasisAmount
                    );
               chargesTotal := chargesTotal + r.netValue;
               grossChargesTotal := grossChargesTotal + r.grossValue;
               grossGrandtotal := grossGrandtotal + r.grossValue;
               netGrandtotal := netGrandtotal + r.netValue;
            end;
            if not FInVerifySummation then
            Transaction.ApplicableHeaderTradeSettlement.SpecifiedTradeSettlementHeaderMonetarySummation.ChargeTotalAmount.Value
               := grossChargesTotal; // GROSS
            fMessages.Add(Format('# Charges: net %f gross %f ',[chargesTotal,grossChargesTotal]));
        end;

         // NOW add the addres to the Settlement
        if not FInVerifySummation then
        with THeaderTradeSettlement(Transaction.ApplicableHeaderTradeSettlement) do
        begin
             if PaymentData<>nil then
             begin
                if PaymentData.PaymentTerms<>'' then
                begin
                   SpecifiedTradePaymentTerms.Description.ValueStr := PaymentData.PaymentTerms;
                end
                else
                begin
                    SpecifiedTradePaymentTerms.DueDateDateTime.DateTimeString.Value := PaymentData.DueDateDateTime;
                end;

                // SKONTO
                if (PaymentData.PaymentDiscountTermsDays>0) and
                    not SameValue(PaymentData.PaymentDiscountTermsPercent,0) then
                begin
                    SpecifiedTradePaymentTerms.Description.ValueStr := PaymentData.PaymentDiscountTermsDescription;
                    SpecifiedTradePaymentTerms.ApplicableTradePaymentDiscountTerms.BasisPeriodMeasure.SetValue(
                        IntToStr(PaymentData.Days),{unitCode=}'DAY');
                    SpecifiedTradePaymentTerms.ApplicableTradePaymentDiscountTerms.CalculationPercent.SetValue(
                        PaymentData.PaymentDiscountTermsPercent);
                end;
             end;
        end;

        // NEED to loop all possible VAT elements and add the sums
        // ApplicableTradeTax for EVERY TAX VALUE REPEATED!
        if not FInVerifySummation then
        Transaction.ApplicableHeaderTradeSettlement.ApplicableTradeTax.Clear;

        if not (TWPXOrderCalcMode.VATAddRoundedOnLine in Transaction.CalcModes) then
        begin
           grossChargesTotal := 0;
           grossLineitemTotal := 0;
           grossAllowanceTotal := 0;
           grossGrandtotal := 0;
        end;


        for i:=0 to summationApplicableTradeTax.Count -1 do
        begin
            r := summationApplicableTradeTax[i];
            if not FInVerifySummation then
            with TTradeTax(Transaction.ApplicableHeaderTradeSettlement.ApplicableTradeTax.ListIsFirstOrAdd) do
            begin
               CalculatedAmount.Value :=  r.VATvalue;
               TypeCode.ValueStr := 'VAT';
               if r.VATCategory=TTaxCategory.K_VAT_exempt_for_EEA then
                   ExemptionReason.ValueStr := wpx_tax_no_vat;
               // We use "gross" for allowances and charges
               BasisAmount.Value := r.netValue+r.grossValue;
               // VAT all Items
               LineTotalBasisAmount.Value := r.netValue;
               // VAT all allowances and charges, except of the "Delivery"
               AllowanceChargeBasisAmount.Value := r.grossValue;
               CategoryCode.Value := r.VATCategory;
               RateApplicablePercent.Value := r.VATRate;
            end;

            // For use in  SpecifiedTradeSettlementHeaderMonetarySummation
            if (TWPXOrderCalcMode.VATAddRoundedOnLine in Transaction.CalcModes) then
                vattotal := vattotal + r.VATvalue
            else
            begin
               // This is the default behaviour. Note that we minimize rounding errors since
               // we add all values which belong to a certain VAT-RATE and calculate the VAT and the gross value
               // based on that sum.
               grossChargesTotal := grossChargesTotal + WPXCurrencyRound(r.grossValue/100*(100+r.VATRate));
               grossLineitemTotal:= grossLineitemTotal + WPXCurrencyRound(r.netValue/100*(100+r.VATRate));
               grossGrandtotal := grossGrandtotal + WPXCurrencyRound((r.netValue+ r.grossValue)/100*(100+r.VATRate));
               vattotal := vattotal + WPXCurrencyRound((r.grossValue + r.netValue)/100*r.VATRate );
            end;
        end;

      (*  if  Transaction.ApplicableHeaderTradeSettlement.Has( TXHeaderTradeSettlement.TaxApplicableTradeCurrencyExchange) and
            Transaction.ApplicableHeaderTradeSettlement.TaxApplicableTradeCurrencyExchange.Has( TXTradeCurrencyExchange.ConversionRate ) then
        begin
            conversionrate :=
               Transaction.ApplicableHeaderTradeSettlement.TaxApplicableTradeCurrencyExchange.ConversionRate.Value;
            if conversionrate=0 then
            begin
                fMessages.Add('# Transaction.ApplicableHeaderTradeSettlement.TaxApplicableTradeCurrencyExchange incomplete');
                conversionrate := 1;
            end;
        end else conversionrate := 1;  *)

        if FInVerifySummation then
        with Transaction.ApplicableHeaderTradeSettlement.SpecifiedTradeSettlementHeaderMonetarySummation do
        begin
            fMessages.Add('# SpecifiedTradeSettlementHeaderMonetarySummation calculated / current value');
            fMessages.Add(Format('LineTotalAmount: %f / %f [%s]',[LineitemTotal,LineTotalAmount.value,currency]));
            fMessages.Add(Format('ChargeTotalAmount: %f / %f [%s]',[ChargesTotal,ChargeTotalAmount.Value,currency]));
            fMessages.Add(Format('AllowanceTotalAmount: %f / %f [%s]',[-allowanceTotal,AllowanceTotalAmount.Value,currency]));
            fMessages.Add(Format('TaxBasisTotalAmount: %f / %f [%s]',[netGrandtotal,TaxBasisTotalAmount.Value,currency]));
            fMessages.Add(Format('TaxTotalAmount: %f / %f [%s]',[vattotal,TaxTotalAmount.value,currency]));
            fMessages.Add(Format('GrandTotalAmount: %f / %f [%s]',[grossGrandtotal,GrandTotalAmount.Value,currency]));
            if not SameValue(PrepaidAmount,0) then
            fMessages.Add(Format('PrepaidAmount: %f / %f [%s]',[PrepaidAmount,PrepaidAmount,currency]));
            fMessages.Add(Format('DuePayableAmount: %f / %f [%s]',[(grossLineitemTotal+grossAllowanceTotal+grossChargesTotal-PrepaidAmount),
               DuePayableAmount.Value,currency]));
        end
        else
        with Transaction.ApplicableHeaderTradeSettlement.SpecifiedTradeSettlementHeaderMonetarySummation do
        begin
            Clear;
            LineTotalAmount.value     := LineitemTotal;
            ChargeTotalAmount.Value   := ChargesTotal;
            AllowanceTotalAmount.Value:= -allowanceTotal; // = negative value!
            TaxBasisTotalAmount.Value := netGrandtotal;
            TaxTotalAmount.SetValue( vattotal , InvoiceCurrencyCode);
            GrandTotalAmount.Value    := grossLineitemTotal+grossAllowanceTotal+grossChargesTotal;
            TotalPrepaidAmount.Value  := PrepaidAmount;
            DuePayableAmount.Value    := (grossLineitemTotal+grossAllowanceTotal+grossChargesTotal-PrepaidAmount);
            fMessages.Add(Format('LineTotalAmount: %f %s',[LineitemTotal,currency]));
            fMessages.Add(Format('ChargeTotalAmount: %f %s',[ChargesTotal,currency]));
            fMessages.Add(Format('AllowanceTotalAmount: %f %s',[-allowanceTotal,currency]));
            fMessages.Add(Format('TaxBasisTotalAmount: %f %s',[netGrandtotal,currency]));
            fMessages.Add(Format('TaxTotalAmount: %f %s',[vattotal,currency]));
            fMessages.Add(Format('GrandTotalAmount: %f %s',[grossGrandtotal,currency]));
            fMessages.Add(Format('DuePayableAmount: %f %s',[grossLineitemTotal+grossAllowanceTotal+grossChargesTotal-PrepaidAmount,currency]));
        end;
      end;
      Result := Transaction.ApplicableHeaderTradeSettlement.SpecifiedTradeSettlementHeaderMonetarySummation;
  finally
    summationApplicableTradeTax.Free;
  end;
end;

{ TWPXFacturCompanyRecord }

procedure TCompanyData.Assign(const Source: TCompanyData);
begin
  if Source=nil then  Clear else
  begin
      Name := Source.Name  ;
      DepartmentName := Source.DepartmentName;
      PostcodeCode := Source.PostcodeCode  ;
      Addres   := Source.Addres  ;
      CityName := Source.CityName  ;
      CountryID := Source.CountryID  ;
      TAXId := Source.TAXId  ;
      VATID := Source.VATID  ;
      ContactInfo := Source.ContactInfo  ;
      ID := Source.ID  ;
      GlobalID := Source.GlobalID  ;
      GlobalIDScheme := Source.GlobalIDScheme  ;
  end;
end;

// Assign Info in TCompanyData to TTradeParty Object
procedure TCompanyData.AssignTo(Dest: TTradeParty);
begin
  if Self<>nil then
  begin
    Dest.SaveElementsInSchemeOrder := true; // the validator depends on this!
    Dest.Name.SetValue(Name);
    if DepartmentName<>'' then Dest.DefinedTradeContact.DepartmentName.SetValue(DepartmentName);
    Dest.PostalTradeAddress.PostcodeCode.SetValue(PostcodeCode);
    Dest.PostalTradeAddress.LineOne.SetValue(Addres);
    Dest.PostalTradeAddress.CityName.SetValue(CityName);
    Dest.PostalTradeAddress.CountryID.SetValue(CountryID);

    if ID<>'' then Dest.ID.ValueStr := ID;
    if GlobalID<>'' then Dest.GlobalID.SetValue(GlobalID,GlobalIDScheme);

    if VATID<>'' then Dest.SpecifiedTaxRegistration.ID.SetValue(VATID,TTaxID.VA_VAT_number);

    if SpecifiedLegalOrganization<>'' then
    begin
      Dest.SpecifiedLegalOrganization.ID.SetValue(
          SpecifiedLegalOrganization, {schemeID=}'0002' );
    end;
  end;
end;

procedure TCompanyData.AssignFrom(Source: TTradeParty);
var val : TWPXElement;
begin
  if Source<>nil then
  begin
    // This code reads the value of properties but does not create the elements
    // If they are not existing.
    Source.ReadElementValue([Integer(TXTradeParty.Name)], Name);
    if Source.ReadElementValue([Integer(TXTradeParty.DefinedTradeContact),
            Integer(TXTradeContact.DepartmentName)], val) then
         DepartmentName := val.ValueStr else DepartmentName := '';
    // This code first checks the property exists and then read the values
    Source.ReadElementValue([Integer(TXTradeParty.PostalTradeAddress),
            Integer(TXTradeAddress.PostcodeCode)], PostcodeCode);
    Source.ReadElementValue([Integer(TXTradeParty.PostalTradeAddress),
            Integer(TXTradeAddress.LineOne)], Addres);
    Source.ReadElementValue([Integer(TXTradeParty.PostalTradeAddress),
            Integer(TXTradeAddress.CityName)], CityName);
    if Source.ReadElementValue([Integer(TXTradeParty.PostalTradeAddress),
            Integer(TXTradeAddress.CountryID)], val) then
         CountryIDText := val.ValueStr else CountryID := TCountryID.UNDEFINED;
    Source.ReadElementValue([Integer(TXTradeParty.ID)], ID);
    Source.ReadElementValue([Integer(TXTradeParty.GlobalID)], GlobalID);
    if Source.ReadElementValue([Integer(TXTradeParty.SpecifiedTaxRegistration),
            Integer(TXTaxRegistration.ID)], val) then
         VATID := val.ValueStr else VATID := '';
    if Source.ReadElementValue([Integer(TXTradeParty.SpecifiedLegalOrganization),
            Integer(TXLegalOrganization.ID)], val) then
         SpecifiedLegalOrganization := val.ValueStr else SpecifiedLegalOrganization := '';
  end;
end;

procedure TCompanyData.Clear;
begin
   if Self<>nil then
   begin
      Name  := '';
      DepartmentName  := '';
      PostcodeCode  := '';
      Addres     := '';
      CityName   := '';
      CountryID  := TCountryID.UNDEFINED;
      TAXId := '';
      VATID  := '';
      ContactInfo  := '';
      ID  := '';
      GlobalID := '';
      GlobalIDScheme  := '';
   end;
end;

function TCompanyData.getCountryIDText: String;
begin
   Result := wpxCountryIDContentType[CountryID];
end;


procedure TCompanyData.setCountryIDText(x: String);
var i : TCountryID;
begin
   x := uppercase(x);
   for i := Low(TCountryID) to High(TCountryID) do
      if x=wpxCountryIDContentType[i] then
      begin
          CountryID := i;
          exit;
      end;
   raise Exception.Create('Unknown country code "' + x + '"');
end;

initialization

// Variables needed for wPDF (  https://www.wpcubed.com )  to creat a PDF file with
// the metadata and embedded XML

pdfa_xfactur_schema :=
   '<rdf:li rdf:parseType="Resource">' + #10 +
                  '<pdfaSchema:schema>Factur-X PDFA Extension Schema</pdfaSchema:schema>' + #10 +
                  '<pdfaSchema:namespaceURI>urn:factur-x:pdfa:CrossIndustryDocument:invoice:1p0#</pdfaSchema:namespaceURI>' + #10 +
                  '<pdfaSchema:prefix>fx</pdfaSchema:prefix>' + #10 +
                  '<pdfaSchema:property>' + #10 +
                     '<rdf:Seq>' + #10 +
                        '<rdf:li rdf:parseType="Resource">' + #10 +
                           '<pdfaProperty:name>DocumentFileName</pdfaProperty:name>' + #10 +
                           '<pdfaProperty:valueType>Text</pdfaProperty:valueType>' + #10 +
                           '<pdfaProperty:category>external</pdfaProperty:category>' + #10 +
                           '<pdfaProperty:description>name of the embedded XML invoice file</pdfaProperty:description>' + #10 +
                        '</rdf:li>' + #10 +
                        '<rdf:li rdf:parseType="Resource">' + #10 +
                           '<pdfaProperty:name>DocumentType</pdfaProperty:name> ' + #10 +
                           '<pdfaProperty:valueType>Text</pdfaProperty:valueType>' + #10 +
                           '<pdfaProperty:category>external</pdfaProperty:category>' + #10 +
                           '<pdfaProperty:description>INVOICE</pdfaProperty:description>' + #10 +
                        '</rdf:li> ' + #10 +
                        '<rdf:li rdf:parseType="Resource"> ' + #10 +
                           '<pdfaProperty:name>Version</pdfaProperty:name>' + #10 +
                           '<pdfaProperty:valueType>Text</pdfaProperty:valueType>' + #10 +
                           '<pdfaProperty:category>external</pdfaProperty:category>' + #10 +
                           '<pdfaProperty:description>The actual version of the ZUGFeRD data</pdfaProperty:description>' + #10 +
                        '</rdf:li>' + #10 +
                        '<rdf:li rdf:parseType="Resource">' + #10 +
                           '<pdfaProperty:name>ConformanceLevel</pdfaProperty:name>' + #10 +
                           '<pdfaProperty:valueType>Text</pdfaProperty:valueType>' + #10 +
                           '<pdfaProperty:category>external</pdfaProperty:category>' + #10 +
                           '<pdfaProperty:description>The conformance level of the ZUGFeRD data</pdfaProperty:description>' + #10 +
                        '</rdf:li>' + #10 +
                     '</rdf:Seq> ' + #10 +
                  '</pdfaSchema:property>' + #10 +
               '</rdf:li>';


// First %s for filename, second %s for EXTENDED/BASIC
pdfa_xfactur_info :=
   '<rdf:Description xmlns:fx="urn:factur-x:pdfa:CrossIndustryDocument:invoice:1p0#"' + #32 + 'rdf:about="">' + #10 +
   '<fx:DocumentType>INVOICE</fx:DocumentType>' + #10 +
   '<fx:DocumentFileName>%s</fx:DocumentFileName>' + #10 +
   '<fx:Version>1.0</fx:Version>' + #10 +
   '<fx:ConformanceLevel>%s</fx:ConformanceLevel></rdf:Description>' + #10;
        //      above are real values, should be dynamically created
pdfa_xfactur_LEVEL := 'EXTENDED';
pdfa_xfactur_filename := 'factur-x.xml';
pdfa_xfactur_description := 'Factur-X/ZUGFeRD Rechnung';


end.
