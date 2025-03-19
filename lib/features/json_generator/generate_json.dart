import 'dart:convert';
import 'dart:math';

import 'package:generador_de_json/app.dart';
import 'package:generador_de_json/core/config/app_config.dart';
import 'package:generador_de_json/core/exceptions/exceptions.dart';
import 'package:generador_de_json/core/interfaces/json_generator_interface.dart';
import 'package:generador_de_json/core/utils/file_utils.dart';
import 'package:generador_de_json/core/utils/logger.dart';
import 'package:generador_de_json/core/utils/validators.dart';

class GenerateJson implements JsonGeneratorInterface {
  /// Configuración de la aplicación
  final AppConfig _config = App().config;

  /// Metodo que genera una lista de datos en un json, para usarlo de forma
  /// correecta, en el parametro [jsonMap] se debe pasar una funcion que
  /// retorne una lista de mapas, se debe usar un [List.generate()] como se muestra en el siguiente ejemplo:
  ///```dart
  ///   List.generate(
  ///   100,
  ///   (index) => <String, dynamic>{
  ///     'id': index,
  ///     'name': util.generateRandomFemaleOrMaleName(isFullName: true),
  ///     'email': util.generateRandomEmail(),
  ///     'avatar': util.generateRandomAvatarUrl(),
  ///   },
  /// );
  ///```
  @override
  void generateJsonList({
    /// Nombre del archivo json a generar, para poder generar una lista de forma correcta
    required String jsonName,

    /// Mapa de datos que se van a generar en el json
    required Function(List<Map<String, dynamic>> data) jsonMap,
    bool addIdAutoincrement = false,
    int? recordCount,
  }) {
    // Validaciones de parámetros de entrada
    AppLogger.debug('Iniciando generación de lista JSON: $jsonName');
    AppLogger.debug('Validando parámetros de entrada');

    Validators.validateNotEmpty(jsonName, 'jsonName');
    Validators.validateFileName(jsonName);
    Validators.validateJsonMapFunction(jsonMap, 'jsonMap');

    // Utilizar la configuración para determinar la cantidad de registros
    final recordsToGenerate = recordCount ?? _config.defaultRecordCount;
    AppLogger.debug('Generando $recordsToGenerate registros');

    try {
      AppLogger.debug('Generando lista de datos JSON');

      // Accede a la variable data de la funcion jsonMap
      final List<Map<String, dynamic>> data = jsonMap([]);

      // Validación de los datos generados
      AppLogger.debug('Validando datos generados (${data.length} elementos)');
      Validators.validateJsonDataList(data);

      // Procesamiento adicional si se requiere auto-incremento de ID
      if (addIdAutoincrement && data.isNotEmpty) {
        AppLogger.debug('Aplicando auto-incremento de ID a ${data.length} elementos');
        for (var i = 0; i < data.length; i++) {
          data[i]['id'] = i;
        }
      }

      // Aplicar timestamp al nombre del archivo si está configurado
      final effectiveJsonName = _config.getFileNameWithTimestamp(jsonName);
      AppLogger.debug('Nombre efectivo del archivo: $effectiveJsonName');

      AppLogger.debug('Convirtiendo y guardando lista JSON: $effectiveJsonName');
      _convertAndSaveJson(jsonName: effectiveJsonName, data: data);
      AppLogger.info('Lista JSON generada exitosamente: $effectiveJsonName (${data.length} elementos)');
    } catch (e) {
      AppLogger.error('Error al generar lista JSON: $jsonName', e, StackTrace.current);
      if (e is JsonGeneratorException) {
        rethrow;
      }
      throw JsonGeneratorException.invalidFormat(
        'Error al generar la lista de datos: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Metodo que genera un json con un solo dato, para usarlo de forma
  /// correecta, en el parametro [jsonMap] se debe pasar una funcion que
  /// retorne un mapa, como se muestra en el siguiente ejemplo:
  ///```dart
  ///   <String, dynamic>{
  ///    'id': 1,
  ///    'name': util.generateRandomFemaleOrMaleName(isFullName: true),
  ///    'email': util.generateRandomEmail(),
  ///    'avatar': util.generateRandomAvatarUrl(),
  /// };
  /// ```
  @override
  void generateJson({
    /// Nombre del archivo json a generar, para poder generar una lista de forma correcta
    required String jsonName,

    /// Mapa de datos que se van a generar en el json
    required Function(Map<String, dynamic> data) jsonMap,
    int? seed,
  }) {
    try {
      AppLogger.debug('Iniciando generación de JSON: $jsonName');
      AppLogger.debug('Validando parámetros de entrada');

      // Validación de parámetros
      Validators.validateNotEmpty(jsonName, 'jsonName');
      Validators.validateFileName(jsonName);
      Validators.validateNotNull(jsonMap, 'jsonMap');

      // Objeto para almacenar los datos generados
      final Map<String, dynamic> data = {};

      // Configuración de la semilla para generación aleatoria
      if (seed != null) {
        AppLogger.debug('Utilizando semilla para generación aleatoria: $seed');
        Random(seed); // Crear un nuevo generador con semilla específica
      }

      // Generar datos con la función proporcionada
      AppLogger.debug('Generando datos JSON');
      final jsonData = jsonMap(data);

      // Validación de datos generados
      AppLogger.debug('Validando datos generados');
      Validators.validateNotNull(jsonData, 'jsonData');
      Validators.validateJsonData(jsonData);

      // Aplicar timestamp al nombre del archivo si está configurado
      final effectiveJsonName = _config.getFileNameWithTimestamp(jsonName);
      AppLogger.debug('Nombre efectivo del archivo: $effectiveJsonName');

      // Convertir y guardar los datos como JSON
      AppLogger.debug('Convirtiendo y guardando JSON: $effectiveJsonName');
      _convertAndSaveJson(jsonName: effectiveJsonName, data: jsonData);
      AppLogger.info('JSON generado exitosamente: $effectiveJsonName');
    } catch (e) {
      AppLogger.error('Error al generar JSON: $jsonName', e, StackTrace.current);
      if (e is BaseException) {
        rethrow;
      }
      throw JsonGeneratorException.invalidFormat('Error al generar JSON: ${e.toString()}', originalError: e);
    }
  }

  /// Método que convierte un mapa en un archivo json y lo guarda en la ruta especificada
  ///
  /// Este método maneja de forma robusta los errores de escritura de archivos
  String _convertAndSaveJson({required String jsonName, required Object data}) {
    // Validaciones de parámetros
    AppLogger.debug('Validando parámetros para conversión y guardado');
    Validators.validateNotEmpty(jsonName, 'jsonName');
    Validators.validateNotNull(data, 'data');

    String outputPath = '';

    try {
      // 1. Preparar la ruta de salida usando la configuración
      outputPath = _config.getOutputFilePath('$jsonName.json');
      AppLogger.debug('Ruta de salida: $outputPath');

      // 2. Validar que la ruta sea segura
      AppLogger.debug('Validando seguridad de la ruta');
      FileUtils.validateSafePath(outputPath);

      // 3. Extraer el directorio de la ruta de salida
      final lastSeparatorIndex = outputPath.lastIndexOf('/');
      final directoryPath =
          lastSeparatorIndex != -1 ? outputPath.substring(0, lastSeparatorIndex + 1) : _config.outputPath;

      // 4. Asegurar que el directorio existe
      AppLogger.debug('Verificando directorio de salida: $directoryPath');
      final directory = FileUtils.ensureDirectoryExists(directoryPath);

      // 5. Verificar permisos de escritura
      AppLogger.debug('Verificando permisos de escritura: ${directory.path}');
      FileUtils.verifyWritePermissions(directory.path);

      // 6. Convertir a JSON con formato adecuado
      AppLogger.debug('Convirtiendo datos a formato JSON');
      String jsonString;
      try {
        // Usar el formato de indentación configurado
        jsonString = JsonEncoder.withIndent(_config.jsonIndent).convert(data);
        AppLogger.debug('Datos convertidos exitosamente, tamaño: ${jsonString.length} caracteres');
      } catch (e) {
        AppLogger.error('Error al convertir a formato JSON', e, StackTrace.current);
        throw JsonGeneratorException.jsonConversionError(originalError: 'Error al convertir a formato JSON: $e');
      }

      // 7. Escribir el archivo
      AppLogger.debug('Escribiendo archivo: $outputPath');
      final file = FileUtils.writeFile(outputPath, jsonString);

      // 8. Reportar éxito
      final successMsg = 'Archivo json $jsonName, fue generado en la ruta ${file.path}';
      print(successMsg);
      AppLogger.info(successMsg);
      return file.path;
    } catch (e) {
      // Manejo centralizado de excepciones
      AppLogger.error('Error al convertir o guardar JSON', e, StackTrace.current);
      if (e is JsonGeneratorException) {
        rethrow;
      }
      if (e is FormatException) {
        throw JsonGeneratorException.jsonConversionError(originalError: e);
      }
      throw JsonGeneratorException.fileWriteError(
        outputPath.isNotEmpty ? outputPath : '${_config.outputPath}$jsonName.json',
        originalError: e,
      );
    }
  }
}
