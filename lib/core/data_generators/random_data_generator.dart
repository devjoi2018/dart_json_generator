import 'dart:math';

import 'package:generador_de_json/app.dart';
import 'package:generador_de_json/core/config/app_config.dart';
import 'package:generador_de_json/core/exceptions/exceptions.dart';
import 'package:generador_de_json/core/interfaces/data_generator_interface.dart';
import 'package:generador_de_json/core/utils/logger.dart';
import 'package:generador_de_json/core/utils/validators.dart';

/// Generador de datos aleatorios
class RandomDataGenerator implements DataGeneratorInterface {
  /// Instancia de Random para generación de datos
  late final Random _random;

  /// Configuración de la aplicación
  final AppConfig _config = App().config;

  /// Caché de datos generados (para mejorar rendimiento)
  final Map<String, dynamic> _dataCache = {};

  /// Constructor
  RandomDataGenerator() {
    // Inicializar el generador de números aleatorios con la semilla configurada
    _random = Random(_config.getSeed());
    AppLogger.debug('Generador de datos inicializado con semilla: ${_config.getSeed()}');
  }

  /// Nombres de mujer comunes
  final List<String> _femaleNames = [
    "María",
    "Ana",
    "Carmen",
    "Josefa",
    "Isabel",
    "Laura",
    "Dolores",
    "Pilar",
    "Lucía",
    "Luisa",
    "Elena",
    "Raquel",
    "Rosa",
    "Manuela",
    "Cristina",
    "Marta",
    "Sara",
    "Paula",
    "Juana",
    "Teresa",
    "Patricia",
    "Irene",
    "Alba",
    "Claudia",
    "Sandra",
    "Marina",
    "Diana",
    "Beatriz",
    "Olga",
    "Julia",
  ];

  /// Apellidos comunes
  final List<String> _lastNames = [
    "García",
    "Rodríguez",
    "González",
    "Fernández",
    "López",
    "Martínez",
    "Sánchez",
    "Pérez",
    "Gómez",
    "Martín",
    "Jiménez",
    "Ruiz",
    "Hernández",
    "Díaz",
    "Moreno",
    "Muñoz",
    "Álvarez",
    "Romero",
    "Alonso",
    "Gutiérrez",
    "Navarro",
    "Torres",
    "Domínguez",
    "Vázquez",
    "Ramos",
    "Gil",
    "Ramírez",
    "Serrano",
    "Blanco",
    "Molina",
  ];

  /// Nombres de hombre comunes
  final List<String> _maleNames = [
    "Antonio",
    "José",
    "Manuel",
    "Francisco",
    "Juan",
    "David",
    "José Antonio",
    "José Luis",
    "Javier",
    "Carlos",
    "Daniel",
    "Miguel",
    "Rafael",
    "Pedro",
    "Alejandro",
    "José Manuel",
    "Ángel",
    "Miguel Ángel",
    "Mario",
    "Fernando",
    "Sergio",
    "Jorge",
    "Luis",
    "Alberto",
    "Juan Carlos",
    "Álvaro",
    "Adrián",
    "Diego",
    "Juan José",
    "Raúl",
  ];

  /// Dominios comunes para emails
  final List<String> _emailDomains = [
    "gmail.com",
    "hotmail.com",
    "yahoo.com",
    "outlook.com",
    "icloud.com",
    "protonmail.com",
    "aol.com",
    "zoho.com",
    "yandex.com",
    "mail.com",
  ];

  /// Genera un nombre de mujer aleatorio
  @override
  String generateRandomFemaleName({bool isFullName = false}) {
    Validators.validateNotNull(isFullName, 'isFullName');

    try {
      final cacheKey = 'female_name_${isFullName ? 'full' : 'single'}';
      if (_config.shouldUseCache() && _dataCache.containsKey(cacheKey)) {
        return _dataCache[cacheKey] as String;
      }

      final name = _femaleNames[_random.nextInt(_femaleNames.length)];

      if (!isFullName) {
        _dataCache[cacheKey] = name;
        return name;
      }

      final lastName1 = _lastNames[_random.nextInt(_lastNames.length)];
      final lastName2 = _lastNames[_random.nextInt(_lastNames.length)];

      final fullName = '$name $lastName1 $lastName2';
      _dataCache[cacheKey] = fullName;
      return fullName;
    } catch (e) {
      AppLogger.error('Error al generar nombre femenino', e, StackTrace.current);
      throw DataGeneratorException.randomGenerationError('Error al generar nombre femenino', originalError: e);
    }
  }

  /// Genera un nombre de hombre aleatorio
  @override
  String generateRandomMaleName({bool isFullName = false}) {
    Validators.validateNotNull(isFullName, 'isFullName');

    try {
      final cacheKey = 'male_name_${isFullName ? 'full' : 'single'}';
      if (_config.shouldUseCache() && _dataCache.containsKey(cacheKey)) {
        return _dataCache[cacheKey] as String;
      }

      final name = _maleNames[_random.nextInt(_maleNames.length)];

      if (!isFullName) {
        _dataCache[cacheKey] = name;
        return name;
      }

      final lastName1 = _lastNames[_random.nextInt(_lastNames.length)];
      final lastName2 = _lastNames[_random.nextInt(_lastNames.length)];

      final fullName = '$name $lastName1 $lastName2';
      _dataCache[cacheKey] = fullName;
      return fullName;
    } catch (e) {
      AppLogger.error('Error al generar nombre masculino', e, StackTrace.current);
      throw DataGeneratorException.randomGenerationError('Error al generar nombre masculino', originalError: e);
    }
  }

  /// Genera un nombre aleatorio que puede ser femenino o masculino
  @override
  String generateRandomFemaleOrMaleName({bool isFullName = false}) {
    Validators.validateNotNull(isFullName, 'isFullName');

    try {
      return _random.nextBool()
          ? generateRandomFemaleName(isFullName: isFullName)
          : generateRandomMaleName(isFullName: isFullName);
    } catch (e) {
      AppLogger.error('Error al generar nombre aleatorio', e, StackTrace.current);
      throw DataGeneratorException.randomGenerationError('Error al generar nombre aleatorio', originalError: e);
    }
  }

  /// Genera un email aleatorio
  @override
  String generateRandomEmail() {
    try {
      if (_config.shouldUseCache() && _dataCache.containsKey('email')) {
        return _dataCache['email'] as String;
      }

      // Generar nombre de usuario basado en nombres aleatorios
      final isMale = _random.nextBool();
      final name =
          isMale ? _maleNames[_random.nextInt(_maleNames.length)] : _femaleNames[_random.nextInt(_femaleNames.length)];
      final surname = _lastNames[_random.nextInt(_lastNames.length)];

      // Determinar si usar punto, guion o subrayado como separador
      final separator = ['.', '_', '-'][_random.nextInt(3)];

      // Generar un sufijo numérico aleatorio
      final suffix = _random.nextInt(9999);

      // Generar un dominio aleatorio
      final domain = _emailDomains[_random.nextInt(_emailDomains.length)];

      // Construir el email completo
      final normalizedName = name
          .toLowerCase()
          .replaceAll(' ', '')
          .replaceAll('á', 'a')
          .replaceAll('é', 'e')
          .replaceAll('í', 'i')
          .replaceAll('ó', 'o')
          .replaceAll('ú', 'u')
          .replaceAll('ñ', 'n')
          .replaceAll('ü', 'u');

      final normalizedSurname = surname
          .toLowerCase()
          .replaceAll(' ', '')
          .replaceAll('á', 'a')
          .replaceAll('é', 'e')
          .replaceAll('í', 'i')
          .replaceAll('ó', 'o')
          .replaceAll('ú', 'u')
          .replaceAll('ñ', 'n')
          .replaceAll('ü', 'u');

      final email = '$normalizedName$separator$normalizedSurname$suffix@$domain';

      _dataCache['email'] = email;
      return email;
    } catch (e) {
      AppLogger.error('Error al generar email aleatorio', e, StackTrace.current);
      throw DataGeneratorException.randomGenerationError('Error al generar email aleatorio', originalError: e);
    }
  }

  /// Genera una URL de avatar aleatorio
  @override
  String generateRandomAvatarUrl() {
    try {
      if (_config.shouldUseCache() && _dataCache.containsKey('avatar')) {
        return _dataCache['avatar'] as String;
      }

      // Generar un identificador aleatorio
      final avatarId = 10000 + _random.nextInt(90000);

      // Generar una URL de avatar aleatorio
      final avatarUrl = 'https://i.pravatar.cc/150?img=$avatarId';

      _dataCache['avatar'] = avatarUrl;
      return avatarUrl;
    } catch (e) {
      AppLogger.error('Error al generar avatar aleatorio', e, StackTrace.current);
      throw DataGeneratorException.randomGenerationError('Error al generar avatar aleatorio', originalError: e);
    }
  }

  /// Genera una fecha aleatoria dentro de un rango
  @override
  String generateRandomDate({DateTime? from, DateTime? to, String? format}) {
    Validators.validateDateRange(from, to);

    try {
      // Definir fechas límite si no se proporcionan
      final fromDate = from ?? DateTime(2000, 1, 1);
      final toDate = to ?? DateTime.now();

      // Calcular la diferencia en días
      final difference = toDate.difference(fromDate).inDays;

      // Generar una fecha aleatoria dentro del rango
      final randomDays = _random.nextInt(difference + 1);
      final randomDate = fromDate.add(Duration(days: randomDays));

      // Formatear la fecha según la configuración o el parámetro
      final dateFormat = format ?? _config.dateFormat;

      if (dateFormat == 'customFormat') {
        return _config.formatDate(randomDate);
      } else {
        return _formatDate(randomDate, dateFormat);
      }
    } catch (e) {
      AppLogger.error('Error al generar fecha aleatoria', e, StackTrace.current);
      throw DataGeneratorException.randomGenerationError('Error al generar fecha aleatoria', originalError: e);
    }
  }

  /// Formatea una fecha según el formato especificado
  String _formatDate(DateTime date, String format) {
    switch (format) {
      case 'iso8601':
        return date.toIso8601String();
      case 'shortDate':
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      case 'longDate':
        final months = [
          'enero',
          'febrero',
          'marzo',
          'abril',
          'mayo',
          'junio',
          'julio',
          'agosto',
          'septiembre',
          'octubre',
          'noviembre',
          'diciembre',
        ];
        return '${date.day} de ${months[date.month - 1]} de ${date.year}';
      case 'timeOnly':
        return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
      case 'usFormat':
        return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
      default:
        return date.toIso8601String();
    }
  }

  /// Genera un número entero aleatorio dentro de un rango
  @override
  int generateRandomInt({int min = 0, int max = 100}) {
    Validators.validateRange(min, max);

    try {
      return min + _random.nextInt(max - min + 1);
    } catch (e) {
      AppLogger.error('Error al generar entero aleatorio', e, StackTrace.current);
      throw DataGeneratorException.randomGenerationError('Error al generar entero aleatorio', originalError: e);
    }
  }

  /// Genera un número decimal aleatorio dentro de un rango
  @override
  double generateRandomDouble({double min = 0.0, double max = 1.0, int decimals = 2}) {
    Validators.validateRange(min, max);
    Validators.validateNotNull(decimals, 'decimals');
    Validators.validatePositive(decimals, 'decimals');

    try {
      final randomValue = min + (_random.nextDouble() * (max - min));
      final factor = pow(10, decimals);
      return (randomValue * factor).round() / factor;
    } catch (e) {
      AppLogger.error('Error al generar decimal aleatorio', e, StackTrace.current);
      throw DataGeneratorException.randomGenerationError('Error al generar decimal aleatorio', originalError: e);
    }
  }

  /// Genera un valor booleano aleatorio con una probabilidad determinada
  @override
  bool generateRandomBool({double trueProbability = 0.5}) {
    Validators.validateProbability(trueProbability);

    try {
      return _random.nextDouble() < trueProbability;
    } catch (e) {
      AppLogger.error('Error al generar booleano aleatorio', e, StackTrace.current);
      throw DataGeneratorException.randomGenerationError('Error al generar booleano aleatorio', originalError: e);
    }
  }

  /// Genera una dirección IP aleatoria
  @override
  String generateRandomIpAddress({bool ipv6 = false}) {
    Validators.validateNotNull(ipv6, 'ipv6');

    try {
      if (ipv6) {
        final segments = List.generate(8, (_) => _generateHexSegment());
        return segments.join(':');
      } else {
        final segments = List.generate(4, (_) => _random.nextInt(256).toString());
        return segments.join('.');
      }
    } catch (e) {
      AppLogger.error('Error al generar dirección IP aleatoria', e, StackTrace.current);
      throw DataGeneratorException.randomGenerationError('Error al generar dirección IP aleatoria', originalError: e);
    }
  }

  /// Genera un segmento hexadecimal para direcciones IPv6
  String _generateHexSegment() {
    final value = _random.nextInt(65536);
    return value.toRadixString(16).padLeft(4, '0');
  }

  /// Limpia la caché de datos generados
  void clearCache() {
    _dataCache.clear();
    AppLogger.debug('Caché de datos generados limpiada');
  }
}
