-- Número máximo, mínimo y promedio de horas de estudio, asistencia a clases, y visitas a la biblioteca
SELECT 
    'Horas de Estudio' AS categoria,
    MAX(study_hours) AS Maximo,
    MIN(study_hours) AS Minimo,
    AVG(study_hours) AS Promedio
FROM student_performance
UNION ALL
SELECT 
    'Asistencia a Clases' AS categoria,
    MAX(class_attendance) AS Maximo,
    MIN(class_attendance) AS Minimo,
    AVG(class_attendance) AS Promedio
FROM student_performance
UNION ALL
SELECT 
    'Visitas a la Biblioteca' AS categoria,
    MAX(library_visits) AS Maximo,
    MIN(library_visits) AS Minimo,
    AVG(library_visits) AS Promedio
FROM student_performance;

-- Promedio, máximo y mínimo del previous_gpa y current_gpa
SELECT 
    'Semestre Anterior' AS Semestre,
    MAX(previous_gpa) AS Maximo,
    MIN(previous_gpa) AS Minimo,
    AVG(previous_gpa) AS Promedio
FROM student_performance
UNION ALL
SELECT 
    'Semestre Actual' AS Semestre,
    MAX(current_gpa) AS Maximo,
    MIN(current_gpa) AS Minimo,
    AVG(current_gpa) AS Promedio
FROM student_performance;


-- Análisis de horas sociales y promedios académicos para estudiantes becados vs no becados
SELECT 
    CASE 
        WHEN is_scholarship_holder = 1 THEN 'Becado'
        ELSE 'No Becado'
    END AS Estado_Beca,
    AVG(social_activities) AS Horas_Actividad_Social,
    AVG(current_gpa) AS Promedio_semestre_actual,
    COUNT(*) AS total_Estudiantes
FROM student_performance
GROUP BY is_scholarship_holder
