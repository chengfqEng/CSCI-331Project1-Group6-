USE AdventureWorks2022
SELECT ppi.ProductID ,ppi.Quantity,MIN(ppi.Quantity) as LowQuantity
FROM Production.ProductInventory as ppi
WHERE ppi.Quantity< 0
GROUP BY ppi.ProductID, ppi.Quantity
--This query compares the quantity with the minimum quantity.

USE AdventureWorks2022
SELECT ppo.ProductID--, COUNT(ppo.ProductID) as QuantityDifferenceID
FROM Purchasing.PurchaseOrderDetail as ppo
Where EXISTs (
SELECT sd.ProductID
FROM Sales.SalesOrderDetail as sd
Where ppo.ReceivedQty <> sd.OrderQty)
GROUP BY ppo.ProductID
ORDER BY ppo.ProductID ASC
--This qeury checks if there is a mismatch in quantity

USE AdventureWorks2022
GO
CREATE OR ALTER FUNCTION dbo.FindDifference
(@fDiff AS INT) RETURNS TABLE
AS 
RETURN
SELECT so.ProductID, 
COUNT(so.OrderQty) as co,
SUM(so.OrderQty) as soq, 
AVG(so.OrderQty) as AverageQuantity
FROM Sales.SalesOrderDetail AS so, Production.[Product] as pp
GROUP BY so.ProductID
GO

SELECT *
FROM dbo.FindDifference(950);
--This Query finds the total orders in production. 

USE AdventureWorks2022
;WITH C AS 
(
SELECT he.JobTitle, hs.ShiftID as firstShiftID, hdh.ShiftID
From 
	HumanResources.Employee as he,
	HumanResources.EmployeePayHistory as hph,
	HumanResources.EmployeeDepartmentHistory as hdh,
	HumanResources.[Shift] as hs
WHERE hs.ShiftID <> hdh.ShiftID AND he.BusinessEntityID <> hdh.BusinessEntityID
	
)
SELECT *
FROM C
--This Query uses shiftID to find mismatches of employee ID. 



--This Query shows a short view on Sales, Exchange Rate, and Country Sales
USE AdventureWorks2022

SELECT sc.TerritoryID, COUNT(st.CountryRegionCode) as SalesCountry, st.CountryRegionCode, scr.EndOfDayRate
FROM Sales.Customer as sc, Sales.SalesTerritory as st,
		Sales.CurrencyRate as scr
GROUP BY sc.TerritoryID, st.CountryRegionCode, scr.EndOfDayRate
--Judging by the Country Sales count and the exchange rate
--It would be best to stay unchanged. 