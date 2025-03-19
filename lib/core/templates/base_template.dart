import 'package:generador_de_json/core/exceptions/exceptions.dart';
import 'package:generador_de_json/core/interfaces/template_interface.dart';
import 'package:generador_de_json/core/utils/logger.dart';
import 'package:generador_de_json/core/utils/validators.dart';

/// Excepción para errores relacionados con los templates
class TemplateException extends BaseException {
  /// Constructor
  TemplateException({
    required String message,
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          code: code ?? "TEMPLATE_ERROR",
          originalError: originalError,
        );

  /// Factory para errores de validación de template
  factory TemplateException.validationError(
    String details, {
    dynamic originalError,
  }) {
    return TemplateException(
      message: "Error de validación en template: $details",
      code: "TEMPLATE_VALIDATION_ERROR",
      originalError: originalError,
    );
  }

  /// Factory para errores de generación de template
  factory TemplateException.generationError(
    String details, {
    dynamic originalError,
  }) {
    return TemplateException(
      message: "Error al generar datos desde template: $details",
      code: "TEMPLATE_GENERATION_ERROR",
      originalError: originalError,
    );
  }

  /// Factory para errores de template no encontrado
  factory TemplateException.templateNotFound(
    String templateName, {
    dynamic originalError,
  }) {
    return TemplateException(
      message: "Template no encontrado: $templateName",
      code: "TEMPLATE_NOT_FOUND",
      originalError: originalError,
    );
  }
}

/// Clase base para los templates
abstract class BaseTemplate implements TemplateInterface {
  @override
  String get name;

  @override
  String get description;

  @override
  String get version;

  @override
  Map<String, dynamic> getSchema() {
    try {
      return getSchemaInternal();
    } catch (e) {
      AppLogger.error("Error al obtener esquema de template: ${name}", e, StackTrace.current);
      if (e is TemplateException) {
        rethrow;
      }
      throw TemplateException(
        message: "Error al obtener esquema del template: ${name}",
        originalError: e,
      );
    }
  }

  /// Implementación interna del esquema
  Map<String, dynamic> getSchemaInternal();

  @override
  Map<String, dynamic> generateMap() {
    try {
      final result = generateMapInternal();
      
      if (!validateData(result)) {
        throw TemplateException.validationError(
          "Los datos generados no cumplen con el esquema del template: ${name}",
        );
      }
      
      return result;
    } catch (e) {
      AppLogger.error("Error al generar mapa desde template: ${name}", e, StackTrace.current);
      print("ERROR DETALLADO: $e");
      print("Stack trace: ${StackTrace.current}");
      if (e is TemplateException) {
        rethrow;
      }
      throw TemplateException.generationError(
        "Error al generar mapa desde template: ${name}",
        originalError: e,
      );
    }
  }

  /// Implementación interna de la generación de mapa
  Map<String, dynamic> generateMapInternal();

  @override
  List<Map<String, dynamic>> generateList(int count) {
    try {
      Validators.validatePositive(count, "count");
      
      final result = List.generate(
        count,
        (_) => generateMapInternal(),
      );
      
      // Validar cada elemento de la lista
      for (var i = 0; i < result.length; i++) {
        if (!validateData(result[i])) {
          throw TemplateException.validationError(
            "El elemento $i no cumple con el esquema del template: ${name}",
          );
        }
      }
      
      return result;
    } catch (e) {
      AppLogger.error("Error al generar lista desde template: ${name}", e, StackTrace.current);
      if (e is TemplateException) {
        rethrow;
      }
      throw TemplateException.generationError(
        "Error al generar lista desde template: ${name}",
        originalError: e,
      );
    }
  }

  @override
  bool validateData(Map<String, dynamic> data) {
    try {
      Validators.validateNotNull(data, "data");
      return validateDataInternal(data);
    } catch (e) {
      AppLogger.error("Error al validar datos con template: ${name}", e, StackTrace.current);
      if (e is TemplateException) {
        rethrow;
      }
      throw TemplateException.validationError(
        "Error al validar datos con template: ${name}",
        originalError: e,
      );
    }
  }

  /// Implementación interna de la validación de datos
  bool validateDataInternal(Map<String, dynamic> data);

  @override
  Map<String, dynamic> applyTemplate(Map<String, dynamic> data) {
    try {
      Validators.validateNotNull(data, "data");
      return applyTemplateInternal(data);
    } catch (e) {
      AppLogger.error("Error al aplicar template: ${name}", e, StackTrace.current);
      if (e is TemplateException) {
        rethrow;
      }
      throw TemplateException.generationError(
        "Error al aplicar template: ${name}",
        originalError: e,
      );
    }
  }

  /// Implementación interna de la aplicación del template
  Map<String, dynamic> applyTemplateInternal(Map<String, dynamic> data);
} 