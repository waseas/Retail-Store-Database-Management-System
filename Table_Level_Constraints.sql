CREATE FUNCTION  CheckValidity(@Start date, @end date)
Returns bit
AS
BEGIN
Declare @result bit = 1;
if ( DATEDIFF(SECOND,@Start,@end)<0)
	set @result = 0;
else 
	set @result = 1;
	return @result;
END

ALTER TABLE Promotion ADD CONSTRAINT CheckPromotionValidity CHECK(dbo.CheckValidity(StartDate,ExpiryDate)=1);

drop function checkValidity;
select * from Promotion;


-------------------------------------------------------------------------------------------------------------

CREATE FUNCTION  CheckHireValidity(@Start date, @end date)
Returns bit
AS
BEGIN
Declare @result bit = 1;
if ( DATEDIFF(YEAR,@Start,@end)<18)
	set @result = 0;
else 
	set @result = 1;
	return @result;
END

ALTER TABLE Employee ADD CONSTRAINT CheckHiringValidity CHECK(dbo.CheckHireValidity(DateOfBirth,DateofHire)=1);

drop function CheckHireValidity;

select * from Orders;

-------------------------------------------------------------------------------------------------------------
CREATE FUNCTION  CheckDeliveryEligibility(@OnlineFlag int,@deliveryDate datetime)
Returns bit
AS
BEGIN
Declare @result bit = 0;
if (@OnlineFlag = 0 AND @deliveryDate IS NOT NULL)
	set @result = 0;
else 
	set @result = 1;
	return @result;
END
drop function CheckDeliveryEligibility;

-------------------------------------------------------------------------------------------------------------


