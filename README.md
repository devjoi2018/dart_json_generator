# 🚀 **Dart JSON Generator**

<div align="center">
  <h3>Versión v1.2.0</h3>
  <p>Una herramienta potente para generar archivos JSON con datos aleatorios o personalizados</p>
</div>

---

## 📋 **Índice**

- [Descripción](#-descripción)
- [Requisitos](#-requisitos)
- [Instalación](#-instalación)
- [Uso Básico](#-uso-básico)
- [Opciones de Configuración](#-opciones-de-configuración)
- [Sistema de Templates](#-sistema-de-templates)
- [Generación de Datos Aleatorios](#-generación-de-datos-aleatorios)
- [Ejemplos Avanzados](#-ejemplos-avanzados)
- [Personalización](#-personalización)
- [Formatos de Salida](#-formatos-de-salida)
- [Validación de Esquemas](#-validación-de-esquemas)

---

## 📝 **Descripción**

Dart JSON Generator es una herramienta robusta que permite generar archivos de datos a partir de mapas de datos en Dart. Soporta generación de datos aleatorios, configuraciones personalizables, múltiples formatos de salida como JSON, YAML y XML, y validación de datos contra esquemas JSON.

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

Esto creará archivos JSON de ejemplo en la carpeta `output/`.

---

## ⚙️ **Opciones de Configuración**

Dart JSON Generator ofrece una amplia gama de opciones configurables a través de argumentos en la línea de comandos, permitiéndote personalizar completamente la generación de archivos JSON:

### 📂 **Opciones de salida**

| Argumento                   | Descripción                                                                  | Valor predeterminado  | Ejemplo            |
| --------------------------- | ---------------------------------------------------------------------------- | --------------------- | ------------------ |
| `--output=<ruta>`           | Directorio donde se guardarán los archivos JSON generados                    | `./output`            | `--output=./datos` |
| `--timestamp`               | Agrega una marca de tiempo al nombre del archivo para evitar sobreescrituras | `false`               | `--timestamp`      |
| `--indent=<texto>`          | Cadena de texto usada para la indentación del JSON                           | Dos espacios (`"  "`) | `--indent="    "`  |
| `--ext=<extensión>`         | Extensión de los archivos generados                                          | `json`                | `--ext=json`       |
| `--encoding=<codificación>` | Codificación de caracteres para los archivos                                 | `utf-8`               | `--encoding=utf-8` |
| `--maxsize=<MB>`            | Tamaño máximo del archivo en megabytes                                       | `10` (10MB)           | `--maxsize=20`     |

**Nota importante**: Por defecto, todos los archivos se generan en la carpeta `./output` según la configuración base. Esta ruta puede cambiarse temporalmente con el argumento `--output` o permanentemente modificando el valor `outputPath` en el archivo de configuración.

### 🧩 **Opciones de generación de datos**

| Argumento                | Descripción                                                                 | Valor predeterminado | Ejemplo                |
| ------------------------ | --------------------------------------------------------------------------- | -------------------- | ---------------------- |
| `--records=<número>`     | Cantidad de registros a generar en listas                                   | `5`                  | `--records=100`        |
| `--seed=<número>`        | Semilla para la generación de datos aleatorios (garantiza reproducibilidad) | Aleatorio            | `--seed=42`            |
| `--gentype=<tipo>`       | Tipo de generación de datos (`fully_random`, `consistent`, `realistic`)     | `realistic`          | `--gentype=consistent` |
| `--cache` / `--no-cache` | Activar/desactivar caché para mejorar rendimiento                           | `true`               | `--no-cache`           |

### 🧰 **Opciones de templates**

| Argumento                         | Descripción                                      | Ejemplo                          |
| --------------------------------- | ------------------------------------------------ | -------------------------------- |
| `--list-templates`                | Muestra la lista de templates disponibles        | `--list-templates`               |
| `--template=<nombre>`             | Especifica el template a utilizar                | `--template=user`                |
| `--show-template-schema=<nombre>` | Muestra el esquema de un template específico     | `--show-template-schema=product` |
| `--validate` / `--no-validate`    | Activar/desactivar validación contra el template | `--validate`                     |

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

# Listar templates disponibles
dart run bin/generador_de_json.dart --list-templates

# Generar datos usando un template específico
dart run bin/generador_de_json.dart --template=user --records=10

# Ver el esquema de un template
dart run bin/generador_de_json.dart --show-template-schema=product
```

> 💡 **Consejo**: Puedes combinar tantos argumentos como necesites para personalizar completamente la generación de tus archivos JSON.

### 🧩 **Opciones de formato de salida**

| Argumento            | Descripción                                    | Valor predeterminado | Ejemplo          |
| -------------------- | ---------------------------------------------- | -------------------- | ---------------- |
| `--format=<formato>` | Formato de salida a utilizar (json, yaml, xml) | `json`               | `--format=yaml`  |
| `--list-formats`     | Muestra la lista de formatos disponibles       | -                    | `--list-formats` |

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

# Listar templates disponibles
dart run bin/generador_de_json.dart --list-templates

# Generar datos usando un template específico
dart run bin/generador_de_json.dart --template=user --records=10

# Ver el esquema de un template
dart run bin/generador_de_json.dart --show-template-schema=product
```

> 💡 **Consejo**: Puedes combinar tantos argumentos como necesites para personalizar completamente la generación de tus archivos JSON.

### 📊 **Opciones de validación de esquemas**

| Argumento                          | Descripción                                       | Ejemplo                                   |
| ---------------------------------- | ------------------------------------------------- | ----------------------------------------- |
| `--list-schema-formats`            | Muestra los formatos de esquema disponibles       | `--list-schema-formats`                   |
| `--generate-schema=<archivo.json>` | Genera un esquema a partir de un archivo JSON     | `--generate-schema=output/datos.json`     |
| `--validate-schema=<archivo.json>` | Esquema contra el que validar datos               | `--validate-schema=esquemas/usuario.json` |
| `--validate-json=<archivo.json>`   | Archivo JSON a validar contra el esquema          | `--validate-json=datos/usuario.json`      |
| `--schema-format=<formato>`        | Formato del esquema (predeterminado: json-schema) | `--schema-format=json-schema`             |

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
  "outputPath": "./output",
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
  "templates": {
    "directory": "templates",
    "defaultTemplate": "",
    "validateData": true,
    "allowWithoutTemplate": true
  },
  "logging": {
    "level": "debug",
    "toFile": true,
    "toConsole": true
  }
}
```

**Ubicación de archivos generados**: El valor `outputPath` determina dónde se guardarán los archivos JSON. Por defecto, los archivos se generan en la carpeta `./output`. Puedes cambiar esta ubicación de dos formas:

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

## 🧩 **Sistema de Templates**

El generador incluye un potente sistema de templates que permite definir esquemas predefinidos para generar datos estructurados de manera consistente.

### Templates predefinidos

El sistema incluye varios templates predefinidos listos para usar:

- `user`: Genera datos de usuarios con campos como nombre, email, rol, preferencias, etc.
- `product`: Genera datos de productos con campos como id, nombre, precio, categoría, marca, etc.

### Uso de templates

Para generar datos utilizando un template predefinido:

```bash
# Generar datos usando el template de usuario
dart run bin/generador_de_json.dart --template=user

# Generar 20 registros con el template de producto
dart run bin/generador_de_json.dart --template=product --records=20
```

### Consultar templates disponibles

Para ver qué templates están disponibles:

```bash
dart run bin/generador_de_json.dart --list-templates
```

### Ver esquema de un template

Para inspeccionar el esquema JSON de un template específico:

```bash
dart run bin/generador_de_json.dart --show-template-schema=user
```

### Creación de templates personalizados

Puedes crear tus propios templates extendiendo la clase `BaseTemplate`:

```dart
import 'package:generador_de_json/core/templates/base_template.dart';

class MiTemplate extends BaseTemplate {
  @override
  String get name => 'mi_template';

  @override
  String get description => 'Mi template personalizado';

  @override
  String get version => '1.0.0';

  @override
  Map<String, dynamic> _getSchemaInternal() {
    return {
      'type': 'object',
      'required': ['id', 'nombre'],
      'properties': {
        'id': {'type': 'integer'},
        'nombre': {'type': 'string'},
        // Más propiedades...
      }
    };
  }

  @override
  Map<String, dynamic> _generateMapInternal() {
    // Lógica para generar datos según el esquema
    return {
      'id': _dataGenerator.generateRandomInt(min: 1, max: 1000),
      'nombre': _dataGenerator.generateRandomFemaleOrMaleName(),
      // Más campos...
    };
  }
}
```

Los templates personalizados deben ubicarse en la carpeta `templates/` y registrarse en el sistema antes de su uso.

---

## 🎭 **Formatos de Salida**

El generador soporta múltiples formatos de salida para adaptarse a tus necesidades:

### JSON (Predeterminado)

El formato estándar para intercambio de datos:

```json
{
  "id": 1,
  "nombre": "Juan Pérez",
  "email": "juan.perez@example.com"
}
```

Para utilizar:

```bash
dart run bin/generador_de_json.dart --format=json
```

### YAML

Un formato más legible basado en indentación:

```yaml
id: 1
nombre: Juan Pérez
email: juan.perez@example.com
```

Para utilizar:

```bash
dart run bin/generador_de_json.dart --format=yaml
```

### XML

Formato basado en etiquetas, ideal para sistemas que requieren XML:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <id>1</id>
  <nombre>Juan Pérez</nombre>
  <email>juan.perez@example.com</email>
</root>
```

Para utilizar:

```bash
dart run bin/generador_de_json.dart --format=xml
```

### Listar formatos disponibles

Para ver todos los formatos soportados:

```bash
dart run bin/generador_de_json.dart --list-formats
```

### Uso con templates

Los formatos funcionan también con el sistema de templates:

```bash
dart run bin/generador_de_json.dart --template=user --format=xml
```

---

## 🔄 **Próximas funcionalidades**

- ~Soporte para diferentes formatos de salida (YAML, XML)~ ✓ Implementado!
- ~Validación de esquemas JSON~ ✓ Implementado!
- Generación asíncrona para archivos grandes
- Interfaz de línea de comandos mejorada

---

## 🔍 **Validación de Esquemas**

Dart JSON Generator incluye potentes capacidades de validación de esquemas que te permiten:

1. Generar automáticamente esquemas a partir de datos JSON existentes
2. Validar que los datos JSON cumplan con un esquema específico
3. Generar datos de ejemplo basados en un esquema

### Generación de esquemas

Para generar un esquema a partir de un archivo JSON existente:

```bash
dart run bin/generador_de_json.dart --generate-schema=output/datos.json
```

Esto creará un archivo de esquema JSON en la misma ubicación con el sufijo `_schema`:

```
output/datos_schema.json
```

### Validación contra esquemas

Para validar un archivo JSON contra un esquema:

```bash
dart run bin/generador_de_json.dart --validate-schema=esquemas/usuario.json --validate-json=datos/usuario.json
```

Si la validación es exitosa, verás un mensaje confirmándolo. Si falla, se mostrará información sobre los errores encontrados.

### Generación de ejemplos

Para generar un ejemplo a partir de un esquema:

```bash
dart run bin/generador_de_json.dart --validate-schema=esquemas/usuario.json
```

Esto generará y mostrará un objeto JSON que cumple con el esquema especificado.

### Formatos de esquema soportados

Para ver los formatos de esquema disponibles:

```bash
dart run bin/generador_de_json.dart --list-schema-formats
```

Actualmente se soporta:

- `json-schema`: El estándar JSON Schema para validación de datos JSON

### Ejemplo de esquema JSON

Un esquema típico para un objeto usuario podría verse así:

```json
{
  "type": "object",
  "properties": {
    "id": { "type": "integer" },
    "nombre": { "type": "string" },
    "email": { "type": "string" },
    "activo": { "type": "boolean" }
  },
  "required": ["id", "nombre", "email"]
}
```

Este esquema define un objeto con propiedades de diferentes tipos y especifica cuáles son obligatorias.

---
