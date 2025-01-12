unit WPXFacturTypes;
{ WPXOrder by WPCubed
  https://github.com/wpcubed/xorder
  https://www.wpcubed.com/xorder
  ---------------------------------

  Copyright (C) 2024-2025 WPCubed GmbH, developed by Julian Ziersch
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
  This will help you to get you  started.
}


{$SCOPEDENUMS ON} // Require the SCOPE

  // Rounding
  (* Für positive Zahlen: Aufrunden auf den nächsthöheren Wert. Besipiel: 13,455 auf zwei
    Nachkommastellen aufgerundet ergibt 13,46.
    • Für negative Zahlen: Abrunden auf den niedrigeren Wert (so dass das Runden zweier streng
    entgegengesetzter Zahlen auch streng entgegengesetzte gerundete Zahlen ergeben).
    Beispiel: -13.455 ergibt -13.46. *)

interface

uses System.SysUtils, System.Classes, System.Rtti, System.TypInfo, System.Math,
    System.IOUtils, System.StrUtils, System.Types, System.Generics.Defaults, System.Generics.Collections;

const WPXOrderVersion = 'WPXOrder 1.0.1';
      WPXOrderXFacturNSHeader =
      '<rsm:CrossIndustryInvoice xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100" ' +
      'xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:100" ' +
      'xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100" ' +
      'xmlns:xs="http://www.w3.org/2001/XMLSchema" ' +
      'xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100">';

type
  ENotExpectedAttributeValue = Class(Exception);
  TWPXElementNS = (
    ram, //   xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"
    rsm, //   xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"
    qdt, //   xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"
    xs,  //   xmlns:xs="http://www.w3.org/2001/XMLSchema"
    udt,  //   xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"
    // The following are used by X-Invoice (reserved)
    cac, // xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
    cec, // xmlns:cec="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
    cbc, // xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
    // Note: cbc=CommonBasicComponents is mainly udt=UnqualifiedDataType !
    none
   );
   TWPXElementNSSelection = set of TWPXElementNS;
   TWPXOrderType = (
      ZUGFeRD,
      // EInvoice is Reserved. Maybe it is impossible to add support for this
      EInvoice

       );

   TWPXOrderDumpMode = (
     Debug,
     XML,
     DelphiCode,
     DelphiCodeCompact
   );

  TWPXDumpXElementOption = (
    CompactCode
  );
  TDumpXElementOptions = set of TWPXDumpXElementOption;

   // used in GuidelineSpecifiedDocumentContextParameter
   TWPXOrderProfile = (  Basic, Extended  );

  type TWPXElementNSDef = record nam, uri : string; end;

// We do not use the :100 at the end for upwards compatibility (DONT CHANGE ORDER!)
var WPXElementNSDefs:array[TWPXElementNS] of TWPXElementNSDef
  =(( nam : 'ram'; uri:'urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity' ),
    ( nam : 'rsm'; uri:'urn:un:unece:uncefact:data:standard:CrossIndustryInvoice' ),
    ( nam : 'qdt'; uri:'urn:un:unece:uncefact:data:standard:QualifiedDataType' ),
    ( nam : 'xs';  uri:'http://www.w3.org/2001/XMLSchema' ),
    ( nam : 'udt'; uri:'urn:un:unece:uncefact:data:standard:UnqualifiedDataType' ),
    // XInvoice - uses a simpler approach
    ( nam : 'cac'; uri:'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2' ),
    ( nam : 'cec'; uri:'urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2' ),
    ( nam : 'cbc'; uri:'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2' ),
    ( nam : '';  uri:'' ) // Ignore
   );


   WPXGuideLineDef : array[TWPXOrderProfile] of String =
   (
       'urn:cen.eu:en16931:2017#compliant#urn:factur-x.eu:1p0:basic',
       'urn:cen.eu:en16931:2017#conformant#urn:factur-x.eu:1p0:extended'
   );

const
  wpxfCrossIndustryDocument: string = '<rdf:Description rdf :about=""' + #10 +
    'xmlns:fx="urn:factur-x:pdfa:CrossIndustryDocument:invoice:1p0#">' + #10 +
    '<fx:DocumentType>INVOICE</fx:DocumentType>' + #10 +
    '<fx:DocumentFileName>factur-x.xml</fx:DocumentFileName>' + #10 +
    '<fx:Version>1.0</fx:Version>' + #10 +
    '<fx:ConformanceLevel>EXTENDED</fx:ConformanceLevel>' + #10 +
    '</rdf:Description>';

  wpxfCrossIndustryDocumentAlt
    : string =
    '<rdf:Description xmlns:fx="urn:factur-x:pdfa:CrossIndustryDocument:invoice:1p0#"'
    + #10 + 'fx:ConformanceLevel="BASIC"' + #10 +
    'fx:DocumentFileName="factur-x.xml"' + #10 + 'fx:DocumentType="INVOICE"' +
    #10 + 'fx:Version="1.0"' + #10 + 'rdf:about=""/>';

  wpxfXOrderNSSelection : array[TWPXOrderType] of TWPXElementNSSelection = (
      [TWPXElementNS.ram, TWPXElementNS.rsm, TWPXElementNS.qdt, TWPXElementNS.xs, TWPXElementNS.udt],
      [TWPXElementNS.cac, TWPXElementNS.cec, TWPXElementNS.cbc, TWPXElementNS.xs] );

type
  // Helper class during loading and saving. Can also
  // be used to crate control sums to verify values.
  // It is also used to create a protocoll and collect
  // errors
  TWPXDocDefaults = class
  private
     FMode : TWPXOrderType;
     procedure SetMode(v : TWPXOrderType);
  public
     NS : array[TWPXElementNS] of String;
     Messages : TStringList;
     CrossIndustryInvoice : String;
     IncludedSupplyChainTradeLineItem : String;
     SupplyChainTradeTransaction : String;
     SupplyChainTradeTransactionCount : Integer;
     NSSelection : TWPXElementNSSelection;
     procedure SetDefaults;
     procedure Log(const msg : String);
     function SameTagname( const BaseValue : String; // excl. NS
       const Value : String; ExpectedNS : TWPXElementNS; ref : String = '' ) : Boolean;
     constructor Create;
     destructor Destroy; override;
     property Mode : TWPXOrderType read FMode write SetMode;
  end;

  TWPXElement = class;

  // 7.1.5 Datentypen
  TwpxType = (Undefined, Enum, // this is an enum type
    Amount, // Betrag  "." as decimal. Max 2 digits
    Nummeric, // Integer ??
    Price, // Preis pro Einheit
    Quantity, // Menge,  . Max 4 digits
    Percentage, // Prozenzsatz  in %
    Identifier, // Bezeichner  = drei Textfelder!   String,Qualifier,Version
    Reference, // Dokumentenverweis = String
    Date, // YYYYMMDD
    Text, // Freitext, = String
    Code, // zwei bis vier textfelder:  String, Attribut, Version, Agentur
    Binary, // Data, mimetype, filename
    Token // Usually codes
    );

  TSeqData = class(TPersistent)
  protected
    // The index = the enum value
    fIndex: Integer;
    // This is actually a TWPXSequence!
    fData: TWPXElement;
    // the string if data=nil
    fDatastr: String;
    function GetAsString: String;
    procedure SetAsString(const s: String);
    function GetSaveData: TWPXElement;
    procedure SetAsFloat(const d: double); virtual;
    function GetAsFloat: double; virtual;
  public
    function HasData: Boolean;
    property Data: TWPXElement read GetSaveData;
    property AsString: string read GetAsString write SetAsString;
    property AsFloat: double read GetAsFloat write SetAsFloat;
  end;

  TWPXElementClass = class of TWPXElement;

  TWPXElementCreateEvent = reference to procedure(aClassName : String);

  // Abstract anchestor for TWPXSequence<TSelector>
  TWPXElement = class(TStrings)
  private
    fprefNItem, fnextNItem : TWPXElement;
    // the previous element
    fParent : TWPXElement;
    // the first anchestor, = grand parent
    fAnchestor: TWPXElement;
    // Event as anonymous procedure is beeing called when an element is created.
    // Only used for the 'Anchestor'
    fOnCreateElement : TWPXElementCreateEvent;
    fSaveElementsInSchemeOrder : Boolean;
    function GetAnchestor : TWPXElement;
  protected
    // the contents of this element as Values + Objects[]
    FList: TList<TSeqData>;
    // Duplicate of FList filled by  ElementsSortedList
    FSortedList : TList<TSeqData>;
    // All possible value names in sequential "enum" order
    FAllowedNames: TStringList;
    FBaseType: TwpxType;
    fBaseStringValue : String;
    // Used and assigned by  TWPXSequence<TSelector>
    FOrdType: TOrdType;
    // If this is '1' we can use AsString on the first!
    FEnumCountVal: Integer;
    FXMLNameSpace : TWPXElementNS;
    fWasCreatedNew : Boolean;
    function Get(Index: Integer): string; override;
    function GetCount: Integer; override;
    procedure Put(Index: Integer; const s: string); override;
    function ValuesGet(Index: Integer): string; virtual;
    procedure ValuesPut(Index: Integer; const s: string); virtual;
    function GetValueStr: String; virtual;
    procedure SetValueStr(const s: String); virtual;
    // // if (opt and 1)=1  the REQUIRED!
    function GetSequenceFor(iEnum: Integer; var opt: Integer)
      : TWPXElementClass; virtual;
    procedure IllegalValue(const value: String);
    procedure InternInitData;
    function  ListItemBase(index : Integer) : TWPXElement;
  public
    fAssignedXMLTagName : string;
    constructor Create; virtual; // MUST BE VIRTUAL!
    constructor CreateAs( asXMLTagName : String );
    destructor Destroy; override;
    function  Add(const s: string): Integer; override;
    // Attributes, such as Currency.
    function  AttributeCount: Integer; virtual;
    function  AttributeGet(Index: Integer; var AName, AValue: String)
      : Boolean; virtual;
    function  AttributeSet(const AName, AValue: String): Boolean; virtual;
    procedure Insert(Index: Integer; const s: string); override;
    function  ElementId( const aTagName : String ) : Integer;
    function  GetElementFor(iEnum: Integer): TWPXElement; virtual;

    // this removes all properties and also deletes all siblings[]
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    function  Child(nr: Integer): TSeqData; virtual;
    // XMLTagName, defaults to classname
    function XMLTagName: String; virtual;

    // Set the value as string. Can be overriden and overloaded.
    // It serves as interface to regular delphi code
    function SetValue( const strvalue : String; Defaults : TWPXDocDefaults  = nil ) : Boolean;  overload;  virtual;
    function SetValue( const intvalue : Integer; Defaults : TWPXDocDefaults  = nil ) : Boolean;  overload;  virtual;

    // Sets the Value and also the first attribute, i.e. "format"
    // Returns FALSE if an attribute was provided but is not accepted
    function SetValue( const strvalue : String; const attribute : String; const attribute2 : string=''; Defaults : TWPXDocDefaults  = nil ) : Boolean;  overload; virtual;
    // Returns the parameters for SetValue to be used by programming code
    function Get_SetValueParams( Defaults : TWPXDocDefaults ) : String; virtual;

    {:: Some objects may have multiple siblings, i.e. ram:IncludedNote. They are
      implemented as simple pref/next chain but can be accessed
      by any of the objects using the index }
    function ListCount : Integer;
    {:: adds a new element. Please note that you need to cast it to the
       type of the class for which you are calling it }
    function ListAdd : TWPXElement;
    {:: Adds an element unless this is the first and and such empty }
    function ListIsFirstOrAdd : TWPXElement;
    function ListNext  : TWPXElement;

    {:: Extracts a sorted list with elements. }
    function ElementsSortedList : TList<TSeqData>;


    // XMLNamespace defaults to TWPXElementNS.ram
    property XMLNameSpace : TWPXElementNS read fXMLNameSpace write fXMLNameSpace;
    property ValueStr: string read GetValueStr write SetValueStr;
    // this property is set to TRUE after creation
    // (used by reader to detect if the property was there already)
    property WasCreatedNew : Boolean read fWasCreatedNew write fWasCreatedNew;
    property Parent : TWPXElement read fParent;
    // this is the previous element or the element itself if at the top
    property Anchestor: TWPXElement read GetAnchestor;

    // Event as anonymous procedure is beeing called when an element is created
    property OnCreateElement : TWPXElementCreateEvent read fOnCreateElement write fOnCreateElement;
    // IF true the elements are saved in order of the ENUM, not creation order.
    // this is the default
    property SaveElementsInSchemeOrder : Boolean read fSaveElementsInSchemeOrder write fSaveElementsInSchemeOrder;
  end;

  // Class used for "simple" classes, such as Currency
  TWPXElementEnum = class(TWPXElement)
  public
    constructor Create; override;
  end;

  // Class which implements a collection of properties
  // accessible by an ENUM
  // NEEDS to override
  // function GetSequenceFor(iEnum : Integer) : TWPXElementClass;!
  TWPXSequence<TSelector> = class(TWPXElement)
  private
    function ToInt(const i: TSelector): Integer;
  protected
    function ValuesGet(Index: Integer): string; override;
    procedure ValuesPut(Index: Integer; const s: string); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Assign(Source: TWPXSequence<TSelector>); reintroduce; virtual;
    function Has(i: TSelector): Boolean;
    /// <summary>
    /// This function reads the value of a nested property. In iNums specify the
    /// integer values of each of inner elements. The function checks if the
    /// property is defined. If the propertry was not defined it returns false
    /// and SubProperty is set to nil
    /// </summary>
    function ReadElementValue( iEnums : array of Integer; var SubProperty : TWPXElement ) : Boolean;  overload;
    function ReadElementValue( iEnums : array of Integer; var SubPropertyValue : String ) : Boolean;  overload;

    function Child(nr: Integer): TSeqData; override;
    function GetElementFor(iEnum: Integer): TWPXElement; override;
    function ValueName(const i: TSelector): string;
    function GetValue(const i: TSelector): string;
    function SetValue(const i: TSelector; const value: String)
      : TWPXSequence<TSelector>; overload;
    function SetValue(const i: TSelector; const value: double)
      : TWPXSequence<TSelector>; overload;
    function SetValue(const AName, AValue: String)
      : TWPXSequence<TSelector>; overload;
    // Read and create sub properties
    function Prop(const i: TSelector): TSeqData; overload;
    // Pass the class we expect, otherwise exception!
    function Prop(const i: TSelector; AsClass: TClass): TSeqData; overload;

    // ONLY the affected classes define ListItem() - see TNote
  end;

  // 7.1.9 Der Umgang mit MwSt   (muss ins PDF!)
  TwpxVATRule = (Undefined, s,
    // S: Standard MwSt-Satz (der dann auch angezeigt werden muss)
    Z, // Z: MwSt-Satz ist Null
    E, // E: MwSt-befreit („exempt“).
    AE, // AE: Steuerumkehrung
    K, // K: Steuerumkehrung bei innergemeinschaftlicher Lieferung.
    G, // G: Steuerbefreiung für Exporte
    O, // O: Außerhalb des Gültigkeitsbereichs der MwSt
    L, // Sonderregelungen für die Kanarischen Inseln und Ceuta/Melilla.
    M);

  // 7.1.10 Umgang mit Steuern außer MwSt, im Fall der WEEE eco-tax
  TwpxTaxRule = (Undefined, IncludesVAT, ExcludedVAT);

  // 7.1.11 Zuschläge, Abschläge und Rabatte bzw. Ermäßigungen
  // SpecifiedTradeAllowanceCharge
  TwpxAllowanceCharge = (Undefined, Surcharge,
    // Zuschlag, ChargeIndicator = false
    Discount); // Abschlag, ChargeIndicator = true

  // unqualified
  // urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100
  TWPXSequenceStringsURN = class(TWPXElement)
  public
    constructor Create; override;
    function XMLTagName: String; override;
  end;

  // ZUGFeRD 2.3.2 - 10.1.2025 (updated)
  // We did not yet get the other codes from ZUGFeRD 2.3.2 since they
  // seem to be much reduced
  TCurrencyCode = (AED, AFN, ALL, AMD, ANG, AOA, ARS, AUD, AWG,
    AZN, BAM, BBD, BDT, BGN, BHD, BIF, BMD, BND, BOB, BOV,
    BRL, BSD, BTN, BWP, BYN, BZD, CAD, CDF, CHE, CHF, CHW,
    CLF, CLP, CNY, COP, COU, CRC, CUC, CUP, CVE, CZK, DJF,
    DKK, DOP, DZD, EGP, ERN, ETB, EUR, FJD, FKP, GBP, GEL,
    GHS, GIP, GMD, GNF, GTQ, GYD, HKD, HNL, HRK, HTG, HUF,
    IDR, ILS, INR, IQD, IRR, ISK, JMD, JOD, JPY, KES, KGS,
    KHR, KMF, KPW, KRW, KWD, KYD, KZT, LAK, LBP, LKR, LRD,
    LSL, LYD, MAD, MDL, MGA, MKD, MMK, MNT, MOP, MRU, MUR,
    MVR, MWK, MXN, MXV, MYR, MZN, NAD, NGN, NIO, NOK, NPR,
    NZD, OMR, PAB, PEN, PGK, PHP, PKR, PLN, PYG, QAR, RON,
    RSD, RUB, RWF, SAR, SBD, SCR, SDG, SEK, SGD, SHP, SLL,
    SOS, SRD, SSP, STN, SVC, SYP, SZL, THB, TJS, TMT, TND,
    TOP, eTRY, TTD, TWD, TZS, UAH, UGX, USD, USN, UYI, UYU,
    UYW, UZS, VES, VND, VUV, WST, XAF, XAG, XAU, XBA, XBB,
    XBC, XBD, XCD, XDR, XOF, XPD, XPF, XPT, XSU, XTS, XUA,
    XXX, YER, ZAR, ZMW, ZWL);

  TAmountType = class(TWPXSequenceStringsURN)
  protected
    fValueDigits : Integer;
  private
    fCurrencyID: String; // xs:token
    procedure set_Value( floatvalue : Double );
    function get_Value : Double;
  public
    constructor Create; override;
    function AttributeCount: Integer; override;
    function AttributeGet(Index: Integer; var AName, AValue: String)
      : Boolean; override;
    function AttributeSet(const AName, AValue: String): Boolean; override;
    function SetValue( floatvalue : Double; Defaults : TWPXDocDefaults  = nil ) : Boolean; overload;
    function SetValue( floatvalue : Double; aCurrencyID : String; Defaults : TWPXDocDefaults  = nil ) : Boolean; overload;
    function SetValue( floatvalue : Double; aCurrencyCode : TCurrencyCode; Defaults : TWPXDocDefaults  = nil ) : Boolean; overload;
    function Get_SetValueParams( Defaults : TWPXDocDefaults ) : String; override;
    property currencyID: String read fCurrencyID write fCurrencyID;
    property Value : Double read get_Value write set_Value;
  end;

  TAmountListType = class(TAmountType)
  protected
     function get_ListItem(index : Integer) : TAmountListType;
  public
     constructor Create; override;
     property ListItem[index : Integer] : TAmountListType read  get_ListItem; default;
  end;

  TBooleanType = class(TWPXSequenceStringsURN)
  private
    fValue: Boolean;
  protected
    function GetValueStr: String; override;
    procedure SetValueStr(const s: String); override;
  public
    // Set the value as string. Can be overriden and overloaded.
    // It serves as interface to regular delphi code
    function SetValue( const boolvalue : Boolean; Defaults : TWPXDocDefaults  = nil ) : Boolean;
    // Returns the parameters for SetValue to be used by programming code
    function Get_SetValueParams( Defaults : TWPXDocDefaults ) : String; override;

    constructor Create; override;
    property AsBoolean: Boolean read fValue write fValue;
    // inherited:  schemeID
  end;

  TBinaryObjectType = class(TWPXSequenceStringsURN)
  private
    fMemory: TMemoryStream;
    fmimeCode: String; // xs:token
    ffilename: String; // xs:string
  public
    constructor Create; override;
    destructor Destroy; override;
    property Memory: TMemoryStream read fMemory;
    property mimeCode: String read fmimeCode write fmimeCode;
    property filename: String read ffilename write ffilename;
  end;

  {
      //EN16931-ID: BT-21
      AAI : General information
      SUR : Comments by the seller
      REG : Regulatory information
      ABL : Legal information
      TXD : Information about tax
      CUS : Customs information

      https://www.xrepository.de/api/xrepository/urn:xoev-de:kosit:codeliste:untdid.4451_4:technischerBestandteilGenericode
  }

  TCodeType = class(TWPXSequenceStringsURN)
  private
    flistID: String; // xs:token
    flistVersionID: String; // xs:token
  public
    function AttributeCount: Integer; override;
    function AttributeGet(Index: Integer; var AName, AValue: String)
      : Boolean; override;
    function AttributeSet(const AName, AValue: String): Boolean; override;

    constructor Create; override;
    property listID: String read flistID write flistID;
    property listVersionID: String read flistVersionID write flistVersionID;
  end;

  TIDType = class(TWPXSequenceStringsURN)
  private
    fschemeID: String;
  public
    function AttributeCount: Integer; override;
    function AttributeGet(Index: Integer; var AName, AValue: String)
      : Boolean; override;
    function AttributeSet(const AName, AValue: String): Boolean; override;

    constructor Create; override;
    property schemeID: string read fschemeID write fschemeID; // xs:token
  end;

  { Used by URIUniversalCommunication

    EAS Entire code list  (excerpt)
    0002 . System Information et Repertoire des Entreprise et des Etablissements: SIRENE 0007 . Organisationsnumme
    0009 . SIRET-CODE
    0037 . LY-tunnus
    0060 . Data Universal Numbering System (D-U-N-S Number)
    0088 . EAN Location Code
    ...
    9957 . French VAT number
    9958 . German Leitweg ID
    AN . O.F.T.P. (ODETTE File Transfer Protocol)
    AQ . X.400 address for mail text
    AS . AS2 exchange
    AU . File Transfer Protocol
    EM . Electronic mail  }

  TIDTypeUniCom = class(TIDType);

  TTaxID = ( VA_VAT_number, FC_tax_number );

  TTaxIDType = class(TWPXSequenceStringsURN)
  private
    fschemeID: TTaxID;
  public
    function AttributeCount: Integer; override;
    function AttributeGet(Index: Integer; var AName, AValue: String)
      : Boolean; override;
    function AttributeSet(const AName, AValue: String): Boolean; override;
    function SetValue( const taxNumber : String; taxScheme: TTaxID; Defaults : TWPXDocDefaults  = nil ) : Boolean; overload;
    function Get_SetValueParams( Defaults : TWPXDocDefaults ) : String; override;
    constructor Create; override;
    property schemeID: TTaxID read fschemeID write fschemeID; // xs:token
  end;

  TNumericType = class(TWPXSequenceStringsURN)
  protected
    fValueDigits : Integer;
    procedure set_Value( floatvalue : Double );
    function get_Value : Double;
  public
    constructor Create; override;
    function SetValue( floatvalue : Double; Defaults : TWPXDocDefaults  = nil ) : Boolean; overload;
    function SetValue( floatvalue : Double; unitCode:String; Defaults : TWPXDocDefaults  = nil ) : Boolean; overload;
    function Get_SetValueParams( Defaults : TWPXDocDefaults ) : String; override;
    property Value : Double read get_Value write set_Value;
  end;

  TIntegerIDType = class(TNumericType)
  public
    constructor Create; override;
    function SetValue( intvalue : Integer; Defaults : TWPXDocDefaults  = nil ) : Boolean; overload;
    function Get_SetValueParams( Defaults : TWPXDocDefaults ) : String; override;
  end;

  TMeasureType = class(TNumericType)
  private
    funitCode: String;
  public
    function AttributeCount: Integer; override;
    function AttributeGet(Index: Integer; var AName, AValue: String) : Boolean; override;
    function AttributeSet(const AName, AValue: String): Boolean; override;
    property unitCode: string read funitCode write funitCode; // xs:token
  end;

  TRateType = class(TMeasureType);

  {
  H87 = piece
  LTR = litre (1 dm3)
  MTQ = cubic metres
  KGM = kilogram
  MTR = metress
  H87 = item
  TNE = ton }

  TQuantityType = class(TMeasureType)
  public
    constructor Create; override;
  end;

  TPercentType = class(TNumericType)
  public
    constructor Create; override;
  end;

  TTextType = class(TWPXSequenceStringsURN)
  public
    constructor Create; override;
  end;

  TReferenceType = class(TTextType);

  (* That is not an element - it is an attribute in an XML tag *)
  TTokenType = class(TWPXSequenceStringsURN)
  public
    constructor Create; override;
  end;

  TXNote = (
	ContentCode, // name=ContentCode,type=udt:CodeType,minOccurs=0
	Content, // name=Content,type=udt:TextType
	SubjectCode // name=SubjectCode,type=udt:CodeType,minOccurs=0
);

TNote=class(TWPXSequence<TXNote>)
private
	function get_0: TCodeType;
	function get_1: TTextType;
	function get_2: TCodeType;
protected
	function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
  function get_ListItem(index : Integer) : TNote;
public
  constructor Create; override;
	property ContentCode:TCodeType read get_0;
	property Content:TTextType read get_1;
	property SubjectCode:TCodeType read get_2;
  property ListItem[index : Integer] : TNote read get_ListItem; default;
end;

  // miscellaneous - needs check!
  TTransportModeCodeType = class(TTokenType);

  TContactTypeCodeType = class(TTokenType);
  TPartyRoleCodeType = class(TTokenType);
  TLineStatusCodeType = class(TTokenType);

  TAllowanceChargeReasonCodeContentType =
  (eAA, eAAA, eAAC, eAAD, eAAE, eAAF,
    eAAH, eAAI, eAAS, eAAT, eAAV, eAAY, eAAZ, eABA, eABB, eABC, eABD, eABF,
    eABK, eABL, eABN, eABR, eABS, eABT, eABU, eACF, eACG, eACH, eACI, eACJ,
    eACK, eACL, eACM, eACS, eADC, eADE, eADJ, eADK, eADL, eADM, eADN, eADO,
    eADP, eADQ, eADR, eADT, eADW, eADY, eADZ, eAEA, eAEB, eAEC, eAED, eAEF,
    eAEH, eAEI, eAEJ, eAEK, eAEL, eAEM, eAEN, eAEO, eAEP, eAES, eAET, eAEU,
    eAEV, eAEW, eAEX, eAEY, eAEZ, eAJ, eAU, eCA, eCAB, eCAD, eCAE, eCAF, eCAI,
    eCAJ, eCAK, eCAL, eCAM, eCAN, eCAO, eCAP, eCAQ, eCAR, eCAS, eCAT, eCAU,
    eCAV, eCAW, eCAX, eCAY, eCAZ, eCD, eCG, eCS, eCT, eDAB, eDAC, eDAD, eDAF,
    eDAG, eDAH, eDAI, eDAJ, eDAK, eDAL, eDAM, eDAN, eDAO, eDAP, eDAQ, eDL, eEG,
    eEP, eER, eFAA, eFAB, eFAC, eFC, eFH, eFI, eGAA, eHAA, eHD, eHH, eIAA, eIAB,
    eID, eIF, eIR, eIS, eKO, eL1, eLA, eLAA, eLAB, eLF, eMAE, eMI, eML, eNAA,
    eOA, ePA, ePAA, ePC, ePL, eRAB, eRAC, eRAD, eRAF, eRE, eRF, eRH, eRV, eSA,
    eSAA, eSAD, eSAE, eSAI, eSG, eSH, eSM, eSU, eTAB, eTAC, eTT, eTV, eV1, eV2,
    eWH, eXAA, eYY, eZZZ, e41, e42, e60, e62, e63, e64, e65, e66, e67, e68, e70,
    e71, e88, e95, e100, e102, e103, e104, e105);

  { 41 - Bonus for works ahead of schedule
    42 - Other bonus
    60 - Manufacturer’s consumer discount
    62 - Due to military status
    63 - Due to work accident
    64 - Special agreement
    65 - Production error discount
    66 - New outlet discount
    67 - Sample discount
    68 - End-of-range discount
    70 - Incoterm discount
    71 - Point of sales threshold allowance
    88 - Material surcharge/deduction
    95 - Discount
    100 - Special rebate
    102 - Fixed long term
    103 - Temporary
    104 - Standard
    105 - Yearly turnover   }

  TAllowanceChargeReasonCodeType = class(TWPXElement)
  private
    FEnumValue: TAllowanceChargeReasonCodeContentType;
  protected
    function GetValueStr: String; override;
    procedure SetValueStr(const s: String); override;
  public
    property value: TAllowanceChargeReasonCodeContentType read FEnumValue
      write FEnumValue;
  end;

  // ISO 3166-1
  TCountryID = (
    UNDEFINED,
    _1A, AD, AE, AF, AG, AI, AL, AM, AO, AQ,
    AR, AS_, AT, AU, AW, AX, AZ, BA, BB, BD, BE, BF, BG, BH, BI,
    BJ, BL, BM, BN, BO, BQ, BR, BS, BT, BV, BW, BY, BZ, CA, CC,
    CD, CF, CG, CH, CI, CK, CL, CM, CN, CO, CR, CU, CV, CW, CX,
    CY, CZ, DE, DJ, DK, DM, DO_, DZ, EC, EE, EG, EH, ER, ES, ET,
    FI, FJ, FK, FM, FO, FR, GA, GB, GD, GE, GF, GG, GH, GI, GL,
    GM, GN, GP, GQ, GR, GS, GT, GU, GW, GY, HK, HM, HN, HR, HT,
    HU, ID, IE, IL, IM, IN_, IO, IQ, IR, IS_, IT, JE, JM, JO, JP,
    KE, KG, KH, KI, KM, KN, KP, KR, KW, KY, KZ, LA, LB, LC, LI,
    LK, LR, LS, LT, LU, LV, LY, MA, MC, MD, ME, MF, MG, MH, MK,
    ML, MM, MN, MO, MP, MQ, MR, MS, MT, MU, MV, MW, MX, MY, MZ,
    NA, NC, NE, NF, NG, NI, NL, NO, NP, NR, NU, NZ, OM, PA, PE,
    PF, PG, PH, PK, PL, PM, PN, PR, PS, PT, PW, PY, QA, RE, RO,
    RS, RU, RW, SA, SB, SC, SD, SE, SG, SH, SI, SJ, SK, SL, SM,
    SN, SO, SR, SS, ST, SV, SX, SY, SZ, TC, TD, TF, TG, TH, TJ,
    TK, TL, TM, TN, TO_, TR, TT, TV, TW, TZ, UA, UG, UM, US, UY,
    UZ, VA, VC, VE, VG, VI, VN, VU, WF, WS, XI, YE, YT, ZA,
    ZM, ZW);

  TCountryIDType = class(TWPXElement)
  private
    FEnumValue: TCountryID;
  protected
    function GetValueStr: String; override;
    procedure SetValueStr(const s: String); override;
  public
    function SetValue( CountryID : TCountryID; Defaults : TWPXDocDefaults  = nil ) : Boolean;  overload;  virtual;
    function Get_SetValueParams( Defaults : TWPXDocDefaults ) : String; override;
    property value: TCountryID read FEnumValue write FEnumValue;
  end;



  TCurrencyCodeType = class(TWPXElementEnum)
  private
    FEnumValue: TCurrencyCode;
  protected
    function GetValueStr: String; override;
    procedure SetValueStr(const s: String); override;
  public
    function SetValue( CurrencyCode : TCurrencyCode; Defaults : TWPXDocDefaults  = nil ) : Boolean;  overload;  virtual;
    function Get_SetValueParams( Defaults : TWPXDocDefaults ) : String; override;
    property value: TCurrencyCode read FEnumValue write FEnumValue;
  end;

  (* defined also:
    TDocumentCodeContentType =(
    e1,  e2,  e3,  e4,  e5,  e6,  e7,  e8,  e9,  e10,  e11,
    e12,  e13,  e14,  e15,  e16,  e17,  e18,  e19,  e20,  e21,
    e22,  e23,  e24,  e25,  e26,  e27,  e28,  e29,  e30,  e31,
    e32,  e33,  e34,  e35,  e36,  e37,  e38,  e39,  e40,  e41,
    e42,  e43,  e44,  e45,  e46,  e47,  e48,  e49,  e50,  e51,
    e52,  e53,  e54,  e55,  e56,  e57,  e58,  e59,  e60,  e61,
    e62,  e63,  e64,  e65,  e66,  e67,  e68,  e69,  e70,  e71,
    e72,  e73,  e74,  e75,  e76,  e77,  e78,  e79,  e80,  e81,
    e82,  e83,  e84,  e85,  e86,  e87,  e88,  e89,  e90,  e91,
    e92,  e93,  e94,  e95,  e96,  e97,  e98,  e99,  e100,  e101,
    e102,  e103,  e104,  e105,  e106,  e107,  e108,  e109,  e110,  e111,
    e112,  e113,  e114,  e115,  e116,  e117,  e118,  e119,  e120,  e121,
    e122,  e123,  e124,  e125,  e126,  e127,  e128,  e129,  e130,  e131,
    e132,  e133,  e134,  e135,  e136,  e137,  e138,  e139,  e140,  e141,
    e142,  e143,  e144,  e145,  e146,  e147,  e148,  e149,  e150,  e151,
    e152,  e153,  e154,  e155,  e156,  e157,  e158,  e159,  e160,  e161,
    e162,  e163,  e164,  e165,  e166,  e167,  e168,  e169,  e170,  e171,
    e172,  e173,  e174,  e175,  e176,  e177,  e178,  e179,  e180,  e181,
    e182,  e183,  e184,  e185,  e186,  e187,  e188,  e189,  e190,  e191,
    e192,  e193,  e194,  e195,  e196,  e197,  e198,  e199,  e200,  e201,
    e202,  e203,  e204,  e205,  e206,  e207,  e208,  e209,  e210,  e211,
    e212,  e213,  e214,  e215,  e216,  e217,  e218,  e219,  e220,  e221,
    e222,  e223,  e224,  e225,  e226,  e227,  e228,  e229,  e230,  e231,
    e232,  e233,  e234,  e235,  e236,  e237,  e238,  e239,  e240,  e241,
    e242,  e243,  e244,  e245,  e246,  e247,  e248,  e249,  e250,  e251,
    e252,  e253,  e254,  e255,  e256,  e257,  e258,  e259,  e260,  e261,
    e262,  e263,  e264,  e265,  e266,  e267,  e268,  e269,  e270,  e271,
    e272,  e273,  e274,  e275,  e276,  e277,  e278,  e279,  e280,  e281,
    e282,  e283,  e284,  e285,  e286,  e287,  e288,  e289,  e290,  e291,
    e292,  e293,  e294,  e295,  e296,  e297,  e298,  e299,  e300,  e301,
    e302,  e303,  e304,  e305,  e306,  e307,  e308,  e309,  e310,  e311,
    e312,  e313,  e314,  e315,  e316,  e317,  e318,  e319,  e320,  e321,
    e322,  e323,  e324,  e325,  e326,  e327,  e328,  e329,  e330,  e331,
    e332,  e333,  e334,  e335,  e336,  e337,  e338,  e339,  e340,  e341,
    e342,  e343,  e344,  e345,  e346,  e347,  e348,  e349,  e350,  e351,
    e352,  e353,  e354,  e355,  e356,  e357,  e358,  e359,  e360,  e361,
    e362,  e363,  e364,  e365,  e366,  e367,  e368,  e369,  e370,  e371,
    e372,  e373,  e374,  e375,  e376,  e377,  e378,  e379,  e380,  e381,
    e382,  e383,  e384,  e385,  e386,  e387,  e388,  e389,  e390,  e391,
    e392,  e393,  e394,  e395,  e396,  e397,  e398,  e399,  e400,  e401,
    e402,  e403,  e404,  e405,  e406,  e407,  e408,  e409,  e410,  e411,
    e412,  e413,  e414,  e415,  e416,  e417,  e418,  e419,  e420,  e421,
    e422,  e423,  e424,  e425,  e426,  e427,  e428,  e429,  e430,  e431,
    e432,  e433,  e434,  e435,  e436,  e437,  e438,  e439,  e440,  e441,
    e442,  e443,  e444,  e445,  e446,  e447,  e448,  e449,  e450,  e451,
    e452,  e453,  e454,  e455,  e456,  e457,  e458,  e459,  e460,  e461,
    e462,  e463,  e464,  e465,  e466,  e467,  e468,  e469,  e470,  e481,
    e482,  e483,  e484,  e485,  e486,  e487,  e488,  e489,  e490,  e491,
    e493,  e494,  e495,  e496,  e497,  e498,  e499,  e520,  e521,  e522,
    e523,  e524,  e525,  e526,  e527,  e528,  e529,  e530,  e531,  e532,
    e533,  e534,  e535,  e536,  e537,  e538,  e539,  e550,  e551,  e552,
    e553,  e554,  e575,  e576,  e577,  e578,  e579,  e580,  e581,  e582,
    e583,  e584,  e585,  e586,  e587,  e588,  e589,  e610,  e621,  e622,
    e623,  e624,  e625,  e626,  e627,  e628,  e629,  e630,  e631,  e632,
    e633,  e634,  e635,  e636,  e637,  e638,  e639,  e640,  e641,  e642,
    e643,  e644,  e645,  e646,  e647,  e648,  e649,  e650,  e651,  e652,
    e653,  e654,  e655,  e656,  e657,  e658,  e659,  e700,  e701,  e702,
    e703,  e704,  e705,  e706,  e707,  e708,  e709,  e710,  e711,  e712,
    e713,  e714,  e715,  e716,  e717,  e718,  e719,  e720,  e721,  e722,
    e723,  e724,  e725,  e726,  e727,  e728,  e729,  e730,  e731,  e732,
    e733,  e734,  e735,  e736,  e737,  e738,  e739,  e740,  e741,  e742,
    e743,  e744,  e745,  e746,  e747,  e748,  e749,  e750,  e751,  e752,
    e753,  e754,  e755,  e756,  e757,  e758,  e759,  e760,  e761,  e762,
    e763,  e764,  e765,  e766,  e767,  e768,  e769,  e770,  e771,  e772,
    e773,  e774,  e775,  e776,  e777,  e778,  e779,  e780,  e781,  e782,
    e783,  e784,  e785,  e786,  e787,  e788,  e789,  e790,  e791,  e792,
    e793,  e794,  e795,  e796,  e797,  e798,  e799,  e810,  e811,  e812,
    e813,  e814,  e815,  e816,  e817,  e818,  e819,  e820,  e821,  e822,
    e823,  e824,  e825,  e826,  e827,  e828,  e829,  e830,  e831,  e832,
    e833,  e834,  e835,  e836,  e837,  e838,  e839,  e840,  e841,  e842,
    e843,  e844,  e845,  e846,  e847,  e848,  e849,  e850,  e851,  e852,
    e853,  e854,  e855,  e856,  e857,  e858,  e859,  e860,  e861,  e862,
    e863,  e864,  e865,  e866,  e867,  e868,  e869,  e870,  e871,  e872,
    e873,  e874,  e875,  e876,  e877,  e878,  e879,  e890,  e891,  e892,
    e893,  e894,  e895,  e896,  e901,  e910,  e911,  e913,  e914,  e915,
    e916,  e917,  e925,  e926,  e927,  e929,  e930,  e931,  e932,  e933,
    e934,  e935,  e936,  e937,  e938,  e940,  e941,  e950,  e951,  e952,
    e953,  e954,  e955,  e960,  e961,  e962,  e963,  e964,  e965,  e966,
    e970,  e971,  e972,  e974,  e975,  e976,  e977,  e978,  e979,  e990,
    e991,  e995,  e996,  e998); *)

 { TDocumentCodeContentType = (e50, e80, e81, e82, e83, e84, e130, e202, e203,
    e204, e211, e261, e262, e295, e296, e308, e325, e326, e380, e381, e383,
    e384, e385, e386, e387, e388, e389, e390, e393, e394, e395, e396, e420,
    e456, e457, e458, e527, e575, e623, e633, e751, e780, e875, e876, e877,
    e916, e935);  }

   // EN16931-ID: BT-3
  TDocumentCode = (
    cZZZ_as_provided_as_String, // See String Value!
    c380_Commercial_invoice, // must be first in this list!
    c381_Credit_notification,
    c384_Invoice_correction,
    c389_Self_billed_invoice, { - credit note within
       a credit note process (an invoice made out by the Payment
       Undertaker instead of by the seller).   }
    c261_Self_billed_credit_note, { a document which indicates that the
    customer is claiming credit in a self billing environment }
    c386_Prepayment, { An invoice which requires a prepayment for products.
    The respective amounts will be deducted in the final bill.  }
    c326_Partial_billing, { For profiles BASIC WL and MINIMUM,
    the following code must be used exclusively:   }
    c751_Invoice_information_for_accounting,
    c51_Posting_aid_NO_invoice
  );

  TDocumentCodeType = class(TWPXElementEnum)
  private
    function GetEnumValue :  TDocumentCode;
    procedure SetEnumValue(x : TDocumentCode);
  public
    function Get_SetValueParams( Defaults : TWPXDocDefaults ) : String; override;
    function SetValue( value : TDocumentCode; Defaults : TWPXDocDefaults  = nil ) : Boolean;  overload;
    property value: TDocumentCode read GetEnumValue write SetEnumValue;
  end;

  /// <summary>
    /// Code for free text unstructured information about the invoice as a whole
    /// </summary>

     (*
        /// <summary>
        ///  Die Ware bleibt bis zur vollständigen Bezahlung
        ///  unser Eigentum.
        /// </summary>
        EEV,

        /// <summary>
        /// Die Ware bleibt bis zur vollständigen Bezahlung
        /// aller Forderungen unser Eigentum.
        /// </summary>
        WEV,

        /// <summary>
        /// Die Ware bleibt bis zur vollständigen Bezahlung
        /// unser Eigentum. Dies gilt auch im Falle der
        /// Weiterveräußerung oder -verarbeitung der Ware.
        /// </summary>
        VEV,

        /// <summary>
        /// Es ergeben sich Entgeltminderungen auf Grund von
        /// Rabatt- und Bonusvereinbarungen.
        /// </summary>
        ST1,

        /// <summary>
        /// Entgeltminderungen ergeben sich aus unseren
        /// aktuellen Rahmen- und Konditionsvereinbarungen.
        /// </summary>
        ST2,

        /// <summary>
        /// Es bestehen Rabatt- oder Bonusvereinbarungen.
        /// </summary>
        ST3,

        /// <summary>
        /// Unbekannter Wert
        /// </summary>
        Unknown

        *)


  TFormattedDateTimeFormatContentType = string;

  {   // EN16931-ID: BT-81
  10 : Species
  20 : Check
  30 : Transfer (includes SEPA transfer for CHORUSPRO)
  42 : Payment to bank account
  48 : Payment by credit card
  49 : Direct debit (includes SEPA direct debit for CHORUSPRO)
  57 : Standind agreement
  58 : SEPA Credit Transfer (not used for CHORUSPRO: code 30)
  59 : SEPA Direct Debit (not used for CHORUSPRO: code 49)
  97 : Report ZZZ : agreed among trading partners on interim basis }


  // 2.3.2
  TPaymentMeansCodeContentType = (e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11,
  e12, e13, e14, e15, e16, e17, e18, e19, e20, e21, e22, e23, e24, e25, e26,
  e27, e28, e29, e30, e31, e32, e33, e34, e35, e36, e37, e38, e39, e40, e41,
  e42, e43, e44, e45, e46, e47, e48, e49, e50, e51, e52, e53, e54, e55, e56,
  e57, e58, e59, e60, e61, e62, e63, e64, e65, e66, e67, e68, e69, e70, e74,
  e75, e76, e77, e78, e91, e92, e93, e94, e95, e96, e97, eZZZ);

  TPaymentMeansCodeType = class(TWPXElementEnum)
  private
    FEnumValue: TPaymentMeansCodeContentType;
  protected
    function GetValueStr: String; override;
    procedure SetValueStr(const s: String); override;
  public
    property value: TPaymentMeansCodeContentType read FEnumValue
      write FEnumValue;
  end;

  TReferenceCodeContentType = (eAAA, eAAB, eAAC, eAAD, eAAE, eAAF, eAAG, eAAH,
    eAAI, eAAJ, eAAK, eAAL, eAAM, eAAN, eAAO, eAAP, eAAQ, eAAR, eAAS, eAAT,
    eAAU, eAAV, eAAW, eAAX, eAAY, eAAZ, eABA, eABB, eABC, eABD, eABE, eABF,
    eABG, eABH, eABI, eABJ, eABK, eABL, eABM, eABN, eABO, eABP, eABQ, eABR,
    eABS, eABT, eABU, eABV, eABW, eABX, eABY, eABZ, eAC, eACA, eACB, eACC, eACD,
    eACE, eACF, eACG, eACH, eACI, eACJ, eACK, eACL, eACN, eACO, eACP, eACQ,
    eACR, eACT, eACU, eACV, eACW, eACX, eACY, eACZ, eADA, eADB, eADC, eADD,
    eADE, eADF, eADG, eADI, eADJ, eADK, eADL, eADM, eADN, eADO, eADP, eADQ,
    eADT, eADU, eADV, eADW, eADX, eADY, eADZ, eAE, eAEA, eAEB, eAEC, eAED, eAEE,
    eAEF, eAEG, eAEH, eAEI, eAEJ, eAEK, eAEL, eAEM, eAEN, eAEO, eAEP, eAEQ,
    eAER, eAES, eAET, eAEU, eAEV, eAEW, eAEX, eAEY, eAEZ, eAF, eAFA, eAFB, eAFC,
    eAFD, eAFE, eAFF, eAFG, eAFH, eAFI, eAFJ, eAFK, eAFL, eAFM, eAFN, eAFO,
    eAFP, eAFQ, eAFR, eAFS, eAFT, eAFU, eAFV, eAFW, eAFX, eAFY, eAFZ, eAGA,
    eAGB, eAGC, eAGD, eAGE, eAGF, eAGG, eAGH, eAGI, eAGJ, eAGK, eAGL, eAGM,
    eAGN, eAGO, eAGP, eAGQ, eAGR, eAGS, eAGT, eAGU, eAGV, eAGW, eAGX, eAGY,
    eAGZ, eAHA, eAHB, eAHC, eAHD, eAHE, eAHF, eAHG, eAHH, eAHI, eAHJ, eAHK,
    eAHL, eAHM, eAHN, eAHO, eAHP, eAHQ, eAHR, eAHS, eAHT, eAHU, eAHV, eAHX,
    eAHY, eAHZ, eAIA, eAIB, eAIC, eAID, eAIE, eAIF, eAIG, eAIH, eAII, eAIJ,
    eAIK, eAIL, eAIM, eAIN, eAIO, eAIP, eAIQ, eAIR, eAIS, eAIT, eAIU, eAIV,
    eAIW, eAIX, eAIY, eAIZ, eAJA, eAJB, eAJC, eAJD, eAJE, eAJF, eAJG, eAJH,
    eAJI, eAJJ, eAJK, eAJL, eAJM, eAJN, eAJO, eAJP, eAJQ, eAJR, eAJS, eAJT,
    eAJU, eAJV, eAJW, eAJX, eAJY, eAJZ, eAKA, eAKB, eAKC, eAKD, eAKE, eAKF,
    eAKG, eAKH, eAKI, eAKJ, eAKK, eAKL, eAKM, eAKN, eAKO, eAKP, eAKQ, eAKR,
    eAKS, eAKT, eAKU, eAKV, eAKW, eAKX, eAKY, eAKZ, eALA, eALB, eALC, eALD,
    eALE, eALF, eALG, eALH, eALI, eALJ, eALK, eALL, eALM, eALN, eALO, eALP,
    eALQ, eALR, eALS, eALT, eALU, eALV, eALW, eALX, eALY, eALZ, eAMA, eAMB,
    eAMC, eAMD, eAME, eAMF, eAMG, eAMH, eAMI, eAMJ, eAMK, eAML, eAMM, eAMN,
    eAMO, eAMP, eAMQ, eAMR, eAMS, eAMT, eAMU, eAMV, eAMW, eAMX, eAMY, eAMZ,
    eANA, eANB, eANC, eAND, eANE, eANF, eANG, eANH, eANI, eANJ, eANK, eANL,
    eANM, eANN, eANO, eANP, eANQ, eANR, eANS, eANT, eANU, eANV, eANW, eANX,
    eANY, eAOA, eAOD, eAOE, eAOF, eAOG, eAOH, eAOI, eAOJ, eAOK, eAOL, eAOM,
    eAON, eAOO, eAOP, eAOQ, eAOR, eAOS, eAOT, eAOU, eAOV, eAOW, eAOX, eAOY,
    eAOZ, eAP, eAPA, eAPB, eAPC, eAPD, eAPE, eAPF, eAPG, eAPH, eAPI, eAPJ, eAPK,
    eAPL, eAPM, eAPN, eAPO, eAPP, eAPQ, eAPR, eAPS, eAPT, eAPU, eAPV, eAPW,
    eAPX, eAPY, eAPZ, eAQA, eAQB, eAQC, eAQD, eAQE, eAQF, eAQG, eAQH, eAQI,
    eAQJ, eAQK, eAQL, eAQM, eAQN, eAQO, eAQP, eAQQ, eAQR, eAQS, eAQT, eAQU,
    eAQV, eAQW, eAQX, eAQY, eAQZ, eARA, eARB, eARC, eARD, eARE, eARF, eARG,
    eARH, eARI, eARJ, eARK, eARL, eARM, eARN, eARO, eARP, eARQ, eARR, eARS,
    eART, eARU, eARV, eARW, eARX, eARY, eARZ, eASA, eASB, eASC, eASD, eASE,
    eASF, eASG, eASH, eASI, eASJ, eASK, eASL, eASM, eASN, eASO, eASP, eASQ,
    eASR, eASS, eAST, eASU, eASV, eASW, eASX, eASY, eASZ, eATA, eATB, eATC,
    eATD, eATE, eATF, eATG, eATH, eATI, eATJ, eATK, eATL, eATM, eATN, eATO,
    eATP, eATQ, eATR, eATS, eATT, eATU, eATV, eATW, eATX, eATY, eATZ, eAU, eAUA,
    eAUB, eAUC, eAUD, eAUE, eAUF, eAUG, eAUH, eAUI, eAUJ, eAUK, eAUL, eAUM,
    eAUN, eAUO, eAUP, eAUQ, eAUR, eAUS, eAUT, eAUU, eAUV, eAUW, eAUX, eAUY,
    eAUZ, eAV, eAVA, eAVB, eAVC, eAVD, eAVE, eAVF, eAVG, eAVH, eAVI, eAVJ, eAVK,
    eAVL, eAVM, eAVN, eAVO, eAVP, eAVQ, eAVR, eAVS, eAVT, eAVU, eAVV, eAVW,
    eAVX, eAVY, eAVZ, eAWA, eAWB, eAWC, eAWD, eAWE, eAWF, eAWG, eAWH, eAWI,
    eAWJ, eAWK, eAWL, eAWM, eAWN, eAWO, eAWP, eAWQ, eAWR, eAWS, eAWT, eAWU,
    eAWV, eAWW, eAWX, eAWY, eAWZ, eAXA, eAXB, eAXC, eAXD, eAXE, eAXF, eAXG,
    eAXH, eAXI, eAXJ, eAXK, eAXL, eAXM, eAXN, eAXO, eAXP, eAXQ, eAXR, eAXS, eBA,
    eBC, eBD, eBE, eBH, eBM, eBN, eBO, eBR, eBT, eBTP, eBW, eCAS, eCAT, eCAU,
    eCAV, eCAW, eCAX, eCAY, eCAZ, eCBA, eCBB, eCD, eCEC, eCED, eCFE, eCFF, eCFO,
    eCG, eCH, eCK, eCKN, eCM, eCMR, eCN, eCNO, eCOF, eCP, eCR, eCRN, eCS, eCST,
    eCT, eCU, eCV, eCW, eCZ, eDA, eDAN, eDB, eDI, eDL, eDM, eDQ, eDR, eEA, eEB,
    eED, eEE, eEEP, eEI, eEN, eEQ, eER, eERN, eET, eEX, eFC, eFF, eFI, eFLW,
    eFN, eFO, eFS, eFT, eFV, eFX, eGA, eGC, eGD, eGDN, eGN, eHS, eHWB, eIA, eIB,
    eICA, eICE, eICO, eII, eIL, eINB, eINN, eINO, eIP, eIS, eIT, eIV, eJB, eJE,
    eLA, eLAN, eLAR, eLB, eLC, eLI, eLO, eLRC, eLS, eMA, eMB, eMF, eMG, eMH,
    eMR, eMRN, eMS, eMSS, eMWB, eNA, eNF, eOH, eOI, eON, eOP, eOR, ePB, ePC,
    ePD, ePE, ePF, ePI, ePK, ePL, ePOR, ePP, ePQ, ePR, ePS, ePW, ePY, eRA, eRC,
    eRCN, eRE, eREN, eRF, eRR, eRT, eSA, eSB, eSD, eSE, eSEA, eSF, eSH, eSI,
    eSM, eSN, eSP, eSQ, eSRN, eSS, eSTA, eSW, eSZ, eTB, eTCR, eTE, eTF, eTI,
    eTIN, eTL, eTN, eTP, eUAR, eUC, eUCN, eUN, eUO, eURI, eVA, eVC, eVGR, eVM,
    eVN, eVON, eVOR, eVP, eVR, eVS, eVT, eVV, eWE, eWM, eWN, eWR, eWS, eWY, eXA,
    eXC, eXP, eZZZ);

  TReferenceCodeType = class(TWPXElementEnum)
  private
    FEnumValue: TReferenceCodeContentType;
  protected
    function GetValueStr: String; override;
    procedure SetValueStr(const s: String); override;
  public
    property value: TReferenceCodeContentType read FEnumValue write FEnumValue;
  end;

///<summary>
/// This code defines an enumeration called TTaxCategory which categorizes different types of tax statuses.
/// The categories include options for reverse charge VAT, exemptions from tax, and specific conditions related
/// to exports, services, and standard tax rates. Each category is represented by a unique identifier
/// for easy referencing.
///
/// <param name="AE_VAT_Reverse_Charge" type="Enum">Indicates that the reverse charge mechanism for VAT applies.</param>
/// <param name="E_Exempt_from_tax" type="Enum">Indicates that the item is exempt from tax.</param>
/// <param name="G_Free_export_item_tax_not_charged" type="Enum">[B] Indicates that tax does not apply to items exported outside the European Community.</param>
/// <param name="K_VAT_exempt_for_EEA" type="Enum">[EB] Indicates that VAT is exempt for transactions within the European Economic Area.</param>
/// <param name="L_Canary_Islands_general_indirect_tax" type="Enum">Indicates the specific tax rules for the Canary Islands.</param>
/// <param name="M_Tax_for_psi_Ceuta_and_Melilla" type="Enum">Indicates the tax regulations specific to Ceuta and Melilla regions.</param>
/// <param name="O_Services_outside_scope_of_tax" type="Enum">Indicates services that are outside the scope of tax.</param>
/// <param name="S_Standard_rate" type="Enum">[B] Indicates the standard tax rate applies.</param>
/// <param name="Z_Zero_rated_goods" type="Enum">Indicates goods that are zero-rated for tax purposes.</param>
/// <summary>


  TTaxCategory = (
     AE_VAT_Reverse_Charge,
     // Mehrwertsteuer entfällt (befreit)
     E_Exempt_from_tax,
     // (B) MwSt. entfällt bei Export außerhalb der Europäischen Gemeinschaft
     G_Free_export_item_tax_not_charged,
     // (EB) Innergemeinschaftliche Lieferung
     K_VAT_exempt_for_EEA,
     // MwSt für Verkäufe in den Gebieten der Kanarischen Inseln
     L_Canary_Islands_general_indirect_tax,
     // MwSt für Verkäufe in den Gebieten von Ceuta und Melilla
     M_Tax_for_psi_Ceuta_and_Melilla,
     // Nicht im Geltunsgbereich
     O_Services_outside_scope_of_tax,
     // (N) Standard TAX
     S_Standard_rate,
     // TAX is 0
     Z_Zero_rated_goods
   );

  TTaxCategoryCodeType = class(TWPXElementEnum)
  private
    FEnumValue: TTaxCategory;
  protected
    function GetValueStr: String; override;
    procedure SetValueStr(const s: String); override;
  public
    function Get_SetValueParams( Defaults : TWPXDocDefaults ) : String; override;
    function SetValue( value : TTaxCategory; Defaults : TWPXDocDefaults  = nil ) : Boolean;  overload;

    property value: TTaxCategory read FEnumValue
      write FEnumValue;
  end;

  TTaxTypeCodeContentType = (eAAA, eAAB, eAAC, eAAD, eAAE, eAAF, eAAG, eAAH,
    eAAI, eAAJ, eAAK, eAAL, eAAM, eADD, eBOL, eCAP, eCAR, eCOC, eCST, eCUD,
    eCVD, eENV, eEXC, eEXP, eFET, eFRE, eGCN, eGST, eILL, eIMP, eIND, eLAC,
    eLCN, eLDP, eLOC, eLST, eMCA, eMCD, eOTH, ePDB, ePDC, ePRF, eSCN, eSSS,
    eSTT, eSUP, eSUR, eSWT, eTAC, eTOT, eTOX, eTTA, eVAD, eVAT);

  TTaxTypeCodeType = class(TWPXElementEnum)
  private
    FEnumValue: TTaxTypeCodeContentType;
  protected
    function GetValueStr: String; override;
    procedure SetValueStr(const s: String); override;
  public
    property value: TTaxTypeCodeContentType read FEnumValue write FEnumValue;
  end;

  TTimeReferenceCodeContentType = (e5, e29, e72);

  TTimeReferenceCodeType = class(TWPXElementEnum)
  private
    FEnumValue: TTimeReferenceCodeContentType;
  protected
    function GetValueStr: String; override;
    procedure SetValueStr(const s: String); override;
  public
    property value: TTimeReferenceCodeContentType read FEnumValue
      write FEnumValue;
  end;

  TAccountingAccountTypeCodeContentType = (e1, e2, e3, e4, e5, e6, e7);

  TAccountingAccountTypeCodeType = class(TWPXElementEnum)
  private
    FEnumValue: TAccountingAccountTypeCodeContentType;
  protected
    function GetValueStr: String; override;
    procedure SetValueStr(const s: String); override;
  public
    property value: TAccountingAccountTypeCodeContentType read FEnumValue
      write FEnumValue;
  end;

  TDeliveryTermsCodeContentType = (
     e1, e2, eCFR, eCIF,
     eCIP, eCPT, eDAP, eDAT,
     eDDP, eEXW, eFAS, eFCA, eFOB);

  TDeliveryTermsCodeType = class(TWPXElementEnum)
  private
    FEnumValue: TDeliveryTermsCodeContentType;
  protected
    function GetValueStr: String; override;
    procedure SetValueStr(const s: String); override;
  public
    property value: TDeliveryTermsCodeContentType read FEnumValue
      write FEnumValue;
  end;

  TDateTimeStringType = class(TWPXSequenceStringsURN)
  private
    FDateValue: TDateTime;
    fformat: String;
  public
    function AttributeCount: Integer; override;
    function AttributeGet(Index: Integer; var AName, AValue: String)
      : Boolean; override;
    function AttributeSet(const AName, AValue: String): Boolean; override;
  protected
    function GetValueStr: String; override;
    procedure SetValueStr(const s: String); override;
  public
    constructor Create; override;
    property format: String read fformat write fformat; // xs:string = required
    property value: TDateTime read FDateValue write FDateValue;
  end;

  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // This classes have been manually added
  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  // added for indicators  (manually!)
  TXIndicator = ( Indicator );
  TIndicator=class(TWPXSequence<TXIndicator>)
  private
    function get_0 : TBooleanType;
  public
    constructor Create; override;
    function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
    property Indicator : TBooleanType read get_0;
  end;

  TXFormattedDateTime = ( DateTimeString );
  TFormattedDateTime=class(TWPXSequence<TXFormattedDateTime>)
  private
    function get_0 : TDateTimeStringType;
  public
    constructor Create; override;
    function GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass; override;
    property DateTimeString : TDateTimeStringType read get_0;
  end;
  TDateTimeType = TFormattedDateTime;
  TDateType = TFormattedDateTime;


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

  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  function TWPXMLMakeSaveString(const s : String) : String;

  // Round to 2 decimals
  function WPXCurrencyRound( value : Double ) : Double;
  function WPXCurrencyStrToFloat( value : String ) : Double;

const
  wpxCountryIDContentType: array [TCountryID] of string = ('UNDEFINED', '1A',
    'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT',
    'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI',
    'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY',
    'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN',
    'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM',
    'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK',
    'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL',
    'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM',
    'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR',
    'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN',
    'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS',
    'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK',
    'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW',
    'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP',
    'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM',
    'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW',
    'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM',
    'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF',
    'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW',
    'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI',
    'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW');


resourcestring
  sNOXML = 'XMLSupport has not been linked';
  sXMLHeader = '<?xml version=' + #39 + '1.0' + #39 + ' encoding=' + #39 + 'UTF-8' + #39 + ' ?>';
  sXMLComment = '<!-- WPXOrder https://www.wpcubed.com/pdf/products/xorder/ -->';

implementation

// qualified

function TWPXMLMakeSaveString(const s : String) : String;
    var i, sl, l, m : Integer;
    res : String;
    procedure Add( const r : String );
    var j : Integer;
    begin for j := 1 to Length(r) do
          begin inc(l);
                res[l] := r[j];
          end;
    end;
begin
  if s='' then Result := '' else
  begin
     sl := Length(s);
     m := sl + 30;
     SetLength(res, m);
     l := 0;
     for I := 1 to sl do
     begin
       if l+5>m then
       begin
         inc(m,30);
         SetLength(res, m);
       end;
       if s[i]='&' then Add('&amp;')
       else if s[i]='<' then Add('&gt;')
       else if s[i]='>' then Add('&lt;')
       else // Remove control codes
       if s[i]>=#9 then
       begin
         inc(l);
         res[l] := s[i];
       end;
     end;
     SetLength(res, l);
     Result := res;
  end;
end;

function WPXCurrencyRound( value : Double ) : Double;
begin
  Result := Round( value * 100 ) / 100;
end;


function WPXCurrencyStrToFloat( value : String ) : Double;
var frm: TFormatSettings;
begin
  frm := TFormatSettings.Create;
  frm.DecimalSeparator := '.';
  if value = '' then Result := 0 else Result := StrToFloat(value, frm);
end;

const
  wpxAllowanceChargeReasonCodeContentType
    : array [TAllowanceChargeReasonCodeContentType] of string = ('AA', 'AAA',
    'AAC', 'AAD', 'AAE', 'AAF', 'AAH', 'AAI', 'AAS', 'AAT', 'AAV', 'AAY', 'AAZ',
    'ABA', 'ABB', 'ABC', 'ABD', 'ABF', 'ABK', 'ABL', 'ABN', 'ABR', 'ABS', 'ABT',
    'ABU', 'ACF', 'ACG', 'ACH', 'ACI', 'ACJ', 'ACK', 'ACL', 'ACM', 'ACS', 'ADC',
    'ADE', 'ADJ', 'ADK', 'ADL', 'ADM', 'ADN', 'ADO', 'ADP', 'ADQ', 'ADR', 'ADT',
    'ADW', 'ADY', 'ADZ', 'AEA', 'AEB', 'AEC', 'AED', 'AEF', 'AEH', 'AEI', 'AEJ',
    'AEK', 'AEL', 'AEM', 'AEN', 'AEO', 'AEP', 'AES', 'AET', 'AEU', 'AEV', 'AEW',
    'AEX', 'AEY', 'AEZ', 'AJ', 'AU', 'CA', 'CAB', 'CAD', 'CAE', 'CAF', 'CAI',
    'CAJ', 'CAK', 'CAL', 'CAM', 'CAN', 'CAO', 'CAP', 'CAQ', 'CAR', 'CAS', 'CAT',
    'CAU', 'CAV', 'CAW', 'CAX', 'CAY', 'CAZ', 'CD', 'CG', 'CS', 'CT', 'DAB',
    'DAC', 'DAD', 'DAF', 'DAG', 'DAH', 'DAI', 'DAJ', 'DAK', 'DAL', 'DAM', 'DAN',
    'DAO', 'DAP', 'DAQ', 'DL', 'EG', 'EP', 'ER', 'FAA', 'FAB', 'FAC', 'FC',
    'FH', 'FI', 'GAA', 'HAA', 'HD', 'HH', 'IAA', 'IAB', 'ID', 'IF', 'IR', 'IS',
    'KO', 'L1', 'LA', 'LAA', 'LAB', 'LF', 'MAE', 'MI', 'ML', 'NAA', 'OA', 'PA',
    'PAA', 'PC', 'PL', 'RAB', 'RAC', 'RAD', 'RAF', 'RE', 'RF', 'RH', 'RV', 'SA',
    'SAA', 'SAD', 'SAE', 'SAI', 'SG', 'SH', 'SM', 'SU', 'TAB', 'TAC', 'TT',
    'TV', 'V1', 'V2', 'WH', 'XAA', 'YY', 'ZZZ', '41', '42', '60', '62', '63',
    '64', '65', '66', '67', '68', '70', '71', '88', '95', '100', '102', '103',
    '104', '105');



  wpxCurrencyCodeContentType: array [TCurrencyCode]
    of string = ('AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG',
    'AZN', 'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BOV',
    'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHE', 'CHF', 'CHW',
    'CLF', 'CLP', 'CNY', 'COP', 'COU', 'CRC', 'CUC', 'CUP', 'CVE', 'CZK', 'DJF',
    'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'GBP', 'GEL',
    'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF',
    'IDR', 'ILS', 'INR', 'IQD', 'IRR', 'ISK', 'JMD', 'JOD', 'JPY', 'KES', 'KGS',
    'KHR', 'KMF', 'KPW', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD',
    'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR',
    'MVR', 'MWK', 'MXN', 'MXV', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR',
    'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON',
    'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLL',
    'SOS', 'SRD', 'SSP', 'STN', 'SVC', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND',
    'TOP', 'TRY', 'TTD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'USN', 'UYI', 'UYU',
    'UYW', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XAG', 'XAU', 'XBA', 'XBB',
    'XBC', 'XBD', 'XCD', 'XDR', 'XOF', 'XPD', 'XPF', 'XPT', 'XSU', 'XTS', 'XUA',
    'XXX', 'YER', 'ZAR', 'ZMW', 'ZWL');

  wpxDocumentCodeContentType: array [TDocumentCode]
    of string = (
     'ZZZ', '380', '381', '384',
     '389', '261', '386', '326',
     '751',
     '51'
    );

  wpxPaymentMeansCodeContentType: array [TPaymentMeansCodeContentType]
    of string = ('1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12',
    '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24',
    '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36',
    '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48',
    '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60',
    '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '74', '75',
    '76', '77', '78', '91', '92', '93', '94', '95', '96', '97', 'ZZZ');

  wpxReferenceCodeContentType: array [TReferenceCodeContentType]
    of string = ('AAA', 'AAB', 'AAC', 'AAD', 'AAE', 'AAF', 'AAG', 'AAH', 'AAI',
    'AAJ', 'AAK', 'AAL', 'AAM', 'AAN', 'AAO', 'AAP', 'AAQ', 'AAR', 'AAS', 'AAT',
    'AAU', 'AAV', 'AAW', 'AAX', 'AAY', 'AAZ', 'ABA', 'ABB', 'ABC', 'ABD', 'ABE',
    'ABF', 'ABG', 'ABH', 'ABI', 'ABJ', 'ABK', 'ABL', 'ABM', 'ABN', 'ABO', 'ABP',
    'ABQ', 'ABR', 'ABS', 'ABT', 'ABU', 'ABV', 'ABW', 'ABX', 'ABY', 'ABZ', 'AC',
    'ACA', 'ACB', 'ACC', 'ACD', 'ACE', 'ACF', 'ACG', 'ACH', 'ACI', 'ACJ', 'ACK',
    'ACL', 'ACN', 'ACO', 'ACP', 'ACQ', 'ACR', 'ACT', 'ACU', 'ACV', 'ACW', 'ACX',
    'ACY', 'ACZ', 'ADA', 'ADB', 'ADC', 'ADD', 'ADE', 'ADF', 'ADG', 'ADI', 'ADJ',
    'ADK', 'ADL', 'ADM', 'ADN', 'ADO', 'ADP', 'ADQ', 'ADT', 'ADU', 'ADV', 'ADW',
    'ADX', 'ADY', 'ADZ', 'AE', 'AEA', 'AEB', 'AEC', 'AED', 'AEE', 'AEF', 'AEG',
    'AEH', 'AEI', 'AEJ', 'AEK', 'AEL', 'AEM', 'AEN', 'AEO', 'AEP', 'AEQ', 'AER',
    'AES', 'AET', 'AEU', 'AEV', 'AEW', 'AEX', 'AEY', 'AEZ', 'AF', 'AFA', 'AFB',
    'AFC', 'AFD', 'AFE', 'AFF', 'AFG', 'AFH', 'AFI', 'AFJ', 'AFK', 'AFL', 'AFM',
    'AFN', 'AFO', 'AFP', 'AFQ', 'AFR', 'AFS', 'AFT', 'AFU', 'AFV', 'AFW', 'AFX',
    'AFY', 'AFZ', 'AGA', 'AGB', 'AGC', 'AGD', 'AGE', 'AGF', 'AGG', 'AGH', 'AGI',
    'AGJ', 'AGK', 'AGL', 'AGM', 'AGN', 'AGO', 'AGP', 'AGQ', 'AGR', 'AGS', 'AGT',
    'AGU', 'AGV', 'AGW', 'AGX', 'AGY', 'AGZ', 'AHA', 'AHB', 'AHC', 'AHD', 'AHE',
    'AHF', 'AHG', 'AHH', 'AHI', 'AHJ', 'AHK', 'AHL', 'AHM', 'AHN', 'AHO', 'AHP',
    'AHQ', 'AHR', 'AHS', 'AHT', 'AHU', 'AHV', 'AHX', 'AHY', 'AHZ', 'AIA', 'AIB',
    'AIC', 'AID', 'AIE', 'AIF', 'AIG', 'AIH', 'AII', 'AIJ', 'AIK', 'AIL', 'AIM',
    'AIN', 'AIO', 'AIP', 'AIQ', 'AIR', 'AIS', 'AIT', 'AIU', 'AIV', 'AIW', 'AIX',
    'AIY', 'AIZ', 'AJA', 'AJB', 'AJC', 'AJD', 'AJE', 'AJF', 'AJG', 'AJH', 'AJI',
    'AJJ', 'AJK', 'AJL', 'AJM', 'AJN', 'AJO', 'AJP', 'AJQ', 'AJR', 'AJS', 'AJT',
    'AJU', 'AJV', 'AJW', 'AJX', 'AJY', 'AJZ', 'AKA', 'AKB', 'AKC', 'AKD', 'AKE',
    'AKF', 'AKG', 'AKH', 'AKI', 'AKJ', 'AKK', 'AKL', 'AKM', 'AKN', 'AKO', 'AKP',
    'AKQ', 'AKR', 'AKS', 'AKT', 'AKU', 'AKV', 'AKW', 'AKX', 'AKY', 'AKZ', 'ALA',
    'ALB', 'ALC', 'ALD', 'ALE', 'ALF', 'ALG', 'ALH', 'ALI', 'ALJ', 'ALK', 'ALL',
    'ALM', 'ALN', 'ALO', 'ALP', 'ALQ', 'ALR', 'ALS', 'ALT', 'ALU', 'ALV', 'ALW',
    'ALX', 'ALY', 'ALZ', 'AMA', 'AMB', 'AMC', 'AMD', 'AME', 'AMF', 'AMG', 'AMH',
    'AMI', 'AMJ', 'AMK', 'AML', 'AMM', 'AMN', 'AMO', 'AMP', 'AMQ', 'AMR', 'AMS',
    'AMT', 'AMU', 'AMV', 'AMW', 'AMX', 'AMY', 'AMZ', 'ANA', 'ANB', 'ANC', 'AND',
    'ANE', 'ANF', 'ANG', 'ANH', 'ANI', 'ANJ', 'ANK', 'ANL', 'ANM', 'ANN', 'ANO',
    'ANP', 'ANQ', 'ANR', 'ANS', 'ANT', 'ANU', 'ANV', 'ANW', 'ANX', 'ANY', 'AOA',
    'AOD', 'AOE', 'AOF', 'AOG', 'AOH', 'AOI', 'AOJ', 'AOK', 'AOL', 'AOM', 'AON',
    'AOO', 'AOP', 'AOQ', 'AOR', 'AOS', 'AOT', 'AOU', 'AOV', 'AOW', 'AOX', 'AOY',
    'AOZ', 'AP', 'APA', 'APB', 'APC', 'APD', 'APE', 'APF', 'APG', 'APH', 'API',
    'APJ', 'APK', 'APL', 'APM', 'APN', 'APO', 'APP', 'APQ', 'APR', 'APS', 'APT',
    'APU', 'APV', 'APW', 'APX', 'APY', 'APZ', 'AQA', 'AQB', 'AQC', 'AQD', 'AQE',
    'AQF', 'AQG', 'AQH', 'AQI', 'AQJ', 'AQK', 'AQL', 'AQM', 'AQN', 'AQO', 'AQP',
    'AQQ', 'AQR', 'AQS', 'AQT', 'AQU', 'AQV', 'AQW', 'AQX', 'AQY', 'AQZ', 'ARA',
    'ARB', 'ARC', 'ARD', 'ARE', 'ARF', 'ARG', 'ARH', 'ARI', 'ARJ', 'ARK', 'ARL',
    'ARM', 'ARN', 'ARO', 'ARP', 'ARQ', 'ARR', 'ARS', 'ART', 'ARU', 'ARV', 'ARW',
    'ARX', 'ARY', 'ARZ', 'ASA', 'ASB', 'ASC', 'ASD', 'ASE', 'ASF', 'ASG', 'ASH',
    'ASI', 'ASJ', 'ASK', 'ASL', 'ASM', 'ASN', 'ASO', 'ASP', 'ASQ', 'ASR', 'ASS',
    'AST', 'ASU', 'ASV', 'ASW', 'ASX', 'ASY', 'ASZ', 'ATA', 'ATB', 'ATC', 'ATD',
    'ATE', 'ATF', 'ATG', 'ATH', 'ATI', 'ATJ', 'ATK', 'ATL', 'ATM', 'ATN', 'ATO',
    'ATP', 'ATQ', 'ATR', 'ATS', 'ATT', 'ATU', 'ATV', 'ATW', 'ATX', 'ATY', 'ATZ',
    'AU', 'AUA', 'AUB', 'AUC', 'AUD', 'AUE', 'AUF', 'AUG', 'AUH', 'AUI', 'AUJ',
    'AUK', 'AUL', 'AUM', 'AUN', 'AUO', 'AUP', 'AUQ', 'AUR', 'AUS', 'AUT', 'AUU',
    'AUV', 'AUW', 'AUX', 'AUY', 'AUZ', 'AV', 'AVA', 'AVB', 'AVC', 'AVD', 'AVE',
    'AVF', 'AVG', 'AVH', 'AVI', 'AVJ', 'AVK', 'AVL', 'AVM', 'AVN', 'AVO', 'AVP',
    'AVQ', 'AVR', 'AVS', 'AVT', 'AVU', 'AVV', 'AVW', 'AVX', 'AVY', 'AVZ', 'AWA',
    'AWB', 'AWC', 'AWD', 'AWE', 'AWF', 'AWG', 'AWH', 'AWI', 'AWJ', 'AWK', 'AWL',
    'AWM', 'AWN', 'AWO', 'AWP', 'AWQ', 'AWR', 'AWS', 'AWT', 'AWU', 'AWV', 'AWW',
    'AWX', 'AWY', 'AWZ', 'AXA', 'AXB', 'AXC', 'AXD', 'AXE', 'AXF', 'AXG', 'AXH',
    'AXI', 'AXJ', 'AXK', 'AXL', 'AXM', 'AXN', 'AXO', 'AXP', 'AXQ', 'AXR', 'AXS',
    'BA', 'BC', 'BD', 'BE', 'BH', 'BM', 'BN', 'BO', 'BR', 'BT', 'BTP', 'BW',
    'CAS', 'CAT', 'CAU', 'CAV', 'CAW', 'CAX', 'CAY', 'CAZ', 'CBA', 'CBB', 'CD',
    'CEC', 'CED', 'CFE', 'CFF', 'CFO', 'CG', 'CH', 'CK', 'CKN', 'CM', 'CMR',
    'CN', 'CNO', 'COF', 'CP', 'CR', 'CRN', 'CS', 'CST', 'CT', 'CU', 'CV', 'CW',
    'CZ', 'DA', 'DAN', 'DB', 'DI', 'DL', 'DM', 'DQ', 'DR', 'EA', 'EB', 'ED',
    'EE', 'EEP', 'EI', 'EN', 'EQ', 'ER', 'ERN', 'ET', 'EX', 'FC', 'FF', 'FI',
    'FLW', 'FN', 'FO', 'FS', 'FT', 'FV', 'FX', 'GA', 'GC', 'GD', 'GDN', 'GN',
    'HS', 'HWB', 'IA', 'IB', 'ICA', 'ICE', 'ICO', 'II', 'IL', 'INB', 'INN',
    'INO', 'IP', 'IS', 'IT', 'IV', 'JB', 'JE', 'LA', 'LAN', 'LAR', 'LB', 'LC',
    'LI', 'LO', 'LRC', 'LS', 'MA', 'MB', 'MF', 'MG', 'MH', 'MR', 'MRN', 'MS',
    'MSS', 'MWB', 'NA', 'NF', 'OH', 'OI', 'ON', 'OP', 'OR', 'PB', 'PC', 'PD',
    'PE', 'PF', 'PI', 'PK', 'PL', 'POR', 'PP', 'PQ', 'PR', 'PS', 'PW', 'PY',
    'RA', 'RC', 'RCN', 'RE', 'REN', 'RF', 'RR', 'RT', 'SA', 'SB', 'SD', 'SE',
    'SEA', 'SF', 'SH', 'SI', 'SM', 'SN', 'SP', 'SQ', 'SRN', 'SS', 'STA', 'SW',
    'SZ', 'TB', 'TCR', 'TE', 'TF', 'TI', 'TIN', 'TL', 'TN', 'TP', 'UAR', 'UC',
    'UCN', 'UN', 'UO', 'URI', 'VA', 'VC', 'VGR', 'VM', 'VN', 'VON', 'VOR', 'VP',
    'VR', 'VS', 'VT', 'VV', 'WE', 'WM', 'WN', 'WR', 'WS', 'WY', 'XA', 'XC',
    'XP', 'ZZZ');

  wpxTaxCategoryCodeContentType: array [TTaxCategory]
    of string = ('AE', 'E', 'G', 'K', 'L', 'M', 'O', 'S', 'Z');

  wpxTaxTypeCodeContentType: array [TTaxTypeCodeContentType] of string = ('AAA',
    'AAB', 'AAC', 'AAD', 'AAE', 'AAF', 'AAG', 'AAH', 'AAI', 'AAJ', 'AAK', 'AAL',
    'AAM', 'ADD', 'BOL', 'CAP', 'CAR', 'COC', 'CST', 'CUD', 'CVD', 'ENV', 'EXC',
    'EXP', 'FET', 'FRE', 'GCN', 'GST', 'ILL', 'IMP', 'IND', 'LAC', 'LCN', 'LDP',
    'LOC', 'LST', 'MCA', 'MCD', 'OTH', 'PDB', 'PDC', 'PRF', 'SCN', 'SSS', 'STT',
    'SUP', 'SUR', 'SWT', 'TAC', 'TOT', 'TOX', 'TTA', 'VAD', 'VAT');

  wpxTimeReferenceCodeContentType: array [TTimeReferenceCodeContentType]
    of string = ('5', '29', '72');

  wpxAccountingAccountTypeCodeContentType
    : array [TAccountingAccountTypeCodeContentType] of string = ('1', '2', '3',
    '4', '5', '6', '7');

  wpxDeliveryTermsCodeContentType: array [TDeliveryTermsCodeContentType]
    of string = ('1', '2', 'CFR', 'CIF', 'CIP', 'CPT', 'DAP', 'DAT', 'DDP',
    'EXW', 'FAS', 'FCA', 'FOB');





  // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // The class TWPXSequence allows storage of strings identified by enums
  // This provides:
  // 1) Storage of any information from an XML
  // 2) Know, if a value is defined or not (not just "" value)
  // 3) Typesavety at compile time since only certain properties can be assigned
  // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TWPXSequence<TSelector>.Assign(Source: TWPXSequence<TSelector>);
var
  i: Integer;
  O: TSeqData;
begin
  Clear;
  for i := 0 to Source.FList.Count - 1 do
  begin
    O := TSeqData.Create;
    O.Assign(Source.FList[i]);
  end;
end;

function TWPXSequence<TSelector>.Child(nr: Integer): TSeqData;
begin
  Result := FList[nr];
end;

constructor TWPXSequence<TSelector>.Create;
var
  i: TSelector;
  typeInf: PTypeInfo;
  typeData: PTypeData;
  s: string;
  j: Integer;
begin
  inherited Create;
  typeInf := PTypeInfo(TypeInfo(TSelector));
  if typeInf^.Kind <> tkEnumeration then
    raise EInvalidCast.Create('TWPXSequence only works for Enums');
  typeData := GetTypeData(typeInf);
  FOrdType := typeData.OrdType;
  FEnumCountVal := typeData.MaxValue - typeData.MinValue + 1;
  for j := typeData.MinValue to typeData.MaxValue do
  begin
    s := GetEnumName(TypeInfo(TSelector), j);
    if (s <> '') and (s[1] = 'e') then
      System.Delete(s, 1, 1);
    FAllowedNames.Add(s);
  end;
end;

destructor TWPXSequence<TSelector>.Destroy;
begin

  inherited;
end;


function TWPXSequence<TSelector>.ToInt(const i: TSelector): Integer;
// var LValue: TValue; // System.Rtti;
begin
  case FOrdType of
    otSByte, otUByte:
      Result := PByte(@i)^;
    otSWord, otUWord:
      Result := PWord(@i)^;
    otSLong, otULong:
      Result := PInteger(@i)^;
  else
    Result := -1;
  end;
  // Result := PByte(@i)^;
  // LValue := TValue.From<TSelector>(i); // PInteger(@Value)^); ??
  // Result := LValue.AsInteger;
end;

function TWPXSequence<TSelector>.ValueName(const i: TSelector): string;
var
  O: Integer;
begin
  O := ToInt(i);
  if (O >= 0) and (O < FAllowedNames.Count) then
    Result := FAllowedNames[O]
  else
    Result := '';
  Result := GetEnumName(TypeInfo(TSelector), ToInt(i));
end;

function TWPXSequence<TSelector>.ValuesGet(Index: Integer): string;
var
  i, O: Integer;
begin
  Result := '';
  if (Index >= 0) and (Index <= FList.Count) then
  begin
    O := Integer(FList[Index].fIndex);
    if O < FAllowedNames.Count then
      Result := FAllowedNames[O] + '=' + FList[Index].GetAsString;
  end;
end;

procedure TWPXSequence<TSelector>.ValuesPut(Index: Integer; const s: string);
var
  i, E, j, EnumValue: Integer;
begin
  i := Pos('=', s);
  if i > 0 then
    SetValue(Copy(s, 1, i - 1), Copy(s, i + 1, Length(s)));
end;

function TWPXSequence<TSelector>.SetValue(const AName, AValue: String)
  : TWPXSequence<TSelector>;
var
  E, j, opt: Integer;
  O: TSeqData;
  oc: TWPXElementClass;
begin
  E := FAllowedNames.IndexOf(AName);
  if E < 0 then
    raise Exception.Create('Property "' + AName + '" is not supported in ' +
      ClassName);
  for j := 0 to FList.Count - 1 do
    if FList[j].fIndex = E then
    begin
      O := FList[j];
      O.AsString := AValue;
      exit;
    end;
  O := TSeqData.Create;
  O.fIndex := E;
  oc := GetSequenceFor(E, opt);
  if Assigned(oc) then
  begin
    o.fData := oc.Create;
    if fAnchestor=nil then o.fData.fAnchestor := self else o.fData.fAnchestor := fAnchestor;
    o.fData.fParent := self;
    o.fData.InternInitData;
    o.fData.fAssignedXMLTagName := FAllowedNames[E];
    if assigned(fAnchestor) and assigned(fAnchestor.fOnCreateElement) then
    begin fAnchestor.fOnCreateElement(AName); end;
  end;
  FList.Add(O);
  O.AsString := AValue;
  Result := Self;
end;


function TWPXSequence<TSelector>.ReadElementValue( iEnums : array of Integer;
      var SubProperty : TWPXElement ) : Boolean;
var j, i : Integer;
    ele, nextele : TWPXElement;
begin
  SubProperty := nil;
  Result := false;
  ele := Self;
  i := 0;
  while (i<Length(iEnums)) and (ele<>nil) and (ele.FList<>nil) do
  begin
      nextele := nil;
      for j := 0 to ele.FList.Count-1 do
      begin
         if ele.FList[j].fIndex=iEnums[i] then
         begin
           nextele := ele.FList[j].Data;
           if i=Length(iEnums)-1 then
           begin
             SubProperty := nextele;
             Result := true;
             exit;
           end;
           inc(i);
           break;
         end;
      end;
      ele := nextele;
  end;
end;

function TWPXSequence<TSelector>.ReadElementValue(
      iEnums : array of Integer; var SubPropertyValue : String ) : Boolean;
var ele : TWPXElement;
begin
  if ReadElementValue(iEnums,ele) then
  begin
     Result := true;
     SubPropertyValue := ele.ValueStr;
  end
  else
  begin
     Result := False;
     SubPropertyValue := '';
  end;
end;


// this function is called by the get_ methods
function TWPXSequence<TSelector>.GetElementFor(iEnum: Integer): TWPXElement;
var
  j, opt: Integer;
  O: TSeqData;
  oc: TWPXElementClass;
begin
  for j := 0 to FList.Count - 1 do
    if FList[j].fIndex = iEnum then
    begin
      Result := FList[j].fData;
      exit;
    end;
  oc := GetSequenceFor(iEnum, opt);
  if Assigned(oc) then
  begin
    O := TSeqData.Create;
    O.fIndex := iEnum;
    Result := oc.Create;
    Result.fWasCreatedNew := true;
    O.fData := Result;
    o.fData.InternInitData;
    if fAnchestor=nil then o.fData.fAnchestor := self else o.fData.fAnchestor := fAnchestor;
    o.fData.fParent := self;
    o.fData.fAssignedXMLTagName := FAllowedNames[iEnum];
    if assigned(fAnchestor) and assigned(fAnchestor.fOnCreateElement) then
    begin fAnchestor.fOnCreateElement(FAllowedNames[iEnum]); end;
    FList.Add(O);
    exit;
  end;
  Result := nil;
end;

function TWPXSequence<TSelector>.Has(i: TSelector): Boolean;
var
  j: Integer;
  ii: Integer;
begin
  if Self=nil then
      Result := false else
  begin
      ii := ToInt(i);
      for j := 0 to FList.Count - 1 do
        if FList[j].fIndex = ii then
        begin
          Result := true;
          exit;
        end;
      Result := false;
  end;
end;

function TWPXSequence<TSelector>.GetValue(const i: TSelector): string;
var
  j: Integer;
  ii: Integer;
begin
  ii := ToInt(i);
  for j := 0 to FList.Count - 1 do
    if FList[j].fIndex = ii then
    begin
      Result := FList[j].AsString;
      exit;
    end;
  Result := '';
end;

// Also checks if we have correct class
function TWPXSequence<TSelector>.Prop(const i: TSelector; AsClass: TClass)
  : TSeqData;
begin
  Result := Prop(i);
  if not Assigned(Result.Data) or not(Result.Data is AsClass) then
    raise Exception.Create('Property "' + ValueName(i) +
      '" is not defined or not of "' + AsClass.ClassName + '"');
end;

{
function TWPXSequence<TSelector>.ListItem(index : Integer) : TWPXSequence<TSelector>;
begin
  Result := ListItemBase(index) as TWPXSequence<TSelector>;
end; }

function TWPXSequence<TSelector>.Prop(const i: TSelector): TSeqData;
var
  j, ii, opt: Integer;
  oc: TWPXElementClass;
begin
  if (Self = nil) or (FList = nil) then
    raise Exception.Create('This is a simple data type. You cannot use Prop()');

  ii := ToInt(i);
  for j := 0 to FList.Count - 1 do
    if FList[j].fIndex = ii then
    begin
      Result := FList[j];
      exit;
    end;
  Result := TSeqData.Create;
  Result.fIndex := ii;
  oc := GetSequenceFor(ii, opt);

  if Assigned(oc) then
  begin
    Result.fData := oc.Create;
    Result.fData.fAssignedXMLTagName := FAllowedNames[ii];
    if fAnchestor=nil then Result.fData.fAnchestor := self else Result.fData.fAnchestor := fAnchestor;
    Result.fData.fParent := self;
  end;
  FList.Add(Result);
end;

function TWPXSequence<TSelector>.SetValue(const i: TSelector;
  const value: String): TWPXSequence<TSelector>;
var
  O: TSeqData;
begin
  O := Prop(i);
  O.AsString := value;
  Result := Self;
end;

function TWPXSequence<TSelector>.SetValue(const i: TSelector;
  const value: double): TWPXSequence<TSelector>;
var
  O: TSeqData;
begin
  O := Prop(i);
  O.AsFloat := value;
  Result := Self;
end;

{ TWPXElement }

function TWPXElement.Add(const s: string): Integer;
var
  O: TSeqData;
begin
  // TODO - NEED NAME!
  O := TSeqData.Create;
  O.fDatastr := s;
  Result := FList.Count;
  FList.Add(O);
end;

procedure TWPXElement.Insert(Index: Integer; const s: string);
var
  O: TSeqData;
begin
  O := TSeqData.Create;
  O.fDatastr := s;
  FList.Insert(index, O);
end;

function TWPXElement.AttributeCount: Integer;
begin
  Result := 0;
end;

function TWPXElement.AttributeGet(Index: Integer;
  var AName, AValue: String): Boolean;
begin
  AName := '';
  AValue := '';
  Result := false;
end;

function TWPXElement.AttributeSet(const AName, AValue: String): Boolean;
begin
  Result := false;
end;

function TWPXElement.Child(nr: Integer): TSeqData;
begin
  Result := nil;
end;

procedure TWPXElement.Clear;
var
  i: Integer;
begin
  // remove all sibligs
  if fnextNItem<>nil then FreeAndNil(fnextNItem);
  // and clear this instance
  for i := 0 to FList.Count - 1 do
  begin
    if FList[i].Data<>nil then
        FList[i].Data.fParent := nil;
    FList[i].Free;
  end;
  FList.Clear;
end;

procedure TWPXElement.InternInitData;
begin
 if FList=nil then
 begin
   FList := TList<TSeqData>.Create;
   FAllowedNames := TStringList.Create;
   FAllowedNames.CaseSensitive := false;
   FXMLNameSpace := TWPXElementNS.ram;
 end;
end;

constructor TWPXElement.Create;
begin
  inherited;
  InternInitData;
  fSaveElementsInSchemeOrder := true;
end;

constructor TWPXElement.CreateAs(asXMLTagName: String);
begin
   Create;  // NOT INHERITED, Same LEVEL!
   fAssignedXMLTagName := asXMLTagName ;
end;

procedure TWPXElement.Delete(Index: Integer);
begin
  FList[index].Free;
  FList.Delete(index);
end;

destructor TWPXElement.Destroy;
var i : Integer;
begin
  if fnextNItem<>nil then FreeAndNil(fnextNItem);
  (* ALLOW FREE for Items
  if (fParent<>nil) and (fParent.FList<>nil) then
  begin
     for i := 0 to fParent.FList.Count-1 do
     begin
       if fParent.FList[i].fData=Self then
       begin
          fParent.FList[i].fData := nil;
          fParent.FList[i].Free;
          fParent.FList.Delete(i);
          break
       end;
     end;
  end;
  *)
  Clear;
  FList.Free;
  FSortedList.Free;
  FAllowedNames.Free;
  inherited;
end;

function TWPXElement.ListCount : Integer;
var p : TWPXElement;
begin
   p := Self;
   while p.fprefNItem<>nil do p := p.fprefNItem;
   Result := 1;
   while p.fnextNItem<>nil do
   begin
     inc(Result);
     p := p.fnextNItem;
   end;
end;

function TWPXElement.ListItemBase(index : Integer) : TWPXElement;
var lp, p : TWPXElement;
    i : Integer;
begin
   if index<2 then
     Result := Self else
   begin
       p := Self;  lp := p;
       while p.fprefNItem<>nil do p := p.fprefNItem;
       i := 1;
       while (i<index) and (p<>nil) do
       begin
         lp := p; inc(i); p := p.fnextNItem;
       end;
       if (p=nil) then
       begin
          if i=index then
          begin
             // lp.fnextNItem  should be nil!
             Result := TWPXElementClass(Self.ClassType).Create;
             Result.fAssignedXMLTagName := fAssignedXMLTagName;
             Result.InternInitData;
             Result.fAnchestor := fAnchestor;
             Result.fParent := fParent;
             if FAllowedNames<>nil then
             Result.FAllowedNames.Assign(FAllowedNames);
             lp.fnextNItem := Result;
             Result.fprefNItem := lp;
          end
          else Result := nil;
       end
       else Result := p;
   end;
end;

function TWPXElement.ListIsFirstOrAdd : TWPXElement;
begin
  if Count=0 then  Result := Self
  else Result := ListAdd;
end;

function TWPXElement.ListAdd : TWPXElement;
var p : TWPXElement;
begin
   p := Self;
   while p.fnextNItem<>nil do p := p.fnextNItem;
   Result := TWPXElementClass(Self.ClassType).Create;
   Result.InternInitData;
   // if ClassName=Result.ClassName then
   Result.fAssignedXMLTagName := fAssignedXMLTagName;
   Result.fParent := fParent;
   Result.fAnchestor := fAnchestor;
   if FAllowedNames<>nil then
   Result.FAllowedNames.Assign(FAllowedNames);
   Result.fprefNItem := p;
   p.fnextNItem := Result;
end;

function TWPXElement.ListNext  : TWPXElement;
begin
  Result := fnextNItem;
end;

function TWPXElement.ElementId(const aTagName: String): Integer;
begin
  if (aTagName='') and ((FAllowedNames=nil) or (FAllowedNames.Count=0)) then  Result := -2
  else if FAllowedNames=nil then Result := -1 else
  Result := FAllowedNames.IndexOf(aTagName);
end;


function TWPXElement.ElementsSortedList: TList<TSeqData>;
var d : TSeqData;
    i : Integer;
begin
  if FSortedList=nil then FSortedList := TList<TSeqData>.Create else FSortedList.Clear;
  for I := 0 to FList.Count-1 do
    begin
      d := FList[i];
      FSortedList.Add(d);
    end;
  // Generics.Defaults
  FSortedList.Sort(TComparer<TSeqData>.Construct(
    function(const Left, Right: TSeqData): Integer
    begin
      Result := Left.fIndex - Right.fIndex;
    end));
  Result :=  FSortedList;
end;

// TStrings
function TWPXElement.Get(Index: Integer): string;
begin
  Result := ValuesGet(index);
  // thats the overridden version in subsequent class!
end;

function TWPXElement.GetAnchestor: TWPXElement;
begin
  if fAnchestor=nil then  Result := Self else Result := fAnchestor;
end;

function TWPXElement.GetCount: Integer;
begin
  if FList=nil then  Result := 0 else Result := FList.Count;
end;

procedure TWPXElement.Put(Index: Integer; const s: string);
begin
  ValuesPut(index, s);
end;

function TWPXElement.GetValueStr: String;
begin
  Result := fBaseStringValue;
end;

procedure TWPXElement.IllegalValue(const value: String);
begin
  raise Exception.Create('Illegal Value ' + value);
end;

function TWPXElement.GetSequenceFor(iEnum: Integer; var opt: Integer)
  : TWPXElementClass;
begin
  Result := nil;
end;

function TWPXElement.GetElementFor(iEnum: Integer): TWPXElement;
begin
  Result := nil;
end;

function TWPXElement.XMLTagName: String;
begin
  if fAssignedXMLTagName<>'' then
       Result := fAssignedXMLTagName else
  begin
      Result := ClassName;
      if Result[1] = 'T' then
        System.Delete(Result, 1, 1);
  end;
end;

// Set the value as string. Can be overriden and overloaded.
function TWPXElement.SetValue( const strvalue : String; Defaults : TWPXDocDefaults  = nil ) : Boolean;
begin
   // We can check the ENUM values here !
   SetValueStr(strvalue);
   Result := true;
end;

function TWPXElement.SetValue( const intvalue : Integer; Defaults : TWPXDocDefaults  = nil ) : Boolean;
begin
   // We can check the ENUM values here !
   SetValueStr(IntToStr(intvalue));
   Result := true;
end;

// Sets the Value and also the first attribute, i.e. "format"
// Returns FALSE if an attribute was provided but is not accepted
function TWPXElement.SetValue( const strvalue : String; const attribute : String; const attribute2 : string=''; Defaults : TWPXDocDefaults = nil) : Boolean;
var attrname, currattrval : String;
begin
   Result := SetValue(strvalue);
   // AttributeeClear ? No, we can have defaults!
   if Result and (attribute<>'') then
   begin
     if AttributeCount=0 then
        Result := false
     else
     begin
       // We need to get the name of attribute #1
       AttributeGet(0, attrname, currattrval );
       AttributeSet(attrname, attribute );
       if attribute2<>'' then
       begin
         AttributeGet(1, attrname, currattrval );
         AttributeSet(attrname, attribute2 );
       end;
     end;
   end;
end;

// Do not override this!
// function TWPXElement.SetValue( const strvalue : String; const attribute : String; Defaults : TWPXDocDefaults  = nil ) : Boolean;
// begin
//   Result := SetValue( strvalue,  attribute, '', Defaults );
// end;

function TWPXElement.Get_SetValueParams( Defaults : TWPXDocDefaults ) : String;
var a : Integer;
    attrname, currattrval : String;
    str : TStringList;
begin
   Result :=  StringReplace(  ValueStr , #39, #39+#39, [rfReplaceAll] );

   str := TStringList.create;
   str.Text := Result;
   if str.Count>1 then
   begin
     Result := '';
     for a := 0 to str.Count-1 do
     begin
       Result := Result +  '''' + str[a] +  '''';
       if a<str.Count-1 then
          Result := Result + '+#13+#10+' + #13+#10;
     end;
   end
   else Result :=  '''' + Result +  '''';

   a := AttributeCount;
   if a>0 then
   begin
      AttributeGet(0, attrname, currattrval );
      Result :=  Result + ',{'+attrname+'=}' + '''' + StringReplace(  currattrval , #39, #39+#39, [rfReplaceAll] ) +  '''' ;
   end;
   if a>1 then
   begin
      AttributeGet(1, attrname, currattrval );
      Result :=  Result + ',{'+attrname+'=}' + '''' + StringReplace(  currattrval , #39, #39+#39, [rfReplaceAll] ) +  '''' ;
   end;
end;


procedure TWPXElement.SetValueStr(const s: String);
begin
  fBaseStringValue := s;
end;

function TWPXElement.ValuesGet(Index: Integer): string;
begin
  // Default - do no handle any INDEX!
  Result := fBaseStringValue;
end;

procedure TWPXElement.ValuesPut(Index: Integer; const s: string);
begin
  // Default - do no handle any INDEX!
  fBaseStringValue := s;
end;

{ TSeqData }

function TSeqData.GetAsString: String;
begin
  if fData = nil then
    Result := fDatastr
  else if fData.FEnumCountVal = 1 then
    Result := fData.GetElementFor(0).ValueStr // NOT! ValuesGet(0)
  else
    Result := fData.CommaText;
end;

procedure TSeqData.SetAsString(const s: String);
begin
  if fData = nil then
    fDatastr := s
  else if fData.FEnumCountVal = 1 then
    fData.GetElementFor(0).ValueStr := s // NOT!  ValuesPut(0, s)
  else
    raise Exception.Create('Not a singular type');
end;

function TSeqData.GetSaveData: TWPXElement;
begin
  if Assigned(Self) and Assigned(fData) then
    Result := fData
  else
    raise Exception.Create('Not a complex data item');
end;

function TSeqData.HasData: Boolean;
begin
  Result := Assigned(fData);
end;

// PROPPERT ROUNDING, 2 or 4 digits
procedure TSeqData.SetAsFloat(const d: double);
var
  frm: TFormatSettings;
begin
  frm := TFormatSettings.Create;
  frm.DecimalSeparator := '.';
  fDatastr := FloatToStrF(d, ffFixed, 10, 4, frm);
end;

function TSeqData.GetAsFloat: double;
var
  frm: TFormatSettings;
begin
  frm := TFormatSettings.Create;
  frm.DecimalSeparator := '.';
  if fDatastr = '' then
    Result := 0
  else
    Result := StrToFloat(fDatastr,frm);
end;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

{ TDocumentCodeType }

function TDocumentCodeType.GetEnumValue: TDocumentCode;
var
  i: TDocumentCode;
begin
  for i := TDocumentCode.c380_Commercial_invoice to High(TDocumentCode) do
    if SameStr(fBaseStringValue, wpxDocumentCodeContentType[i]) then
    begin
      Result := i;
      exit;
    end;
  Result := TDocumentCode.cZZZ_as_provided_as_String;
end;

function TDocumentCodeType.Get_SetValueParams(
  Defaults: TWPXDocDefaults): String;
var
  i: TDocumentCode;
begin
  for i := TDocumentCode.c380_Commercial_invoice to High(TDocumentCode) do
    if SameStr(fBaseStringValue, wpxDocumentCodeContentType[i]) then
    begin
      Result := 'TDocumentCode.' + GetEnumName(TypeInfo(TDocumentCode), Integer(i));
      exit;
    end;
  Result := inherited;
end;

procedure TDocumentCodeType.SetEnumValue(x: TDocumentCode);
begin
   fBaseStringValue := wpxDocumentCodeContentType[x];
end;

function TDocumentCodeType.SetValue(value: TDocumentCode;
  Defaults: TWPXDocDefaults): Boolean;
begin
   fBaseStringValue := wpxDocumentCodeContentType[value];
end;


{ TCurrencyCodeType }

function TCurrencyCodeType.GetValueStr: String;
begin
  Result := wpxCurrencyCodeContentType[FEnumValue];
end;

procedure TCurrencyCodeType.SetValueStr(const s: String);
var
  i: TCurrencyCode;
begin
  for i := Low(TCurrencyCode) to High(TCurrencyCode) do
    if SameStr(s, wpxCurrencyCodeContentType[i]) then
    begin
      FEnumValue := i;
      exit;
    end;
  IllegalValue(s);
end;

function TCurrencyCodeType.SetValue( CurrencyCode : TCurrencyCode; Defaults : TWPXDocDefaults  = nil ) : Boolean;
begin
  FEnumValue := CurrencyCode;
  Result := true;
end;

function TCurrencyCodeType.Get_SetValueParams( Defaults : TWPXDocDefaults ) : String;
begin
  Result := 'TCurrencyCode.' + GetEnumName(TypeInfo(TCurrencyCode), Integer(FEnumValue));
end;

{ TReferenceCodeType }

function TReferenceCodeType.GetValueStr: String;
begin
  Result := wpxReferenceCodeContentType[FEnumValue];
end;

procedure TReferenceCodeType.SetValueStr(const s: String);
var
  i: TReferenceCodeContentType;
begin
  for i := Low(TReferenceCodeContentType) to High(TReferenceCodeContentType) do
    if SameStr(s, wpxReferenceCodeContentType[i]) then
    begin
      FEnumValue := i;
      exit;
    end;
  IllegalValue(s);
end;

{ TTaxCategoryCodeType }

function TTaxCategoryCodeType.GetValueStr: String;
begin
  Result := wpxTaxCategoryCodeContentType[FEnumValue];
end;

procedure TTaxCategoryCodeType.SetValueStr(const s: String);
var
  i: TTaxCategory;
begin
  for i := Low(TTaxCategory)
    to High(TTaxCategory) do
    if SameStr(s, wpxTaxCategoryCodeContentType[i]) then
    begin
      FEnumValue := i;
      exit;
    end;
  IllegalValue(s);
end;

function TTaxCategoryCodeType.Get_SetValueParams( Defaults : TWPXDocDefaults ) : String;
begin
  Result := 'TTaxCategory.' + GetEnumName(TypeInfo(TTaxCategory), Integer(FEnumValue));
end;

function TTaxCategoryCodeType.SetValue( value : TTaxCategory;
     Defaults : TWPXDocDefaults  = nil ) : Boolean;
begin
   FEnumValue := value;
   Result := true;
end;


{ TTaxTypeCodeType }

function TTaxTypeCodeType.GetValueStr: String;
begin
  Result := wpxTaxTypeCodeContentType[FEnumValue];
end;

procedure TTaxTypeCodeType.SetValueStr(const s: String);
var
  i: TTaxTypeCodeContentType;
begin
  for i := Low(TTaxTypeCodeContentType) to High(TTaxTypeCodeContentType) do
    if SameStr(s, wpxTaxTypeCodeContentType[i]) then
    begin
      FEnumValue := i;
      exit;
    end;
  IllegalValue(s);
end;

{ TTimeReferenceCodeType }

function TTimeReferenceCodeType.GetValueStr: String;
begin
  Result := wpxTimeReferenceCodeContentType[FEnumValue];
end;

procedure TTimeReferenceCodeType.SetValueStr(const s: String);
var
  i: TTimeReferenceCodeContentType;
begin
  for i := Low(TTimeReferenceCodeContentType)
    to High(TTimeReferenceCodeContentType) do
    if SameStr(s, wpxTimeReferenceCodeContentType[i]) then
    begin
      FEnumValue := i;
      exit;
    end;
  IllegalValue(s);
end;

{ TCountryIDType }

function TCountryIDType.GetValueStr: String;
begin
  Result := wpxCountryIDContentType[FEnumValue];
end;

procedure TCountryIDType.SetValueStr(const s: String);
var
  i: TCountryID;
begin
  for i := Low(TCountryID) to High(TCountryID) do
    if SameStr(s, wpxCountryIDContentType[i]) then
    begin
      FEnumValue := i;
      exit;
    end;
  IllegalValue(s);
end;

function TCountryIDType.SetValue( CountryID : TCountryID; Defaults : TWPXDocDefaults  = nil ) : Boolean;
begin
   FEnumValue := CountryID;
   Result := true;
end;

function TCountryIDType.Get_SetValueParams( Defaults : TWPXDocDefaults ) : String;
begin
  Result := 'TCountryID.' + GetEnumName(TypeInfo(TCountryID), Integer(FEnumValue));
end;

{ TAllowanceChargeReasonCodeType }

function TAllowanceChargeReasonCodeType.GetValueStr: String;
begin
  Result := wpxAllowanceChargeReasonCodeContentType[FEnumValue];
end;

procedure TAllowanceChargeReasonCodeType.SetValueStr(const s: String);
var
  i: TAllowanceChargeReasonCodeContentType;
begin
  for i := Low(TAllowanceChargeReasonCodeContentType)
    to High(TAllowanceChargeReasonCodeContentType) do
    if SameStr(s, wpxAllowanceChargeReasonCodeContentType[i]) then
    begin
      FEnumValue := i;
      exit;
    end;
  IllegalValue(s);
end;

{ TPaymentMeansCodeType }

function TPaymentMeansCodeType.GetValueStr: String;
begin
  Result := wpxPaymentMeansCodeContentType[FEnumValue];
end;

procedure TPaymentMeansCodeType.SetValueStr(const s: String);
var
  i: TPaymentMeansCodeContentType;
begin
  for i := Low(TPaymentMeansCodeContentType)
    to High(TPaymentMeansCodeContentType) do
    if SameStr(s, wpxPaymentMeansCodeContentType[i]) then
    begin
      FEnumValue := i;
      exit;
    end;
  IllegalValue(s);
end;

{ TAccountingAccountTypeCodeType }

function TAccountingAccountTypeCodeType.GetValueStr: String;
begin
  Result := wpxAccountingAccountTypeCodeContentType[FEnumValue];
end;

procedure TAccountingAccountTypeCodeType.SetValueStr(const s: String);
var
  i: TAccountingAccountTypeCodeContentType;
begin
  for i := Low(TAccountingAccountTypeCodeContentType)
    to High(TAccountingAccountTypeCodeContentType) do
    if SameStr(s, wpxAccountingAccountTypeCodeContentType[i]) then
    begin
      FEnumValue := i;
      exit;
    end;
  IllegalValue(s);
end;

{ TDeliveryTermsCodeType }

function TDeliveryTermsCodeType.GetValueStr: String;
begin
  Result := wpxDeliveryTermsCodeContentType[FEnumValue];
end;

procedure TDeliveryTermsCodeType.SetValueStr(const s: String);
var
  i: TDeliveryTermsCodeContentType;
begin
  for i := Low(TDeliveryTermsCodeContentType)
    to High(TDeliveryTermsCodeContentType) do
    if SameStr(s, wpxDeliveryTermsCodeContentType[i]) then
    begin
      FEnumValue := i;
      exit;
    end;
  IllegalValue(s);
end;

{ TAmountType }

function TAmountType.AttributeCount: Integer;
begin
  Result := 1; // -->currencyID
end;

function TAmountType.AttributeGet(Index: Integer;
  var AName, AValue: String): Boolean;
begin
  if index = 0 then
  begin
    AName := 'currencyID';
    AValue := fCurrencyID;
    Result := true;
  end
  else
    Result := false;
end;

function TAmountType.AttributeSet(const AName, AValue: String): Boolean;
begin
  if SameText(AName, 'currencyID') then
  begin
    fCurrencyID := AValue;
    Result := true;
  end
  else
    Result := false;
end;

constructor TAmountType.Create;
begin
  inherited Create;
  FBaseType := TwpxType.Amount;
  fValueDigits := 2;
end;

function TAmountType.Get_SetValueParams(Defaults: TWPXDocDefaults): String;
begin
  Result := fBaseStringValue ;
  if Result='' then Result := '0';
  if currencyID<>'' then
     Result := Result + ', ' + #39 + currencyID + #39;
end;

function TAmountType.SetValue(floatvalue: Double;
  Defaults: TWPXDocDefaults): Boolean;
var
  frm: TFormatSettings;
begin
  frm := TFormatSettings.Create;
  frm.DecimalSeparator := '.';
  fBaseStringValue := FloatToStrF(floatvalue, ffFixed, 10, fValueDigits, frm);
  fCurrencyID := '';
  Result := true;
end;

function TAmountType.SetValue( floatvalue : Double; aCurrencyID : String; Defaults : TWPXDocDefaults  = nil ) : Boolean;
var
  frm: TFormatSettings;
begin
  frm := TFormatSettings.Create;
  frm.DecimalSeparator := '.';
  fBaseStringValue := FloatToStrF(floatvalue, ffFixed, 10, fValueDigits, frm);
  fCurrencyID := aCurrencyID;
  Result := true;
end;

function TAmountType.SetValue( floatvalue : Double; aCurrencyCode : TCurrencyCode; Defaults : TWPXDocDefaults  = nil ) : Boolean;
begin
  Result := SetValue(floatvalue,GetEnumName(TypeInfo(TCurrencyCode), Integer(aCurrencyCode)),Defaults);
end;

procedure TAmountType.set_Value( floatvalue : Double );
var
  frm: TFormatSettings;
begin
  frm := TFormatSettings.Create;
  frm.DecimalSeparator := '.';
  fBaseStringValue := FloatToStrF(floatvalue, ffFixed, 10, fValueDigits, frm);
end;

function TAmountType.get_Value : Double;
var
  frm: TFormatSettings;
begin
  frm := TFormatSettings.Create;
  frm.DecimalSeparator := '.';
  if fBaseStringValue='' then Result := 0 else
     Result := StrToFloat(fBaseStringValue, frm);
end;

{ TWPXElementEnum }

constructor TWPXElementEnum.Create;
begin
  inherited;
  FBaseType := TwpxType.Enum;
end;

{ TBinaryObjectType }

constructor TBinaryObjectType.Create;
begin
  inherited;
  FBaseType := TwpxType.Binary;
  fMemory := TMemoryStream.Create;
end;

destructor TBinaryObjectType.Destroy;
begin
  fMemory.Free;
  inherited;
end;

{ TCodeType }

function TCodeType.AttributeCount: Integer;
begin
  Result := 2; // -->listID,listVersionID
end;

function TCodeType.AttributeGet(Index: Integer;
  var AName, AValue: String): Boolean;
begin
  if index = 0 then
  begin
    AName := 'listID';
    AValue := flistID;
    Result := true;
  end
  else if index = 1 then
  begin
    AName := 'listVersionID';
    AValue := flistVersionID;
    Result := true;
  end
  else
    Result := false;
end;

function TCodeType.AttributeSet(const AName, AValue: String): Boolean;
begin
  if SameText(AName, 'listID') then
  begin
    flistID := AValue;
    Result := true;
  end
  else if SameText(AName, 'listVersionID') then
  begin
    flistVersionID := AValue;
    Result := true;
  end
  else
    Result := false;
end;

constructor TCodeType.Create;
begin
  inherited;
  FBaseType := TwpxType.Code;
end;

{ TIDType }

function TIDType.AttributeCount: Integer;
begin
  Result := 1; // -->schemeID
end;

function TIDType.AttributeGet(Index: Integer;
  var AName, AValue: String): Boolean;
begin
  if index = 0 then
  begin
    AName := 'schemeID';
    AValue := fschemeID;
    Result := true;
  end
  else
    Result := false;
end;

function TIDType.AttributeSet(const AName, AValue: String): Boolean;
begin
  if SameText(AName, 'schemeID') then
  begin
    fschemeID := AValue;
    Result := true;
  end
  else
    Result := false;
end;

constructor TIDType.Create;
begin
  inherited;
  FBaseType := TwpxType.Identifier;
  // NO!! fXMLNameSpace := TWPXElementNS.ram;
end;

{ TTokenType }

constructor TTokenType.Create;
begin
  inherited;
  FBaseType := TwpxType.Token;
end;

{ TNote }
constructor TNote.Create;
begin
  inherited;
  // Create a note, such as   <ram:IncludedNote>
end;

function TNote.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin opt:=0; result:=nil;
case iEnum of
0 : begin Result := TCodeType; opt:=0; end;
1 : begin Result := TTextType; opt:=0; end;
2 : begin Result := TCodeType; opt:=0; end;
end; end;
	function TNote.get_0: TCodeType; begin Result := GetElementFor(0) as TCodeType; end;
	function TNote.get_1: TTextType; begin Result := GetElementFor(1) as TTextType; end;
	function TNote.get_2: TCodeType; begin Result := GetElementFor(2) as TCodeType; end;


function TNote.get_ListItem(index: Integer): TNote;
begin
  Result := ListItemBase(index) as TNote;
end;

{ TNumericType }

constructor TNumericType.Create;
begin
  inherited;
  FBaseType := TwpxType.Nummeric;
  fValueDigits := 4;
end;

function TNumericType.Get_SetValueParams(Defaults: TWPXDocDefaults): String;
begin
   if fBaseStringValue='' then fBaseStringValue := '0';
   Result := inherited Get_SetValueParams(Defaults);
end;

procedure TNumericType.set_Value( floatvalue : Double );
var
  frm: TFormatSettings;
begin
  frm := TFormatSettings.Create;
  frm.DecimalSeparator := '.';
  fBaseStringValue := FloatToStrF(floatvalue, ffFixed, 10, fValueDigits, frm);
end;

function TNumericType.get_Value : Double;
var
  frm: TFormatSettings;
begin
  frm := TFormatSettings.Create;
  frm.DecimalSeparator := '.';
  if fBaseStringValue='' then Result := 0 else
     Result := StrToFloat(fBaseStringValue, frm);
end;

function TNumericType.SetValue(floatvalue: Double;
  Defaults: TWPXDocDefaults): Boolean;
var
  frm: TFormatSettings;
begin
  frm := TFormatSettings.Create;
  frm.DecimalSeparator := '.';
  // fBaseStringValue := FloatToStrF(floatvalue, ffFixed, 10, 4, frm);
   Result := inherited SetValue( FloatToStrF(floatvalue, ffFixed, 10, fValueDigits, frm), '', '', Defaults);
end;

function TNumericType.SetValue( floatvalue : Double; unitCode:String; Defaults : TWPXDocDefaults  = nil ) : Boolean;
var
  frm: TFormatSettings;
begin
  frm := TFormatSettings.Create;
  frm.DecimalSeparator := '.';
  // fBaseStringValue := FloatToStrF(floatvalue, ffFixed, 10, 4, frm);
   Result := inherited SetValue( FloatToStrF(floatvalue, ffFixed, 10, fValueDigits, frm), unitCode, '', Defaults);
end;

{ TIntegerIDType }

constructor TIntegerIDType.Create;
begin
  inherited;
  fValueDigits := 0;
end;

function TIntegerIDType.Get_SetValueParams(Defaults: TWPXDocDefaults): String;
var i : Integer;
begin
   i := Pos( '.', fBaseStringValue);
   if i>0 then SetLength( fBaseStringValue, i-1);
   Result := IntToStr(StrToIntDef(fBaseStringValue,0));
end;

function TIntegerIDType.SetValue(intvalue: Integer;
  Defaults: TWPXDocDefaults): Boolean;
begin
  fBaseStringValue := IntToStr(intvalue);
end;
{ TQuantityType }

constructor TQuantityType.Create;
begin
  inherited;
  FBaseType := TwpxType.Quantity;
  fValueDigits := 4;
end;

{ TTextType }

constructor TTextType.Create;
begin
  inherited;
  FBaseType := TwpxType.Text;
end;

{ TDateTimeStringType }

function TDateTimeStringType.AttributeCount: Integer;
begin
  Result := 1; // -->format
end;

function TDateTimeStringType.AttributeGet(Index: Integer;
  var AName, AValue: String): Boolean;
begin
  if index = 0 then
  begin
    AName := 'format';
    AValue := fformat;
    Result := true;
  end
  else
    Result := false;
end;

function TDateTimeStringType.AttributeSet(const AName,
  AValue: String): Boolean;
begin
  if SameText(AName, 'format') then
  begin
    fformat := AValue;
    Result := true;
  end
  else
    Result := false;
end;

constructor TDateTimeStringType.Create;
begin
  inherited;
  fXMLNameSpace := TWPXElementNS.udt;
end;

function TDateTimeStringType.GetValueStr: String;
var
  frm: TFormatSettings;
begin
  // 12.1.2025 - that is undefined, rather write "" instead of default data
  if SameValue(FDateValue,0) then Result := '' else
  begin
      frm := TFormatSettings.Create;
      frm.DateSeparator :=#0;
      frm.ShortDateFormat := 'YYYYMMDD';
      Result := DateToStr(FDateValue, frm);
  end;
end;

procedure TDateTimeStringType.SetValueStr(const s: String);
var
  wYear, wMonth, wDay: Word;
begin
  if s='' then FDateValue := 0 else
  begin
      wYear := StrToInt(Copy(s, 1, 4));
      wMonth := StrToInt(Copy(s, 5, 2));
      wDay := StrToInt(Copy(s, 7, 2));
      FDateValue := EncodeDate(wYear, wMonth, wDay);
  end;
end;

{ TWPXSequenceStringsURN }

function TWPXSequenceStringsURN.XMLTagName: String;
var aa : String;
begin
  if fAssignedXMLTagName<>'' then
       Result := fAssignedXMLTagName else
  begin
       // Remove trailing "Type"
       aa := Copy(ClassName,2,100);
       if Copy(aa,Length(aa)-3,4)='Type' then
               Result := Copy(aa,1, Length(aa)-4)
       else Result := aa;
  end;
end;

constructor TWPXSequenceStringsURN.Create;
begin
  inherited;
  //NO!FXMLNameSpace := TWPXElementNS.udt;
  FXMLNameSpace := TWPXElementNS.ram;
end;

{ TBooleanType }

constructor TBooleanType.Create;
begin
  inherited;
  fXMLNameSpace := TWPXElementNS.udt; //YES UDT!
end;

function TBooleanType.GetValueStr: String;
begin
  if fValue then
    Result := 'true'
  else
    Result := 'false';
end;

function TBooleanType.Get_SetValueParams(Defaults: TWPXDocDefaults): String;
begin
  if fValue then  Result := 'true' else Result := 'false';
end;

function TBooleanType.SetValue(const boolvalue: Boolean;
  Defaults: TWPXDocDefaults = nil): Boolean;
begin
  fValue := boolvalue;
  Result := true;
end;

procedure TBooleanType.SetValueStr(const s: String);
begin
  fValue := SameText(s, 'true');
end;

{ TMeasureType }

function TMeasureType.AttributeCount: Integer;
begin
  Result := 1; // --> unitCode
end;

function TMeasureType.AttributeGet(Index: Integer;
  var AName, AValue: String): Boolean;
begin
  if index = 0 then
  begin
    AName := 'unitCode';
    AValue := funitCode;
    Result := true;
  end
  else
    Result := false;
end;

function TMeasureType.AttributeSet(const AName, AValue: String): Boolean;
begin
  if SameText(AName, 'unitCode') then
  begin
    funitCode := AValue;
    Result := true;
  end
  else
    Result := false;
end;

{ TWPXDocDefaults }

constructor TWPXDocDefaults.Create;
var i : TWPXElementNS;
begin
  inherited Create;
  Messages := TStringList.Create;
  for I := Low(TWPXElementNS) to High(TWPXElementNS) do
    NS[i] := WPXElementNSDefs[i].nam;
  SetDefaults;
end;

destructor TWPXDocDefaults.Destroy;
begin
   Messages.Free;
end;

procedure TWPXDocDefaults.Log(const msg: String);
begin
  Messages.Add(msg);
end;

function TWPXDocDefaults.SameTagname( const BaseValue, Value: String;
  ExpectedNS: TWPXElementNS; ref : String = ''): Boolean;
var i : Integer;
begin
  Result := false;
  i := Pos(':',Value);
  if i=0 then
  begin
     if ExpectedNS<>TWPXElementNS.none then
     begin
       Log( ref+': Expected NS "' + NS[ExpectedNS] + '" read "".');
     end;
     Result := true;
  end
  else
  begin
     if SameText(Copy(Value,i+1, Length(Value)),BaseValue) then
     begin
       if not SameText(NS[ExpectedNS],Copy(Value,1,i-1)) then
          Log( ref+': Expected NS "' + NS[ExpectedNS] + '" read "' + Copy(Value,1,i-1)  + '".');
        Result := true;
     end;
  end;
end;

procedure TWPXDocDefaults.SetDefaults;
begin
  Messages.Clear;
  SupplyChainTradeTransactionCount := 0;
  if FMode=TWPXOrderType.ZUGFeRD then
  begin
      CrossIndustryInvoice := 'CrossIndustryInvoice';
      IncludedSupplyChainTradeLineItem := 'IncludedSupplyChainTradeLineItem';
      SupplyChainTradeTransaction := 'SupplyChainTradeTransaction';
      NSSelection :=  wpxfXOrderNSSelection[  TWPXOrderType.ZUGFeRD ];
  end
  else
  begin
      CrossIndustryInvoice := 'xxx';
      IncludedSupplyChainTradeLineItem := 'xxx';
      SupplyChainTradeTransaction := 'xxx';
  end;

end;

procedure TWPXDocDefaults.SetMode(v: TWPXOrderType);
begin
  if v<>FMode then
  begin
    FMode := v;
    SetDefaults;
  end;
end;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// manually added classes
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

{ TIndicator }

constructor TIndicator.Create;
begin
  inherited;
  fXMLNameSpace := TWPXElementNS.ram;
end;

function TIndicator.GetSequenceFor(iEnum: Integer;var opt:Integer):TWPXElementClass;
begin
  opt:=0;
  case iEnum of
    0 : begin
         Result := TBooleanType;
         opt:=0;
        end;
    else
       Result := nil;
  end;
end;

function TIndicator.get_0: TBooleanType;
begin
    Result := GetElementFor(0) as TBooleanType;
end;


{ TFormattedDateTime }

constructor TFormattedDateTime.Create;
begin
  inherited;
  fXMLNameSpace := TWPXElementNS.ram;
  DateTimeString.format := '102'; // 102 = CCYYMMDD
end;

function TFormattedDateTime.GetSequenceFor(iEnum: Integer;
  var opt: Integer): TWPXElementClass;
begin
   opt:=0;
  case iEnum of
    0 : begin
         Result := TDateTimeStringType;
         opt:=0;
        end;
    else
       Result := nil;
  end;
end;

function TFormattedDateTime.get_0: TDateTimeStringType;
begin
    Result := GetElementFor(0) as TDateTimeStringType;
end;

{ TPercentType }

constructor TPercentType.Create;
begin
  inherited;
  fValueDigits := 2;
end;

{ TTaxIDType }

function TTaxIDType.AttributeCount: Integer;
begin
  Result := 1; // -->schemeID
end;

function TTaxIDType.AttributeGet(Index: Integer;
  var AName, AValue: String): Boolean;
begin
  if index = 0 then
  begin
    AName := 'schemeID';
    if fschemeID=TTaxID.FC_tax_number then
         AValue := 'FC'   // 5.1.2024
    else AValue := 'VA';
    Result := true;
  end
  else
    Result := false;
end;

function TTaxIDType.AttributeSet(const AName, AValue: String): Boolean;
begin
  if SameText(AName, 'schemeID') then
  begin
    if SameText('FC',AValue) then fschemeID := TTaxID.FC_tax_number
    else if SameText('VA',AValue) then fschemeID := TTaxID.VA_VAT_number
    else raise ENotExpectedAttributeValue( AName+'='+ AValue);
    Result := true;
  end
  else
    Result := false;
end;

function TTaxIDType.SetValue( const taxNumber : String; taxScheme: TTaxID; Defaults : TWPXDocDefaults  = nil ) : Boolean;
begin
  fschemeID :=  taxScheme;
  fBaseStringValue :=  taxNumber;
  Result := true;
end;

function TTaxIDType.Get_SetValueParams( Defaults : TWPXDocDefaults ) : String;
begin
  Result := #39 +  fBaseStringValue + #39 + ',TTaxID.' +
     GetEnumName(TypeInfo(TTaxID), Integer(fschemeID));
end;


constructor TTaxIDType.Create;
begin
  inherited;
  FBaseType := TwpxType.Identifier;
  // NO!! fXMLNameSpace := TWPXElementNS.ram;
end;



{ TAmountListType }

constructor TAmountListType.Create;
begin
  inherited;

end;

function TAmountListType.get_ListItem(index: Integer): TAmountListType;
begin
  Result := ListItemBase(index) as TAmountListType;
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
