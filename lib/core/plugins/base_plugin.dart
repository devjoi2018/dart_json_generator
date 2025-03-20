import 'package:generador_de_json/core/interfaces/plugin_interface.dart';

/// Clase base para implementar plugins
abstract class BasePlugin implements PluginInterface {
  /// Versión por defecto
  @override
  String get pluginVersion => '1.0.0';

  /// Autor por defecto
  @override
  String get pluginAuthor => 'Desconocido';

  /// Por defecto, todos los plugins están habilitados
  @override
  bool isEnabled() => true;

  /// Configuración por defecto (vacía)
  @override
  Map<String, dynamic> get pluginConfig => {};

  /// Por defecto, no hay dependencias
  @override
  List<String> get dependencies => [];

  /// Método de inicialización que debe ser implementado por cada plugin
  @override
  void initialize();

  /// Registro de funcionalidades que debe ser implementado por cada plugin
  @override
  void registerFunctionalities();

  /// Notifica si el plugin es compatible con la versión actual de la aplicación
  bool isCompatibleWithHost(String hostVersion) => true;
}
