/// Interfaz para implementaciones de validadores de esquemas
abstract class SchemaValidatorInterface {
  /// Nombre del validador
  String get validatorName;

  /// Valida un objeto contra un esquema definido
  /// Devuelve true si el objeto es válido
  /// Genera una excepción si el objeto es inválido
  bool validate(dynamic data, dynamic schema);

  /// Valida un objeto contra un esquema definido y devuelve el resultado
  /// junto con los errores de validación
  Map<String, dynamic> validateWithDetails(dynamic data, dynamic schema);

  /// Verifica si un esquema es válido
  bool isSchemaValid(dynamic schema);

  /// Obtiene el formato de esquema que soporta este validador
  String get schemaFormat;

  /// Convierte una estructura de datos al formato de esquema soportado
  dynamic convertToSchema(Map<String, dynamic> structure);
}
