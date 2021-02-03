
CREATE VIEW [Stores With Highest Sales] AS
SELECT TOP 5 s.StoreID, s.StoreName, sum(i.BillingAmount) as [Total Sales] 
FROM Stores s inner join Invoice i on s.StoreID=i.StoreID
Where i.PaymentDate between '2020-11-01' AND '2020-11-30'
Group by s.StoreID, s.StoreName 
Order by [Total Sales] DESC;

DROP VIEW [Stores With Highest Sales];

-------------------------------------------------------------------------------------------------------------------------------


CREATE VIEW [Stores With today's Offer] AS
SELECT s.StoreID, s.StoreName, p.PromotionName as [Offer], p.DiscountPercentage
FROM Stores s inner join PromotionStores ps on s.StoreID=ps.StoreID inner join Promotion p on ps.PromotionID = p.PromotionID
Where CURRENT_TIMESTAMP between p.StartDate AND p.ExpiryDate

DROP VIEW [Stores With today's Offer];
-------------------------------------------------------------------------------------------------------------------------------
CREATE VIEW [Total Orders per Date] AS
SELECT CAST(OrderedDate AS DATE) AS [Order Date], COUNT(DISTINCT OrderedDate) AS [Total Orders Per Date] FROM Orders ord 
GROUP BY CAST(OrderedDate AS DATE);


-------------------------------------------------------------------------------------------------------------------------------

CREATE VIEW [Total Quantity of Each Product Sold] AS
SELECT DISTINCT oi.ProductID AS [Product ID], p.ProductName AS [Name of the Product] , 
SUM(oi.Quantity) AS [Total Quantity of Each Product Sold] FROM OrderItems oi INNER JOIN
Orders o ON oi.OrderID = o.OrderID INNER JOIN Product p ON oi.ProductID = p.ProductID 
GROUP BY oi.ProductID, p.ProductName;

-------------------------------------------------------------------------------------------------------------------------------



CREATE VIEW [Total Orders Placed By a Customer] AS
SELECT RANK() OVER(ORDER BY COUNT(o.OrderID) DESC) AS [CustomerRank],
o.CustomerID, c.FirstName, c.LastName, COUNT(o.OrderID) AS [Total Orders of Customer],
SUM(inv.BillingAmount) AS [Total Billing Amt of each Customer]
FROM Orders o INNER JOIN Customer c ON
o.CustomerID = c.CustomerID INNER JOIN Invoice inv ON o.OrderID = inv.OrderID 
GROUP BY o.CustomerID, c.FirstName, c.LastName;
-------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM [Total Quantity of Each Product Sold];
SELECT * FROM [Total Orders per Date];
SELECT * FROM [Stores With Highest Sales];
SELECT * FROM [Stores With today's Offer];
SELECT * FROM [Total Orders Placed By a Customer];
-------------------------------------------------------------------------------------------------------------------------------
