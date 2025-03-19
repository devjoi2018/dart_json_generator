# Changelog

## 1.3.0 - 2025-03-19

### Generación de datos complejos

- Implementación de nuevos métodos en `DataGeneratorInterface` para tipos complejos: coordenadas geográficas, códigos postales, direcciones, teléfonos, colores, usernames, passwords, UUIDs, URLs y texto Lorem Ipsum
- Ampliación de `RandomDataGenerator` con listas de datos para calles, ciudades, provincias y palabras para texto
- Implementación de sistema de caché para optimizar rendimiento en generación de datos repetidos
- Adición de ejemplos prácticos: `coordinates_example.dart` para generación de datos geográficos en formato GeoJSON
- Adición de `complex_data_example.dart` para demostrar generación de objetos JSON con datos enriquecidos

### Sistema de versionado semántico

- Implementación de la clase `VersionUtil` para gestión de versiones según SemVer
- Creación del script `update_version.dart` para actualización automática de versiones
- Implementación de registro histórico de cambios en `CHANGELOG.md`
- Actualización de la versión en `pubspec.yaml` y `app_constants.dart`

### Documentación

- Actualización del README.md con secciones detalladas sobre nuevas funcionalidades
- Adición de ejemplos para generación de datos complejos y geográficos
- Mejora en la estructura del índice y organización del contenido

## 1.2.0 - 2025-03-18

### Compresión de archivos

- Implementación de la interfaz `CompressorInterface` para definir contratos de compresión
- Creación de `GzipCompressor` para compresión y descompresión de datos
- Implementación de `CompressorRegistry` para gestión de compresores
- Adición de `CompressionException` para manejo específico de errores
- Actualización de `FileUtils` con métodos para compresión y descompresión de archivos
- Integración de funcionalidad de compresión en el generador JSON
- Actualización de la configuración en `AppConfig` para soporte de compresión

### Validación de esquemas

- Implementación de `SchemaValidatorInterface` para validación de esquemas
- Creación de `JsonSchemaValidator` para validación de esquemas JSON
- Implementación de `SchemaValidatorRegistry` para gestión de validadores
- Adición de `SchemaValidationException` para manejo de errores de validación
- Actualización de configuración para incluir opciones de esquemas
- Integración de validación de esquemas en la aplicación principal

## 1.1.1 - 2025-03-15

### Mejoras y correcciones

- Correcciones de errores en el formateo XML
- Refactorización de `AppLogger` para mejorar la gestión de logs
- Optimizaciones de rendimiento en la generación de datos
- Mejoras en el manejo de excepciones y validación de datos

## 1.1.0 - 2025-03-10

### Múltiples formatos de salida

- Implementación de `OutputFormatInterface` para definir el contrato de formatos
- Creación de `JsonFormatter`, `XmlFormatter` y `YamlFormatter`
- Implementación de `FormatterRegistry` para gestión centralizada de formatos
- Actualización de `AppConfig` para soporte de múltiples formatos
- Adición de excepciones específicas para manejo de errores de formato

### Sistema de templates

- Implementación de `TemplateInterface` y clase base `BaseTemplate`
- Creación de templates predefinidos: `UserTemplate` y `ProductTemplate`
- Implementación de `TemplateRegistry` y `TemplateModule` para gestión de templates
- Creación de `TemplateManager` para integración con el generador JSON
- Adición de `TemplateException` para manejo de errores específicos
- Actualización de la configuración para soporte de templates
- Mejoras en documentación con ejemplos de uso de templates

## 1.0.0 - 2025-03-01

### Funcionalidades base

- Implementación de la arquitectura modular con `BaseModule` y `ModuleRegistry`
- Creación de `App` como punto central de la aplicación
- Implementación de `DataGeneratorInterface` y `RandomDataGenerator`
- Creación de `DataGeneratorFactory` para instanciación de generadores
- Implementación de `JsonGeneratorInterface` y `GenerateJson`
- Sistema de excepciones con `BaseException`, `AppException`, `DataGeneratorException` y `JsonGeneratorException`
- Implementación de utilidades: `FileUtils`, `Validators` y `AppLogger`
- Configuración inicial de la aplicación con `AppConfig` y `AppConstants`
- Documentación básica y estructura del proyecto
