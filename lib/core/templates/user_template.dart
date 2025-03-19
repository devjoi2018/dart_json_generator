import 'package:generador_de_json/core/data_generators/data_generator_factory.dart';
import 'package:generador_de_json/core/interfaces/data_generator_interface.dart';
import 'package:generador_de_json/core/templates/base_template.dart';

/// Template para generar datos de usuario
class UserTemplate extends BaseTemplate {
  /// Generador de datos
  final DataGeneratorInterface _dataGenerator = DataGeneratorFactory.create(GeneratorType.random);

  @override
  String get name => "user";

  @override
  String get description => "Template para generar datos de usuario";

  @override
  String get version => "1.0.0";

  /// Campos requeridos en el esquema
  final List<String> _requiredFields = ["id", "name", "email"];

  @override
  Map<String, dynamic> getSchemaInternal() {
    return {
      "type": "object",
      "required": _requiredFields,
      "properties": {
        "id": {"type": "integer", "minimum": 0},
        "name": {"type": "string", "minLength": 2},
        "email": {"type": "string", "format": "email"},
        "avatar": {"type": "string", "format": "uri"},
        "active": {"type": "boolean"},
        "registrationDate": {"type": "string", "format": "date-time"},
        "lastLogin": {"type": "string", "format": "date-time"},
        "role": {"type": "string", "enum": ["user", "admin", "guest"]},
        "score": {"type": "number", "minimum": 0, "maximum": 100},
        "preferences": {
          "type": "object",
          "properties": {
            "theme": {"type": "string", "enum": ["light", "dark", "system"]},
            "notifications": {"type": "boolean"},
            "language": {"type": "string"},
          },
        },
      },
    };
  }

  @override
  Map<String, dynamic> generateMapInternal() {
    return {
      "id": _dataGenerator.generateRandomInt(min: 1, max: 1000),
      "name": _dataGenerator.generateRandomFemaleOrMaleName(isFullName: true),
      "email": _dataGenerator.generateRandomEmail(),
      "avatar": _dataGenerator.generateRandomAvatarUrl(),
      "active": _dataGenerator.generateRandomBool(trueProbability: 0.8),
      "registrationDate": _dataGenerator.generateRandomDate(
        from: DateTime(2020, 1, 1),
        to: DateTime.now(),
      ),
      "lastLogin": _dataGenerator.generateRandomDate(
        from: DateTime.now().subtract(const Duration(days: 30)),
        to: DateTime.now(),
      ),
      "role": _getRandomRole(),
      "score": _dataGenerator.generateRandomDouble(min: 0, max: 100, decimals: 1),
      "preferences": _generateRandomPreferences(),
    };
  }

  /// Genera un rol aleatorio
  String _getRandomRole() {
    final roles = ["user", "admin", "guest"];
    final probabilities = [0.7, 0.2, 0.1];
    final random = _dataGenerator.generateRandomDouble(min: 0, max: 1);
    
    double cumulative = 0;
    for (var i = 0; i < roles.length; i++) {
      cumulative += probabilities[i];
      if (random <= cumulative) {
        return roles[i];
      }
    }
    
    return roles.first;
  }

  /// Genera preferencias aleatorias
  Map<String, dynamic> _generateRandomPreferences() {
    final themes = ["light", "dark", "system"];
    final languages = ["es", "en", "fr", "de", "pt", "it"];
    
    return {
      "theme": themes[_dataGenerator.generateRandomInt(min: 0, max: themes.length - 1)],
      "notifications": _dataGenerator.generateRandomBool(trueProbability: 0.7),
      "language": languages[_dataGenerator.generateRandomInt(min: 0, max: languages.length - 1)],
    };
  }

  @override
  bool validateDataInternal(Map<String, dynamic> data) {
    // Verifica campos requeridos
    for (final field in _requiredFields) {
      if (!data.containsKey(field) || data[field] == null) {
        return false;
      }
    }
    
    // Validaciones específicas para cada campo
    if (data.containsKey("id") && data["id"] is int && data["id"] < 0) {
      return false;
    }
    
    if (data.containsKey("name") && data["name"] is String && (data["name"] as String).length < 2) {
      return false;
    }
    
    if (data.containsKey("email") && data["email"] is String) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(data["email"] as String)) {
        return false;
      }
    }
    
    return true;
  }

  @override
  Map<String, dynamic> applyTemplateInternal(Map<String, dynamic> data) {
    final template = generateMapInternal();
    
    // Combina los datos proporcionados con el template
    final result = Map<String, dynamic>.from(template);
    
    // Sobrescribe con los datos proporcionados
    data.forEach((key, value) {
      result[key] = value;
    });
    
    return result;
  }
} 