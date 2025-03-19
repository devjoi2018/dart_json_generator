/// Interfaz para compresores de archivos
abstract class CompressorInterface {
  /// Nombre del compresor
  String get compressorName;

  /// Extensión del archivo comprimido
  String get fileExtension;

  /// Tipo MIME del archivo comprimido
  String get mimeType;

  /// Comprime el contenido de un String
  List<int> compressString(String content);

  /// Descomprime un contenido comprimido a un String
  String decompressToString(List<int> compressedContent);

  /// Comprime un archivo y escribe el resultado en un nuevo archivo
  Future<String> compressFile(String sourcePath, String outputPath);

  /// Descomprime un archivo y escribe el resultado en un nuevo archivo
  Future<String> decompressFile(String sourcePath, String outputPath);
}
