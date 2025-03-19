import 'package:generador_de_json/core/constants/app_constants.dart';

/// Utilidad para gestionar el versionado semántico (SemVer)
class VersionUtil {
  /// Obtiene la versión completa de la aplicación
  static String get fullVersion => AppConstants.appVersion;

  /// Obtiene el número de versión mayor
  static int get major {
    final parts = _parseVersion();
    return parts.isNotEmpty ? parts[0] : 0;
  }

  /// Obtiene el número de versión menor
  static int get minor {
    final parts = _parseVersion();
    return parts.length > 1 ? parts[1] : 0;
  }

  /// Obtiene el número de versión de parche
  static int get patch {
    final parts = _parseVersion();
    return parts.length > 2 ? parts[2] : 0;
  }

  /// Divide la versión en sus componentes (mayor, menor, parche)
  static List<int> _parseVersion() {
    try {
      final versionParts = AppConstants.appVersion.split('.');
      return versionParts.map(int.parse).toList();
    } catch (e) {
      return [0, 0, 0];
    }
  }

  /// Verifica si la versión actual es mayor o igual a la versión especificada
  static bool isAtLeast(String version) {
    final current = _parseVersion();
    List<int> target;

    try {
      final targetParts = version.split('.');
      target = targetParts.map(int.parse).toList();
    } catch (e) {
      return false;
    }

    // Completar con ceros si la lista de destino es más corta
    while (target.length < 3) {
      target.add(0);
    }

    // Comparar versiones
    for (var i = 0; i < 3; i++) {
      if (i >= current.length) return false;
      if (current[i] > target[i]) return true;
      if (current[i] < target[i]) return false;
    }

    return true;
  }

  /// Construye una nueva versión incrementando uno de los componentes
  /// y reiniciando los componentes de menor nivel
  static String incrementVersion({bool major = false, bool minor = false, bool patch = true}) {
    var newMajor = VersionUtil.major;
    var newMinor = VersionUtil.minor;
    var newPatch = VersionUtil.patch;

    if (major) {
      newMajor++;
      newMinor = 0;
      newPatch = 0;
    } else if (minor) {
      newMinor++;
      newPatch = 0;
    } else if (patch) {
      newPatch++;
    }

    return '$newMajor.$newMinor.$newPatch';
  }
}
