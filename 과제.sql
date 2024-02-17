---------------------
-- 과제
create table test_employees
as (select * from employees);

drop table test_employees;

/* 1.
주민등록번호를 입력하면 
다음과 같이 출력되도록 yedam_ju 프로시저를 작성하시오. */
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

/* 2.사원번호를 입력할 경우
삭제하는 TEST_PRO 프로시저를 생성하시오.
단, 해당사원이 없는 경우 "해당사원이 없습니다." 출력
(employees 테이블은 foreign key 제약 때문에 삭제 안됨)
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
        DBMS_OUTPUT.PUT_LINE('해당 사원이 없습니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_id || '번의 사원정보가 삭제되었습니다.');
    END IF;
    
END;
/
EXECUTE TEST_PRO(176);

/* 3. 다음과 같이 PL/SQL 블록을 실행할 경우 
사원번호를 입력할 경우 사원의 이름(last_name)의 첫번째 글자를 제외하고는
'*'가 출력되도록 yedam_emp 프로시저를 생성하시오. */
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

/* 4.부서번호를 입력할 경우 
해당부서에 근무하는 사원의 사원번호, 사원이름(last_name)을 출력하는 get_emp 프로시저를 생성하시오. 
(cursor 사용해야 함)
단, 사원이 없을 경우 "해당 부서에는 사원이 없습니다."라고 출력(exception 사용) */

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
        DBMS_OUTPUT.PUT('사원번호 : ' || dep_record.employee_id);
        DBMS_OUTPUT.PUT_LINE(', 사원이름 : ' || dep_record.last_name);
    END LOOP;
    
    IF dep_cursor%ROWCOUNT = 0 THEN
        RAISE e_invalid_department;
    END IF;
    CLOSE dep_cursor;
    
EXCEPTION
    WHEN e_invalid_department THEN
    DBMS_OUTPUT.PUT_LINE('해당 부서에는 사원이 없습니다.');

END;
/
EXECUTE get_emp(30);

/* 5. 직원들의 사번, 급여 증가치만 입력하면 Employees테이블에 쉽게 사원의 급여를 갱신할 수 있는 y_update 프로시저를 작성하세요. 
만약 입력한 사원이 없는 경우에는 ‘No search employee!!’라는 메시지를 출력하세요.(예외처리) */
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
        DBMS_OUTPUT.PUT_LINE(v_employee_id || '번의 사원급여가 수정되었습니다.');
    END IF;
    
EXCEPTION

WHEN e_no_employee THEN
    DBMS_OUTPUT.PUT_LINE('No search employee!!');
WHEN e_under_increase THEN
    DBMS_OUTPUT.PUT_LINE('증가값이 0보다 작습니다.');
    
END;
/

EXECUTE y_update(200, 10);
-----------------------------------------------------------------