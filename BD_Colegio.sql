CREATE TABLE Alumno (
    idAlumno SERIAL PRIMARY KEY,
    dni VARCHAR(8) NOT NULL UNIQUE,
    nombres VARCHAR(255) NOT NULL,
    apellidos VARCHAR(255) NOT NULL,
    telefono CHAR(9) NOT NULL,
    email VARCHAR(255),
    sexo VARCHAR(20) NOT NULL,
    fechaNac DATE NOT NULL,
    fechaIngreso DATE NOT NULL,
    idDistrito INT NOT NULL
);

CREATE TABLE Matricula (
    idMatricula SERIAL PRIMARY KEY,
    modalidad VARCHAR(50) NOT NULL,
    fechaMatricula DATE NOT NULL,
    estado VARCHAR(15) NOT NULL,
    idAlumno INT NOT NULL
);

CREATE TABLE Departamento (
    idDepartamento SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);

CREATE TABLE Provincia (
    idProvincia SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    idDepartamento INT NOT NULL
);

CREATE TABLE Distrito (
    idDistrito SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    codigo_postal VARCHAR(10) NOT NULL,
    idProvincia INT NOT NULL
);

CREATE TABLE Grado (
    idGrado SERIAL PRIMARY KEY,
    nivel VARCHAR(255) NOT NULL,
    descripcion TEXT NOT NULL,
    edad_minima INT NOT NULL,
    edad_maxima INT NOT NULL
);

CREATE TABLE Ano_academico (
    idAnoaca SERIAL PRIMARY KEY,
    ano VARCHAR(10) NOT NULL,
    fechaInicio DATE NOT NULL,
    fechaFinal DATE NOT NULL
);

CREATE TABLE Cursos (
    idCursos SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    area VARCHAR(255) NOT NULL,
    horasTeoricas INT NOT NULL,
    horasPracticas INT NOT NULL,
    idGrado INT NOT NULL
);

CREATE TABLE Docente (
    idDocente SERIAL PRIMARY KEY,
    dni VARCHAR(8) NOT NULL UNIQUE,
    nombres VARCHAR(255) NOT NULL,
    apellidos VARCHAR(255) NOT NULL,
    telefono VARCHAR(9) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    sexo VARCHAR(20) NOT NULL,
    fechaNac DATE NOT NULL,
    gradoInst VARCHAR(255) NOT NULL
);

CREATE TABLE Seccion (
    idSeccion INT NOT NULL,
    idAnoaca INT NOT NULL,
    idGrado INT NOT NULL,
    nombreSeccion VARCHAR(20) NOT NULL,
    capacidad INT NOT NULL,
    aula VARCHAR(20) NOT NULL,
    PRIMARY KEY (idSeccion, idAnoaca, idGrado)
);

CREATE TABLE Cursos_Docente (
    idCursos INT NOT NULL,
    idDocente INT NOT NULL,
    idSeccion INT NOT NULL,
    idAnoaca INT NOT NULL,
    idGrado INT NOT NULL,
    rol VARCHAR(20) NOT NULL,
    horasAsignadas INT NOT NULL,
    estado VARCHAR(15) NOT NULL,
    PRIMARY KEY (idCursos, idDocente)
);

CREATE TABLE Detalle_Matricula (
    idDetalle_Matricula INT NOT NULL,
    idMatricula INT NOT NULL,
    idCursos INT NOT NULL,
    idDocente INT NOT NULL,
    idSeccion INT NOT NULL,
    idAnoaca INT NOT NULL,
    idGrado INT NOT NULL,
    promFinal NUMERIC(10, 2) NOT NULL,
    condicion VARCHAR(25) NOT NULL,
    fechaInicio DATE NOT NULL,
    fechaFinal DATE NOT NULL,
    PRIMARY KEY (
        idDetalle_Matricula,
        idMatricula,
        idCursos,
        idDocente,
        idSeccion,
        idAnoaca,
        idGrado
    )
);

ALTER TABLE Provincia
    ADD CONSTRAINT FK_Provincia_Departamento
    FOREIGN KEY (idDepartamento) REFERENCES Departamento (idDepartamento);

ALTER TABLE Distrito
    ADD CONSTRAINT FK_Distrito_Provincia
    FOREIGN KEY (idProvincia) REFERENCES Provincia (idProvincia);

ALTER TABLE Alumno
    ADD CONSTRAINT FK_Alumno_Distrito
    FOREIGN KEY (idDistrito) REFERENCES Distrito (idDistrito);

ALTER TABLE Matricula
    ADD CONSTRAINT FK_Matricula_Alumno
    FOREIGN KEY (idAlumno) REFERENCES Alumno (idAlumno);

ALTER TABLE Seccion
    ADD CONSTRAINT FK_Seccion_Ano_academico
    FOREIGN KEY (idAnoaca) REFERENCES Ano_academico (idAnoaca);

ALTER TABLE Seccion
    ADD CONSTRAINT FK_Seccion_Grado
    FOREIGN KEY (idGrado) REFERENCES Grado (idGrado);

ALTER TABLE Cursos
    ADD CONSTRAINT FK_Cursos_Grado
    FOREIGN KEY (idGrado) REFERENCES Grado (idGrado);

ALTER TABLE Cursos_Docente
    ADD CONSTRAINT FK_Cursos_Docente_Cursos
    FOREIGN KEY (idCursos) REFERENCES Cursos (idCursos);

ALTER TABLE Cursos_Docente
    ADD CONSTRAINT FK_Cursos_Docente_Docente
    FOREIGN KEY (idDocente) REFERENCES Docente (idDocente);

ALTER TABLE Cursos_Docente
    ADD CONSTRAINT FK_Cursos_Docente_Seccion
    FOREIGN KEY (idSeccion, idAnoaca, idGrado) REFERENCES Seccion (idSeccion, idAnoaca, idGrado);

ALTER TABLE Detalle_Matricula
    ADD CONSTRAINT FK_Detalle_Matricula_Matricula
    FOREIGN KEY (idMatricula) REFERENCES Matricula (idMatricula);

ALTER TABLE Detalle_Matricula
    ADD CONSTRAINT FK_Detalle_Matricula_Cursos_Docente
    FOREIGN KEY (idCursos, idDocente) REFERENCES Cursos_Docente (idCursos, idDocente);

INSERT INTO Departamento (nombre) VALUES 
('Arequipa'), ('Piura'), ('La Libertad'), ('Ancash'), ('Ica'), ('Junín'), 
('Huancavelica'), ('Lambayeque'), ('Tacna'), ('Puno'), 
('Moquegua'), ('Tumbes'), ('Cajamarca'), ('Amazonas'), ('Ucayali'), 
('Madre de Dios'), ('Pasco'), ('Ayacucho'), ('Apurímac'), ('Huánuco');

INSERT INTO Provincia (nombre, idDepartamento) VALUES 
('Arequipa', 3), ('Piura', 4), ('Trujillo', 5), ('Huaraz', 6), ('Ica', 7), ('Huancayo', 8), ('Lambayeque', 9), ('Tacna', 10), ('Puno', 11), 
('Moquegua', 12), ('Tumbes', 13), ('Cajamarca', 14), ('Chachapoyas', 15), ('Pucallpa', 16), ('Puerto Maldonado', 17), ('Cerro de Pasco', 18), 
('Ayacucho', 19), ('Andahuaylas', 20), ('Huánuco', 20), ('Tarma', 8);

INSERT INTO Distrito (nombre, codigo_postal, idProvincia) VALUES 
('Cercado', '04001', 3), ('Piura', '20001', 4), ('Víctor Larco', '13009', 5), ('Independencia', '02001', 6), ('Chincha Alta', '11701', 7), 
('Huancayo', '12001', 8), ('Lambayeque', '14013', 9), ('Tacna', '23001', 10), ('Juliaca', '21001', 11), ('Moquegua', '18001', 12), 
('Tumbes', '24001', 13), ('Jaén', '06011', 14), ('Bagua', '01001', 15), ('Callería', '25001', 16), ('Tambopata', '17001', 17), 
('Yanacancha', '19001', 18), ('Huamanga', '05001', 19), ('Abancay', '03001', 20), ('Amarilis', '10001', 20), ('Acolla', '12001', 20);

INSERT INTO Alumno (dni, nombres, apellidos, telefono, email, sexo, fechaNac, fechaIngreso, idDistrito) VALUES
('12345679', 'Luis', 'Pérez', '987654310', 'luis.perez@example.com', 'Masculino', '2007-05-12', '2024-03-15', 3),
('23456789', 'Ana', 'López', '987654321', 'ana.lopez@example.com', 'Femenino', '2008-06-10', '2023-04-10', 5),
('34567890', 'Pedro', 'Santos', '987654322', 'pedro.santos@example.com', 'Masculino', '2006-12-20', '2024-01-15', 7),
('45678901', 'María', 'Torres', '987654323', 'maria.torres@example.com', 'Femenino', '2005-09-30', '2023-03-15', 9),
('56789012', 'Carlos', 'Gómez', '987654324', 'carlos.gomez@example.com', 'Masculino', '2007-02-15', '2023-04-15', 2),
('67890123', 'Lucía', 'Ramos', '987654325', 'lucia.ramos@example.com', 'Femenino', '2008-10-22', '2023-03-12', 8),
('78901234', 'José', 'Castro', '987654326', 'jose.castro@example.com', 'Masculino', '2007-05-30', '2023-05-20', 6),
('89012345', 'Laura', 'Vargas', '987654327', 'laura.vargas@example.com', 'Femenino', '2006-08-15', '2024-01-20', 10),
('90123456', 'Antonio', 'Medina', '987654328', 'antonio.medina@example.com', 'Masculino', '2009-04-25', '2023-06-25', 4),
('01234567', 'Sofía', 'Álvarez', '987654329', 'sofia.alvarez@example.com', 'Femenino', '2005-12-05', '2024-02-01', 1),
('34567891', 'Fernando', 'Cruz', '987654330', 'fernando.cruz@example.com', 'Masculino', '2008-03-18', '2024-03-18', 12),
('45678902', 'Camila', 'Salas', '987654331', 'camila.salas@example.com', 'Femenino', '2007-01-13', '2024-04-01', 11),
('56789013', 'Miguel', 'Reyes', '987654332', 'miguel.reyes@example.com', 'Masculino', '2006-07-20', '2023-06-20', 14),
('67890124', 'Sara', 'Morales', '987654333', 'sara.morales@example.com', 'Femenino', '2009-10-10', '2023-07-10', 13),
('78901235', 'Raúl', 'Silva', '987654334', 'raul.silva@example.com', 'Masculino', '2005-11-15', '2023-08-15', 16),
('89012346', 'Carolina', 'Paredes', '987654335', 'carolina.paredes@example.com', 'Femenino', '2007-09-12', '2024-01-12', 15),
('90123457', 'Diego', 'Rojas', '987654336', 'diego.rojas@example.com', 'Masculino', '2006-06-30', '2023-09-30', 18),
('01234568', 'Natalia', 'Quispe', '987654337', 'natalia.quispe@example.com', 'Femenino', '2008-11-22', '2023-10-10', 17),
('12345680', 'Andrés', 'Navarro', '987654338', 'andres.navarro@example.com', 'Masculino', '2005-01-15', '2024-02-15', 19),
('23456781', 'Mariana', 'Herrera', '987654339', 'mariana.herrera@example.com', 'Femenino', '2007-02-25', '2023-11-20', 20);

INSERT INTO Grado (nivel, descripcion, edad_minima, edad_maxima) VALUES
('Inicial', 'Todo inicial', 3, 5),
('Primaria', 'Todo Primaria', 6, 11),
('Secundaria', 'Todo Secundaria', 12, 17);

INSERT INTO Ano_academico (ano, fechaInicio, fechaFinal) VALUES
('2020', '2020-03-01', '2020-12-15'),
('2021', '2021-03-01', '2021-12-15'),
('2022', '2022-03-01', '2022-12-15'),
('2023', '2023-03-01', '2023-12-15'),
('2024', '2024-03-01', '2024-12-15');

INSERT INTO Cursos (nombre, area, horasTeoricas, horasPracticas, idGrado) VALUES
('Psicomotricidad', 'Desarrollo Integral', 2, 2, 1),
('Juego y Aprendizaje', 'Habilidades Sociales', 3, 1, 1),
('Comunicación Inicial', 'Lenguaje y Comunicación', 2, 1, 1),
('Matemática Básica', 'Lógica y Números', 2, 2, 1),
('Arte y Creatividad', 'Arte', 1, 3, 1);

INSERT INTO Cursos (nombre, area, horasTeoricas, horasPracticas, idGrado) VALUES
('Matemáticas', 'Ciencias', 3, 2, 2),
('Comunicación', 'Lenguaje', 3, 2, 2),
('Ciencias Naturales', 'Ciencias', 4, 1, 2),
('Historia', 'Ciencias Sociales', 2, 1, 2),
('Educación Física', 'Salud y Deporte', 1, 3, 2);

INSERT INTO Cursos (nombre, area, horasTeoricas, horasPracticas, idGrado) VALUES
('Álgebra', 'Matemáticas', 3, 2, 3),
('Física', 'Ciencias', 4, 1, 3),
('Química', 'Ciencias', 4, 1, 3),
('Literatura', 'Humanidades', 3, 1, 3),
('Educación Cívica', 'Ciencias Sociales', 2, 1, 3);

INSERT INTO Docente (dni, nombres, apellidos, telefono, email, sexo, fechaNac, gradoInst) VALUES
('87654321', 'Carlos', 'Ramírez', '987654321', 'carlos.ramirez@example.com', 'Masculino', '1980-01-15', 'Licenciado en Educación Inicial'),
('87654322', 'María', 'Sánchez', '987654322', 'maria.sanchez@example.com', 'Femenino', '1985-03-22', 'Licenciada en Educación Primaria'),
('87654323', 'Luis', 'Gómez', '987654323', 'luis.gomez@example.com', 'Masculino', '1978-07-18', 'Licenciado en Matemáticas'),
('87654324', 'Ana', 'Fernández', '987654324', 'ana.fernandez@example.com', 'Femenino', '1982-05-12', 'Magíster en Ciencias Naturales'),
('87654325', 'Pedro', 'Castro', '987654325', 'pedro.castro@example.com', 'Masculino', '1975-11-10', 'Doctor en Historia'),
('87654326', 'Lucía', 'Mendoza', '987654326', 'lucia.mendoza@example.com', 'Femenino', '1988-02-14', 'Licenciada en Educación Secundaria'),
('87654327', 'Jorge', 'Pérez', '987654327', 'jorge.perez@example.com', 'Masculino', '1979-09-30', 'Licenciado en Física'),
('87654328', 'Rosa', 'Torres', '987654328', 'rosa.torres@example.com', 'Femenino', '1983-12-25', 'Licenciada en Química'),
('87654329', 'Juan', 'Silva', '987654329', 'juan.silva@example.com', 'Masculino', '1981-06-18', 'Doctor en Matemáticas'),
('87654330', 'Elena', 'López', '987654330', 'elena.lopez@example.com', 'Femenino', '1987-04-10', 'Magíster en Lengua y Literatura'),
('87654331', 'Roberto', 'Vega', '987654331', 'roberto.vega@example.com', 'Masculino', '1976-10-05', 'Licenciado en Educación Física'),
('87654332', 'Claudia', 'Reyes', '987654332', 'claudia.reyes@example.com', 'Femenino', '1984-03-11', 'Licenciada en Artes'),
('87654333', 'Fernando', 'Rojas', '987654333', 'fernando.rojas@example.com', 'Masculino', '1977-07-07', 'Licenciado en Ciencias Sociales'),
('87654334', 'Mónica', 'Quispe', '987654334', 'monica.quispe@example.com', 'Femenino', '1986-08-20', 'Licenciada en Educación Especial'),
('87654335', 'Andrés', 'Morales', '987654335', 'andres.morales@example.com', 'Masculino', '1974-05-28', 'Licenciado en Filosofía'),
('87654336', 'Paula', 'Vargas', '987654336', 'paula.vargas@example.com', 'Femenino', '1980-11-03', 'Licenciada en Psicología Educativa'),
('87654337', 'Ricardo', 'Cruz', '987654337', 'ricardo.cruz@example.com', 'Masculino', '1979-08-12', 'Magíster en Ciencias Computacionales'),
('87654338', 'Teresa', 'Paredes', '987654338', 'teresa.paredes@example.com', 'Femenino', '1985-02-23', 'Licenciada en Matemáticas Aplicadas'),
('87654339', 'Alejandro', 'Navarro', '987654339', 'alejandro.navarro@example.com', 'Masculino', '1983-01-30', 'Doctor en Física Aplicada'),
('87654340', 'Gabriela', 'Herrera', '987654340', 'gabriela.herrera@example.com', 'Femenino', '1989-06-15', 'Licenciada en Ciencias Biológicas');

INSERT INTO Seccion (idSeccion, idAnoaca, idGrado, nombreSeccion, capacidad, aula) VALUES
(1, 1, 1, 'A', 25, 'Aula 101'),
(2, 1, 2, 'B', 30, 'Aula 102'),
(3, 1, 3, 'C', 35, 'Aula 103'),
(4, 2, 1, 'A', 25, 'Aula 201'),
(5, 2, 2, 'B', 30, 'Aula 202'),
(6, 2, 3, 'C', 35, 'Aula 203'),
(7, 3, 1, 'A', 25, 'Aula 301'),
(8, 3, 2, 'B', 30, 'Aula 302'),
(9, 3, 3, 'C', 35, 'Aula 303'),
(10, 4, 1, 'A', 25, 'Aula 401'),
(11, 4, 2, 'B', 30, 'Aula 402'),
(12, 4, 3, 'C', 35, 'Aula 403'),
(13, 5, 1, 'A', 25, 'Aula 501'),
(14, 5, 2, 'B', 30, 'Aula 502'),
(15, 5, 3, 'C', 35, 'Aula 503'),
(16, 5, 1, 'D', 25, 'Aula 504'),
(17, 5, 2, 'E', 30, 'Aula 505'),
(18, 5, 3, 'F', 35, 'Aula 506'),
(19, 5, 1, 'G', 25, 'Aula 507'),
(20, 5, 2, 'H', 30, 'Aula 508');

INSERT INTO Cursos_Docente (idCursos, idDocente, idSeccion, idAnoaca, idGrado, rol, horasAsignadas, estado) VALUES
(1, 1, 1, 1, 1, 'Titular', 4, 'Activo'),
(2, 2, 2, 1, 2, 'Titular', 6, 'Activo'),
(3, 3, 3, 1, 3, 'Titular', 5, 'Activo'),
(4, 4, 4, 2, 1, 'Asistente', 3, 'Activo'),
(5, 5, 5, 2, 2, 'Titular', 7, 'Activo'),
(6, 6, 6, 2, 3, 'Titular', 8, 'Activo'),
(7, 7, 7, 3, 1, 'Titular', 6, 'Activo'),
(8, 8, 8, 3, 2, 'Titular', 4, 'Activo'),
(9, 9, 9, 3, 3, 'Asistente', 5, 'Activo'),
(10, 10, 10, 4, 1, 'Titular', 7, 'Activo'),
(11, 11, 11, 4, 2, 'Asistente', 5, 'Activo'),
(12, 12, 12, 4, 3, 'Titular', 6, 'Activo'),
(13, 13, 13, 5, 1, 'Titular', 7, 'Activo'),
(14, 14, 14, 5, 2, 'Asistente', 5, 'Activo'),
(15, 15, 15, 5, 3, 'Titular', 8, 'Activo');

INSERT INTO Matricula (modalidad, fechaMatricula, estado, idAlumno) VALUES
('Regular', '2024-03-20', 'Activo', 6),
('Especial', '2024-02-10', 'Activo', 7),
('Regular', '2024-01-25', 'Activo', 8),
('Regular', '2023-09-15', 'Activo', 9),
('Especial', '2023-12-01', 'Activo', 10),
('Regular', '2023-10-05', 'Inactivo', 11),
('Especial', '2023-08-20', 'Activo', 12),
('Regular', '2023-07-30', 'Activo', 13),
('Especial', '2023-06-15', 'Activo', 14),
('Regular', '2024-04-01', 'Inactivo', 15),
('Regular', '2024-01-10', 'Activo', 16),
('Especial', '2023-11-05', 'Activo', 17),
('Regular', '2024-02-20', 'Inactivo', 18),
('Especial', '2023-09-12', 'Activo', 19),
('Regular', '2024-03-18', 'Activo', 20),
('Especial', '2023-07-15', 'Inactivo', 1),
('Regular', '2024-01-22', 'Activo', 2),
('Especial', '2023-10-10', 'Activo', 3),
('Regular', '2023-06-18', 'Activo', 4),
('Especial', '2024-01-30', 'Activo', 5);

INSERT INTO Detalle_Matricula (idDetalle_Matricula, idMatricula, idCursos, idDocente, idSeccion, idAnoaca, idGrado, promFinal, condicion, fechaInicio, fechaFinal) VALUES
(6, 1, 1, 1, 1, 1, 1, 17.5, 'Aprobado', '2023-03-15', '2023-12-15'),
(7, 2, 2, 2, 2, 1, 2, 16.0, 'Aprobado', '2023-04-10', '2023-12-15'),
(8, 3, 3, 3, 3, 1, 3, 12.5, 'Reprobado', '2024-01-15', '2024-12-15'),
(9, 4, 4, 4, 4, 2, 1, 19.0, 'Aprobado', '2023-05-20', '2023-12-15'),
(10, 5, 5, 5, 5, 2, 2, 15.0, 'Aprobado', '2023-06-25', '2023-12-15'),
(11, 1, 6, 6, 6, 2, 3, 18.0, 'Aprobado', '2023-03-15', '2023-12-15'),
(12, 2, 7, 7, 7, 3, 1, 20.0, 'Aprobado', '2023-04-10', '2023-12-15'),
(13, 3, 8, 8, 8, 3, 2, 14.5, 'Aprobado', '2024-01-15', '2024-12-15'),
(14, 4, 9, 9, 9, 3, 3, 11.0, 'Reprobado', '2023-05-20', '2023-12-15'),
(15, 5, 10, 10, 10, 4, 1, 19.5, 'Aprobado', '2023-06-25', '2023-12-15'),
(16, 6, 1, 1, 1, 1, 1, 17.5, 'Aprobado', '2023-03-15', '2023-12-15'),
(17, 7, 2, 2, 2, 1, 2, 16.0, 'Aprobado', '2023-04-10', '2023-12-15'),
(18, 8, 3, 3, 3, 1, 3, 12.5, 'Reprobado', '2024-01-15', '2024-12-15'),
(19, 9, 4, 4, 4, 2, 1, 19.0, 'Aprobado', '2023-05-20', '2023-12-15'),
(20, 10, 5, 5, 5, 2, 2, 15.0, 'Aprobado', '2023-06-25', '2023-12-15'),
(21, 6, 6, 6, 6, 2, 3, 18.0, 'Aprobado', '2023-03-15', '2023-12-15'),
(22, 7, 7, 7, 7, 3, 1, 20.0, 'Aprobado', '2023-04-10', '2023-12-15'),
(23, 8, 8, 8, 8, 3, 2, 14.5, 'Aprobado', '2024-01-15', '2024-12-15'),
(24, 9, 9, 9, 9, 3, 3, 11.0, 'Reprobado', '2023-05-20', '2023-12-15'),
(25, 10, 10, 10, 10, 4, 1, 19.5, 'Aprobado', '2023-06-25', '2023-12-15');