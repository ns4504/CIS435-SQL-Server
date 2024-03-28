--SELF JOIN PRACTICE

select
	emp.EMPLOYEE_ID
	,emp.FIRST_NAME + ' '
		+ emp.LAST_NAME EMPLOYEE_NAME
	,emp.PHONE_NUMBER 
	,emp.MANAGER_ID
	,mgr.FIRST_NAME + ' '
		+mgr.LAST_NAME MANAGER_NAME
	,mgr.PHONE_NUMBER
from
	L_EMPLOYEES emp
	left join L_EMPLOYEES mgr on emp.MANAGER_ID = mgr.EMPLOYEE_ID