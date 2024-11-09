object InvoiceForm: TInvoiceForm
  Left = 0
  Top = 0
  Caption = 'ZUGFeRD Rechnung'
  ClientHeight = 355
  ClientWidth = 666
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pagInvoiceDatra: TPageControl
    Left = 0
    Top = 0
    Width = 666
    Height = 355
    ActivePage = tabAddr
    Align = alClient
    TabOrder = 0
    object tabAddr: TTabSheet
      Caption = 'Adressen'
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 26
        Height = 13
        Caption = 'Seller'
      end
      object Buyer: TLabel
        Left = 328
        Top = 16
        Width = 28
        Height = 13
        Caption = 'Buyer'
      end
      object valSeller: TValueListEditor
        Left = 9
        Top = 35
        Width = 313
        Height = 273
        Strings.Strings = (
          'Name='
          'PostcodeCode='
          'Addres='
          'CityName='
          'CountryID='
          'DepartmentName='
          'TAXId='
          'VATID='
          'ContactInfo='
          'ID='
          'GlobalID='
          'GlobalIDScheme='
          'SpecifiedLegalOrganization=')
        TabOrder = 0
        TitleCaptions.Strings = (
          'Fieldname'
          'Value')
        ColWidths = (
          150
          157)
        RowHeights = (
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18)
      end
      object valBuyer: TValueListEditor
        Left = 328
        Top = 35
        Width = 313
        Height = 273
        Strings.Strings = (
          'Name='
          'PostcodeCode='
          'Addres='
          'CityName='
          'CountryID='
          'DepartmentName='
          'TAXId='
          'VATID='
          'ContactInfo='
          'ID='
          'GlobalID='
          'GlobalIDScheme='
          'SpecifiedLegalOrganization=')
        TabOrder = 1
        TitleCaptions.Strings = (
          'Fieldname'
          'Value')
        ColWidths = (
          150
          157)
        RowHeights = (
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18
          18)
      end
    end
    object tabOrder: TTabSheet
      Caption = 'Bestellung'
      ImageIndex = 1
      DesignSize = (
        658
        327)
      object Label2: TLabel
        Left = 3
        Top = 7
        Width = 48
        Height = 13
        Caption = 'TAX Mode'
      end
      object Label3: TLabel
        Left = 251
        Top = 7
        Width = 27
        Height = 13
        Caption = 'Name'
      end
      object Label4: TLabel
        Left = 423
        Top = 7
        Width = 61
        Height = 13
        Caption = 'Rechnuns ID'
      end
      object taxCombo: TComboBox
        Left = 76
        Top = 3
        Width = 169
        Height = 21
        Style = csDropDownList
        ItemIndex = 7
        TabOrder = 0
        Text = 'S_Standard_rate'
        Items.Strings = (
          'AE_VAT_Reverse_Charge'
          'E_Exempt_from_tax'
          'G_Free_export_item_tax_not_charged'
          'K_VAT_exempt_for_EEA'
          'L_Canary_Islands_general_indirect_tax'
          'M_Tax_for_psi_Ceuta_and_Melilla'
          'O_Services_outside_scope_of_tax'
          'S_Standard_rate'
          'Z_Zero_rated_goods')
      end
      object ItemGrid: TStringGrid
        Left = 3
        Top = 30
        Width = 639
        Height = 284
        Anchors = [akLeft, akTop, akRight, akBottom]
        FixedCols = 0
        TabOrder = 1
        ColWidths = (
          70
          64
          64
          64
          64)
        RowHeights = (
          24
          24
          24
          24
          24)
      end
      object edREName: TEdit
        Left = 284
        Top = 3
        Width = 121
        Height = 21
        TabOrder = 2
        Text = 'Musterrechnung'
      end
      object edREID: TEdit
        Left = 490
        Top = 3
        Width = 121
        Height = 21
        TabOrder = 3
        Text = 'RE00001'
      end
    end
    object tabXML: TTabSheet
      Caption = 'Ausgabe'
      ImageIndex = 2
      object outText: TMemo
        Left = 0
        Top = 35
        Width = 658
        Height = 292
        Align = alClient
        Lines.Strings = (
          'outText')
        TabOrder = 0
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 658
        Height = 35
        Align = alTop
        TabOrder = 1
        object btnCalculate: TButton
          AlignWithMargins = True
          Left = 171
          Top = 4
          Width = 161
          Height = 27
          Align = alLeft
          Caption = 'Kontrollrechnung'
          TabOrder = 0
          OnClick = btnCalculateClick
        end
        object btnGenerateInvoice: TButton
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 161
          Height = 27
          Align = alLeft
          Caption = 'Erstelle XML'
          TabOrder = 1
          OnClick = btnGenerateInvoiceClick
        end
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 132
    Top = 40
    object File1: TMenuItem
      Caption = 'File'
      object LoadXML1: TMenuItem
        Caption = 'Load XML'
        OnClick = LoadXML1Click
      end
      object SaveXML1: TMenuItem
        Caption = 'Save XML'
        OnClick = SaveXML1Click
      end
      object SaveasDelphiCode1: TMenuItem
        Caption = 'Save as Delphi Code'
        OnClick = SaveasDelphiCode1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'X-Factur XML (*.XML)|*.XML'
    Left = 260
    Top = 56
  end
  object SaveDialog1: TSaveDialog
    Filter = 'X-Factur XML (*.XML)|*.XML|Textfiles|*.TXT'
    Left = 260
    Top = 120
  end
end
