

	drop table patient
	drop table Hospital
	drop table PatientCase
	drop table doctor

	-----------------------------------------------Table Patient 
	CREATE TABLE Patient(
	id INT NOT NULL PRIMARY KEY IDENTITY(1,1) CHECK(id > 0),
	PatientName varchar(30) NOT NULL,
	Age INT NOT NULL,
	Gender varchar(20),
	bloodType varchar(10),
	InsuranceProvider varchar(30),
	HospitalId INT NOT NULL default 0,
	foreign key (HospitalId) references Hospital(id)
	)


	--------------------------------------------------------Table Hospital 

create Table Hospital(
	id int primary key identity(1,1),
	HospitalName VARCHAR(50) not Null,
	DateOfAddmission DATE DEFAULT GETDATE() ,
	DateOfDischarge DATE  ,
	RoomNum INT NOT Null CHECK(RoomNum > 0),
	billingAmount decimal,
	doctorId INT default 0,
	Foreign key (doctorId) references doctor(id)
	)
	-----------------------------------------------------------Table doctor 
	CREATE TABLE doctor(
	id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	DoctorName VARCHAR(30),
  	)
	---------------------------------------------------------Table PatientCase

	CREATE TABLE PatientCase(
	caseId INT NOT NULL PRIMARY KEY IDENTITY(1,1) CHECK(caseId > 0),
	admissionType VARCHAR(30) ,
	MedicalCondition varchar(30),
	Medication varchar(30) ,
	TestResult varchar(30) ,
	patientId INT default 0,
	foreign key (patientId) references Patient (id)
	)



