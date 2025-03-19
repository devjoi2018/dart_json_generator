import 'package:generador_de_json/core/interfaces/output_format_interface.dart';
import 'package:generador_de_json/core/formatters/json_formatter.dart';
import 'package:generador_de_json/core/formatters/yaml_formatter.dart';
import 'package:generador_de_json/core/formatters/xml_formatter.dart';
import 'package:generador_de_json/core/utils/logger.dart';

/// Registro de formatos de salida soportados
class FormatterRegistry {
  /// Instancia singleton de registro de formatos
  static final FormatterRegistry _instance = FormatterRegistry._internal();

  /// Constructor factory para obtener la instancia singleton
  factory FormatterRegistry() => _instance;

  /// Constructor interno
  FormatterRegistry._internal() {
    _registerDefaultFormatters();
  }

  /// Mapa de formatos registrados por nombre
  final Map<String, OutputFormatInterface> _formatters = {};

  /// Registra los formatos predeterminados
  void _registerDefaultFormatters() {
    try {
      // Registrar formatos incorporados
      registerFormatter(JsonFormatter());
      registerFormatter(YamlFormatter());
      registerFormatter(XmlFormatter());
      AppLogger.debug('Formatos de salida predeterminados registrados: JSON, YAML, XML');
    } catch (e) {
      AppLogger.error('Error al registrar formatos predeterminados', e, StackTrace.current);
      rethrow;
    }
  }

  /// Registra un nuevo formato de salida
  void registerFormatter(OutputFormatInterface formatter) {
    final formatName = formatter.formatName.toLowerCase();
    _formatters[formatName] = formatter;
    AppLogger.debug('Formato registrado: ${formatter.formatName}');
  }

  /// Obtiene un formato por su nombre
  OutputFormatInterface getFormatter(String formatName) {
    final lowerCaseName = formatName.toLowerCase();
    if (!_formatters.containsKey(lowerCaseName)) {
      throw FormatException('Formato no soportado: $formatName');
    }
    return _formatters[lowerCaseName]!;
  }

  /// Obtiene un formato por su extensión de archivo
  OutputFormatInterface getFormatterByExtension(String extension) {
    final lowerCaseExt = extension.toLowerCase().replaceAll('.', '');

    for (final formatter in _formatters.values) {
      if (formatter.fileExtension.toLowerCase() == lowerCaseExt) {
        return formatter;
      }
    }

    throw FormatException('Extensión no soportada: $extension');
  }

  /// Verifica si un formato está soportado
  bool isFormatSupported(String formatName) {
    return _formatters.containsKey(formatName.toLowerCase());
  }

  /// Verifica si una extensión está soportada
  bool isExtensionSupported(String extension) {
    final lowerCaseExt = extension.toLowerCase().replaceAll('.', '');
    return _formatters.values.any((formatter) => formatter.fileExtension.toLowerCase() == lowerCaseExt);
  }

  /// Obtiene la lista de nombres de formatos disponibles
  List<String> getAvailableFormatNames() {
    return _formatters.values.map((formatter) => formatter.formatName).toList();
  }

  /// Obtiene la lista de extensiones de archivos soportadas
  List<String> getSupportedExtensions() {
    return _formatters.values.map((formatter) => formatter.fileExtension).toList();
  }
}
