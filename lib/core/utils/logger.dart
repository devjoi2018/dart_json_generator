import 'dart:io';
import 'package:logging/logging.dart';
import 'package:generador_de_json/core/constants/app_constants.dart';

/// Niveles de log personalizados para la aplicación
class LogLevel {
  static const Level debug = Level('DEBUG', 500);
  static const Level info = Level.INFO;
  static const Level warning = Level.WARNING;
  static const Level error = Level.SEVERE;
  static const Level fatal = Level('FATAL', 1200);
}

/// Gestor centralizado de logging para la aplicación
class AppLogger {
  /// Directorio donde se guardarán los archivos de log
  static const String _logDirectory = 'logs';

  /// Nombre del archivo de log
  static const String _logFileName = 'app.log';

  /// Instancia del logger
  static late Logger _logger;

  /// Archivo para guardar los logs
  static IOSink? _logFile;

  /// Indica si el logger ha sido inicializado
  static bool _initialized = false;

  /// Nivel actual de logging
  static Level _currentLevel = LogLevel.info;

  /// Inicializa el sistema de logging
  static void init({Level logLevel = LogLevel.info, bool logToFile = true, bool logToConsole = true}) {
    if (_initialized) return;

    _currentLevel = logLevel;

    // Configurar el logger
    Logger.root.level = _currentLevel;

    // Añadir manejadores de log según configuración
    if (logToConsole) {
      Logger.root.onRecord.listen(_logToConsole);
    }

    if (logToFile) {
      _setupLogFile();
      Logger.root.onRecord.listen(_logToFile);
    }

    // Crear logger específico para la aplicación
    _logger = Logger(AppConstants.appName);

    _initialized = true;

    // Registrar información inicial
    info(
      'Logger inicializado - Nivel: ${_currentLevel.name}, App: ${AppConstants.appName} v${AppConstants.appVersion}',
    );
  }

  /// Configura el archivo de log
  static void _setupLogFile() {
    try {
      // Crear directorio si no existe
      final logDir = Directory(_logDirectory);
      if (!logDir.existsSync()) {
        logDir.createSync(recursive: true);
      }

      // Abrir archivo de log (o crearlo si no existe)
      final file = File('$_logDirectory/$_logFileName');
      _logFile = file.openWrite(mode: FileMode.append);
    } catch (e) {
      print('ERROR: No se pudo configurar el archivo de log: $e');
    }
  }

  /// Cierra el sistema de logging y los recursos asociados
  static void close() {
    try {
      if (_logFile != null) {
        _logFile!.flush();
        _logFile!.close();
        _logFile = null;
      }
    } catch (e) {
      print('ERROR: No se pudo cerrar el archivo de log: $e');
    }
  }

  /// Escribe un mensaje en la consola
  static void _logToConsole(LogRecord record) {
    final message = _formatLogMessage(record);

    // Dar formato según el nivel para mejor visualización
    if (record.level >= LogLevel.error) {
      // Errores en rojo (solo para plataformas que lo soporten)
      print('\x1B[31m$message\x1B[0m');
    } else if (record.level >= LogLevel.warning) {
      // Warnings en amarillo (solo para plataformas que lo soporten)
      print('\x1B[33m$message\x1B[0m');
    } else {
      print(message);
    }
  }

  /// Escribe un mensaje en el archivo de log
  static void _logToFile(LogRecord record) {
    if (_logFile != null) {
      try {
        _logFile!.writeln(_formatLogMessage(record, includeStackTrace: true));
      } catch (e) {
        print('ERROR: No se pudo escribir en el archivo de log: $e');
      }
    }
  }

  /// Formatea un mensaje de log
  static String _formatLogMessage(LogRecord record, {bool includeStackTrace = false}) {
    final timestamp = record.time.toIso8601String();
    final level = record.level.name.padRight(7);
    final loggerName = record.loggerName;
    final message = record.message;

    String formattedMessage = '[$timestamp] $level - [$loggerName] $message';

    // Añadir información del error si está disponible
    if (record.error != null) {
      formattedMessage += '\nError: ${record.error}';
    }

    // Añadir stack trace si está disponible y se solicita
    if (includeStackTrace && record.stackTrace != null) {
      formattedMessage += '\nStack Trace:\n${record.stackTrace}';
    }

    return formattedMessage;
  }

  /// Registra un mensaje de nivel debug
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.log(LogLevel.debug, message, error, stackTrace);
  }

  /// Registra un mensaje de nivel info
  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.log(LogLevel.info, message, error, stackTrace);
  }

  /// Registra un mensaje de nivel warning
  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.log(LogLevel.warning, message, error, stackTrace);
  }

  /// Registra un mensaje de nivel error
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.log(LogLevel.error, message, error, stackTrace);
  }

  /// Registra un mensaje de nivel fatal
  static void fatal(String message, [Object? error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.log(LogLevel.fatal, message, error, stackTrace);
  }

  /// Asegura que el logger esté inicializado
  static void _ensureInitialized() {
    if (!_initialized) {
      init();
    }
  }
}
