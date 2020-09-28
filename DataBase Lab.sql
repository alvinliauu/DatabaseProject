CREATE DATABASE Hermosa

USE Hermosa

CREATE TABLE MsStaff(
	StaffId CHAR(5) PRIMARY KEY CHECK(StaffId LIKE 'ST[0-9][0-9][0-9]'),
	StaffName VARCHAR(50),
	StaffGender CHAR(6)  CHECK(StaffGender LIKE 'Male' OR StaffGender LIKE 'Female'),
	StaffSalary INT ,
	StaffEmail VARCHAR(50),
	StaffPhone VARCHAR(20) CHECK(StaffPhone LIKE '+62%'),
	StaffAddress VARCHAR(50)
)

CREATE TABLE Member(
	MemberId CHAR(5) PRIMARY KEY CHECK(MemberId LIKE 'MM[0-9][0-9][0-9]'),
	MemberName VARCHAR(50),
	MemberPhone VARCHAR(20) CHECK (MemberPhone LIKE '+62%'),
	MemberGender CHAR(6) CHECK(MemberGender LIKE 'Male' OR MemberGender LIKE 'Female'),
	MemberEmail VARCHAR(50)
)

CREATE TABLE GownType(
	GownTypeId CHAR(5) PRIMARY KEY CHECK(GownTypeId LIKE 'GT[0-9][0-9][0-9]'),
	GownName VARCHAR(50),
	GownDescription VARCHAR(50) CHECK(LEN(GownDescription) < 50)
)

CREATE TABLE Gown(
	GownId CHAR(5) PRIMARY KEY CHECK(GownId LIKE 'GW[0-9][0-9][0-9]'),
	GownTypeId CHAR(5) FOREIGN KEY REFERENCES GownType(GownTypeId),
	GownColour VARCHAR(20),
	GownPrice INT,
	GownStock INT
)

CREATE TABLE RENT(
	RentId CHAR(5) PRIMARY KEY CHECK(RentId LIKE 'RE[0-9][0-9][0-9]'),
	StaffId CHAR(5) FOREIGN KEY REFERENCES MsStaff(StaffId),
	MemberId CHAR(5) FOREIGN KEY REFERENCES Member(MemberId),
	GownId CHAR(5) FOREIGN KEY REFERENCES Gown(GownId),
	StartDate DATE,
	ReturnDate DATE,
	GownRented VARCHAR(20),
	RentQuantity INT CHECK(RentQuantity <= 5)
)

CREATE TABLE Supplier(
	SupplierId CHAR(5) PRIMARY KEY CHECK(SupplierId LIKE 'VD[0-9][0-9][0-9]'),
	SupplierName VARCHAR(50),
	SupplierPhone VARCHAR(20) CHECK (SupplierPhone LIKE '+62%'),
	SupplierEmail VARCHAR(50),
	SupplierAddress VARCHAR(50)
)

CREATE TABLE Payment(
	PaymentId CHAR(5) PRIMARY KEY CHECK(PaymentId LIKE 'PY[0-9][0-9][0-9]'),
	PaymentType VARCHAR(50) CHECK(PaymentType IN('OVO','GOPAY','BCA','CASH')),
	PaymentAmount INT
)

CREATE TABLE TransactionHeader(
	TransactionId CHAR(5) PRIMARY KEY CHECK(TransactionId LIKE 'PD[0-9][0-9][0-9]'),
	StaffId CHAR(5) FOREIGN KEY REFERENCES MsStaff(StaffId),
	SupplierId CHAR(5) FOREIGN KEY REFERENCES Supplier(SupplierId),
	GownId CHAR(5) FOREIGN KEY REFERENCES Gown(GownId),
	TransactionDate DATE,
	GownQuantity INT,
	PaymentId CHAR(5) FOREIGN KEY REFERENCES Payment(PaymentId)
)

go
CREATE TRIGGER Trig1 on Rent for insert
as
begin
update Gown set
GownStock = GownStock - RentQuantity
FROM inserted
end 
