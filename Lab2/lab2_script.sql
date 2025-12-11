-- Лабораторна робота №2
-- Студентка: Галактіонова Антоніна
-- Група: КВ-31
-- Варіант: 4 Види індексів: GIN, BRIN Умови для тригера: after delete, insert.

-- 1. Створення таблиці та наповнення даними

DROP TABLE IF EXISTS medical_records;

CREATE TABLE medical_records (
    record_id SERIAL PRIMARY KEY,
    patient_name VARCHAR(100),
    diagnosis VARCHAR(100),
    status VARCHAR(50),
    treatment_cost INT
);

INSERT INTO medical_records (patient_name, diagnosis, status, treatment_cost) 
VALUES 
('Oleh Bondar', 'Flu', 'Active', 500),
('Maria Koval', 'Gastritis', 'Active', 1200),
('Ivan Petrenko', 'Fracture', 'Discharged', 3000);

SELECT * FROM medical_records;


-- 2. Робота з транзакціями

-- Рівень READ COMMITTED
-- Транзакція 1
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT treatment_cost FROM medical_records WHERE patient_name = 'Oleh Bondar';

-- Транзакція 2 (виконується паралельно)
BEGIN;
UPDATE medical_records SET treatment_cost = 750 WHERE patient_name = 'Oleh Bondar';
COMMIT;

-- Продовження Транзакції 1
SELECT treatment_cost FROM medical_records WHERE patient_name = 'Oleh Bondar';
COMMIT;


-- Рівень REPEATABLE READ

-- Повертаємо початкове значення
UPDATE medical_records SET treatment_cost = 500 WHERE patient_name = 'Oleh Bondar';

-- Транзакція 1
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT treatment_cost FROM medical_records WHERE patient_name = 'Oleh Bondar';

-- Транзакція 2
BEGIN;
UPDATE medical_records SET treatment_cost = 1000 WHERE patient_name = 'Oleh Bondar';
COMMIT;

-- Продовження Транзакції 1
SELECT treatment_cost FROM medical_records WHERE patient_name = 'Oleh Bondar';
COMMIT;


-- Рівень SERIALIZABLE

-- Транзакція 1
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT count(*) FROM medical_records WHERE diagnosis = 'Flu';

-- Транзакція 2
BEGIN;
INSERT INTO medical_records (patient_name, diagnosis, status, treatment_cost) 
VALUES ('Anna Boyko', 'Flu', 'Active', 600);
COMMIT;

-- Продовження Транзакції 1
SELECT count(*) FROM medical_records WHERE diagnosis = 'Flu';
COMMIT;