import 'dart:convert';
import 'package:json_schema/json_schema.dart';
import 'package:generador_de_json/core/exceptions/exceptions.dart';
import 'package:generador_de_json/core/interfaces/schema_validator_interface.dart';
import 'package:generador_de_json/core/utils/logger.dart';

/// Implementación de un validador de esquemas JSON
class JsonSchemaValidator implements SchemaValidatorInterface {
  /// Singleton instance
  static final JsonSchemaValidator _instance = JsonSchemaValidator._internal();

  /// Constructor factory que devuelve la instancia singleton
  factory JsonSchemaValidator() => _instance;

  /// Constructor privado para implementación del singleton
  JsonSchemaValidator._internal();

  @override
  String get validatorName => 'JSON Schema Validator';

  @override
  String get schemaFormat => 'json-schema';

  @override
  bool validate(dynamic data, dynamic schema) {
    try {
      // Verificar que el esquema sea válido
      if (!isSchemaValid(schema)) {
        throw SchemaValidationException.invalidSchema('El esquema proporcionado no es válido');
      }

      // Convertir el esquema a JsonSchema
      final jsonSchema = _parseSchema(schema);

      // Validar los datos
      if (!jsonSchema.validate(data).isValid) {
        throw SchemaValidationException.validationFailed('Los datos no cumplen con el esquema especificado');
      }

      return true;
    } catch (e) {
      if (e is SchemaValidationException) {
        rethrow;
      }
      throw SchemaValidationException('Error al validar con JSON Schema: ${e.toString()}', originalError: e);
    }
  }

  @override
  Map<String, dynamic> validateWithDetails(dynamic data, dynamic schema) {
    try {
      // Verificar que el esquema sea válido
      if (!isSchemaValid(schema)) {
        return {
          'valid': false,
          'errors': ['El esquema proporcionado no es válido'],
        };
      }

      // Convertir el esquema a JsonSchema
      final jsonSchema = _parseSchema(schema);

      // Validar los datos
      final validation = jsonSchema.validate(data);

      if (validation.isValid) {
        return {'valid': true, 'errors': []};
      } else {
        return {'valid': false, 'errors': validation.errors.map((e) => e.toString()).toList()};
      }
    } catch (e) {
      AppLogger.error('Error en validación con detalles', e, StackTrace.current);
      return {
        'valid': false,
        'errors': ['Error interno en validación: ${e.toString()}'],
      };
    }
  }

  @override
  bool isSchemaValid(dynamic schema) {
    try {
      // Si el esquema es un String, intentar parsearlo
      if (schema is String) {
        schema = json.decode(schema);
      }

      // Verificar que sea un mapa
      if (schema is! Map<String, dynamic>) {
        return false;
      }

      // Intentar crear un JsonSchema
      JsonSchema.create(schema);
      return true;
    } catch (e) {
      AppLogger.error('Error al validar esquema', e, StackTrace.current);
      return false;
    }
  }

  @override
  dynamic convertToSchema(Map<String, dynamic> structure) {
    // Crear un esquema JSON a partir de una estructura de datos
    final schema = {'type': 'object', 'properties': <String, dynamic>{}, 'required': <String>[]};

    _inferSchemaFromObject(schema, structure);
    return schema;
  }

  /// Analiza el esquema y devuelve un objeto JsonSchema
  JsonSchema _parseSchema(dynamic schema) {
    try {
      if (schema is String) {
        // Si es un string, intentar parsearlo como JSON
        return JsonSchema.create(json.decode(schema));
      } else if (schema is Map<String, dynamic>) {
        // Si ya es un mapa, usarlo directamente
        return JsonSchema.create(schema);
      } else {
        throw SchemaValidationException.invalidSchema(
          'Formato de esquema no soportado. Debe ser un String JSON o un Map<String, dynamic>',
        );
      }
    } catch (e) {
      if (e is SchemaValidationException) {
        rethrow;
      }
      throw SchemaValidationException.invalidSchema('Error al parsear el esquema: ${e.toString()}', originalError: e);
    }
  }

  /// Infiere un esquema a partir de un objeto
  void _inferSchemaFromObject(Map<String, dynamic> schema, Map<String, dynamic> obj) {
    final properties = schema['properties'] as Map<String, dynamic>;
    final required = schema['required'] as List<String>;

    // Determinar propiedades y requerimientos
    obj.forEach((key, value) {
      if (value != null) {
        properties[key] = _inferType(value);
        required.add(key);
      } else {
        properties[key] = {'type': 'null'};
      }
    });
  }

  /// Infiere el tipo de un valor para el esquema
  Map<String, dynamic> _inferType(dynamic value) {
    if (value is String) {
      return {'type': 'string'};
    } else if (value is int) {
      return {'type': 'integer'};
    } else if (value is double) {
      return {'type': 'number'};
    } else if (value is bool) {
      return {'type': 'boolean'};
    } else if (value is List) {
      if (value.isEmpty) {
        return {'type': 'array', 'items': {}};
      } else {
        // Tomar el tipo del primer elemento como referencia
        return {'type': 'array', 'items': _inferType(value.first)};
      }
    } else if (value is Map<String, dynamic>) {
      final nestedSchema = {'type': 'object', 'properties': <String, dynamic>{}, 'required': <String>[]};
      _inferSchemaFromObject(nestedSchema, value);
      return nestedSchema;
    } else {
      return {'type': 'object'};
    }
  }
}
