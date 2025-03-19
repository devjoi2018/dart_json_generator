/// Interfaz para el sistema de templates
abstract class TemplateInterface {
  /// Nombre del template
  String get name;

  /// Descripción del template
  String get description;

  /// Versión del template
  String get version;

  /// Obtiene el esquema del template
  Map<String, dynamic> getSchema();

  /// Genera un mapa a partir del template
  Map<String, dynamic> generateMap();

  /// Genera una lista de mapas a partir del template
  List<Map<String, dynamic>> generateList(int count);

  /// Valida que los datos de un mapa cumplan con el esquema del template
  bool validateData(Map<String, dynamic> data);

  /// Aplica el template a datos existentes
  Map<String, dynamic> applyTemplate(Map<String, dynamic> data);
}
