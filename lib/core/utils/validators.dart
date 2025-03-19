import 'dart:convert';
import 'dart:io';

import 'package:generador_de_json/core/exceptions/exceptions.dart';

/// Utilidades de validación para toda la aplicación
class Validators {
  /// Valida que un string no sea nulo ni vacío
  static void validateNotEmpty(String? value, String paramName) {
    if (value == null) {
      throw ArgumentError('El parámetro "$paramName" no puede ser nulo');
    }
    if (value.isEmpty) {
      throw ArgumentError('El parámetro "$paramName" no puede estar vacío');
    }
  }

  /// Valida que un valor no sea nulo
  static void validateNotNull(Object? value, String paramName) {
    if (value == null) {
      throw ArgumentError('El parámetro "$paramName" no puede ser nulo');
    }
  }

  /// Valida que un número esté dentro de un rango
  static void validateRange(num? min, num? max) {
    if (min == null || max == null) {
      throw ArgumentError('Los valores mínimo y máximo no pueden ser nulos');
    }

    if (min > max) {
      throw ArgumentError('El valor mínimo ($min) no puede ser mayor que el valor máximo ($max)');
    }
  }

  /// Valida que un número sea positivo
  static void validatePositive(num value, String paramName) {
    if (value <= 0) {
      throw ArgumentError('El parámetro "$paramName" debe ser un valor positivo');
    }
  }

  /// Valida que un valor de probabilidad esté entre 0 y 1
  static void validateProbability(double probability) {
    if (probability < 0 || probability > 1) {
      throw ArgumentError('El valor de probabilidad debe estar entre 0 y 1');
    }
  }

  /// Valida un rango de fechas
  static void validateDateRange(DateTime? from, DateTime? to) {
    if (from != null && to != null) {
      if (from.isAfter(to)) {
        throw ArgumentError('La fecha inicial no puede ser posterior a la fecha final');
      }
    }
  }

  /// Valida que un nombre de archivo sea válido
  static void validateFileName(String fileName) {
    validateNotEmpty(fileName, 'fileName');

    final RegExp validFileName = RegExp(r'^[a-zA-Z0-9_\-\.]+$');
    if (!validFileName.hasMatch(fileName)) {
      throw JsonGeneratorException.invalidParameters(
        'El nombre del archivo "$fileName" contiene caracteres no válidos. Solo se permiten letras, números, guiones, puntos y guiones bajos.',
      );
    }
  }

  /// Valida que una ruta de archivo sea válida y escribible
  static void validateFilePath(String filePath) {
    validateNotEmpty(filePath, 'filePath');

    try {
      final directory = Directory(filePath.substring(0, filePath.lastIndexOf('/')));
      if (!directory.existsSync()) {
        throw JsonGeneratorException.fileWriteError(filePath, originalError: 'El directorio no existe');
      }

      // Intenta crear un archivo temporal para verificar permisos de escritura
      final testFile = File('${directory.path}/.test_write_permission');
      testFile.createSync();
      testFile.deleteSync();
    } catch (e) {
      if (e is JsonGeneratorException) {
        rethrow;
      }
      throw JsonGeneratorException.fileWriteError(filePath, originalError: 'No se puede escribir en la ruta: $e');
    }
  }

  /// Valida la función de mapeo para la generación de JSON
  static void validateJsonMapFunction(Function? mapFunction, String paramName) {
    if (mapFunction == null) {
      throw JsonGeneratorException.invalidParameters('La función de mapeo "$paramName" no puede ser nula');
    }
  }

  /// Valida un mapa de datos JSON
  static void validateJsonData(Map<String, dynamic>? data) {
    if (data == null) {
      throw JsonGeneratorException.invalidFormat('Los datos no pueden ser nulos');
    }

    if (data.isEmpty) {
      throw JsonGeneratorException.invalidFormat('El mapa de datos no puede estar vacío');
    }

    // Valida que todos los valores sean serializables a JSON
    try {
      json.encode(data);
    } catch (e) {
      throw JsonGeneratorException.jsonConversionError(originalError: e);
    }
  }

  /// Valida una lista de datos JSON
  static void validateJsonDataList(List<Map<String, dynamic>>? dataList) {
    if (dataList == null) {
      throw JsonGeneratorException.invalidFormat('La lista de datos no puede ser nula');
    }

    if (dataList.isEmpty) {
      throw JsonGeneratorException.invalidFormat('La lista de datos no puede estar vacía');
    }

    // Valida cada elemento de la lista
    for (var i = 0; i < dataList.length; i++) {
      try {
        validateJsonData(dataList[i]);
      } catch (e) {
        throw JsonGeneratorException.invalidFormat('El elemento en el índice $i no es válido: ${e.toString()}');
      }
    }
  }
}
