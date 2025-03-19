import 'package:generador_de_json/core/interfaces/output_format_interface.dart';
import 'package:yaml/yaml.dart';

/// Implementación del formato YAML
class YamlFormatter implements OutputFormatInterface {
  @override
  String get formatName => 'YAML';

  @override
  String get fileExtension => 'yaml';

  @override
  String encode(dynamic data, {int indent = 2}) {
    // Convertir el objeto a YAML
    // Como la biblioteca yaml no incluye un codificador, implementamos uno simple
    if (data is Map) {
      return _convertMapToYaml(data, indent: indent);
    } else if (data is List) {
      return _convertListToYaml(data, indent: indent);
    } else {
      return data.toString();
    }
  }

  @override
  dynamic decode(String data) {
    return loadYaml(data);
  }

  @override
  String get mimeType => 'application/yaml';

  /// Convierte un mapa a formato YAML
  String _convertMapToYaml(Map<dynamic, dynamic> map, {int indent = 2, int level = 0}) {
    if (map.isEmpty) return '{}';

    final buffer = StringBuffer();
    final spaces = ' ' * (indent * level);

    map.forEach((key, value) {
      if (value is Map) {
        buffer.writeln('$spaces$key:');
        buffer.write(_convertMapToYaml(value, indent: indent, level: level + 1));
      } else if (value is List) {
        buffer.writeln('$spaces$key:');
        buffer.write(_convertListToYaml(value, indent: indent, level: level + 1));
      } else {
        // Si el valor es una cadena con caracteres especiales, lo envolvemos entre comillas
        final formattedValue = _formatYamlValue(value);
        buffer.writeln('$spaces$key: $formattedValue');
      }
    });

    return buffer.toString();
  }

  /// Convierte una lista a formato YAML
  String _convertListToYaml(List<dynamic> list, {int indent = 2, int level = 0}) {
    if (list.isEmpty) return '[]';

    final buffer = StringBuffer();
    final spaces = ' ' * (indent * level);

    for (var item in list) {
      if (item is Map) {
        buffer.writeln('$spaces-');
        buffer.write(_convertMapToYaml(item, indent: indent, level: level + 1));
      } else if (item is List) {
        buffer.writeln('$spaces-');
        buffer.write(_convertListToYaml(item, indent: indent, level: level + 1));
      } else {
        final formattedValue = _formatYamlValue(item);
        buffer.writeln('$spaces- $formattedValue');
      }
    }

    return buffer.toString();
  }

  /// Formatea un valor para YAML
  String _formatYamlValue(dynamic value) {
    if (value == null) {
      return 'null';
    } else if (value is bool || value is num) {
      return value.toString();
    } else {
      final stringValue = value.toString();
      // Si contiene caracteres especiales, poner entre comillas
      if (_needsQuotes(stringValue)) {
        return '"${_escapeString(stringValue)}"';
      }
      return stringValue;
    }
  }

  /// Determina si un string necesita comillas en YAML
  bool _needsQuotes(String value) {
    if (value.isEmpty) return true;

    // Caracteres que requieren comillas en YAML
    final specialChars = RegExp(r'[:#\[\]{}&*!|>"%@`,-]');

    // También comillas si parece un número, booleano o null
    final looksLikeReserved = RegExp(r'^(true|false|null|\d+|\d+\.\d+)$');

    return specialChars.hasMatch(value) || looksLikeReserved.hasMatch(value);
  }

  /// Escapa caracteres especiales en un string
  String _escapeString(String value) {
    return value
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }
}
