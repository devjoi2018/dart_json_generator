import 'package:generador_de_json/core/exceptions/base_exception.dart';

/// Prefijo para los códigos de error generales de la aplicación
const String _prefix = 'APP';

/// Excepción para errores generales de la aplicación
class AppException extends BaseException {
  AppException({required String message, required String code, dynamic originalError})
    : super(message: message, code: '${_prefix}_$code', originalError: originalError);

  /// Error de inicialización
  factory AppException.initializationError(String details, {dynamic originalError}) {
    return AppException(message: 'Error de inicialización: $details', code: 'INIT_ERROR', originalError: originalError);
  }

  /// Error al registrar un módulo
  factory AppException.moduleRegistrationError(String details, {dynamic originalError}) {
    return AppException(
      message: 'Error al registrar módulo: $details',
      code: 'MODULE_REG_ERROR',
      originalError: originalError,
    );
  }

  /// Error al no encontrar un módulo
  factory AppException.moduleNotFound(String moduleName) {
    return AppException(
      message: 'Módulo no encontrado: $moduleName',
      code: 'MODULE_NOT_FOUND',
      originalError: 'El módulo solicitado ($moduleName) no está registrado en la aplicación',
    );
  }

  /// Error de configuración
  factory AppException.configurationError(String details, {dynamic originalError}) {
    return AppException(
      message: 'Error de configuración: $details',
      code: 'CONFIG_ERROR',
      originalError: originalError,
    );
  }

  /// Error de operación no soportada
  factory AppException.unsupportedOperation(String operation, {dynamic originalError}) {
    return AppException(
      message: 'Operación no soportada: $operation',
      code: 'UNSUPPORTED_OPERATION',
      originalError: originalError,
    );
  }
}
