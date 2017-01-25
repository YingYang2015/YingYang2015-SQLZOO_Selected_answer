## SQLZOO, AdventureWorks
# Sample queries

# 1. Show the CompanyName for James D. Kramer
select CompanyName
from CustomerAW
where FirstName = 'James' and
      MiddleName = 'D.' and
      LastName = 'Kramer'
	  
	  
# 2. Show all the addresses listed for 'Modular Cycle Systems'
select C1.CompanyName, C2.AddressType, A.AddressLine1
from CustomerAW C1 join CustomerAddress C2 on C1.CustomerID = C2.CustomerID
				   join Address A on C2.AddressID = A.AddressID
where C1.CompanyName = 'Modular Cycle Systems'

# 3. Show OrdeQty, the Name and the ListPrice of the order made by CustomerID 635
select OrderQty, Name, ListPrice
from ProductAW P join SalesOrderDetail S1 on P.ProductID = S1.ProductID
				 join SalesOrderHeader S2 on S1.SalesOrderID = S2.SalesOrderID 
where CustomerID = 635

## Questions
# Easy
# 1. Show the first name and the email address of customer with CompanyName 'Bike World'
select FirstName, EmailAddress
from CustomerAW
where CompanyName = 'Bike World'

#2. Show the CompanyName for all customers with an address in City 'Dallas'.
select distinct C1.CompanyName
from CustomerAW C1 join CustomerAddress C2 on C1.CustomerID = C2.CustomerID
				   join Address A on C2.AddressID = A.AddressID
where A.City = 'Dallas'

#3. How many items with ListPrice more than $1000 have been sold?
select count(*)
from SalesOrderDetail S join ProductAW P on S.ProductID = P.ProductID
where P.ListPrice > 1000

#4. Give the CompanyName of those customers with orders over $100000. Include the subtotal plus tax plus freight.
select C.CompanyName, sum(SubTotal + TaxAmt + Freight) as TotalSpending
from CustomerAW C join SalesOrderHeader S on C.CustomerID = S.CustomerID
group by C.CompanyName
having sum(SubTotal + TaxAmt + Freight) > 100000

#5. Find the number of left racing socks ('Racing Socks, L') ordered by CompanyName 'Riding Cycles'
select count(*)
from ProductAW P join SalesOrderDetail S on P.ProductID = S.ProductID
		join SalesOrderHeader SD on SD.SalesOrderID = S.SalesOrderID
		join CustomerAW C on SD.CustomerID and C.CustomerID
where Name = 'Racing Socks, L'

# Medium
#6. A "Single Item Order" is a customer order where only one item is ordered. Show the SalesOrderID and the UnitPrice for every Single Item Order.
select SalesOrderID, UnitPrice
from SalesOrderDetail
where SalesOrderID in (
						select SalesOrderID
						from SalesOrderDetail
						group by SalesOrderID
						having count(*) = 1)
						
#7. Where did the racing socks go? List the product name and the CompanyName for all Customers who ordered ProductModel 'Racing Socks'.
select C.CompanyName, PA.Name
from ProductModel PM join ProductAW PA on PM.ProductModelID = PA.ProductModelID
					 join SalesOrderDetail SO on SO.ProductID = PA.ProductID
					 join SalesOrderHeader SH on SH.SalesOrderID = SO.SalesOrderID
					 join CustomerAW C on C.CustomerID = SH.CustomerID
where PM.Name =  'Racing Socks'

#8. Show the product description for culture 'fr' for product with ProductID 736. 
select Description
from ProductModelProductDescription P1 join ProductDescription P2 on P1.ProductDescriptionID = P2.ProductDescriptionID 
									   join ProductAW P3 on P1.ProductModelID = P3.ProductModelID
where P1.Culture = 'fr' and P3.ProductID = 736

#9. Use the SubTotal value in SaleOrderHeader to list orders from the largest to the smallest. For each order show the CompanyName and the SubTotal and the total weight of the order.
select distinct CompanyName, SubTotal, Weight
from SalesOrderHeader S1 join SalesOrderDetail S2 on S1.SalesOrderID = S2.SalesOrderID 
						 left join ProductAW P on S2.ProductID = P.ProductID
						 join CustomerAW C on S1.CustomerID = C.CustomerID
order by SubTotal DESC

#10. How many products in ProductCategory 'Cranksets' have been sold to an address in 'London'?

select sum(S1.OrderQty)
from ProductCategory P1 join ProductAW P2 on P1.ProductCategoryID = P2.ProductCategoryID
						join SalesOrderDetail S1 on S1.ProductID = P2.ProductID
						join SalesOrderHeader S2 on S2.SalesOrderID = S1.SalesOrderID
						join CustomerAddress C on C.CustomerID= S2.CustomerID
						join Address A on C.AddressID = A.AddressID
where City = 'London' and P1.Name = 'Cranksets'

# Hard
#11.For every customer with a 'Main Office' in Dallas show AddressLine1 of the 'Main Office' and AddressLine1 of the 'Shipping' address - if there is no shipping address leave it blank. Use one row per customer.
select T.CustomerID, T.AddressType, T.AddressLine1, coalesce(C3.AddressType, ''), coalesce(A2.AddressLine1, '')
from 
		(select C1.CustomerID as CustomerID, AddressType, AddressLine1
		from CustomerAddress C1 join CustomerAW C2 on C1.CustomerID = C2.CustomerID 
		join Address A on A.AddressID = C1.AddressID
		where C1.AddressType = 'Main Office' and A.City = 'Dallas') as T 
	left join (select * from CustomerAddress where AddressType != 'Main Office') C3 on T.CustomerID = C3.CustomerID
	left join Address A2 on C3.AddressID= A2.AddressID

# 12. For each order show the SalesOrderID and SubTotal calculated three ways:
# 		A) From the SalesOrderHeader
# 		B) Sum of OrderQty*UnitPrice
# 		C) Sum of OrderQty*ListPrice 
select S1.SalesOrderID, S1.SubTotal, sum(S2.OrderQty*S2.UnitPrice), sum(S2.OrderQty*P.ListPrice)
from SalesOrderHeader S1 left join SalesOrderDetail S2 on S1.SalesOrderID = S2.SalesOrderID 
						 left join ProductAW P on S2.ProductID = P.ProductID
group by S1.SalesOrderID, S1.SubTotal

# 13. Show the best selling item by value. 
select *
from ProductAW P join (select SalesOrderDetailID, ProductID, OrderQty*UnitPrice
from SalesOrderDetail
where OrderQty*UnitPrice = (select max(OrderQty*UnitPrice)
from SalesOrderDetail)) as T on T.ProductID = P.ProductID

#14. Show how many orders are in the following ranges (in $): 
#    RANGE      Num Orders      Total Value
#    0-  99
#  100- 999
# 1000-9999
#10000-
select T.Range, count(*) as NumOrders, sum(SubTotal)
from(
select SalesOrderID, SubTotal, 
		(case when SubTotal between 0 and 99 then '0-99'
            when SubTotal between 100 and 999 then '100- 999'
            when SubTotal between 1000 and 9999 then '1000-9999'
            when SubTotal > 10000 then '10000-' end) as 'Range'
from SalesOrderHeader) as T
group by T.Range

#15. Identify the three most important cities. Show the break down of top level product category against city.