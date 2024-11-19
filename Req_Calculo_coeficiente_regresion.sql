WITH estimado AS (
    SELECT 
        COUNT(*) AS n,
        AVG(study_hours) AS avg_study_hours,
        AVG(class_attendance) AS avg_class_attendance,
        AVG(previous_gpa) AS avg_previous_gpa,
        AVG(social_activities) AS avg_social_activities,
        AVG(library_visits) AS avg_library_visits,
        AVG(CAST(is_scholarship_holder AS FLOAT)) AS avg_is_scholarship_holder,
        AVG(current_gpa) AS avg_current_gpa,
        -- Cálculo de sumas cruzadas
        GREATEST(SUM(study_hours * current_gpa) - COUNT(*) * AVG(study_hours) * AVG(current_gpa), 0) AS sum_x1y,
        GREATEST(SUM(class_attendance * current_gpa) - COUNT(*) * AVG(class_attendance) * AVG(current_gpa), 0) AS sum_x2y,
        GREATEST(SUM(previous_gpa * current_gpa) - COUNT(*) * AVG(previous_gpa) * AVG(current_gpa), 0) AS sum_x3y,
        GREATEST(SUM(social_activities * current_gpa) - COUNT(*) * AVG(social_activities) * AVG(current_gpa), 0) AS sum_x4y,
        GREATEST(SUM(library_visits * current_gpa) - COUNT(*) * AVG(library_visits) * AVG(current_gpa), 0) AS sum_x5y,
        GREATEST(SUM(CAST(is_scholarship_holder AS FLOAT) * current_gpa) - COUNT(*) * AVG(CAST(is_scholarship_holder AS FLOAT)) * AVG(current_gpa), 0) AS sum_x6y,
        -- Cálculo de sumas de cuadrados
        GREATEST(SUM(study_hours * study_hours) - COUNT(*) * AVG(study_hours) * AVG(study_hours), 0) AS sum_x1x1,
        GREATEST(SUM(class_attendance * class_attendance) - COUNT(*) * AVG(class_attendance) * AVG(class_attendance), 0) AS sum_x2x2,
        GREATEST(SUM(previous_gpa * previous_gpa) - COUNT(*) * AVG(previous_gpa) * AVG(previous_gpa), 0) AS sum_x3x3,
        GREATEST(SUM(social_activities * social_activities) - COUNT(*) * AVG(social_activities) * AVG(social_activities), 0) AS sum_x4x4,
        GREATEST(SUM(library_visits * library_visits) - COUNT(*) * AVG(library_visits) * AVG(library_visits), 0) AS sum_x5x5,
        GREATEST(SUM(CAST(is_scholarship_holder AS FLOAT) * CAST(is_scholarship_holder AS FLOAT)) - COUNT(*) * AVG(CAST(is_scholarship_holder AS FLOAT)) * AVG(CAST(is_scholarship_holder AS FLOAT)), 0) AS sum_x6x6
    FROM student_performance
),
calculo AS (
    SELECT 
        ROUND(GREATEST(sum_x1y / NULLIF(sum_x1x1, 0), 0), 3) AS beta1,
        ROUND(GREATEST(sum_x2y / NULLIF(sum_x2x2, 0), 0), 3) AS beta2,
        ROUND(GREATEST(sum_x3y / NULLIF(sum_x3x3, 0), 0), 3) AS beta3,
        ROUND(GREATEST(sum_x4y / NULLIF(sum_x4x4, 0), 0), 3) AS beta4,
        ROUND(GREATEST(sum_x5y / NULLIF(sum_x5x5, 0), 0), 3) AS beta5,
        ROUND(GREATEST(sum_x6y / NULLIF(sum_x6x6, 0), 0), 3) AS beta6,
        ROUND(GREATEST(avg_current_gpa - 
              ((sum_x1y / NULLIF(sum_x1x1, 0)) * avg_study_hours) - 
              ((sum_x2y / NULLIF(sum_x2x2, 0)) * avg_class_attendance) - 
              ((sum_x3y / NULLIF(sum_x3x3, 0)) * avg_previous_gpa) - 
              ((sum_x4y / NULLIF(sum_x4x4, 0)) * avg_social_activities) - 
              ((sum_x5y / NULLIF(sum_x5x5, 0)) * avg_library_visits) - 
              ((sum_x6y / NULLIF(sum_x6x6, 0)) * avg_is_scholarship_holder), 0), 3) AS beta0
    FROM estimado
)
SELECT 
    'Intercepto' AS variable,
    beta0 AS valor
FROM calculo
UNION ALL
SELECT 
    'Pendiente_study_hours' AS variable,
    beta1 AS valor
FROM calculo
UNION ALL
SELECT 
    'Pendiente_class_attendance' AS variable,
    beta2 AS valor
FROM calculo
UNION ALL
SELECT 
    'Pendiente_previous_gpa' AS variable,
    beta3 AS valor
FROM calculo
UNION ALL
SELECT 
    'Pendiente_social_activities' AS variable,
    beta4 AS valor
FROM calculo
UNION ALL
SELECT 
    'Pendiente_library_visits' AS variable,
    beta5 AS valor
FROM calculo
UNION ALL
SELECT 
    'Pendiente_is_scholarship_holder' AS variable,
    beta6 AS valor
FROM calculo;
