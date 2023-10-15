USE [Test]
GO
CREATE FUNCTION sprawdz(@String varchar(MAX))
RETURNS INT AS
BEGIN
DECLARE @Result INT;
SELECT @Result=(CASE WHEN @String Not LIKE  '%[^0-9]%' THEN 1 ELSE 0 END);
RETURN @Result;
END
GO
CREATE FUNCTION ile_czasu_do_rezerwacji (@data DATE)
RETURNS int AS
BEGIN
DECLARE @Result int;
DECLARE @Sdate DATE;
SELECT @Sdate=CONVERT (date,SYSDATETIME())
SELECT @Result=(DATEDIFF(day,@Sdate,@data));
RETURN @Result;
END
GO