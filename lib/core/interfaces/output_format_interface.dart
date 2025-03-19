/// Interfaz para formatos de salida soportados
abstract class OutputFormatInterface {
  /// Obtiene el nombre del formato
  String get formatName;

  /// Obtiene la extensión del archivo para este formato
  String get fileExtension;

  /// Convierte el objeto a la representación del formato específico
  String encode(dynamic data, {int indent = 2});

  /// Convierte desde la representación del formato específico a un objeto Dart
  dynamic decode(String data);

  /// Obtiene el MIME type para este formato
  String get mimeType;
}
