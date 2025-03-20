import 'package:generador_de_json/core/base_module.dart';
import 'package:generador_de_json/core/plugins/plugin_registry.dart';
import 'package:generador_de_json/core/utils/logger.dart';

/// Módulo para la gestión de plugins
class PluginModule extends BaseModule {
  /// Instancia singleton del módulo
  static final PluginModule _instance = PluginModule._internal();

  /// Gestor de plugins
  late final PluginRegistry _pluginRegistry;

  /// Constructor interno
  PluginModule._internal() {
    _pluginRegistry = PluginRegistry();
  }

  /// Fábrica para obtener la instancia singleton
  factory PluginModule() {
    return _instance;
  }

  /// Nombre del módulo
  @override
  String get moduleName => 'plugin_manager';

  /// Versión del módulo
  @override
  String get moduleVersion => '1.0.0';

  /// Obtiene el gestor de plugins
  PluginRegistry get pluginRegistry => _pluginRegistry;

  /// Inicializa el módulo
  @override
  void initialize() {
    AppLogger.info('Inicializando módulo: $moduleName v$moduleVersion');

    try {
      // Inicializar los plugins registrados manualmente
      // La detección asíncrona debe realizarse después mediante el método discoverAndLoadPlugins
      _pluginRegistry.initializePlugins();

      AppLogger.info('Módulo inicializado correctamente: $moduleName');
    } catch (e) {
      AppLogger.error('Error al inicializar el módulo de plugins', e, StackTrace.current);
      rethrow;
    }
  }

  /// Descubre y carga plugins de forma asíncrona
  Future<void> discoverAndLoadPlugins() async {
    try {
      AppLogger.info('Buscando plugins instalados...');
      await _pluginRegistry.discoverPlugins();
      AppLogger.info('Búsqueda de plugins completada');
    } catch (e) {
      AppLogger.error('Error al buscar plugins', e, StackTrace.current);
      rethrow;
    }
  }

  /// Registra las dependencias del módulo
  @override
  void registerDependencies() {
    // No hay dependencias específicas para este módulo
    AppLogger.debug('Registrando dependencias del módulo: $moduleName');
  }
}
