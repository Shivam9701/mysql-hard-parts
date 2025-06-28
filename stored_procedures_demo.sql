-- ========================================
-- 🧪 STORED PROCEDURES DEMO
-- ========================================


-- ❗ Ensure a clean start (drop if exists)
DROP PROCEDURE IF EXISTS large_salaries;

-- ✅ Simple Procedure Without BEGIN/END (single query)
CREATE PROCEDURE large_salaries()
SELECT * FROM employee_salary
WHERE salary >= 50000;

-- ▶️ Call the procedure
CALL large_salaries();


-- ========================================
-- 🧪 Procedure with Multiple Queries (BEGIN/END)
-- ========================================

DROP PROCEDURE IF EXISTS large_salaries2;
DELIMITER $$

CREATE PROCEDURE large_salaries2()
BEGIN 
    SELECT * FROM employee_salary
    WHERE salary >= 50000;

    SELECT * FROM employee_salary
    WHERE salary <= 20000;
END $$

DELIMITER ;

-- ▶️ Call the multi-query procedure
CALL large_salaries2();


-- ========================================
-- 🧪 Schema-Qualified Procedure
-- ========================================

-- Make sure you're using the right schema context
USE office_db;

DROP PROCEDURE IF EXISTS MY_PROC;
DELIMITER $$

CREATE PROCEDURE MY_PROC()
BEGIN
    SELECT 1 FROM employee_salary WHERE salary = 70000;
END $$

DELIMITER ;

-- ▶️ Call it
CALL MY_PROC();


-- ========================================
-- 🧪 Procedure with Input Parameter
-- ========================================

DROP PROCEDURE IF EXISTS select_salary;
DELIMITER $$

CREATE PROCEDURE select_salary(IN sal INT)
BEGIN 
    SELECT * FROM employee_salary WHERE salary = sal;
END $$

DELIMITER ;

-- ▶️ Call with a specific salary value
CALL select_salary(70000);
