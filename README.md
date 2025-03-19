# 🚀 **Dart JSON Generator**

<div align="center">
  <h3>Versión v1.1.1</h3>
  <p>Una herramienta potente para generar archivos JSON con datos aleatorios o personalizados</p>
</div>

---

## 📋 **Índice**

- [Descripción](#-descripción)
- [Requisitos](#-requisitos)
- [Instalación](#-instalación)
- [Uso Básico](#-uso-básico)
- [Opciones de Configuración](#-opciones-de-configuración)
- [Generación de Datos Aleatorios](#-generación-de-datos-aleatorios)
- [Ejemplos Avanzados](#-ejemplos-avanzados)
- [Personalización](#-personalización)

---

## 📝 **Descripción**

Dart JSON Generator es una herramienta robusta que permite generar archivos JSON a partir de mapas de datos en Dart. Soporta generación de datos aleatorios, configuraciones personalizables y múltiples formatos de salida.

---

## 💻 **Requisitos**

- Dart SDK v2.18.2 o superior
- Cualquier sistema operativo: Windows, macOS o Linux

> 💡 **Nota**: Si ya tienes Flutter instalado, ¡Dart ya está disponible en tu sistema!

---

## 🔧 **Instalación**

1. Clona el repositorio:

   ```bash
   git clone https://github.com/devjoi2018/dart_json_generator.git
   cd dart_json_generator
   ```

2. Instala las dependencias:
   ```bash
   dart pub get
   ```

---

## 🚀 **Uso Básico**

Para ejecutar el generador con la configuración predeterminada:

```bash
dart run bin/generador_de_json.dart
```

Esto creará archivos JSON de ejemplo en la carpeta `examples/`.

---

## ⚙️ **Opciones de Configuración**

Dart JSON Generator ofrece una amplia gama de opciones configurables a través de argumentos en la línea de comandos, permitiéndote personalizar completamente la generación de archivos JSON:

### 📂 **Opciones de salida**

| Argumento                   | Descripción                                                                  | Valor predeterminado  | Ejemplo            |
| --------------------------- | ---------------------------------------------------------------------------- | --------------------- | ------------------ |
| `--output=<ruta>`           | Directorio donde se guardarán los archivos JSON generados                    | `./examples`          | `--output=./datos` |
| `--timestamp`               | Agrega una marca de tiempo al nombre del archivo para evitar sobreescrituras | `false`               | `--timestamp`      |
| `--indent=<texto>`          | Cadena de texto usada para la indentación del JSON                           | Dos espacios (`"  "`) | `--indent="    "`  |
| `--ext=<extensión>`         | Extensión de los archivos generados                                          | `json`                | `--ext=json`       |
| `--encoding=<codificación>` | Codificación de caracteres para los archivos                                 | `utf-8`               | `--encoding=utf-8` |
| `--maxsize=<MB>`            | Tamaño máximo del archivo en megabytes                                       | `10` (10MB)           | `--maxsize=20`     |

**Nota importante**: Por defecto, todos los archivos se generan en la carpeta `./examples` según la configuración base. Esta ruta puede cambiarse temporalmente con el argumento `--output` o permanentemente modificando el valor `outputPath` en el archivo de configuración.

### 🧩 **Opciones de generación de datos**

| Argumento                | Descripción                                                                 | Valor predeterminado | Ejemplo                |
| ------------------------ | --------------------------------------------------------------------------- | -------------------- | ---------------------- |
| `--records=<número>`     | Cantidad de registros a generar en listas                                   | `5`                  | `--records=100`        |
| `--seed=<número>`        | Semilla para la generación de datos aleatorios (garantiza reproducibilidad) | Aleatorio            | `--seed=42`            |
| `--gentype=<tipo>`       | Tipo de generación de datos (`fully_random`, `consistent`, `realistic`)     | `realistic`          | `--gentype=consistent` |
| `--cache` / `--no-cache` | Activar/desactivar caché para mejorar rendimiento                           | `true`               | `--no-cache`           |

### 📅 **Opciones de formato de fecha**

| Argumento                     | Descripción                                       | Valor predeterminado  | Ejemplo                           |
| ----------------------------- | ------------------------------------------------- | --------------------- | --------------------------------- |
| `--dateformat=<formato>`      | Formato de fecha a usar                           | `iso8601`             | `--dateformat=shortDate`          |
| `--customdateformat=<patrón>` | Patrón personalizado cuando se usa `customFormat` | `yyyy-MM-dd HH:mm:ss` | `--customdateformat="dd/MM/yyyy"` |
| `--timezone=<zona>`           | Zona horaria para las fechas generadas            | `UTC`                 | `--timezone=CET`                  |

### 📊 **Opciones de logging**

| Argumento            | Descripción                                                     | Valor predeterminado | Ejemplo           |
| -------------------- | --------------------------------------------------------------- | -------------------- | ----------------- |
| `--loglevel=<nivel>` | Nivel de logging (`debug`, `info`, `warning`, `error`, `fatal`) | `debug`              | `--loglevel=info` |

### 🧪 **Ejemplos prácticos**

```bash
# Generar 50 registros en formato JSON con indentación de 4 espacios
dart run bin/generador_de_json.dart --records=50 --indent="    "

# Generar datos con formato de fecha completo y marca de tiempo
dart run bin/generador_de_json.dart --dateformat=longDate --timestamp

# Configuración para desarrollo: registros reducidos y logging mínimo
dart run bin/generador_de_json.dart --records=3 --loglevel=info --output=./dev

# Configuración para pruebas reproducibles
dart run bin/generador_de_json.dart --seed=12345 --gentype=consistent --no-cache

# Generar archivos JSON con configuración completa
dart run bin/generador_de_json.dart --output=./data --records=100 --indent="  " --timestamp --dateformat=shortDate --loglevel=info --seed=42 --gentype=realistic --maxsize=5
```

> 💡 **Consejo**: Puedes combinar tantos argumentos como necesites para personalizar completamente la generación de tus archivos JSON.

---

## 🎲 **Generación de Datos Aleatorios**

El generador incluye múltiples utilidades para crear datos aleatorios realistas:

### 👤 Datos personales:

```dart
// Nombres y apellidos
dataGenerator.generateRandomMaleName(isFullName: true)
dataGenerator.generateRandomFemaleName(isFullName: false)
dataGenerator.generateRandomFemaleOrMaleName(isFullName: true)

// Contacto
dataGenerator.generateRandomEmail()
dataGenerator.generateRandomAvatarUrl()
```

### 📊 Datos numéricos y booleanos:

```dart
dataGenerator.generateRandomInt(min: 1, max: 100)
dataGenerator.generateRandomDouble(min: 0.0, max: 10.0, decimals: 2)
dataGenerator.generateRandomBool(trueProbability: 0.7)
```

### 📅 Fechas y horas:

```dart
dataGenerator.generateRandomDate(
  from: DateTime(2020, 1, 1),
  to: DateTime.now(),
  format: 'shortDate'
)
```

### 🌐 Datos de red:

```dart
dataGenerator.generateRandomIpAddress(ipv6: false)
```

---

## 📋 **Ejemplos Avanzados**

### Generación de objeto simple:

```dart
jsonGenerator.generateJson(
  jsonName: 'usuario',
  jsonMap: (Map<String, dynamic> data) {
    return <String, dynamic>{
      'id': 1,
      'nombre': dataGenerator.generateRandomFemaleOrMaleName(isFullName: true),
      'email': dataGenerator.generateRandomEmail(),
      'avatar': dataGenerator.generateRandomAvatarUrl(),
      'fechaNacimiento': dataGenerator.generateRandomDate(),
      'activo': dataGenerator.generateRandomBool(),
      'puntuacion': dataGenerator.generateRandomDouble(min: 0, max: 5, decimals: 1),
    };
  },
);
```

### Generación de lista de objetos:

```dart
jsonGenerator.generateJsonList(
  jsonName: 'usuarios',
  jsonMap: (List<Map<String, dynamic>> data) {
    return List.generate(
      app.config.defaultRecordCount,
      (index) => <String, dynamic>{
        'id': index,
        'nombre': dataGenerator.generateRandomFemaleOrMaleName(isFullName: true),
        'email': dataGenerator.generateRandomEmail(),
        'avatar': dataGenerator.generateRandomAvatarUrl(),
        'fechaRegistro': dataGenerator.generateRandomDate(
          from: DateTime(2020, 1, 1),
          to: DateTime.now(),
          format: 'longDate'
        ),
        'ipAcceso': dataGenerator.generateRandomIpAddress(),
      },
    );
  },
  addIdAutoincrement: true,
);
```

---

## 🛠️ **Personalización**

### Archivo de configuración

Puedes personalizar la configuración predeterminada editando el archivo `config/config.json`:

```json
{
  "outputPath": "./examples",
  "defaultRecordCount": 5,
  "jsonIndent": "  ",
  "addTimestampToFiles": true,
  "dates": {
    "format": "iso8601",
    "customFormat": "yyyy-MM-dd HH:mm:ss",
    "timeZone": "UTC"
  },
  "generation": {
    "type": "realistic",
    "seed": null,
    "enableCache": true
  },
  "files": {
    "extension": "json",
    "encoding": "utf-8",
    "maxSize": 10485760
  },
  "logging": {
    "level": "debug",
    "toFile": true,
    "toConsole": true
  }
}
```

**Ubicación de archivos generados**: El valor `outputPath` determina dónde se guardarán los archivos JSON. Por defecto, los archivos se generan en la carpeta `./examples`. Puedes cambiar esta ubicación de dos formas:

1. **Cambio permanente**: Edita el valor `outputPath` en el archivo `config/config.json`.
2. **Cambio temporal**: Utiliza el parámetro `--output` al ejecutar el programa:
   ```bash
   dart run bin/generador_de_json.dart --output=./mi_carpeta_personalizada
   ```

Los cambios en el archivo de configuración son permanentes, mientras que los parámetros de línea de comandos solo afectan a la ejecución actual.

### Formatos de fecha disponibles:

- `iso8601`: Formato ISO estándar (2023-04-15T10:30:00)
- `shortDate`: Formato corto (15/04/2023)
- `longDate`: Formato largo (15 de abril de 2023)
- `timeOnly`: Solo hora (10:30:00)
- `usFormat`: Formato estadounidense (04/15/2023)
- `customFormat`: Formato personalizado definido en "customFormat"

---

## 🔄 **Próximas funcionalidades**

- Soporte para diferentes formatos de salida (YAML, XML)
- Validación de esquemas JSON
- Generación asíncrona para archivos grandes
- Interfaz de línea de comandos mejorada

---
