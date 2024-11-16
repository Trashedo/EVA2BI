CREATE TABLE student_performance (
    student_id INT IDENTITY(1,1) PRIMARY KEY, -- Identificador único del estudiante
    semester NVARCHAR(50) NOT NULL,           -- Semestre actual
    study_hours FLOAT CHECK (study_hours >= 0), -- Promedio de horas de estudio por semana del estudiante
    class_attendance FLOAT CHECK (class_attendance BETWEEN 0 AND 100), -- Porcentaje de asistencia a clases durante el semestre
    previous_gpa FLOAT CHECK (previous_gpa BETWEEN 0 AND 4), -- Promedio de calificaciones del semestre anterior
    social_activities FLOAT CHECK (social_activities >= 0),  -- Horas semanales promedio dedicadas a actividades extracurriculares y sociales
    library_visits FLOAT CHECK (library_visits >= 0),        -- Número promedio de visitas semanales a la biblioteca
    is_scholarship_holder BIT NOT NULL,                      -- Indicador de si el estudiante cuenta con beca (1) o no (0)
    current_gpa FLOAT CHECK (current_gpa BETWEEN 0 AND 4)    -- Promedio de calificaciones del semestre actual (variable objetivo a predecir)
);



