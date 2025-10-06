-- USERS
INSERT INTO users (username, password, enabled) VALUES
                                                    ('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J.oDdIo6aJ89pzLfTEJ/jjzNqLCbQq', true),
                                                    ('user',  '$2a$10$N9qo8uLOickgx2ZMRZoMye1J.oDdIo6aJ89pzLfTEJ/jjzNqLCbQq', true),
                                                    ('profesor1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J.oDdIo6aJ89pzLfTEJ/jjzNqLCbQq', true),
                                                    ('estudiante1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J.oDdIo6aJ89pzLfTEJ/jjzNqLCbQq', true)
    ON CONFLICT (username) DO NOTHING;

-- ROLES (tu unique es (user_id, rol))
INSERT INTO roles (user_id, rol)
SELECT u.id, 'ROLE_ADMIN' FROM users u WHERE u.username='admin'
    ON CONFLICT (user_id, rol) DO NOTHING;

INSERT INTO roles (user_id, rol)
SELECT u.id, 'ROLE_USER' FROM users u WHERE u.username='user'
    ON CONFLICT (user_id, rol) DO NOTHING;

-- 1) Un curso nuevo dictado por profesor1
INSERT INTO cursos (nombre_curso, descripcion, creditos, fecha_inicio, fecha_fin, id_profesor)
SELECT 'Introducción a Python',
       'Curso básico de Python para principiantes',
       3, '2025-03-01', '2025-07-01',
       p.id_profesor
FROM profesores p
         JOIN users u ON u.id = p.id_usuario
WHERE u.username = 'profesor1'
  AND NOT EXISTS (
    SELECT 1 FROM cursos c
    WHERE c.nombre_curso = 'Introducción a Python'
      AND c.fecha_inicio = '2025-03-01'
);

-- 2) Una inscripción: estudiante1 se inscribe al curso
INSERT INTO inscripciones (id_estudiante, id_curso, fecha_inscripcion, calificacion, estado)
SELECT e.id_estudiante,
       c.id_curso,
       '2025-02-20', NULL, 'Inscrito'
FROM estudiantes e
         JOIN users ue ON ue.id = e.id_usuario
         JOIN cursos c ON c.nombre_curso = 'Introducción a Python' AND c.fecha_inicio = '2025-03-01'
WHERE ue.username = 'estudiante1'
  AND NOT EXISTS (
    SELECT 1 FROM inscripciones i
    WHERE i.id_estudiante = e.id_estudiante AND i.id_curso = c.id_curso
);

