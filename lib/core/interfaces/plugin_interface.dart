/// Interfaz base para todos los plugins del sistema
abstract class PluginInterface {
  /// Nombre único del plugin
  String get pluginName;

  /// Descripción del plugin
  String get pluginDescription;

  /// Versión del plugin
  String get pluginVersion;

  /// Autor del plugin
  String get pluginAuthor;

  /// ID único del plugin (normalmente en formato reverso de dominio)
  String get pluginId;

  /// Inicializa el plugin
  void initialize();

  /// Notifica si el plugin está habilitado
  bool isEnabled();

  /// Configuración del plugin
  Map<String, dynamic> get pluginConfig;

  /// Define las dependencias del plugin
  List<String> get dependencies;

  /// Registra las funcionalidades del plugin en el sistema
  void registerFunctionalities();
}
