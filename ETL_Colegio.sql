CREATE OR REPLACE FUNCTION fnTransDiaSemana(fecha DATE)
RETURNS VARCHAR(10)
AS $$
BEGIN
    RETURN TO_CHAR(fecha, 'Day');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fnTransEdadMediaGrado(idGrado INT)
RETURNS NUMERIC(5, 2)
AS $$
DECLARE
    edadPromedio NUMERIC(5, 2);
BEGIN
    SELECT AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, a.fechaNac))) INTO edadPromedio
    FROM colegio.Alumno a
    JOIN colegio.Matricula m ON a.idAlumno = m.idAlumno
    JOIN colegio.Detalle_Matricula dm ON m.idMatricula = dm.idMatricula
    WHERE dm.idGrado = idGrado;

    RETURN edadPromedio;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fnTransEstadoMatricula(fechaMatricula DATE, estado VARCHAR)
RETURNS VARCHAR(15)
AS $$
BEGIN
    IF fechaMatricula < CURRENT_DATE AND estado = 'Vigente' THEN
        RETURN 'ACTIVA';
    ELSE
        RETURN 'INACTIVA';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fnTransCantidadAlumnosCurso(idCurso INT)
RETURNS INT
AS $$
DECLARE
    cantidadAlumnos INT;
BEGIN
    SELECT COUNT(DISTINCT dm.idMatricula) INTO cantidadAlumnos
    FROM colegio.Detalle_Matricula dm
    WHERE dm.idCursos = idCurso;

    RETURN cantidadAlumnos;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fnTransRendimientoPorGrado(idGrado INT)
RETURNS NUMERIC(5, 2)
AS $$
DECLARE
    promedioGrado NUMERIC(5, 2);
BEGIN
    SELECT AVG(promFinal) INTO promedioGrado
    FROM colegio.Detalle_Matricula
    WHERE idGrado = idGrado;

    RETURN promedioGrado;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fnTransCrecimientoMatriculasAnual(anoInicial INT, anoFinal INT)
RETURNS NUMERIC(5, 2)
AS $$
DECLARE
    matriculasInicial INT;
    matriculasFinal INT;
BEGIN
    SELECT COUNT(*) INTO matriculasInicial
    FROM colegio.Matricula m
    JOIN colegio.Ano_academico a ON m.fechaMatricula BETWEEN a.fechaInicio AND a.fechaFinal
    WHERE a.ano::INT = anoInicial;

    SELECT COUNT(*) INTO matriculasFinal
    FROM colegio.Matricula m
    JOIN colegio.Ano_academico a ON m.fechaMatricula BETWEEN a.fechaInicio AND a.fechaFinal
    WHERE a.ano::INT = anoFinal;

    RETURN ((matriculasFinal - matriculasInicial) * 100.0 / matriculasInicial)::NUMERIC(5, 2);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fnTransUltimaInscripcion(idAlumno INT)
RETURNS DATE
AS $$
DECLARE
    ultimaInscripcion DATE;
BEGIN
    SELECT MAX(fechaMatricula) INTO ultimaInscripcion
    FROM colegio.Matricula
    WHERE idAlumno = idAlumno;

    RETURN ultimaInscripcion;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fnTransPromocionPendiente(idAlumno INT)
RETURNS BOOLEAN
AS $$
DECLARE
    pendiente BOOLEAN;
BEGIN
    SELECT CASE 
        WHEN COUNT(*) > 0 THEN TRUE
        ELSE FALSE
    END INTO pendiente
    FROM colegio.Detalle_Matricula
    WHERE idAlumno = idAlumno AND condicion = 'Reprobado';

    RETURN pendiente;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fnTransEdad(fechaNac DATE, fechaInscripcion DATE)
RETURNS INT
AS $$
DECLARE
    edad INT;
BEGIN
    IF fechaNac IS NULL THEN
        edad := (SELECT AVG(EXTRACT(YEAR FROM AGE(fechaInscripcion, fechaNac)))::INT
                 FROM colegio.Alumno
                 WHERE fechaNac IS NOT NULL);
    ELSE
        edad := EXTRACT(YEAR FROM AGE(fechaInscripcion, fechaNac));
    END IF;

    RETURN edad;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fnTransEtapaVida(edad INT)
RETURNS VARCHAR(20)
AS $$
BEGIN
    IF edad <= 11 THEN
        RETURN 'NIÑO';
    ELSIF edad <= 17 THEN
        RETURN 'ADOLESCENTE';
    ELSIF edad <= 29 THEN
        RETURN 'JOVEN';
    ELSIF edad <= 59 THEN
        RETURN 'ADULTO';
    ELSE
        RETURN 'ADULTO MAYOR';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fnTransTurno(hora TIME WITHOUT TIME ZONE)
RETURNS VARCHAR(20)
AS $$
BEGIN
    CASE
        WHEN (hora BETWEEN '07:00:00' AND '12:59:59') THEN
            RETURN 'MAÑANA';
        WHEN (hora BETWEEN '13:00:00' AND '18:59:59') THEN
            RETURN 'TARDE';
        WHEN (hora BETWEEN '19:00:00' AND '23:59:59') THEN
            RETURN 'NOCHE';
        ELSE
            RETURN 'MADRUGADA';
    END CASE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fnTransTemporada(fecha DATE)
RETURNS VARCHAR
AS $$
DECLARE
    mes SMALLINT;
    dia SMALLINT;
BEGIN
    mes := EXTRACT(MONTH FROM fecha);
    dia := EXTRACT(DAY FROM fecha);

    IF (mes = 9 AND dia >= 23) OR (mes = 10 OR mes = 11) OR (mes = 12 AND dia <= 20) THEN
        RETURN 'PRIMAVERA';
    ELSIF (mes = 12 AND dia >= 21) OR (mes = 1 OR mes = 2) OR (mes = 3 AND dia <= 19) THEN
        RETURN 'VERANO';
    ELSIF (mes = 3 AND dia >= 20) OR (mes = 4 OR mes = 5) OR (mes = 6 AND dia <= 20) THEN
        RETURN 'OTOÑO';
    ELSIF (mes = 6 AND dia >= 21) OR (mes = 7 OR mes = 8) OR (mes = 9 AND dia <= 22) THEN
        RETURN 'INVIERNO';
    ELSE
        RETURN 'ERROR';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fnSexo(sexo VARCHAR)
RETURNS CHAR(1)
AS $$
DECLARE
    resultado CHAR(1);
BEGIN
    IF UPPER(sexo) = 'MASCULINO' THEN
        resultado := 'M';
    ELSIF UPPER(sexo) = 'FEMENINO' THEN
        resultado := 'F';
    ELSE
        SELECT CASE WHEN COUNT(*) > 0 THEN LEFT(sexo, 1) ELSE 'D' END INTO resultado
        FROM (SELECT sexo, COUNT(*) AS recuento FROM colegio.Alumno GROUP BY sexo ORDER BY recuento DESC LIMIT 1) AS subquery;
    END IF;

    RETURN resultado;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fnTransDuracionInscripcion(fechaIngreso DATE)
RETURNS INT
AS $$
DECLARE
    duracion INT;
BEGIN
    duracion := EXTRACT(YEAR FROM AGE(CURRENT_DATE, fechaIngreso));
    RETURN duracion;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fnTransCategoriaRendimiento(promedio NUMERIC)
RETURNS VARCHAR(20)
AS $$
BEGIN
    IF promedio < 10 THEN
        RETURN 'INSUFICIENTE';
    ELSIF promedio < 13 THEN
        RETURN 'REGULAR';
    ELSIF promedio < 16 THEN
        RETURN 'BUENO';
    ELSIF promedio < 18 THEN
        RETURN 'MUY BUENO';
    ELSE
        RETURN 'EXCELENTE';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fnTransPeriodoEscolar(fecha DATE)
RETURNS VARCHAR(20)
AS $$
DECLARE
    mes INT;
BEGIN
    mes := EXTRACT(MONTH FROM fecha);
    
    IF mes BETWEEN 1 AND 3 THEN
        RETURN 'INICIO DE AÑO';
    ELSIF mes BETWEEN 4 AND 8 THEN
        RETURN 'MEDIO DE AÑO';
    ELSE
        RETURN 'FIN DE AÑO';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fnTransPromedioPonderadoFinal(idAlumno INT)
RETURNS NUMERIC(5, 2)
AS $$
DECLARE
    promedioPonderado NUMERIC(5, 2);
BEGIN
    SELECT SUM(dm.promFinal * c.horasTeoricas) / SUM(c.horasTeoricas) INTO promedioPonderado
    FROM colegio.Detalle_Matricula dm
    JOIN colegio.Cursos c ON dm.idCursos = c.idCursos
    WHERE dm.idMatricula = idAlumno;
    
    RETURN promedioPonderado;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fnTransAnoIngreso(fechaInscripcion DATE)
RETURNS INT
AS $$
BEGIN
    RETURN EXTRACT(YEAR FROM fechaInscripcion);
END;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE proc_dim_detallematricula()
AS $$
BEGIN
    INSERT INTO DIM_DETALLEMATRICULA (condicion, codDetalleMatricula)
    SELECT DISTINCT dm.condicion, dm.idDetalle_Matricula
    FROM colegio.Detalle_Matricula dm
    LEFT OUTER JOIN DIM_DETALLEMATRICULA dim ON dm.idDetalle_Matricula = dim.codDetalleMatricula
    WHERE dim.KeyDetalleMatricula IS NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE proc_dim_alumno()
AS $$
BEGIN
    INSERT INTO DIM_ALUMNO (alumno, sexo, fechaNac, fechaIngreso, codAlumno)
    SELECT DISTINCT CONCAT(a.nombres, ' ', a.apellidos), fnSexo(a.sexo), a.fechaNac, a.fechaIngreso, a.idAlumno
    FROM colegio.Alumno a
    LEFT OUTER JOIN DIM_ALUMNO dim ON a.idAlumno = dim.codAlumno
    WHERE dim.KeyAlumno IS NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE proc_dim_docente()
AS $$
BEGIN
    INSERT INTO DIM_DOCENTE (docente, sexo, fechaNac, gradoInst, codDocente)
    SELECT DISTINCT CONCAT(d.nombres, ' ', d.apellidos), fnSexo(d.sexo), d.fechaNac, d.gradoInst, d.idDocente
    FROM colegio.Docente d
    LEFT OUTER JOIN DIM_DOCENTE dim ON d.idDocente = dim.codDocente
    WHERE dim.KeyDocente IS NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE proc_dim_curso()
AS $$
BEGIN
    INSERT INTO DIM_CURSO (curso, area, horasTeoricas, horasPracticas, codCurso)
    SELECT DISTINCT c.nombre, c.area, c.horasTeoricas, c.horasPracticas, c.idCursos
    FROM colegio.Cursos c
    LEFT OUTER JOIN DIM_CURSO dim ON c.idCursos = dim.codCurso
    WHERE dim.KeyCurso IS NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE proc_dim_grado()
AS $$
BEGIN
    INSERT INTO DIM_GRADO (grado, edad_minima, edad_maxima, codGrado)
    SELECT DISTINCT CONCAT(g.nivel, ' - ', g.descripcion), g.edad_minima, g.edad_maxima, g.idGrado
    FROM colegio.Grado g
    LEFT OUTER JOIN DIM_GRADO dim ON g.idGrado = dim.codGrado
    WHERE dim.KeyGrado IS NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE proc_dim_anoacademico()
AS $$
BEGIN
    INSERT INTO DIM_ANOACADEMICO (ano, fechaInicio, fechaFinal, codAnoaca)
    SELECT DISTINCT a.ano, a.fechaInicio, a.fechaFinal, a.idAnoaca
    FROM colegio.Ano_academico a
    LEFT OUTER JOIN DIM_ANOACADEMICO dim ON a.idAnoaca = dim.codAnoaca
    WHERE dim.KeyAñoAca IS NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE proc_dim_matricula()
AS $$
BEGIN
    INSERT INTO DIM_MATRICULA (modalidad, fechaMatricula, codMatricula)
    SELECT DISTINCT m.modalidad, m.fechaMatricula, m.idMatricula
    FROM colegio.Matricula m
    LEFT OUTER JOIN DIM_MATRICULA dim ON m.idMatricula = dim.codMatricula
    WHERE dim.KeyMatricula IS NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE proc_dim_geografia()
AS $$
BEGIN
    INSERT INTO DIM_GEOGRAFIA (Departamento, Provincia, Distrito, codDepartamento, codProvincia, codDistrito)
    SELECT DISTINCT dep.nombre, prov.nombre, dist.nombre, dep.idDepartamento, prov.idProvincia, dist.idDistrito
    FROM colegio.Departamento dep
    JOIN colegio.Provincia prov ON dep.idDepartamento = prov.idDepartamento
    JOIN colegio.Distrito dist ON prov.idProvincia = dist.idProvincia
    LEFT OUTER JOIN DIM_GEOGRAFIA dim ON dist.idDistrito = dim.codDistrito
    WHERE dim.KeyGeografia IS NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE proc_hecho_rendimientoacademico()
AS $$
BEGIN
    INSERT INTO HECHO_RENDIMIENTOACADEMICO (KeyAlumno, KeyDocente, KeyGeografia, KeyCurso, KeyGrado, KeyAñoAca, KeyMatricula, KeyDetalleMatricula, promedioFinal)
    SELECT DISTINCT 
        da.KeyAlumno,
        dd.KeyDocente,
        dgeo.KeyGeografia,
        dc.KeyCurso,
        dgr.KeyGrado,
        dya.KeyAñoAca,
        dmat.KeyMatricula,
        ddm.KeyDetalleMatricula,
        dm.promFinal
    FROM colegio.Detalle_Matricula dm
    JOIN DIM_ALUMNO da ON dm.idMatricula = da.codAlumno
    JOIN DIM_DOCENTE dd ON dm.idDocente = dd.codDocente
    JOIN DIM_GEOGRAFIA dgeo ON da.codAlumno = dgeo.codDistrito
    JOIN DIM_CURSO dc ON dm.idCursos = dc.codCurso
    JOIN DIM_GRADO dgr ON dm.idGrado = dgr.codGrado
    JOIN DIM_ANOACADEMICO dya ON dm.idAnoaca = dya.codAnoaca
    JOIN DIM_MATRICULA dmat ON dm.idMatricula = dmat.codMatricula
    JOIN DIM_DETALLEMATRICULA ddm ON dm.idDetalle_Matricula = ddm.codDetalleMatricula
    LEFT OUTER JOIN HECHO_RENDIMIENTOACADEMICO h ON h.KeyDetalleMatricula = ddm.KeyDetalleMatricula
    WHERE h.KeyRendimientoAca IS NULL;
END;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE proc_etl_rendimientoacademico()
AS $$
BEGIN
	CALL proc_dim_detallematricula();
	CALL proc_dim_alumno();
	CALL proc_dim_docente();
	CALL proc_dim_curso();
	CALL proc_dim_grado();
	CALL proc_dim_anoacademico();
	CALL proc_dim_matricula();
	CALL proc_dim_geografia();
	CALL proc_hecho_rendimientoacademico();
END;
$$ LANGUAGE plpgsql;

-----------------------------------------------------

CALL proc_etl_rendimientoacademico();

SELECT * FROM dim_alumno;