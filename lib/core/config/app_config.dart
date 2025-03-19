import 'dart:convert';
import 'dart:io';

import 'package:generador_de_json/core/constants/app_constants.dart';
import 'package:generador_de_json/core/exceptions/exceptions.dart';
import 'package:generador_de_json/core/utils/logger.dart';

/// Enum para los formatos de fecha
enum DateFormat {
  iso8601, // 2024-03-18T23:30:45.123Z
  shortDate, // 18/03/2024
  longDate, // 18 de marzo de 2024
  timeOnly, // 23:30:45
  usFormat, // 03/18/2024
  customFormat, // Formato personalizado
}

/// Enum para tipos de generación de datos
enum DataGenerationType {
  fully_random, // Datos totalmente aleatorios
  consistent, // Datos consistentes entre ejecuciones (misma semilla)
  realistic, // Datos realistas y coherentes
}

/// Clase que maneja la configuración de la aplicación
class AppConfig {
  /// Instancia singleton
  static final AppConfig _instance = AppConfig._internal();

  /// Constructor de fábrica para obtener la instancia
  factory AppConfig() {
    return _instance;
  }

  /// Constructor interno
  AppConfig._internal();

  /// Ruta de salida para los archivos generados
  String outputPath = AppConstants.outputBasePath;

  /// Cantidad de registros a generar por defecto
  int defaultRecordCount = 100;

  /// Formato de indentación para los archivos JSON
  String jsonIndent = '  ';

  /// Indica si se debe añadir información de timestamp a los archivos generados
  bool addTimestampToFiles = false;

  /// Formato de fecha a utilizar
  String dateFormat = 'iso8601';

  /// Formato personalizado para fechas
  String customDateFormat = 'yyyy-MM-dd HH:mm:ss';

  /// Zona horaria a utilizar en las fechas
  String timeZone = 'UTC';

  /// Tipo de generación de datos
  String dataGenerationType = 'realistic';

  /// Semilla para la generación de datos aleatorios (para resultados consistentes)
  int? randomSeed;

  /// Extensión de archivo para los datos generados
  String fileExtension = 'json';

  /// Codificación de caracteres para los archivos generados
  String encoding = 'utf-8';

  /// Nombre de archivo por defecto para un solo objeto
  String defaultSingleObjectFileName = 'object';

  /// Nombre de archivo por defecto para listas de objetos
  String defaultListFileName = 'list';

  /// Tamaño máximo de archivo permitido (en bytes)
  int maxFileSize = 10 * 1024 * 1024; // 10MB por defecto

  /// Caché habilitada para la generación de datos (mejora rendimiento)
  bool enableDataCache = true;

  /// Nivel de log
  String logLevel = 'info';

  /// Activa o desactiva el logging a archivo
  bool logToFile = true;

  /// Activa o desactiva el logging a consola
  bool logToConsole = true;

  /// Nombre del archivo de configuración
  static const String _configFileName = 'config.json';

  /// Ruta del archivo de configuración
  static final String _configFilePath = '${AppConstants.configBasePath}$_configFileName';

  /// Directorio donde se almacenan los templates personalizados
  String templatesDirectory = 'templates';

  /// Template por defecto a utilizar para generación
  String defaultTemplate = '';

  /// Indica si se deben validar los datos generados contra el template
  bool validateTemplateData = true;

  /// Indica si se permite la generación de datos sin template
  bool allowGenerationWithoutTemplate = true;

  /// Carga la configuración desde el archivo
  void loadConfig() {
    try {
      final configFile = File(_configFilePath);

      // Si el archivo no existe, guardamos la configuración por defecto
      if (!configFile.existsSync()) {
        AppLogger.info('Archivo de configuración no encontrado. Creando configuración por defecto.');
        saveConfig();
        return;
      }

      // Leer el archivo de configuración
      final String jsonContent = configFile.readAsStringSync();
      AppLogger.debug('Configuración cargada desde: $_configFilePath');

      // Convertir el contenido a un mapa
      final Map<String, dynamic> configMap = json.decode(jsonContent);

      // Actualizar la configuración con los valores del archivo
      _updateFromMap(configMap);

      AppLogger.info('Configuración cargada correctamente');
    } catch (e) {
      AppLogger.error('Error al cargar la configuración', e, StackTrace.current);
      // Si hay un error, usamos los valores por defecto
      throw AppException.configurationError(
        'Error al cargar la configuración. Se usarán los valores por defecto.',
        originalError: e,
      );
    }
  }

  /// Guarda la configuración actual en el archivo
  void saveConfig() {
    try {
      // Crear el directorio de configuración si no existe
      final configDir = Directory(AppConstants.configBasePath);
      if (!configDir.existsSync()) {
        configDir.createSync(recursive: true);
      }

      // Convertir la configuración a JSON
      final Map<String, dynamic> configMap = toMap();
      final String jsonContent = const JsonEncoder.withIndent('  ').convert(configMap);

      // Escribir el archivo
      final configFile = File(_configFilePath);
      configFile.writeAsStringSync(jsonContent);

      AppLogger.info('Configuración guardada en: $_configFilePath');
    } catch (e) {
      AppLogger.error('Error al guardar la configuración', e, StackTrace.current);
      throw AppException.configurationError('Error al guardar la configuración.', originalError: e);
    }
  }

  /// Convierte la configuración a un mapa
  Map<String, dynamic> toMap() {
    return {
      'outputPath': outputPath,
      'defaultRecordCount': defaultRecordCount,
      'jsonIndent': jsonIndent,
      'addTimestampToFiles': addTimestampToFiles,
      'dates': {'format': dateFormat, 'customFormat': customDateFormat, 'timeZone': timeZone},
      'generation': {'type': dataGenerationType, 'seed': randomSeed, 'enableCache': enableDataCache},
      'files': {
        'extension': fileExtension,
        'encoding': encoding,
        'defaultSingleName': defaultSingleObjectFileName,
        'defaultListName': defaultListFileName,
        'maxSize': maxFileSize,
      },
      'templates': {
        'directory': templatesDirectory,
        'defaultTemplate': defaultTemplate,
        'validateData': validateTemplateData,
        'allowWithoutTemplate': allowGenerationWithoutTemplate,
      },
      'logging': {'level': logLevel, 'toFile': logToFile, 'toConsole': logToConsole},
    };
  }

  /// Actualiza la configuración desde un mapa
  void _updateFromMap(Map<String, dynamic> configMap) {
    outputPath = configMap['outputPath'] ?? outputPath;
    defaultRecordCount = configMap['defaultRecordCount'] ?? defaultRecordCount;
    jsonIndent = configMap['jsonIndent'] ?? jsonIndent;
    addTimestampToFiles = configMap['addTimestampToFiles'] ?? addTimestampToFiles;

    // Configuración de fechas
    if (configMap.containsKey('dates')) {
      final datesConfig = configMap['dates'];
      if (datesConfig is Map) {
        dateFormat = datesConfig['format'] ?? dateFormat;
        customDateFormat = datesConfig['customFormat'] ?? customDateFormat;
        timeZone = datesConfig['timeZone'] ?? timeZone;
      }
    }

    // Configuración de generación
    if (configMap.containsKey('generation')) {
      final genConfig = configMap['generation'];
      if (genConfig is Map) {
        dataGenerationType = genConfig['type'] ?? dataGenerationType;
        randomSeed = genConfig['seed']; // Puede ser null
        enableDataCache = genConfig['enableCache'] ?? enableDataCache;
      }
    }

    // Configuración de archivos
    if (configMap.containsKey('files')) {
      final filesConfig = configMap['files'];
      if (filesConfig is Map) {
        fileExtension = filesConfig['extension'] ?? fileExtension;
        encoding = filesConfig['encoding'] ?? encoding;
        defaultSingleObjectFileName = filesConfig['defaultSingleName'] ?? defaultSingleObjectFileName;
        defaultListFileName = filesConfig['defaultListName'] ?? defaultListFileName;
        maxFileSize = filesConfig['maxSize'] ?? maxFileSize;
      }
    }

    // Configuración de templates
    if (configMap.containsKey('templates')) {
      final templateConfig = configMap['templates'];
      if (templateConfig is Map) {
        templatesDirectory = templateConfig['directory'] ?? templatesDirectory;
        defaultTemplate = templateConfig['defaultTemplate'] ?? defaultTemplate;
        validateTemplateData = templateConfig['validateData'] ?? validateTemplateData;
        allowGenerationWithoutTemplate = templateConfig['allowWithoutTemplate'] ?? allowGenerationWithoutTemplate;
      }
    }

    // Configuración de logging
    if (configMap.containsKey('logging')) {
      final loggingConfig = configMap['logging'];
      if (loggingConfig is Map) {
        logLevel = loggingConfig['level'] ?? logLevel;
        logToFile = loggingConfig['toFile'] ?? logToFile;
        logToConsole = loggingConfig['toConsole'] ?? logToConsole;
      }
    }
  }

  /// Obtiene el nivel de log basado en la configuración
  dynamic getLogLevel() {
    switch (logLevel.toLowerCase()) {
      case 'debug':
        return LogLevel.debug;
      case 'info':
        return LogLevel.info;
      case 'warning':
        return LogLevel.warning;
      case 'error':
        return LogLevel.error;
      case 'fatal':
        return LogLevel.fatal;
      default:
        return LogLevel.info;
    }
  }

  /// Obtiene el nombre de archivo con timestamp si está configurado
  String getFileNameWithTimestamp(String baseName) {
    if (addTimestampToFiles) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return '${baseName}_$timestamp';
    }
    return baseName;
  }

  /// Obtiene la ruta completa para un archivo
  String getOutputFilePath(String fileName) {
    // Asegurar que el nombre tenga la extensión correcta
    final String nameWithExtension = !fileName.endsWith('.$fileExtension') ? '$fileName.$fileExtension' : fileName;

    if (!outputPath.endsWith('/') && !outputPath.endsWith('\\')) {
      return '$outputPath/$nameWithExtension';
    }
    return '$outputPath$nameWithExtension';
  }

  /// Formatea una fecha según la configuración
  String formatDate(DateTime date) {
    switch (dateFormat) {
      case 'iso8601':
        return date.toIso8601String();
      case 'shortDate':
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      case 'longDate':
        final months = [
          'enero',
          'febrero',
          'marzo',
          'abril',
          'mayo',
          'junio',
          'julio',
          'agosto',
          'septiembre',
          'octubre',
          'noviembre',
          'diciembre',
        ];
        return '${date.day} de ${months[date.month - 1]} de ${date.year}';
      case 'timeOnly':
        return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
      case 'usFormat':
        return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
      case 'customFormat':
        return _applyCustomDateFormat(date, customDateFormat);
      default:
        return date.toIso8601String();
    }
  }

  /// Aplica un formato personalizado a una fecha
  String _applyCustomDateFormat(DateTime date, String format) {
    // Implementación básica de formato personalizado
    String result = format;

    // Año
    result = result.replaceAll('yyyy', date.year.toString());
    result = result.replaceAll('yy', date.year.toString().substring(2));

    // Mes
    result = result.replaceAll('MM', date.month.toString().padLeft(2, '0'));
    result = result.replaceAll('M', date.month.toString());

    // Día
    result = result.replaceAll('dd', date.day.toString().padLeft(2, '0'));
    result = result.replaceAll('d', date.day.toString());

    // Hora
    result = result.replaceAll('HH', date.hour.toString().padLeft(2, '0'));
    result = result.replaceAll('H', date.hour.toString());

    // Minuto
    result = result.replaceAll('mm', date.minute.toString().padLeft(2, '0'));
    result = result.replaceAll('m', date.minute.toString());

    // Segundo
    result = result.replaceAll('ss', date.second.toString().padLeft(2, '0'));
    result = result.replaceAll('s', date.second.toString());

    return result;
  }

  /// Obtiene una semilla para generación de datos aleatorios
  int getSeed() {
    return randomSeed ?? DateTime.now().millisecondsSinceEpoch;
  }

  /// Comprueba si se debe utilizar caché para datos
  bool shouldUseCache() {
    return enableDataCache;
  }

  /// Valida que el tamaño del archivo no exceda el máximo configurado
  bool isValidFileSize(int fileSizeInBytes) {
    return fileSizeInBytes <= maxFileSize;
  }

  /// Obtiene la ruta completa del directorio de templates
  String getTemplatesDirectoryPath() {
    if (templatesDirectory.startsWith('/') || templatesDirectory.contains(':')) {
      // Es una ruta absoluta
      return templatesDirectory;
    }

    // Es una ruta relativa
    final String appDirectory = Directory.current.path;
    return '$appDirectory${Platform.pathSeparator}$templatesDirectory';
  }

  /// Verifica si se debe usar un template específico
  bool shouldUseTemplate() {
    return defaultTemplate.isNotEmpty;
  }

  /// Verifica si se permite la generación sin template
  bool isGenerationWithoutTemplateAllowed() {
    return allowGenerationWithoutTemplate;
  }
}
