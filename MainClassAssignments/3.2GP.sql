--Name: Nathan Scott
--Question 1
select
	cast(i.InvoiceTotal as decimal(17, 2)) CastAsDecimal
	,cast(i.InvoiceTotal as varchar) CastAsVarchar
	,convert(decimal(17, 2), i.InvoiceTotal) ConvertToDecimal
	,convert(varchar, i.InvoiceTotal, 1) ConvertToVarchar
from
	Invoices i
--Name: Nathan Scott
--Question 2
select
	cast(i.InvoiceDate as varchar) CastAsVarchar
	,convert(varchar, i.InvoiceDate, 1) ConvertToStyle1
	,convert(varchar, i.InvoiceDate, 10) ConvertToStyle10
	,cast(i.InvoiceDate as real) CastToReal
from
	Invoices i