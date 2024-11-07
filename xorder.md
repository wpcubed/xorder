
<h1>WPXOrder is a collection of Delphi units to create X-Factur (ZUGFeRD) XML data. </h1>
<p>It was created to load, process and save such data. It does <b>not include E-Invoice standard</b> yet and is focussed to create the XML data to be embedded inside PDF invoices. To create such Invoices you can use wPDF. To read such Invoices you can use WPViewPDF PLUS which can not only extract X-Factur Data but also attach it.</p>
<p class="emptypar">&nbsp;</p>
<p>We developed WPXOrder to offer a tool that leverages the capabilities of the modern Delphi compiler, simplifying the management of the complex format using a deeply thought out software architecture</a>.</p>
<div class="emptypar">&nbsp;</div>
<h3>Please read here how to use WPXOrder</a>.</h3>
<div class="emptypar">&nbsp;</div>
<div class="emptypar">&nbsp;</div>
<h1>Features</h1>
<h2>Load XML Data</h2>
<p>This generates objects that represent the data structures and content present in the XML data.</p>
<p>You can directly interact with the data structures using the Pascal programming language.</p>
<p>If you don&#8217;t require this feature, it can be turned off, and the links to XML support will also be removed from the project. </p>
<h2>Create Pascal code from object structure</h2>
<p>The component generates Delphi code that can reconstruct the entire object structure step by step.</p>
<p>Certain information is configured using specific types, like the accepted payment methods, or as text strings.</p>
<p>Having the code simplifies the process of generating similar invoices by simply changing the data while retaining the object names. </p>
<h2>Save XML Data from object struture</h2>
<p>After the object structure has been loaded or created, you can store it as new XML data.</p>
<p>The XML will represent the precise arrangement and sequence of tags that are present in the internal object data.</p>
<p>Saving is accomplished using basic string operations, eliminating the need for XML support. This results in a process that is quick, dependable, and platform-independent.</p>
<p class="emptypar">&nbsp;</p>
<p>We evaluated the functionality by importing loading sample invoices and saving the data as new XML files. After utilizing text-diff, only a few minor alterations were identified, primarily variations in insignificant digits in numerical values (such as the &#34;0&#34; following the decimal point). We suggest that you check your data in the same manner. </p>
<div class="emptypar">&nbsp;</div>
<h2>Sample of auto-generated Delphi code</h2>
<p><code>with WPXOrder1.ExchangedDocument do</p>
<p>begin</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ID.ValueStr := &#39;471102&#39;;</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;TypeCode.SetValue(TDocumentCode.c380_Commercial_invoice);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;IssueDateTime.DateTimeString.SetValue(&#39;20200305&#39;,{format=}&#39;102&#39;);</p>
<p> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;....// some lines skipped</p>
<p>end;</p>
<div class="emptypar">&nbsp;</div>
<p>item:=WPXOrder1.Transaction.Items.Add;</p>
<p>with item.Line do</p>
<p>begin</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;AssociatedDocumentLineDocument.LineID.ValueStr := &#39;1&#39;;</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedLineTradeAgreement.NetPriceProductTradePrice.ChargeAmount.SetValue(9.90);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedLineTradeDelivery.BilledQuantity.SetValue(&#39;20.0000&#39;,{unitCode=}&#39;H87&#39;);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedLineTradeSettlement.ApplicableTradeTax.TypeCode.SetValue(&#39;VAT&#39;);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedLineTradeSettlement.ApplicableTradeTax.CategoryCode.SetValue(TTaxCategory.S_Standard_rate);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedLineTradeSettlement.ApplicableTradeTax.RateApplicablePercent.SetValue(&#39;19&#39;);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedLineTradeSettlement.SpecifiedTradeSettlementLineMonetarySummation.LineTotalAmount.SetValue(198.00);</p>
<p>end;</p>
<div class="emptypar">&nbsp;</div>
<p>with WPXOrder1.Transaction.ApplicableHeaderTradeAgreement do</p>
<p>begin</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SellerTradeParty.Name.SetValue(&#39;Lieferant GmbH&#39;);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SellerTradeParty.PostalTradeAddress.PostcodeCode.SetValue(&#39;80333&#39;,{listID=}&#39;&#39;,{listVersionID=}&#39;&#39;);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;....// some lines skipped</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SellerTradeParty.SpecifiedTaxRegistration[1].ID.SetValue(&#39;201/113/40209&#39;,TTaxID.FC_tax_number);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SellerTradeParty.SpecifiedTaxRegistration[2].ID.SetValue(&#39;DE123456789&#39;,TTaxID.VA_VAT_number);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;....// some lines skipped</p>
<p>end;</p>
<div class="emptypar">&nbsp;</div>
<p>with WPXOrder1.Transaction.ApplicableHeaderTradeSettlement do</p>
<p>begin</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;InvoiceCurrencyCode.SetValue(TCurrencyCode.EUR);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ApplicableTradeTax.CalculatedAmount.SetValue(37.62);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ApplicableTradeTax.TypeCode.SetValue(&#39;VAT&#39;);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ApplicableTradeTax.BasisAmount.SetValue(198.00);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ApplicableTradeTax.CategoryCode.SetValue(TTaxCategory.S_Standard_rate);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ApplicableTradeTax.RateApplicablePercent.SetValue(&#39;19.00&#39;);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedTradePaymentTerms.DueDateDateTime.DateTimeString.SetValue(&#39;20200404&#39;,{format=}&#39;102&#39;);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedTradeSettlementHeaderMonetarySummation.LineTotalAmount.SetValue(198.00);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedTradeSettlementHeaderMonetarySummation.ChargeTotalAmount.SetValue(0.00);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedTradeSettlementHeaderMonetarySummation.AllowanceTotalAmount.SetValue(0.00);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedTradeSettlementHeaderMonetarySummation.TaxBasisTotalAmount.SetValue(198.00);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedTradeSettlementHeaderMonetarySummation.TaxTotalAmount.SetValue(37.62, &#39;EUR&#39;);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedTradeSettlementHeaderMonetarySummation.GrandTotalAmount.SetValue(235.62);</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SpecifiedTradeSettlementHeaderMonetarySummation.DuePayableAmount.SetValue(235.62);</p>
<p>end;</code></p>
<div class="emptypar">&nbsp;</div>
<div class="emptypar">&nbsp;</div>
<h1>WPXOrder is distributed under a dual license:</h1>
<h2>1. GNU General Public License, Version 3.0 or later (GPL-3.0-or-later)</h2>
<p>You can find a copy of the license at <a href="http://www.gnu.org/licenses/gpl-3.0.html">http://www.gnu.org/licenses/gpl-3.0.html</a></p>
<p>This allows you to freely use, modify, and distribute the software under the terms of the GPL. (Your software must also be distributed under GNU License!)</p>
<p><b>Not allowed is the use in components of any kind or forks of this component.</b></p>
<p class="emptypar">&nbsp;</p>
<h2>2. Commercial License:</h2>
<p>For those who prefer to use &#34;WPXOrder&#34; without the restrictions imposed by the GPL, a commercial license is available. </p>
<p>Please contact WPCubed GmbH - support@wptools.de for terms and pricing.</p>
<p class="emptypar">&nbsp;</p>
<h1>Usage Disclaimer</h1>
<p>The code was created with the Information provided here</p>
<p><a href="https://xeinkauf.de/dokumente/">https://xeinkauf.de/dokumente/</a></p>
<p>Here you can validate the created XML / Invoice</p>
<p><a href="https://portal3.gefeg.com/invoice/page/validation">https://portal3.gefeg.com/invoice/page/validation</a></p>
<p class="emptypar">&nbsp;</p>
<h2>This software is provided in the hope that it will be useful, but without any warranty of any kind. </h2>
<p>For more details, please refer to the licenses. For inquiries or support, please contact support@wptools.de.</p>
<p class="emptypar">&nbsp;</p>
<p>For information about what information to include in the X-Factur data please refer to the offical information.</p>
<p class="emptypar">&nbsp;</p>
<p>Tip: You can download an spreadsheet with the possible values for the &#34;codes&#34;.</p>

