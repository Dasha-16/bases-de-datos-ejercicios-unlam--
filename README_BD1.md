# 📚 Bases de Datos 1 — Guía de Ejercicios

> Materia: **Bases de Datos **  
> Ejercicios prácticos de consultas SQL sobre distintos modelos relacionales.

---

## 🗂️ Estructura del repositorio

```
/
├── 01_almacen_articulo.sql           # Guía completa — 25 ejercicios
├── 02_almacen_articulo_resueltos.sql # Resoluciones alternativas
├── 03_empresa_persona.sql            # Modelo Empresa / Persona
├── 04_escuela_alumno.sql             # Modelo Escuela / Alumno
├── 05_banco_moneda.sql               # Modelo Banco / Moneda
└── 06_taxi_chofer.sql                # Modelo Taxi / Chofer
```

---

## 🧱 Modelos de datos

### 01 & 02 — Almacén / Artículo
Modelo de gestión de almacenes con artículos, materiales y proveedores.
- Tablas: `Almacen`, `Articulo`, `Material`, `Proveedor`, `Tiene`, `Compuesto_Por`, `Provisto_Por`
- 25 ejercicios: filtros, JOINs, subconsultas, GROUP BY, vistas, operaciones de conjuntos

### 03 — Empresa / Persona
Modelo de gestión de empleados y empresas.
- Tablas: `Persona`, `Empresa`, `Vive`, `Trabaja`, `Situada_En`, `Supervisada`
- Consultas sobre relaciones de trabajo, salarios y ubicaciones geográficas

### 04 — Escuela / Alumno
Modelo de alumnos, escuelas y alimentación escolar.
- Tablas: `Alumno`, `Escuela`, `Hermano_De`, `Alimento`, `Almuerza_En`
- Consultas con relaciones recursivas (hermanos) y condiciones compuestas

### 05 — Banco / Moneda
Modelo de cuentas bancarias internacionales.
- Tablas: `Pais`, `Banco`, `Moneda`, `Persona`, `Cuenta`, `Opera`
- Consultas con múltiples JOINs y operaciones sobre monedas y valores

### 06 — Taxi / Chofer
Modelo de gestión de viajes en taxi.
- Tablas: `Auto`, `Chofer`, `Viaje`, `Cliente`
- Consultas con funciones de fecha (`DATEADD`, `GETDATE`), agregaciones y subconsultas

---

## ⚙️ Temas cubiertos

- `SELECT` con filtros simples y compuestos
- `JOIN` (INNER, LEFT)
- Subconsultas correlacionadas y no correlacionadas
- `GROUP BY` / `HAVING`
- Funciones de agregación: `COUNT`, `SUM`, `AVG`, `MAX`, `MIN`
- `EXISTS` / `NOT EXISTS`
- Vistas (`CREATE VIEW`)
- Funciones de fecha: `DATEADD`, `GETDATE`, `YEAR`
- División relacional

---

## 🚀 Cómo ejecutar

### Requisitos
- **SQL Server** (2019 o superior recomendado)
- **SQL Server Management Studio (SSMS)**

### Pasos
1. Abrir SSMS y conectarse a tu instancia de SQL Server.
2. Abrir el archivo deseado con `Ctrl+O`.
3. Ejecutar el script completo con `F5` para crear las tablas e insertar los datos.
4. Luego ejecutar cada consulta individualmente, seleccionándola y presionando `F5`.

---

## 🛠️ Tecnologías

- Microsoft SQL Server
- T-SQL (Transact-SQL)
- SQL Server Management Studio (SSMS)
