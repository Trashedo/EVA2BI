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
        SUM(study_hours * current_gpa) - COUNT(*) * AVG(study_hours) * AVG(current_gpa) AS sum_x1y,
        SUM(class_attendance * current_gpa) - COUNT(*) * AVG(class_attendance) * AVG(current_gpa) AS sum_x2y,
        SUM(previous_gpa * current_gpa) - COUNT(*) * AVG(previous_gpa) * AVG(current_gpa) AS sum_x3y,
        SUM(social_activities * current_gpa) - COUNT(*) * AVG(social_activities) * AVG(current_gpa) AS sum_x4y,
        SUM(library_visits * current_gpa) - COUNT(*) * AVG(library_visits) * AVG(current_gpa) AS sum_x5y,
        SUM(CAST(is_scholarship_holder AS FLOAT) * current_gpa) - COUNT(*) * AVG(CAST(is_scholarship_holder AS FLOAT)) * AVG(current_gpa) AS sum_x6y,
        -- Cálculo de sumas de cuadrados
        SUM(study_hours * study_hours) - COUNT(*) * AVG(study_hours) * AVG(study_hours) AS sum_x1x1,
        SUM(class_attendance * class_attendance) - COUNT(*) * AVG(class_attendance) * AVG(class_attendance) AS sum_x2x2,
        SUM(previous_gpa * previous_gpa) - COUNT(*) * AVG(previous_gpa) * AVG(previous_gpa) AS sum_x3x3,
        SUM(social_activities * social_activities) - COUNT(*) * AVG(social_activities) * AVG(social_activities) AS sum_x4x4,
        SUM(library_visits * library_visits) - COUNT(*) * AVG(library_visits) * AVG(library_visits) AS sum_x5x5,
        SUM(CAST(is_scholarship_holder AS FLOAT) * CAST(is_scholarship_holder AS FLOAT)) - COUNT(*) * AVG(CAST(is_scholarship_holder AS FLOAT)) * AVG(CAST(is_scholarship_holder AS FLOAT)) AS sum_x6x6
    FROM student_performance
),
calculo AS (
    SELECT 
        (sum_x1y / NULLIF(sum_x1x1, 0)) AS beta1,
        (sum_x2y / NULLIF(sum_x2x2, 0)) AS beta2,
        (sum_x3y / NULLIF(sum_x3x3, 0)) AS beta3,
        (sum_x4y / NULLIF(sum_x4x4, 0)) AS beta4,
        (sum_x5y / NULLIF(sum_x5x5, 0)) AS beta5,
        (sum_x6y / NULLIF(sum_x6x6, 0)) AS beta6,
        avg_current_gpa - 





        ((sum_x1y / NULLIF(sum_x1x1, 0)) * avg_study_hours) - 
        ((sum_x2y / NULLIF(sum_x2x2, 0)) * avg_class_attendance) - 
        ((sum_x3y / NULLIF(sum_x3x3, 0)) * avg_previous_gpa) - 
        ((sum_x4y / NULLIF(sum_x4x4, 0)) * avg_social_activities) - 
        ((sum_x5y / NULLIF(sum_x5x5, 0)) * avg_library_visits) - 
        ((sum_x6y / NULLIF(sum_x6x6, 0)) * avg_is_scholarship_holder) AS beta0
    FROM estimado
)
SELECT 
    beta0 + 
    beta1 * study_hours + 
    beta2 * class_attendance + 
    beta3 * previous_gpa + 
    beta4 * social_activities + 
    beta5 * library_visits + 
    beta6 * CAST(is_scholarship_holder AS FLOAT) AS predicted_gpa
FROM student_performance, calculo;
