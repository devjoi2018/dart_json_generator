/// Interfaz para los generadores de datos
abstract class DataGeneratorInterface {
  /// Genera un valor booleano aleatorio con probabilidad configurable
  bool generateRandomBool({double trueProbability = 0.5});

  /// Genera un nombre masculino aleatorio
  String generateRandomMaleName({bool isFullName = false});

  /// Genera un nombre femenino aleatorio
  String generateRandomFemaleName({bool isFullName = false});

  /// Genera un nombre aleatorio (masculino o femenino)
  String generateRandomFemaleOrMaleName({bool isFullName = false});

  /// Genera un correo electrónico aleatorio
  String generateRandomEmail();

  /// Genera una URL de avatar aleatorio
  String generateRandomAvatarUrl();

  /// Genera una fecha aleatoria dentro de un rango con formato configurable
  String generateRandomDate({DateTime? from, DateTime? to, String? format});

  /// Genera un número entero aleatorio dentro de un rango
  int generateRandomInt({int min = 0, int max = 100});

  /// Genera un número decimal aleatorio dentro de un rango con decimales configurables
  double generateRandomDouble({double min = 0.0, double max = 1.0, int decimals = 2});

  /// Genera una dirección IP aleatoria (IPv4 o IPv6)
  String generateRandomIpAddress({bool ipv6 = false});
}
