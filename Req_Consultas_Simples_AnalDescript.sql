-- Número máximo, mínimo y promedio de horas de estudio, asistencia a clases, y visitas a la biblioteca
SELECT 
    MAX(study_hours) AS max_study_hours,
    MIN(study_hours) AS min_study_hours,
    AVG(study_hours) AS avg_study_hours,
    MAX(class_attendance) AS max_class_attendance,
    MIN(class_attendance) AS min_class_attendance,
    AVG(class_attendance) AS avg_class_attendance,
    MAX(library_visits) AS max_library_visits,
    MIN(library_visits) AS min_library_visits,
    AVG(library_visits) AS avg_library_visits
FROM student_performance;

-- Promedio, máximo y mínimo del previous_gpa y current_gpa
SELECT 
    MAX(previous_gpa) AS max_previous_gpa,
    MIN(previous_gpa) AS min_previous_gpa,
    AVG(previous_gpa) AS avg_previous_gpa,
    MAX(current_gpa) AS max_current_gpa,
    MIN(current_gpa) AS min_current_gpa,
    AVG(current_gpa) AS avg_current_gpa
FROM student_performance;

-- Análisis de horas sociales y promedios académicos para estudiantes becados vs no becados
SELECT 
    is_scholarship_holder,
    AVG(social_activities) AS avg_social_activities,
    AVG(current_gpa) AS avg_current_gpa,
    COUNT(*) AS total_students
FROM student_performance
GROUP BY is_scholarship_holder;
