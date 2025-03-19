import 'package:generador_de_json/core/base_module.dart';
import 'package:generador_de_json/core/data_generators/data_generator_factory.dart';
import 'package:generador_de_json/core/interfaces/data_generator_interface.dart';

/// Módulo para la generación de datos
class DataGeneratorModule extends BaseModule {
  /// Instancia singleton del módulo
  static final DataGeneratorModule _instance = DataGeneratorModule._internal();

  /// Instancia del generador de datos por defecto
  late final DataGeneratorInterface _defaultGenerator;

  /// Constructor interno
  DataGeneratorModule._internal() {
    _defaultGenerator = DataGeneratorFactory.create(GeneratorType.random);
  }

  /// Fábrica para obtener la instancia singleton
  factory DataGeneratorModule() {
    return _instance;
  }

  /// Nombre del módulo
  @override
  String get moduleName => 'data_generator';

  /// Versión del módulo
  @override
  String get moduleVersion => '1.0.0';

  /// Inicializa el módulo
  @override
  void initialize() {
    // Código de inicialización si es necesario
    print('Módulo de generación de datos inicializado');
  }

  /// Obtiene el generador de datos por defecto
  DataGeneratorInterface get defaultGenerator => _defaultGenerator;

  /// Crea un generador de datos según el tipo especificado
  DataGeneratorInterface createGenerator(GeneratorType type) {
    return DataGeneratorFactory.create(type);
  }
}
