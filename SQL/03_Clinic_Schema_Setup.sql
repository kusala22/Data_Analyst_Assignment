-- ============================================================
--  03_Clinic_Schema_Setup.sql
--  Clinic Management System — Table Creation & Sample Data
-- ============================================================

DROP TABLE IF EXISTS clinic_sales;
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS clinics;
DROP TABLE IF EXISTS customer;

-- ------------------------------------------------------------
-- Table: clinics
-- ------------------------------------------------------------
CREATE TABLE clinics (
    cid          VARCHAR(50)  PRIMARY KEY,
    clinic_name  VARCHAR(100) NOT NULL,
    city         VARCHAR(100),
    state        VARCHAR(100),
    country      VARCHAR(100)
);

-- ------------------------------------------------------------
-- Table: customer
-- ------------------------------------------------------------
CREATE TABLE customer (
    uid     VARCHAR(50)  PRIMARY KEY,
    name    VARCHAR(100) NOT NULL,
    mobile  VARCHAR(20)
);

-- ------------------------------------------------------------
-- Table: clinic_sales
-- ------------------------------------------------------------
CREATE TABLE clinic_sales (
    oid           VARCHAR(50)    PRIMARY KEY,
    uid           VARCHAR(50)    NOT NULL,
    cid           VARCHAR(50)    NOT NULL,
    amount        DECIMAL(10, 2) NOT NULL,
    datetime      DATETIME       NOT NULL,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- ------------------------------------------------------------
-- Table: expenses
-- ------------------------------------------------------------
CREATE TABLE expenses (
    eid         VARCHAR(50)    PRIMARY KEY,
    cid         VARCHAR(50)    NOT NULL,
    description VARCHAR(200),
    amount      DECIMAL(10, 2) NOT NULL,
    datetime    DATETIME       NOT NULL,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- ============================================================
--  SAMPLE DATA
-- ============================================================

-- clinics
INSERT INTO clinics VALUES
('cnc-001', 'HealthFirst Clinic',  'Mumbai',    'Maharashtra', 'India'),
('cnc-002', 'CarePoint Clinic',    'Mumbai',    'Maharashtra', 'India'),
('cnc-003', 'WellBeing Clinic',    'Delhi',     'Delhi',       'India'),
('cnc-004', 'MedPlus Clinic',      'Bangalore', 'Karnataka',   'India'),
('cnc-005', 'CityHealth Clinic',   'Bangalore', 'Karnataka',   'India'),
('cnc-006', 'LifeCare Clinic',     'Hyderabad', 'Telangana',   'India');

-- customers
INSERT INTO customer VALUES
('cust-001', 'John Doe',     '9700000001'),
('cust-002', 'Jane Smith',   '9700000002'),
('cust-003', 'Bob Wilson',   '9700000003'),
('cust-004', 'Alice Brown',  '9700000004'),
('cust-005', 'Charlie King', '9700000005'),
('cust-006', 'Diana Prince', '9700000006'),
('cust-007', 'Eve Adams',    '9700000007'),
('cust-008', 'Frank Castle', '9700000008'),
('cust-009', 'Grace Hopper', '9700000009'),
('cust-010', 'Hank Pym',     '9700000010');

-- clinic_sales (year 2021, multiple channels)
INSERT INTO clinic_sales VALUES
('ord-001', 'cust-001', 'cnc-001', 24999, '2021-01-10 10:00:00', 'online'),
('ord-002', 'cust-002', 'cnc-001', 15000, '2021-01-15 11:00:00', 'walk-in'),
('ord-003', 'cust-003', 'cnc-002', 8000,  '2021-02-05 09:30:00', 'online'),
('ord-004', 'cust-004', 'cnc-002', 12000, '2021-02-20 14:00:00', 'referral'),
('ord-005', 'cust-005', 'cnc-003', 30000, '2021-03-08 10:00:00', 'online'),
('ord-006', 'cust-006', 'cnc-003', 5000,  '2021-03-22 16:00:00', 'walk-in'),
('ord-007', 'cust-001', 'cnc-004', 18000, '2021-04-01 09:00:00', 'referral'),
('ord-008', 'cust-002', 'cnc-004', 22000, '2021-04-18 13:00:00', 'online'),
('ord-009', 'cust-003', 'cnc-005', 9500,  '2021-05-10 11:00:00', 'walk-in'),
('ord-010', 'cust-007', 'cnc-005', 7000,  '2021-05-25 15:00:00', 'online'),
('ord-011', 'cust-008', 'cnc-006', 45000, '2021-06-03 10:00:00', 'referral'),
('ord-012', 'cust-009', 'cnc-006', 11000, '2021-06-19 12:00:00', 'online'),
('ord-013', 'cust-010', 'cnc-001', 3200,  '2021-07-07 09:00:00', 'walk-in'),
('ord-014', 'cust-001', 'cnc-002', 16500, '2021-07-21 14:00:00', 'online'),
('ord-015', 'cust-002', 'cnc-003', 27000, '2021-08-05 10:00:00', 'referral'),
('ord-016', 'cust-003', 'cnc-004', 8800,  '2021-08-19 16:00:00', 'walk-in'),
('ord-017', 'cust-004', 'cnc-005', 13000, '2021-09-11 09:30:00', 'online'),
('ord-018', 'cust-005', 'cnc-006', 19500, '2021-09-28 11:00:00', 'referral'),
('ord-019', 'cust-006', 'cnc-001', 6700,  '2021-10-04 13:00:00', 'walk-in'),
('ord-020', 'cust-007', 'cnc-002', 23000, '2021-10-17 10:00:00', 'online'),
('ord-021', 'cust-008', 'cnc-003', 5500,  '2021-11-02 09:00:00', 'referral'),
('ord-022', 'cust-009', 'cnc-004', 31000, '2021-11-16 15:00:00', 'online'),
('ord-023', 'cust-010', 'cnc-005', 14000, '2021-12-08 10:00:00', 'walk-in'),
('ord-024', 'cust-001', 'cnc-006', 28000, '2021-12-22 14:00:00', 'online');

-- expenses
INSERT INTO expenses VALUES
('exp-001', 'cnc-001', 'First-aid supplies',   2000,  '2021-01-05 08:00:00'),
('exp-002', 'cnc-001', 'Staff salary',          30000, '2021-01-31 18:00:00'),
('exp-003', 'cnc-002', 'Equipment maintenance', 5000,  '2021-02-10 09:00:00'),
('exp-004', 'cnc-002', 'Utilities',             3000,  '2021-02-28 18:00:00'),
('exp-005', 'cnc-003', 'Staff salary',          25000, '2021-03-31 18:00:00'),
('exp-006', 'cnc-003', 'Medical supplies',      8000,  '2021-03-15 10:00:00'),
('exp-007', 'cnc-004', 'Rent',                  15000, '2021-04-01 09:00:00'),
('exp-008', 'cnc-004', 'Utilities',             2500,  '2021-04-30 18:00:00'),
('exp-009', 'cnc-005', 'Staff salary',          20000, '2021-05-31 18:00:00'),
('exp-010', 'cnc-005', 'First-aid supplies',    1500,  '2021-05-10 10:00:00'),
('exp-011', 'cnc-006', 'Equipment maintenance', 10000, '2021-06-15 09:00:00'),
('exp-012', 'cnc-006', 'Medical supplies',      6000,  '2021-06-30 18:00:00'),
('exp-013', 'cnc-001', 'Utilities',             2200,  '2021-07-31 18:00:00'),
('exp-014', 'cnc-002', 'Rent',                  12000, '2021-07-01 09:00:00'),
('exp-015', 'cnc-003', 'Staff salary',          25000, '2021-08-31 18:00:00'),
('exp-016', 'cnc-004', 'Medical supplies',      4000,  '2021-08-15 10:00:00'),
('exp-017', 'cnc-005', 'Rent',                  10000, '2021-09-01 09:00:00'),
('exp-018', 'cnc-006', 'Utilities',             3500,  '2021-09-30 18:00:00'),
('exp-019', 'cnc-001', 'First-aid supplies',    1800,  '2021-10-10 10:00:00'),
('exp-020', 'cnc-002', 'Staff salary',          22000, '2021-10-31 18:00:00'),
('exp-021', 'cnc-003', 'Equipment maintenance', 7000,  '2021-11-15 09:00:00'),
('exp-022', 'cnc-004', 'Rent',                  15000, '2021-11-01 09:00:00'),
('exp-023', 'cnc-005', 'Medical supplies',      3000,  '2021-12-10 10:00:00'),
('exp-024', 'cnc-006', 'Staff salary',          28000, '2021-12-31 18:00:00');
