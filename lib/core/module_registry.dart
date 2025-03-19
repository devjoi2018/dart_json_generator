import 'package:generador_de_json/core/exceptions/exceptions.dart';
import 'package:generador_de_json/core/interfaces/module_interface.dart';
import 'package:generador_de_json/core/utils/validators.dart';

/// Gestor del registro de módulos
class ModuleRegistry {
  /// Instancia singleton del registro de módulos
  static final ModuleRegistry _instance = ModuleRegistry._internal();

  /// Mapa que almacena los módulos registrados por nombre
  final Map<String, ModuleInterface> _modules = {};

  /// Constructor interno
  ModuleRegistry._internal();

  /// Fábrica para obtener la instancia singleton
  factory ModuleRegistry() {
    return _instance;
  }

  /// Registra un módulo en el registro
  void registerModule(ModuleInterface module) {
    // Validar que el módulo no sea nulo
    Validators.validateNotNull(module, 'module');

    // Validar que el nombre del módulo sea válido
    Validators.validateNotEmpty(module.moduleName, 'module.moduleName');

    // Validar que la versión del módulo sea válida
    Validators.validateNotEmpty(module.moduleVersion, 'module.moduleVersion');

    if (_modules.containsKey(module.moduleName)) {
      print('ADVERTENCIA: El módulo ${module.moduleName} ya está registrado y será sobrescrito.');
    }

    try {
      _modules[module.moduleName] = module;
      module.registerDependencies();
      print('Módulo ${module.moduleName} (v${module.moduleVersion}) registrado correctamente.');
    } catch (e) {
      throw AppException.moduleRegistrationError(module.moduleName, originalError: e);
    }
  }

  /// Inicializa todos los módulos registrados
  void initializeModules() {
    if (_modules.isEmpty) {
      throw AppException.moduleRegistrationError('No hay módulos registrados para inicializar');
    }

    for (final module in _modules.values) {
      try {
        if (module.isEnabled()) {
          module.initialize();
          print('Módulo ${module.moduleName} (v${module.moduleVersion}) inicializado.');
        } else {
          print('Módulo ${module.moduleName} (v${module.moduleVersion}) deshabilitado, omitiendo inicialización.');
        }
      } catch (e) {
        throw AppException.initializationError('Error al inicializar el módulo ${module.moduleName}', originalError: e);
      }
    }
  }

  /// Obtiene un módulo registrado por su nombre
  T? getModule<T extends ModuleInterface>(String moduleName) {
    // Validar que el nombre del módulo sea válido
    Validators.validateNotEmpty(moduleName, 'moduleName');

    final module = _modules[moduleName];
    if (module != null && module is T) {
      return module;
    }
    return null;
  }

  /// Verifica si un módulo está registrado
  bool hasModule(String moduleName) {
    // Validar que el nombre del módulo sea válido
    try {
      Validators.validateNotEmpty(moduleName, 'moduleName');
      return _modules.containsKey(moduleName);
    } catch (e) {
      return false;
    }
  }

  /// Obtiene una lista de todos los módulos registrados
  List<ModuleInterface> get allModules => _modules.values.toList();

  /// Obtiene una lista de los nombres de todos los módulos registrados
  List<String> get moduleNames => _modules.keys.toList();
}
