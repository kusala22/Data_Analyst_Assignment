-- ============================================================
--  01_Hotel_Schema_Setup.sql
--  Hotel Management System — Table Creation & Sample Data
-- ============================================================

-- Drop tables if they already exist (safe re-run)
DROP TABLE IF EXISTS booking_commercials;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS users;

-- ------------------------------------------------------------
-- Table: users
-- ------------------------------------------------------------
CREATE TABLE users (
    user_id          VARCHAR(50)  PRIMARY KEY,
    name             VARCHAR(100) NOT NULL,
    phone_number     VARCHAR(20),
    mail_id          VARCHAR(100),
    billing_address  TEXT
);

-- ------------------------------------------------------------
-- Table: items
-- ------------------------------------------------------------
CREATE TABLE items (
    item_id    VARCHAR(50)    PRIMARY KEY,
    item_name  VARCHAR(100)   NOT NULL,
    item_rate  DECIMAL(10, 2) NOT NULL
);

-- ------------------------------------------------------------
-- Table: bookings
-- ------------------------------------------------------------
CREATE TABLE bookings (
    booking_id    VARCHAR(50) PRIMARY KEY,
    booking_date  DATETIME    NOT NULL,
    room_no       VARCHAR(50) NOT NULL,
    user_id       VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ------------------------------------------------------------
-- Table: booking_commercials
-- ------------------------------------------------------------
CREATE TABLE booking_commercials (
    id            VARCHAR(50)    PRIMARY KEY,
    booking_id    VARCHAR(50)    NOT NULL,
    bill_id       VARCHAR(50)    NOT NULL,
    bill_date     DATETIME       NOT NULL,
    item_id       VARCHAR(50)    NOT NULL,
    item_quantity DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id)    REFERENCES items(item_id)
);

-- ============================================================
--  SAMPLE DATA
-- ============================================================

-- users
INSERT INTO users VALUES
('usr-001', 'John Doe',   '9700000001', 'john.doe@example.com',   '12, Street A, Mumbai'),
('usr-002', 'Jane Smith', '9700000002', 'jane.smith@example.com', '34, Street B, Delhi'),
('usr-003', 'Bob Wilson', '9700000003', 'bob.wilson@example.com', '56, Street C, Pune'),
('usr-004', 'Alice Brown','9700000004', 'alice.b@example.com',    '78, Street D, Goa');

-- items
INSERT INTO items VALUES
('itm-001', 'Tawa Paratha', 18.00),
('itm-002', 'Mix Veg',      89.00),
('itm-003', 'Dal Tadka',    75.00),
('itm-004', 'Butter Naan',  30.00),
('itm-005', 'Paneer Tikka', 150.00),
('itm-006', 'Lassi',        45.00);

-- bookings
INSERT INTO bookings VALUES
('bk-001', '2021-09-23 07:36:48', 'rm-101', 'usr-001'),
('bk-002', '2021-10-05 10:15:00', 'rm-102', 'usr-002'),
('bk-003', '2021-10-18 14:22:00', 'rm-103', 'usr-003'),
('bk-004', '2021-11-02 09:00:00', 'rm-104', 'usr-001'),
('bk-005', '2021-11-10 11:30:00', 'rm-105', 'usr-002'),
('bk-006', '2021-11-20 16:45:00', 'rm-101', 'usr-004'),
('bk-007', '2021-12-01 08:00:00', 'rm-102', 'usr-003'),
('bk-008', '2021-12-15 12:00:00', 'rm-103', 'usr-004');

-- booking_commercials
-- Sept booking (bk-001)
INSERT INTO booking_commercials VALUES
('bc-001', 'bk-001', 'bl-001', '2021-09-23 12:03:22', 'itm-001', 3),
('bc-002', 'bk-001', 'bl-001', '2021-09-23 12:03:22', 'itm-002', 1),

-- Oct bookings (bk-002, bk-003) — used for Q3 (bills > 1000 in Oct 2021)
('bc-003', 'bk-002', 'bl-002', '2021-10-05 13:00:00', 'itm-005', 5),   -- 750
('bc-004', 'bk-002', 'bl-002', '2021-10-05 13:00:00', 'itm-006', 8),   -- 360  => total 1110
('bc-005', 'bk-003', 'bl-003', '2021-10-18 15:00:00', 'itm-002', 4),   -- 356
('bc-006', 'bk-003', 'bl-003', '2021-10-18 15:00:00', 'itm-003', 10),  -- 750  => total 1106
('bc-007', 'bk-003', 'bl-004', '2021-10-19 09:00:00', 'itm-004', 5),   -- 150  => total 150 (< 1000)

-- Nov bookings (bk-004, bk-005, bk-006) — used for Q2 & Q4 & Q5
('bc-008', 'bk-004', 'bl-005', '2021-11-02 10:00:00', 'itm-001', 10),  -- 180
('bc-009', 'bk-004', 'bl-005', '2021-11-02 10:00:00', 'itm-005', 3),   -- 450  => total 630
('bc-010', 'bk-005', 'bl-006', '2021-11-10 12:00:00', 'itm-002', 6),   -- 534
('bc-011', 'bk-005', 'bl-006', '2021-11-10 12:00:00', 'itm-003', 5),   -- 375  => total 909
('bc-012', 'bk-006', 'bl-007', '2021-11-20 17:00:00', 'itm-005', 8),   -- 1200
('bc-013', 'bk-006', 'bl-007', '2021-11-20 17:00:00', 'itm-006', 4),   -- 180  => total 1380

-- Dec bookings (bk-007, bk-008)
('bc-014', 'bk-007', 'bl-008', '2021-12-01 09:00:00', 'itm-001', 5),   -- 90
('bc-015', 'bk-007', 'bl-008', '2021-12-01 09:00:00', 'itm-004', 10),  -- 300  => total 390
('bc-016', 'bk-008', 'bl-009', '2021-12-15 13:00:00', 'itm-005', 10),  -- 1500
('bc-017', 'bk-008', 'bl-009', '2021-12-15 13:00:00', 'itm-002', 5);   -- 445  => total 1945
