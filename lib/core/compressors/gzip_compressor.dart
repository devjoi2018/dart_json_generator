import 'dart:convert';
import 'dart:io';

import 'package:generador_de_json/core/exceptions/exceptions.dart';
import 'package:generador_de_json/core/interfaces/compressor_interface.dart';
import 'package:generador_de_json/core/utils/logger.dart';

/// Implementación de compresor GZip
class GzipCompressor implements CompressorInterface {
  @override
  String get compressorName => 'GZip';

  @override
  String get fileExtension => 'gz';

  @override
  String get mimeType => 'application/gzip';

  @override
  List<int> compressString(String content) {
    try {
      final List<int> contentBytes = utf8.encode(content);
      return gzip.encode(contentBytes);
    } catch (e) {
      AppLogger.error('Error al comprimir contenido con GZip', e, StackTrace.current);
      throw CompressionException.compressionFailed('Error al comprimir con GZip', originalError: e);
    }
  }

  @override
  String decompressToString(List<int> compressedContent) {
    try {
      final List<int> decompressedBytes = gzip.decode(compressedContent);
      return utf8.decode(decompressedBytes);
    } catch (e) {
      AppLogger.error('Error al descomprimir contenido con GZip', e, StackTrace.current);
      throw CompressionException.decompressionFailed('Error al descomprimir con GZip', originalError: e);
    }
  }

  @override
  Future<String> compressFile(String sourcePath, String outputPath) async {
    try {
      final sourceFile = File(sourcePath);
      if (!sourceFile.existsSync()) {
        throw CompressionException.compressionFailed('El archivo origen no existe: $sourcePath');
      }

      final String content = await sourceFile.readAsString();
      final List<int> compressed = compressString(content);

      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(compressed);

      AppLogger.debug('Archivo comprimido con GZip: $outputPath');
      return outputPath;
    } catch (e) {
      if (e is CompressionException) rethrow;
      AppLogger.error('Error al comprimir archivo con GZip', e, StackTrace.current);
      throw CompressionException.compressionFailed(
        'Error al comprimir archivo con GZip: $sourcePath',
        originalError: e,
      );
    }
  }

  @override
  Future<String> decompressFile(String sourcePath, String outputPath) async {
    try {
      final sourceFile = File(sourcePath);
      if (!sourceFile.existsSync()) {
        throw CompressionException.decompressionFailed('El archivo comprimido no existe: $sourcePath');
      }

      final List<int> compressed = await sourceFile.readAsBytes();
      final String decompressed = decompressToString(compressed);

      final outputFile = File(outputPath);
      await outputFile.writeAsString(decompressed);

      AppLogger.debug('Archivo descomprimido con GZip: $outputPath');
      return outputPath;
    } catch (e) {
      if (e is CompressionException) rethrow;
      AppLogger.error('Error al descomprimir archivo con GZip', e, StackTrace.current);
      throw CompressionException.decompressionFailed(
        'Error al descomprimir archivo con GZip: $sourcePath',
        originalError: e,
      );
    }
  }
}
