import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:generador_de_json/core/exceptions/exceptions.dart';
import 'package:generador_de_json/core/utils/logger.dart';

/// Clase para cargar y gestionar plugins
class PluginLoader {
  /// Directorio base para los plugins
  static const String pluginsBaseDir = 'plugins';

  /// Carga la configuración de un plugin desde su archivo manifest.json
  static Future<Map<String, dynamic>> loadPluginManifest(String pluginDir) async {
    final manifestFile = File(path.join(pluginDir, 'manifest.json'));

    if (!await manifestFile.exists()) {
      throw PluginException.loadError(path.basename(pluginDir), originalError: 'Archivo manifest.json no encontrado');
    }

    try {
      final jsonString = await manifestFile.readAsString();
      final manifest = json.decode(jsonString) as Map<String, dynamic>;

      // Validar que el manifest contiene los campos requeridos
      _validateManifest(manifest, path.basename(pluginDir));

      return manifest;
    } catch (e) {
      if (e is PluginException) rethrow;

      throw PluginException.loadError(
        path.basename(pluginDir),
        originalError: 'Error al leer manifest.json: ${e.toString()}',
      );
    }
  }

  /// Valida que el manifest contiene los campos requeridos
  static void _validateManifest(Map<String, dynamic> manifest, String pluginId) {
    final requiredFields = ['id', 'name', 'version', 'description', 'author', 'entryPoint'];

    for (final field in requiredFields) {
      if (!manifest.containsKey(field) || manifest[field] == null || manifest[field].toString().isEmpty) {
        throw PluginException.loadError(
          pluginId,
          originalError: 'Campo requerido no encontrado en manifest.json: $field',
        );
      }
    }

    // Validar que el ID coincide con el directorio del plugin
    if (manifest['id'] != pluginId && path.basename(pluginId) != manifest['id']) {
      AppLogger.warning('El ID del plugin (${manifest['id']}) no coincide con el nombre del directorio ($pluginId)');
    }
  }

  /// Crea un directorio para plugins si no existe
  static Future<void> ensurePluginDirectory() async {
    final directory = Directory(pluginsBaseDir);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
      AppLogger.info('Directorio de plugins creado: $pluginsBaseDir');
    }
  }

  /// Crea un plugin de ejemplo para mostrar la estructura
  static Future<void> createExamplePlugin() async {
    await ensurePluginDirectory();

    final exampleDir = Directory(path.join(pluginsBaseDir, 'example_plugin'));
    if (await exampleDir.exists()) {
      AppLogger.info('El plugin de ejemplo ya existe.');
      return;
    }

    await exampleDir.create();

    // Crear el archivo manifest.json
    final manifest = {
      'id': 'com.example.plugin',
      'name': 'Plugin de Ejemplo',
      'version': '1.0.0',
      'description': 'Un plugin de ejemplo para demostrar la estructura',
      'author': 'Dart JSON Generator',
      'entryPoint': 'main.dart',
      'dependencies': [],
    };

    final manifestFile = File(path.join(exampleDir.path, 'manifest.json'));
    final jsonString = const JsonEncoder.withIndent('  ').convert(manifest);
    await manifestFile.writeAsString(jsonString);

    // Crear el archivo main.dart con un ejemplo
    final mainDartContent = '''
// Este es un ejemplo de archivo principal para un plugin
// Implementa la interfaz PluginInterface para crear tu propio plugin

import 'package:generador_de_json/core/plugins/base_plugin.dart';

class ExamplePlugin extends BasePlugin {
  @override
  String get pluginId => 'com.example.plugin';
  
  @override
  String get pluginName => 'Plugin de Ejemplo';
  
  @override
  String get pluginDescription => 'Un plugin de ejemplo para demostrar la estructura';
  
  @override
  String get pluginVersion => '1.0.0';
  
  @override
  String get pluginAuthor => 'Dart JSON Generator';
  
  @override
  void initialize() {
    print('Plugin de ejemplo inicializado');
  }
  
  @override
  void registerFunctionalities() {
    print('Registrando funcionalidades del plugin de ejemplo');
    // Aquí podrías registrar generadores de datos, formateadores, etc.
  }
}

// Función que devuelve una instancia del plugin
// Esta función sería llamada por el sistema de plugins
dynamic createPlugin() {
  return ExamplePlugin();
}
''';

    final mainDartFile = File(path.join(exampleDir.path, 'main.dart'));
    await mainDartFile.writeAsString(mainDartContent);

    // Crear un README.md con instrucciones
    final readmeContent = '''
# Plugin de Ejemplo

Este es un plugin de ejemplo para el Dart JSON Generator.

## Estructura

- `manifest.json`: Contiene la información del plugin
- `main.dart`: Punto de entrada del plugin

## Desarrollo

Para crear tu propio plugin, debes:

1. Crear una clase que implemente `BasePlugin`
2. Definir las propiedades requeridas (id, nombre, versión, etc.)
3. Implementar los métodos `initialize()` y `registerFunctionalities()`
4. Exponer una función `createPlugin()` que devuelva una instancia de tu plugin

## Instalación

Para instalar un plugin, simplemente colócalo en el directorio `plugins/`.
''';

    final readmeFile = File(path.join(exampleDir.path, 'README.md'));
    await readmeFile.writeAsString(readmeContent);

    AppLogger.info('Plugin de ejemplo creado en: ${exampleDir.path}');
  }
}
