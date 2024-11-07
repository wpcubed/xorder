
<h1>WPXOrder was created to make it easier to create X-Factur (ZUGFeRD) XML Data. </h1>
<p>It contains classes that represent elements outlined in the EN16931 specification. Some classes are applicable to many data types, while others are specific to certain data types or particular properties. It is feasible and fairly straightforward to replace a general class with a more specialized one. This provides additional type savety.</p>
<p class="emptypar">&nbsp;</p>
<p>There are multiple possibilites to create X-Factur data. Many involve to create the XML data by using an XML component to add the elements node by node. There are libraries available which makes this easier by implementing functions to create the proper class names. The idea behind WPXOrder was ther should be a way to do this with without having to deal with XMLNodes but use standard Delphi code instead. Only then the delphi compiler will check the corrrect nesting of the objects and very often also the correct type of the assigned data. </p>
<p class="emptypar">&nbsp;</p>
<h1>Special Design Choices</h1>
<h2>All properties are stored as members of a List</h2>
<p>Rather than using predefined coded classes that encompass all potential properties and elements, the primary objects contain a list that references each element.</p>
<p>With this list, it is possible to identify which objects and properties were created, as well as the order in which they were assigned.</p>
<p>This is why importing the XML data into WPXOrder and then saving it again essentially generates the same XML data, which can be easily verified using a text comparison tool. (Tip: In Delphi use Edit/Compare)</p>
<h2>Generic classes (System.Generics.Collections).</h2>
<p>This made is possible to create easy to maintain classes using very small prototypes.</p>
<p>We used a propritary converter to create the codes from the official X-Facur XSD data. This reduced the probability to typing errors and made it possible to create a rather complete representation of the data model as Delphi objects.</p>
<h2>ENUMS</h2>
<p>Using enums it is possible to assign some values for codes with full checking by the delphi compiler</p>
<h2>Generic arrays</h2>
<p>Many of the classes can be used as arrays, too. For example the ApplicableHeaderTradeSettlement.ApplicableTradeTax can occur multiple times in the object ApplicableHeaderTradeSettlement. In such cases you can access all elements using the array operator [x]. </p>
<p>Example: </p>
<p>ApplicableTradeTax[1].RateApplicablePercent.SetValue(&#39;19.00&#39;); </p>
<p>ApplicableTradeTax[2].RateApplicablePercent.SetValue(&#39;7.00&#39;); </p>
<h2>Automatic Object creation</h2>
<p>With the exception of Transaction lines (used for each product in the invoice) you do not have to create any of the objects. They are automatically created for you when you first access the property.</p>
<p class="emptypar">&nbsp;</p>
<h1>What about X-Invoice (E-Rechnung)?</h1>
<p>At present WPXOrder deals with X-Factur (ZUGFeRD) only. We made some design choices to make it possible to later also add X-Invoice, but for now X-Factur is more important for us.</p>
<div class="emptypar">&nbsp;</div>
<h1>Can XOrder validate X-Factur</h1>
<p>No, it cannot.</p>
<p>It generates the document structure based on the properties added by the developer, maintaining the same sequence.</p>
<p>It doesn&#8217;t incorporate items or compute values. It will also not confirm whether the code values are accurate.</p>
<p>We suggest using a validation tool to verify the accuracy and completeness of the generated data. <a href="https://portal3.gefeg.com/invoice/page/validation">https://portal3.gefeg.com/invoice/page/validation</a>)</p>

