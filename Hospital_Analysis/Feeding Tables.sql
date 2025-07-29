SELECT * FROM healthcare_dataset$


-- doctor ==> feeding 
select * from doctor
INSERT INTO dbo.doctor (
 DoctorName
)
SELECT Distinct	
    TOTAL.Doctor
FROM healthcare_dataset$ TOTAL;


--============================	
-- hospital ==> feeding 
select * from Hospital
INSERT INTO Hospital (
	HospitalName	,
	DateOfAddmission	,
	DateOfDischarge	,
	RoomNum	,
	billingAmount	,
	doctorId
)
SELECT 
    TOTAL.Hospital,
	TOTAL.[Date of Admission],
	TOTAL.[Discharge Date],
	TOTAL.[Room Number],
	[Billing Amount],
	D.id
FROM healthcare_dataset$ TOTAL 
join
doctor D
on TOTAL.Doctor = D.DoctorName;
--============================	
-- patient ==> feeding 
select * from Patient

SELECT * FROM healthcare_dataset$

INSERT INTO Patient(
	PatientName	,
	Age	,
	Gender	,
	bloodType	,
	InsuranceProvider	,
	HospitalId
)
SELECT 
	TOTAL.Name,
	TOTAL.Age,
	TOTAL.Gender,
	TOTAL.[Blood Type],
	TOTAL.[Insurance Provider],
	(
		SELECT TOP 1 id 
		FROM Hospital 
		WHERE HospitalName = TOTAL.Hospital
	) AS HospitalId
FROM healthcare_dataset$ TOTAL 

SELECT * FROM Patient
--============================	
-- patientCAse ==> feeding 
select * from patientCase

SELECT * FROM healthcare_dataset$

INSERT INTO patientCase(
	admissionType	,
	MedicalCondition	,
	Medication	,
	TestResult	,
	patientId
)
SELECT 
	TOTAL.[Admission Type],
	TOTAL.[Medical Condition],
	TOTAL.Medication,
	TOTAL.[Test Results],
	(SELECT 
	top 1 id
	FROM Patient P
	where p.PatientName =TOTAL.Name 
	and p.Age = TOTAL.Age
	)	
FROM healthcare_dataset$ TOTAL 

