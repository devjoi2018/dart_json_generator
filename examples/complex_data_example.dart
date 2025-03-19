import 'package:generador_de_json/core/data_generators/data_generator_factory.dart';
import 'package:generador_de_json/features/json_generator/generate_json.dart';

void main() {
  // Obtener la instancia del generador de datos
  final dataGenerator = DataGeneratorFactory.create(GeneratorType.random);

  // Crear instancia del generador JSON
  final jsonGenerator = GenerateJson();

  // Generar un JSON con datos complejos
  jsonGenerator.generateJson(
    jsonName: 'datos_complejos',
    jsonMap: (data) {
      // Enriquecer los datos del usuario con tipos complejos
      data['username'] = dataGenerator.generateRandomUsername();
      data['password'] = dataGenerator.generateRandomPassword(
        length: 16,
        includeUppercase: true,
        includeNumbers: true,
        includeSpecialChars: true,
      );
      data['uuid'] = dataGenerator.generateRandomUUID();
      data['location'] = {
        'coordinates': dataGenerator.generateRandomGeoCoordinates(
          minLat: 36.0,
          maxLat: 44.0,
          minLong: -10.0,
          maxLong: 5.0,
        ),
        'address': dataGenerator.generateRandomAddress(countryCode: 'ES'),
      };
      data['contact'] = {
        'phone': dataGenerator.generateRandomPhoneNumber(countryCode: 'ES', withPrefix: true),
        'website': dataGenerator.generateRandomUrl(category: 'web'),
        'profilePicture': dataGenerator.generateRandomUrl(category: 'profile'),
      };
      data['settings'] = {
        'theme': {
          'primary': dataGenerator.generateRandomColor(),
          'secondary': dataGenerator.generateRandomColor(),
          'background': dataGenerator.generateRandomColor(withAlpha: true),
        },
        'notifications': dataGenerator.generateRandomBool(trueProbability: 0.7),
      };
      data['bio'] = dataGenerator.generateRandomLoremIpsum(minWords: 20, maxWords: 50);

      return data;
    },
  );

  print('Archivo JSON generado con éxito: output/datos_complejos.json');
}
