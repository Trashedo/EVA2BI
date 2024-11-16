WITH calculo AS (
    -- Incluye aquí los coeficientes de regresión calculados en el Paso 2
    SELECT 
        2.345 AS beta0,  -- Intercepto (ejemplo)
        0.123 AS beta1,  -- Coeficiente para study_hours
        0.456 AS beta2,  -- Coeficiente para class_attendance
        0.789 AS beta3,  -- Coeficiente para previous_gpa
        -0.234 AS beta4, -- Coeficiente para social_activities
        0.567 AS beta5,  -- Coeficiente para library_visits
        0.890 AS beta6   -- Coeficiente para is_scholarship_holder
)
SELECT 
    student_id,
    ROUND(beta0 + 
          beta1 * study_hours + 
          beta2 * class_attendance + 
          beta3 * previous_gpa + 
          beta4 * social_activities + 
          beta5 * library_visits + 
          beta6 * CAST(is_scholarship_holder AS FLOAT), 3) AS predicted_gpa,
    current_gpa AS actual_gpa
FROM student_performance, calculo;
