import 'package:generador_de_json/core/exceptions/base_exception.dart';

/// Prefijo para códigos de error de archivos
const String _prefix = 'FILE';

/// Excepción para errores relacionados con archivos
class FileException extends BaseException {
  /// Ruta de salida relacionada con el error
  final String? outputPath;

  FileException({required String message, required String code, dynamic originalError, this.outputPath})
    : super(message: message, code: '${_prefix}_$code', originalError: originalError);

  /// Error de creación de directorio
  factory FileException.directoryCreationError(String directoryPath, {dynamic originalError}) {
    return FileException(
      message: 'Error al crear directorio: $directoryPath',
      code: 'DIR_CREATE_ERROR',
      originalError: originalError,
      outputPath: directoryPath,
    );
  }

  /// Error de permisos de escritura
  factory FileException.permissionDenied(String path, {dynamic originalError}) {
    return FileException(
      message: 'Permiso denegado para escribir en: $path',
      code: 'PERMISSION_DENIED',
      originalError: originalError,
      outputPath: path,
    );
  }

  /// Error de escritura de archivo
  factory FileException.fileWriteError(String message, {String? outputPath, dynamic originalError}) {
    return FileException(message: message, code: 'WRITE_ERROR', originalError: originalError, outputPath: outputPath);
  }

  /// Error de lectura de archivo
  factory FileException.fileReadError(String filePath, {dynamic originalError}) {
    return FileException(
      message: 'Error al leer archivo: $filePath',
      code: 'READ_ERROR',
      originalError: originalError,
      outputPath: filePath,
    );
  }

  /// Error de ruta no segura
  factory FileException.unsafePath(String path, {dynamic originalError}) {
    return FileException(
      message: 'Ruta no segura: $path',
      code: 'UNSAFE_PATH',
      originalError: originalError,
      outputPath: path,
    );
  }
}
