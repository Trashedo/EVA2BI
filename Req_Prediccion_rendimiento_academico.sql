WITH estimado AS (
    SELECT 
        COUNT(*) AS n,
        ROUND(AVG(study_hours), 1) AS avg_study_hours,
        ROUND(AVG(class_attendance), 1) AS avg_class_attendance,
        ROUND(AVG(previous_gpa), 1) AS avg_previous_gpa,
        ROUND(AVG(social_activities), 1) AS avg_social_activities,
        ROUND(AVG(library_visits), 1) AS avg_library_visits,
        ROUND(AVG(CAST(is_scholarship_holder AS FLOAT)), 1) AS avg_is_scholarship_holder,
        ROUND(AVG(current_gpa), 1) AS avg_current_gpa,
        -- Cálculo de sumas cruzadas con redondeo
        ROUND(SUM(study_hours * current_gpa) - COUNT(*) * AVG(study_hours) * AVG(current_gpa), 1) AS sum_x1y,
        ROUND(SUM(class_attendance * current_gpa) - COUNT(*) * AVG(class_attendance) * AVG(current_gpa), 1) AS sum_x2y,
        ROUND(SUM(previous_gpa * current_gpa) - COUNT(*) * AVG(previous_gpa) * AVG(current_gpa), 1) AS sum_x3y,
        ROUND(SUM(social_activities * current_gpa) - COUNT(*) * AVG(social_activities) * AVG(current_gpa), 1) AS sum_x4y,
        ROUND(SUM(library_visits * current_gpa) - COUNT(*) * AVG(library_visits) * AVG(current_gpa), 1) AS sum_x5y,
        ROUND(SUM(CAST(is_scholarship_holder AS FLOAT) * current_gpa) - COUNT(*) * AVG(CAST(is_scholarship_holder AS FLOAT)) * AVG(current_gpa), 1) AS sum_x6y,
        -- Cálculo de sumas de cuadrados con redondeo
        ROUND(SUM(study_hours * study_hours) - COUNT(*) * AVG(study_hours) * AVG(study_hours), 1) AS sum_x1x1,
        ROUND(SUM(class_attendance * class_attendance) - COUNT(*) * AVG(class_attendance) * AVG(class_attendance), 1) AS sum_x2x2,
        ROUND(SUM(previous_gpa * previous_gpa) - COUNT(*) * AVG(previous_gpa) * AVG(previous_gpa), 1) AS sum_x3x3,
        ROUND(SUM(social_activities * social_activities) - COUNT(*) * AVG(social_activities) * AVG(social_activities), 1) AS sum_x4x4,
        ROUND(SUM(library_visits * library_visits) - COUNT(*) * AVG(library_visits) * AVG(library_visits), 1) AS sum_x5x5,
        ROUND(SUM(CAST(is_scholarship_holder AS FLOAT) * CAST(is_scholarship_holder AS FLOAT)) - COUNT(*) * AVG(CAST(is_scholarship_holder AS FLOAT)) * AVG(CAST(is_scholarship_holder AS FLOAT)), 1) AS sum_x6x6
    FROM student_performance
),
calculo AS (
    SELECT 
        ROUND(sum_x1y / NULLIF(sum_x1x1, 0), 1) AS beta1,
        ROUND(sum_x2y / NULLIF(sum_x2x2, 0), 1) AS beta2,
        ROUND(sum_x3y / NULLIF(sum_x3x3, 0), 1) AS beta3,
        ROUND(sum_x4y / NULLIF(sum_x4x4, 0), 1) AS beta4,
        ROUND(sum_x5y / NULLIF(sum_x5x5, 0), 1) AS beta5,
        ROUND(sum_x6y / NULLIF(sum_x6x6, 0), 1) AS beta6,
        ROUND(avg_current_gpa - 
              ((sum_x1y / NULLIF(sum_x1x1, 0)) * avg_study_hours) - 
              ((sum_x2y / NULLIF(sum_x2x2, 0)) * avg_class_attendance) - 
              ((sum_x3y / NULLIF(sum_x3x3, 0)) * avg_previous_gpa) - 
              ((sum_x4y / NULLIF(sum_x4x4, 0)) * avg_social_activities) - 
              ((sum_x5y / NULLIF(sum_x5x5, 0)) * avg_library_visits) - 
              ((sum_x6y / NULLIF(sum_x6x6, 0)) * avg_is_scholarship_holder), 1) AS beta0
    FROM estimado
)
SELECT 
    student_id,
    ROUND(beta0 + 
          beta1 * study_hours + 
          beta2 * class_attendance + 
          beta3 * previous_gpa + 
          beta4 * social_activities + 
          beta5 * library_visits + 
          beta6 * CAST(is_scholarship_holder AS FLOAT), 1) AS predicted_gpa,
    ROUND(current_gpa, 1) AS actual_gpa
FROM student_performance, calculo;
