import 'dart:io';

/// Script para actualizar la versión del proyecto en todos los archivos necesarios
/// Ejecución: dart run bin/update_version.dart [major|minor|patch]
void main(List<String> arguments) {
  // Determinar el tipo de incremento
  bool incrementMajor = false;
  bool incrementMinor = false;
  bool incrementPatch = false;

  if (arguments.isNotEmpty) {
    switch (arguments[0].toLowerCase()) {
      case 'major':
        incrementMajor = true;
        break;
      case 'minor':
        incrementMinor = true;
        break;
      case 'patch':
      default:
        incrementPatch = true;
        break;
    }
  } else {
    incrementPatch = true;
  }

  // Leer la versión actual del pubspec.yaml
  final pubspecFile = File('pubspec.yaml');
  final pubspecContent = pubspecFile.readAsStringSync();
  final versionRegExp = RegExp(r'version:\s*(\d+\.\d+\.\d+)');
  final match = versionRegExp.firstMatch(pubspecContent);

  if (match == null) {
    print('Error: No se pudo encontrar la versión en pubspec.yaml');
    exit(1);
  }

  // Obtener los componentes de la versión actual
  final currentVersion = match.group(1)!;
  print('Versión actual: $currentVersion');

  final parts = currentVersion.split('.').map(int.parse).toList();
  var newMajor = parts[0];
  var newMinor = parts[1];
  var newPatch = parts[2];

  // Calcular la nueva versión
  if (incrementMajor) {
    newMajor++;
    newMinor = 0;
    newPatch = 0;
  } else if (incrementMinor) {
    newMinor++;
    newPatch = 0;
  } else if (incrementPatch) {
    newPatch++;
  }

  final newVersion = '$newMajor.$newMinor.$newPatch';
  print('Nueva versión: $newVersion');

  // Actualizar pubspec.yaml
  final newPubspecContent = pubspecContent.replaceFirst('version: $currentVersion', 'version: $newVersion');
  pubspecFile.writeAsStringSync(newPubspecContent);
  print('Actualizado: pubspec.yaml');

  // Actualizar app_constants.dart
  final constantsFile = File('lib/core/constants/app_constants.dart');
  final constantsContent = constantsFile.readAsStringSync();
  final newConstantsContent = constantsContent.replaceFirst(
    "static const String appVersion = '$currentVersion';",
    "static const String appVersion = '$newVersion';",
  );
  constantsFile.writeAsStringSync(newConstantsContent);
  print('Actualizado: lib/core/constants/app_constants.dart');

  // Actualizar o crear CHANGELOG.md
  updateChangelog(newVersion);

  print('\nActualización de versión completada. Nueva versión: $newVersion');
  print('\nAhora puedes actualizar el README.md manualmente si es necesario.');
}

/// Actualiza el CHANGELOG.md con la nueva versión
void updateChangelog(String newVersion) {
  final date = DateTime.now();
  final formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  final changelogFile = File('CHANGELOG.md');
  String content = '';

  if (changelogFile.existsSync()) {
    content = changelogFile.readAsStringSync();
  } else {
    content = '# Changelog\n\n';
  }

  // Insertar la nueva versión después del encabezado
  final insertPosition = content.indexOf('\n') + 1;
  final newEntry = '\n## $newVersion - $formattedDate\n\n- \n\n';

  final newContent = content.substring(0, insertPosition) + newEntry + content.substring(insertPosition);

  changelogFile.writeAsStringSync(newContent);
  print('Actualizado: CHANGELOG.md');
}
