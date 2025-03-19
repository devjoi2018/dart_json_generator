/// Interfaz base para todos los módulos del sistema
abstract class ModuleInterface {
  /// Nombre único del módulo
  String get moduleName;

  /// Versión del módulo
  String get moduleVersion;

  /// Inicializa el módulo
  void initialize();

  /// Registra las dependencias del módulo
  void registerDependencies();

  /// Notifica si el módulo está habilitado
  bool isEnabled();
}
