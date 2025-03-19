import 'package:generador_de_json/core/exceptions/base_exception.dart';

/// Excepción para errores de validación de esquemas
class SchemaValidationException extends BaseException {
  /// Constructor para errores de validación de esquema
  SchemaValidationException(String message, {dynamic originalError, StackTrace? stackTrace})
    : super(code: 'SCHEMA_VALIDATION_ERROR', message: message, originalError: originalError);

  /// Error en el esquema
  factory SchemaValidationException.invalidSchema(String message, {dynamic originalError}) {
    return SchemaValidationException('Esquema inválido: $message', originalError: originalError);
  }

  /// Error en la validación de datos contra un esquema
  factory SchemaValidationException.validationFailed(String message, {dynamic originalError}) {
    return SchemaValidationException('Validación fallida: $message', originalError: originalError);
  }

  /// Error al intentar cargar un esquema
  factory SchemaValidationException.schemaLoadError(String schemaId, {dynamic originalError}) {
    return SchemaValidationException('Error al cargar esquema "$schemaId"', originalError: originalError);
  }
}
