# 🍏 Bath Inventarios MAC

 Herramienta automatizada con interfaz gráfica (UI) para la extracción de inventario técnico de equipos macOS (**Apple Silicon** e **Intel**).

[![macOS](https://img.shields.io/badge/macOS-Supported-black?logo=apple)](https://apple.com)
[![Language](https://img.shields.io/badge/Language-Shell%20%7C%20AppleScript-blue)](#-tecnologías)
[![Architecture](https://img.shields.io/badge/Architecture-Apple%20Silicon%20%2F%20Intel-orange)](#-compatibilidad)

---

## 📌 Descripción

Esta aplicación permite realizar un levantamiento rápido e intuitivo del hardware y software de cualquier equipo Mac. Presenta un cuadro de diálogo nativo de macOS para seleccionar la carpeta destino (**Sala/Laboratorio**) y genera automáticamente un archivo de texto (`.txt`) con el **nombre del equipo** como título del archivo.

---

## ✨ Características Principales

- 🖥️ **Interfaz Gráfica Nativa (UI)**: Selector de archivos y carpetas sin necesidad de usar comandos por consola.
- 📁 **Organización por Salas**: Pregunta en qué sala o carpeta almacenar el reporte de inventario.
- 📄 **Nombre de Archivo Automático**: El reporte generado se nombra con el nombre exacto del equipo (ejemplo: `iMac de Kevin.txt`).
- ⚡ **Compatibilidad Universal**: Funciona nativamente en arquitectura **Apple Silicon (M1, M2, M3, M4)** y **Intel**.
- 📊 **Formato Doble (Texto + Excel)**: Incluye un resumen detallado y una fila separada por tabulaciones (Tab-Separated Values) lista para copiar y pegar directamente en Microsoft Excel o Google Sheets.

---

## 🔍 Datos Extraídos del Equipo

| Campo | Descripción | Ejemplo |
| :--- | :--- | :--- |
| **NOMBRE DEL EQUIPO** | Nombre configurado del Host | `iMac de Kevin` |
| **NÚMERO DE SERIE** | Serial Number del hardware | `C02H70ZJQ7GN` |
| **MARCA** | Fabricante del equipo | `Apple` |
| **MODELO** | Nombre comercial e identificador | `iMac (iMac21,2)` |
| **MEMORIA RAM** | Memoria RAM instalada | `8 GB` |
| **PROCESADOR** | Chip Apple Silicon o Procesador Intel | `Apple M1` |
| **SISTEMA OPERATIVO** | Nombre y versión de macOS | `macOS 26.3` |
| **DISCOS** | Modelo/Nombre del SSD o disco | `APPLE SSD AP0256Q` |
| **TAMAÑO DEL DISCO** | Capacidad total de almacenamiento | `251.0 GB` |

---

## 🚀 Formas de Ejecución

Existen dos opciones listas para usar dentro del repositorio:

### Opción 1: Aplicación Nativa (`InventarioMac.app`)
1. Haz **doble clic** sobre `InventarioMac.app`.
2. Selecciona la carpeta de la **Sala** donde deseas guardar el inventario.
3. ¡Listo! Recibirás una notificación de confirmación con la ruta del archivo generado.

### Opción 2: Script ejecutable (`GenerarInventario.command`)
1. Haz doble clic en `GenerarInventario.command`.
2. Se abrirá la interfaz gráfica de selección de sala y se guardará el archivo `.txt`.

---

## 📂 Estructura del Repositorio

```text
├── InventarioMac.app          # Aplicación ejecutable nativa de macOS
├── GenerarInventario.command  # Script ejecutable de macOS
├── src/                       # Código fuente del proyecto
│   ├── inventario_mac.sh      # Script principal en Shell (Bash)
│   └── inventario.applescript # Código fuente en AppleScript
├── B-201/                     # Carpetas de salas de ejemplo/destino
├── B-202/
├── B-203/
├── B-204/
├── B403/
├── B404/
├── .gitattributes             # Configuración de lenguajes para GitHub
└── README.md                  # Documentación del proyecto
```

---

## 🛠️ Compilación desde el Código Fuente

Si deseas recompilar la aplicación `.app` a partir del archivo fuente `src/inventario.applescript`:

```bash
osacompile -o "InventarioMac.app" "src/inventario.applescript"
```

Para otorgar permisos de ejecución al script `.command`:

```bash
chmod +x GenerarInventario.command
```

---

## ⚙️ Tecnologías

- **Shell (Bash)**: Extracción profunda de datos del sistema mediante `scutil`, `system_profiler`, `ioreg`, `sysctl`, `sw_vers` y `diskutil`.
- **AppleScript**: Renderizado de la interfaz gráfica (GUI) nativa de macOS (`choose folder`, `display dialog`).
