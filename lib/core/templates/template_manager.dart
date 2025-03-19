import 'package:generador_de_json/core/interfaces/template_interface.dart';
import 'package:generador_de_json/core/templates/base_template.dart';
import 'package:generador_de_json/core/templates/product_template.dart';
import 'package:generador_de_json/core/templates/template_registry.dart';
import 'package:generador_de_json/core/templates/user_template.dart';
import 'package:generador_de_json/core/utils/logger.dart';

/// Gestor de templates para la generación de JSON
class TemplateManager {
  /// Registro de templates
  final TemplateRegistry _registry = TemplateRegistry.instance;
  
  /// Constructor que inicializa los templates por defecto
  TemplateManager() {
    _registerDefaultTemplates();
  }
  
  /// Registra los templates predeterminados
  void _registerDefaultTemplates() {
    try {
      // Registrar el template de usuario
      _registry.registerTemplate(UserTemplate());
      
      // Registrar el template de producto
      _registry.registerTemplate(ProductTemplate());
      
      AppLogger.debug('Templates predeterminados registrados');
    } catch (e) {
      AppLogger.error('Error al registrar templates predeterminados', e, StackTrace.current);
      rethrow;
    }
  }
  
  /// Registra un nuevo template
  void registerTemplate(TemplateInterface template) {
    _registry.registerTemplate(template);
  }
  
  /// Obtiene un template por su nombre
  TemplateInterface getTemplate(String templateName) {
    return _registry.getTemplate(templateName);
  }
  
  /// Verifica si un template está registrado
  bool hasTemplate(String templateName) {
    return _registry.hasTemplate(templateName);
  }
  
  /// Obtiene los nombres de todos los templates disponibles
  List<String> getAvailableTemplates() {
    return _registry.getTemplateNames();
  }
  
  /// Genera un objeto JSON a partir de un template
  Map<String, dynamic> generateObject(String templateName) {
    try {
      final template = _registry.getTemplate(templateName);
      return template.generateMap();
    } catch (e) {
      AppLogger.error('Error al generar objeto desde template: $templateName', e, StackTrace.current);
      if (e is TemplateException) {
        rethrow;
      }
      throw TemplateException.generationError(
        'Error al generar objeto desde template: $templateName',
        originalError: e,
      );
    }
  }
  
  /// Genera una lista de objetos JSON a partir de un template
  List<Map<String, dynamic>> generateList(String templateName, int count) {
    try {
      final template = _registry.getTemplate(templateName);
      return template.generateList(count);
    } catch (e) {
      AppLogger.error('Error al generar lista desde template: $templateName', e, StackTrace.current);
      if (e is TemplateException) {
        rethrow;
      }
      throw TemplateException.generationError(
        'Error al generar lista desde template: $templateName',
        originalError: e,
      );
    }
  }
  
  /// Aplica un template a datos existentes
  Map<String, dynamic> applyTemplate(String templateName, Map<String, dynamic> data) {
    try {
      final template = _registry.getTemplate(templateName);
      return template.applyTemplate(data);
    } catch (e) {
      AppLogger.error('Error al aplicar template: $templateName', e, StackTrace.current);
      if (e is TemplateException) {
        rethrow;
      }
      throw TemplateException.generationError(
        'Error al aplicar template: $templateName',
        originalError: e,
      );
    }
  }
  
  /// Valida que un objeto cumpla con un template
  bool validateObject(String templateName, Map<String, dynamic> data) {
    try {
      final template = _registry.getTemplate(templateName);
      return template.validateData(data);
    } catch (e) {
      AppLogger.error('Error al validar objeto con template: $templateName', e, StackTrace.current);
      if (e is TemplateException) {
        rethrow;
      }
      throw TemplateException.validationError(
        'Error al validar objeto con template: $templateName',
        originalError: e,
      );
    }
  }
  
  /// Obtiene el esquema de un template
  Map<String, dynamic> getSchema(String templateName) {
    try {
      final template = _registry.getTemplate(templateName);
      return template.getSchema();
    } catch (e) {
      AppLogger.error('Error al obtener esquema de template: $templateName', e, StackTrace.current);
      if (e is TemplateException) {
        rethrow;
      }
      throw TemplateException(
        message: 'Error al obtener esquema de template: $templateName',
        originalError: e,
      );
    }
  }
} 