import 'package:generador_de_json/core/exceptions/base_exception.dart';

/// Prefijo para los códigos de error del generador de datos
const String _prefix = 'DATA_GEN';

/// Excepción para errores relacionados con la generación de datos
class DataGeneratorException extends BaseException {
  DataGeneratorException({required String message, required String code, dynamic originalError})
    : super(message: message, code: '${_prefix}_$code', originalError: originalError);

  /// Error al generar datos de un tipo específico
  factory DataGeneratorException.generationError(String dataType, {dynamic originalError}) {
    return DataGeneratorException(
      message: 'Error al generar datos de tipo: $dataType',
      code: 'GENERATION_ERROR',
      originalError: originalError,
    );
  }

  /// Error al intentar obtener un generador de datos de un tipo no soportado
  factory DataGeneratorException.unsupportedGeneratorType(String type, {dynamic originalError}) {
    return DataGeneratorException(
      message: 'Tipo de generador no soportado: $type',
      code: 'UNSUPPORTED_GENERATOR_TYPE',
      originalError: originalError,
    );
  }

  /// Error en los datos de origen
  factory DataGeneratorException.sourceDataError(String details, {dynamic originalError}) {
    return DataGeneratorException(
      message: 'Error en los datos de origen: $details',
      code: 'SOURCE_DATA_ERROR',
      originalError: originalError,
    );
  }

  /// Error al no encontrar datos necesarios
  factory DataGeneratorException.dataNotFound(String dataType, {dynamic originalError}) {
    return DataGeneratorException(
      message: 'No se encontraron datos de tipo: $dataType',
      code: 'DATA_NOT_FOUND',
      originalError: originalError,
    );
  }

  /// Error al intentar generar datos con parámetros inválidos
  factory DataGeneratorException.invalidParameters(String details, {dynamic originalError}) {
    return DataGeneratorException(
      message: 'Parámetros inválidos para la generación de datos: $details',
      code: 'INVALID_PARAMETERS',
      originalError: originalError,
    );
  }

  /// Error al generar datos aleatorios
  factory DataGeneratorException.randomGenerationError(String message, {dynamic originalError}) {
    return DataGeneratorException(message: message, code: 'RANDOM_GENERATION_ERROR', originalError: originalError);
  }
}
