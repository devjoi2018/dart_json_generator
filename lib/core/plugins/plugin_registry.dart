import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:generador_de_json/core/exceptions/exceptions.dart';
import 'package:generador_de_json/core/interfaces/plugin_interface.dart';
import 'package:generador_de_json/core/utils/logger.dart';
import 'package:generador_de_json/core/utils/validators.dart';

/// Gestor del registro de plugins
class PluginRegistry {
  /// Instancia singleton del registro de plugins
  static final PluginRegistry _instance = PluginRegistry._internal();

  /// Mapa que almacena los plugins registrados por ID
  final Map<String, PluginInterface> _plugins = {};

  /// Directorio donde se almacenan los plugins
  static const String _pluginsDir = 'plugins';

  /// Constructor interno
  PluginRegistry._internal();

  /// Fábrica para obtener la instancia singleton
  factory PluginRegistry() {
    return _instance;
  }

  /// Registra un plugin en el registro
  void registerPlugin(PluginInterface plugin) {
    // Validar que el plugin no sea nulo
    Validators.validateNotNull(plugin, 'plugin');

    // Validar que el ID del plugin sea válido
    Validators.validateNotEmpty(plugin.pluginId, 'plugin.pluginId');

    // Validar que el nombre del plugin sea válido
    Validators.validateNotEmpty(plugin.pluginName, 'plugin.pluginName');

    // Validar que la versión del plugin sea válida
    Validators.validateNotEmpty(plugin.pluginVersion, 'plugin.pluginVersion');

    if (_plugins.containsKey(plugin.pluginId)) {
      AppLogger.warning('El plugin ${plugin.pluginName} (${plugin.pluginId}) ya está registrado y será sobrescrito.');
    }

    try {
      _plugins[plugin.pluginId] = plugin;
      AppLogger.info(
        'Plugin ${plugin.pluginName} (${plugin.pluginId} v${plugin.pluginVersion}) registrado correctamente.',
      );
    } catch (e) {
      AppLogger.error('Error al registrar plugin: ${plugin.pluginId}', e, StackTrace.current);
      throw PluginException.loadError(plugin.pluginId, originalError: e);
    }
  }

  /// Verifica las dependencias de un plugin
  void _checkDependencies(PluginInterface plugin) {
    for (final dependency in plugin.dependencies) {
      if (!_plugins.containsKey(dependency)) {
        throw PluginException.dependencyError(plugin.pluginId, dependency);
      }
    }
  }

  /// Inicializa todos los plugins registrados
  void initializePlugins() {
    if (_plugins.isEmpty) {
      AppLogger.info('No hay plugins registrados para inicializar.');
      return;
    }

    AppLogger.info('Inicializando ${_plugins.length} plugins...');

    // Verificar dependencias de todos los plugins primero
    for (final plugin in _plugins.values) {
      try {
        _checkDependencies(plugin);
      } catch (e) {
        AppLogger.error('Error de dependencias en plugin ${plugin.pluginId}', e, StackTrace.current);
        if (e is! PluginException) {
          throw PluginException.dependencyError(plugin.pluginId, 'desconocida');
        }
        rethrow;
      }
    }

    // Inicializar plugins
    for (final plugin in _plugins.values) {
      try {
        if (plugin.isEnabled()) {
          plugin.initialize();
          plugin.registerFunctionalities();
          AppLogger.info('Plugin ${plugin.pluginName} (${plugin.pluginId} v${plugin.pluginVersion}) inicializado.');
        } else {
          AppLogger.info('Plugin ${plugin.pluginName} (${plugin.pluginId}) deshabilitado, omitiendo inicialización.');
        }
      } catch (e) {
        AppLogger.error('Error al inicializar plugin ${plugin.pluginId}', e, StackTrace.current);
        throw PluginException.initializationError(plugin.pluginId, originalError: e);
      }
    }

    AppLogger.info('Todos los plugins han sido inicializados correctamente.');
  }

  /// Descubre y carga plugins desde el directorio de plugins
  Future<void> discoverPlugins() async {
    final pluginsDirectory = Directory(_pluginsDir);

    if (!await pluginsDirectory.exists()) {
      AppLogger.info('Creando directorio de plugins: $_pluginsDir');
      await pluginsDirectory.create(recursive: true);
      return;
    }

    AppLogger.info('Buscando plugins en: $_pluginsDir');

    final entries = await pluginsDirectory.list().toList();
    final pluginDirs =
        entries.where((entity) => entity is Directory && !path.basename(entity.path).startsWith('.')).toList();

    if (pluginDirs.isEmpty) {
      AppLogger.info('No se encontraron plugins en el directorio $_pluginsDir');
      return;
    }

    AppLogger.info('Encontrados ${pluginDirs.length} posibles plugins.');

    // Aquí normalmente cargaríamos los plugins dinámicamente
    // Sin embargo, en Dart, la carga dinámica es limitada
    // En su lugar, utilizamos un enfoque basado en registro manual

    // Esto es solo para proporcionar información en el log
    for (final dir in pluginDirs) {
      AppLogger.debug('Plugin encontrado en: ${dir.path}');
    }
  }

  /// Obtiene un plugin registrado por su ID
  T? getPlugin<T extends PluginInterface>(String pluginId) {
    // Validar que el ID del plugin sea válido
    Validators.validateNotEmpty(pluginId, 'pluginId');

    final plugin = _plugins[pluginId];
    if (plugin != null && plugin is T) {
      return plugin;
    }
    return null;
  }

  /// Verifica si un plugin está registrado
  bool hasPlugin(String pluginId) {
    // Validar que el ID del plugin sea válido
    try {
      Validators.validateNotEmpty(pluginId, 'pluginId');
      return _plugins.containsKey(pluginId);
    } catch (e) {
      return false;
    }
  }

  /// Obtiene una lista de todos los plugins registrados
  List<PluginInterface> get allPlugins => _plugins.values.toList();

  /// Obtiene una lista de los IDs de todos los plugins registrados
  List<String> get pluginIds => _plugins.keys.toList();

  /// Obtiene información detallada de todos los plugins
  List<Map<String, dynamic>> get pluginsInfo {
    return _plugins.values
        .map(
          (plugin) => {
            'id': plugin.pluginId,
            'name': plugin.pluginName,
            'description': plugin.pluginDescription,
            'version': plugin.pluginVersion,
            'author': plugin.pluginAuthor,
            'enabled': plugin.isEnabled(),
            'dependencies': plugin.dependencies,
          },
        )
        .toList();
  }
}
