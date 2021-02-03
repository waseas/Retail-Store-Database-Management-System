CREATE TRIGGER ReturnAndExchangeTrigger
ON ReturnAndExchange
AFTER INSERT,UPDATE
AS
BEGIN
DECLARE @myOrderItemId INT;
DECLARE @Count INT;
DECLARE @QuantityReturned INT;

        IF EXISTS (SELECT * FROM inserted)
		  begin
            SELECT @myOrderItemId = i.OrderItemID FROM inserted i;
			SELECT @Count =COUNT(*) FROM inserted i where i.ReturnedType='return';
			SELECT @QuantityReturned=i.ReturnedQuantity FROM inserted i;
          end
       
   IF @Count>0
   BEGIN 
   SET nocount on;
   UPDATE OrderItems SET Quantity= (Quantity-@QuantityReturned) where OrderItemID=@myOrderItemId;
   --UPDATE OrderItems SET TotalPrice=(Quantity*UnitPrice) where OrderItemID=@myOrderItemId ;
   /*If we update the records in the SQL table, and computed columns calculate updated value once we 
   retrieve data again. However, we cannot update or insert values in the virtual computed columns in SQL Server.*/

   END
   IF @@ERROR !=0
      ROLLBACK TRAN;
END
GO

-------------------------------------------------
CREATE TRIGGER OrderItemsTrigger
ON OrderItems
AFTER INSERT,UPDATE
AS
BEGIN
DECLARE @myProductId INT;
DECLARE @OrderItemID INT;
DECLARE @OrderID INT;
DECLARE @StoreID INT;
DECLARE @Count INT;
DECLARE @Discount INT;
DECLARE @ProductPrice Money;
DECLARE @UnitDiscount Money;

        IF EXISTS (SELECT * FROM inserted)
		  begin
            SELECT @myProductId = i.ProductID FROM inserted i;
			SELECT @OrderItemID=i.OrderItemID FROM inserted i;
			SELECT @Count =COUNT(*) FROM inserted;
			SELECT @ProductPrice =p.UnitPrice FROM Product p where p.ProductID=@myProductId;
			Select @OrderID=i.OrderID FROM inserted i;
			SELECT @StoreID=(select e.storeID FROM Employee e inner join orders o on e.EmployeeID=o.ApprovedBy where o.OrderID=@OrderID);
			SELECT @Discount=(select top 1 isnull(prom.DiscountPercentage,0) from promotion prom inner join PromotionProducts pp on prom.PromotionID=pp.PromotionID inner join
			PromotionStores ps on prom.PromotionID=ps.PromotionID where prom.StartDate<=GETDATE() and prom.ExpiryDate>getdate() and 
			pp.ProductID=@myProductId and ps.StoreID=@StoreID);
			Select @UnitDiscount=(@Discount * @ProductPrice)/100;

          end
       
   IF @Count>0
   BEGIN 
   SET nocount on;
   UPDATE OrderItems SET UnitPrice=@ProductPrice where OrderItemID=@OrderItemID ;
   --UPDATE OrderItems SET TotalPrice=(Quantity*UnitPrice) where OrderItemID=@myOrderItemId ;
   /*If we update the records in the SQL table, and computed columns calculate updated value once we 
   retrieve data again. However, we cannot update or insert values in the virtual computed columns in SQL Server.*/
   UPDATE OrderItems SET UnitDiscount=isnull(@UnitDiscount,0) where OrderItemID=@OrderItemID ;

   END
   IF @@ERROR !=0
      ROLLBACK TRAN;
END
GO


drop trigger OrderItemsTrigger

