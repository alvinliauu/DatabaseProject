USE Hermosa

-- A. Proses Transaksi (Staff membeli melalui Supplier)
-- Jika staff/supplier belum mendaftarkan diri , silahkan mendaftarkan diri terlebih dahulu
Insert Into MsStaff
Values('ST011','Aming liau','Male',5000000,'Aming55@gmail.com','+6281303849574','JL. salam 1')

Select *
From MsStaff

INSERT INTO Supplier
VALUES('VD011','Mahendra Miang','+6282575849308','Mahe@gmail.com','JL. Kenanga')

Select *
From Supplier

-- lalu masuk ke menu payment untuk melakukan pembayaran dan memilih metode pembayarannya
INSERT INTO Payment
VALUES('PY026','OVO',30000000)

Select * 
From Payment

-- B. Supplier ingin menambahkan Gaun jenis baru
-- Jika supplier ingin menambahkan gaun jenis baru maka harus mengisi table GownType
Insert Into GownType
Values('GT011','Kebaya','Asli indonesia')

Select *
From GownType

-- Setelah itu masukan stock dan harga gaun tersebut pada tabel Gown
INSERT INTO Gown
VALUES('GW011','GT011','Silver',1500000,200)

Select *
From Gown

-- lalu masukan data pembayaran gaun tersebut pada tabel TransactionHeader
INSERT INTO TransactionHeader
VALUES('PD026','ST011','VD011','GW011','12-15-19',2,'PY026')

-- Setelah selesai maka table akan mengupdate stock secara otomatis

-- C. Member ingin sewa gaun
-- Jika member belum terdaftar maka harus mendaftarkan diri terlebih dahulu
INSERT INTO Member
VALUES('MM011','Angela Miharja','+6289004893754','Female','Angelaa@gmail.com')

Select *
From Member

-- Setelah itu pilih gown apa saja yang ingin di sewa dan data lain-lain pada tabel Rent
INSERT INTO Rent
VALUES('RE026','ST011','MM011','GW011','12-10-19','12-15-2019','Kebaya',2)

Select *
From Rent

-- Setelah selesai stock akan otomatis terupdate
