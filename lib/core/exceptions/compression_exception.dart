import 'package:generador_de_json/core/exceptions/base_exception.dart';

/// Prefijo para códigos de error de compresión
const String _prefix = 'COMPRESSION';

/// Excepción para errores de compresión/descompresión de archivos
class CompressionException extends BaseException {
  /// Ruta del archivo relacionado con el error
  final String? filePath;

  CompressionException({required String message, required String code, dynamic originalError, this.filePath})
    : super(message: message, code: '${_prefix}_$code', originalError: originalError);

  /// Constructor para error de compresión
  factory CompressionException.compressionFailed(String message, {String? filePath, dynamic originalError}) {
    return CompressionException(message: message, code: 'FAILED', originalError: originalError, filePath: filePath);
  }

  /// Constructor para error de descompresión
  factory CompressionException.decompressionFailed(String message, {String? filePath, dynamic originalError}) {
    return CompressionException(
      message: message,
      code: 'DECOMPRESSION_FAILED',
      originalError: originalError,
      filePath: filePath,
    );
  }

  /// Constructor para formato no soportado
  factory CompressionException.unsupportedFormat(String format, {dynamic originalError}) {
    return CompressionException(
      message: 'Formato de compresión no soportado: $format',
      code: 'UNSUPPORTED_FORMAT',
      originalError: originalError,
    );
  }
}
