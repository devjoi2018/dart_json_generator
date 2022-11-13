import 'package:generador_de_json/generate_json.dart';
import 'package:generador_de_json/utils/all_utils.dart';

void main(List<String> arguments) {
  // Instancia una lista de utilidades para la generacion de datos
  final AllUtils util = AllUtils();
  // Instancia la clase que genera los json
  final GenerateJson generateJson = GenerateJson();

  /// Ejemplo de como generar un json con un solo dato
  generateJson.generateJson(
    jsonName: 'example',
    jsonMap: (Map<String, dynamic> data) {
      return <String, dynamic>{
        'id': 1,
        'name': util.generateRandomFemaleOrMaleName(isFullName: true),
        'email': util.generateRandomEmail(),
        'avatar': util.generateRandomAvatarUrl(),
      };
    },
  );

  /// Ejemplo de como generar un json con una lista de datos
  generateJson.generateJsonList(
    jsonName: 'example_list',
    jsonMap: (List<Map<String, dynamic>> data) {
      return List.generate(
        100,
        (index) => <String, dynamic>{
          'id': index,
          'name': util.generateRandomFemaleOrMaleName(isFullName: true),
          'email': util.generateRandomEmail(),
          'avatar': util.generateRandomAvatarUrl(),
        },
      );
    },
  );
}
