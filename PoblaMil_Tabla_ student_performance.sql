-- Script para insertar 1000 registros consistentes y coherentes en la tabla student_performance
SET NOCOUNT ON;

DECLARE @i INT = 1;

WHILE @i <= 1000
BEGIN
    DECLARE @semester NVARCHAR(50) = 
        CASE 
            WHEN RAND() < 0.5 THEN 'Fall ' + CAST(YEAR(GETDATE()) - FLOOR(RAND() * 4) AS NVARCHAR)
            ELSE 'Spring ' + CAST(YEAR(GETDATE()) - FLOOR(RAND() * 4) AS NVARCHAR)
        END;
		--Emulación de datos academicos, se usan patrones solo al azar
    DECLARE @study_hours FLOAT = ROUND(10 + (RAND() * 15), 1); -- Entre 10 y 25 horas por semana
    DECLARE @class_attendance FLOAT = ROUND(70 + (RAND() * 30), 1); -- Entre 70% y 100%
    DECLARE @previous_gpa FLOAT = ROUND(2.0 + (RAND() * 2), 2); -- Entre 2.0 y 4.0
    DECLARE @social_activities FLOAT = ROUND(2 + (RAND() * 10), 1); -- Entre 2 y 12 horas semanales
    DECLARE @library_visits FLOAT = ROUND(1 + (RAND() * 5), 1); -- Entre 1 y 6 visitas por semana
    DECLARE @is_scholarship_holder BIT = CASE WHEN RAND() < 0.3 THEN 1 ELSE 0 END; -- 30% tienen beca
    DECLARE @current_gpa FLOAT = ROUND(
        0.4 * @study_hours / 25 +
        0.3 * @class_attendance / 100 +
        0.2 * @previous_gpa +
        0.1 * (6 - @social_activities / 12) +
        (CASE @is_scholarship_holder WHEN 1 THEN 0.2 ELSE -0.1 END),
        2
    );
    
    -- Limitar el GPA entre 0 y 4
    SET @current_gpa = CASE 
        WHEN @current_gpa < 0 THEN 0 
        WHEN @current_gpa > 4 THEN 4 
        ELSE @current_gpa 
    END;

    INSERT INTO student_performance (
        semester, 
        study_hours, 
        class_attendance, 
        previous_gpa, 
        social_activities, 
        library_visits, 
        is_scholarship_holder, 
        current_gpa
    )
    VALUES (
        @semester, 
        @study_hours, 
        @class_attendance, 
        @previous_gpa, 
        @social_activities, 
        @library_visits, 
        @is_scholarship_holder, 
        @current_gpa
    );

    SET @i = @i + 1;
END;

-- Verificar los datos generados
SELECT TOP 10 * FROM student_performance;
