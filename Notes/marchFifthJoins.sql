/*
	select * from Production.ProductModel
	select * from Production.Product
*/
use AdventureWorks2019;
select
	pm.ProductModelID
	,pm.[Name]
	,count(distinct p.ProductID) AllProducts
	,coalesce(sum(pod.StockedQty), 0) TotalQtyStocked
from
	Production.ProductModel pm 
	left join Production.Product p on pm.ProductModelID = p.ProductModelID 
	left join Purchasing.PurchaseOrderDetail pod on p.ProductID = pod.ProductID 
group by
	pm.ProductModelID
	,pm.[Name]
order by
	AllProducts --order by is rendered last, can use aliases here