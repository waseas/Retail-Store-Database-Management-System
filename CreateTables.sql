USE [Retail Store Database Management];
-------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE dbo.Orders (
 OrderID int IDENTITY NOT NULL PRIMARY KEY,
 CustomerID int NOT NULL REFERENCES Customer(CustomerID),
 ApprovedBy int NOT NULL REFERENCES Employee(EmployeeID),
 OnlineOrderFlag int NOT NULL,
 OrderStatus varchar(45) NOT NULL,
 OrderedDate datetime NOT NULL,
 DeliveredDate datetime NOT NULL
 );
-------------------------------------------------------------------------------------------------------------------------------
 CREATE TABLE dbo.OrderItems (
 OrderItemID int IDENTITY NOT NULL PRIMARY KEY,
 OrderID int NOT NULL REFERENCES Orders(OrderID),
 ProductID int NOT NULL REFERENCES Product(ProductID),
 Quantity int NOT NULL,
 UnitPrice money,
 TotalPrice as (Quantity*UnitPrice) --- Computed Column
 UnitDiscount money,
TotalDiscount as (Quantity*UnitDiscount) – Computed Column
 );
-------------------------------------------------------------------------------------------------------------------------------
  CREATE TABLE dbo.ReturnAndExchange (
 ReturnAndExchangeID int IDENTITY NOT NULL PRIMARY KEY,
 OrderItemID int NOT NULL REFERENCES OrderItems(OrderItemID),
 ReturnedQuantity int NOT NULL,
 ReturnedType varchar(45) NOT NULL,
 ReturnedDate datetime NOT NULL
 );
-------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE dbo.Delivery (
 DeliveryID int IDENTITY NOT NULL PRIMARY KEY,
 OrderID int NOT NULL REFERENCES Orders(OrderID),
 DeliveredBy int NOT NULL REFERENCES Employee(EmployeeID)
 );
-------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Stores (
    StoreID int NOT NULL PRIMARY KEY,
    AddressID int FOREIGN KEY REFERENCES Address(AddressID),
    ManagerID int FOREIGN KEY REFERENCES Employee(EmployeeID),
	PhoneNumber varchar(10) not null,
	StoreName varchar(30) NOT NULL,
	EmailID varchar(40) not null,
	OpeningTime TIME,
	ClosingTime TIME
);
------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Assets (
    AssetID int NOT NULL PRIMARY KEY,
    StoreID int FOREIGN KEY REFERENCES Stores(StoreID),
    AssetName varchar(30) NOT NULL,
	AssetType varchar(10) not null,
	AssetStatus varchar(10) not null,
	LastMaintenanceDate DATE
);
-------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Promotion (
	PromotionID int NOT NULL PRIMARY KEY,
	PromotionName varchar(30) NOT NULL,
	StartDate DATETIME,
	ExpiryDate DATETIME,
	DiscountPercentage int
);
-------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE PromotionStores (
	StoreID int NOT NULL FOREIGN KEY REFERENCES Stores(StoreID),
	PromotionID int NOT NULL FOREIGN KEY REFERENCES Promotion(PromotionID),
	PRIMARY KEY (StoreID, PromotionID)
);
-------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE dbo.Employee(
EmployeeID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
LoginID varchar(40) NOT NULL REFERENCES dbo.Login(LoginID),
AddressID varchar(20) NOT NULL,
FirstName varchar(40) NOT NULL,
LastName varchar(40) NOT NULL,
PhoneNumber int NOT NULL,
Gender varchar(20) NOT NULL,
PersonalEmail varchar(40) NOT NULL,
DateOfBirth DATETIME NOT NULL,
DateOfHire DATETIME NOT NULL,
Salary int NOT NULL,
StoreId int NOT NULL
CONSTRAINT FKTEmployee FOREIGN KEY (LoginID) REFERENCES dbo.Login(LoginID)
CONSTRAINT FKTEmployee2 FOREIGN KEY (AddressID) REFERENCES dbo.Address(AddressID)
);
-------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE dbo.Login(
LoginID varchar(40) NOT NULL PRIMARY KEY,
Password varchar(10) NOT NULL,
SecurityQuestion varchar(60) NOT NULL,
LastLoginDateTime DATETIME NOT NULL
);
-------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE dbo.Roles(
RoleID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
RoleType varchar(40) NOT NULL,
);
-------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE dbo.TimeSheets(
TimeSheetID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
EmployeeID int NOT NULL REFERENCES dbo.Employee(EmployeeID),
ApprovedBy int NOT NULL REFERENCES dbo.Employee(EmployeeID),
StartDate DATE NOT NULL,
StartTime time NOT NULL,
EndTime time NOT NULL,
ApprovalStatus varchar(80) NOT NULL,
CONSTRAINT FKTimesheet1 FOREIGN KEY (EmployeeID) REFERENCES dbo.Employee(EmployeeID),
CONSTRAINT FKTimesheet2 FOREIGN KEY (ApprovedBy) REFERENCES dbo.Employee(EmployeeID)
);
-------------------------------------------------------------------------------------------------------------------------------
Create Table PromotionProducts( ProductID int not null, PromotionID int not null, Primary key (ProductID,PromotionID),foreign key(ProductID) references Product(ProductID), foreign key(PromotionID) references Promotion(PromotionID));
-------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Supplier(
SupplierID int NOT NULL,
AddressID int NOT NULL,
PhoneNumber varchar(22),
SupplierName varchar(50) NOT NULL,
Notes varchar(100),
PRIMARY KEY(SupplierID),
FOREIGN KEY(AddressID) references Address(AddressID)
);

-----------------------------------------------------------------------------------------
CREATE TABLE ProductCategory(
ProductCategoryID int NOT NULL,
CategoryName varchar(50) NOT NULL,
Description varchar(100),
PRIMARY KEY(ProductCategoryID)
);
-------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Product(
ProductID int NOT NULL,
SupplierID int NOT NULL,
ProductCategoryID int NOT NULL,
ProductName varchar(70) NOT NULL,
UnitPrice money NOT NULL,
UnitsInStock int NOT NULL,
LastUpdatedDate date NOT NULL,
RakNumber varchar(10),
PRIMARY KEY(ProductID),
FOREIGN KEY(SupplierID) REFERENCES Supplier(SupplierID),
FOREIGN KEY(ProductCategoryID) REFERENCES ProductCategory(ProductCategoryID)
);
-------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Address(AddressID int NOT NULL IDENTITY(1,1) PRIMARY KEY, AddressLine1 varchar(60) NOT NULL, AddressLine2 varchar(60), 
City varchar(30) NOT NULL, State varchar(30) NOT NULL, Zipcode varchar(10) NOT NULL, AddressType varchar(30) NOT NULL);

----------------------------------------------------------------------------------------
CREATE TABLE Customer(CustomerID int NOT NULL IDENTITY(1,1) PRIMARY KEY, AddressID int NOT NULL REFERENCES dbo.Address(AddressID), 
LoginID varchar(40) NOT NULL REFERENCES dbo.Login(LoginID), 
FirstName varchar(30) NOT NULL, 
LastName varchar(30) NOT NULL, DateOfBirth Date, Phone varchar(20) NOT NULL, MembershipType varchar(30), RewardPoints int, CustomerNotes varchar(60));

-----------------------------------------------------------------------------------------
CREATE TABLE Invoice(InvoiceID int NOT NULL IDENTITY(1,1) PRIMARY KEY, OrderID int NOT NULL REFERENCES dbo.Orders(OrderID), 
StoreID int NOT NULL REFERENCES dbo.Stores(StoreID), 
RewardPointsAdded int, PaymentType varchar(30) NOT NULL,
PaymentDate Date NOT NULL, BillingAmount money NOT NULL,
CurrentType varchar(30) NOT NULL, BillingAddress int NOT NULL REFERENCES dbo.Address(AddressID), 
CardDetails varchar(30), DiscountProvided int);
-------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE dbo.Employee DROP COLUMN PhoneNumber;
ALTER TABLE dbo.Employee ADD PhoneNumber varchar(40) NOT NULL;
ALTER TABLE dbo.Employee ADD FOREIGN KEY (AddressID) REFERENCES dbo.Address(AddressID)
ALTER TABLE dbo.Employee ADD StoreID integer NOT NULL;
ALTER TABLE dbo.Employee ADD FOREIGN KEY (StoreID) REFERENCES dbo.Stores (StoreID);
ALTER TABLE dbo.Employee ALTER COLUMN StoreID INT NOT NULL;
ALTER TABLE dbo.Employee ALTER COLUMN DateOfHire DATE;
ALTER TABLE Product ALTER COLUMN RackNumber varchar(10);






