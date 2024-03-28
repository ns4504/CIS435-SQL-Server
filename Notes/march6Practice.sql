select
	p.FirstName
	,p.LastName
	,c.AccountNumber
	,format(soh.OrderDate, 'MM.dd.yyyy') OrderDate
	,replace(shipAddr.AddressLine1
		+ ', ' + isnull(shipAddr.AddressLine2, '')
		+ ', ' + shipAddr.City
		+ ', ' + shipSP.[Name]
		+ '  ' + shipAddr.PostalCode, ', ,', ',') ShippingAddress
	,replace(billAddr.AddressLine1
		+ ', ' + isnull(billAddr.AddressLine2, '')
		+ ', ' + billAddr.City
		+ ', ' + billSP.[Name]
		+ '  ' + billAddr.PostalCode, ', ,', ',') BillingAddress
from
	Person.Person p
	join Sales.Customer c on p.BusinessEntityID = c.PersonID
	left join Sales.SalesOrderHeader soh on c.CustomerID = soh.CustomerID
	left join Person.[Address] shipAddr on soh.ShipToAddressID = shipAddr.AddressID
	left join Person.[Address] billAddr on soh.BillToAddressID = billAddr.AddressID
	left join Person.StateProvince shipSP on shipAddr.StateProvinceID = shipSP.StateProvinceID
	left join Person.StateProvince billSP on billAddr.StateProvinceID = billSP.StateProvinceID
order by
	p.LastName ,p.FirstName ,soh.OrderDate desc