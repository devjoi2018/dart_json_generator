import 'package:generador_de_json/core/config/app_config.dart';
import 'package:generador_de_json/core/data_generators/data_generator_module.dart';
import 'package:generador_de_json/core/exceptions/exceptions.dart';
import 'package:generador_de_json/core/interfaces/data_generator_interface.dart';
import 'package:generador_de_json/core/interfaces/module_interface.dart';
import 'package:generador_de_json/core/interfaces/template_interface.dart';
import 'package:generador_de_json/core/module_registry.dart';
import 'package:generador_de_json/core/templates/template_module.dart';
import 'package:generador_de_json/core/utils/logger.dart';
import 'package:generador_de_json/core/utils/validators.dart';
import 'package:generador_de_json/features/json_generator/generate_json.dart';
import 'package:generador_de_json/features/json_generator/json_generator_module.dart';

/// Clase principal de la aplicación
class App {
  /// Instancia singleton de la aplicación
  static final App _instance = App._internal();

  /// Registro de módulos
  final ModuleRegistry _moduleRegistry = ModuleRegistry();

  /// Configuración de la aplicación
  final AppConfig _config = AppConfig();

  /// Estado de inicialización
  bool _initialized = false;

  /// Constructor interno
  App._internal();

  /// Fábrica para obtener la instancia singleton
  factory App() {
    return _instance;
  }

  /// Obtiene la configuración de la aplicación
  AppConfig get config => _config;

  /// Inicializa la aplicación y todos sus módulos
  void initialize() {
    if (_initialized) {
      AppLogger.warning('La aplicación ya está inicializada.');
      return;
    }

    try {
      // Inicializar el sistema de logging con configuración básica
      AppLogger.init();
      AppLogger.info('Inicializando la aplicación...');

      // Cargar configuración
      try {
        _config.loadConfig();

        // Reinicializar el logger con la configuración cargada
        AppLogger.close();
        AppLogger.init(
          logLevel: _config.getLogLevel(),
          logToFile: _config.logToFile,
          logToConsole: _config.logToConsole,
        );
        AppLogger.info('Configuración cargada y aplicada');
      } catch (e) {
        AppLogger.warning('Error al cargar la configuración. Se usarán los valores por defecto.', e);
      }

      // Registra los módulos principales
      _registerCoreModules();

      // Inicializa todos los módulos registrados
      _moduleRegistry.initializeModules();

      _initialized = true;
      AppLogger.info('Aplicación inicializada correctamente.');
    } catch (e) {
      AppLogger.error('Error al inicializar la aplicación', e, StackTrace.current);
      if (e is BaseException) {
        rethrow;
      }
      throw AppException.initializationError('Error al inicializar la aplicación', originalError: e);
    }
  }

  /// Registra los módulos principales de la aplicación
  void _registerCoreModules() {
    try {
      AppLogger.debug('Registrando módulos principales...');

      // Módulo de generación de datos
      final dataGeneratorModule = DataGeneratorModule();
      _validateModule(dataGeneratorModule, 'DataGeneratorModule');
      _moduleRegistry.registerModule(dataGeneratorModule);
      AppLogger.debug('Módulo DataGeneratorModule registrado correctamente');

      // Módulo de generación de JSON
      final jsonGeneratorModule = JsonGeneratorModule();
      _validateModule(jsonGeneratorModule, 'JsonGeneratorModule');
      _moduleRegistry.registerModule(jsonGeneratorModule);
      AppLogger.debug('Módulo JsonGeneratorModule registrado correctamente');

      // Módulo de templates
      final templateModule = TemplateModule();
      _validateModule(templateModule, 'TemplateModule');
      _moduleRegistry.registerModule(templateModule);
      AppLogger.debug('Módulo TemplateModule registrado correctamente');

      AppLogger.info('Todos los módulos principales han sido registrados');
    } catch (e) {
      AppLogger.error('Error al registrar módulos principales', e, StackTrace.current);
      if (e is BaseException) {
        rethrow;
      }
      throw AppException.moduleRegistrationError('Error al registrar módulos principales', originalError: e);
    }
  }

  /// Obtiene el generador de datos por defecto
  DataGeneratorInterface get dataGenerator {
    _validateInitialized();

    final moduleName = 'data_generator';
    AppLogger.debug('Obteniendo el generador de datos: $moduleName');

    final dataGeneratorModule = _moduleRegistry.getModule<DataGeneratorModule>(moduleName);

    if (dataGeneratorModule == null) {
      final errorMsg = 'Módulo no encontrado: $moduleName';
      AppLogger.error(errorMsg);
      throw AppException.moduleNotFound(moduleName);
    }

    return dataGeneratorModule.defaultGenerator;
  }

  /// Obtiene el generador de JSON
  GenerateJson get jsonGenerator {
    _validateInitialized();

    final moduleName = 'json_generator';
    AppLogger.debug('Obteniendo el generador de JSON: $moduleName');

    final jsonGeneratorModule = _moduleRegistry.getModule<JsonGeneratorModule>(moduleName);

    if (jsonGeneratorModule == null) {
      final errorMsg = 'Módulo no encontrado: $moduleName';
      AppLogger.error(errorMsg);
      throw AppException.moduleNotFound(moduleName);
    }

    return jsonGeneratorModule.generator;
  }

  /// Obtiene el gestor de templates
  TemplateModule get templateModule {
    _validateInitialized();

    final moduleName = 'template_manager';
    AppLogger.debug('Obteniendo el módulo de templates: $moduleName');

    final module = _moduleRegistry.getModule<TemplateModule>(moduleName);

    if (module == null) {
      final errorMsg = 'Módulo no encontrado: $moduleName';
      AppLogger.error(errorMsg);
      throw AppException.moduleNotFound(moduleName);
    }

    return module;
  }

  /// Obtiene un template específico por su nombre
  TemplateInterface getTemplate(String templateName) {
    return templateModule.templateManager.getTemplate(templateName);
  }

  /// Verifica si existe un template con el nombre especificado
  bool hasTemplate(String templateName) {
    return templateModule.templateManager.hasTemplate(templateName);
  }

  /// Obtiene la lista de nombres de templates disponibles
  List<String> getAvailableTemplates() {
    return templateModule.templateManager.getAvailableTemplates();
  }

  /// Valida que la aplicación esté inicializada
  void _validateInitialized() {
    if (!_initialized) {
      const errorMsg = 'La aplicación no ha sido inicializada. Debe llamar a initialize() primero.';
      AppLogger.error(errorMsg);
      throw AppException.initializationError(errorMsg);
    }
  }

  /// Valida que un módulo sea válido
  void _validateModule(ModuleInterface module, String moduleName) {
    try {
      AppLogger.debug('Validando módulo: $moduleName');

      Validators.validateNotNull(module, moduleName);

      if (module.moduleName.isEmpty) {
        final errorMsg = 'El nombre del módulo $moduleName no puede estar vacío';
        AppLogger.error(errorMsg);
        throw AppException.moduleRegistrationError(errorMsg);
      }

      if (module.moduleVersion.isEmpty) {
        final errorMsg = 'La versión del módulo $moduleName no puede estar vacía';
        AppLogger.error(errorMsg);
        throw AppException.moduleRegistrationError(errorMsg);
      }

      AppLogger.debug('Módulo validado correctamente: $moduleName (${module.moduleVersion})');
    } catch (e) {
      AppLogger.error('Error al validar el módulo $moduleName', e, StackTrace.current);
      if (e is BaseException) {
        rethrow;
      }
      throw AppException.moduleRegistrationError('Error al validar el módulo $moduleName', originalError: e);
    }
  }

  /// Finaliza la aplicación y libera recursos
  void dispose() {
    if (_initialized) {
      AppLogger.info('Finalizando la aplicación...');
      _initialized = false;

      // Guardar configuración
      try {
        _config.saveConfig();
        AppLogger.debug('Configuración guardada');
      } catch (e) {
        AppLogger.warning('Error al guardar la configuración', e);
      }

      // Cerrar el sistema de logging
      AppLogger.close();
    }
  }
}
