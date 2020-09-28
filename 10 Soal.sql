USE Hermosa

--1
SELECT M.MemberId,MemberName,SUM(RentQuantity) AS 'Total Rent Quantity'
FROM Member M,RENT R
WHERE M.MemberId = R.MemberId AND datepart(MM,StartDate) = 6 AND R.MemberId LIKE 'MM00[1-5]'
GROUP BY M.MemberId,MemberName

--2
SELECT MS.StaffId,StaffName,COUNT(*) AS 'Total Purchase Transaction'
FROM MsStaff MS,TransactionHeader TH,Payment P
WHERE MS.StaffId =  TH.StaffId AND P.PaymentId = TH.PaymentId AND PaymentAmount > 1000000 AND DATEPART(MM,TransactionDate) = 5
GROUP BY MS.StaffId,StaffName

--3
SELECT [Member Name] = 'Mrs. ' + MemberName, SUM(GownPrice) * DATEDIFF(DD,StartDate,ReturnDate) AS 'Renting Cost',COUNT(RentQuantity) AS 'Total Gown Rented'
FROM Member M,Gown G,RENT R, MsStaff MS,TransactionHeader TH
WHERE M.MemberId = R.MemberId AND MS.StaffId = R.StaffId AND TH.StaffId = MS.StaffId AND TH.GownId = G.GownId
AND MemberGender = 'Female' AND DATEPART(DD,TransactionDate) = 15
GROUP BY MemberName,StartDate,ReturnDate
UNION
SELECT [Member Name] = 'Mr. ' + MemberName, SUM(GownPrice) * DATEDIFF(DD,StartDate,ReturnDate) AS 'Renting Cost',COUNT(RentQuantity) AS 'Total Gown Rented'
FROM Member M,Gown G,RENT R, MsStaff MS,TransactionHeader TH
WHERE M.MemberId = R.MemberId AND MS.StaffId = R.StaffId AND TH.StaffId = MS.StaffId AND TH.GownId = G.GownId
AND MemberGender = 'Male' AND DATENAME(DD,TransactionDate) = 15
GROUP BY MemberName,StartDate,ReturnDate

--4
SELECT MS.StaffId, SUBSTRING(StaffName,1,CHARINDEX(' ',StaffName)),SUM(PaymentAmount) AS 'Total Purchasing Amount'
FROM MsStaff MS , TransactionHeader TH , Payment P, RENT R
WHERE MS.StaffId = TH.StaffId AND P.PaymentId = TH.PaymentId AND R.StaffId = MS.StaffId AND  MS.StaffId ='ST001' AND RentQuantity != 0
GROUP BY MS.StaffId,StaffName

--5
SELECT StaffId,StaffName,LEFT(StaffGender,1) AS 'StaffGender', 'Rp. ' + CAST(StaffSalary AS VARCHAR) AS 'StaffSalary'
FROM MsStaff , 
(SELECT [Avg_Salary] = AVG(StaffSalary)
FROM MsStaff) AS X
WHERE  StaffSalary > X.Avg_Salary AND StaffName LIKE 'A%'
ORDER BY StaffId DESC

--6
SELECT G.GownId,CAST(COUNT(TransactionId) AS VARCHAR) + ' times' AS 'Rented Total Times',GownColour,GownName,GownDescription
FROM Gown G JOIN TransactionHeader TH
ON G.GownId = TH.GownId JOIN GownType GT 
ON G.GownTypeId = GT.GownTypeId JOIN Rent R
ON R.GownId = G.GownId, 
( SELECT [Avg_Desc] = AVG(LEN(GownDescription)) 
FROM GownType
) AS Y
WHERE DATEPART(MM,ReturnDate) = 6 AND LEN(GownDescription) < Y.Avg_Desc
GROUP BY G.GownId,GownColour,GownName,GownDescription

--7
SELECT REPLACE(G.GownId,'GW','Gown'),GownName,'Rp. ' + CAST(GownPrice AS VARCHAR) AS 'GownPrice',SUM(RentQuantity) AS 'Gown Rented Times',GownColour
FROM Gown G JOIN GownType GT
ON G.GownTypeId = GT.GownTypeId JOIN TransactionHeader TH
ON TH.GownId = G.GownId JOIN RENT R
ON R.GownId = G.GownId,
(SELECT [Avg_Price] = AVG(GownPrice) 
FROM Gown) AS Z
WHERE GownPrice > Z.Avg_Price AND DATEPART(MM,TransactionDate) = 6
GROUP BY G.GownId,GownName,GownPrice,GownColour
ORDER BY G.GownId ASC

--8
SELECT CONVERT(VARCHAR,TransactionDate,107),REPLACE(MS.StaffId,'ST','Staff') AS 'Staff Number',TransactionId,P.PaymentId,'Rp. ' + CAST(PaymentAmount AS VARCHAR) AS 'Payment Amount',
SUM(RentQuantity) AS 'Total Gown Rented'
FROM TransactionHeader TH JOIN MsStaff MS
ON TH.StaffId = MS.StaffId JOIN Payment P
ON P.PaymentId = TH.PaymentId JOIN RENT R
ON R.StaffId = MS.StaffId,
(SELECT [Max_Amount] = MAX(PaymentAmount)
FROM Payment
) AS A
WHERE PaymentAmount = A.Max_Amount AND DATEPART(MM,TransactionDate) = 5
GROUP BY TransactionDate,MS.StaffId,TransactionId,P.PaymentId,PaymentAmount

--9
GO
CREATE VIEW MemberTotalTransaction
AS
SELECT M.MemberId,MemberName, COUNT(*) AS 'Total Rent',SUM(GownPrice) * DATEDIFF(DD,StartDate,ReturnDate) AS 'Total Purchase Amount'
FROM Gown G JOIN Rent R
ON G.GownId = R.GownId JOIN Member M
ON M.MemberId = R.MemberId
WHERE M.MemberId  = 'MM001' AND DATEDIFF(DD,StartDate,ReturnDate) > 1
GROUP BY M.MemberId,MemberName,StartDate,ReturnDate

--10
GO
CREATE VIEW StaffInvolvemen
AS
SELECT MS.StaffId , StaffName ,COUNT(TransactionId) AS 'Staff Purchase Involvement',SUM(PaymentAmount) AS 'Staff Total Expense'
FROM MsStaff MS JOIN TransactionHeader TH
ON TH.StaffId = MS.StaffId JOIN Payment P
ON P.PaymentId = TH.PaymentId,
(SELECT [STE] = SUM(PaymentAmount)
FROM MsStaff MS JOIN TransactionHeader TH
ON MS.StaffId = TH.StaffId JOIN Payment P
ON P.PaymentId = TH.PaymentId
) AS Q
WHERE DATEPART(MM,TransactionDate) = 5 AND Q.STE > 1000000
GROUP BY MS.StaffId,StaffName