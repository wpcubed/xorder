unit WPXFacturEN16931;
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

interface

uses System.SysUtils, System.Classes, System.Rtti, System.TypInfo,
  System.IOUtils,
  System.StrUtils, System.Types, System.Generics.Collections,
  WPXFacturTypes;

{$REGION 'mostly auto generated from schema'}

// ZUGFerD Types
type
TAdvancePayment=class;
TCreditorFinancialAccount=class;
TCreditorFinancialInstitution=class;
TDebtorFinancialAccount=class;
TDocumentContextParameter=class;
TDocumentLineDocument=class;
TExchangedDocumentContext=class;
TExchangedDocument=class;
THeaderTradeAgreement=class;
THeaderTradeDelivery=class;
THeaderTradeSettlement=class;
TLegalOrganization=class;
TLineTradeAgreement=class;
TLineTradeDelivery=class;
TLineTradeSettlement=class;
TLogisticsServiceCharge=class;
TLogisticsTransportMovement=class;
TProcuringProject=class;
TProductCharacteristic=class;
TProductClassification=class;
TReferencedDocument=class;
TReferencedProduct=class;
TSpecifiedPeriod=class;
TSupplyChainConsignment=class;
TSupplyChainEvent=class;
TSupplyChainTradeLineItem=class;
//TSupplyChainTradeTransaction=class;
TTaxRegistration=class;
TTradeAccountingAccount=class;
TTradeAddress=class;
TTradeAllowanceCharge=class;
TTradeContact=class;
TTradeCountry=class;
TTradeCurrencyExchange=class;
TTradeDeliveryTerms=class;
TTradeParty=class;
TTradePaymentDiscountTerms=class;
TTradePaymentPenaltyTerms=class;
TTradePaymentTerms=class;
TTradePrice=class;
TTradeProductInstance=class;
TTradeProduct=class;
TTradeSettlementFinancialCard=class;
TTradeSettlementHeaderMonetarySummation=class;
TTradeSettlementLineMonetarySummation=class;
TTradeSettlementPaymentMeans=class;
TTradeTax=class;
TUniversalCommunication=class;


TXAdvancePayment = (
	PaidAmount, // name=PaidAmount,type=udt:AmountType
	FormattedReceivedDateTime, // name=FormattedReceivedDateTime,type=qdt:FormattedDateTimeType,minOccurs=0
	IncludedTradeTax // name=IncludedTradeTax,type=ram:TradeTaxType,maxOccurs=unbounded
);
TAdvancePayment=class(TWPXSequence<TXAdvancePayment>)
private
	function get_0: TAmountType;
	function get_1: TFormattedDateTime;
	function get_2: TTradeTax;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property PaidAmount:TAmountType read get_0;
	property FormattedReceivedDateTime:TFormattedDateTime read get_1;
	property IncludedTradeTax:TTradeTax read get_2;
end;

TXCreditorFinancialAccount = (
	IBANID, // name=IBANID,type=udt:IDType,minOccurs=0
	AccountName, // name=AccountName,type=udt:TextType,minOccurs=0
	ProprietaryID // name=ProprietaryID,type=udt:IDType,minOccurs=0
);
TCreditorFinancialAccount=class(TWPXSequence<TXCreditorFinancialAccount>)
private
	function get_0: TIDType;
	function get_1: TTextType;
	function get_2: TIDType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property IBANID:TIDType read get_0;
	property AccountName:TTextType read get_1;
	property ProprietaryID:TIDType read get_2;
end;

TXCreditorFinancialInstitution = (
	BICID // name=BICID,type=udt:IDType
);
TCreditorFinancialInstitution=class(TWPXSequence<TXCreditorFinancialInstitution>)
private
	function get_0: TIDType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property BICID:TIDType read get_0;
end;

TXDebtorFinancialAccount = (
	IBANID // name=IBANID,type=udt:IDType
);
TDebtorFinancialAccount=class(TWPXSequence<TXDebtorFinancialAccount>)
private
	function get_0: TIDType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property IBANID:TIDType read get_0;
end;

TXDocumentContextParameter = (
	ID // name=ID,type=udt:IDType
);
TDocumentContextParameter=class(TWPXSequence<TXDocumentContextParameter>)
private
	function get_0: TIDType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property ID:TIDType read get_0;
end;

TXDocumentLineDocument = (
	LineID, // name=LineID,type=udt:IDType
	ParentLineID, // name=ParentLineID,type=udt:IDType,minOccurs=0
	LineStatusCode, // name=LineStatusCode,type=qdt:LineStatusCodeType,minOccurs=0
	LineStatusReasonCode, // name=LineStatusReasonCode,type=udt:CodeType,minOccurs=0
	IncludedNote // name=IncludedNote,type=ram:NoteType,minOccurs=0,maxOccurs=unbounded
);
TDocumentLineDocument=class(TWPXSequence<TXDocumentLineDocument>)
private
	function get_0: TIDType;
	function get_1: TIDType;
	function get_2: TLineStatusCodeType;
	function get_3: TCodeType;
	function get_4: TNote;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property LineID:TIDType read get_0;
	property ParentLineID:TIDType read get_1;
	property LineStatusCode:TLineStatusCodeType read get_2;
	property LineStatusReasonCode:TCodeType read get_3;
	property IncludedNote:TNote read get_4;
end;

TXExchangedDocumentContext = (
	TestIndicator, // name=TestIndicator,type=udt:IndicatorType,minOccurs=0
	BusinessProcessSpecifiedDocumentContextParameter, // name=BusinessProcessSpecifiedDocumentContextParameter,type=ram:DocumentContextParameterType,minOccurs=0
	GuidelineSpecifiedDocumentContextParameter // name=GuidelineSpecifiedDocumentContextParameter,type=ram:DocumentContextParameterType
);
TExchangedDocumentContext=class(TWPXSequence<TXExchangedDocumentContext>)
private
	function get_0: TIndicator;
	function get_1: TDocumentContextParameter;
	function get_2: TDocumentContextParameter;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
  constructor Create; override;
	property TestIndicator:TIndicator read get_0;
	property BusinessProcessSpecifiedDocumentContextParameter:TDocumentContextParameter read get_1;
	property GuidelineSpecifiedDocumentContextParameter:TDocumentContextParameter read get_2;
end;

TXExchangedDocument = (
	ID, // name=ID,type=udt:IDType
	Name, // name=Name,type=udt:TextType,minOccurs=0
	TypeCode, // name=TypeCode,type=qdt:DocumentCodeType
	IssueDateTime, // name=IssueDateTime,type=udt:DateTimeType
	CopyIndicator, // name=CopyIndicator,type=udt:IndicatorType,minOccurs=0
	LanguageID, // name=LanguageID,type=udt:IDType,minOccurs=0,maxOccurs=unbounded
	IncludedNote, // name=IncludedNote,type=ram:NoteType,minOccurs=0,maxOccurs=unbounded
	EffectiveSpecifiedPeriod // name=EffectiveSpecifiedPeriod,type=ram:SpecifiedPeriodType,minOccurs=0
);
TExchangedDocument=class(TWPXSequence<TXExchangedDocument>)
private
	function get_0: TIDType;
	function get_1: TTextType;
	function get_2: TDocumentCodeType;
	function get_3: TDateTimeType;
	function get_4: TIndicator;
	function get_5: TIDType;
	function get_6: TNote;
	function get_7: TSpecifiedPeriod;
    function XMLNamespace: string;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
  constructor Create; override;
	property ID:TIDType read get_0;
	property Name:TTextType read get_1;
	property TypeCode:TDocumentCodeType read get_2;
	property IssueDateTime:TDateTimeType read get_3;
	property CopyIndicator:TIndicator read get_4;
	property LanguageID:TIDType read get_5;
	property IncludedNote:TNote read get_6;
	property EffectiveSpecifiedPeriod:TSpecifiedPeriod read get_7;
end;

TXHeaderTradeAgreement = (
	BuyerReference, // name=BuyerReference,type=udt:TextType,minOccurs=0
	SellerTradeParty, // name=SellerTradeParty,type=ram:TradePartyType
	BuyerTradeParty, // name=BuyerTradeParty,type=ram:TradePartyType
	SalesAgentTradeParty, // name=SalesAgentTradeParty,type=ram:TradePartyType,minOccurs=0
	BuyerTaxRepresentativeTradeParty, // name=BuyerTaxRepresentativeTradeParty,type=ram:TradePartyType,minOccurs=0
	SellerTaxRepresentativeTradeParty, // name=SellerTaxRepresentativeTradeParty,type=ram:TradePartyType,minOccurs=0
	ProductEndUserTradeParty, // name=ProductEndUserTradeParty,type=ram:TradePartyType,minOccurs=0
	ApplicableTradeDeliveryTerms, // name=ApplicableTradeDeliveryTerms,type=ram:TradeDeliveryTermsType,minOccurs=0
	SellerOrderReferencedDocument, // name=SellerOrderReferencedDocument,type=ram:ReferencedDocumentType,minOccurs=0
	BuyerOrderReferencedDocument, // name=BuyerOrderReferencedDocument,type=ram:ReferencedDocumentType,minOccurs=0
	QuotationReferencedDocument, // name=QuotationReferencedDocument,type=ram:ReferencedDocumentType,minOccurs=0
	ContractReferencedDocument, // name=ContractReferencedDocument,type=ram:ReferencedDocumentType,minOccurs=0
	AdditionalReferencedDocument, // name=AdditionalReferencedDocument,type=ram:ReferencedDocumentType,minOccurs=0,maxOccurs=unbounded
	BuyerAgentTradeParty, // name=BuyerAgentTradeParty,type=ram:TradePartyType,minOccurs=0
	SpecifiedProcuringProject, // name=SpecifiedProcuringProject,type=ram:ProcuringProjectType,minOccurs=0
	UltimateCustomerOrderReferencedDocument // name=UltimateCustomerOrderReferencedDocument,type=ram:ReferencedDocumentType,minOccurs=0,maxOccurs=unbounded
);
THeaderTradeAgreement=class(TWPXSequence<TXHeaderTradeAgreement>)
private
	function get_0: TTextType;
	function get_1: TTradeParty;
	function get_2: TTradeParty;
	function get_3: TTradeParty;
	function get_4: TTradeParty;
	function get_5: TTradeParty;
	function get_6: TTradeParty;
	function get_7: TTradeDeliveryTerms;
	function get_8: TReferencedDocument;
	function get_9: TReferencedDocument;
	function get_10: TReferencedDocument;
	function get_11: TReferencedDocument;
	function get_12: TReferencedDocument;
	function get_13: TTradeParty;
	function get_14: TProcuringProject;
	function get_15: TReferencedDocument;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property BuyerReference:TTextType read get_0;
	property SellerTradeParty:TTradeParty read get_1;
	property BuyerTradeParty:TTradeParty read get_2;
	property SalesAgentTradeParty:TTradeParty read get_3;
	property BuyerTaxRepresentativeTradeParty:TTradeParty read get_4;
	property SellerTaxRepresentativeTradeParty:TTradeParty read get_5;
	property ProductEndUserTradeParty:TTradeParty read get_6;
	property ApplicableTradeDeliveryTerms:TTradeDeliveryTerms read get_7;
	property SellerOrderReferencedDocument:TReferencedDocument read get_8;
	property BuyerOrderReferencedDocument:TReferencedDocument read get_9;
	property QuotationReferencedDocument:TReferencedDocument read get_10;
	property ContractReferencedDocument:TReferencedDocument read get_11;
	property AdditionalReferencedDocument:TReferencedDocument read get_12;
	property BuyerAgentTradeParty:TTradeParty read get_13;
	property SpecifiedProcuringProject:TProcuringProject read get_14;
	property UltimateCustomerOrderReferencedDocument:TReferencedDocument read get_15;
end;

TXHeaderTradeDelivery = (
	RelatedSupplyChainConsignment, // name=RelatedSupplyChainConsignment,type=ram:SupplyChainConsignmentType,minOccurs=0
	ShipToTradeParty, // name=ShipToTradeParty,type=ram:TradePartyType,minOccurs=0
	UltimateShipToTradeParty, // name=UltimateShipToTradeParty,type=ram:TradePartyType,minOccurs=0
	ShipFromTradeParty, // name=ShipFromTradeParty,type=ram:TradePartyType,minOccurs=0
	ActualDeliverySupplyChainEvent, // name=ActualDeliverySupplyChainEvent,type=ram:SupplyChainEventType,minOccurs=0
	DespatchAdviceReferencedDocument, // name=DespatchAdviceReferencedDocument,type=ram:ReferencedDocumentType,minOccurs=0
	ReceivingAdviceReferencedDocument, // name=ReceivingAdviceReferencedDocument,type=ram:ReferencedDocumentType,minOccurs=0
	DeliveryNoteReferencedDocument // name=DeliveryNoteReferencedDocument,type=ram:ReferencedDocumentType,minOccurs=0
);
THeaderTradeDelivery=class(TWPXSequence<TXHeaderTradeDelivery>)
private
	function get_0: TSupplyChainConsignment;
	function get_1: TTradeParty;
	function get_2: TTradeParty;
	function get_3: TTradeParty;
	function get_4: TSupplyChainEvent;
	function get_5: TReferencedDocument;
	function get_6: TReferencedDocument;
	function get_7: TReferencedDocument;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property RelatedSupplyChainConsignment:TSupplyChainConsignment read get_0;
	property ShipToTradeParty:TTradeParty read get_1;
	property UltimateShipToTradeParty:TTradeParty read get_2;
	property ShipFromTradeParty:TTradeParty read get_3;
	property ActualDeliverySupplyChainEvent:TSupplyChainEvent read get_4;
	property DespatchAdviceReferencedDocument:TReferencedDocument read get_5;
	property ReceivingAdviceReferencedDocument:TReferencedDocument read get_6;
	property DeliveryNoteReferencedDocument:TReferencedDocument read get_7;
end;

TXHeaderTradeSettlement = (
	CreditorReferenceID, // name=CreditorReferenceID,type=udt:IDType,minOccurs=0
	PaymentReference, // name=PaymentReference,type=udt:TextType,minOccurs=0
	TaxCurrencyCode, // name=TaxCurrencyCode,type=qdt:CurrencyCodeType,minOccurs=0
	InvoiceCurrencyCode, // name=InvoiceCurrencyCode,type=qdt:CurrencyCodeType
	InvoiceIssuerReference, // name=InvoiceIssuerReference,type=udt:TextType,minOccurs=0
	InvoicerTradeParty, // name=InvoicerTradeParty,type=ram:TradePartyType,minOccurs=0
	InvoiceeTradeParty, // name=InvoiceeTradeParty,type=ram:TradePartyType,minOccurs=0
	PayeeTradeParty, // name=PayeeTradeParty,type=ram:TradePartyType,minOccurs=0
	PayerTradeParty, // name=PayerTradeParty,type=ram:TradePartyType,minOccurs=0
	TaxApplicableTradeCurrencyExchange, // name=TaxApplicableTradeCurrencyExchange,type=ram:TradeCurrencyExchangeType,minOccurs=0
	SpecifiedTradeSettlementPaymentMeans, // name=SpecifiedTradeSettlementPaymentMeans,type=ram:TradeSettlementPaymentMeansType,minOccurs=0,maxOccurs=unbounded
	ApplicableTradeTax, // name=ApplicableTradeTax,type=ram:TradeTaxType,maxOccurs=unbounded
	BillingSpecifiedPeriod, // name=BillingSpecifiedPeriod,type=ram:SpecifiedPeriodType,minOccurs=0
	SpecifiedTradeAllowanceCharge, // name=SpecifiedTradeAllowanceCharge,type=ram:TradeAllowanceChargeType,minOccurs=0,maxOccurs=unbounded
	SpecifiedLogisticsServiceCharge, // name=SpecifiedLogisticsServiceCharge,type=ram:LogisticsServiceChargeType,minOccurs=0,maxOccurs=unbounded
	SpecifiedTradePaymentTerms, // name=SpecifiedTradePaymentTerms,type=ram:TradePaymentTermsType,minOccurs=0,maxOccurs=unbounded
	SpecifiedTradeSettlementHeaderMonetarySummation, // name=SpecifiedTradeSettlementHeaderMonetarySummation,type=ram:TradeSettlementHeaderMonetarySummationType
	InvoiceReferencedDocument, // name=InvoiceReferencedDocument,type=ram:ReferencedDocumentType,minOccurs=0
	ReceivableSpecifiedTradeAccountingAccount, // name=ReceivableSpecifiedTradeAccountingAccount,type=ram:TradeAccountingAccountType,minOccurs=0,maxOccurs=unbounded
	SpecifiedAdvancePayment // name=SpecifiedAdvancePayment,type=ram:AdvancePaymentType,minOccurs=0,maxOccurs=unbounded
);
THeaderTradeSettlement=class(TWPXSequence<TXHeaderTradeSettlement>)
private
	function get_0: TIDType;
	function get_1: TTextType;
	function get_2: TCurrencyCodeType;
	function get_3: TCurrencyCodeType;
	function get_4: TTextType;
	function get_5: TTradeParty;
	function get_6: TTradeParty;
	function get_7: TTradeParty;
	function get_8: TTradeParty;
	function get_9: TTradeCurrencyExchange;
	function get_10: TTradeSettlementPaymentMeans;
	function get_11: TTradeTax;
	function get_12: TSpecifiedPeriod;
	function get_13: TTradeAllowanceCharge;
	function get_14: TLogisticsServiceCharge;
	function get_15: TTradePaymentTerms;
	function get_16: TTradeSettlementHeaderMonetarySummation;
	function get_17: TReferencedDocument;
	function get_18: TTradeAccountingAccount;
	function get_19: TAdvancePayment;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property CreditorReferenceID:TIDType read get_0;
	property PaymentReference:TTextType read get_1;
	property TaxCurrencyCode:TCurrencyCodeType read get_2;
	property InvoiceCurrencyCode:TCurrencyCodeType read get_3;
	property InvoiceIssuerReference:TTextType read get_4;
	property InvoicerTradeParty:TTradeParty read get_5;
	property InvoiceeTradeParty:TTradeParty read get_6;
	property PayeeTradeParty:TTradeParty read get_7;
	property PayerTradeParty:TTradeParty read get_8;
	property TaxApplicableTradeCurrencyExchange:TTradeCurrencyExchange read get_9;
	property SpecifiedTradeSettlementPaymentMeans:TTradeSettlementPaymentMeans read get_10;
	property ApplicableTradeTax:TTradeTax read get_11;
	property BillingSpecifiedPeriod:TSpecifiedPeriod read get_12;
	property SpecifiedTradeAllowanceCharge:TTradeAllowanceCharge read get_13;
	property SpecifiedLogisticsServiceCharge:TLogisticsServiceCharge read get_14;
	property SpecifiedTradePaymentTerms:TTradePaymentTerms read get_15;
	property SpecifiedTradeSettlementHeaderMonetarySummation:TTradeSettlementHeaderMonetarySummation read get_16;
	property InvoiceReferencedDocument:TReferencedDocument read get_17;
	property ReceivableSpecifiedTradeAccountingAccount:TTradeAccountingAccount read get_18;
	property SpecifiedAdvancePayment:TAdvancePayment read get_19;
end;

TXLegalOrganization = (
	ID, // name=ID,type=udt:IDType,minOccurs=0
	TradingBusinessName, // name=TradingBusinessName,type=udt:TextType,minOccurs=0
	PostalTradeAddress // name=PostalTradeAddress,type=ram:TradeAddressType,minOccurs=0
);
TLegalOrganization=class(TWPXSequence<TXLegalOrganization>)
private
	function get_0: TIDType;
	function get_1: TTextType;
	function get_2: TTradeAddress;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property ID:TIDType read get_0;
	property TradingBusinessName:TTextType read get_1;
	property PostalTradeAddress:TTradeAddress read get_2;
end;

TXLineTradeAgreement = (
	BuyerOrderReferencedDocument, // name=BuyerOrderReferencedDocument,type=ram:ReferencedDocumentType,minOccurs=0
	QuotationReferencedDocument, // name=QuotationReferencedDocument,type=ram:ReferencedDocumentType,minOccurs=0
	ContractReferencedDocument, // name=ContractReferencedDocument,type=ram:ReferencedDocumentType,minOccurs=0
	AdditionalReferencedDocument, // name=AdditionalReferencedDocument,type=ram:ReferencedDocumentType,minOccurs=0,maxOccurs=unbounded
	GrossPriceProductTradePrice, // name=GrossPriceProductTradePrice,type=ram:TradePriceType,minOccurs=0
	NetPriceProductTradePrice, // name=NetPriceProductTradePrice,type=ram:TradePriceType
	UltimateCustomerOrderReferencedDocument // name=UltimateCustomerOrderReferencedDocument,type=ram:ReferencedDocumentType,minOccurs=0,maxOccurs=unbounded
);
TLineTradeAgreement=class(TWPXSequence<TXLineTradeAgreement>)
private
	function get_0: TReferencedDocument;
	function get_1: TReferencedDocument;
	function get_2: TReferencedDocument;
	function get_3: TReferencedDocument;
	function get_4: TTradePrice;
	function get_5: TTradePrice;
	function get_6: TReferencedDocument;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property BuyerOrderReferencedDocument:TReferencedDocument read get_0;
	property QuotationReferencedDocument:TReferencedDocument read get_1;
	property ContractReferencedDocument:TReferencedDocument read get_2;
	property AdditionalReferencedDocument:TReferencedDocument read get_3;
	property GrossPriceProductTradePrice:TTradePrice read get_4;
	property NetPriceProductTradePrice:TTradePrice read get_5;
	property UltimateCustomerOrderReferencedDocument:TReferencedDocument read get_6;
end;

TXLineTradeDelivery = (
	BilledQuantity, // name=BilledQuantity,type=udt:QuantityType
	ChargeFreeQuantity, // name=ChargeFreeQuantity,type=udt:QuantityType,minOccurs=0
	PackageQuantity, // name=PackageQuantity,type=udt:QuantityType,minOccurs=0
	ShipToTradeParty, // name=ShipToTradeParty,type=ram:TradePartyType,minOccurs=0
	UltimateShipToTradeParty, // name=UltimateShipToTradeParty,type=ram:TradePartyType,minOccurs=0
	ActualDeliverySupplyChainEvent, // name=ActualDeliverySupplyChainEvent,type=ram:SupplyChainEventType,minOccurs=0
	DespatchAdviceReferencedDocument, // name=DespatchAdviceReferencedDocument,type=ram:ReferencedDocumentType,minOccurs=0
	ReceivingAdviceReferencedDocument, // name=ReceivingAdviceReferencedDocument,type=ram:ReferencedDocumentType,minOccurs=0
	DeliveryNoteReferencedDocument // name=DeliveryNoteReferencedDocument,type=ram:ReferencedDocumentType,minOccurs=0
);
TLineTradeDelivery=class(TWPXSequence<TXLineTradeDelivery>)
private
	function get_0: TQuantityType;
	function get_1: TQuantityType;
	function get_2: TQuantityType;
	function get_3: TTradeParty;
	function get_4: TTradeParty;
	function get_5: TSupplyChainEvent;
	function get_6: TReferencedDocument;
	function get_7: TReferencedDocument;
	function get_8: TReferencedDocument;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property BilledQuantity:TQuantityType read get_0;
	property ChargeFreeQuantity:TQuantityType read get_1;
	property PackageQuantity:TQuantityType read get_2;
	property ShipToTradeParty:TTradeParty read get_3;
	property UltimateShipToTradeParty:TTradeParty read get_4;
	property ActualDeliverySupplyChainEvent:TSupplyChainEvent read get_5;
	property DespatchAdviceReferencedDocument:TReferencedDocument read get_6;
	property ReceivingAdviceReferencedDocument:TReferencedDocument read get_7;
	property DeliveryNoteReferencedDocument:TReferencedDocument read get_8;
end;

TXLineTradeSettlement = (
	ApplicableTradeTax, // name=ApplicableTradeTax,type=ram:TradeTaxType,maxOccurs=unbounded
	BillingSpecifiedPeriod, // name=BillingSpecifiedPeriod,type=ram:SpecifiedPeriodType,minOccurs=0
	SpecifiedTradeAllowanceCharge, // name=SpecifiedTradeAllowanceCharge,type=ram:TradeAllowanceChargeType,minOccurs=0,maxOccurs=unbounded
	SpecifiedTradeSettlementLineMonetarySummation, // name=SpecifiedTradeSettlementLineMonetarySummation,type=ram:TradeSettlementLineMonetarySummationType
	InvoiceReferencedDocument, // name=InvoiceReferencedDocument,type=ram:ReferencedDocumentType,minOccurs=0
	AdditionalReferencedDocument, // name=AdditionalReferencedDocument,type=ram:ReferencedDocumentType,minOccurs=0,maxOccurs=unbounded
	ReceivableSpecifiedTradeAccountingAccount // name=ReceivableSpecifiedTradeAccountingAccount,type=ram:TradeAccountingAccountType,minOccurs=0
);
TLineTradeSettlement=class(TWPXSequence<TXLineTradeSettlement>)
private
	function get_0: TTradeTax;
	function get_1: TSpecifiedPeriod;
	function get_2: TTradeAllowanceCharge;
	function get_3: TTradeSettlementLineMonetarySummation;
	function get_4: TReferencedDocument;
	function get_5: TReferencedDocument;
	function get_6: TTradeAccountingAccount;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property ApplicableTradeTax:TTradeTax read get_0;
	property BillingSpecifiedPeriod:TSpecifiedPeriod read get_1;
	property SpecifiedTradeAllowanceCharge:TTradeAllowanceCharge read get_2;
	property SpecifiedTradeSettlementLineMonetarySummation:TTradeSettlementLineMonetarySummation read get_3;
	property InvoiceReferencedDocument:TReferencedDocument read get_4;
	property AdditionalReferencedDocument:TReferencedDocument read get_5;
	property ReceivableSpecifiedTradeAccountingAccount:TTradeAccountingAccount read get_6;
end;

TXLogisticsServiceCharge = (
	Description, // name=Description,type=udt:TextType
	AppliedAmount, // name=AppliedAmount,type=udt:AmountType
	AppliedTradeTax // name=AppliedTradeTax,type=ram:TradeTaxType,minOccurs=0,maxOccurs=unbounded
);
TLogisticsServiceCharge=class(TWPXSequence<TXLogisticsServiceCharge>)
private
	function get_0: TTextType;
	function get_1: TAmountType;
	function get_2: TTradeTax;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
  function get_ListItem(index : Integer) : TLogisticsServiceCharge;
public
	property Description:TTextType read get_0;
	property AppliedAmount:TAmountType read get_1;
	property AppliedTradeTax:TTradeTax read get_2;
  property ListItem[index : Integer] : TLogisticsServiceCharge read  get_ListItem; default;
end;

TXLogisticsTransportMovement = (
	ModeCode // name=ModeCode,type=qdt:TransportModeCodeType
);
TLogisticsTransportMovement=class(TWPXSequence<TXLogisticsTransportMovement>)
private
	function get_0: TTransportModeCodeType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property ModeCode:TTransportModeCodeType read get_0;
end;



TXProcuringProject = (
	ID, // name=ID,type=udt:IDType
	Name // name=Name,type=udt:TextType
);
TProcuringProject=class(TWPXSequence<TXProcuringProject>)
private
	function get_0: TIDType;
	function get_1: TTextType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property ID:TIDType read get_0;
	property Name:TTextType read get_1;
end;

TXProductCharacteristic = (
	TypeCode, // name=TypeCode,type=udt:CodeType,minOccurs=0
	Description, // name=Description,type=udt:TextType
	ValueMeasure, // name=ValueMeasure,type=udt:MeasureType,minOccurs=0
	Value // name=Value,type=udt:TextType
);
TProductCharacteristic=class(TWPXSequence<TXProductCharacteristic>)
private
	function get_0: TCodeType;
	function get_1: TTextType;
	function get_2: TMeasureType;
	function get_3: TTextType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property TypeCode:TCodeType read get_0;
	property Description:TTextType read get_1;
	property ValueMeasure:TMeasureType read get_2;
	property Value:TTextType read get_3;
end;

TXProductClassification = (
	ClassCode, // name=ClassCode,type=udt:CodeType,minOccurs=0
	ClassName // name=ClassName,type=udt:TextType,minOccurs=0
);
TProductClassification=class(TWPXSequence<TXProductClassification>)
private
	function get_0: TCodeType;
	function get_1: TTextType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property ClassCode:TCodeType read get_0;
	property ClassName:TTextType read get_1;
end;

TXReferencedDocument = (
	IssuerAssignedID, // name=IssuerAssignedID,type=udt:IDType,minOccurs=0
	URIID, // name=URIID,type=udt:IDType,minOccurs=0
	LineID, // name=LineID,type=udt:IDType,minOccurs=0
	TypeCode, // name=TypeCode,type=qdt:DocumentCodeType,minOccurs=0
	Name, // name=Name,type=udt:TextType,minOccurs=0,maxOccurs=unbounded
	AttachmentBinaryObject, // name=AttachmentBinaryObject,type=udt:BinaryObjectType,minOccurs=0
	ReferenceTypeCode, // name=ReferenceTypeCode,type=qdt:ReferenceCodeType,minOccurs=0
	FormattedIssueDateTime // name=FormattedIssueDateTime,type=qdt:FormattedDateTimeType,minOccurs=0
);
TReferencedDocument=class(TWPXSequence<TXReferencedDocument>)
private
	function get_0: TIDType;
	function get_1: TIDType;
	function get_2: TIDType;
	function get_3: TDocumentCodeType;
	function get_4: TTextType;
	function get_5: TBinaryObjectType;
	function get_6: TReferenceCodeType;
	function get_7: TFormattedDateTime;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
  function get_ListItem(index : Integer) : TReferencedDocument;
public
	property IssuerAssignedID:TIDType read get_0;
	property URIID:TIDType read get_1;
	property LineID:TIDType read get_2;
	property TypeCode:TDocumentCodeType read get_3;
	property Name:TTextType read get_4;
	property AttachmentBinaryObject:TBinaryObjectType read get_5;
	property ReferenceTypeCode:TReferenceCodeType read get_6;
	property FormattedIssueDateTime:TFormattedDateTime read get_7;
  property ListItem[index : Integer] : TReferencedDocument read  get_ListItem; default;
end;

TXReferencedProduct = (
	ID, // name=ID,type=udt:IDType,minOccurs=0
	GlobalID, // name=GlobalID,type=udt:IDType,minOccurs=0,maxOccurs=unbounded
	SellerAssignedID, // name=SellerAssignedID,type=udt:IDType,minOccurs=0
	BuyerAssignedID, // name=BuyerAssignedID,type=udt:IDType,minOccurs=0
	IndustryAssignedID, // name=IndustryAssignedID,type=udt:IDType,minOccurs=0
	Name, // name=Name,type=udt:TextType
	Description, // name=Description,type=udt:TextType,minOccurs=0
	UnitQuantity // name=UnitQuantity,type=udt:QuantityType,minOccurs=0
);
TReferencedProduct=class(TWPXSequence<TXReferencedProduct>)
private
	function get_0: TIDType;
	function get_1: TIDType;
	function get_2: TIDType;
	function get_3: TIDType;
	function get_4: TIDType;
	function get_5: TTextType;
	function get_6: TTextType;
	function get_7: TQuantityType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
  function get_ListItem(index : Integer) : TReferencedProduct;
public
	property ID:TIDType read get_0;
	property GlobalID:TIDType read get_1;
	property SellerAssignedID:TIDType read get_2;
	property BuyerAssignedID:TIDType read get_3;
	property IndustryAssignedID:TIDType read get_4;
	property Name:TTextType read get_5;
	property Description:TTextType read get_6;
	property UnitQuantity:TQuantityType read get_7;
  property ListItem[index : Integer] : TReferencedProduct read  get_ListItem; default;
end;

TXSpecifiedPeriod = (
	Description, // name=Description,type=udt:TextType,minOccurs=0
	StartDateTime, // name=StartDateTime,type=udt:DateTimeType,minOccurs=0
	EndDateTime, // name=EndDateTime,type=udt:DateTimeType,minOccurs=0
	CompleteDateTime // name=CompleteDateTime,type=udt:DateTimeType,minOccurs=0
);
TSpecifiedPeriod=class(TWPXSequence<TXSpecifiedPeriod>)
private
	function get_0: TTextType;
	function get_1: TDateTimeType;
	function get_2: TDateTimeType;
	function get_3: TDateTimeType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property Description:TTextType read get_0;
	property StartDateTime:TDateTimeType read get_1;
	property EndDateTime:TDateTimeType read get_2;
	property CompleteDateTime:TDateTimeType read get_3;
end;

TXSupplyChainConsignment = (
	SpecifiedLogisticsTransportMovement // name=SpecifiedLogisticsTransportMovement,type=ram:LogisticsTransportMovementType,minOccurs=0,maxOccurs=unbounded
);
TSupplyChainConsignment=class(TWPXSequence<TXSupplyChainConsignment>)
private
	function get_0: TLogisticsTransportMovement;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property SpecifiedLogisticsTransportMovement:TLogisticsTransportMovement read get_0;
end;

TXSupplyChainEvent = (
	OccurrenceDateTime // name=OccurrenceDateTime,type=udt:DateTimeType
);
TSupplyChainEvent=class(TWPXSequence<TXSupplyChainEvent>)
private
	function get_0: TDateTimeType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property OccurrenceDateTime:TDateTimeType read get_0;
end;

TXSupplyChainTradeLineItem = (
	AssociatedDocumentLineDocument, // name=AssociatedDocumentLineDocument,type=ram:DocumentLineDocumentType
	SpecifiedTradeProduct, // name=SpecifiedTradeProduct,type=ram:TradeProductType
	SpecifiedLineTradeAgreement, // name=SpecifiedLineTradeAgreement,type=ram:LineTradeAgreementType
	SpecifiedLineTradeDelivery, // name=SpecifiedLineTradeDelivery,type=ram:LineTradeDeliveryType
	SpecifiedLineTradeSettlement // name=SpecifiedLineTradeSettlement,type=ram:LineTradeSettlementType
);
TSupplyChainTradeLineItem=class(TWPXSequence<TXSupplyChainTradeLineItem>)
private
	function get_0: TDocumentLineDocument;
	function get_1: TTradeProduct;
	function get_2: TLineTradeAgreement;
	function get_3: TLineTradeDelivery;
	function get_4: TLineTradeSettlement;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property AssociatedDocumentLineDocument:TDocumentLineDocument read get_0;
	property SpecifiedTradeProduct:TTradeProduct read get_1;
	property SpecifiedLineTradeAgreement:TLineTradeAgreement read get_2;
	property SpecifiedLineTradeDelivery:TLineTradeDelivery read get_3;
	property SpecifiedLineTradeSettlement:TLineTradeSettlement read get_4;
end;

(*
TXSupplyChainTradeTransaction = (
	IncludedSupplyChainTradeLineItem, // name=IncludedSupplyChainTradeLineItem,type=ram:SupplyChainTradeLineItemType,maxOccurs=unbounded
	ApplicableHeaderTradeAgreement, // name=ApplicableHeaderTradeAgreement,type=ram:HeaderTradeAgreementType
	ApplicableHeaderTradeDelivery, // name=ApplicableHeaderTradeDelivery,type=ram:HeaderTradeDeliveryType
	ApplicableHeaderTradeSettlement // name=ApplicableHeaderTradeSettlement,type=ram:HeaderTradeSettlementType
);
TSupplyChainTradeTransaction=class(TWPXSequence<TXSupplyChainTradeTransaction>)
private
	function get_0: TSupplyChainTradeLineItem;
	function get_1: THeaderTradeAgreement;
	function get_2: THeaderTradeDelivery;
	function get_3: THeaderTradeSettlement;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property IncludedSupplyChainTradeLineItem:TSupplyChainTradeLineItem read get_0;
	property ApplicableHeaderTradeAgreement:THeaderTradeAgreement read get_1;
	property ApplicableHeaderTradeDelivery:THeaderTradeDelivery read get_2;
	property ApplicableHeaderTradeSettlement:THeaderTradeSettlement read get_3;
end;*)

TXTaxRegistration = (
	ID // name=ID,type=udt:IDType
);
TTaxRegistration=class(TWPXSequence<TXTaxRegistration>)
private
	function get_0: TTaxIDType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
  function get_ListItem(index : Integer) : TTaxRegistration;
public
	property ID:TTaxIDType read get_0;
  property ListItem[index : Integer] : TTaxRegistration read  get_ListItem; default;
end;

TXTradeAccountingAccount = (
	ID, // name=ID,type=udt:IDType
	TypeCode // name=TypeCode,type=qdt:AccountingAccountTypeCodeType,minOccurs=0
);
TTradeAccountingAccount=class(TWPXSequence<TXTradeAccountingAccount>)
private
	function get_0: TIDType;
	function get_1: TAccountingAccountTypeCodeType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property ID:TIDType read get_0;
	property TypeCode:TAccountingAccountTypeCodeType read get_1;
end;

TXTradeAddress = (
	PostcodeCode, // name=PostcodeCode,type=udt:CodeType,minOccurs=0
	LineOne, // name=LineOne,type=udt:TextType,minOccurs=0
	LineTwo, // name=LineTwo,type=udt:TextType,minOccurs=0
	LineThree, // name=LineThree,type=udt:TextType,minOccurs=0
	CityName, // name=CityName,type=udt:TextType,minOccurs=0
	CountryID, // name=CountryID,type=qdt:CountryIDType
	CountrySubDivisionName // name=CountrySubDivisionName,type=udt:TextType,minOccurs=0,maxOccurs=unbounded
);
TTradeAddress=class(TWPXSequence<TXTradeAddress>)
private
	function get_0: TCodeType;
	function get_1: TTextType;
	function get_2: TTextType;
	function get_3: TTextType;
	function get_4: TTextType;
	function get_5: TCountryIDType;
	function get_6: TTextType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property PostcodeCode:TCodeType read get_0;
	property LineOne:TTextType read get_1;
	property LineTwo:TTextType read get_2;
	property LineThree:TTextType read get_3;
	property CityName:TTextType read get_4;
	property CountryID:TCountryIDType read get_5;
	property CountrySubDivisionName:TTextType read get_6;
end;

TXTradeAllowanceCharge = (
	ChargeIndicator, // name=ChargeIndicator,type=udt:IndicatorType
	SequenceNumeric, // name=SequenceNumeric,type=udt:NumericType,minOccurs=0
	CalculationPercent, // name=CalculationPercent,type=udt:PercentType,minOccurs=0
	BasisAmount, // name=BasisAmount,type=udt:AmountType,minOccurs=0
	BasisQuantity, // name=BasisQuantity,type=udt:QuantityType,minOccurs=0
	ActualAmount, // name=ActualAmount,type=udt:AmountType
	ReasonCode, // name=ReasonCode,type=qdt:AllowanceChargeReasonCodeType,minOccurs=0
	Reason, // name=Reason,type=udt:TextType,minOccurs=0
	CategoryTradeTax // name=CategoryTradeTax,type=ram:TradeTaxType,minOccurs=0
);
TTradeAllowanceCharge=class(TWPXSequence<TXTradeAllowanceCharge>)
private
	function get_0: TIndicator;
	function get_1: TNumericType;
	function get_2: TPercentType;
	function get_3: TAmountType;
	function get_4: TQuantityType;
	function get_5: TAmountType;
	function get_6: TAllowanceChargeReasonCodeType;
	function get_7: TTextType;
	function get_8: TTradeTax;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
  function get_ListItem(index : Integer) : TTradeAllowanceCharge;
public
	property ChargeIndicator:TIndicator read get_0;
	property SequenceNumeric:TNumericType read get_1;
	property CalculationPercent:TPercentType read get_2;
	property BasisAmount:TAmountType read get_3;
	property BasisQuantity:TQuantityType read get_4;
	property ActualAmount:TAmountType read get_5;
	property ReasonCode:TAllowanceChargeReasonCodeType read get_6;
	property Reason:TTextType read get_7;
	property CategoryTradeTax:TTradeTax read get_8;
  property ListItem[index : Integer] : TTradeAllowanceCharge read  get_ListItem; default;
end;

TXTradeContact = (
	PersonName, // name=PersonName,type=udt:TextType,minOccurs=0
	DepartmentName, // name=DepartmentName,type=udt:TextType,minOccurs=0
	TypeCode, // name=TypeCode,type=qdt:ContactTypeCodeType,minOccurs=0
	TelephoneUniversalCommunication, // name=TelephoneUniversalCommunication,type=ram:UniversalCommunicationType,minOccurs=0
	FaxUniversalCommunication, // name=FaxUniversalCommunication,type=ram:UniversalCommunicationType,minOccurs=0
	EmailURIUniversalCommunication // name=EmailURIUniversalCommunication,type=ram:UniversalCommunicationType,minOccurs=0
);
TTradeContact=class(TWPXSequence<TXTradeContact>)
private
	function get_0: TTextType;
	function get_1: TTextType;
	function get_2: TContactTypeCodeType;
	function get_3: TUniversalCommunication;
	function get_4: TUniversalCommunication;
	function get_5: TUniversalCommunication;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property PersonName:TTextType read get_0;
	property DepartmentName:TTextType read get_1;
	property TypeCode:TContactTypeCodeType read get_2;
	property TelephoneUniversalCommunication:TUniversalCommunication read get_3;
	property FaxUniversalCommunication:TUniversalCommunication read get_4;
	property EmailURIUniversalCommunication:TUniversalCommunication read get_5;
end;

TXTradeCountry = (
	ID // name=ID,type=qdt:CountryIDType,minOccurs=0
);
TTradeCountry=class(TWPXSequence<TXTradeCountry>)
private
	function get_0: TCountryIDType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property ID:TCountryIDType read get_0;
end;

TXTradeCurrencyExchange = (
	SourceCurrencyCode, // name=SourceCurrencyCode,type=qdt:CurrencyCodeType
	TargetCurrencyCode, // name=TargetCurrencyCode,type=qdt:CurrencyCodeType
	ConversionRate, // name=ConversionRate,type=udt:RateType
	ConversionRateDateTime // name=ConversionRateDateTime,type=udt:DateTimeType,minOccurs=0
);
TTradeCurrencyExchange=class(TWPXSequence<TXTradeCurrencyExchange>)
private
	function get_0: TCurrencyCodeType;
	function get_1: TCurrencyCodeType;
	function get_2: TRateType;
	function get_3: TDateTimeType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property SourceCurrencyCode:TCurrencyCodeType read get_0;
	property TargetCurrencyCode:TCurrencyCodeType read get_1;
	property ConversionRate:TRateType read get_2;
	property ConversionRateDateTime:TDateTimeType read get_3;
end;

TXTradeDeliveryTerms = (
	DeliveryTypeCode // name=DeliveryTypeCode,type=qdt:DeliveryTermsCodeType
);
TTradeDeliveryTerms=class(TWPXSequence<TXTradeDeliveryTerms>)
private
	function get_0: TDeliveryTermsCodeType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property DeliveryTypeCode:TDeliveryTermsCodeType read get_0;
end;

TXTradeParty = (
	ID, // name=ID,type=udt:IDType,minOccurs=0,maxOccurs=unbounded
	GlobalID, // name=GlobalID,type=udt:IDType,minOccurs=0,maxOccurs=unbounded
	Name, // name=Name,type=udt:TextType,minOccurs=0
	RoleCode, // name=RoleCode,type=qdt:PartyRoleCodeType,minOccurs=0
	Description, // name=Description,type=udt:TextType,minOccurs=0
	SpecifiedLegalOrganization, // name=SpecifiedLegalOrganization,type=ram:LegalOrganizationType,minOccurs=0
	DefinedTradeContact, // name=DefinedTradeContact,type=ram:TradeContactType,minOccurs=0,maxOccurs=unbounded
	PostalTradeAddress, // name=PostalTradeAddress,type=ram:TradeAddressType,minOccurs=0
	URIUniversalCommunication, // name=URIUniversalCommunication,type=ram:UniversalCommunicationType,minOccurs=0
	SpecifiedTaxRegistration // name=SpecifiedTaxRegistration,type=ram:TaxRegistrationType,minOccurs=0,maxOccurs=unbounded
);
TTradeParty=class(TWPXSequence<TXTradeParty>)
private
	function get_0: TIDType;
	function get_1: TIDType;
	function get_2: TTextType;
	function get_3: TPartyRoleCodeType;
	function get_4: TTextType;
	function get_5: TLegalOrganization;
	function get_6: TTradeContact;
	function get_7: TTradeAddress;
	function get_8: TUniversalCommunication;
	function get_9: TTaxRegistration;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
  // An identification of the seller.
	property ID:TIDType read get_0;
  // Global identifier of the seller: GLN, DUNS, BIC, ODETTE, ...
	property GlobalID:TIDType read get_1;
	property Name:TTextType read get_2;
	property RoleCode:TPartyRoleCodeType read get_3;
	property Description:TTextType read get_4;
	property SpecifiedLegalOrganization:TLegalOrganization read get_5;
	property DefinedTradeContact:TTradeContact read get_6;
	property PostalTradeAddress:TTradeAddress read get_7;
	property URIUniversalCommunication:TUniversalCommunication read get_8;
  { The local identification (defined by the seller’s address)
    of the seller for tax purposes or a reference
    that enables the seller to state his registered tax status.
    Seller tax registration identifier }
	property SpecifiedTaxRegistration:TTaxRegistration read get_9;
end;

TXTradePaymentDiscountTerms = (
	BasisDateTime, // name=BasisDateTime,type=udt:DateTimeType,minOccurs=0
	BasisPeriodMeasure, // name=BasisPeriodMeasure,type=udt:MeasureType,minOccurs=0
	BasisAmount, // name=BasisAmount,type=udt:AmountType,minOccurs=0
	CalculationPercent, // name=CalculationPercent,type=udt:PercentType,minOccurs=0
	ActualDiscountAmount // name=ActualDiscountAmount,type=udt:AmountType,minOccurs=0
);
TTradePaymentDiscountTerms=class(TWPXSequence<TXTradePaymentDiscountTerms>)
private
	function get_0: TDateTimeType;
	function get_1: TMeasureType;
	function get_2: TAmountType;
	function get_3: TPercentType;
	function get_4: TAmountType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property BasisDateTime:TDateTimeType read get_0;
	property BasisPeriodMeasure:TMeasureType read get_1;
	property BasisAmount:TAmountType read get_2;
	property CalculationPercent:TPercentType read get_3;
	property ActualDiscountAmount:TAmountType read get_4;
end;

TXTradePaymentPenaltyTerms = (
	BasisDateTime, // name=BasisDateTime,type=udt:DateTimeType,minOccurs=0
	BasisPeriodMeasure, // name=BasisPeriodMeasure,type=udt:MeasureType,minOccurs=0
	BasisAmount, // name=BasisAmount,type=udt:AmountType,minOccurs=0
	CalculationPercent, // name=CalculationPercent,type=udt:PercentType,minOccurs=0
	ActualPenaltyAmount // name=ActualPenaltyAmount,type=udt:AmountType,minOccurs=0
);
TTradePaymentPenaltyTerms=class(TWPXSequence<TXTradePaymentPenaltyTerms>)
private
	function get_0: TDateTimeType;
	function get_1: TMeasureType;
	function get_2: TAmountType;
	function get_3: TPercentType;
	function get_4: TAmountType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property BasisDateTime:TDateTimeType read get_0;
	property BasisPeriodMeasure:TMeasureType read get_1;
	property BasisAmount:TAmountType read get_2;
	property CalculationPercent:TPercentType read get_3;
	property ActualPenaltyAmount:TAmountType read get_4;
end;

TXTradePaymentTerms = (
	Description, // name=Description,type=udt:TextType,minOccurs=0
	DueDateDateTime, // name=DueDateDateTime,type=udt:DateTimeType,minOccurs=0
	DirectDebitMandateID, // name=DirectDebitMandateID,type=udt:IDType,minOccurs=0
	PartialPaymentAmount, // name=PartialPaymentAmount,type=udt:AmountType,minOccurs=0
	ApplicableTradePaymentPenaltyTerms, // name=ApplicableTradePaymentPenaltyTerms,type=ram:TradePaymentPenaltyTermsType,minOccurs=0
	ApplicableTradePaymentDiscountTerms, // name=ApplicableTradePaymentDiscountTerms,type=ram:TradePaymentDiscountTermsType,minOccurs=0
	PayeeTradeParty // name=PayeeTradeParty,type=ram:TradePartyType,minOccurs=0
);
TTradePaymentTerms=class(TWPXSequence<TXTradePaymentTerms>)
private
	function get_0: TTextType;
	function get_1: TDateTimeType;
	function get_2: TIDType;
	function get_3: TAmountType;
	function get_4: TTradePaymentPenaltyTerms;
	function get_5: TTradePaymentDiscountTerms;
	function get_6: TTradeParty;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
  function get_ListItem(index : Integer) : TTradePaymentTerms;
public

	property Description:TTextType read get_0;
	property DueDateDateTime:TDateTimeType read get_1;
	property DirectDebitMandateID:TIDType read get_2;
	property PartialPaymentAmount:TAmountType read get_3;
	property ApplicableTradePaymentPenaltyTerms:TTradePaymentPenaltyTerms read get_4;
	property ApplicableTradePaymentDiscountTerms:TTradePaymentDiscountTerms read get_5;
	property PayeeTradeParty:TTradeParty read get_6;
  property ListItem[index : Integer] : TTradePaymentTerms read get_ListItem; default;
end;

TXTradePrice = (
	ChargeAmount, // name=ChargeAmount,type=udt:AmountType
	BasisQuantity, // name=BasisQuantity,type=udt:QuantityType,minOccurs=0
	AppliedTradeAllowanceCharge, // name=AppliedTradeAllowanceCharge,type=ram:TradeAllowanceChargeType,minOccurs=0,maxOccurs=unbounded
	IncludedTradeTax // name=IncludedTradeTax,type=ram:TradeTaxType,minOccurs=0
);
TTradePrice=class(TWPXSequence<TXTradePrice>)
private
	function get_0: TAmountType;
	function get_1: TQuantityType;
	function get_2: TTradeAllowanceCharge;
	function get_3: TTradeTax;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property ChargeAmount:TAmountType read get_0;
	property BasisQuantity:TQuantityType read get_1;
	property AppliedTradeAllowanceCharge:TTradeAllowanceCharge read get_2;
	property IncludedTradeTax:TTradeTax read get_3;
end;

TXTradeProductInstance = (
	BatchID, // name=BatchID,type=udt:IDType,minOccurs=0
	SupplierAssignedSerialID // name=SupplierAssignedSerialID,type=udt:IDType,minOccurs=0
);
TTradeProductInstance=class(TWPXSequence<TXTradeProductInstance>)
private
	function get_0: TIDType;
	function get_1: TIDType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property BatchID:TIDType read get_0;
	property SupplierAssignedSerialID:TIDType read get_1;
end;

TXTradeProduct = (
	ID, // name=ID,type=udt:IDType,minOccurs=0
	GlobalID, // name=GlobalID,type=udt:IDType,minOccurs=0
	SellerAssignedID, // name=SellerAssignedID,type=udt:IDType,minOccurs=0
	BuyerAssignedID, // name=BuyerAssignedID,type=udt:IDType,minOccurs=0
	Name, // name=Name,type=udt:TextType
	Description, // name=Description,type=udt:TextType,minOccurs=0
	ApplicableProductCharacteristic, // name=ApplicableProductCharacteristic,type=ram:ProductCharacteristicType,minOccurs=0,maxOccurs=unbounded
	DesignatedProductClassification, // name=DesignatedProductClassification,type=ram:ProductClassificationType,minOccurs=0,maxOccurs=unbounded
	IndividualTradeProductInstance, // name=IndividualTradeProductInstance,type=ram:TradeProductInstanceType,minOccurs=0,maxOccurs=unbounded
	OriginTradeCountry, // name=OriginTradeCountry,type=ram:TradeCountryType,minOccurs=0
	IncludedReferencedProduct // name=IncludedReferencedProduct,type=ram:ReferencedProductType,minOccurs=0,maxOccurs=unbounded
);
TTradeProduct=class(TWPXSequence<TXTradeProduct>)
private
	function get_0: TIDType;
	function get_1: TIDType;
	function get_2: TIDType;
	function get_3: TIDType;
	function get_4: TTextType;
	function get_5: TTextType;
	function get_6: TProductCharacteristic;
	function get_7: TProductClassification;
	function get_8: TTradeProductInstance;
	function get_9: TTradeCountry;
	function get_10: TReferencedProduct;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property ID:TIDType read get_0;
	property GlobalID:TIDType read get_1;
	property SellerAssignedID:TIDType read get_2;
	property BuyerAssignedID:TIDType read get_3;
	property Name:TTextType read get_4;
	property Description:TTextType read get_5;
	property ApplicableProductCharacteristic:TProductCharacteristic read get_6;
	property DesignatedProductClassification:TProductClassification read get_7;
	property IndividualTradeProductInstance:TTradeProductInstance read get_8;
	property OriginTradeCountry:TTradeCountry read get_9;
	property IncludedReferencedProduct:TReferencedProduct read get_10;
end;

TXTradeSettlementFinancialCard = (
	ID, // name=ID,type=udt:IDType
	CardholderName // name=CardholderName,type=udt:TextType,minOccurs=0
);
TTradeSettlementFinancialCard=class(TWPXSequence<TXTradeSettlementFinancialCard>)
private
	function get_0: TIDType;
	function get_1: TTextType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property ID:TIDType read get_0;
	property CardholderName:TTextType read get_1;
end;

TXTradeSettlementHeaderMonetarySummation = (
	LineTotalAmount, // name=LineTotalAmount,type=udt:AmountType
	ChargeTotalAmount, // name=ChargeTotalAmount,type=udt:AmountType,minOccurs=0
	AllowanceTotalAmount, // name=AllowanceTotalAmount,type=udt:AmountType,minOccurs=0
	TaxBasisTotalAmount, // name=TaxBasisTotalAmount,type=udt:AmountType,maxOccurs=2
	TaxTotalAmount, // name=TaxTotalAmount,type=udt:AmountType,minOccurs=0,maxOccurs=2
	RoundingAmount, // name=RoundingAmount,type=udt:AmountType,minOccurs=0
	GrandTotalAmount, // name=GrandTotalAmount,type=udt:AmountType,maxOccurs=2
	TotalPrepaidAmount, // name=TotalPrepaidAmount,type=udt:AmountType,minOccurs=0
	DuePayableAmount // name=DuePayableAmount,type=udt:AmountType
);
TTradeSettlementHeaderMonetarySummation=class(TWPXSequence<TXTradeSettlementHeaderMonetarySummation>)
private
	function get_0: TAmountType;
	function get_1: TAmountType;
	function get_2: TAmountType;
	function get_3: TAmountType;
	function get_4: TAmountListType;
	function get_5: TAmountType;
	function get_6: TAmountType;
	function get_7: TAmountType;
	function get_8: TAmountType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property LineTotalAmount:TAmountType read get_0;
	property ChargeTotalAmount:TAmountType read get_1;
	property AllowanceTotalAmount:TAmountType read get_2;
	property TaxBasisTotalAmount:TAmountType read get_3;
	property TaxTotalAmount:TAmountListType read get_4;
	property RoundingAmount:TAmountType read get_5;
	property GrandTotalAmount:TAmountType read get_6;
	property TotalPrepaidAmount:TAmountType read get_7;
	property DuePayableAmount:TAmountType read get_8;
end;

TXTradeSettlementLineMonetarySummation = (
	LineTotalAmount, // name=LineTotalAmount,type=udt:AmountType
	ChargeTotalAmount, // name=ChargeTotalAmount,type=udt:AmountType,minOccurs=0
	AllowanceTotalAmount, // name=AllowanceTotalAmount,type=udt:AmountType,minOccurs=0
	TaxTotalAmount, // name=TaxTotalAmount,type=udt:AmountType,minOccurs=0
	GrandTotalAmount, // name=GrandTotalAmount,type=udt:AmountType,minOccurs=0
	TotalAllowanceChargeAmount // name=TotalAllowanceChargeAmount,type=udt:AmountType,minOccurs=0
);
TTradeSettlementLineMonetarySummation=class(TWPXSequence<TXTradeSettlementLineMonetarySummation>)
private
	function get_0: TAmountType;
	function get_1: TAmountType;
	function get_2: TAmountType;
	function get_3: TAmountType;
	function get_4: TAmountType;
	function get_5: TAmountType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property LineTotalAmount:TAmountType read get_0;
	property ChargeTotalAmount:TAmountType read get_1;
	property AllowanceTotalAmount:TAmountType read get_2;
	property TaxTotalAmount:TAmountType read get_3;
	property GrandTotalAmount:TAmountType read get_4;
	property TotalAllowanceChargeAmount:TAmountType read get_5;
end;

TXTradeSettlementPaymentMeans = (
	TypeCode, // name=TypeCode,type=qdt:PaymentMeansCodeType
	Information, // name=Information,type=udt:TextType,minOccurs=0
	ApplicableTradeSettlementFinancialCard, // name=ApplicableTradeSettlementFinancialCard,type=ram:TradeSettlementFinancialCardType,minOccurs=0
	PayerPartyDebtorFinancialAccount, // name=PayerPartyDebtorFinancialAccount,type=ram:DebtorFinancialAccountType,minOccurs=0
	PayeePartyCreditorFinancialAccount, // name=PayeePartyCreditorFinancialAccount,type=ram:CreditorFinancialAccountType,minOccurs=0
	PayeeSpecifiedCreditorFinancialInstitution // name=PayeeSpecifiedCreditorFinancialInstitution,type=ram:CreditorFinancialInstitutionType,minOccurs=0
);
TTradeSettlementPaymentMeans=class(TWPXSequence<TXTradeSettlementPaymentMeans>)
private
	function get_0: TPaymentMeansCodeType;
	function get_1: TTextType;
	function get_2: TTradeSettlementFinancialCard;
	function get_3: TDebtorFinancialAccount;
	function get_4: TCreditorFinancialAccount;
	function get_5: TCreditorFinancialInstitution;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property TypeCode:TPaymentMeansCodeType read get_0;
	property Information:TTextType read get_1;
	property ApplicableTradeSettlementFinancialCard:TTradeSettlementFinancialCard read get_2;
	property PayerPartyDebtorFinancialAccount:TDebtorFinancialAccount read get_3;
	property PayeePartyCreditorFinancialAccount:TCreditorFinancialAccount read get_4;
	property PayeeSpecifiedCreditorFinancialInstitution:TCreditorFinancialInstitution read get_5;
end;

TXTradeTax = (
	CalculatedAmount, // name=CalculatedAmount,type=udt:AmountType,minOccurs=0
	TypeCode, // name=TypeCode,type=qdt:TaxTypeCodeType,minOccurs=0
	ExemptionReason, // name=ExemptionReason,type=udt:TextType,minOccurs=0
	BasisAmount, // name=BasisAmount,type=udt:AmountType,minOccurs=0
	LineTotalBasisAmount, // name=LineTotalBasisAmount,type=udt:AmountType,minOccurs=0
	AllowanceChargeBasisAmount, // name=AllowanceChargeBasisAmount,type=udt:AmountType,minOccurs=0
	CategoryCode, // name=CategoryCode,type=qdt:TaxCategoryCodeType
	ExemptionReasonCode, // name=ExemptionReasonCode,type=udt:CodeType,minOccurs=0
	TaxPointDate, // name=TaxPointDate,type=udt:DateType,minOccurs=0
	DueDateTypeCode, // name=DueDateTypeCode,type=qdt:TimeReferenceCodeType,minOccurs=0
	RateApplicablePercent // name=RateApplicablePercent,type=udt:PercentType,minOccurs=0
);
TTradeTax=class(TWPXSequence<TXTradeTax>)
private
	function get_0: TAmountType;
	function get_1: TTaxTypeCodeType;
	function get_2: TTextType;
	function get_3: TAmountType;
	function get_4: TAmountType;
	function get_5: TAmountType;
	function get_6: TTaxCategoryCodeType;
	function get_7: TCodeType;
	function get_8: TDateType;
	function get_9: TTimeReferenceCodeType;
	function get_10: TPercentType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
  function get_ListItem(index : Integer) : TTradeTax;
public
	property CalculatedAmount:TAmountType read get_0;
	property TypeCode:TTaxTypeCodeType read get_1;
	property ExemptionReason:TTextType read get_2;
	property BasisAmount:TAmountType read get_3;
	property LineTotalBasisAmount:TAmountType read get_4;
	property AllowanceChargeBasisAmount:TAmountType read get_5;
	property CategoryCode:TTaxCategoryCodeType read get_6;
	property ExemptionReasonCode:TCodeType read get_7;
	property TaxPointDate:TDateType read get_8;
	property DueDateTypeCode:TTimeReferenceCodeType read get_9;
	property RateApplicablePercent:TPercentType read get_10;
  property ListItem[index : Integer] : TTradeTax read  get_ListItem; default;
end;


TXUniversalCommunication = (
	URIID, // name=URIID,type=udt:IDType,minOccurs=0
	CompleteNumber // name=CompleteNumber,type=udt:TextType,minOccurs=0
);
TUniversalCommunication=class(TWPXSequence<TXUniversalCommunication>)
private
	function get_0: TIDTypeUniCom;
	function get_1: TTextType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
public
	property URIID:TIDTypeUniCom read get_0;
	property CompleteNumber:TTextType read get_1;
end;




  // ------------------------------------------------------------
{$ENDREGION}




implementation



// -----------------------------------------------------------------------------

{$REGION 'aggregated list - auto generated from schema'}
// ------------------------------------------------------------



{ TAdvancePayment }
function TAdvancePayment.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TAmountType; opt:=0; end;
1 : begin Result := TFormattedDateTime; opt:=0; end;
2 : begin Result := TTradeTax; opt:=0; end;
end; end;
	function TAdvancePayment.get_0: TAmountType; begin Result := GetElementFor(0) as TAmountType; end;
	function TAdvancePayment.get_1: TFormattedDateTime; begin Result := GetElementFor(1) as TFormattedDateTime; end;
	function TAdvancePayment.get_2: TTradeTax;
  begin
     Result := GetElementFor(2) as TTradeTax;
     if Result.WasCreatedNew then
         Result.fBaseStringValue := 'VAT'; // Fixed value = "VAT"
  end;


{ TCreditorFinancialAccount }
function TCreditorFinancialAccount.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TIDType; opt:=0; end;
1 : begin Result := TTextType; opt:=0; end;
2 : begin Result := TIDType; opt:=0; end;
end; end;
	function TCreditorFinancialAccount.get_0: TIDType; begin Result := GetElementFor(0) as TIDType; end;
	function TCreditorFinancialAccount.get_1: TTextType; begin Result := GetElementFor(1) as TTextType; end;
	function TCreditorFinancialAccount.get_2: TIDType; begin Result := GetElementFor(2) as TIDType; end;


{ TCreditorFinancialInstitution }
function TCreditorFinancialInstitution.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TIDType; opt:=0; end;
end; end;
	function TCreditorFinancialInstitution.get_0: TIDType; begin Result := GetElementFor(0) as TIDType; end;


{ TDebtorFinancialAccount }
function TDebtorFinancialAccount.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TIDType; opt:=0; end;
end; end;
	function TDebtorFinancialAccount.get_0: TIDType; begin Result := GetElementFor(0) as TIDType; end;


{ TDocumentContextParameter }
function TDocumentContextParameter.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TIDType; opt:=0; end;
end; end;
	function TDocumentContextParameter.get_0: TIDType; begin Result := GetElementFor(0) as TIDType; end;


{ TDocumentLineDocument }
function TDocumentLineDocument.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TIDType; opt:=0; end;
1 : begin Result := TIDType; opt:=0; end;
2 : begin Result := TLineStatusCodeType; opt:=0; end;
3 : begin Result := TCodeType; opt:=0; end;
4 : begin Result := TNote; opt:=0; end;
end; end;
	function TDocumentLineDocument.get_0: TIDType; begin Result := GetElementFor(0) as TIDType; end;
	function TDocumentLineDocument.get_1: TIDType; begin Result := GetElementFor(1) as TIDType; end;
	function TDocumentLineDocument.get_2: TLineStatusCodeType; begin Result := GetElementFor(2) as TLineStatusCodeType; end;
	function TDocumentLineDocument.get_3: TCodeType; begin Result := GetElementFor(3) as TCodeType; end;
	function TDocumentLineDocument.get_4: TNote; begin Result := GetElementFor(4) as TNote; end;


{ TExchangedDocumentContext }
constructor TExchangedDocumentContext.Create;
begin
  inherited;
  FXMLNameSpace := TWPXElementNS.rsm;
end;

function TExchangedDocumentContext.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TIndicator; opt:=0; end;
1 : begin Result := TDocumentContextParameter; opt:=0; end;
2 : begin Result := TDocumentContextParameter; opt:=0; end;
end; end;
	function TExchangedDocumentContext.get_0: TIndicator; begin Result := GetElementFor(0) as TIndicator; end;
	function TExchangedDocumentContext.get_1: TDocumentContextParameter; begin Result := GetElementFor(1) as TDocumentContextParameter; end;
	function TExchangedDocumentContext.get_2: TDocumentContextParameter; begin Result := GetElementFor(2) as TDocumentContextParameter; end;


{ TExchangedDocument }
constructor TExchangedDocument.Create;
begin
  inherited;
  FXMLNameSpace := TWPXElementNS.rsm;
end;

function TExchangedDocument.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TIDType; opt:=0; end;
1 : begin Result := TTextType; opt:=0; end;
2 : begin Result := TDocumentCodeType; opt:=0; end;
3 : begin Result := TDateTimeType; opt:=0; end;
4 : begin Result := TIndicator; opt:=0; end;
5 : begin Result := TIDType; opt:=0; end;
6 : begin Result := TNote; opt:=0; end;
7 : begin Result := TSpecifiedPeriod; opt:=0; end;
end; end;
	function TExchangedDocument.get_0: TIDType; begin Result := GetElementFor(0) as TIDType; end;
	function TExchangedDocument.get_1: TTextType; begin Result := GetElementFor(1) as TTextType; end;
	function TExchangedDocument.get_2: TDocumentCodeType; begin Result := GetElementFor(2) as TDocumentCodeType; end;
	function TExchangedDocument.get_3: TDateTimeType; begin Result := GetElementFor(3) as TDateTimeType; end;
	function TExchangedDocument.get_4: TIndicator; begin Result := GetElementFor(4) as TIndicator; end;
	function TExchangedDocument.get_5: TIDType; begin Result := GetElementFor(5) as TIDType; end;
	function TExchangedDocument.get_6: TNote; begin Result := GetElementFor(6) as TNote; end;
	function TExchangedDocument.get_7: TSpecifiedPeriod; begin Result := GetElementFor(7) as TSpecifiedPeriod; end;


function TExchangedDocument.XMLNamespace: string;
begin
  Result := 'rsm';
end;

{ THeaderTradeAgreement }
function THeaderTradeAgreement.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TTextType; opt:=0; end;
1 : begin Result := TTradeParty; opt:=0; end;
2 : begin Result := TTradeParty; opt:=0; end;
3 : begin Result := TTradeParty; opt:=0; end;
4 : begin Result := TTradeParty; opt:=0; end;
5 : begin Result := TTradeParty; opt:=0; end;
6 : begin Result := TTradeParty; opt:=0; end;
7 : begin Result := TTradeDeliveryTerms; opt:=0; end;
8 : begin Result := TReferencedDocument; opt:=0; end;
9 : begin Result := TReferencedDocument; opt:=0; end;
10 : begin Result := TReferencedDocument; opt:=0; end;
11 : begin Result := TReferencedDocument; opt:=0; end;
12 : begin Result := TReferencedDocument; opt:=0; end;
13 : begin Result := TTradeParty; opt:=0; end;
14 : begin Result := TProcuringProject; opt:=0; end;
15 : begin Result := TReferencedDocument; opt:=0; end;
end; end;
	function THeaderTradeAgreement.get_0: TTextType; begin Result := GetElementFor(0) as TTextType; end;
	function THeaderTradeAgreement.get_1: TTradeParty; begin Result := GetElementFor(1) as TTradeParty; end;
	function THeaderTradeAgreement.get_2: TTradeParty; begin Result := GetElementFor(2) as TTradeParty; end;
	function THeaderTradeAgreement.get_3: TTradeParty; begin Result := GetElementFor(3) as TTradeParty; end;
	function THeaderTradeAgreement.get_4: TTradeParty; begin Result := GetElementFor(4) as TTradeParty; end;
	function THeaderTradeAgreement.get_5: TTradeParty; begin Result := GetElementFor(5) as TTradeParty; end;
	function THeaderTradeAgreement.get_6: TTradeParty; begin Result := GetElementFor(6) as TTradeParty; end;
	function THeaderTradeAgreement.get_7: TTradeDeliveryTerms; begin Result := GetElementFor(7) as TTradeDeliveryTerms; end;
	function THeaderTradeAgreement.get_8: TReferencedDocument; begin Result := GetElementFor(8) as TReferencedDocument; end;
	function THeaderTradeAgreement.get_9: TReferencedDocument; begin Result := GetElementFor(9) as TReferencedDocument; end;
	function THeaderTradeAgreement.get_10: TReferencedDocument; begin Result := GetElementFor(10) as TReferencedDocument; end;
	function THeaderTradeAgreement.get_11: TReferencedDocument; begin Result := GetElementFor(11) as TReferencedDocument; end;
	function THeaderTradeAgreement.get_12: TReferencedDocument; begin Result := GetElementFor(12) as TReferencedDocument; end;
	function THeaderTradeAgreement.get_13: TTradeParty; begin Result := GetElementFor(13) as TTradeParty; end;
	function THeaderTradeAgreement.get_14: TProcuringProject; begin Result := GetElementFor(14) as TProcuringProject; end;
	function THeaderTradeAgreement.get_15: TReferencedDocument; begin Result := GetElementFor(15) as TReferencedDocument; end;


{ THeaderTradeDelivery }
function THeaderTradeDelivery.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TSupplyChainConsignment; opt:=0; end;
1 : begin Result := TTradeParty; opt:=0; end;
2 : begin Result := TTradeParty; opt:=0; end;
3 : begin Result := TTradeParty; opt:=0; end;
4 : begin Result := TSupplyChainEvent; opt:=0; end;
5 : begin Result := TReferencedDocument; opt:=0; end;
6 : begin Result := TReferencedDocument; opt:=0; end;
7 : begin Result := TReferencedDocument; opt:=0; end;
end; end;
	function THeaderTradeDelivery.get_0: TSupplyChainConsignment; begin Result := GetElementFor(0) as TSupplyChainConsignment; end;
	function THeaderTradeDelivery.get_1: TTradeParty; begin Result := GetElementFor(1) as TTradeParty; end;
	function THeaderTradeDelivery.get_2: TTradeParty; begin Result := GetElementFor(2) as TTradeParty; end;
	function THeaderTradeDelivery.get_3: TTradeParty; begin Result := GetElementFor(3) as TTradeParty; end;
	function THeaderTradeDelivery.get_4: TSupplyChainEvent; begin Result := GetElementFor(4) as TSupplyChainEvent; end;
	function THeaderTradeDelivery.get_5: TReferencedDocument; begin Result := GetElementFor(5) as TReferencedDocument; end;
	function THeaderTradeDelivery.get_6: TReferencedDocument; begin Result := GetElementFor(6) as TReferencedDocument; end;
	function THeaderTradeDelivery.get_7: TReferencedDocument; begin Result := GetElementFor(7) as TReferencedDocument; end;


{ THeaderTradeSettlement }
function THeaderTradeSettlement.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TIDType; opt:=0; end;
1 : begin Result := TTextType; opt:=0; end;
2 : begin Result := TCurrencyCodeType; opt:=0; end;
3 : begin Result := TCurrencyCodeType; opt:=0; end;
4 : begin Result := TTextType; opt:=0; end;
5 : begin Result := TTradeParty; opt:=0; end;
6 : begin Result := TTradeParty; opt:=0; end;
7 : begin Result := TTradeParty; opt:=0; end;
8 : begin Result := TTradeParty; opt:=0; end;
9 : begin Result := TTradeCurrencyExchange; opt:=0; end;
10 : begin Result := TTradeSettlementPaymentMeans; opt:=0; end;
11 : begin Result := TTradeTax; opt:=0; end;
12 : begin Result := TSpecifiedPeriod; opt:=0; end;
13 : begin Result := TTradeAllowanceCharge; opt:=0; end;
14 : begin Result := TLogisticsServiceCharge; opt:=0; end;
15 : begin Result := TTradePaymentTerms; opt:=0; end;
16 : begin Result := TTradeSettlementHeaderMonetarySummation; opt:=0; end;
17 : begin Result := TReferencedDocument; opt:=0; end;
18 : begin Result := TTradeAccountingAccount; opt:=0; end;
19 : begin Result := TAdvancePayment; opt:=0; end;
end; end;
	function THeaderTradeSettlement.get_0: TIDType; begin Result := GetElementFor(0) as TIDType; end;
	function THeaderTradeSettlement.get_1: TTextType; begin Result := GetElementFor(1) as TTextType; end;
	function THeaderTradeSettlement.get_2: TCurrencyCodeType; begin Result := GetElementFor(2) as TCurrencyCodeType; end;
	function THeaderTradeSettlement.get_3: TCurrencyCodeType; begin Result := GetElementFor(3) as TCurrencyCodeType; end;
	function THeaderTradeSettlement.get_4: TTextType; begin Result := GetElementFor(4) as TTextType; end;
	function THeaderTradeSettlement.get_5: TTradeParty; begin Result := GetElementFor(5) as TTradeParty; end;
	function THeaderTradeSettlement.get_6: TTradeParty; begin Result := GetElementFor(6) as TTradeParty; end;
	function THeaderTradeSettlement.get_7: TTradeParty; begin Result := GetElementFor(7) as TTradeParty; end;
	function THeaderTradeSettlement.get_8: TTradeParty; begin Result := GetElementFor(8) as TTradeParty; end;
	function THeaderTradeSettlement.get_9: TTradeCurrencyExchange; begin Result := GetElementFor(9) as TTradeCurrencyExchange; end;
	function THeaderTradeSettlement.get_10: TTradeSettlementPaymentMeans; begin Result := GetElementFor(10) as TTradeSettlementPaymentMeans; end;
	function THeaderTradeSettlement.get_11: TTradeTax; begin Result := GetElementFor(11) as TTradeTax; end;
	function THeaderTradeSettlement.get_12: TSpecifiedPeriod; begin Result := GetElementFor(12) as TSpecifiedPeriod; end;
	function THeaderTradeSettlement.get_13: TTradeAllowanceCharge; begin Result := GetElementFor(13) as TTradeAllowanceCharge; end;
	function THeaderTradeSettlement.get_14: TLogisticsServiceCharge; begin Result := GetElementFor(14) as TLogisticsServiceCharge; end;
	function THeaderTradeSettlement.get_15: TTradePaymentTerms; begin Result := GetElementFor(15) as TTradePaymentTerms; end;
	function THeaderTradeSettlement.get_16: TTradeSettlementHeaderMonetarySummation; begin Result := GetElementFor(16) as TTradeSettlementHeaderMonetarySummation; end;
	function THeaderTradeSettlement.get_17: TReferencedDocument; begin Result := GetElementFor(17) as TReferencedDocument; end;
	function THeaderTradeSettlement.get_18: TTradeAccountingAccount; begin Result := GetElementFor(18) as TTradeAccountingAccount; end;
	function THeaderTradeSettlement.get_19: TAdvancePayment; begin Result := GetElementFor(19) as TAdvancePayment; end;


{ TLegalOrganization }
function TLegalOrganization.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TIDType; opt:=0; end;
1 : begin Result := TTextType; opt:=0; end;
2 : begin Result := TTradeAddress; opt:=0; end;
end; end;
	function TLegalOrganization.get_0: TIDType; begin Result := GetElementFor(0) as TIDType; end;
	function TLegalOrganization.get_1: TTextType; begin Result := GetElementFor(1) as TTextType; end;
	function TLegalOrganization.get_2: TTradeAddress; begin Result := GetElementFor(2) as TTradeAddress; end;


{ TLineTradeAgreement }
function TLineTradeAgreement.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TReferencedDocument; opt:=0; end;
1 : begin Result := TReferencedDocument; opt:=0; end;
2 : begin Result := TReferencedDocument; opt:=0; end;
3 : begin Result := TReferencedDocument; opt:=0; end;
4 : begin Result := TTradePrice; opt:=0; end;
5 : begin Result := TTradePrice; opt:=0; end;
6 : begin Result := TReferencedDocument; opt:=0; end;
end; end;
	function TLineTradeAgreement.get_0: TReferencedDocument; begin Result := GetElementFor(0) as TReferencedDocument; end;
	function TLineTradeAgreement.get_1: TReferencedDocument; begin Result := GetElementFor(1) as TReferencedDocument; end;
	function TLineTradeAgreement.get_2: TReferencedDocument; begin Result := GetElementFor(2) as TReferencedDocument; end;
	function TLineTradeAgreement.get_3: TReferencedDocument; begin Result := GetElementFor(3) as TReferencedDocument; end;
	function TLineTradeAgreement.get_4: TTradePrice; begin Result := GetElementFor(4) as TTradePrice; end;
	function TLineTradeAgreement.get_5: TTradePrice; begin Result := GetElementFor(5) as TTradePrice; end;
	function TLineTradeAgreement.get_6: TReferencedDocument; begin Result := GetElementFor(6) as TReferencedDocument; end;


{ TLineTradeDelivery }
function TLineTradeDelivery.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TQuantityType; opt:=0; end;
1 : begin Result := TQuantityType; opt:=0; end;
2 : begin Result := TQuantityType; opt:=0; end;
3 : begin Result := TTradeParty; opt:=0; end;
4 : begin Result := TTradeParty; opt:=0; end;
5 : begin Result := TSupplyChainEvent; opt:=0; end;
6 : begin Result := TReferencedDocument; opt:=0; end;
7 : begin Result := TReferencedDocument; opt:=0; end;
8 : begin Result := TReferencedDocument; opt:=0; end;
end; end;
	function TLineTradeDelivery.get_0: TQuantityType; begin Result := GetElementFor(0) as TQuantityType; end;
	function TLineTradeDelivery.get_1: TQuantityType; begin Result := GetElementFor(1) as TQuantityType; end;
	function TLineTradeDelivery.get_2: TQuantityType; begin Result := GetElementFor(2) as TQuantityType; end;
	function TLineTradeDelivery.get_3: TTradeParty; begin Result := GetElementFor(3) as TTradeParty; end;
	function TLineTradeDelivery.get_4: TTradeParty; begin Result := GetElementFor(4) as TTradeParty; end;
	function TLineTradeDelivery.get_5: TSupplyChainEvent; begin Result := GetElementFor(5) as TSupplyChainEvent; end;
	function TLineTradeDelivery.get_6: TReferencedDocument; begin Result := GetElementFor(6) as TReferencedDocument; end;
	function TLineTradeDelivery.get_7: TReferencedDocument; begin Result := GetElementFor(7) as TReferencedDocument; end;
	function TLineTradeDelivery.get_8: TReferencedDocument; begin Result := GetElementFor(8) as TReferencedDocument; end;


{ TLineTradeSettlement }
function TLineTradeSettlement.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TTradeTax; opt:=0; end;
1 : begin Result := TSpecifiedPeriod; opt:=0; end;
2 : begin Result := TTradeAllowanceCharge; opt:=0; end;
3 : begin Result := TTradeSettlementLineMonetarySummation; opt:=0; end;
4 : begin Result := TReferencedDocument; opt:=0; end;
5 : begin Result := TReferencedDocument; opt:=0; end;
6 : begin Result := TTradeAccountingAccount; opt:=0; end;
end; end;
	function TLineTradeSettlement.get_0: TTradeTax; begin Result := GetElementFor(0) as TTradeTax; end;
	function TLineTradeSettlement.get_1: TSpecifiedPeriod; begin Result := GetElementFor(1) as TSpecifiedPeriod; end;
	function TLineTradeSettlement.get_2: TTradeAllowanceCharge; begin Result := GetElementFor(2) as TTradeAllowanceCharge; end;
	function TLineTradeSettlement.get_3: TTradeSettlementLineMonetarySummation; begin Result := GetElementFor(3) as TTradeSettlementLineMonetarySummation; end;
	function TLineTradeSettlement.get_4: TReferencedDocument; begin Result := GetElementFor(4) as TReferencedDocument; end;
	function TLineTradeSettlement.get_5: TReferencedDocument; begin Result := GetElementFor(5) as TReferencedDocument; end;
	function TLineTradeSettlement.get_6: TTradeAccountingAccount; begin Result := GetElementFor(6) as TTradeAccountingAccount; end;


{ TLogisticsServiceCharge }
function TLogisticsServiceCharge.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TTextType; opt:=0; end;
1 : begin Result := TAmountType; opt:=0; end;
2 : begin Result := TTradeTax; opt:=0; end;
end; end;
	function TLogisticsServiceCharge.get_0: TTextType; begin Result := GetElementFor(0) as TTextType; end;
	function TLogisticsServiceCharge.get_1: TAmountType; begin Result := GetElementFor(1) as TAmountType; end;
	function TLogisticsServiceCharge.get_2: TTradeTax; begin Result := GetElementFor(2) as TTradeTax; end;


function TLogisticsServiceCharge.get_ListItem(index: Integer): TLogisticsServiceCharge;
begin
 Result := ListItemBase(index) as TLogisticsServiceCharge;
end;

{ TLogisticsTransportMovement }
function TLogisticsTransportMovement.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TTransportModeCodeType; opt:=0; end;
end; end;
	function TLogisticsTransportMovement.get_0: TTransportModeCodeType; begin Result := GetElementFor(0) as TTransportModeCodeType; end;




{ TProcuringProject }
function TProcuringProject.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TIDType; opt:=0; end;
1 : begin Result := TTextType; opt:=0; end;
end; end;
	function TProcuringProject.get_0: TIDType; begin Result := GetElementFor(0) as TIDType; end;
	function TProcuringProject.get_1: TTextType; begin Result := GetElementFor(1) as TTextType; end;


{ TProductCharacteristic }
function TProductCharacteristic.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TCodeType; opt:=0; end;
1 : begin Result := TTextType; opt:=0; end;
2 : begin Result := TMeasureType; opt:=0; end;
3 : begin Result := TTextType; opt:=0; end;
end; end;
	function TProductCharacteristic.get_0: TCodeType; begin Result := GetElementFor(0) as TCodeType; end;
	function TProductCharacteristic.get_1: TTextType; begin Result := GetElementFor(1) as TTextType; end;
	function TProductCharacteristic.get_2: TMeasureType; begin Result := GetElementFor(2) as TMeasureType; end;
	function TProductCharacteristic.get_3: TTextType; begin Result := GetElementFor(3) as TTextType; end;


{ TProductClassification }
function TProductClassification.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TCodeType; opt:=0; end;
1 : begin Result := TTextType; opt:=0; end;
end; end;
	function TProductClassification.get_0: TCodeType; begin Result := GetElementFor(0) as TCodeType; end;
	function TProductClassification.get_1: TTextType; begin Result := GetElementFor(1) as TTextType; end;


{ TReferencedDocument }
function TReferencedDocument.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TIDType; opt:=0; end;
1 : begin Result := TIDType; opt:=0; end;
2 : begin Result := TIDType; opt:=0; end;
3 : begin Result := TDocumentCodeType; opt:=0; end;
4 : begin Result := TTextType; opt:=0; end;
5 : begin Result := TBinaryObjectType; opt:=0; end;
6 : begin Result := TReferenceCodeType; opt:=0; end;
7 : begin Result := TFormattedDateTime; opt:=0; end;
end; end;
	function TReferencedDocument.get_0: TIDType; begin Result := GetElementFor(0) as TIDType; end;
	function TReferencedDocument.get_1: TIDType; begin Result := GetElementFor(1) as TIDType; end;
	function TReferencedDocument.get_2: TIDType; begin Result := GetElementFor(2) as TIDType; end;
	function TReferencedDocument.get_3: TDocumentCodeType; begin Result := GetElementFor(3) as TDocumentCodeType; end;
	function TReferencedDocument.get_4: TTextType; begin Result := GetElementFor(4) as TTextType; end;
	function TReferencedDocument.get_5: TBinaryObjectType; begin Result := GetElementFor(5) as TBinaryObjectType; end;
	function TReferencedDocument.get_6: TReferenceCodeType; begin Result := GetElementFor(6) as TReferenceCodeType; end;
	function TReferencedDocument.get_7: TFormattedDateTime;  begin
     Result := GetElementFor(7) as TFormattedDateTime; end;


function TReferencedDocument.get_ListItem(index: Integer): TReferencedDocument;
begin Result := ListItemBase(index) as TReferencedDocument; end;

{ TReferencedProduct }
function TReferencedProduct.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TIDType; opt:=0; end;
1 : begin Result := TIDType; opt:=0; end;
2 : begin Result := TIDType; opt:=0; end;
3 : begin Result := TIDType; opt:=0; end;
4 : begin Result := TIDType; opt:=0; end;
5 : begin Result := TTextType; opt:=0; end;
6 : begin Result := TTextType; opt:=0; end;
7 : begin Result := TQuantityType; opt:=0; end;
end; end;
	function TReferencedProduct.get_0: TIDType; begin Result := GetElementFor(0) as TIDType; end;
	function TReferencedProduct.get_1: TIDType; begin Result := GetElementFor(1) as TIDType; end;
	function TReferencedProduct.get_2: TIDType; begin Result := GetElementFor(2) as TIDType; end;
	function TReferencedProduct.get_3: TIDType; begin Result := GetElementFor(3) as TIDType; end;
	function TReferencedProduct.get_4: TIDType; begin Result := GetElementFor(4) as TIDType; end;
	function TReferencedProduct.get_5: TTextType; begin Result := GetElementFor(5) as TTextType; end;
	function TReferencedProduct.get_6: TTextType; begin Result := GetElementFor(6) as TTextType; end;
	function TReferencedProduct.get_7: TQuantityType; begin Result := GetElementFor(7) as TQuantityType; end;



  function TReferencedProduct.get_ListItem(index : Integer) : TReferencedProduct;
  begin Result := ListItemBase(index) as TReferencedProduct; end;

{ TSpecifiedPeriod }
function TSpecifiedPeriod.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TTextType; opt:=0; end;
1 : begin Result := TDateTimeType; opt:=0; end;
2 : begin Result := TDateTimeType; opt:=0; end;
3 : begin Result := TDateTimeType; opt:=0; end;
end; end;
	function TSpecifiedPeriod.get_0: TTextType; begin Result := GetElementFor(0) as TTextType; end;
	function TSpecifiedPeriod.get_1: TDateTimeType; begin Result := GetElementFor(1) as TDateTimeType; end;
	function TSpecifiedPeriod.get_2: TDateTimeType; begin Result := GetElementFor(2) as TDateTimeType; end;
	function TSpecifiedPeriod.get_3: TDateTimeType; begin Result := GetElementFor(3) as TDateTimeType; end;


{ TSupplyChainConsignment }
function TSupplyChainConsignment.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TLogisticsTransportMovement; opt:=0; end;
end; end;
	function TSupplyChainConsignment.get_0: TLogisticsTransportMovement; begin Result := GetElementFor(0) as TLogisticsTransportMovement; end;


{ TSupplyChainEvent }
function TSupplyChainEvent.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TDateTimeType; opt:=0; end;
end; end;
	function TSupplyChainEvent.get_0: TDateTimeType; begin Result := GetElementFor(0) as TDateTimeType; end;


{ TSupplyChainTradeLineItem }
function TSupplyChainTradeLineItem.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TDocumentLineDocument; opt:=0; end;
1 : begin Result := TTradeProduct; opt:=0; end;
2 : begin Result := TLineTradeAgreement; opt:=0; end;
3 : begin Result := TLineTradeDelivery; opt:=0; end;
4 : begin Result := TLineTradeSettlement; opt:=0; end;
end; end;
	function TSupplyChainTradeLineItem.get_0: TDocumentLineDocument; begin Result := GetElementFor(0) as TDocumentLineDocument; end;
	function TSupplyChainTradeLineItem.get_1: TTradeProduct; begin Result := GetElementFor(1) as TTradeProduct; end;
	function TSupplyChainTradeLineItem.get_2: TLineTradeAgreement; begin Result := GetElementFor(2) as TLineTradeAgreement; end;
	function TSupplyChainTradeLineItem.get_3: TLineTradeDelivery; begin Result := GetElementFor(3) as TLineTradeDelivery; end;
	function TSupplyChainTradeLineItem.get_4: TLineTradeSettlement; begin Result := GetElementFor(4) as TLineTradeSettlement; end;


{ TSupplyChainTradeTransaction }
(*
function TSupplyChainTradeTransaction.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TSupplyChainTradeLineItem; opt:=0; end;
1 : begin Result := THeaderTradeAgreement; opt:=0; end;
2 : begin Result := THeaderTradeDelivery; opt:=0; end;
3 : begin Result := THeaderTradeSettlement; opt:=0; end;
end; end;
	function TSupplyChainTradeTransaction.get_0: TSupplyChainTradeLineItem; begin Result := GetElementFor(0) as TSupplyChainTradeLineItem; end;
	function TSupplyChainTradeTransaction.get_1: THeaderTradeAgreement; begin Result := GetElementFor(1) as THeaderTradeAgreement; end;
	function TSupplyChainTradeTransaction.get_2: THeaderTradeDelivery; begin Result := GetElementFor(2) as THeaderTradeDelivery; end;
	function TSupplyChainTradeTransaction.get_3: THeaderTradeSettlement; begin Result := GetElementFor(3) as THeaderTradeSettlement; end;
*)

{ TTaxRegistration }
function TTaxRegistration.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TTaxIDType; opt:=0; end;
end; end;
function TTaxRegistration.get_0: TTaxIDType; begin Result := GetElementFor(0) as TTaxIDType; end;


function TTaxRegistration.get_ListItem(index: Integer): TTaxRegistration;
begin Result := ListItemBase(index) as TTaxRegistration; end;

{ TTradeAccountingAccount }
function TTradeAccountingAccount.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TIDType; opt:=0; end;
1 : begin Result := TAccountingAccountTypeCodeType; opt:=0; end;
end; end;
	function TTradeAccountingAccount.get_0: TIDType; begin Result := GetElementFor(0) as TIDType; end;
	function TTradeAccountingAccount.get_1: TAccountingAccountTypeCodeType; begin Result := GetElementFor(1) as TAccountingAccountTypeCodeType; end;


{ TTradeAddress }
function TTradeAddress.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TCodeType; opt:=0; end;
1 : begin Result := TTextType; opt:=0; end;
2 : begin Result := TTextType; opt:=0; end;
3 : begin Result := TTextType; opt:=0; end;
4 : begin Result := TTextType; opt:=0; end;
5 : begin Result := TCountryIDType; opt:=0; end;
6 : begin Result := TTextType; opt:=0; end;
end; end;
	function TTradeAddress.get_0: TCodeType; begin Result := GetElementFor(0) as TCodeType; end;
	function TTradeAddress.get_1: TTextType; begin Result := GetElementFor(1) as TTextType; end;
	function TTradeAddress.get_2: TTextType; begin Result := GetElementFor(2) as TTextType; end;
	function TTradeAddress.get_3: TTextType; begin Result := GetElementFor(3) as TTextType; end;
	function TTradeAddress.get_4: TTextType; begin Result := GetElementFor(4) as TTextType; end;
	function TTradeAddress.get_5: TCountryIDType; begin Result := GetElementFor(5) as TCountryIDType; end;
	function TTradeAddress.get_6: TTextType; begin Result := GetElementFor(6) as TTextType; end;


{ TTradeAllowanceCharge }
function TTradeAllowanceCharge.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TIndicator; opt:=0; end;
1 : begin Result := TNumericType; opt:=0; end;
2 : begin Result := TPercentType; opt:=0; end;
3 : begin Result := TAmountType; opt:=0; end;
4 : begin Result := TQuantityType; opt:=0; end;
5 : begin Result := TAmountType; opt:=0; end;
6 : begin Result := TAllowanceChargeReasonCodeType; opt:=0; end;
7 : begin Result := TTextType; opt:=0; end;
8 : begin Result := TTradeTax; opt:=0; end;
end; end;
	function TTradeAllowanceCharge.get_0: TIndicator; begin Result := GetElementFor(0) as TIndicator; end;
	function TTradeAllowanceCharge.get_1: TNumericType; begin Result := GetElementFor(1) as TNumericType; end;
	function TTradeAllowanceCharge.get_2: TPercentType; begin Result := GetElementFor(2) as TPercentType; end;
	function TTradeAllowanceCharge.get_3: TAmountType; begin Result := GetElementFor(3) as TAmountType; end;
	function TTradeAllowanceCharge.get_4: TQuantityType; begin Result := GetElementFor(4) as TQuantityType; end;
	function TTradeAllowanceCharge.get_5: TAmountType; begin Result := GetElementFor(5) as TAmountType; end;
	function TTradeAllowanceCharge.get_6: TAllowanceChargeReasonCodeType; begin Result := GetElementFor(6) as TAllowanceChargeReasonCodeType; end;
	function TTradeAllowanceCharge.get_7: TTextType; begin Result := GetElementFor(7) as TTextType; end;
	function TTradeAllowanceCharge.get_8: TTradeTax;
  begin
     Result := GetElementFor(8) as TTradeTax;
     if Result.fWasCreatedNew then
        Result.fBaseStringValue := 'VAT'; // Note: Fixed value = "VAT" , EN16931-ID: BT-95-0
  end;

  function TTradeAllowanceCharge.get_ListItem(index : Integer) : TTradeAllowanceCharge;
  begin Result := ListItemBase(index) as TTradeAllowanceCharge; end;


{ TTradeContact }
function TTradeContact.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TTextType; opt:=0; end;
1 : begin Result := TTextType; opt:=0; end;
2 : begin Result := TContactTypeCodeType; opt:=0; end;
3 : begin Result := TUniversalCommunication; opt:=0; end;
4 : begin Result := TUniversalCommunication; opt:=0; end;
5 : begin Result := TUniversalCommunication; opt:=0; end;
end; end;
	function TTradeContact.get_0: TTextType; begin Result := GetElementFor(0) as TTextType; end;
	function TTradeContact.get_1: TTextType; begin Result := GetElementFor(1) as TTextType; end;
	function TTradeContact.get_2: TContactTypeCodeType; begin Result := GetElementFor(2) as TContactTypeCodeType; end;
	function TTradeContact.get_3: TUniversalCommunication; begin Result := GetElementFor(3) as TUniversalCommunication; end;
	function TTradeContact.get_4: TUniversalCommunication; begin Result := GetElementFor(4) as TUniversalCommunication; end;
	function TTradeContact.get_5: TUniversalCommunication; begin Result := GetElementFor(5) as TUniversalCommunication; end;


{ TTradeCountry }
function TTradeCountry.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TCountryIDType; opt:=0; end;
end; end;
	function TTradeCountry.get_0: TCountryIDType; begin Result := GetElementFor(0) as TCountryIDType; end;


{ TTradeCurrencyExchange }
function TTradeCurrencyExchange.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TCurrencyCodeType; opt:=0; end;
1 : begin Result := TCurrencyCodeType; opt:=0; end;
2 : begin Result := TRateType; opt:=0; end;
3 : begin Result := TDateTimeType; opt:=0; end;
end; end;
	function TTradeCurrencyExchange.get_0: TCurrencyCodeType; begin Result := GetElementFor(0) as TCurrencyCodeType; end;
	function TTradeCurrencyExchange.get_1: TCurrencyCodeType; begin Result := GetElementFor(1) as TCurrencyCodeType; end;
	function TTradeCurrencyExchange.get_2: TRateType; begin Result := GetElementFor(2) as TRateType; end;
	function TTradeCurrencyExchange.get_3: TDateTimeType; begin Result := GetElementFor(3) as TDateTimeType; end;


{ TTradeDeliveryTerms }
function TTradeDeliveryTerms.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TDeliveryTermsCodeType; opt:=0; end;
end; end;
	function TTradeDeliveryTerms.get_0: TDeliveryTermsCodeType; begin Result := GetElementFor(0) as TDeliveryTermsCodeType; end;


{ TTradeParty }
function TTradeParty.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TIDType; opt:=0; end;
1 : begin Result := TIDType; opt:=0; end;
2 : begin Result := TTextType; opt:=0; end;
3 : begin Result := TPartyRoleCodeType; opt:=0; end;
4 : begin Result := TTextType; opt:=0; end;
5 : begin Result := TLegalOrganization; opt:=0; end;
6 : begin Result := TTradeContact; opt:=0; end;
7 : begin Result := TTradeAddress; opt:=0; end;
8 : begin Result := TUniversalCommunication; opt:=0; end;
9 : begin Result := TTaxRegistration; opt:=0; end;
end; end;
	function TTradeParty.get_0: TIDType; begin Result := GetElementFor(0) as TIDType; end;
	function TTradeParty.get_1: TIDType; begin Result := GetElementFor(1) as TIDType; end;
	function TTradeParty.get_2: TTextType; begin Result := GetElementFor(2) as TTextType; end;
	function TTradeParty.get_3: TPartyRoleCodeType; begin Result := GetElementFor(3) as TPartyRoleCodeType; end;
	function TTradeParty.get_4: TTextType; begin Result := GetElementFor(4) as TTextType; end;
	function TTradeParty.get_5: TLegalOrganization; begin Result := GetElementFor(5) as TLegalOrganization; end;
	function TTradeParty.get_6: TTradeContact; begin Result := GetElementFor(6) as TTradeContact; end;
	function TTradeParty.get_7: TTradeAddress; begin Result := GetElementFor(7) as TTradeAddress; end;
	function TTradeParty.get_8: TUniversalCommunication; begin Result := GetElementFor(8) as TUniversalCommunication; end;
	function TTradeParty.get_9: TTaxRegistration; begin Result := GetElementFor(9) as TTaxRegistration; end;


{ TTradePaymentDiscountTerms }
function TTradePaymentDiscountTerms.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TDateTimeType; opt:=0; end;
1 : begin Result := TMeasureType; opt:=0; end;
2 : begin Result := TAmountType; opt:=0; end;
3 : begin Result := TPercentType; opt:=0; end;
4 : begin Result := TAmountType; opt:=0; end;
end; end;
	function TTradePaymentDiscountTerms.get_0: TDateTimeType; begin Result := GetElementFor(0) as TDateTimeType; end;
	function TTradePaymentDiscountTerms.get_1: TMeasureType; begin Result := GetElementFor(1) as TMeasureType; end;
	function TTradePaymentDiscountTerms.get_2: TAmountType; begin Result := GetElementFor(2) as TAmountType; end;
	function TTradePaymentDiscountTerms.get_3: TPercentType; begin Result := GetElementFor(3) as TPercentType; end;
	function TTradePaymentDiscountTerms.get_4: TAmountType; begin Result := GetElementFor(4) as TAmountType; end;


{ TTradePaymentPenaltyTerms }
function TTradePaymentPenaltyTerms.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TDateTimeType; opt:=0; end;
1 : begin Result := TMeasureType; opt:=0; end;
2 : begin Result := TAmountType; opt:=0; end;
3 : begin Result := TPercentType; opt:=0; end;
4 : begin Result := TAmountType; opt:=0; end;
end; end;
	function TTradePaymentPenaltyTerms.get_0: TDateTimeType; begin Result := GetElementFor(0) as TDateTimeType; end;
	function TTradePaymentPenaltyTerms.get_1: TMeasureType; begin Result := GetElementFor(1) as TMeasureType; end;
	function TTradePaymentPenaltyTerms.get_2: TAmountType; begin Result := GetElementFor(2) as TAmountType; end;
	function TTradePaymentPenaltyTerms.get_3: TPercentType; begin Result := GetElementFor(3) as TPercentType; end;
	function TTradePaymentPenaltyTerms.get_4: TAmountType; begin Result := GetElementFor(4) as TAmountType; end;


{ TTradePaymentTerms }
function TTradePaymentTerms.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TTextType; opt:=0; end;
1 : begin Result := TDateTimeType; opt:=0; end;
2 : begin Result := TIDType; opt:=0; end;
3 : begin Result := TAmountType; opt:=0; end;
4 : begin Result := TTradePaymentPenaltyTerms; opt:=0; end;
5 : begin Result := TTradePaymentDiscountTerms; opt:=0; end;
6 : begin Result := TTradeParty; opt:=0; end;
end; end;
	function TTradePaymentTerms.get_0: TTextType; begin Result := GetElementFor(0) as TTextType; end;
	function TTradePaymentTerms.get_1: TDateTimeType; begin Result := GetElementFor(1) as TDateTimeType; end;
	function TTradePaymentTerms.get_2: TIDType; begin Result := GetElementFor(2) as TIDType; end;
	function TTradePaymentTerms.get_3: TAmountType; begin Result := GetElementFor(3) as TAmountType; end;
	function TTradePaymentTerms.get_4: TTradePaymentPenaltyTerms; begin Result := GetElementFor(4) as TTradePaymentPenaltyTerms; end;
	function TTradePaymentTerms.get_5: TTradePaymentDiscountTerms; begin Result := GetElementFor(5) as TTradePaymentDiscountTerms; end;
	function TTradePaymentTerms.get_6: TTradeParty; begin Result := GetElementFor(6) as TTradeParty; end;

function TTradePaymentTerms.get_ListItem(index : Integer) : TTradePaymentTerms;
begin Result := ListItemBase(index) as  TTradePaymentTerms; end;

{ TTradePrice }
function TTradePrice.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TAmountType; opt:=0; end;
1 : begin Result := TQuantityType; opt:=0; end;
2 : begin Result := TTradeAllowanceCharge; opt:=0; end;
3 : begin Result := TTradeTax; opt:=0; end;
end; end;
	function TTradePrice.get_0: TAmountType; begin Result := GetElementFor(0) as TAmountType; end;
	function TTradePrice.get_1: TQuantityType; begin Result := GetElementFor(1) as TQuantityType; end;
	function TTradePrice.get_2: TTradeAllowanceCharge; begin Result := GetElementFor(2) as TTradeAllowanceCharge; end;
	function TTradePrice.get_3: TTradeTax; begin Result := GetElementFor(3) as TTradeTax; end;


{ TTradeProductInstance }
function TTradeProductInstance.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TIDType; opt:=0; end;
1 : begin Result := TIDType; opt:=0; end;
end; end;
	function TTradeProductInstance.get_0: TIDType; begin Result := GetElementFor(0) as TIDType; end;
	function TTradeProductInstance.get_1: TIDType; begin Result := GetElementFor(1) as TIDType; end;


{ TTradeProduct }
function TTradeProduct.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TIDType; opt:=0; end;
1 : begin Result := TIDType; opt:=0; end;
2 : begin Result := TIDType; opt:=0; end;
3 : begin Result := TIDType; opt:=0; end;
4 : begin Result := TTextType; opt:=0; end;
5 : begin Result := TTextType; opt:=0; end;
6 : begin Result := TProductCharacteristic; opt:=0; end;
7 : begin Result := TProductClassification; opt:=0; end;
8 : begin Result := TTradeProductInstance; opt:=0; end;
9 : begin Result := TTradeCountry; opt:=0; end;
10 : begin Result := TReferencedProduct; opt:=0; end;
end; end;
	function TTradeProduct.get_0: TIDType; begin Result := GetElementFor(0) as TIDType; end;
	function TTradeProduct.get_1: TIDType; begin Result := GetElementFor(1) as TIDType; end;
	function TTradeProduct.get_2: TIDType; begin Result := GetElementFor(2) as TIDType; end;
	function TTradeProduct.get_3: TIDType; begin Result := GetElementFor(3) as TIDType; end;
	function TTradeProduct.get_4: TTextType; begin Result := GetElementFor(4) as TTextType; end;
	function TTradeProduct.get_5: TTextType; begin Result := GetElementFor(5) as TTextType; end;
	function TTradeProduct.get_6: TProductCharacteristic; begin Result := GetElementFor(6) as TProductCharacteristic; end;
	function TTradeProduct.get_7: TProductClassification; begin Result := GetElementFor(7) as TProductClassification; end;
	function TTradeProduct.get_8: TTradeProductInstance; begin Result := GetElementFor(8) as TTradeProductInstance; end;
	function TTradeProduct.get_9: TTradeCountry; begin Result := GetElementFor(9) as TTradeCountry; end;
	function TTradeProduct.get_10: TReferencedProduct; begin Result := GetElementFor(10) as TReferencedProduct; end;


{ TTradeSettlementFinancialCard }
function TTradeSettlementFinancialCard.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TIDType; opt:=0; end;
1 : begin Result := TTextType; opt:=0; end;
end; end;
	function TTradeSettlementFinancialCard.get_0: TIDType; begin Result := GetElementFor(0) as TIDType; end;
	function TTradeSettlementFinancialCard.get_1: TTextType; begin Result := GetElementFor(1) as TTextType; end;


{ TTradeSettlementHeaderMonetarySummation }
function TTradeSettlementHeaderMonetarySummation.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TAmountType; opt:=0; end;
1 : begin Result := TAmountType; opt:=0; end;
2 : begin Result := TAmountType; opt:=0; end;
3 : begin Result := TAmountType; opt:=0; end;
4 : begin Result := TAmountListType; opt:=0; end;
5 : begin Result := TAmountType; opt:=0; end;
6 : begin Result := TAmountType; opt:=0; end;
7 : begin Result := TAmountType; opt:=0; end;
8 : begin Result := TAmountType; opt:=0; end;
end; end;
	function TTradeSettlementHeaderMonetarySummation.get_0: TAmountType; begin Result := GetElementFor(0) as TAmountType; end;
	function TTradeSettlementHeaderMonetarySummation.get_1: TAmountType; begin Result := GetElementFor(1) as TAmountType; end;
	function TTradeSettlementHeaderMonetarySummation.get_2: TAmountType; begin Result := GetElementFor(2) as TAmountType; end;
	function TTradeSettlementHeaderMonetarySummation.get_3: TAmountType; begin Result := GetElementFor(3) as TAmountType; end;
	function TTradeSettlementHeaderMonetarySummation.get_4: TAmountListType; begin Result := GetElementFor(4) as TAmountListType; end;
	function TTradeSettlementHeaderMonetarySummation.get_5: TAmountType; begin Result := GetElementFor(5) as TAmountType; end;
	function TTradeSettlementHeaderMonetarySummation.get_6: TAmountType; begin Result := GetElementFor(6) as TAmountType; end;
	function TTradeSettlementHeaderMonetarySummation.get_7: TAmountType; begin Result := GetElementFor(7) as TAmountType; end;
	function TTradeSettlementHeaderMonetarySummation.get_8: TAmountType; begin Result := GetElementFor(8) as TAmountType; end;


{ TTradeSettlementLineMonetarySummation }
function TTradeSettlementLineMonetarySummation.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TAmountType; opt:=0; end;
1 : begin Result := TAmountType; opt:=0; end;
2 : begin Result := TAmountType; opt:=0; end;
3 : begin Result := TAmountType; opt:=0; end;
4 : begin Result := TAmountType; opt:=0; end;
5 : begin Result := TAmountType; opt:=0; end;
end; end;
	function TTradeSettlementLineMonetarySummation.get_0: TAmountType; begin Result := GetElementFor(0) as TAmountType; end;
	function TTradeSettlementLineMonetarySummation.get_1: TAmountType; begin Result := GetElementFor(1) as TAmountType; end;
	function TTradeSettlementLineMonetarySummation.get_2: TAmountType; begin Result := GetElementFor(2) as TAmountType; end;
	function TTradeSettlementLineMonetarySummation.get_3: TAmountType; begin Result := GetElementFor(3) as TAmountType; end;
	function TTradeSettlementLineMonetarySummation.get_4: TAmountType; begin Result := GetElementFor(4) as TAmountType; end;
	function TTradeSettlementLineMonetarySummation.get_5: TAmountType; begin Result := GetElementFor(5) as TAmountType; end;


{ TTradeSettlementPaymentMeans }
function TTradeSettlementPaymentMeans.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TPaymentMeansCodeType; opt:=0; end;
1 : begin Result := TTextType; opt:=0; end;
2 : begin Result := TTradeSettlementFinancialCard; opt:=0; end;
3 : begin Result := TDebtorFinancialAccount; opt:=0; end;
4 : begin Result := TCreditorFinancialAccount; opt:=0; end;
5 : begin Result := TCreditorFinancialInstitution; opt:=0; end;
end; end;
	function TTradeSettlementPaymentMeans.get_0: TPaymentMeansCodeType; begin Result := GetElementFor(0) as TPaymentMeansCodeType; end;
	function TTradeSettlementPaymentMeans.get_1: TTextType; begin Result := GetElementFor(1) as TTextType; end;
	function TTradeSettlementPaymentMeans.get_2: TTradeSettlementFinancialCard; begin Result := GetElementFor(2) as TTradeSettlementFinancialCard; end;
	function TTradeSettlementPaymentMeans.get_3: TDebtorFinancialAccount; begin Result := GetElementFor(3) as TDebtorFinancialAccount; end;
	function TTradeSettlementPaymentMeans.get_4: TCreditorFinancialAccount; begin Result := GetElementFor(4) as TCreditorFinancialAccount; end;
	function TTradeSettlementPaymentMeans.get_5: TCreditorFinancialInstitution; begin Result := GetElementFor(5) as TCreditorFinancialInstitution; end;


{ TTradeTax }
function TTradeTax.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TAmountType; opt:=0; end;
1 : begin Result := TTaxTypeCodeType; opt:=0; end;
2 : begin Result := TTextType; opt:=0; end;
3 : begin Result := TAmountType; opt:=0; end;
4 : begin Result := TAmountType; opt:=0; end;
5 : begin Result := TAmountType; opt:=0; end;
6 : begin Result := TTaxCategoryCodeType; opt:=0; end;
7 : begin Result := TCodeType; opt:=0; end;
8 : begin Result := TDateType; opt:=0; end;
9 : begin Result := TTimeReferenceCodeType; opt:=0; end;
10 : begin Result := TPercentType; opt:=0; end;
end; end;
	function TTradeTax.get_0: TAmountType;
  begin
     Result := GetElementFor(0) as TAmountType;
     if Result.WasCreatedNew then
        Result.ValueStr := 'VAT'; // Note: Fixed value = "VAT" , EN16931-ID: BT-95-0
  end;
	function TTradeTax.get_1: TTaxTypeCodeType; begin Result := GetElementFor(1) as TTaxTypeCodeType; end;
	function TTradeTax.get_2: TTextType; begin Result := GetElementFor(2) as TTextType; end;
	function TTradeTax.get_3: TAmountType; begin Result := GetElementFor(3) as TAmountType; end;
	function TTradeTax.get_4: TAmountType; begin Result := GetElementFor(4) as TAmountType; end;
	function TTradeTax.get_5: TAmountType; begin Result := GetElementFor(5) as TAmountType; end;
	function TTradeTax.get_6: TTaxCategoryCodeType; begin Result := GetElementFor(6) as TTaxCategoryCodeType; end;
	function TTradeTax.get_7: TCodeType; begin Result := GetElementFor(7) as TCodeType; end;
	function TTradeTax.get_8: TDateType; begin Result := GetElementFor(8) as TDateType; end;
	function TTradeTax.get_9: TTimeReferenceCodeType; begin Result := GetElementFor(9) as TTimeReferenceCodeType; end;
  function TTradeTax.get_10: TPercentType; begin Result := GetElementFor(10) as TPercentType; end;
  function TTradeTax.get_ListItem(index : Integer) : TTradeTax;
  begin Result := ListItemBase(index) as TTradeTax; end;

{ TUniversalCommunication }
function TUniversalCommunication.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TIDTypeUniCom; opt:=0; end;
1 : begin Result := TTextType; opt:=0; end;
end; end;
	function TUniversalCommunication.get_0: TIDTypeUniCom; begin Result := GetElementFor(0) as TIDTypeUniCom; end;
	function TUniversalCommunication.get_1: TTextType; begin Result := GetElementFor(1) as TTextType; end;



// ------------------------------------------------------------
{$ENDREGION}

// -----------------------------------------------------------------------------



end.
