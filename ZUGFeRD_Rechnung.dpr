program ZUGFeRD_Rechnung;

uses
  Vcl.Forms,
  ZUGFeRD_Rechnung_U in 'ZUGFeRD_Rechnung_U.pas' {InvoiceForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TInvoiceForm, InvoiceForm);
  Application.Run;
end.
