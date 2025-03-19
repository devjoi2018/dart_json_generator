/// Interfaz que define el contrato para los generadores de JSON
abstract class JsonGeneratorInterface {
  /// Genera un JSON con un solo objeto
  void generateJson({required String jsonName, required Function(Map<String, dynamic> data) jsonMap, int? seed});

  /// Genera un JSON con una lista de objetos
  void generateJsonList({
    required String jsonName,
    required Function(List<Map<String, dynamic>> data) jsonMap,
    bool addIdAutoincrement,
    int? recordCount,
  });
}
