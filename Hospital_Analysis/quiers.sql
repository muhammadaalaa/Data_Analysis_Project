
--4.	List all distinct hospital names.

SELECT DISTINCT H.HospitalName
FROM Hospital H

SELECT *
FROM Patient
ORDER BY Age DESC


--6.Calculate the average billing amount for all admissions.


SELECT 	pc.admissionType ,AVG(H.billingAmount) as 'Avaerage Billing amount'
FROM Patient p
JOIN Hospital H ON p.HospitalId = H.id
JOIN PatientCase PC ON pc.patientId= p.id
group by pc.admissionType
	

--7.	Display patients admitted through 'Emergency'.


SELECT	* 
FROM Patient P
JOIN 
PatientCase PC ON pc.patientId= p.id
WHERE PC.admissionType = 'Emergency' 


--8.Count the number of cases handled by each doctor.
SELECT	D.DoctorName , COUNT(P.PatientName) AS 'PATIENT NUMBER'
FROM Patient P
JOIN PatientCase PC ON pc.patientId= p.id
JOIN Hospital H ON p.HospitalId = H.id
JOIN doctor D ON h.doctorId= D.id
GROUP BY D.DoctorName

--9.Show the doctor name and the hospital they work in
SELECT	D.DoctorName , H.HospitalName
FROM Hospital h
JOIN doctor D ON h.doctorId= D.id

--10.	List patients whose test results are 'Abnormal'.

SELECT	*
FROM Patient p
JOIN PatientCase pc ON p.id= pc.caseId
WHERE pc.TestResult ='abnormal'

--11.	Display all patients treated in a hospital named 'Cairo Hospital' using JOIN.
SELECT * 
FROM Patient p
JOIN Hospital H ON H.id= P.HospitalId
WHERE H.HospitalName = 'Brown Inc'


--12.	Calculate the total billing amount per hospital.
SELECT  HospitalName, SUM(billingAmount) AS 'TOTAL BILLING'
FROM Hospital
GROUP BY HospitalName


--13.	List the patients who stayed more than 5 days in the hospital.
SELECT  *
FROM Patient P
JOIN Hospital H
ON P.HospitalId = H.id
WHERE (
DATEDIFF(DAY,DAY(H.DateOfAddmission),DAY(H.DateOfDischarge)) > 5
)
--14.	Show all medications used per admission using JOIN.
SELECT Medication ,admissionType
FROM PatientCase 
FOR JSON AUTO;
--15.	Count the number of patients per medical condition.

SELECT PC.MedicalCondition , COUNT(P.PatientName) AS 'NUM OF ALL PATIENT'
FROM Patient p
JOIN PatientCase pc
ON p.id =PC.patientId
GROUP BY PC.MedicalCondition
 
 --16.	Show each doctor and how many patients they treated.

 SELECT D.DoctorName , COUNT(P.PatientName) 
FROM Patient P
JOIN PatientCase PC ON pc.patientId= p.id
JOIN Hospital H ON p.HospitalId = H.id
JOIN doctor D ON h.doctorId= D.id
GROUP BY D.DoctorName

--17.	List each hospital and the number of doctors working there.

SELECT H.HospitalName ,COUNT(D.DoctorName) AS 'NUM OF DOCS'
FROM Hospital h
JOIN
doctor d 
ON H.id = d.id
GROUP BY H.HospitalName

--18.	Display patients discharged before '2024-01-01'

SELECT *
FROM Patient p
JOIN Hospital h
ON
	H.id= P.HospitalId 
WHERE
H.DateOfDischarge = '2023-01-01'


--19.Show patients with billing amounts above the average (usesubquery)
SELECT p.PatientName, H.billingAmount
FROM Hospital H
JOIN Patient P ON P.HospitalId = H.id
WHERE H.billingAmount > (
    SELECT AVG(TotalBilling)
    FROM (
        SELECT SUM(billingAmount) AS TotalBilling
        FROM Hospital
        GROUP BY id
    ) AS HospitalTotals
);
--20.	List patients who were given the medication 'Aspirin'.
select * 
from Patient P join PatientCase PC on PC.patientId =  p.id
where pc.Medication = 'Aspirin'

--21.	Show each patient's name, their doctor’s name, and hospital name. If the medical condition is NULL, show 'No Diagnosis' (use COALESCE with JOINs across patients, doctors, and hospitals).

 SELECT p.PatientName, D.DoctorName ,H.HospitalName, Medication
 FROM Patient P
JOIN PatientCase PC ON pc.patientId= p.id
JOIN Hospital H ON p.HospitalId = H.id
JOIN doctor D ON h.doctorId= D.id



--22.	List patients who were admitted more than once, showing their name and number of admissions (use GROUP BY and HAVING COUNT(*) > 1).

 SELECT p.PatientName, COUNT(H.DateOfAddmission)  AS 'NUM OF Admission'
 FROM Patient P
JOIN PatientCase PC ON pc.patientId= p.id
JOIN Hospital H ON p.HospitalId = H.id
JOIN doctor D ON h.doctorId= D.id
GROUP BY p.PatientName
HAVING  COUNT(H.DateOfAddmission)>1


--23.	Count the number of patients per admission_type, only showing those with more than 3 and where admission_type is not NULL.
SELECT COUNT(PatientName) ,admissionType
FROM Patient P
JOIN PatientCase PC ON pc.patientId= p.id
JOIN Hospital H ON p.HospitalId = H.id
JOIN doctor D ON h.doctorId= D.id
GROUP BY admissionType
HAVING  COUNT(PatientName)>3


---2424.	List patients with more than one distinct medical condition using JOINs across patients, admissions, and medical conditions.
SELECT count(distinct MedicalCondition ),p.PatientName
FROM Patient P
JOIN PatientCase PC ON pc.patientId= p.id
JOIN Hospital H ON p.HospitalId = H.id
JOIN doctor D ON h.doctorId= D.id
group by p.PatientName
having count(MedicalCondition) >1



---2424.	List patients with more than one distinct medical condition using JOINs across patients, admissions, and medical conditions.


--25.	Show hospitals where the total billing is more than 50,000 EGP and display the total billing amount (use GROUP BY + SUM).
SELECT p.PatientName, billingAmount ,h.HospitalName
FROM Patient P
JOIN Hospital H ON p.HospitalId = H.id
where (billingAmount >40000)


--26.	Using a CTE, show patients over age 40 who were admitted as 'Urgent', along with their doctor and hospital name.
WITH AgeTable AS (
    SELECT 
        p.PatientName,
        p.Age,
        pc.AdmissionType,
        pc.Medication,
        h.HospitalName,
        h.BillingAmount
    FROM Patient p 
    JOIN PatientCase pc ON p.id = pc.patientId
    JOIN Hospital h ON p.HospitalId = h.id
    WHERE p.Age = 40 AND pc.AdmissionType = 'Urgent'
)
SELECT *
FROM AgeTable;



SELECT * FROM PatientCase
SELECT * FROM Hospital
SELECT * FROM doctor

SELECT * FROM Patient


----27.	Use a subquery 
----to find all patients treated by the same doctor who treated a patient named 'mary tran'.


select *
from Patient P
   JOIN PatientCase pc ON p.id = pc.patientId
   JOIN Hospital h ON p.HospitalId = h.id
   
   JOIN doctor D ON h.doctorId= d.id
where d.DoctorName = (
select top 1 d.DoctorName
from doctor
where 
d.id = h.doctorId and
h.id = p.HospitalId and
p.PatientName = 'Megan Alexander'
)



--28.	Show all admissions at 'Alex Medical Center'
--with the medication names and quantities using joins across admissions, hospitals, and medications.

SELECT 
    pc.Medication,
    COUNT(*) AS Quantity
FROM Patient p
JOIN PatientCase pc ON pc.patientId = p.id
JOIN Hospital h ON p.HospitalId = h.id
WHERE h.HospitalName = 'Smith, Edwards and Obrien'
GROUP BY pc.Medication;



select InsuranceProvider,Count(admissionType)
 FROM Patient p
JOIN PatientCase pc ON pc.patientId = p.id
JOIN Hospital h ON p.HospitalId = h.id
group by InsuranceProvider


SELECT 
    p.PatientName,
    pc.admissionType,
    h.DateOfDischarge,
    DATEDIFF(DAY, h.DateOfAddmission, h.DateOfDischarge) AS StayDuration
FROM Patient p
JOIN PatientCase pc ON p.id = pc.patientId
JOIN Hospital h ON p.HospitalId = h.id
WHERE DATEDIFF(DAY, h.DateOfAddmission, h.DateOfDischarge) >= 10;
SELECT 
    p.PatientName,
    p.Age,
    h.RoomNum,
    d.DoctorName,
    CASE 
        WHEN p.Age > 50 THEN 'Senior'
        ELSE 'Adult'
    END AS AgeGroup
FROM Patient p
JOIN PatientCase pc ON p.id = pc.patientId
JOIN Hospital h ON p.HospitalId = h.id
JOIN Doctor d ON h.doctorId = d.id
WHERE h.RoomNum BETWEEN 100 AND 200
  AND d.DoctorName = 'Dr. Mona';
