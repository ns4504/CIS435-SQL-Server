use AP;

-- subquery, GROSS >:(
select
	*
	,(select 
		AccountDescription 
	from 
		GLAccounts a 
		where 
			a.AccountNo = li.AccountNo) as 'AccountDescription'
from
	InvoiceLineItems li
where
	li.AccountNo in /*= will cause error*/ (select 
					AccountNo
				from 
					GLAccounts 
				where 
					AccountDescription = 'Furniture' 
					or AccountDescription = 'Book Printing Costs')
-- join, PEAK <3

select
	li.*
	,a.AccountDescription
from
	InvoiceLineItems li
	join GLAccounts a on li.AccountNo = a.AccountNo
where
	a.AccountDescription = 'Furniture'
	or AccountDescription = 'Book Printing Costs'