import 'dart:convert';
import 'package:generador_de_json/core/interfaces/output_format_interface.dart';

/// Implementación del formato JSON
class JsonFormatter implements OutputFormatInterface {
  /// Espacios para la indentación
  final String _indent;

  /// Constructor
  JsonFormatter({String indent = '  '}) : _indent = indent;

  @override
  String get formatName => 'JSON';

  @override
  String get fileExtension => 'json';

  @override
  String encode(dynamic data, {int indent = 2}) {
    final encoder = JsonEncoder.withIndent(_indent * indent);
    return encoder.convert(data);
  }

  @override
  dynamic decode(String data) {
    return jsonDecode(data);
  }

  @override
  String get mimeType => 'application/json';
}
