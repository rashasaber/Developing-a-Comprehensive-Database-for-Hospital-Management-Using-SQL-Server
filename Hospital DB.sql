create database hospital_DB
use hospital_DB

CREATE TABLE Patients (
    patient_id INT  PRIMARY KEY identity (1,1),
    name VARCHAR(255) NOT NULL,
    gender varchar(50) NOT NULL,
    dob DATE,
    contact_number VARCHAR(15),
    address VARCHAR(255),
    medical_history TEXT
);


CREATE TABLE Doctors (
    doctor_id int PRIMARY KEY identity (1,1),
    name VARCHAR(255) NOT NULL,
    specialization VARCHAR(100),
    contact_number VARCHAR(15),
    email VARCHAR(100)
);

CREATE TABLE Appointments (
    appointment_id int PRIMARY KEY identity (1,1),
    patient_id INT foreign key REFERENCES Patients(patient_id),
    doctor_id INT REFERENCES Doctors(doctor_id),
    appointment_date DATE,
    appointment_time TIME,
    status text
	)

	CREATE TABLE Billing (
    bill_id int PRIMARY KEY identity (1,1),
    patient_id INT foreign key REFERENCES Patients(patient_id),
    doctor_id INT foreign key REFERENCES Doctors(doctor_id),
    bill_date DATE,
    amount DECIMAL(10, 2),
    status varchar(50)
);
-------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Patients (name, gender, dob, contact_number, address, medical_history) 
VALUES 
('John Doe', 'Male', '1985-07-12', '1234567890', '123 Elm St', 'Diabetes, Hypertension'),
('Jane Smith', 'Female', '1990-09-25', '0987654321', '456 Oak St', 'Asthma'),
 ('Michael Scott', 'Male', '1964-03-15', '2223334444', '789 Birch St', 'Hypertension'),
('Pam Beesly', 'Female', '1980-09-25', '9876543210', '456 Cedar St', 'None'),
('Dwight Schrute', 'Male', '1978-01-20', '5556667777', '123 Farm Ln', 'None'),
('Jim Halpert', 'Male', '1979-10-01', '1112223333', '321 Maple St', 'Back Pain');

INSERT INTO Doctors (name, specialization, contact_number, email) 
VALUES 
('Dr. Alice Johnson', 'Cardiologist', '5551234567', 'alice.j@hospital.com'),
('Dr. Robert Brown', 'Dermatologist', '5559876543', 'robert.b@hospital.com'),
('Dr. Meredith Palmer', 'Psychiatrist', '5553334444', 'meredith.p@hospital.com'),
('Dr. Stanley Hudson', 'Endocrinologist', '5557778888', 'stanley.h@hospital.com');

INSERT INTO Appointments (patient_id, doctor_id, appointment_date, appointment_time, status) 
VALUES 
(1, 1, '2024-10-20', '10:00:00', 'Scheduled'),
(2, 2, '2024-10-21', '11:30:00', 'Scheduled'),
(3, 1, '2024-10-22', '09:00:00', 'Completed'),
(4, 3, '2024-10-23', '12:00:00', 'Scheduled'),
(5, 4, '2024-10-24', '14:00:00', 'Cancelled');


INSERT INTO Billing (patient_id, doctor_id, bill_date, amount, status) 
VALUES 
(1, 1, '2024-10-20', 200.00, 'Paid'),
(2, 2, '2024-10-21', 150.00, 'Pending'),
(3, 1, '2024-10-22', 300.00, 'Paid'),
(4, 3, '2024-10-23', 250.00, 'Pending'),
(5, 4, '2024-10-24', 400.00, 'Cancelled');
------------------------------------------------------------------------------------------------------

-----------1.Total Patients------------------------------------------------------
select count(patient_id) as [Total Patients] from Patients

------------2.View Patient with Medical History---------------------------------------------------
select * from Patients where medical_history not like'None'

--------------3.View Scheduled Appointments------------------------------------------------
select * from Appointments where status like 'Scheduled'

------4.View Doctor's Appointments--------------------------------------------------------------------------------
select DOC.name,APP.appointment_date,APP.appointment_time from Doctors as DOC inner join Appointments as APP 
on DOC.doctor_id=APP.doctor_id

--------------5.	View  Unpaid Bills-----------------------------------------------------------------------------------
select patient_billing.name,Doctors.name,patient_billing.bill_date,patient_billing.amount,patient_billing.status from 

(select pa.name,bill.doctor_id,bill.bill_date,bill.amount,bill.status from Patients as pa inner join Billing as bill
on pa.patient_id=bill.patient_id
where bill.status like 'Pending' ) as patient_billing

 inner join Doctors
on patient_billing.doctor_id=Doctors.doctor_id

-----------------------------------------------------------------------------------------------------------------
select * from Patients
select * from Billing
select * from Billing where status like 'Pending'

--------------6.	Get Total Bills for each Patients----------------------------------------------------------------------
SELECT pa.name, sum(bill.amount) as [Total Amount]
FROM Patients AS pa 
INNER JOIN Billing AS bill 
ON pa.patient_id = bill.patient_id 
GROUP BY pa.name;
------------------------------------------------------------------------------------------
--------------7.	View All Patients With each  Doctor-------------------

select * from Patients
select * from Appointments

select patients_appointments.name as [Patient Name] ,Doctors.name as [Doctor Name] from 

(select Patients.name,Appointments.doctor_id from Patients inner join Appointments
on Patients.patient_id=Appointments.patient_id)as patients_appointments

inner join Doctors
on Doctors.doctor_id=patients_appointments.doctor_id

----------------------------8.	View Billing Report for a month of octobar-----------------------------------------
select patient_billing.name,Doctors.name,patient_billing.bill_date,patient_billing.amount,patient_billing.status from 

(select pa.name,bill.doctor_id,bill.bill_date,bill.amount,bill.status from Patients as pa inner join Billing as bill
on pa.patient_id=bill.patient_id ) as patient_billing

 inner join Doctors
on patient_billing.doctor_id=Doctors.doctor_id
where format( patient_billing.bill_date,'MMM')like'Oct'
-------------------------------------------------------------------------------------------------------------------------