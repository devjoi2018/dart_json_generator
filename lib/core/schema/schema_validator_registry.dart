import 'package:generador_de_json/core/interfaces/schema_validator_interface.dart';
import 'package:generador_de_json/core/schema/json_schema_validator.dart';
import 'package:generador_de_json/core/utils/logger.dart';

/// Registro de validadores de esquemas
class SchemaValidatorRegistry {
  /// Singleton instance
  static final SchemaValidatorRegistry _instance = SchemaValidatorRegistry._internal();

  /// Constructor factory que devuelve la instancia singleton
  factory SchemaValidatorRegistry() => _instance;

  /// Constructor privado para implementación del singleton
  SchemaValidatorRegistry._internal() {
    _initializeDefaultValidators();
  }

  /// Mapa de validadores registrados
  final Map<String, SchemaValidatorInterface> _validators = {};

  /// Inicializa los validadores predeterminados
  void _initializeDefaultValidators() {
    // Registrar el validador de JSON Schema
    registerValidator(JsonSchemaValidator());
    AppLogger.debug('Validadores de esquemas predeterminados registrados');
  }

  /// Registra un nuevo validador
  void registerValidator(SchemaValidatorInterface validator) {
    final format = validator.schemaFormat;

    if (_validators.containsKey(format)) {
      AppLogger.warning('Ya existe un validador para el formato "$format". Se sobrescribirá.');
    }

    _validators[format] = validator;
    AppLogger.debug('Validador registrado: ${validator.validatorName} para formato $format');
  }

  /// Elimina un validador registrado
  void unregisterValidator(String format) {
    if (_validators.containsKey(format)) {
      _validators.remove(format);
      AppLogger.debug('Validador para formato "$format" eliminado');
    } else {
      AppLogger.warning('No existe un validador para el formato "$format"');
    }
  }

  /// Obtiene un validador por formato
  SchemaValidatorInterface? getValidator(String format) {
    return _validators[format];
  }

  /// Verifica si existe un validador para un formato específico
  bool hasValidator(String format) {
    return _validators.containsKey(format);
  }

  /// Devuelve la lista de formatos de esquema disponibles
  List<String> getAvailableFormats() {
    return _validators.keys.toList();
  }

  /// Valida datos contra un esquema usando el validador apropiado
  bool validate(dynamic data, dynamic schema, String format) {
    if (!hasValidator(format)) {
      throw ArgumentError('No existe un validador para el formato "$format"');
    }

    return getValidator(format)!.validate(data, schema);
  }

  /// Valida datos contra un esquema usando el validador apropiado y devuelve detalles
  Map<String, dynamic> validateWithDetails(dynamic data, dynamic schema, String format) {
    if (!hasValidator(format)) {
      return {
        'valid': false,
        'errors': ['No existe un validador para el formato "$format"'],
      };
    }

    return getValidator(format)!.validateWithDetails(data, schema);
  }

  /// Genera un esquema a partir de una estructura de datos
  dynamic generateSchema(Map<String, dynamic> structure, String format) {
    if (!hasValidator(format)) {
      throw ArgumentError('No existe un validador para el formato "$format"');
    }

    return getValidator(format)!.convertToSchema(structure);
  }
}
