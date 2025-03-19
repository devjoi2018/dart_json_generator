import 'package:generador_de_json/app.dart';
import 'package:generador_de_json/core/config/app_config.dart';
import 'package:generador_de_json/core/exceptions/exceptions.dart';
import 'package:generador_de_json/core/formatters/formatter_registry.dart';
import 'package:generador_de_json/core/interfaces/json_generator_interface.dart';
import 'package:generador_de_json/core/utils/file_utils.dart';
import 'package:generador_de_json/core/utils/logger.dart';
import 'package:generador_de_json/core/utils/validators.dart';

class GenerateJson implements JsonGeneratorInterface {
  /// Configuración de la aplicación
  final AppConfig _config = App().config;

  /// Registro de formatos de salida
  final FormatterRegistry _formatterRegistry = FormatterRegistry();

  /// Metodo que genera una lista de datos en formato especificado, para usarlo de forma
  /// correcta, en el parametro [jsonMap] se debe pasar una funcion que
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
    /// Nombre del archivo a generar
    required String jsonName,

    /// Mapa de datos que se van a generar
    required Function(List<Map<String, dynamic>> data) jsonMap,
    bool addIdAutoincrement = false,
    int? recordCount,
    String? format,
  }) {
    // Validaciones de parámetros de entrada
    AppLogger.debug('Iniciando generación de lista: $jsonName');
    AppLogger.debug('Validando parámetros de entrada');

    Validators.validateNotEmpty(jsonName, 'jsonName');
    Validators.validateFileName(jsonName);
    Validators.validateJsonMapFunction(jsonMap, 'jsonMap');

    // Utilizar la configuración para determinar la cantidad de registros
    final recordsToGenerate = recordCount ?? _config.defaultRecordCount;
    AppLogger.debug('Generando $recordsToGenerate registros');

    // Obtener el formato de salida
    final outputFormat = format ?? _config.outputFormat;
    final formatter = _formatterRegistry.getFormatter(outputFormat);
    final fileExtension = formatter.fileExtension;

    AppLogger.debug('Usando formato de salida: ${formatter.formatName}');

    try {
      // Generar datos usando la función proporcionada
      final data = jsonMap([]);
      AppLogger.debug('Datos generados por la función proporcionada');

      // Verificar que los datos sean válidos
      Validators.validateNotNull(data, 'Datos generados');
      if (data.isEmpty) {
        AppLogger.warning('No se generaron datos, el resultado está vacío');
      }

      // Verificar tamaño máximo
      Validators.validateDataSize(data, _config.maxFileSize, 'Lista de datos generada');

      // Añadir IDs autoincrementales si se solicita
      if (addIdAutoincrement) {
        AppLogger.debug('Añadiendo IDs autoincrementales');
        for (var i = 0; i < data.length; i++) {
          data[i]['id'] = data[i]['id'] ?? i;
        }
      }

      // Convertir a formato de salida
      AppLogger.debug('Convirtiendo datos a formato ${formatter.formatName}');
      final dataString = formatter.encode(data, indent: _config.jsonIndent.length);
      AppLogger.debug('Datos convertidos exitosamente, tamaño: ${dataString.length} bytes');

      // Guardar a archivo
      final fileName = _getFileName(jsonName, fileExtension);
      FileUtils.saveToFile(fileName, dataString, _config.outputPath);
      AppLogger.info('Archivo generado exitosamente: $fileName');
    } catch (e) {
      _handleError('Error al generar lista', e);
    }
  }

  /// Método que genera un objeto en el formato especificado
  @override
  void generateJson({
    /// Nombre del archivo a generar
    required String jsonName,

    /// Mapa de datos que se van a generar
    required Function(Map<String, dynamic> data) jsonMap,
    int? seed,
    String? format,
  }) {
    // Validaciones de parámetros de entrada
    AppLogger.debug('Iniciando generación de objeto: $jsonName');
    AppLogger.debug('Validando parámetros de entrada');

    Validators.validateNotEmpty(jsonName, 'jsonName');
    Validators.validateFileName(jsonName);
    Validators.validateJsonMapFunction(jsonMap, 'jsonMap');

    // Obtener el formato de salida
    final outputFormat = format ?? _config.outputFormat;
    final formatter = _formatterRegistry.getFormatter(outputFormat);
    final fileExtension = formatter.fileExtension;

    AppLogger.debug('Usando formato de salida: ${formatter.formatName}');

    try {
      // Generar datos usando la función proporcionada
      final data = jsonMap({});
      AppLogger.debug('Datos generados por la función proporcionada');

      // Verificar que los datos sean válidos
      Validators.validateNotNull(data, 'Datos generados');
      if (data.isEmpty) {
        AppLogger.warning('No se generaron datos, el resultado está vacío');
      }

      // Verificar tamaño máximo
      Validators.validateDataSize(data, _config.maxFileSize, 'Objeto de datos generado');

      // Convertir a formato de salida
      AppLogger.debug('Convirtiendo datos a formato ${formatter.formatName}');
      final dataString = formatter.encode(data, indent: _config.jsonIndent.length);
      AppLogger.debug('Datos convertidos exitosamente, tamaño: ${dataString.length} bytes');

      // Guardar a archivo
      final fileName = _getFileName(jsonName, fileExtension);
      FileUtils.saveToFile(fileName, dataString, _config.outputPath);
      AppLogger.info('Archivo generado exitosamente: $fileName');
    } catch (e) {
      _handleError('Error al generar objeto', e);
    }
  }

  /// Obtiene el nombre del archivo según la configuración
  String _getFileName(String baseName, String extension) {
    if (_config.addTimestampToFiles) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return '${baseName}_$timestamp.$extension';
    } else {
      return '$baseName.$extension';
    }
  }

  /// Maneja los errores generados durante la generación
  void _handleError(String message, dynamic error) {
    if (error is BaseException) {
      AppLogger.error('$message: ${error.message}', error, StackTrace.current);
      throw error;
    } else {
      final exception = JsonGeneratorException.generationError('$message: $error');
      AppLogger.error(exception.message, error, StackTrace.current);
      throw exception;
    }
  }
}
