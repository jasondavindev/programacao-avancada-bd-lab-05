CREATE OR REPLACE PACKAGE pkg_cursors AS
    TYPE type_sal_funcs_rec IS RECORD (
        first_name        VARCHAR2(20),
        last_name         VARCHAR2(25),
        department_name   VARCHAR2(30),
        salary            NUMBER(8, 2)
    );
    TYPE type_sal_funcs_cur IS REF CURSOR RETURN type_sal_funcs_rec;
    PROCEDURE acrs_funcs (
        cur_funcs IN OUT type_sal_funcs_cur
    );

    PROCEDURE pc_emp_sal_cursor;
END pkg_cursors;

CREATE OR REPLACE PACKAGE BODY pkg_cursors AS

    PROCEDURE acrs_funcs (
        cur_funcs IN OUT type_sal_funcs_cur
    ) AS
    BEGIN
        OPEN cur_funcs FOR SELECT
                               e.first_name,
                               e.last_name,
                               d.department_name,
                               e.salary * 1.1
                           FROM
                               employees     e
                               INNER JOIN departments   d ON d.department_id = e.department_id;

    END;

    PROCEDURE pc_emp_sal_cursor IS

        emp_cursor        type_sal_funcs_cur;
        first_name        employees.first_name%TYPE;
        last_name         employees.last_name%TYPE;
        salary            employees.salary%TYPE;
        department_name   departments.department_name%TYPE;
    BEGIN
        acrs_funcs(emp_cursor);
        dbms_output.put_line('First name | Last name | Department | Salary');
        LOOP
            FETCH emp_cursor INTO
                first_name,
                last_name,
                department_name,
                salary;
            EXIT WHEN emp_cursor%notfound;
            dbms_output.put_line(first_name
                                 || ' | '
                                 || last_name
                                 || ' | '
                                 || department_name
                                 || ' | '
                                 || salary);

        END LOOP;

    END;

END pkg_cursors;