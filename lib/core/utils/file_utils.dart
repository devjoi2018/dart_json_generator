import 'dart:io';

import 'package:generador_de_json/core/exceptions/exceptions.dart';

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
}
