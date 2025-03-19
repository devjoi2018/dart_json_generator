import 'dart:convert';
import 'dart:io';
import 'package:generador_de_json/app.dart';
import 'package:generador_de_json/core/config/app_config.dart';
import 'package:generador_de_json/core/exceptions/exceptions.dart';
import 'package:generador_de_json/core/utils/logger.dart';
import 'package:generador_de_json/core/utils/validators.dart';
import 'package:generador_de_json/core/formatters/formatter_registry.dart';
import 'package:generador_de_json/core/compressors/compressor_registry.dart';
import 'package:generador_de_json/features/json_generator/generate_json.dart';

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

    // Verificar si se solicitó listar templates
    if (parsedArgs.containsKey('list_templates') && parsedArgs['list_templates'] == true) {
      _listAvailableTemplates(app);
      return;
    }

    // Verificar si se solicitó listar formatos
    if (parsedArgs.containsKey('list_formats') && parsedArgs['list_formats'] == true) {
      _listAvailableFormats(app);
      return;
    }

    // Verificar si se solicitó mostrar un esquema de template
    if (parsedArgs.containsKey('show_template_schema')) {
      final templateName = parsedArgs['show_template_schema'];
      _showTemplateSchema(app, templateName);
      return;
    }

    // Verificar si se solicitó listar formatos de esquema
    if (parsedArgs.containsKey('list_schema_formats') && parsedArgs['list_schema_formats'] == true) {
      _listAvailableSchemaFormats(app);
      return;
    }

    // Verificar si se solicitó generar un esquema
    if (parsedArgs.containsKey('generate_schema')) {
      final jsonFileName = parsedArgs['generate_schema'];
      _generateSchemaFromJson(app, jsonFileName);
      return;
    }

    // Verificar si se solicitó validar contra un esquema
    if (parsedArgs.containsKey('validate_schema')) {
      final schemaFile = parsedArgs['validate_schema'];
      final jsonFile = parsedArgs.containsKey('validate_json') ? parsedArgs['validate_json'] : null;
      _validateJsonAgainstSchema(app, schemaFile, jsonFile);
      return;
    }

    // Verificar si se solicitó listar formatos de compresión
    if (parsedArgs.containsKey('list_compress_formats') && parsedArgs['list_compress_formats'] == true) {
      _listAvailableCompressFormats(app);
      return;
    }

    // Determinar si usar un template
    String? templateToUse;
    if (parsedArgs.containsKey('template')) {
      templateToUse = parsedArgs['template'];
    } else if (app.config.shouldUseTemplate()) {
      templateToUse = app.config.defaultTemplate;
    }

    if (templateToUse != null && templateToUse.isNotEmpty) {
      _generateWithTemplate(app, jsonGenerator, templateToUse, parsedArgs);
      return;
    }

    // Si llegamos aquí, generamos los JSON estándar (sin template)
    /// Ejemplo de como generar un json con un solo dato
    AppLogger.info('Generando ejemplo de JSON único');

    // Obtener el formato de salida si se especificó
    String? format;
    if (parsedArgs.containsKey('format')) {
      format = parsedArgs['format'];
    }

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
      format: format,
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
      format: format,
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

  // Configuración de compresión
  if (args.containsKey('compress')) {
    config.enableCompression = args['compress'] as bool;
    AppLogger.info('Compresión de archivos ${config.enableCompression ? "habilitada" : "deshabilitada"}');
  }

  // Formato de compresión
  if (args.containsKey('compress_format')) {
    config.compressionFormat = args['compress_format'] as String;
    AppLogger.info('Formato de compresión actualizado: ${config.compressionFormat}');
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

  // Template por defecto
  if (args.containsKey('template')) {
    config.defaultTemplate = args['template'];
    AppLogger.debug('Template actualizado: ${config.defaultTemplate}');
  }

  // Validación de template
  if (args.containsKey('validate')) {
    config.validateTemplateData = args['validate'];
    AppLogger.debug('Validación de template: ${config.validateTemplateData ? 'habilitada' : 'deshabilitada'}');
  }

  // Formato de salida
  if (args.containsKey('format')) {
    config.outputFormat = args['format'];
    AppLogger.debug('Formato de salida: ${config.outputFormat}');
  }

  // Configuración de formato de esquema
  if (args.containsKey('schema_format')) {
    config.schemaFormat = args['schema_format'];
    AppLogger.debug('Formato de esquema: ${config.schemaFormat}');
  }
}

/// Valida los argumentos de la línea de comandos
Map<String, dynamic> validateArguments(List<String> arguments) {
  AppLogger.debug('Validando argumentos: ${arguments.length} argumento(s)');
  Validators.validateNotNull(arguments, 'arguments');

  // Mapa para almacenar los argumentos procesados
  final Map<String, dynamic> parsedArgs = {};

  // Manejar ciertas opciones especiales primero
  if (arguments.contains('--help') || arguments.contains('-h')) {
    _showHelp();
    parsedArgs['help'] = true;
    return parsedArgs;
  }

  if (arguments.contains('--list-templates')) {
    parsedArgs['list_templates'] = true;
    return parsedArgs;
  }

  if (arguments.contains('--list-formats')) {
    parsedArgs['list_formats'] = true;
    return parsedArgs;
  }

  if (arguments.contains('--list-schema-formats')) {
    parsedArgs['list_schema_formats'] = true;
    return parsedArgs;
  }

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
      final validTypes = ['fullyRandom', 'consistent', 'realistic'];
      if (validTypes.contains(value)) {
        parsedArgs['gentype'] = value;
        AppLogger.debug('Argumento gentype: $value');
      } else {
        AppLogger.warning('Tipo de generación inválido: $value. Valores válidos: ${validTypes.join(", ")}');
      }
    } else if (arg.startsWith('--seed=')) {
      // Semilla para generación determinista
      final value = arg.substring('--seed='.length);
      try {
        final seed = int.parse(value);
        parsedArgs['seed'] = seed;
        AppLogger.debug('Argumento seed: $seed');
      } catch (e) {
        AppLogger.warning('Valor inválido para seed: $value, debe ser un número entero');
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
    } else if (arg.startsWith('--template=')) {
      // Template a utilizar
      final value = arg.substring('--template='.length);
      if (value.isNotEmpty) {
        parsedArgs['template'] = value;
        AppLogger.debug('Argumento template: $value');
      }
    } else if (arg == '--compress') {
      // Habilitar compresión de archivos
      parsedArgs['compress'] = true;
      AppLogger.debug('Compresión de archivos habilitada');
    } else if (arg == '--no-compress') {
      // Deshabilitar compresión de archivos
      parsedArgs['compress'] = false;
      AppLogger.debug('Compresión de archivos deshabilitada');
    } else if (arg.startsWith('--compress-format=')) {
      // Formato de compresión a utilizar
      final value = arg.substring('--compress-format='.length).toLowerCase();
      parsedArgs['compress_format'] = value;
      AppLogger.debug('Formato de compresión: $value');
    } else if (arg == '--list-compress-formats') {
      // Listar formatos de compresión disponibles
      parsedArgs['list_compress_formats'] = true;
      AppLogger.debug('Listando formatos de compresión disponibles');
    } else if (arg.startsWith('--show-template-schema=')) {
      // Mostrar esquema de un template
      final value = arg.substring('--show-template-schema='.length);
      if (value.isNotEmpty) {
        parsedArgs['show_template_schema'] = value;
        AppLogger.debug('Mostrando esquema del template: $value');
      }
    } else if (arg == '--validate') {
      // Validar datos generados contra el template
      parsedArgs['validate'] = true;
      AppLogger.debug('Validación de template habilitada');
    } else if (arg == '--no-validate') {
      // No validar datos generados contra el template
      parsedArgs['validate'] = false;
      AppLogger.debug('Validación de template deshabilitada');
    } else if (arg.startsWith('--format=')) {
      // Formato de salida
      final value = arg.substring('--format='.length).toLowerCase();
      if (['json', 'yaml', 'xml'].contains(value)) {
        parsedArgs['format'] = value;
        AppLogger.debug('Argumento format: $value');
      } else {
        AppLogger.warning('Formato de salida no soportado: $value. Usando formato por defecto (json)');
      }
    } else if (arg.startsWith('--generate-schema=')) {
      // Generar esquema a partir de un archivo JSON
      final value = arg.substring('--generate-schema='.length);
      if (value.isNotEmpty) {
        parsedArgs['generate_schema'] = value;
        AppLogger.debug('Generando esquema a partir de JSON: $value');
      }
    } else if (arg.startsWith('--validate-schema=')) {
      // Esquema para validar un JSON
      final value = arg.substring('--validate-schema='.length);
      if (value.isNotEmpty) {
        parsedArgs['validate_schema'] = value;
        AppLogger.debug('Validando con esquema: $value');
      }
    } else if (arg.startsWith('--validate-json=')) {
      // Archivo JSON a validar contra esquema
      final value = arg.substring('--validate-json='.length);
      if (value.isNotEmpty) {
        parsedArgs['validate_json'] = value;
        AppLogger.debug('JSON a validar: $value');
      }
    } else if (arg.startsWith('--schema-format=')) {
      // Formato del esquema a utilizar
      final value = arg.substring('--schema-format='.length).toLowerCase();
      parsedArgs['schema_format'] = value;
      AppLogger.debug('Formato de esquema: $value');
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

/// Muestra la ayuda del programa
void _showHelp() {
  final help = '''
Generador de JSON para Dart.

Uso: dart run bin/generador_de_json.dart [opciones]

Opciones:
  --help, -h                      Muestra este mensaje de ayuda
  --output=<path>                 Ruta de salida para los archivos generados
  --records=<count>               Cantidad de registros a generar
  --timestamp                     Añade timestamp a los nombres de archivo
  --indent=<chars>                Caracteres de indentación (ej: "  " o "\\t")
  --loglevel=<level>              Nivel de log (debug, info, warning, error, fatal)
  --dateformat=<format>           Formato de fecha (iso8601, shortDate, longDate, timeOnly, usFormat, customFormat)
  --customdateformat=<format>     Formato personalizado para fechas
  --timezone=<zone>               Zona horaria para las fechas
  --gentype=<type>                Tipo de generación (fullyRandom, consistent, realistic)
  --seed=<number>                 Semilla para generación de datos aleatorios
  --ext=<extension>               Extensión para los archivos generados
  --encoding=<encoding>           Codificación de caracteres (utf-8, ascii, latin1, utf-16)
  --maxsize=<size>                Tamaño máximo de archivo en MB
  --cache, --no-cache             Habilita o deshabilita la caché de datos

Opciones de templates:
  --list-templates                Lista los templates disponibles
  --template=<name>               Template a utilizar para la generación
  --show-template-schema=<name>   Muestra el esquema de un template específico
  --validate, --no-validate       Habilita o deshabilita la validación contra el template

🧩 Opciones de formato de salida:
--------------------------
--format=<formato>      : Formato de salida (json, yaml, xml)
--list-formats          : Listar formatos disponibles

📝 Opciones de esquemas de validación:
--------------------------
--list-schema-formats             : Listar formatos de esquema disponibles
--generate-schema=<archivo.json>  : Generar un esquema a partir de un archivo JSON
--validate-schema=<archivo.json>  : Esquema para validar datos
--validate-json=<archivo.json>    : Archivo JSON a validar contra esquema
--schema-format=<formato>         : Formato del esquema (predeterminado: json-schema)

📦 Opciones de compresión:
--------------------------
--compress, --no-compress         : Habilita o deshabilita la compresión de archivos
--compress-format=<formato>       : Formato de compresión (gzip)
--list-compress-formats           : Listar formatos de compresión disponibles
''';

  print(help);
}

/// Lista los templates disponibles
void _listAvailableTemplates(App app) {
  final templates = app.getAvailableTemplates();

  if (templates.isEmpty) {
    print('No hay templates disponibles.');
    return;
  }

  print('Templates disponibles:');
  print('=====================');

  for (final templateName in templates) {
    try {
      final template = app.getTemplate(templateName);
      print('- ${template.name}: ${template.description} (v${template.version})');
    } catch (e) {
      print('- $templateName: [Error al obtener información]');
    }
  }
}

/// Muestra el esquema de un template específico
void _showTemplateSchema(App app, String templateName) {
  try {
    if (!app.hasTemplate(templateName)) {
      print('El template "$templateName" no existe.');
      return;
    }

    final template = app.getTemplate(templateName);
    final schema = template.getSchema();

    print('Esquema del template "${template.name}" (${template.description}):');
    print('=============================================================');
    final encoder = JsonEncoder.withIndent('  ');
    print(encoder.convert(schema));
  } catch (e) {
    print('Error al obtener el esquema del template: $e');
  }
}

/// Genera JSON utilizando un template
void _generateWithTemplate(App app, GenerateJson jsonGenerator, String templateName, Map<String, dynamic> args) {
  try {
    AppLogger.debug('Generando con template: $templateName');

    // Obtener el template
    if (!app.hasTemplate(templateName)) {
      AppLogger.error('Template no encontrado: $templateName');
      print('Error: Template no encontrado: $templateName');
      return;
    }

    final template = app.getTemplate(templateName);
    AppLogger.debug('Template obtenido: ${template.name} (${template.version})');

    // Determinar la cantidad de registros
    int recordCount = app.config.defaultRecordCount;
    if (args.containsKey('records')) {
      recordCount = args['records'];
    }

    // Determinar el formato de salida
    String? format;
    if (args.containsKey('format')) {
      format = args['format'];
    }

    // Generar JSON único
    AppLogger.debug('Generando objeto único con template: ${template.name}');
    jsonGenerator.generateJson(
      jsonName: '${template.name}_single',
      jsonMap: (_) => template.generateMap(),
      format: format,
    );

    // Generar lista
    AppLogger.debug('Generando lista con template: ${template.name}, registros: $recordCount');
    jsonGenerator.generateJsonList(
      jsonName: '${template.name}_list',
      jsonMap: (_) => template.generateList(recordCount),
      format: format,
    );

    AppLogger.info('Archivos generados exitosamente con template: ${template.name}');
    print('Archivos generados exitosamente con template: ${template.name}');
  } catch (e) {
    AppLogger.error('Error al generar con template: $templateName', e, StackTrace.current);
    print('Error al generar con template $templateName: $e');
  }
}

/// Muestra los formatos de salida disponibles
void _listAvailableFormats(App app) {
  try {
    AppLogger.debug('Listando formatos de salida disponibles');

    // Usar el registro de formatos para obtener la lista
    final formatterRegistry = FormatterRegistry();
    final formatNames = formatterRegistry.getAvailableFormatNames();
    final extensions = formatterRegistry.getSupportedExtensions();

    print('\nFormatos de salida disponibles:');
    print('=====================');

    for (var i = 0; i < formatNames.length; i++) {
      final format = formatNames[i];
      final extension = extensions[i];
      print('- $format: Extensión .$extension, MIME ${formatterRegistry.getFormatter(format).mimeType}');
    }

    print('\nPara usar: --format=<formato>');
  } catch (e) {
    AppLogger.error('Error al listar formatos disponibles', e, StackTrace.current);
    print('Error al listar formatos disponibles: $e');
  }
}

/// Lista los formatos de esquema disponibles
void _listAvailableSchemaFormats(App app) {
  try {
    AppLogger.debug('Listando formatos de esquema disponibles');

    // Usar la aplicación para obtener la lista de formatos
    final formats = app.getAvailableSchemaFormats();

    print('\nFormatos de esquema disponibles:');
    print('=====================');

    for (var format in formats) {
      print('- $format');
    }

    print('\nPara usar: --schema-format=<formato>');
  } catch (e) {
    AppLogger.error('Error al listar formatos de esquema disponibles', e, StackTrace.current);
    print('Error al listar formatos de esquema disponibles: $e');
  }
}

/// Genera un esquema a partir de un archivo JSON
void _generateSchemaFromJson(App app, String jsonFileName) {
  try {
    AppLogger.debug('Generando esquema a partir de JSON: $jsonFileName');

    // Verificar la existencia del archivo
    final file = File(jsonFileName);
    if (!file.existsSync()) {
      AppLogger.error('Archivo JSON no encontrado: $jsonFileName');
      print('Error: Archivo JSON no encontrado: $jsonFileName');
      return;
    }

    // Leer y parsear el archivo JSON
    final jsonContent = file.readAsStringSync();
    final jsonData = json.decode(jsonContent);

    if (jsonData is! Map<String, dynamic>) {
      AppLogger.error('El archivo debe contener un objeto JSON válido: $jsonFileName');
      print('Error: El archivo debe contener un objeto JSON válido.');
      return;
    }

    // Generar el esquema
    final schemaFormat = app.config.schemaFormat;
    final schema = app.generateSchema(jsonData, format: schemaFormat);

    // Determinar el nombre del archivo de salida
    final fileName = jsonFileName.substring(0, jsonFileName.lastIndexOf('.'));
    final outputFileName = '${fileName}_schema.json';

    // Escribir el esquema generado a un archivo
    final outputFile = File(outputFileName);
    final encoder = JsonEncoder.withIndent('  ');
    outputFile.writeAsStringSync(encoder.convert(schema));

    AppLogger.info('Esquema generado exitosamente: $outputFileName');
    print('Esquema generado exitosamente: $outputFileName');
  } catch (e) {
    AppLogger.error('Error al generar esquema', e, StackTrace.current);
    print('Error al generar esquema: $e');
  }
}

/// Valida un archivo JSON contra un esquema
void _validateJsonAgainstSchema(App app, String schemaFileName, String? jsonFileName) {
  try {
    AppLogger.debug('Validando JSON contra esquema: $schemaFileName');

    // Verificar la existencia del archivo de esquema
    final schemaFile = File(schemaFileName);
    if (!schemaFile.existsSync()) {
      AppLogger.error('Archivo de esquema no encontrado: $schemaFileName');
      print('Error: Archivo de esquema no encontrado: $schemaFileName');
      return;
    }

    // Leer y parsear el archivo de esquema
    final schemaContent = schemaFile.readAsStringSync();
    final schema = json.decode(schemaContent);

    // Si no se proporciona un archivo JSON, validar un ejemplo generado
    if (jsonFileName == null) {
      AppLogger.debug('No se proporcionó JSON para validar, generando ejemplo...');

      // Generar un ejemplo y validarlo
      final example = _generateExampleFromSchema(schema);

      // Determinar el formato del esquema
      final schemaFormat = app.config.schemaFormat;

      // Validar el ejemplo
      app.validateSchema(example, schema, format: schemaFormat);

      AppLogger.info('Validación exitosa del ejemplo generado');
      print('Validación exitosa del ejemplo generado:');
      final encoder = JsonEncoder.withIndent('  ');
      print(encoder.convert(example));

      return;
    }

    // Verificar la existencia del archivo JSON
    final jsonFile = File(jsonFileName);
    if (!jsonFile.existsSync()) {
      AppLogger.error('Archivo JSON no encontrado: $jsonFileName');
      print('Error: Archivo JSON no encontrado: $jsonFileName');
      return;
    }

    // Leer y parsear el archivo JSON
    final jsonContent = jsonFile.readAsStringSync();
    final jsonData = json.decode(jsonContent);

    // Determinar el formato del esquema
    final schemaFormat = app.config.schemaFormat;

    // Validar el JSON contra el esquema
    app.validateSchema(jsonData, schema, format: schemaFormat);

    AppLogger.info('Validación exitosa: $jsonFileName cumple con el esquema $schemaFileName');
    print('Validación exitosa: El archivo JSON cumple con el esquema especificado.');
  } catch (e) {
    AppLogger.error('Error en validación', e, StackTrace.current);

    if (e is SchemaValidationException) {
      print('Error de validación: ${e.message}');
    } else {
      print('Error al validar: $e');
    }
  }
}

/// Genera un ejemplo a partir de un esquema
Map<String, dynamic> _generateExampleFromSchema(Map<String, dynamic> schema) {
  final example = <String, dynamic>{};

  // Si el esquema tiene la propiedad 'properties', usarla para generar un ejemplo
  if (schema.containsKey('properties') && schema['properties'] is Map<String, dynamic>) {
    final properties = schema['properties'] as Map<String, dynamic>;

    properties.forEach((propName, propSchema) {
      if (propSchema is Map<String, dynamic>) {
        example[propName] = _generateExampleValue(propSchema);
      }
    });
  }

  return example;
}

/// Genera un valor de ejemplo para una propiedad del esquema
dynamic _generateExampleValue(Map<String, dynamic> propSchema) {
  // Obtener el tipo de la propiedad
  final type = propSchema['type'];

  // Usar ejemplos si están definidos
  if (propSchema.containsKey('example')) {
    return propSchema['example'];
  }

  // Generar según el tipo
  switch (type) {
    case 'string':
      if (propSchema.containsKey('enum') && propSchema['enum'] is List) {
        final enumValues = propSchema['enum'] as List;
        if (enumValues.isNotEmpty) {
          return enumValues.first;
        }
      }
      return 'string';

    case 'integer':
      return 0;

    case 'number':
      return 0.0;

    case 'boolean':
      return false;

    case 'array':
      if (propSchema.containsKey('items') && propSchema['items'] is Map<String, dynamic>) {
        final itemSchema = propSchema['items'] as Map<String, dynamic>;
        return [_generateExampleValue(itemSchema)];
      }
      return [];

    case 'object':
      if (propSchema.containsKey('properties') && propSchema['properties'] is Map<String, dynamic>) {
        return _generateExampleFromSchema(propSchema);
      }
      return {};

    default:
      return null;
  }
}

/// Implementar función para listar formatos de compresión
void _listAvailableCompressFormats(App app) {
  try {
    AppLogger.debug('Listando formatos de compresión disponibles');

    // Importar las clases necesarias
    final compressorRegistry = CompressorRegistry();
    final formatNames = compressorRegistry.getAvailableCompressorNames();
    final extensions = compressorRegistry.getSupportedExtensions();

    print('\nFormatos de compresión disponibles:');
    print('=====================');

    for (var i = 0; i < formatNames.length; i++) {
      final format = formatNames[i];
      final extension = extensions[i];
      print('- $format: Extensión .$extension');
    }

    print('\nPara usar: --compress --compress-format=<formato>');
  } catch (e) {
    AppLogger.error('Error al listar formatos de compresión disponibles', e, StackTrace.current);
    print('Error al listar formatos de compresión disponibles: $e');
  }
}
