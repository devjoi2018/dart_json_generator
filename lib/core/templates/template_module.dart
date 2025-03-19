import 'package:generador_de_json/core/base_module.dart';
import 'package:generador_de_json/core/templates/template_manager.dart';
import 'package:generador_de_json/core/utils/logger.dart';

/// Módulo para la gestión de templates
class TemplateModule extends BaseModule {
  /// Gestor de templates
  late final TemplateManager _templateManager;

  @override
  String get moduleName => 'template_manager';

  @override
  String get moduleVersion => '1.0.0';

  /// Descripción del módulo
  String get moduleDescription => 'Módulo para la gestión de templates JSON';

  /// Obtiene el gestor de templates
  TemplateManager get templateManager => _templateManager;

  @override
  void initialize() {
    AppLogger.debug('Inicializando módulo: $moduleName v$moduleVersion');
    
    // Inicializar el gestor de templates
    _templateManager = TemplateManager();
    
    AppLogger.debug('Módulo inicializado correctamente: $moduleName');
  }

  /// Libera los recursos del módulo
  void dispose() {
    AppLogger.debug('Finalizando módulo: $moduleName');
    // No hay recursos que liberar
  }
} 