/// Interfaz para el generador de JSON
abstract class JsonGeneratorInterface {
  /// Genera un objeto JSON
  void generateJson({
    required String jsonName,
    required Function(Map<String, dynamic> data) jsonMap,
    int? seed,
    String? format,
  });

  /// Genera una lista de objetos JSON
  void generateJsonList({
    required String jsonName,
    required Function(List<Map<String, dynamic>> data) jsonMap,
    bool addIdAutoincrement = false,
    int? recordCount,
    String? format,
  });
}
