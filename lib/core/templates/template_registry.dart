import 'package:generador_de_json/core/interfaces/template_interface.dart';
import 'package:generador_de_json/core/templates/base_template.dart';
import 'package:generador_de_json/core/utils/logger.dart';
import 'package:generador_de_json/core/utils/validators.dart';

/// Registro de templates disponibles
class TemplateRegistry {
  /// Mapa de templates registrados
  final Map<String, TemplateInterface> _templates = {};

  /// Constructor privado para Singleton
  TemplateRegistry._();

  /// Instancia única
  static final TemplateRegistry _instance = TemplateRegistry._();

  /// Obtiene la instancia única del registro
  static TemplateRegistry get instance => _instance;

  /// Registra un nuevo template
  void registerTemplate(TemplateInterface template) {
    try {
      Validators.validateNotNull(template, 'template');
      Validators.validateNotEmpty(template.name, 'template.name');

      if (_templates.containsKey(template.name)) {
        AppLogger.warning('El template ${template.name} ya está registrado. Se sobrescribirá.');
      }

      _templates[template.name] = template;
      AppLogger.debug('Template registrado: ${template.name} v${template.version}');
    } catch (e) {
      AppLogger.error('Error al registrar template', e, StackTrace.current);
      rethrow;
    }
  }

  /// Obtiene un template por su nombre
  TemplateInterface getTemplate(String templateName) {
    try {
      Validators.validateNotEmpty(templateName, 'templateName');

      if (!_templates.containsKey(templateName)) {
        throw TemplateException.templateNotFound(templateName);
      }

      return _templates[templateName]!;
    } catch (e) {
      AppLogger.error('Error al obtener template: $templateName', e, StackTrace.current);
      if (e is TemplateException) {
        rethrow;
      }
      throw TemplateException.templateNotFound(templateName, originalError: e);
    }
  }

  /// Verifica si un template está registrado
  bool hasTemplate(String templateName) {
    try {
      Validators.validateNotEmpty(templateName, 'templateName');
      return _templates.containsKey(templateName);
    } catch (e) {
      AppLogger.error('Error al verificar existencia de template', e, StackTrace.current);
      return false;
    }
  }

  /// Obtiene los nombres de todos los templates registrados
  List<String> getTemplateNames() {
    return _templates.keys.toList();
  }

  /// Obtiene todos los templates registrados
  List<TemplateInterface> getAllTemplates() {
    return _templates.values.toList();
  }

  /// Elimina un template del registro
  void unregisterTemplate(String templateName) {
    try {
      Validators.validateNotEmpty(templateName, 'templateName');

      if (!_templates.containsKey(templateName)) {
        AppLogger.warning('Template no encontrado para eliminar: $templateName');
        return;
      }

      _templates.remove(templateName);
      AppLogger.debug('Template eliminado: $templateName');
    } catch (e) {
      AppLogger.error('Error al eliminar template', e, StackTrace.current);
      rethrow;
    }
  }

  /// Limpia todos los templates registrados
  void clearTemplates() {
    _templates.clear();
    AppLogger.debug('Registro de templates limpiado');
  }
} 