---------------------
-- ����
create table test_employees
as (select * from employees);

drop table test_employees;

/* 1.
�ֹε�Ϲ�ȣ�� �Է��ϸ� 
������ ���� ��µǵ��� yedam_ju ���ν����� �ۼ��Ͻÿ�. */
DROP PROCEDURE yedam_ju;

CREATE PROCEDURE yedam_ju
(
    v_ju IN VARCHAR2
)
IS
    v_newju VARCHAR2(100) := '';
BEGIN
    v_newju := SUBSTR(v_ju,1,6) || '-' || RPAD(SUBSTR(v_ju,7,1),7,'*');
    DBMS_OUTPUT.PUT_LINE(v_newju);
END;
/

EXECUTE yedam_ju(9501011667777);

/* 2.�����ȣ�� �Է��� ���
�����ϴ� TEST_PRO ���ν����� �����Ͻÿ�.
��, �ش����� ���� ��� "�ش����� �����ϴ�." ���
(employees ���̺��� foreign key ���� ������ ���� �ȵ�)
*/

DROP PROCEDURE TEST_PRO;
CREATE PROCEDURE TEST_PRO
(
    v_id IN NUMBER
)
IS

BEGIN
    DELETE FROM test_employees
    WHERE employee_id = v_id;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�ش� ����� �����ϴ�.');
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_id || '���� ��������� �����Ǿ����ϴ�.');
    END IF;
    
END;
/
EXECUTE TEST_PRO(176);

/* 3. ������ ���� PL/SQL ����� ������ ��� 
�����ȣ�� �Է��� ��� ����� �̸�(last_name)�� ù��° ���ڸ� �����ϰ��
'*'�� ��µǵ��� yedam_emp ���ν����� �����Ͻÿ�. */
DROP PROCEDURE yedam_emp;
CREATE PROCEDURE yedam_emp
(
    v_id IN VARCHAR2
)
IS
    v_last_name VARCHAR2(100) := '';
BEGIN
    SELECT last_name 
    INTO v_last_name
    FROM test_employees
    WHERE employee_id = v_id;
    
    v_last_name := RPAD(SUBSTR(v_last_name,1,1),LENGTH(v_last_name),'*');
    DBMS_OUTPUT.PUT_LINE(v_last_name);
END;
/

EXECUTE yedam_emp(176);

/* 4.�μ���ȣ�� �Է��� ��� 
�ش�μ��� �ٹ��ϴ� ����� �����ȣ, ����̸�(last_name)�� ����ϴ� get_emp ���ν����� �����Ͻÿ�. 
(cursor ����ؾ� ��)
��, ����� ���� ��� "�ش� �μ����� ����� �����ϴ�."��� ���(exception ���) */

CREATE PROCEDURE get_emp
(
    v_department_id IN VARCHAR2
)
IS
    CURSOR dep_cursor IS
        SELECT e.employee_id, e.last_name
        FROM departments d JOIN employees e
        ON e.department_id = d.department_id
        where d.department_id = v_department_id;
    
    dep_record dep_cursor%ROWTYPE;
    e_invalid_department EXCEPTION;
BEGIN
    OPEN dep_cursor;
    LOOP
        FETCH dep_cursor INTO dep_record;
        EXIT WHEN dep_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT('�����ȣ : ' || dep_record.employee_id);
        DBMS_OUTPUT.PUT_LINE(', ����̸� : ' || dep_record.last_name);
    END LOOP;
    
    IF dep_cursor%ROWCOUNT = 0 THEN
        RAISE e_invalid_department;
    END IF;
    CLOSE dep_cursor;
    
EXCEPTION
    WHEN e_invalid_department THEN
    DBMS_OUTPUT.PUT_LINE('�ش� �μ����� ����� �����ϴ�.');

END;
/
EXECUTE get_emp(30);

/* 5. �������� ���, �޿� ����ġ�� �Է��ϸ� Employees���̺� ���� ����� �޿��� ������ �� �ִ� y_update ���ν����� �ۼ��ϼ���. 
���� �Է��� ����� ���� ��쿡�� ��No search employee!!����� �޽����� ����ϼ���.(����ó��) */
DROP PROCEDURE y_update;

CREATE PROCEDURE y_update
(
    v_employee_id IN NUMBER,
    v_sal_increase IN NUMBER
)
IS
    v_comm NUMBER(5,2) := 0;
    e_no_employee EXCEPTION;
    e_under_increase EXCEPTION;
BEGIN

    IF v_sal_increase < 0 THEN
        RAISE e_under_increase;
    ELSE
        v_comm := v_sal_increase / 100;
    END IF;
    
    UPDATE employees
    SET salary = salary + (salary * v_comm)
    WHERE employee_id = v_employee_id;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_employee;
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_employee_id || '���� ����޿��� �����Ǿ����ϴ�.');
    END IF;
    
EXCEPTION

WHEN e_no_employee THEN
    DBMS_OUTPUT.PUT_LINE('No search employee!!');
WHEN e_under_increase THEN
    DBMS_OUTPUT.PUT_LINE('�������� 0���� �۽��ϴ�.');
    
END;
/

EXECUTE y_update(200, 10);
-----------------------------------------------------------------