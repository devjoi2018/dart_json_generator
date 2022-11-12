import 'package:generador_de_json/generate_json.dart';
import 'package:generador_de_json/utils/all_utils.dart';

void main(List<String> arguments) {
  // Instancia una lista de utilidades para la generacion de datos
  final AllUtils util = AllUtils();
  // Instancia la clase que genera los json
  final GenerateJson generateJson = GenerateJson();
  generateJson.generateJsonList(
    jsonName: 'test_data',
    jsonMap: (data) {
      return List.generate(
        100,
        (index) => <String, dynamic>{
          'id': index,
          'name': util.generateRandomFemaleOrMaleName(),
          'lastName': util.generateRandomLastName(),
          'email': util.generateRandomEmail(),
          'avatar': util.generateRandomAvatarUrl(),
          'phone': util.generateRandomPhoneNumber(),
          'isShared': util.generateRandomBool(),
        },
      );
    },
  );
}
