import 'dart:convert';
import 'dart:io';

class GenerateJson {
  /// Metodo que genera una lista de datos en un json, para usarlo de forma
  /// correecta, en el parametro [jsonMap] se debe pasar una funcion que
  /// retorne una lista de mapas, se debe usar un [List.generate()] como se muestra en el siguinete ejemplo:
  ///```dart
  ///   List.generate(
  ///   100,
  ///   (index) => <String, dynamic>{
  ///     'id': index,
  ///     'name': util.generateRandomFemaleOrMaleName(isFullName: true),
  ///     'email': util.generateRandomEmail(),
  ///     'avatar': util.generateRandomAvatarUrl(),
  ///   },
  /// );
  ///```
  void generateJsonList({
    /// Nombre del archivo json a generar, para poder generar una lista de forma correcta
    required String jsonName,

    /// Mapa de datos que se van a generar en el json
    required Function(List<Map<String, dynamic>> data) jsonMap,
    bool addIdAutoincrement = false,
  }) {
    // Accede a la variable data de la funcion jsonMap
    final List<Map<String, dynamic>> data = jsonMap([]);

    _convertAndSaveJson(
      jsonName: jsonName,
      data: data,
    );
  }

  // Metodo que convierte un mapa en un archivo json y lo guarda en la ruta especificada
  void _convertAndSaveJson({required String jsonName, required Object data}) {
    //Le damos fromato al json
    final String json = JsonEncoder.withIndent('  ').convert(data);
    // Creamos el archivo json en la carpeta actual
    File file = File('lib/$jsonName.json');
    // Crea el archivo json en la ruta especificada
    file.create(recursive: true).then((File file) {
      file.writeAsString(json);
      print('Archivo json $jsonName, fue generado en la ruta ${file.path}');
    });
  }
}
