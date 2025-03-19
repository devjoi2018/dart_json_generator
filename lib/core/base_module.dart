import 'package:generador_de_json/core/interfaces/module_interface.dart';

/// Clase base para implementar módulos
abstract class BaseModule implements ModuleInterface {
  /// Versión por defecto
  @override
  String get moduleVersion => '1.0.0';

  /// Por defecto, todos los módulos están habilitados
  @override
  bool isEnabled() => true;

  /// Implementación por defecto del registro de dependencias (no hace nada)
  @override
  void registerDependencies() {}

  /// Método de inicialización que debe ser implementado por cada módulo
  @override
  void initialize();

  /// Nombre del módulo que debe ser proporcionado por cada implementación
  @override
  String get moduleName;
}
