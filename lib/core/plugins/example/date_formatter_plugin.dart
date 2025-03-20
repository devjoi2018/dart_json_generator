import 'package:generador_de_json/core/plugins/base_plugin.dart';
import 'package:generador_de_json/core/utils/logger.dart';

/// Plugin de ejemplo para formatear fechas
class DateFormatterPlugin extends BasePlugin {
  /// Formatos de fecha disponibles
  final Map<String, String Function(DateTime)> _formats = {};

  @override
  String get pluginId => 'com.generador_json.plugins.date_formatter';

  @override
  String get pluginName => 'Formateador de Fechas';

  @override
  String get pluginDescription => 'Plugin para formatear fechas en diferentes formatos';

  @override
  String get pluginVersion => '1.0.0';

  @override
  String get pluginAuthor => 'Dart JSON Generator';

  @override
  void initialize() {
    AppLogger.info('Inicializando plugin: $pluginName');

    // Registrar formatos predeterminados
    _registerDefaultFormats();
  }

  @override
  void registerFunctionalities() {
    AppLogger.debug('Registrando formateadores de fecha del plugin: $pluginName');
    // En una implementación real, aquí se registrarían los formateadores
    // con el sistema principal para que puedan ser utilizados
  }

  /// Registra los formatos predeterminados
  void _registerDefaultFormats() {
    // Formato ISO estándar
    registerFormat('iso', (date) => date.toIso8601String());

    // Formato personalizado: DD/MM/YYYY
    registerFormat(
      'dd/mm/yyyy',
      (date) => '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
    );

    // Formato personalizado: YYYY-MM-DD
    registerFormat(
      'yyyy-mm-dd',
      (date) => '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
    );

    // Formato personalizado: MM/DD/YYYY
    registerFormat(
      'mm/dd/yyyy',
      (date) => '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}',
    );

    // Formato timestamp
    registerFormat('timestamp', (date) => date.millisecondsSinceEpoch.toString());

    AppLogger.debug('Formatos de fecha registrados: ${_formats.keys.join(', ')}');
  }

  /// Registra un nuevo formato de fecha
  void registerFormat(String formatName, String Function(DateTime date) formatter) {
    if (_formats.containsKey(formatName)) {
      AppLogger.warning('El formato de fecha "$formatName" ya está registrado y será sobrescrito');
    }

    _formats[formatName] = formatter;
    AppLogger.debug('Formato de fecha registrado: $formatName');
  }

  /// Formatea una fecha utilizando el formato especificado
  String formatDate(DateTime date, String format) {
    if (!_formats.containsKey(format)) {
      AppLogger.warning('Formato de fecha "$format" no encontrado, utilizando ISO por defecto');
      return _formats['iso']!(date);
    }

    return _formats[format]!(date);
  }

  /// Obtiene una lista de los formatos disponibles
  List<String> get availableFormats => _formats.keys.toList();
}

/// Función para crear una instancia del plugin
/// Esta función sería utilizada por el sistema de plugins para cargar el plugin
DateFormatterPlugin createPlugin() {
  return DateFormatterPlugin();
}
