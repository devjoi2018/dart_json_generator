import 'dart:io';
import 'dart:convert';

import 'package:generador_de_json/core/exceptions/exceptions.dart';
import 'package:generador_de_json/core/utils/logger.dart';
import 'package:path/path.dart' as path;
import 'package:generador_de_json/app.dart';
import 'package:generador_de_json/core/compressors/compressor_registry.dart';

/// Utilidades para operaciones con archivos
class FileUtils {
  /// Verifica si un directorio existe y lo crea si es necesario
  ///
  /// Maneja excepciones de forma robusta y realiza validaciones adicionales
  static Directory ensureDirectoryExists(String path) {
    final directory = Directory(path);

    try {
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);

        // Validación adicional para asegurar que se creó correctamente
        if (!directory.existsSync()) {
          throw JsonGeneratorException.fileWriteError(
            path,
            originalError: 'No se pudo verificar la creación del directorio',
          );
        }
      }

      return directory;
    } catch (e) {
      if (e is JsonGeneratorException) rethrow;
      throw JsonGeneratorException.fileWriteError(path, originalError: 'Error al crear el directorio: $e');
    }
  }

  /// Verifica si se tienen permisos de escritura en un directorio
  ///
  /// Crea un archivo temporal para probar permisos y lo elimina después
  static void verifyWritePermissions(String directoryPath) {
    final testFile = File('$directoryPath/.write_permission_test');

    try {
      // Escribir en el archivo de prueba
      testFile.writeAsStringSync('test', flush: true);

      // Verificar que se escribió correctamente
      if (!testFile.existsSync() || testFile.lengthSync() == 0) {
        throw JsonGeneratorException.fileWriteError(
          directoryPath,
          originalError: 'No se tienen permisos de escritura en el directorio',
        );
      }

      // Eliminar el archivo de prueba
      testFile.deleteSync();
    } catch (e) {
      // Intentar limpiar el archivo de prueba si existe
      _cleanupTestFile(testFile);

      if (e is JsonGeneratorException) rethrow;
      throw JsonGeneratorException.fileWriteError(
        directoryPath,
        originalError: 'No se tienen permisos suficientes en el directorio: $e',
      );
    }
  }

  /// Escribe contenido en un archivo de forma robusta
  ///
  /// Realiza verificaciones adicionales después de escribir
  static File writeFile(String path, String content) {
    final file = File(path);

    try {
      // Escribir el contenido
      file.writeAsStringSync(content, flush: true);

      // Verificar que se escribió correctamente
      if (!file.existsSync()) {
        throw JsonGeneratorException.fileWriteError(
          path,
          originalError: 'No se pudo verificar la creación del archivo',
        );
      }

      // Verificar el tamaño del archivo
      if (file.lengthSync() == 0 && content.isNotEmpty) {
        throw JsonGeneratorException.fileWriteError(path, originalError: 'El archivo se creó pero está vacío');
      }

      return file;
    } catch (e) {
      if (e is JsonGeneratorException) rethrow;
      throw JsonGeneratorException.fileWriteError(path, originalError: 'Error al escribir el archivo: $e');
    }
  }

  /// Valida que una ruta sea segura para escritura
  ///
  /// Verifica caracteres prohibidos y rutas restringidas
  static void validateSafePath(String path) {
    // Verificar que la ruta no contenga caracteres peligrosos
    final RegExp safePathRegex = RegExp(r'^[\w\/\\\.\-\s]+$');
    if (!safePathRegex.hasMatch(path)) {
      throw JsonGeneratorException.securityViolation('La ruta contiene caracteres no permitidos: $path');
    }

    // Verificar que la ruta no intente acceder a directorios del sistema
    final List<String> restrictedPaths = [
      '/bin',
      '/boot',
      '/dev',
      '/etc',
      '/lib',
      '/root',
      '/sbin',
      'C:\\Windows',
      'C:\\Program Files',
      'C:\\Program Files (x86)',
      'C:\\Users\\Administrator',
      'C:\\Windows\\System32',
    ];

    for (final restrictedPath in restrictedPaths) {
      if (path.toLowerCase().contains(restrictedPath.toLowerCase())) {
        throw JsonGeneratorException.securityViolation(
          'No se permite escribir en directorios sensibles del sistema: $path',
        );
      }
    }

    // Verificar longitud máxima de la ruta
    final int maxPathLength = 260; // Límite en Windows
    if (path.length > maxPathLength) {
      throw JsonGeneratorException.invalidParameters(
        'La ruta es demasiado larga (máximo $maxPathLength caracteres): ${path.length} caracteres',
      );
    }
  }

  /// Intenta limpiar un archivo de prueba ignorando errores
  static void _cleanupTestFile(File testFile) {
    if (testFile.existsSync()) {
      try {
        testFile.deleteSync();
      } catch (_) {
        // Ignorar errores al eliminar el archivo de prueba
      }
    }
  }

  /// Guarda un contenido en un archivo con la ruta especificada
  static File saveToFile(String fileName, String content, String directoryPath) {
    try {
      AppLogger.debug('Guardando archivo: $fileName en $directoryPath');

      // Obtener la ruta completa
      final outputPath = path.join(directoryPath, fileName);
      AppLogger.debug('Ruta completa: $outputPath');

      // Validar que la ruta sea segura
      validateSafePath(outputPath);

      // Asegurar que el directorio existe
      final directory = ensureDirectoryExists(directoryPath);

      // Verificar permisos de escritura
      verifyWritePermissions(directory.path);

      // Escribir el archivo
      final file = writeFile(outputPath, content);

      // Verificar si se debe comprimir el archivo
      final config = App().config;
      if (config.enableCompression) {
        return compressFile(file.path, config.compressionFormat);
      }

      AppLogger.debug('Archivo guardado correctamente: ${file.path}');
      return file;
    } catch (e) {
      AppLogger.error('Error al guardar archivo: $fileName', e, StackTrace.current);
      if (e is BaseException) {
        rethrow;
      }
      throw FileException.fileWriteError(
        'Error al guardar archivo $fileName',
        outputPath: path.join(directoryPath, fileName),
        originalError: e,
      );
    }
  }

  /// Comprime un archivo usando el formato especificado
  static File compressFile(String filePath, String format) {
    try {
      AppLogger.debug('Comprimiendo archivo: $filePath con formato: $format');

      // Obtener el compresor adecuado
      final compressorRegistry = CompressorRegistry();
      if (!compressorRegistry.hasCompressor(format)) {
        throw CompressionException.unsupportedFormat(format);
      }

      final compressor = compressorRegistry.getCompressor(format);
      final fileExtension = compressor.fileExtension;

      // Definir la ruta del archivo comprimido
      final compressedPath = '$filePath.$fileExtension';

      // Realizar la compresión de forma asíncrona pero esperar el resultado para mantener el API
      final result = File(filePath).readAsBytesSync();
      final compressedBytes = compressor.compressString(utf8.decode(result));

      // Escribir el archivo comprimido
      final compressedFile = File(compressedPath);
      compressedFile.writeAsBytesSync(compressedBytes);

      // Verificar que se creó correctamente
      if (!compressedFile.existsSync() || compressedFile.lengthSync() == 0) {
        throw CompressionException.compressionFailed('Error al comprimir archivo: $filePath', filePath: filePath);
      }

      AppLogger.debug('Archivo comprimido correctamente: $compressedPath');

      // Eliminar el archivo original si la compresión fue exitosa
      try {
        File(filePath).deleteSync();
        AppLogger.debug('Archivo original eliminado tras compresión: $filePath');
      } catch (e) {
        AppLogger.warning('No se pudo eliminar el archivo original tras la compresión: $filePath', e);
      }

      return compressedFile;
    } catch (e) {
      AppLogger.error('Error al comprimir archivo: $filePath', e, StackTrace.current);
      if (e is BaseException) {
        rethrow;
      }
      throw CompressionException.compressionFailed(
        'Error al comprimir archivo: $filePath',
        filePath: filePath,
        originalError: e,
      );
    }
  }

  /// Descomprime un archivo usando el formato deducido de su extensión
  static File decompressFile(String compressedFilePath) {
    try {
      AppLogger.debug('Descomprimiendo archivo: $compressedFilePath');

      // Identificar el formato por la extensión
      final extension = path.extension(compressedFilePath).toLowerCase();
      if (extension.isEmpty) {
        throw CompressionException.decompressionFailed(
          'No se puede determinar el formato de compresión: $compressedFilePath',
          filePath: compressedFilePath,
        );
      }

      // Eliminar el punto inicial de la extensión
      final format = extension.substring(1);

      // Obtener el compresor adecuado
      final compressorRegistry = CompressorRegistry();
      if (!compressorRegistry.hasCompressor(format)) {
        throw CompressionException.unsupportedFormat(format);
      }

      final compressor = compressorRegistry.getCompressor(format);

      // Definir la ruta del archivo descomprimido (sin la extensión)
      final originalPath = compressedFilePath.substring(0, compressedFilePath.length - extension.length);

      // Realizar la descompresión
      final compressedBytes = File(compressedFilePath).readAsBytesSync();
      final decompressedContent = compressor.decompressToString(compressedBytes);

      // Escribir el archivo descomprimido
      final decompressedFile = File(originalPath);
      decompressedFile.writeAsStringSync(decompressedContent);

      // Verificar que se creó correctamente
      if (!decompressedFile.existsSync()) {
        throw CompressionException.decompressionFailed(
          'Error al descomprimir archivo: $compressedFilePath',
          filePath: compressedFilePath,
        );
      }

      AppLogger.debug('Archivo descomprimido correctamente: $originalPath');
      return decompressedFile;
    } catch (e) {
      AppLogger.error('Error al descomprimir archivo: $compressedFilePath', e, StackTrace.current);
      if (e is BaseException) {
        rethrow;
      }
      throw CompressionException.decompressionFailed(
        'Error al descomprimir archivo: $compressedFilePath',
        filePath: compressedFilePath,
        originalError: e,
      );
    }
  }
}
