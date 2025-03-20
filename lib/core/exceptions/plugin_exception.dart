import 'package:generador_de_json/core/exceptions/base_exception.dart';

/// Prefijo para los códigos de error de plugins
const String _prefix = 'PLUGIN';

/// Excepción para errores relacionados con plugins
class PluginException extends BaseException {
  PluginException({required String message, required String code, dynamic originalError})
    : super(message: message, code: '${_prefix}_$code', originalError: originalError);

  /// Error de carga de plugin
  factory PluginException.loadError(String pluginId, {dynamic originalError}) {
    return PluginException(
      message: 'Error al cargar plugin: $pluginId',
      code: 'LOAD_ERROR',
      originalError: originalError,
    );
  }

  /// Error de inicialización de plugin
  factory PluginException.initializationError(String pluginId, {dynamic originalError}) {
    return PluginException(
      message: 'Error al inicializar plugin: $pluginId',
      code: 'INIT_ERROR',
      originalError: originalError,
    );
  }

  /// Error al no encontrar un plugin
  factory PluginException.pluginNotFound(String pluginId) {
    return PluginException(
      message: 'Plugin no encontrado: $pluginId',
      code: 'NOT_FOUND',
      originalError: 'El plugin solicitado ($pluginId) no está registrado en la aplicación',
    );
  }

  /// Error de dependencias de plugin
  factory PluginException.dependencyError(String pluginId, String dependencyId) {
    return PluginException(
      message: 'Error de dependencia para plugin $pluginId: dependencia $dependencyId no encontrada',
      code: 'DEPENDENCY_ERROR',
      originalError: 'El plugin $pluginId requiere el plugin $dependencyId que no está instalado',
    );
  }

  /// Error de versión incompatible
  factory PluginException.incompatibleVersion(String pluginId, String requiredVersion, String actualVersion) {
    return PluginException(
      message: 'Versión incompatible para plugin $pluginId: requiere $requiredVersion, actual $actualVersion',
      code: 'VERSION_ERROR',
      originalError:
          'El plugin $pluginId requiere la versión $requiredVersion, pero la versión actual es $actualVersion',
    );
  }

  /// Error de configuración de plugin
  factory PluginException.configurationError(String pluginId, {dynamic originalError}) {
    return PluginException(
      message: 'Error de configuración para plugin $pluginId',
      code: 'CONFIG_ERROR',
      originalError: originalError,
    );
  }
}
