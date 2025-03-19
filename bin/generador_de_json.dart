import 'package:generador_de_json/app.dart';
import 'package:generador_de_json/core/config/app_config.dart';
import 'package:generador_de_json/core/exceptions/exceptions.dart';
import 'package:generador_de_json/core/utils/logger.dart';
import 'package:generador_de_json/core/utils/validators.dart';

/// Ejecuta la aplicación con los argumentos proporcionados
void main(List<String> arguments) {
  // Instancia de la aplicación
  final app = App();

  try {
    // Configurar el sistema de logging
    AppLogger.init(logLevel: LogLevel.debug);
    AppLogger.info('Iniciando aplicación Dart JSON Generator');

    // Validación de argumentos
    final Map<String, dynamic> parsedArgs = validateArguments(arguments);

    // Inicializa la aplicación y sus módulos
    app.initialize();

    // Actualizar configuración según argumentos
    _updateConfigFromArgs(app.config, parsedArgs);

    // Obtiene los generadores a través de la aplicación
    AppLogger.debug('Obteniendo generadores');
    final dataGenerator = app.dataGenerator;
    final jsonGenerator = app.jsonGenerator;

    /// Ejemplo de como generar un json con un solo dato
    AppLogger.info('Generando ejemplo de JSON único');
    jsonGenerator.generateJson(
      jsonName: 'example',
      jsonMap: (Map<String, dynamic> data) {
        return <String, dynamic>{
          'id': 1,
          'name': dataGenerator.generateRandomFemaleOrMaleName(isFullName: true),
          'email': dataGenerator.generateRandomEmail(),
          'avatar': dataGenerator.generateRandomAvatarUrl(),
        };
      },
    );

    /// Ejemplo de como generar un json con una lista de datos
    AppLogger.info('Generando ejemplo de lista JSON');
    jsonGenerator.generateJsonList(
      jsonName: 'example_list',
      jsonMap: (List<Map<String, dynamic>> data) {
        return List.generate(
          app.config.defaultRecordCount,
          (index) => <String, dynamic>{
            'id': index,
            'name': dataGenerator.generateRandomFemaleOrMaleName(isFullName: true),
            'email': dataGenerator.generateRandomEmail(),
            'avatar': dataGenerator.generateRandomAvatarUrl(),
          },
        );
      },
    );

    AppLogger.info('Archivos JSON generados exitosamente');
    print('Archivos JSON generados exitosamente.');

    // Cerrar correctamente la aplicación y los recursos
    app.dispose();
  } catch (e) {
    if (e is BaseException) {
      final errorMsg = 'ERROR [${e.code}]: ${e.message}';
      AppLogger.error(errorMsg);
      print(errorMsg);

      if (e.originalError != null) {
        final causeMsg = 'Causa: ${e.originalError}';
        AppLogger.error(causeMsg);
        print(causeMsg);
      }
    } else {
      final errorMsg = 'ERROR no controlado: $e';
      AppLogger.error(errorMsg, e, StackTrace.current);
      print(errorMsg);
    }

    // Código de salida diferente de cero para indicar error
    exitWithError();
  } finally {
    // Asegurarse de cerrar el sistema de logging
    try {
      AppLogger.close();
    } catch (e) {
      print('Error al cerrar el logger: $e');
    }
  }
}

/// Actualiza la configuración según los argumentos
void _updateConfigFromArgs(AppConfig config, Map<String, dynamic> args) {
  // Configuración de ruta de salida
  if (args.containsKey('output')) {
    config.outputPath = args['output'] as String;
    AppLogger.info('Ruta de salida actualizada: ${config.outputPath}');
  }

  // Configuración de registros
  if (args.containsKey('records')) {
    config.defaultRecordCount = args['records'] as int;
    AppLogger.info('Cantidad de registros actualizada: ${config.defaultRecordCount}');
  }

  // Configuración de timestamp en archivos
  if (args.containsKey('timestamp')) {
    config.addTimestampToFiles = true;
    AppLogger.info('Timestamp en archivos habilitado');
  }

  // Configuración de indentación
  if (args.containsKey('indent')) {
    config.jsonIndent = args['indent'] as String;
    AppLogger.info('Indentación JSON actualizada: "${config.jsonIndent}"');
  }

  // Configuración de nivel de log
  if (args.containsKey('loglevel')) {
    config.logLevel = args['loglevel'] as String;
    AppLogger.info('Nivel de log actualizado: ${config.logLevel}');

    // Reinicializar el logger con la nueva configuración
    AppLogger.close();
    AppLogger.init(logLevel: config.getLogLevel(), logToFile: config.logToFile, logToConsole: config.logToConsole);
  }

  // Configuración de formato de fecha
  if (args.containsKey('dateformat')) {
    config.dateFormat = args['dateformat'] as String;
    AppLogger.info('Formato de fecha actualizado: ${config.dateFormat}');
  }

  // Configuración de formato personalizado de fecha
  if (args.containsKey('customdateformat')) {
    config.customDateFormat = args['customdateformat'] as String;
    AppLogger.info('Formato personalizado de fecha actualizado: ${config.customDateFormat}');
  }

  // Configuración de zona horaria
  if (args.containsKey('timezone')) {
    config.timeZone = args['timezone'] as String;
    AppLogger.info('Zona horaria actualizada: ${config.timeZone}');
  }

  // Configuración de tipo de generación de datos
  if (args.containsKey('gentype')) {
    config.dataGenerationType = args['gentype'] as String;
    AppLogger.info('Tipo de generación de datos actualizado: ${config.dataGenerationType}');
  }

  // Configuración de semilla para datos aleatorios
  if (args.containsKey('seed')) {
    config.randomSeed = args['seed'] as int;
    AppLogger.info('Semilla para datos aleatorios actualizada: ${config.randomSeed}');
  }

  // Configuración de extensión de archivo
  if (args.containsKey('ext')) {
    config.fileExtension = args['ext'] as String;
    AppLogger.info('Extensión de archivo actualizada: ${config.fileExtension}');
  }

  // Configuración de codificación
  if (args.containsKey('encoding')) {
    config.encoding = args['encoding'] as String;
    AppLogger.info('Codificación de caracteres actualizada: ${config.encoding}');
  }

  // Configuración de tamaño máximo de archivo
  if (args.containsKey('maxsize')) {
    final sizeInMB = args['maxsize'] as int;
    config.maxFileSize = sizeInMB * 1024 * 1024; // Convertir de MB a bytes
    AppLogger.info('Tamaño máximo de archivo actualizado: $sizeInMB MB');
  }

  // Configuración de caché
  if (args.containsKey('cache')) {
    config.enableDataCache = args['cache'] as bool;
    AppLogger.info('Caché ${config.enableDataCache ? "habilitada" : "deshabilitada"}');
  }
}

/// Valida los argumentos de la línea de comandos
Map<String, dynamic> validateArguments(List<String> arguments) {
  AppLogger.debug('Validando argumentos: ${arguments.length} argumento(s)');
  Validators.validateNotNull(arguments, 'arguments');

  // Mapa para almacenar los argumentos procesados
  final Map<String, dynamic> parsedArgs = {};

  // Procesar argumentos
  for (int i = 0; i < arguments.length; i++) {
    final arg = arguments[i];
    AppLogger.debug('Procesando argumento: $arg');

    if (arg.startsWith('--output=')) {
      // Ruta de salida personalizada
      final value = arg.substring('--output='.length);
      if (value.isNotEmpty) {
        parsedArgs['output'] = value;
        AppLogger.debug('Argumento output: $value');
      }
    } else if (arg.startsWith('--records=')) {
      // Cantidad de registros a generar
      final value = arg.substring('--records='.length);
      try {
        final recordCount = int.parse(value);
        if (recordCount > 0) {
          parsedArgs['records'] = recordCount;
          AppLogger.debug('Argumento records: $recordCount');
        } else {
          AppLogger.warning('Valor inválido para records: $value, debe ser mayor que 0');
        }
      } catch (e) {
        AppLogger.warning('Valor inválido para records: $value');
      }
    } else if (arg == '--timestamp') {
      // Habilitar timestamp en archivos
      parsedArgs['timestamp'] = true;
      AppLogger.debug('Argumento timestamp habilitado');
    } else if (arg.startsWith('--indent=')) {
      // Formato de indentación personalizado
      final value = arg.substring('--indent='.length);
      if (value.isNotEmpty) {
        parsedArgs['indent'] = value;
        AppLogger.debug('Argumento indent: "$value"');
      }
    } else if (arg.startsWith('--loglevel=')) {
      // Nivel de log
      final value = arg.substring('--loglevel='.length).toLowerCase();
      final validLevels = ['debug', 'info', 'warning', 'error', 'fatal'];
      if (validLevels.contains(value)) {
        parsedArgs['loglevel'] = value;
        AppLogger.debug('Argumento loglevel: $value');
      } else {
        AppLogger.warning('Nivel de log inválido: $value. Valores válidos: ${validLevels.join(", ")}');
      }
    } else if (arg.startsWith('--dateformat=')) {
      // Formato de fecha
      final value = arg.substring('--dateformat='.length);
      final validFormats = ['iso8601', 'shortDate', 'longDate', 'timeOnly', 'usFormat', 'customFormat'];
      if (validFormats.contains(value)) {
        parsedArgs['dateformat'] = value;
        AppLogger.debug('Argumento dateformat: $value');
      } else {
        AppLogger.warning('Formato de fecha inválido: $value. Valores válidos: ${validFormats.join(", ")}');
      }
    } else if (arg.startsWith('--customdateformat=')) {
      // Formato personalizado de fecha
      final value = arg.substring('--customdateformat='.length);
      if (value.isNotEmpty) {
        parsedArgs['customdateformat'] = value;
        AppLogger.debug('Argumento customdateformat: $value');
      }
    } else if (arg.startsWith('--timezone=')) {
      // Zona horaria
      final value = arg.substring('--timezone='.length);
      if (value.isNotEmpty) {
        parsedArgs['timezone'] = value;
        AppLogger.debug('Argumento timezone: $value');
      }
    } else if (arg.startsWith('--gentype=')) {
      // Tipo de generación de datos
      final value = arg.substring('--gentype='.length);
      final validTypes = ['fully_random', 'consistent', 'realistic'];
      if (validTypes.contains(value)) {
        parsedArgs['gentype'] = value;
        AppLogger.debug('Argumento gentype: $value');
      } else {
        AppLogger.warning('Tipo de generación inválido: $value. Valores válidos: ${validTypes.join(", ")}');
      }
    } else if (arg.startsWith('--seed=')) {
      // Semilla para generación de datos
      final value = arg.substring('--seed='.length);
      try {
        final seed = int.parse(value);
        parsedArgs['seed'] = seed;
        AppLogger.debug('Argumento seed: $seed');
      } catch (e) {
        AppLogger.warning('Valor inválido para seed: $value');
      }
    } else if (arg.startsWith('--ext=')) {
      // Extensión de archivo
      final value = arg.substring('--ext='.length);
      if (value.isNotEmpty && !value.contains('/') && !value.contains('\\')) {
        parsedArgs['ext'] = value;
        AppLogger.debug('Argumento ext: $value');
      } else {
        AppLogger.warning('Valor inválido para extensión: $value');
      }
    } else if (arg.startsWith('--encoding=')) {
      // Codificación de caracteres
      final value = arg.substring('--encoding='.length);
      final validEncodings = ['utf-8', 'ascii', 'latin1', 'utf-16'];
      if (validEncodings.contains(value.toLowerCase())) {
        parsedArgs['encoding'] = value.toLowerCase();
        AppLogger.debug('Argumento encoding: $value');
      } else {
        AppLogger.warning('Codificación inválida: $value. Valores válidos: ${validEncodings.join(", ")}');
      }
    } else if (arg.startsWith('--maxsize=')) {
      // Tamaño máximo de archivo (en MB)
      final value = arg.substring('--maxsize='.length);
      try {
        final size = int.parse(value);
        if (size > 0) {
          parsedArgs['maxsize'] = size;
          AppLogger.debug('Argumento maxsize: $size MB');
        } else {
          AppLogger.warning('Valor inválido para maxsize: $value, debe ser mayor que 0');
        }
      } catch (e) {
        AppLogger.warning('Valor inválido para maxsize: $value');
      }
    } else if (arg == '--cache') {
      // Habilitar caché
      parsedArgs['cache'] = true;
      AppLogger.debug('Argumento cache habilitado');
    } else if (arg == '--no-cache') {
      // Deshabilitar caché
      parsedArgs['cache'] = false;
      AppLogger.debug('Argumento cache deshabilitado');
    } else {
      AppLogger.warning('Argumento desconocido: $arg');
    }
  }

  return parsedArgs;
}

/// Finaliza la aplicación con código de error
void exitWithError() {
  final errorMsg = 'La aplicación finalizó con errores.';
  AppLogger.error(errorMsg);
  print(errorMsg);
}
