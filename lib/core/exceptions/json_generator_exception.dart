import 'package:generador_de_json/core/exceptions/base_exception.dart';

/// Prefijo para los códigos de error del generador de JSON
const String _prefix = 'JSON_GEN';

/// Excepción para errores relacionados con la generación de JSON
class JsonGeneratorException extends BaseException {
  JsonGeneratorException({required String message, required String code, dynamic originalError})
    : super(message: message, code: '${_prefix}_$code', originalError: originalError);

  /// Error de formato de datos
  factory JsonGeneratorException.invalidFormat(String details, {dynamic originalError}) {
    return JsonGeneratorException(
      message: 'Formato de datos inválido: $details',
      code: 'INVALID_FORMAT',
      originalError: originalError,
    );
  }

  /// Error al escribir el archivo
  factory JsonGeneratorException.fileWriteError(String path, {dynamic originalError}) {
    return JsonGeneratorException(
      message: 'Error al escribir el archivo en: $path',
      code: 'FILE_WRITE_ERROR',
      originalError: originalError,
    );
  }

  /// Error al convertir a JSON
  factory JsonGeneratorException.jsonConversionError({dynamic originalError}) {
    return JsonGeneratorException(
      message: 'Error al convertir el objeto a formato JSON',
      code: 'CONVERSION_ERROR',
      originalError: originalError,
    );
  }

  /// Error de validación de esquema JSON
  factory JsonGeneratorException.schemaValidationError(String details, {dynamic originalError}) {
    return JsonGeneratorException(
      message: 'El objeto no cumple con el esquema JSON: $details',
      code: 'SCHEMA_VALIDATION_ERROR',
      originalError: originalError,
    );
  }

  /// Error de parámetros inválidos
  factory JsonGeneratorException.invalidParameters(String details, {dynamic originalError}) {
    return JsonGeneratorException(
      message: 'Parámetros inválidos: $details',
      code: 'INVALID_PARAMETERS',
      originalError: originalError,
    );
  }

  /// Error de violación de seguridad
  factory JsonGeneratorException.securityViolation(String details, {dynamic originalError}) {
    return JsonGeneratorException(
      message: 'Violación de seguridad: $details',
      code: 'SECURITY_VIOLATION',
      originalError: originalError,
    );
  }

  /// Error de datos que exceden el tamaño máximo
  factory JsonGeneratorException.dataExceedsMaxSize(String details, {dynamic originalError}) {
    return JsonGeneratorException(
      message: 'Datos demasiado grandes: $details',
      code: 'DATA_SIZE_EXCEEDED',
      originalError: originalError,
    );
  }

  /// Error de datos inválidos
  factory JsonGeneratorException.invalidData(String details, {dynamic originalError}) {
    return JsonGeneratorException(
      message: 'Datos inválidos: $details',
      code: 'INVALID_DATA',
      originalError: originalError,
    );
  }

  /// Error general en el generador
  factory JsonGeneratorException.generationError(String details, {dynamic originalError}) {
    return JsonGeneratorException(
      message: 'Error en el generador: $details',
      code: 'GENERATION_ERROR',
      originalError: originalError,
    );
  }
}
