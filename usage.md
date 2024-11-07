
<h1>Purpose and Licensing</h1>
<p>WPXOrder is designed to create XML attachments for invoices distributed as PDFs. It is developed in Delphi 10.1 and works best with our products, wPDF</a> or WPViewPDF PLUS</a>. It can also be used to read such XML data and access all the properties with ease. It can also be used to verify the calculation (total sums) - however, please note that we cannot guarantee that such calculations work correctly in any case. </p>
<p class="emptypar">&nbsp;</p>
<p>Using the provided EXE, you can open the example PDFs and compare the internal calculations with the numbers stored in the PDFs. With ony click you can create Delphi code which will create the data as loaded in the invoice. This will help you greatly to understand the XML format better and to convert your invoice writing software </p>
<p class="emptypar">&nbsp;</p>
<p>Please review the source code on our <a href="https://github.com/wpcubed/xorder">GitHub page</a>. You can use the component without any licensing cost if you incorporate it into an open-source project that is distributed under the GNU license - except for components of any kind or &#34;forks&#34;.</p>
<div class="emptypar">&nbsp;</div>
<p>If you need to use it commercially in-house or in any closed-source product, a commercial license is required. This license is available at a reasonable cost per company (named license). The commercial license also contains support for 60 days after purchase. </p>
<p>Please note that we cannot comment on any legal and most calculation questions involved with X-Factur.</p>
<p class="emptypar">&nbsp;</p>
<h1>How WPXOrder operates</h1>
<h2>Convert XML data to Delphi objects</h2>
<p>When loading XML data or when the invoice is created by code, in memory Delphi objects will be initialized. Each of the objects use a class which matches the property inside the XML document. This means such classes have subproperties with the name of each of the possible sub elements. This provides typesavety and consitency of code vs XML data. You are also protected against typing errors. The component even knows the order in which the objects are supposed to be written to XML - which is important for propper verification of the invoice. The moste inner elements of the object-tree are datatype objects. Those have properties to read and assign theit value, i.e. ValueStr, Value, AsBoolean. We use a lot of overloading to let you code the way you are used to.</p>
<h2>Heavy use of generics</h2>
<p>Each class representing an invoice property was implemented using class inheritance and generics. This approach allowed us to create the basic architecture based on the official ZUGFeRD XML scheme, saving time and reducing typing errors. It is possible to extend the classes with helper functions, if needed. However, please note that a modern Delphi compiler is required; we recommend Delphi 10.1 or later.</p>
<h2>Writing XML as simple top-bottom export</h2>
<p>When saving the loaded data to XML, we use a straightforward method to recursively write all objects from top to bottom. The code is efficient and quick, achieving this without using any XML writing classes. A simple string list is sufficient to write the code. Thanks to this approach, we can use the same procedure to alternatively generate Delphi code to produce the same invoice data, including all the text and number values. We find this extremely practical, and it has been helpful during development to verify that a specific example invoice can be recreated using our component, with only minor differences in the digits of numbers (such as &#34;12.34&#34; vs &#34;12.3400&#34;).</p>
<p class="emptypar">&nbsp;</p>
<h1>Usage</h1>
<h2>General</h2>
<p>We assume you will use the component in a program that is based on a database. For this description we assume in the database there is a table containing customer address data, a table with invoice data, and a table linked to the latter that includes each item included in the invoice. We recommend creating the XML when you calculate the invoice and saving it as text. You can later embed this XML into the PDF. </p>
<h2>Required classes</h2>
<p>You need some working classes which hold important information for the invoice:</p>
<p>WPXSeller : TCompanyData - this holds the address and tax information of the seller.</p>
<p>WPXBuyer &nbsp;: TCompanyData - this holds the address and tax information of the buyer.</p>
<p>WPXShipTo : TCompanyData - this holds the address where the invoice is shipped to..</p>
<p>WPXPaymentData : TPaymentData - here you store some payment terms, due time and the tax category</p>
<p>WPXOrderData : TOrderData - here currently there is just a field for the order data;</p>
<p class="emptypar">&nbsp;</p>
<p>If course you need an instance of the TWPXFactur class which creates the invoice.</p>
<p>WPXFactur : TWPXFactur</p>
<h2>Start Invoice</h2>
<p>First you need to populate the objects which hold the addresses. Please note that you need to provide a country ID (i.e. &#34;DE&#34;) and a ZIP code. The VAT ID is required for any EU invoice. Also do not forget the data and the due date.</p>
<p class="emptypar">&nbsp;</p>
<p>Now you can start the process like this</p>
<div class="code"><code>WPXFactur.StartInvoice(</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;TDocumentCode.c380_Commercial_invoice,</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;InvoiceDATE.AsDateTime,</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;InvoiceORDER_ID.AsString,</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&#39;Rechnung&#39;,</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WPXSeller,</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WPXBuyer, </div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WPXShipTo , // or nil</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;InvoiceNotes.Lines, // some free text - if required</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WPXOrderData,</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;nil, // optional: TDeliveryData</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WPXPaymentData</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;);</code></div>
<h2>Add all Items</h2>
<p>Now loop through all the items (here &#34;Products&#34;) which are connected to the invoice. For each items you can use code like this:</p>
<p> &nbsp;&nbsp;&nbsp;</p>
<div class="code"><code> &nbsp;&nbsp;&nbsp;&nbsp;if WPXPaymentData.TAXCategory&lt;&gt;TTaxCategory.S_Standard_rate then </div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;vat_pc := 0 else</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;vat_pc := ProductsVAT_PC.AsFloat;</div>
<div class="emptypar" class="code">&nbsp;</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;if ProductsNETTO.AsFloat&lt;0 then </div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;begin</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WPXFactur.AddAllowanceCharge(</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;false, &nbsp;// false=allowance, true=charge</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;100,</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-ProductsNETTO.AsFloat*Form1.ProductsCOUNT.AsFloat, &nbsp;// negative!</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ProductsDESCRIPTION.AsString,</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;vat_pc,</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WPXPaymentData.TAXCategory &nbsp;)</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;end</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;else</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;begin</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WPXFactur.AddSale(</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ProductsDESCRIPTION.AsString,</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ProductsNETTO.AsFloat,</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ProductsCOUNT.AsFloat,</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;vat_pc,</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WPXPaymentData.TAXCategory );</div>
<div class="code"> &nbsp;&nbsp;&nbsp;&nbsp;end;</code></div>
<p class="emptypar">&nbsp;</p>
<p>1) Please note that in this examples items with negative values are possible. Such items are usually rebates and have to be added to the invoice as &#34;allowance&#34; - but with a positive value.</p>
<p>2) The above code works well inside of a reporting tool. We used it with our product WPReporter</a> inside the event AfterProcessGroup. </p>
<h2>Finalize Invoice</h2>
<p>At the end you add the summation to the invoice based on the calculation you did yourself while looping all items:</p>
<p><code></p>
<p>with WPXFactur.Transaction.ApplicableHeaderTradeSettlement do</p>
<p>begin</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;InvoiceCurrencyCode.SetValue(TCurrencyCode.EUR);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ApplicableTradeTax.CalculatedAmount.SetValue(...);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ApplicableTradeTax.TypeCode.SetValue(&#39;VAT&#39;);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ApplicableTradeTax.BasisAmount.SetValue(...);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ApplicableTradeTax.CategoryCode.SetValue(WPXPaymentData.TAXCategory);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ApplicableTradeTax.RateApplicablePercent.SetValue(....);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedTradePaymentTerms.DueDateDateTime.DateTimeString.Value := InvoiceData;</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedTradeSettlementHeaderMonetarySummation.LineTotalAmount.SetValue(....);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedTradeSettlementHeaderMonetarySummation.ChargeTotalAmount.SetValue(...);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedTradeSettlementHeaderMonetarySummation.AllowanceTotalAmount.SetValue(....);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedTradeSettlementHeaderMonetarySummation.TaxBasisTotalAmount.SetValue(....);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedTradeSettlementHeaderMonetarySummation.TaxTotalAmount.SetValue(...., &#39;EUR&#39;);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedTradeSettlementHeaderMonetarySummation.GrandTotalAmount.SetValue(....);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedTradeSettlementHeaderMonetarySummation.DuePayableAmount.SetValue(....);</p>
<p>end;</code></p>
<p class="emptypar">&nbsp;</p>
<p>or you can simply call the method <b>FinalizeInvoice</b>.</p>
<p><code>WPXFactur.FinalizeInvoice(true,TCurrencyCode.EUR,0,WPXPaymentData);</code></p>
<p class="emptypar">&nbsp;</p>
<p>You can of course read out the created values after FinalizeInvoice. Please make sure to use <a href="https://portal3.gefeg.com/invoice/account/logon/">official verification</a> to check the result. <b>We do not and we cannot guarantee the correctness of the calculation</b>.</p>
<p class="emptypar">&nbsp;</p>
<p>Another option is to write the elements yourself like in the example above and call <b>VerifySummation</b> to get a comparision of the values using your calculation and our calculation.</p>
<p><code>WPXFactur.VerifySummation;</p>
<p>ShowMessage(WPXFactur .Messages.Text)</code></p>

