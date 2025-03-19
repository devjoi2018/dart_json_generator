import 'package:generador_de_json/core/base_module.dart';
import 'package:generador_de_json/features/json_generator/generate_json.dart';

/// Módulo para la generación de JSON
class JsonGeneratorModule extends BaseModule {
  /// Instancia singleton del módulo
  static final JsonGeneratorModule _instance = JsonGeneratorModule._internal();

  /// Instancia del generador de JSON
  final GenerateJson _generator = GenerateJson();

  /// Constructor interno
  JsonGeneratorModule._internal();

  /// Fábrica para obtener la instancia singleton
  factory JsonGeneratorModule() {
    return _instance;
  }

  /// Nombre del módulo
  @override
  String get moduleName => 'json_generator';

  /// Versión del módulo
  @override
  String get moduleVersion => '1.0.0';

  /// Inicializa el módulo
  @override
  void initialize() {
    // Código de inicialización si es necesario
    print('Módulo de generación de JSON inicializado');
  }

  /// Obtiene el generador de JSON
  GenerateJson get generator => _generator;
}
