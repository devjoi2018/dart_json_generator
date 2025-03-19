import 'package:generador_de_json/core/data_generators/random_data_generator.dart';
import 'package:generador_de_json/core/exceptions/data_generator_exception.dart';
import 'package:generador_de_json/core/interfaces/data_generator_interface.dart';

/// Tipo de generador de datos
enum GeneratorType {
  /// Generador de datos aleatorios
  random,
  // Otros tipos de generadores podrían agregarse en el futuro
}

/// Fábrica para obtener diferentes implementaciones de generadores de datos
class DataGeneratorFactory {
  /// Crea y devuelve una instancia del generador de datos según el tipo especificado
  static DataGeneratorInterface create(GeneratorType type) {
    try {
      switch (type) {
        case GeneratorType.random:
          return RandomDataGenerator();
      }
    } catch (e) {
      throw DataGeneratorException.unsupportedGeneratorType(type.toString(), originalError: e);
    }
  }
}
