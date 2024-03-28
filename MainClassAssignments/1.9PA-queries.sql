use L_LUNCHES
--QUERY A
select
	*
from
	L_FOODS
where
	PRICE < 2
	and PRICE_INCREASE is null
order by
	[DESCRIPTION]
--QUERY B
select
	*
from
	L_FOODS
where
	SUPPLIER_ID != 'ASP'

--QUERY C
select
	*
from
	L_FOODS
where
	[DESCRIPTION] like '%fresh%'
order by
	[DESCRIPTION] asc

--QUERY D
select
	*
from
	L_EMPLOYEES
where CREDIT_LIMIT > (select
		CREDIT_LIMIT
	from
		L_EMPLOYEES
	where
		FIRST_NAME = 'Jim'
		and LAST_NAME = 'Kern')

--QUERY E
select
	*
from
	L_EMPLOYEES
where
	LAST_NAME like '%n%'