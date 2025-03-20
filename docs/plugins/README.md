# 🔌 Guía de Desarrollo de Plugins para Dart JSON Generator

## 📋 Índice

- [Introducción](#-introducción)
- [Arquitectura del Sistema de Plugins](#-arquitectura-del-sistema-de-plugins)
- [Requisitos Previos](#-requisitos-previos)
- [Estructura de un Plugin](#-estructura-de-un-plugin)
- [Paso a Paso: Creando tu Primer Plugin](#-paso-a-paso-creando-tu-primer-plugin)
  - [Paso 1: Crear el Directorio del Plugin](#paso-1-crear-el-directorio-del-plugin)
  - [Paso 2: Crear el Archivo de Manifiesto](#paso-2-crear-el-archivo-de-manifiesto)
  - [Paso 3: Implementar la Clase del Plugin](#paso-3-implementar-la-clase-del-plugin)
  - [Paso 4: Registrar Funcionalidades](#paso-4-registrar-funcionalidades)
  - [Paso 5: Probar el Plugin](#paso-5-probar-el-plugin)
- [Ejemplos Prácticos](#-ejemplos-prácticos)
  - [Ejemplo 1: Plugin de Formateo de Fechas](#ejemplo-1-plugin-de-formateo-de-fechas)
  - [Ejemplo 2: Plugin de Generación de Datos Geográficos](#ejemplo-2-plugin-de-generación-de-datos-geográficos)
  - [Ejemplo 3: Plugin de Formato de Salida Personalizado](#ejemplo-3-plugin-de-formato-de-salida-personalizado)
- [Mejores Prácticas](#-mejores-prácticas)
- [Solución de Problemas](#-solución-de-problemas)
- [Referencia de la API](#-referencia-de-la-api)

## 🌟 Introducción

El sistema de plugins de Dart JSON Generator permite extender la funcionalidad de la herramienta de manera modular. Los plugins pueden agregar nuevos generadores de datos, formatos de salida, o cualquier otra característica que desees integrar con la aplicación principal.

Esta guía te mostrará cómo crear, configurar y distribuir plugins para el generador, con ejemplos prácticos que puedes adaptar a tus necesidades específicas.

## 🏗️ Arquitectura del Sistema de Plugins

El sistema de plugins se basa en un conjunto de interfaces y clases base que definen cómo deben comportarse los plugins y cómo interactúan con la aplicación principal:

- **PluginInterface**: Define el contrato base que todos los plugins deben implementar.
- **BasePlugin**: Clase abstracta que proporciona implementaciones predeterminadas de métodos comunes.
- **PluginRegistry**: Responsable de gestionar el ciclo de vida de los plugins: carga, inicialización y acceso.
- **PluginModule**: Integra el sistema de plugins con la arquitectura modular de la aplicación.

## 📋 Requisitos Previos

Para desarrollar plugins, necesitarás:

- Dart SDK 2.18.2 o superior
- Conocimientos básicos de Dart y Programación Orientada a Objetos
- El código fuente de Dart JSON Generator o el paquete publicado
- Entendimiento básico de los principios SOLID (especialmente Inversión de Dependencias)

## 📁 Estructura de un Plugin

Un plugin bien estructurado debe contener:

- **manifest.json**: Archivo de metadatos que describe el plugin
- **Archivo principal (main.dart)**: Implementación principal del plugin
- **README.md**: Documentación sobre el uso del plugin
- **Recursos adicionales**: Cualquier recurso que el plugin necesite

## 🚀 Paso a Paso: Creando tu Primer Plugin

### Paso 1: Crear el Directorio del Plugin

Los plugins deben ubicarse en el directorio `plugins/` de la aplicación principal:

```bash
mkdir -p plugins/mi_plugin
cd plugins/mi_plugin
```

### Paso 2: Crear el Archivo de Manifiesto

El archivo `manifest.json` define los metadatos del plugin:

```json
{
  "id": "com.ejemplo.mi_plugin",
  "name": "Mi Plugin",
  "version": "1.0.0",
  "description": "Un plugin de ejemplo para Dart JSON Generator",
  "author": "Tu Nombre",
  "entryPoint": "main.dart",
  "dependencies": []
}
```

### Paso 3: Implementar la Clase del Plugin

Crea un archivo `main.dart` que implemente la interfaz de plugin:

```dart
import 'package:generador_de_json/core/plugins/base_plugin.dart';
import 'package:generador_de_json/core/utils/logger.dart';

class MiPlugin extends BasePlugin {
  @override
  String get pluginId => 'com.ejemplo.mi_plugin';

  @override
  String get pluginName => 'Mi Plugin';

  @override
  String get pluginDescription => 'Un plugin de ejemplo para Dart JSON Generator';

  @override
  String get pluginVersion => '1.0.0';

  @override
  String get pluginAuthor => 'Tu Nombre';

  @override
  void initialize() {
    AppLogger.info('Inicializando plugin: $pluginName');
    // Código de inicialización
  }

  @override
  void registerFunctionalities() {
    AppLogger.debug('Registrando funcionalidades del plugin: $pluginName');
    // Registrar generadores, formateadores, etc.
  }

  // Añade métodos adicionales según la funcionalidad de tu plugin
  String diHola(String nombre) {
    return '¡Hola, $nombre! Desde $pluginName';
  }
}

// Función para crear una instancia del plugin
// Esta función será llamada por el sistema de plugins
MiPlugin createPlugin() {
  return MiPlugin();
}
```

### Paso 4: Registrar Funcionalidades

En el método `registerFunctionalities()`, registra las capacidades que tu plugin proporciona. Dependiendo del tipo de plugin, podrías registrar:

- Generadores de datos
- Formateadores de salida
- Validadores de esquemas
- Herramientas utilitarias

```dart
@override
void registerFunctionalities() {
  AppLogger.debug('Registrando funcionalidades de: $pluginName');

  // Ejemplo: registrar un generador de datos
  final dataGeneratorModule = app.getModule<DataGeneratorModule>('data_generator');
  if (dataGeneratorModule != null) {
    dataGeneratorModule.registerGenerator('mi_generador', miGenerador);
  }
}
```

### Paso 5: Probar el Plugin

Una vez implementado el plugin, puedes probarlo ejecutando:

```bash
dart run bin/generador_de_json.dart --list-plugins
```

Deberías ver tu plugin en la lista de plugins registrados.

## 📚 Ejemplos Prácticos

### Ejemplo 1: Plugin de Formateo de Fechas

Este plugin permite formatear fechas en diferentes formatos personalizados:

```dart
import 'package:generador_de_json/core/plugins/base_plugin.dart';
import 'package:generador_de_json/core/utils/logger.dart';

class DateFormatterPlugin extends BasePlugin {
  final Map<String, String Function(DateTime)> _formats = {};

  @override
  String get pluginId => 'com.ejemplo.date_formatter';

  @override
  String get pluginName => 'Formateador de Fechas';

  @override
  String get pluginDescription => 'Plugin para formatear fechas en diferentes formatos';

  @override
  String get pluginVersion => '1.0.0';

  @override
  String get pluginAuthor => 'Tu Nombre';

  @override
  void initialize() {
    AppLogger.info('Inicializando plugin: $pluginName');

    // Registrar formatos predeterminados
    registerFormat('iso', (date) => date.toIso8601String());
    registerFormat('dd/mm/yyyy', (date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}');
    registerFormat('yyyy-mm-dd', (date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}');
  }

  @override
  void registerFunctionalities() {
    AppLogger.debug('Registrando formateadores de fecha');
    // Código para registrar los formateadores con el sistema principal
  }

  void registerFormat(String formatName, String Function(DateTime date) formatter) {
    _formats[formatName] = formatter;
  }

  String formatDate(DateTime date, String format) {
    if (!_formats.containsKey(format)) {
      return date.toString();
    }
    return _formats[format]!(date);
  }

  List<String> get availableFormats => _formats.keys.toList();
}

DateFormatterPlugin createPlugin() {
  return DateFormatterPlugin();
}
```

### Ejemplo 2: Plugin de Generación de Datos Geográficos

Este plugin proporciona funciones para generar datos geográficos como coordenadas, direcciones, etc.:

```dart
import 'dart:math';
import 'package:generador_de_json/core/plugins/base_plugin.dart';
import 'package:generador_de_json/core/utils/logger.dart';

class GeoDataGeneratorPlugin extends BasePlugin {
  final Random _random = Random();

  @override
  String get pluginId => 'com.ejemplo.geo_data';

  @override
  String get pluginName => 'Generador de Datos Geográficos';

  @override
  String get pluginDescription => 'Plugin para generar datos geográficos';

  @override
  String get pluginVersion => '1.0.0';

  @override
  String get pluginAuthor => 'Tu Nombre';

  @override
  void initialize() {
    AppLogger.info('Inicializando plugin: $pluginName');
    // Inicialización del plugin
  }

  @override
  void registerFunctionalities() {
    AppLogger.debug('Registrando generadores de datos geográficos');
    // Registrar los generadores con el sistema principal
  }

  Map<String, double> generateCoordinates({
    double minLat = -90.0,
    double maxLat = 90.0,
    double minLng = -180.0,
    double maxLng = 180.0,
  }) {
    final lat = minLat + _random.nextDouble() * (maxLat - minLat);
    final lng = minLng + _random.nextDouble() * (maxLng - minLng);

    return {
      'latitude': double.parse(lat.toStringAsFixed(6)),
      'longitude': double.parse(lng.toStringAsFixed(6)),
    };
  }

  String generateAddress() {
    final streetNames = ['Main St', 'Oak Ave', 'Maple Rd', 'Cedar Blvd'];
    final cities = ['Springfield', 'Rivertown', 'Oakville', 'Maplewood'];

    final streetNumber = _random.nextInt(200) + 1;
    final streetName = streetNames[_random.nextInt(streetNames.length)];
    final city = cities[_random.nextInt(cities.length)];

    return '$streetNumber $streetName, $city';
  }
}

GeoDataGeneratorPlugin createPlugin() {
  return GeoDataGeneratorPlugin();
}
```

### Ejemplo 3: Plugin de Formato de Salida Personalizado

Este plugin añade un nuevo formato de salida (CSV) al generador:

```dart
import 'package:generador_de_json/core/plugins/base_plugin.dart';
import 'package:generador_de_json/core/utils/logger.dart';
import 'package:generador_de_json/core/formatters/formatter_registry.dart';

class CsvFormatterPlugin extends BasePlugin {
  @override
  String get pluginId => 'com.ejemplo.csv_formatter';

  @override
  String get pluginName => 'Formateador CSV';

  @override
  String get pluginDescription => 'Plugin para formatear datos en CSV';

  @override
  String get pluginVersion => '1.0.0';

  @override
  String get pluginAuthor => 'Tu Nombre';

  @override
  void initialize() {
    AppLogger.info('Inicializando plugin: $pluginName');
  }

  @override
  void registerFunctionalities() {
    AppLogger.debug('Registrando formateador CSV');

    // Obtener el registro de formatos
    final formatterRegistry = FormatterRegistry();

    // Registrar el formateador CSV
    formatterRegistry.registerFormatter('CSV', _formatToCsv);
  }

  String _formatToCsv(dynamic data, {String indent = ''}) {
    if (data is Map<String, dynamic>) {
      // Convertir el mapa a CSV
      final headers = data.keys.join(',');
      final values = data.values.map((v) => _formatValue(v)).join(',');
      return '$headers\n$values';
    } else if (data is List) {
      // Convertir la lista a CSV
      if (data.isEmpty) return '';

      // Si es una lista de mapas, extraer las claves del primer elemento
      if (data.first is Map<String, dynamic>) {
        final maps = data.cast<Map<String, dynamic>>();
        final headers = maps.first.keys.join(',');
        final rows = maps.map((map) =>
          map.values.map((v) => _formatValue(v)).join(',')
        ).join('\n');

        return '$headers\n$rows';
      } else {
        // Lista de valores simples
        return data.map((v) => _formatValue(v)).join('\n');
      }
    }

    return data.toString();
  }

  String _formatValue(dynamic value) {
    if (value == null) return '';
    if (value is String) return '"${value.replaceAll('"', '""')}"';
    if (value is DateTime) return value.toIso8601String();
    return value.toString();
  }
}

CsvFormatterPlugin createPlugin() {
  return CsvFormatterPlugin();
}
```

## 🏆 Mejores Prácticas

Para crear plugins de alta calidad:

1. **Sigue el Principio de Responsabilidad Única**: Cada plugin debe tener un propósito claro y específico.
2. **Documenta tu Código**: Añade comentarios y documentación para que otros desarrolladores entiendan tu plugin.
3. **Maneja Errores Adecuadamente**: Captura y registra errores para facilitar la depuración.
4. **Valida Entradas**: Verifica que las entradas a tus métodos sean válidas.
5. **Evita Dependencias Innecesarias**: Limita las dependencias externas para mantener el plugin ligero.
6. **Implementa Tests**: Asegúrate de que tu plugin funcione correctamente en diferentes escenarios.
7. **Respeta las Convenciones**: Sigue las convenciones de codificación de Dart y del proyecto.

## 🛠️ Solución de Problemas

### El plugin no aparece en la lista

- Verifica que el archivo `manifest.json` esté correctamente formateado
- Asegúrate de que el plugin esté en el directorio correcto (`plugins/`)
- Confirma que la función `createPlugin()` esté implementada y expuesta correctamente

### Errores durante la inicialización

- Revisa los logs para ver mensajes de error específicos
- Verifica que todas las dependencias del plugin estén disponibles
- Comprueba que el plugin sea compatible con la versión actual del generador

### Conflictos entre plugins

- Asegúrate de que los ID de los plugins sean únicos
- Evita sobreescribir funcionalidades de otros plugins sin coordinación
- Utiliza espacios de nombres específicos para tus características

## 📖 Referencia de la API

### Interfaces Principales

#### PluginInterface

```dart
abstract class PluginInterface {
  String get pluginId;
  String get pluginName;
  String get pluginDescription;
  String get pluginVersion;
  String get pluginAuthor;
  void initialize();
  void registerFunctionalities();
  bool isEnabled();
  Map<String, dynamic> get pluginConfig;
  List<String> get dependencies;
}
```

#### BasePlugin

```dart
abstract class BasePlugin implements PluginInterface {
  @override
  String get pluginVersion => '1.0.0';

  @override
  String get pluginAuthor => 'Desconocido';

  @override
  bool isEnabled() => true;

  @override
  Map<String, dynamic> get pluginConfig => {};

  @override
  List<String> get dependencies => [];

  @override
  void initialize();

  @override
  void registerFunctionalities();

  bool isCompatibleWithHost(String hostVersion) => true;
}
```

### Clases de Utilidad

#### PluginRegistry

- `registerPlugin(PluginInterface plugin)`: Registra un plugin en el sistema
- `getPlugin<T extends PluginInterface>(String pluginId)`: Obtiene un plugin por su ID
- `hasPlugin(String pluginId)`: Verifica si un plugin está registrado
- `allPlugins`: Lista todos los plugins registrados
- `pluginIds`: Lista los IDs de todos los plugins registrados
- `pluginsInfo`: Obtiene información detallada sobre todos los plugins

#### PluginLoader

- `loadPluginManifest(String pluginDir)`: Carga el manifiesto de un plugin
- `ensurePluginDirectory()`: Asegura que exista el directorio de plugins
- `createExamplePlugin()`: Crea un plugin de ejemplo

### Excepciones

- `PluginException`: Clase base para excepciones relacionadas con plugins
  - `loadError`: Error al cargar un plugin
  - `initializationError`: Error al inicializar un plugin
  - `pluginNotFound`: Plugin no encontrado
  - `dependencyError`: Error de dependencia
  - `incompatibleVersion`: Versión incompatible
  - `configurationError`: Error de configuración
