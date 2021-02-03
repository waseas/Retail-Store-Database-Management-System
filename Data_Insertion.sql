--INSERT/ STORED PROCEDURE:

--1)	Order Table
CREATE PROCEDURE OrderInsertionProcedure
 @CustomerID INT,
 @ApprovedBy INT,
 @OnlineOrderFlag INT
AS
BEGIN
 DECLARE @Status varchar(45) = 'placed';
 DECLARE @OrderedDate DATETIME = getdate();

    BEGIN
        INSERT INTO Orders (CustomerID,ApprovedBy,OnlineOrderFlag,OrderStatus,OrderedDate)
        VALUES (@CustomerID,@ApprovedBy, @OnlineOrderFlag, @Status, @OrderedDate);
    END
END

-- Declare variables
DECLARE @CustomerID INT;
DECLARE @ApprovedBy INT;
DECLARE @OnlineOrderFlag INT;
-- Initialize variables
SET @CustomerID = 5;
SET @ApprovedBy = 24;
SET @OnlineOrderFlag = 1;
-- Execute the procedure
EXEC OrderInsertionProcedure @CustomerID, @ApprovedBy, @OnlineOrderFlag;
-- See the result
SELECT * from Orders;
-------------------------------------------------------------------------------------------------------------------------------
--2)	OrderItems Table
CREATE PROCEDURE OrderItemsInsertionProcedure
 @OrderID INT,
 @ProductID INT,
 @Quantity INT
AS
BEGIN

INSERT INTO OrderItems (OrderID, ProductID,Quantity) VALUES (@OrderID,@ProductID,@Quantity);
END

-- Declare variables
DECLARE @OrderID INT;
DECLARE @ProductID INT;
DECLARE @Quantity INT;
-- Initialize variables
SET @OrderID = 11;
SET @ProductID = 111;
SET @Quantity = 2;
-- Execute the procedure
EXEC OrderItemsInsertionProcedure @OrderID, @ProductID, @Quantity;

-- See the result
SELECT * from OrderItems;
-------------------------------------------------------------------------------------------------------------------------------
--3)	Order Return And Exchange Table
CREATE PROCEDURE OrderReturnAndExchangeInsertionProcedure
 @OrderItemID INT,
 @Quantity INT,
 @Type varchar(45)
AS
BEGIN
DECLARE @ReturnedDate DATETIME = getdate();

INSERT INTO ReturnAndExchange(OrderItemID, ReturnedQuantity,ReturnedType,ReturnedDate) 
VALUES (@OrderItemID,@Quantity,@Type,@ReturnedDate);
END

-- Declare variables
DECLARE @OrderItemID INT;
DECLARE @Quantity INT;
DECLARE @Type varchar(45);
-- Initialize variables
SET @OrderItemID = 48;
SET @Quantity = 1;
SET @Type = 'exchange';
-- Execute the procedure
EXEC OrderReturnAndExchangeInsertionProcedure @OrderItemID, @Quantity, @Type;

-- See the result
SELECT * from ReturnAndExchange;
select * from OrderItems where orderitemid=@OrderItemID
-------------------------------------------------------------------------------------------------------------------------------

--4)	Delivery Table
CREATE PROCEDURE DeliveryInsertionProcedure
 @OrderID INT,
 @DeliveredBy INT
AS
BEGIN
INSERT INTO Delivery(OrderID, DeliveredBy) VALUES (@OrderID,@DeliveredBy);
END

-- Declare variables
DECLARE @OrderID INT;
DECLARE @DeliveredBy INT;
-- Initialize variables
SET @OrderID = 16;
SET @DeliveredBy = 15;
-- Execute the procedure
EXEC DeliveryInsertionProcedure @OrderID, @DeliveredBy;
-- See the result
SELECT * from Delivery;

-------------------------------------------------------------------------------------------------------------------------------
--5)	Invoice Table
CREATE PROCEDURE InvoiceStoredProcedure
@orderId int,
@rewardPointsAdded int,
@paymentType varchar(30),
@currencyType varchar(30),
@billingAddr int,
@cardDetails varchar(30)
AS
BEGIN
 DECLARE @Status varchar(45) = 'placed';
 DECLARE @PaymentDate DATETIME = getdate();
 DECLARE @StoreID INT = (select e.storeid from employee e inner join orders o on o.ApprovedBy=e.EmployeeID where o.OrderID=@orderId);
 DECLARE @totalPrice money=(select sum(o.TotalPrice) from OrderItems o where OrderID=@orderId);
 DECLARE @totalDiscount money=(select sum(o.TotalDiscount) from OrderItems o where OrderID=@orderId);
 DECLARE @BillingAmount money=(@totalPrice-@totalDiscount);

 BEGIN
	INSERT INTO Invoice(OrderID, StoreID, RewardPointsAdded, PaymentType , PaymentDate , BillingAmount , CurrencyType , BillingAddress , 
	CardDetails ,DiscountProvided)
	VALUES(@orderId, @storeId, @rewardPointsAdded, @paymentType, @paymentDate, @BillingAmount, @currencyType, @billingAddr, @cardDetails,
	@totalDiscount)
END
END

-- Declare variables
DECLARE @orderId INT;
DECLARE @rewardPointsAdded INT;
DECLARE @paymentType varchar(30);
DECLARE @currencyType varchar(30);
DECLARE @billingAddr int;
DECLARE @cardDetails varchar(30);
-- Initialize variables
SET @orderId =11;
SET @rewardPointsAdded =6;
SET @paymentType ='card';
SET @currencyType='USD';
SET @billingAddr =71;
SET @cardDetails= '******4828';
-- Execute the procedure
EXEC InvoiceStoredProcedure @orderId, @rewardPointsAdded, @paymentType,@currencyType,@billingAddr,@cardDetails;

-- See the result
SELECT * from Invoice;
-------------------------------------------------------------------------------------------------------------------------------
--6)	Stores Table
insert into dbo.Stores (StoreID,AddressID,PhoneNumber,StoreName,EmailID,OpeningTime,ClosingTime) 
values 
(1001,1,2342023328,'Rainbow Shops','rainbowshops@gmail.com','10:00','22:00'),
(1002,2,6174240033,'Evolve Residential Retail','evolveresidential@gmail.com','09:00','21:00'),
(1003,3,8572334639,'For Now','fornow@gmail.com','09:00','21:00'),
(1004,4,6175168388,'Almany Market','almanymarket@gmail.com','10:00','22:00'),
(1005,5,6174425964,'Shawmut Groceries','shawmutgrocery@gmail.com','08:00:00','20:00:00'),
(1006,6,6174427439,'Tropical Foods','tropicalfoods@gmail.com','07:00:00','23:00:00'),
(1007,7,6175416728,'Liriano Grocery','lirianogrocery@gmail.com','08:00:00','21:00:00'),
(1008,8,6174425964,'Shawmut Groceries','shawmutgrocery@gmail.com','08:00:00','20:00:00'),
(1009,9,6178679094,'The Food Basket','thfoodbasket@gmail.com','07:00:00','23:00:00'),
(1010,10,6172385218,'Senado Market','senadomarket@gmail.com','10:00:00','22:00:00');

-------------------------------------------------------------------------------------------------------------------------------

--7)	Promotion Table

CREATE PROCEDURE PromotionProcedure
    @PromotionName varchar(30),
	@StartDate datetime,
	@ExpirtDate datetime,
	@DiscountPercentage int
AS
BEGIN
	BEGIN TRANSACTION
        DECLARE @PromotionID int;
        SELECT @PromotionID = coalesce((select max(PromotionID) + 1 from Promotion), 5001)
    COMMIT 
	INSERT into Promotion(PromotionID,PromotionName, StartDate, ExpiryDate, DiscountPercentage) values
	(@PromotionID,@PromotionName,@StartDate,@ExpirtDate,@DiscountPercentage);
END;

 

EXEC PromotionProcedure @PromotionName='Thanks Giving', @StartDate = "2020-11-20 00:00:00", @ExpirtDate = "2020-11-30 23:59:00" , @DiscountPercentage = 50;

EXEC PromotionProcedure @PromotionName='Black Friday Sale', @StartDate = "2020-11-27 00:00:00", @ExpirtDate = "2020-11-27 23:59:00" , @DiscountPercentage = 75;

EXEC PromotionProcedure @PromotionName='Christmus Sale', @StartDate = "2020-12-20 00:00:00", @ExpirtDate = "2020-12-30 23:59:00" , @DiscountPercentage = 40;

EXEC PromotionProcedure @PromotionName='Halloween Sale', @StartDate = "2020-10-31 00:00:00", @ExpirtDate = "2020-10-31 23:59:00" , @DiscountPercentage = 25;

EXEC PromotionProcedure @PromotionName='New Year Day Sale', @StartDate = "2021-01-01 00:00:00", @ExpirtDate = "2020-01-01 23:59:00" , @DiscountPercentage = 30;

EXEC PromotionProcedure @PromotionName='Memorial Day Sale', @StartDate = "2020-05-25 00:00:00", @ExpirtDate = "2020-05-25 23:59:00" , @DiscountPercentage = 35;

EXEC PromotionProcedure @PromotionName='Independence Day Sale', @StartDate = "2020-07-03 00:00:00", @ExpirtDate = "2020-07-03 23:59:00" , @DiscountPercentage = 25;

EXEC PromotionProcedure @PromotionName='Labor Day Sale', @StartDate = "2020-09-01 00:00:00", @ExpirtDate = "2020-09-06 23:59:00" , @DiscountPercentage = 15;

EXEC PromotionProcedure @PromotionName='Columbus Day Sale', @StartDate = "2020-10-01 00:00:00", @ExpirtDate = "2020-10-04 23:59:00" , @DiscountPercentage = 15;

EXEC PromotionProcedure @PromotionName='President Day Sale', @StartDate = "2020-02-15 00:00:00", @ExpirtDate = "2020-02-22 23:59:00" , @DiscountPercentage = 20;

EXEC PromotionProcedure @PromotionName='Cyber Monday Sale', @StartDate = "2020-11-30 00:00:00", @ExpirtDate = "2020-11-30 23:59:00" , @DiscountPercentage = 40;

select * from Promotion;
-------------------------------------------------------------------------------------------------------------------------------
--8)	Promotion Stores Table
CREATE PROCEDURE PromotionStoresProcedure
    @StoreID int,
    @PromotionID int  
AS
BEGIN
	INSERT into PromotionStores(StoreID,PromotionID) values (@StoreID,@PromotionID)
END;

DROP PROCEDURE PromotionStoresProcedure;  
GO 

EXEC PromotionStoresProcedure @StoreID = 1001, @PromotionID = 5001;
EXEC PromotionStoresProcedure @StoreID = 1001, @PromotionID = 5006;
EXEC PromotionStoresProcedure @StoreID = 1001, @PromotionID = 5007;

EXEC PromotionStoresProcedure @StoreID = 1002, @PromotionID = 5002;
EXEC PromotionStoresProcedure @StoreID = 1002, @PromotionID = 5003;
EXEC PromotionStoresProcedure @StoreID = 1002, @PromotionID = 5004;

EXEC PromotionStoresProcedure @StoreID = 1003, @PromotionID = 5005;
EXEC PromotionStoresProcedure @StoreID = 1003, @PromotionID = 5006;
EXEC PromotionStoresProcedure @StoreID = 1003, @PromotionID = 5002;

EXEC PromotionStoresProcedure @StoreID = 1004, @PromotionID = 5001;
EXEC PromotionStoresProcedure @StoreID = 1004, @PromotionID = 5004;
EXEC PromotionStoresProcedure @StoreID = 1004, @PromotionID = 5007;
EXEC PromotionStoresProcedure @StoreID = 1004, @PromotionID = 5005;

EXEC PromotionStoresProcedure @StoreID = 1005, @PromotionID = 5002;

EXEC PromotionStoresProcedure @StoreID = 1006, @PromotionID = 5003;
EXEC PromotionStoresProcedure @StoreID = 1006, @PromotionID = 5007;

EXEC PromotionStoresProcedure @StoreID = 1007, @PromotionID = 5002;
EXEC PromotionStoresProcedure @StoreID = 1007, @PromotionID = 5001;
EXEC PromotionStoresProcedure @StoreID = 1007, @PromotionID = 5007;

EXEC PromotionStoresProcedure @StoreID = 1008, @PromotionID = 5001;

EXEC PromotionStoresProcedure @StoreID = 1009, @PromotionID = 5002;
EXEC PromotionStoresProcedure @StoreID = 1009, @PromotionID = 5004;

EXEC PromotionStoresProcedure @StoreID = 1010, @PromotionID = 5006;
EXEC PromotionStoresProcedure @StoreID = 1010, @PromotionID = 5005;
EXEC PromotionStoresProcedure @StoreID = 1010, @PromotionID = 5004;
EXEC PromotionStoresProcedure @StoreID = 1010, @PromotionID = 5001;

-------------------------------------------------------------------------------------------------------------------------------
--9)	Assets Table

CREATE PROCEDURE AssetsProcedure
    @StoreID int,
	@AssetName varchar(30),
	@AssetType varchar(20),
	@AssetStatus varchar(20),
	@LastMaintenanceDate date
AS
BEGIN
	BEGIN TRANSACTION
        DECLARE @AssetID int;
        SELECT @AssetID = coalesce((select max(AssetID) + 1 from Assets), 21001)
    COMMIT 
	INSERT into Assets(AssetID,StoreID,AssetName,AssetType,AssetStatus,LastMaintenanceDate) values
	(@AssetID,@StoreID,@AssetName,@AssetType,@AssetStatus,@LastMaintenanceDate);
END;


DROP PROCEDURE AssetsProcedure;  
GO  

DELETE FROM Assets;

select * from Assets

EXEC AssetsProcedure @StoreID = 1001, @AssetName = 'Air Condition' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-08-15';
EXEC AssetsProcedure @StoreID = 1001, @AssetName = 'Vacuum Cleaner' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-09-20';
EXEC AssetsProcedure @StoreID = 1001, @AssetName = 'Refrigerator' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-08-15';
EXEC AssetsProcedure @StoreID = 1001, @AssetName = 'Digital Display' ,@AssetType= 'Electronic' , @AssetStatus= 'Not Working', @LastMaintenanceDate = '2020-08-15';
EXEC AssetsProcedure @StoreID = 1001, @AssetName = 'Escalator' ,@AssetType= 'ElectroMechanical' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-07-25';
EXEC AssetsProcedure @StoreID = 1001, @AssetName = 'Computers' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-07-25';

EXEC AssetsProcedure @StoreID = 1002, @AssetName = 'Air Condition' ,@AssetType= 'Electronic' , @AssetStatus= 'Not Working', @LastMaintenanceDate = '2020-09-27';
EXEC AssetsProcedure @StoreID = 1002, @AssetName = 'Vacuum Cleaner' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-08-20';
EXEC AssetsProcedure @StoreID = 1002, @AssetName = 'Refrigerator' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-06-21';
EXEC AssetsProcedure @StoreID = 1002, @AssetName = 'Digital Display' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-04-15';
EXEC AssetsProcedure @StoreID = 1002, @AssetName = 'Escalator' ,@AssetType= 'ElectroMechanical' , @AssetStatus= 'Not Working', @LastMaintenanceDate = '2020-07-25';
EXEC AssetsProcedure @StoreID = 1002, @AssetName = 'Computers' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-05-15';

EXEC AssetsProcedure @StoreID = 1003, @AssetName = 'Air Condition' ,@AssetType= 'Electronic' , @AssetStatus= 'Not Working', @LastMaintenanceDate = '2020-02-27';
EXEC AssetsProcedure @StoreID = 1003, @AssetName = 'Vacuum Cleaner' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-04-26';
EXEC AssetsProcedure @StoreID = 1003, @AssetName = 'Refrigerator' ,@AssetType= 'Electronic' , @AssetStatus= 'Not Working', @LastMaintenanceDate = '2020-06-05';
EXEC AssetsProcedure @StoreID = 1003, @AssetName = 'Computers' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-07-23';

EXEC AssetsProcedure @StoreID = 1004, @AssetName = 'Digital Display' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-04-15';
EXEC AssetsProcedure @StoreID = 1004, @AssetName = 'Escalator' ,@AssetType= 'ElectroMechanical' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-07-25';
EXEC AssetsProcedure @StoreID = 1004, @AssetName = 'Computers' ,@AssetType= 'Electronic' , @AssetStatus= 'Not Working', @LastMaintenanceDate = '2020-11-26';
EXEC AssetsProcedure @StoreID = 1004, @AssetName = 'Air Condition' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-09-27';

EXEC AssetsProcedure @StoreID = 1005, @AssetName = 'Digital Display' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-08-15';
EXEC AssetsProcedure @StoreID = 1005, @AssetName = 'Computers' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-08-26';
EXEC AssetsProcedure @StoreID = 1005, @AssetName = 'Air Condition' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-08-27';

EXEC AssetsProcedure @StoreID = 1006, @AssetName = 'Digital Display' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-09-15';
EXEC AssetsProcedure @StoreID = 1006, @AssetName = 'Escalator' ,@AssetType= 'ElectroMechanical' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-09-25';
EXEC AssetsProcedure @StoreID = 1006, @AssetName = 'Computers' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-10-26';

EXEC AssetsProcedure @StoreID = 1007, @AssetName = 'Computers' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-10-26';
EXEC AssetsProcedure @StoreID = 1007, @AssetName = 'Air Condition' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-09-27';

EXEC AssetsProcedure @StoreID = 1008, @AssetName = 'Air Condition' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-06-27';
EXEC AssetsProcedure @StoreID = 1008, @AssetName = 'Vacuum Cleaner' ,@AssetType= 'Electronic' , @AssetStatus= 'Not Working', @LastMaintenanceDate = '2020-05-26';
EXEC AssetsProcedure @StoreID = 1008, @AssetName = 'Refrigerator' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-09-05';
EXEC AssetsProcedure @StoreID = 1008, @AssetName = 'Computers' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-08-23';

EXEC AssetsProcedure @StoreID = 1009, @AssetName = 'Digital Display' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-05-15';
EXEC AssetsProcedure @StoreID = 1009, @AssetName = 'Escalator' ,@AssetType= 'ElectroMechanical' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-07-12';
EXEC AssetsProcedure @StoreID = 1009, @AssetName = 'Computers' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-11-10';
EXEC AssetsProcedure @StoreID = 1009, @AssetName = 'Air Condition' ,@AssetType= 'Electronic' , @AssetStatus= 'Not Working', @LastMaintenanceDate = '2020-09-02';

EXEC AssetsProcedure @StoreID = 1010, @AssetName = 'Digital Display' ,@AssetType= 'Electronic' , @AssetStatus= 'Not Working', @LastMaintenanceDate = '2020-08-25';
EXEC AssetsProcedure @StoreID = 1010, @AssetName = 'Computers' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-03-07';
EXEC AssetsProcedure @StoreID = 1010, @AssetName = 'Air Condition' ,@AssetType= 'Electronic' , @AssetStatus= 'Working', @LastMaintenanceDate = '2020-03-21';

-------------------------------------------------------------------------------------------------------------------------------10) Login Table

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('user3@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),convert(varbinary,'RetailUser3')),'Favourite Fruit:Mango','20200618 10:50:09AM');

CREATE MASTER KEY ENCRYPTION BY Password= 'Group4_2020';

--Create Certificate
CREATE CERTIFICATE RetailCertificate WITH SUBJECT ='Retail-DB Test Certificate', EXPIRY_DATE='2030-12-31';

--Create symmetric key to encrypt data
CREATE SYMMETRIC KEY TestSymmetricKey WITH ALGORITHM = AES_128 ENCRYPTION BY CERTIFICATE RetailCertificate;

--open symmetric key
OPEN SYMMETRIC KEY TestSymmetricKey DECRYPTION BY CERTIFICATE RetailCertificate;

Select * from dbo.login;
---Data insert customers in Login table
UPDATE dbo.Login
SET  Password= EncryptByKey(Key_GUID('TestSymmetricKey'),convert(varbinary,'User@4'))
WHERE LoginID = 'user4@gmail.com';

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('user3@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailUser3')),'Favourite Fruit:Mango','20200618 10:50:09');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('user4@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailUser4')),'Favourite Fruit:pear','20200618 11:50:09');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('user5@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailUser5')),'Favourite Fruit:banana','20200618 11:50:09');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('user6@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailUser6')),'Favourite day:sunday','20200618 11:50:09');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('user7@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailUser7')),'Favourite day:friday','20200618 11:50:09');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('user8@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailUser8')),'Favourite day:monday','20200618 11:50:09');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('user9@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailUser9')),'Nick name:sandy','20200618 11:50:09');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('user10@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailUser10')),'Nick name:sui','20200618 11:50:09');
----------Insert Employee in login table

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp1@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp1')),'Nick name:pops','20191201 08:15:09PM');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp2@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp2')),'favourite palce:Paris','20191128 08:15:09PM');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp3@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp3')),'favourite palce:London','20191125 08:15:09PM');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp4@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp4')),'favourite palce:New York','20201128 08:15:09PM');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp5@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp5')),'favourite palce:Mumbai','20200828 11:15:09PM');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp6@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp6')),'favourite palce:Goa','20200628 10:15:09PM');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp7@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp7')),'favourite palce:LA','20200928 08:15:09AM');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp8@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp8')),'favourite palce:Boston','20201201 011:15:09AM');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp9@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp9')),'favourite palce:NJ','20200428 10:15:09AM');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp10@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp10')),'best friend:Sania','20200911 01:15:09PM');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp11@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp11')),'best friend:Sami','20200819 01:10:09');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp12@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp12')),'best friend:levi','20200819 01:10:09');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp13@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp13')),'best friend:humaira','20200819 01:10:09');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp14@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp14')),'best friend:lolo','20200819 01:10:09');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp15@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp15')),'best friend:kelly','20200819 01:10:09');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp16@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp16')),'best friend:kop','20200819 01:10:09');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp17@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp17')),'nick name:kedi','20200819 01:10:09');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp18@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp18')),'nick name:yarmi','20200819 01:10:09');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp19@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp19')),'nick name:jenna','20200819 01:10:09');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp20@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp20')),'nick name:kaby','20200819 01:10:09');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp21@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp21')),'nick name:and','20200819 01:10:09');

INSERT INTO dbo.Login (LoginID, Password, SecurityQuestion, LastLoginDateTime) 
VALUES ('emp22@gmail.com', EncryptByKey(Key_GUID(N'TestSymmetricKey'),
convert(varbinary,'RetailEmp22')),'nick name:jan','20200819 01:10:09');

------Alter table Employee to add role ID
ALTER TABLE dbo.Employee ADD RoleID integer NOT NULL;
ALTER TABLE dbo.Employee ADD FOREIGN KEY (RoleID) REFERENCES dbo.Roles (RoleID);

-------------------------------------------------------------------------------------------------------------------------------
--11)	Roles Table
Create Procedure roles_insert
@RoleType varchar(40)
AS
Begin
	Insert Into dbo.Roles(RoleType) Values(@RoleType);
END


DECLARE @RoleType varchar(40);
SET @RoleType = 'Warehouse Associate – Material Handler';
EXEC roles_insert @RoleType;

-------------------------------------------------------------------------------------------------------------------------------

12)	Employee Table

----------Insert data into Employee Table
INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp1@gmail.com','John','Doe','M','johndoe@gmail.com','19930423','20190823',10000,32,1,'675-678-8768');

INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp2@gmail.com','Merry','Diana','F','merryd@gmail.com','19910410','20190625',11000,33,2,'671-678-2268');


INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp3@gmail.com','Ubi','Bal','M','ubid@gmail.com','19920411','20190625',9000,34,3,'671-618-1268');

INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp4@gmail.com','Sai','Kal','F','saik@gmail.com','19910411','20190622',9000,35,4,'661-618-1268');

INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp5@gmail.com','Sam','jal','M','samJ@gmail.com','19960411','20180621',8000,36,5,'661-618-1268');

INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp6@gmail.com','Sandy','jalli','M','sandyJ@gmail.com','19900711','20180620',8000,37,6,'661-618-0068');

INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp7@gmail.com','Jolly','Ball','F','jollyB@gmail.com','19900909','20180820',8000,38,7,'611-628-0068');


INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp8@gmail.com','guila','demis','F','guiD@gmail.com','19922309','20180820',8000,39,8,'611-628-0018');

INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp9@gmail.com','Husai','dell','M','dellH@gmail.com','19970909','20180820',8000,40,7,'611-628-1268');

INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp10@gmail.com','Sally','Levito','F','sallyL@gmail.com','19902909','20180820',8000,39,8,'601-608-0018');

INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp11@gmail.com','Kelly','Kulera','F','KellyK@gmail.com','19892909','20180920',9000,41,1,'611-608-0018');

INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp12@gmail.com','Jai','Khambata','M','JaiK@gmail.com','19872909','20180920',9000,42,1,'655-608-0018');

INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp13@gmail.com','Sara','ALi','F','SaraA@gmail.com','198929023','20180920',9000,43,3,'625-608-0018');

INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp14@gmail.com','Denis','Hali','M','DenisH@gmail.com','19891012','20180920',10000,44,5,'611-608-0018');

INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp15@gmail.com','Caroline','Fox','F','CarolF@gmail.com','19931212','20180920',10000,45,5,'618-608-0018');

INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp16@gmail.com','Vijey','Rom','M','vjrom@gmail.com','19930912','20180720',7000,45,3,'618-128-0018');

INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp17@gmail.com','Kamoty','Roxi','M','CamotyR@gmail.com','19950923','20191120',7000,46,3,'618-608-0118');

INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp18@gmail.com','Kal','Bugi','M','KalBu@gmail.com','19900923','20161120',12000,47,2,'618-118-0118');

INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp19@gmail.com','Juili','Bani','F','JuiB@gmail.com','19910923','20161120',8000,48,6,'618-128-0118');

INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp20@gmail.com','Kalam','Kali','F','KalK@gmail.com','19890923','20161121',8000,49,4,'618-128-2318');

-----insert more managers
INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp21@gmail.com','Andy','Cock','M','AndyC@gmail.com','19890920','20151121',11000,50,2,'648-108-2318',1004);

INSERT INTO dbo.Employee (LoginID, FirstName, LastName, Gender, PersonalEmail, DateOfBirth, DateOfHire, Salary, AddressID, RoleID, PhoneNumber) 
VALUES('emp22@gmail.com','Jani','Rehamn','F','JanR@gmail.com','19900821','20171121',11000,51,2,'678-108-2118',1005);

---- UPDATE STOREID COLUMN IN EMPLOYEE TABLE----
UPDATE dbo.Employee
SET  StoreID= 1001
WHERE EmployeeID = 14;

-------------------------------------------------------------------------------------------------------------------------------
13)	Timesheet Table
INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (9,26,'2020-11-02','10:30:00','18:30:00','Approved');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (9,26,'2020-11-03','10:30:00','18:30:00','Approved');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (9,26,'2020-11-04','10:30:00','18:30:00','Approved');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (9,26,'2020-11-05','10:30:00','18:30:00','Approved');
INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (9,26,'2020-11-06','10:30:00','18:30:00','Approved');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (9,26,'2020-11-09','10:30:00','18:30:00','Approved');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (9,26,'2020-11-10','10:30:00','18:30:00','Approved');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (9,26,'2020-11-11','10:30:00','18:30:00','Submitted');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (9,26,'2020-11-12','10:30:00','18:30:00','Submitted');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (9,26,'2020-11-13','10:30:00','18:30:00','Submitted');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (19,21,'2020-11-02','06:30:00','17:30:00','Approved');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (19,21,'2020-11-03','06:30:00','17:30:00','Approved');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (19,21,'2020-11-04','06:30:00','17:30:00','Approved');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (19,21,'2020-11-05','06:30:00','17:30:00','Approved');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (19,21,'2020-11-06','06:30:00','17:30:00','Approved');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (19,21,'2020-11-09','06:30:00','17:30:00','Approved');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (19,21,'2020-11-10','06:30:00','17:30:00','Approved');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (19,21,'2020-11-11','06:30:00','17:30:00','Approved');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy,StartDate,StartTime,EndTime,ApprovalStatus) 
VALUES (19,21,'2020-11-12','06:30:00','17:30:00','Approved');
INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy,StartDate,StartTime,EndTime,ApprovalStatus) 
VALUES (19,21,'2020-11-13','06:30:00','17:30:00','Approved');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (20,25,'2020-11-02','09:30:00','19:30:00','Approved');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (20,25,'2020-11-03','09:30:00','19:30:00','Approved');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (20,25,'2020-11-04','09:30:00','19:30:00','Declined');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (20,25,'2020-11-05','09:30:00','19:30:00','Submitted');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (20,25,'2020-11-06','09:30:00','19:30:00','Submitted');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (20,25,'2020-11-09','09:30:00','19:30:00','Declined');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (20,25,'2020-11-10','09:30:00','19:30:00','Declined');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (20,25,'2020-11-11','09:30:00','19:30:00','Declined');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (20,25,'2020-11-12','09:30:00','19:30:00','Declined');

INSERT INTO dbo.TimeSheets (EmployeeID, ApprovedBy, StartDate, StartTime, EndTime, ApprovalStatus) 
VALUES (20,25,'2020-11-13','09:30:00','19:30:00','Declined');
-------------------------------------------------------------------------------------------------------------------------------

14)Supplier Table


INSERT INTO Supplier(AddressID,PhoneNumber,SupplierName) 
VALUES (12,'(614) 555-4435','Micro Center');

INSERT INTO Supplier(AddressID,PhoneNumber,SupplierName)
VALUES (13,'(559) 555-2993','Zee Medical Service Co');

INSERT INTO Supplier(AddressID,PhoneNumber,SupplierName)
VALUES (14,'(800) 555-8110','Nielson');

INSERT INTO Supplier(AddressID,PhoneNumber,SupplierName)
VALUES (15,'(559) 555-8060','Shields Design');

INSERT INTO Supplier(AddressID,PhoneNumber,SupplierName)
VALUES (16,'(559) 555-1704','Executive Office Products');

INSERT INTO Supplier(AddressID,PhoneNumber,SupplierName)
VALUES (17,'(233) 555-6400','Zip Print & Copy Center');

INSERT INTO Supplier(AddressID,PhoneNumber,SupplierName)
VALUES (18,'(800) 555-7000','Ford Motor Credit Company');

INSERT INTO Supplier(AddressID,PhoneNumber,SupplierName)
VALUES (19,'(202) 555-5561','Reiters Scientific & Pro Books');

INSERT INTO Supplier(AddressID,PhoneNumber,SupplierName) 
VALUES (20,'(559) 555-3112','Valprint');

INSERT INTO Supplier(AddressID,PhoneNumber,SupplierName) 
VALUES (21,'(559) 555-6643','Lou Gentile Flower Basket');

INSERT INTO Supplier(AddressID,PhoneNumber,SupplierName)
VALUES (72,'(617) 555-6668','Ingram Content Group');

INSERT INTO Supplier(AddressID,PhoneNumber,SupplierName)
VALUES (73,'(857) 555-6456','Baker and Taylor');

INSERT INTO Supplier(AddressID,PhoneNumber,SupplierName) 
VALUES (72,'(617) 555-6668','Ingram Content Group');

INSERT INTO Supplier(AddressID,PhoneNumber,SupplierName) 
VALUES (73,'(857) 555-6456','Baker and Taylor');

-------------------------------------------------------------------------------------------------------------------------------

15)	Promotion Products Table

insert into PromotionProducts(ProductID,PromotionID) values (111,5002);
insert into PromotionProducts(ProductID,PromotionID) values (115,5002);
insert into PromotionProducts(ProductID,PromotionID) values (117,5002);
insert into PromotionProducts(ProductID,PromotionID) values (128,5002);
insert into PromotionProducts(ProductID,PromotionID) values (148,5002);
insert into PromotionProducts(ProductID,PromotionID) values (151,5002);
insert into PromotionProducts(ProductID,PromotionID) values (159,5002);
insert into PromotionProducts(ProductID,PromotionID) values (160,5002);
insert into PromotionProducts(ProductID,PromotionID) values (157,5002);
insert into PromotionProducts(ProductID,PromotionID) values (158,5005);
insert into PromotionProducts(ProductID,PromotionID) values (159,5005);
insert into PromotionProducts(ProductID,PromotionID) values (162,5005);
insert into PromotionProducts(ProductID,PromotionID) values (153,5005);
insert into PromotionProducts(ProductID,PromotionID) values (147,5005);
insert into PromotionProducts(ProductID,PromotionID) values (148,5005);
insert into PromotionProducts(ProductID,PromotionID) values (111,5003);
insert into PromotionProducts(ProductID,PromotionID) values (112,5003);
insert into PromotionProducts(ProductID,PromotionID) values (113,5003);
insert into PromotionProducts(ProductID,PromotionID) values (115,5003);
insert into PromotionProducts(ProductID,PromotionID) values (117,5003);
insert into PromotionProducts(ProductID,PromotionID) values (120,5003);
insert into PromotionProducts(ProductID,PromotionID) values (121,5003);
insert into PromotionProducts(ProductID,PromotionID) values (122,5003);
insert into PromotionProducts(ProductID,PromotionID) values (123,5002);
insert into PromotionProducts(ProductID,PromotionID) values (112,5001);
insert into PromotionProducts(ProductID,PromotionID) values (115,5001);
insert into PromotionProducts(ProductID,PromotionID) values (111,5001);
insert into PromotionProducts(ProductID,PromotionID) values (136,5001);
insert into PromotionProducts(ProductID,PromotionID) values (134,5001);
insert into PromotionProducts(ProductID,PromotionID) values (133,5001);
insert into PromotionProducts(ProductID,PromotionID) values (112,5007);
insert into PromotionProducts(ProductID,PromotionID) values (115,5007);
insert into PromotionProducts(ProductID,PromotionID) values (111,5007);
insert into PromotionProducts(ProductID,PromotionID) values (136,5007);
insert into PromotionProducts(ProductID,PromotionID) values (134,5007);
insert into PromotionProducts(ProductID,PromotionID) values (133,5007);
insert into PromotionProducts(ProductID,PromotionID) values (112,5006);
insert into PromotionProducts(ProductID,PromotionID) values (115,5006);
insert into PromotionProducts(ProductID,PromotionID) values (111,5006);
insert into PromotionProducts(ProductID,PromotionID) values (136,5006);
insert into PromotionProducts(ProductID,PromotionID) values (134,5006);
insert into PromotionProducts(ProductID,PromotionID) values (133,5006);


-------------------------------------------------------------------------------------------------------------------------------

16)	Product Category Table

CREATE PROCEDURE ProductCategoryProcedure
@CategoryName varchar(50),
@Description varchar(100)
AS
BEGIN 

		INSERT INTO ProductCategory(CategoryName,Description) VALUES(@CategoryName,@Description)
END


Declare @CatName varchar(50);
Declare @Desc varchar(100);

SET @CatName = 'Electronics';
SET  @Desc= 'This section contains all Eletronics Products'

EXEC ProductCategoryProcedure @CatName,@Desc;

-------------------------------------------------------------------------------------------------------------------------------
17)	Product Table
INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber) 
VALUES(12,10,'T-shirts',30,1000,'2020-03-20','1-A');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(12,10,'Pantalons & Shorts',28,1500,'2020-04-20','1-A');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber) 
VALUES(12,10,'Robes',20.69,120,'2020-06-20','1-A');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber) 
VALUES(12,10,'Nightwear',15.99,250,'2020-06-17','1-B');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber) 
VALUES(11,10,'T-shirts',25,1000,'2020-06-28','1-C');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(11,10,'Shirts',45,678,'2020-06-23','1-C');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(11,10,'Pyjamas',10.99,370,'2020-06-24','1-D');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(11,10,'Ties',30,176,'2020-05-20','1-C');
INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(11,4,'Flowers',7.89,100,'2020-11-26','2-A');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber) 
VALUES(4,9,'Home Carpets',80.99,30,'2020-08-20','2-D');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(4,9,'Mirrors',8.78,100,'2019-03-20','2-B');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(4,9,'Cushions',23.89,100,'2019-03-20','2-B');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(4,9,'Outdoor Tools',34.56,100,'2019-03-20','2-C');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(13,3,'MultiVitamin Gummies',10.89,170,'2019-09-20','1-K');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(13,3,'College Wellness Essentials Collection',23.99,1000,'2019-09-28','1-K');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(13,3,'Flexible Fabric Bandages',1.99,2300,'2020-09-29','1-K');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(13,3,'Deluxe Safety Kits',27.99,998,'2020-07-15','1-L');
INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(8,9,'College Ruled Notebook',0.99,3000,'2020-05-14','2-D');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)VALUES(8,9,'6ct File Folders',4.29,1000,'2020-03-23','2-D');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(8,9,' Planner 2021',14.99,245,'2020-10-20','2-D');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(8,9,'WoodCase Pencils',3.99,345,'2020-07-05','2-D');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(3,3,'Suave Hand Sanitizer Unscented',2.99,4500,'2020-11-20','1-M');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber) 
VALUES(3,3,'Hand and Face Wipes',1.77,3780,'2020-11-20','1-M');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(3,3,'Crest Whitening Toothaste',5.99,1080,'2020-03-20','1-M');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(3,3,'Super Clean ToothBrush',3.49,678,'2020-03-20','1-M');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(3,3,'Face Cleansing Device',24.99,345,'2020-05-20','1-N');
INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(3,3,'Face Cream Moisturizer',24.99,234,'2020-07-5','1-N');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(7,2,'Vitamin-d Whole Milk',3.29,100,'2020-11-26','1-E');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(7,2,'Vital Farms Large Eggs',5.49,56,'2020-11-26','1-E');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(7,2,'Organic Salted Butter',5.29,45,'2020-11-20','1-E');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(7,2,'SaraLee Bread',2.69,78,'2020-11-24','1-E');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(7,2,'Boneless Chicken',12.22,38,'2020-11-25','1-F');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(7,2,'Apple and Chicken Sausage',3.99,67,'2020-11-19','1-F');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(14,1,'Bose Wireless Headphones',159.99,134,'2020-06-27','2-J');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(14,1,'Bose Noise Cancellation Headphones',300.99,47,'2020-06-27','2-J');
INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(14,1,'Smart Roku TV',119.99,30,'2020-08-14','2-J');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber) 
VALUES(14,1,'HP Touchscreen Laptop',399.99,12,'2020-11-02','2-K');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(14,1,'Acer TouchScreen Laptop',499.99,15,'2020-11-02','2-K');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(14,1,'Epson Wireless Printer',69.99,67,'2020-08-05','2-L');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(14,1,'Canon Scanner',79.95,23,'2020-08-05','2-L');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(6,10,'Timberland Womens Shoes',170,30,'2020-11-03','2-P');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(6,10,'Womens Short Winter Boots',39.99,24,'2020-11-03','2-P');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(6,10,'Mens Ankle Rain Boots',44.99,23,'2020-11-03','2-Q');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(6,10,'Mens Fashion Boots',27.99,56,'2020-11-03','2-Q');
INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(6,10,'Toddlers Winter Boots',29.99,12,'2020-10-15','2-S');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(6,10,'Toddlers Fashion Boots',34.99,56,'2020-10-15','1-S');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(5,3,'Long Sleeve Pullover',12.99,78,'2020-11-17','1-P');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(5,3,'Long Sleeve T-shirt',14.99,45,'2020-11-17','1-P');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(5,3,'Woven Tops',14.99,25,'2020-11-17','1-P');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(5,3,'Fur Jacket',34.99,35,'2020-11-17','1-Q');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(5,3,'Run Shorts',6.80,57,'2020-11-17','1-Q');

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(5,3,'Stretch Skinny Jeans',16.99,43,'2020-11-17','1-Q');	

INSERT INTO Product(ProductCategoryId,SupplierId,ProductName,UnitPrice,UnitsInStock,LastUpdatedDate,RackNumber)
VALUES(5,3,'Stretch Skinny JeansTop',-9,43,'2020-11-17','1-Q');


-------------------------------------------------------------------------------------------------------------------------------
19)	Address Table

--1
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('4116  Christie Way',NULL,'Boston','Massachusetts',02110,'Shipping');

--2
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('2951  Metz Lane','Apt 16','Boston','Massachusetts',02215,'Shipping');

--3
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('1589  Aspen Court',NULL,'Cambridge','Massachusetts',02138,'Home');

--4
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('3453  Delaware Avenue','Apt 721','San Francisco','California',94104,'Shipping');

--5
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('1981  Pinnickinick Street','Apt 520','Seattle','Washington',98119,'Shipping');

--6
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('373  Hinkle Lake Road','Apt 18','Boston','Massachusetts',02110,'Billing');

--7
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('3480  Blair Court','Apt 212','Edina','Missouri',63537,'Billing');

--8
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('2168  Callison Lane','Apt 4','Boston','Massachusetts',40107,'Shipping');

--9
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('2550  East Avenue','Apt 912','Phoenix','Arizona',85003,'Shipping');

--10
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('3727  Poplar Street',NULL,'Chicago','Illinois',60631,'Shipping');

--22
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('3648  Benedum Drive','Apt 789','White Plains','New York',10601,'Shipping');

--23
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('3224  Bee Street', NULL,'Mc Bain','Michigan',49657,'Shipping');

--24
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('111  Eagle Lane', NULL,'Erskine','Minnesota',56535,'Shipping');

--25
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('1219  Newton Street','Apt 1009','Maple','Texas',79344,'Shipping');

--26
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('1817  Davis Lane','Apt 20','Centennial','Colorado',80112,'Shipping/Billing');

--27
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('2204  Stout Street', NULL,'Burlington','Indiana',46915,'Shipping');

--28
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('3221  Franklin Street',NULL,'Montgomery','Alabama',36104,'Shipping/Billing');

--29
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('264  Roosevelt Wilson Lane',NULL,'Ontario','Californai',91762,'Shipping');

--30
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('2284  Rosebud Avenue','S100','Fort LauderDale','Florida',33330,'Shipping');

--31
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('2315  James Avenue',NULL,'Syracuse','New York',13202,'Shipping');

--32
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('2534  Thorn Street',NULL,'Midwest','Wyoming',82643,'Home');

--33
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('3994  Tavern Place',NULL,'Williamson','West Virginia',25661,'Home');

--34
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('508  Reeves Street',NULL,'Hilbert','Wisconsin',54129,'Home');

--35
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('663  Marion Street','S#181','Newbury','Vermont',05051,'Home');

--36
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('1139  Lang Avenue','Unit#123','Snowville','Utah',84336,'Home');

--37
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('4258  Mapleview Drive',NULL,'Memphis','Tennessee',38110,'Home');

--38
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('3331  Mattson Street','Apt 788','Salem','Oregon',97301,'Home');

--39
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('4538  Simpson Square',NULL,'Elmer','Oklahoma',73539,'Home');

--40
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('133  Eagle Lane','Unit#120','Avon','Connecticut',06001,'Home');

--41
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('1110  Hide A Way Road','S18','Aiea','Hawaii',96701,'Home');

--42
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('2780  Veltri Drive','Unit#67','Anchorage','Alaska',99503,'Home');

--43
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('1264  Rosebud Avenue','Apt 81','Wilmar','Arkansas',71675,'Home');

--44
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('530  Argonne Street',NULL,'New Castle','Delaware',19720,'Home');

--45
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('652  Clousson Road',NULL,'Everly','Iowa',51338,'Home');

--46
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('180  Young Road','S#12','Boise','Idaho',83702,'Home');

--47
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('3784  Roguski Road',NULL,'Monroe','Louisiana',71201,'Home');

--48
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('3784  Roguski Road',NULL,'DHS','Maryland',20588,'Home');

--49
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('28  Pinewood Avenue','Apt 901','Powers','Michigan',49874,'Home');

--50
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('2790  Coolidge Street',NULL,'Elmo','Montana',59915,'Home');

--51
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('4365  Eastland Avenue',NULL,'Jackson','Mississippi',39206,'Home');

--52 
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('4650  Vesta Drive',NULL,'Chicago','Illinois',60637,'Home');
 
--53
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('3426  George Street',NULL,'Ocala','Florida',34471,'Home');

--54
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('2360  Leroy Lane',NULL,'Milo','Missouri',89990,'Home');

--55
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('627  Kenwood Place',NULL,'Fort Lauderdale','Florida',33301,'Home');

--56
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('2563  Nuzum Court',NULL,'Buffalo','New York',14214,'Home');

--57
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('1990  Cabell Avenue',NULL,'Washington','Virginia',20008,'Home');

--58
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('4824  Hornor Avenue',NULL,'Tulsa','Oklahoma',74119	,'Home');

--59
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('2441  Lang Avenue',NULL,'East Saint Louis','Illinois',62207,'Home');

--60
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('23715  Massachusetts Avenue',NULL,'Washington','Washington DC',20200,'Home');

--61
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('2966  Fraggle Drive',NULL,'Hickory Hills','Illinois',60457,'Home');

--62
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('3644  Bassel Street',NULL,'Bayou Vista','Louisiana',70392,'Billing');

--63
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('4039  Wiseman Street',NULL,'Sevierville','Tennessee',37862,'Billing');

--64
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('206  Timber Ridge Road',NULL,'Elk Grove','California',95624,'Billing');

--65
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('1167 Boylston Street','Apt 21','Boston','Massachusetts',02115,'Billing');

--66
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('352 Riverway','Apt 10','Boston','Massachusetts',02215,'Billing');

--67
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('4415  Sardis Station',NULL,'Minneapolis','Minnesota',55402,'Billing');

--68
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('2359  Abia Martin Drive',NULL,'New York','New York',10013,'Billing');

--69
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('4456  Adamsville Road',NULL,'Harlingen','Texas',78550,'Billing');

--70
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('1592  Desert Broom Court',NULL,'Jersey City','New Jersey',07304,'Billing');

--71
INSERT INTO Address(AddressLine1, AddressLine2, City, State, Zipcode, AddressType) 
VALUES ('2810  Whitetail Lane',NULL,'Irving','Texas',75039,'Billing');

--72
insert into address values ('2446 Chapman St','','Fullerton','California',92831,'Home');

--73
insert into address values ('352 Riverway','','Boston','Massachusetts',02115,'Home');

SELECT * FROM Address a;

-------------------------------------------------------------------------------------------------------------------------------
18) Customer
--1
INSERT INTO Customer(AddressID, LoginID, FirstName, LastName, DateOfBirth, Phone, MembershipType, RewardPoints, CustomerNotes)
VALUES (22,'user1@gmail.com','Joseph','Tijerina','1980-11-11','845-446-8609','Gold','10', NULL);

--2
INSERT INTO Customer(AddressID, LoginID, FirstName, LastName, DateOfBirth, Phone, MembershipType, RewardPoints, CustomerNotes)
VALUES (23,'user2@gmail.com','George','George','1992-10-20','409-201-0855','Silver',NULL, NULL);

--3
INSERT INTO Customer(AddressID, LoginID, FirstName, LastName, DateOfBirth, Phone, MembershipType, RewardPoints, CustomerNotes)
VALUES (24,'user3@gmail.com','John','Williams','1995-8-7','512-601-0938',NULL,NULL,'New Customer');

--4
INSERT INTO Customer(AddressID, LoginID, FirstName, LastName, DateOfBirth, Phone, MembershipType, RewardPoints, CustomerNotes)
VALUES (24,'user4@gmail.com','Bridgette','Ross	','1985-3-21','469-995-3009','Platinum','1000','Regular Customer');

--5
INSERT INTO Customer(AddressID, LoginID, FirstName, LastName, DateOfBirth, Phone, MembershipType, RewardPoints, CustomerNotes)
VALUES (26,'user5@gmail.com','William','Brazier','1995-8-7','512-601-0938','Silver','20',NULL);

--7
INSERT INTO Customer(AddressID, LoginID, FirstName, LastName, DateOfBirth, Phone, MembershipType, RewardPoints, CustomerNotes)
VALUES (27,'user6@gmail.com','Stephanie','Kimberling','1982-1-28','484-281-5470','Premium','2500','Most Regular Customer');

--8
INSERT INTO Customer(AddressID, LoginID, FirstName, LastName, DateOfBirth, Phone, MembershipType, RewardPoints, CustomerNotes)
VALUES (28,'user7@gmail.com','Terry','Terry','1993-2-7','512-601-0938','Silver','80',NULL);

--9
INSERT INTO Customer(AddressID, LoginID, FirstName, LastName, DateOfBirth, Phone, MembershipType, RewardPoints, CustomerNotes)
VALUES (29,'user8@gmail.com','Marina','Marina','1987-10-1','701-474-8819',NULL,NULL,'New Customer');

--10
INSERT INTO Customer(AddressID, LoginID, FirstName, LastName, DateOfBirth, Phone, MembershipType, RewardPoints, CustomerNotes)
VALUES (30,'user9@gmail.com','Ann','Norvell','1997-8-10','573-675-9910',NULL,'100',NULL);

--11
INSERT INTO Customer(AddressID, LoginID, FirstName, LastName, DateOfBirth, Phone, MembershipType, RewardPoints, CustomerNotes)
VALUES (31,'user10@gmail.com','Thomas','Nance','1989-6-21','608-633-8742',NULL,'50',NULL);

SELECT * from Customer c

	
