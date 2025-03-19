import 'dart:math';

import 'package:generador_de_json/app.dart';
import 'package:generador_de_json/core/config/app_config.dart';
import 'package:generador_de_json/core/exceptions/exceptions.dart';
import 'package:generador_de_json/core/interfaces/data_generator_interface.dart';
import 'package:generador_de_json/core/utils/logger.dart';
import 'package:generador_de_json/core/utils/validators.dart';
import 'package:uuid/uuid.dart';

/// Generador de datos aleatorios
class RandomDataGenerator implements DataGeneratorInterface {
  /// Instancia de Random para generación de datos
  late final Random _random;

  /// Instancia de Uuid para generación de UUIDs
  final Uuid _uuid = Uuid();

  /// Configuración de la aplicación
  final AppConfig _config = App().config;

  /// Caché de datos generados (para mejorar rendimiento)
  final Map<String, dynamic> _dataCache = {};

  /// Lista de nombres de calles comunes
  final List<String> _streetNames = [
    'Gran Vía',
    'Paseo de la Castellana',
    'Calle Mayor',
    'Avenida de América',
    'Calle Alcalá',
    'Avenida Diagonal',
    'Calle Serrano',
    'Paseo del Prado',
    'Calle Goya',
    'Rambla de Catalunya',
    'Calle Velázquez',
    'Calle Princesa',
    'Paseo de Gracia',
    'Calle Toledo',
    'Calle Atocha',
    'Calle Fuencarral',
    'Calle Preciados',
    'Avenida del Paralelo',
    'Calle Hortaleza',
    'Calle Arenal',
  ];

  /// Lista de ciudades comunes
  final List<String> _cities = [
    'Madrid',
    'Barcelona',
    'Valencia',
    'Sevilla',
    'Zaragoza',
    'Málaga',
    'Murcia',
    'Palma',
    'Las Palmas',
    'Bilbao',
    'Alicante',
    'Córdoba',
    'Valladolid',
    'Vigo',
    'Gijón',
    'L\'Hospitalet',
    'A Coruña',
    'Granada',
    'Vitoria',
    'Elche',
    'Oviedo',
    'Badalona',
    'Cartagena',
    'Terrassa',
  ];

  /// Lista de provincias
  final List<String> _provinces = [
    'Madrid',
    'Barcelona',
    'Valencia',
    'Sevilla',
    'Zaragoza',
    'Málaga',
    'Murcia',
    'Baleares',
    'Las Palmas',
    'Vizcaya',
    'Alicante',
    'Córdoba',
    'Valladolid',
    'Pontevedra',
    'Asturias',
    'Barcelona',
    'A Coruña',
    'Granada',
    'Álava',
    'Alicante',
    'Asturias',
    'Barcelona',
    'Murcia',
    'Barcelona',
  ];

  /// Palabras para generar Lorem Ipsum
  final List<String> _loremWords = [
    'lorem',
    'ipsum',
    'dolor',
    'sit',
    'amet',
    'consectetur',
    'adipiscing',
    'elit',
    'sed',
    'do',
    'eiusmod',
    'tempor',
    'incididunt',
    'ut',
    'labore',
    'et',
    'dolore',
    'magna',
    'aliqua',
    'enim',
    'ad',
    'minim',
    'veniam',
    'quis',
    'nostrud',
    'exercitation',
    'ullamco',
    'laboris',
    'nisi',
    'aliquip',
    'ex',
    'ea',
    'commodo',
    'consequat',
    'duis',
    'aute',
    'irure',
    'reprehenderit',
    'voluptate',
    'velit',
    'esse',
    'cillum',
    'dolore',
    'fugiat',
    'nulla',
    'pariatur',
    'excepteur',
    'sint',
    'occaecat',
    'cupidatat',
    'non',
    'proident',
    'sunt',
    'culpa',
    'qui',
    'officia',
    'deserunt',
    'mollit',
    'anim',
    'id',
    'est',
    'laborum',
    'sed',
    'perspiciatis',
    'unde',
    'omnis',
    'iste',
    'natus',
    'error',
    'voluptatem',
    'accusantium',
    'doloremque',
    'laudantium',
    'totam',
    'rem',
    'aperiam',
    'eaque',
    'ipsa',
    'quae',
    'ab',
    'illo',
    'inventore',
    'veritatis',
    'quasi',
    'architecto',
    'beatae',
    'vitae',
    'dicta',
    'explicabo',
    'nemo',
    'ipsam',
    'voluptatem',
    'quia',
  ];

  /// Caracteres especiales para generación de contraseñas
  final List<String> _specialChars = [
    '!',
    '@',
    '#',
    '\$',
    '%',
    '^',
    '&',
    '*',
    '(',
    ')',
    '-',
    '_',
    '+',
    '=',
    '[',
    ']',
    '{',
    '}',
    ';',
    ':',
    ',',
    '.',
    '<',
    '>',
    '/',
    '?',
    '|',
    '\\',
  ];

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

      // Generar un identificador aleatorio entre 1 y 70
      final avatarId = 1 + _random.nextInt(70);

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

  /// Genera coordenadas geográficas aleatorias [latitud, longitud]
  @override
  Map<String, double> generateRandomGeoCoordinates({
    double minLat = -90.0,
    double maxLat = 90.0,
    double minLong = -180.0,
    double maxLong = 180.0,
  }) {
    Validators.validateRange(minLat, maxLat);
    Validators.validateRange(minLong, maxLong);

    try {
      if (_config.shouldUseCache() && _dataCache.containsKey('geo_coordinates')) {
        return _dataCache['geo_coordinates'] as Map<String, double>;
      }

      final latitude = generateRandomDouble(min: minLat, max: maxLat, decimals: 6);
      final longitude = generateRandomDouble(min: minLong, max: maxLong, decimals: 6);

      final coordinates = {'latitude': latitude, 'longitude': longitude};
      _dataCache['geo_coordinates'] = coordinates;
      return coordinates;
    } catch (e) {
      AppLogger.error('Error al generar coordenadas geográficas', e, StackTrace.current);
      throw DataGeneratorException.randomGenerationError('Error al generar coordenadas geográficas', originalError: e);
    }
  }

  /// Genera un código postal aleatorio (formato específico del país)
  @override
  String generateRandomPostalCode({String countryCode = 'ES'}) {
    Validators.validateNotNull(countryCode, 'countryCode');

    try {
      final cacheKey = 'postal_code_$countryCode';
      if (_config.shouldUseCache() && _dataCache.containsKey(cacheKey)) {
        return _dataCache[cacheKey] as String;
      }

      String postalCode;
      switch (countryCode.toUpperCase()) {
        case 'ES': // España: 5 dígitos
          postalCode = (10000 + _random.nextInt(90000)).toString();
          break;
        case 'US': // Estados Unidos: 5 dígitos o 5+4
          final base = (10000 + _random.nextInt(90000)).toString();
          postalCode = _random.nextBool() ? base : '$base-${1000 + _random.nextInt(9000)}';
          break;
        case 'UK': // Reino Unido: combinación de letras y números
          final areaCode = String.fromCharCodes(List.generate(2, (_) => _random.nextInt(26) + 65));
          final districtCode = _random.nextInt(100).toString().padLeft(2, '0');
          final sectorCode = _random.nextInt(10).toString();
          final unitCode = String.fromCharCodes(List.generate(2, (_) => _random.nextInt(26) + 65));
          postalCode = '$areaCode$districtCode $sectorCode$unitCode';
          break;
        case 'FR': // Francia: 5 dígitos
          postalCode = (10000 + _random.nextInt(90000)).toString();
          break;
        case 'IT': // Italia: 5 dígitos
          postalCode = (10000 + _random.nextInt(90000)).toString();
          break;
        case 'DE': // Alemania: 5 dígitos
          postalCode = (10000 + _random.nextInt(90000)).toString();
          break;
        default: // Por defecto: 5 dígitos
          postalCode = (10000 + _random.nextInt(90000)).toString();
      }

      _dataCache[cacheKey] = postalCode;
      return postalCode;
    } catch (e) {
      AppLogger.error('Error al generar código postal', e, StackTrace.current);
      throw DataGeneratorException.randomGenerationError('Error al generar código postal', originalError: e);
    }
  }

  /// Genera una dirección completa aleatoria
  @override
  Map<String, String> generateRandomAddress({String? countryCode}) {
    try {
      if (_config.shouldUseCache() && _dataCache.containsKey('address')) {
        return _dataCache['address'] as Map<String, String>;
      }

      final country = countryCode?.toUpperCase() ?? 'ES';

      // Generar calle y número
      final streetName = _streetNames[_random.nextInt(_streetNames.length)];
      final streetNumber = _random.nextInt(200) + 1;

      // Generar piso y puerta (a veces incluidos, a veces no)
      final hasFloor = _random.nextBool();
      final floor = hasFloor ? (1 + _random.nextInt(10)).toString() : '';
      final door = hasFloor ? String.fromCharCode(65 + _random.nextInt(6)) : '';

      // Generar código postal
      final postalCode = generateRandomPostalCode(countryCode: country);

      // Generar ciudad y provincia
      final cityIndex = _random.nextInt(_cities.length);
      final city = _cities[cityIndex];
      final province = _provinces[cityIndex];

      // Construir la dirección completa
      final streetLine = hasFloor ? '$streetName, $streetNumber, ${floor}º $door' : '$streetName, $streetNumber';

      final address = {
        'street': streetLine,
        'postalCode': postalCode,
        'city': city,
        'province': province,
        'country': country,
      };

      _dataCache['address'] = address;
      return address;
    } catch (e) {
      AppLogger.error('Error al generar dirección', e, StackTrace.current);
      throw DataGeneratorException.randomGenerationError('Error al generar dirección', originalError: e);
    }
  }

  /// Genera un número de teléfono aleatorio (formato específico del país)
  @override
  String generateRandomPhoneNumber({String countryCode = 'ES', bool withPrefix = false}) {
    Validators.validateNotNull(countryCode, 'countryCode');
    Validators.validateNotNull(withPrefix, 'withPrefix');

    try {
      final cacheKey = 'phone_${countryCode}_${withPrefix ? 'with' : 'without'}_prefix';
      if (_config.shouldUseCache() && _dataCache.containsKey(cacheKey)) {
        return _dataCache[cacheKey] as String;
      }

      String phoneNumber;
      String prefix = '';

      switch (countryCode.toUpperCase()) {
        case 'ES': // España
          prefix = withPrefix ? '+34 ' : '';
          // Móviles comienzan por 6 o 7, fijos por 8 o 9
          final firstDigit = [6, 7, 8, 9][_random.nextInt(4)];
          final restDigits = List.generate(8, (_) => _random.nextInt(10)).join();
          phoneNumber = '$prefix$firstDigit$restDigits';
          break;
        case 'US': // Estados Unidos
          prefix = withPrefix ? '+1 ' : '';
          final areaCode = 200 + _random.nextInt(800); // Evitar códigos de área reservados
          final firstPart = 200 + _random.nextInt(800);
          final secondPart = 1000 + _random.nextInt(9000);
          phoneNumber = '$prefix($areaCode) $firstPart-$secondPart';
          break;
        case 'UK': // Reino Unido
          prefix = withPrefix ? '+44 ' : '';
          final areaCode = _random.nextInt(1000) + 100;
          final localNumber = List.generate(7, (_) => _random.nextInt(10)).join();
          phoneNumber = '$prefix$areaCode $localNumber';
          break;
        default: // Formato genérico internacional
          prefix = withPrefix ? '+${30 + _random.nextInt(180)} ' : '';
          phoneNumber = '$prefix${List.generate(9, (_) => _random.nextInt(10)).join()}';
      }

      _dataCache[cacheKey] = phoneNumber;
      return phoneNumber;
    } catch (e) {
      AppLogger.error('Error al generar número de teléfono', e, StackTrace.current);
      throw DataGeneratorException.randomGenerationError('Error al generar número de teléfono', originalError: e);
    }
  }

  /// Genera un color aleatorio en formato hexadecimal
  @override
  String generateRandomColor({bool withAlpha = false}) {
    Validators.validateNotNull(withAlpha, 'withAlpha');

    try {
      final cacheKey = 'color_${withAlpha ? 'with' : 'without'}_alpha';
      if (_config.shouldUseCache() && _dataCache.containsKey(cacheKey)) {
        return _dataCache[cacheKey] as String;
      }

      final r = _random.nextInt(256);
      final g = _random.nextInt(256);
      final b = _random.nextInt(256);
      final a = withAlpha ? _random.nextInt(256) : null;

      final hexColor =
          withAlpha
              ? '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}${a!.toRadixString(16).padLeft(2, '0')}'
              : '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';

      _dataCache[cacheKey] = hexColor;
      return hexColor;
    } catch (e) {
      AppLogger.error('Error al generar color aleatorio', e, StackTrace.current);
      throw DataGeneratorException.randomGenerationError('Error al generar color aleatorio', originalError: e);
    }
  }

  /// Genera un nombre de usuario aleatorio
  @override
  String generateRandomUsername() {
    try {
      if (_config.shouldUseCache() && _dataCache.containsKey('username')) {
        return _dataCache['username'] as String;
      }

      // Obtener un nombre aleatorio
      final isMale = _random.nextBool();
      final firstName =
          isMale ? _maleNames[_random.nextInt(_maleNames.length)] : _femaleNames[_random.nextInt(_femaleNames.length)];

      // Normalizar el nombre (minúsculas, sin acentos, etc.)
      final normalizedName = firstName
          .toLowerCase()
          .replaceAll(' ', '')
          .replaceAll('á', 'a')
          .replaceAll('é', 'e')
          .replaceAll('í', 'i')
          .replaceAll('ó', 'o')
          .replaceAll('ú', 'u')
          .replaceAll('ñ', 'n')
          .replaceAll('ü', 'u');

      // Diferentes estilos de nombres de usuario
      final styles = [
        () => '$normalizedName${_random.nextInt(1000)}', // nombre123
        () => '$normalizedName${['_', '.', '-'][_random.nextInt(3)]}${_random.nextInt(1000)}', // nombre_123
        () => '${['cool', 'super', 'mega', 'ultra', 'pro'][_random.nextInt(5)]}$normalizedName', // coolnombre
        () => '$normalizedName${['gamer', 'fan', 'lover', 'pro', 'master'][_random.nextInt(5)]}', // nombregamer
        () => 'the$normalizedName', // thenombre
        () => '$normalizedName${_random.nextInt(100)}${['x', 'z', 'y'][_random.nextInt(3)]}', // nombre42x
      ];

      final username = styles[_random.nextInt(styles.length)]();
      _dataCache['username'] = username;
      return username;
    } catch (e) {
      AppLogger.error('Error al generar nombre de usuario', e, StackTrace.current);
      throw DataGeneratorException.randomGenerationError('Error al generar nombre de usuario', originalError: e);
    }
  }

  /// Genera una contraseña aleatoria con opciones de complejidad
  @override
  String generateRandomPassword({
    int length = 12,
    bool includeUppercase = true,
    bool includeNumbers = true,
    bool includeSpecialChars = true,
  }) {
    Validators.validateNotNull(length, 'length');
    Validators.validatePositive(length, 'length');
    Validators.validateNotNull(includeUppercase, 'includeUppercase');
    Validators.validateNotNull(includeNumbers, 'includeNumbers');
    Validators.validateNotNull(includeSpecialChars, 'includeSpecialChars');

    try {
      // Definir los caracteres disponibles según las opciones
      String chars = 'abcdefghijklmnopqrstuvwxyz';
      if (includeUppercase) chars += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      if (includeNumbers) chars += '0123456789';

      // Lista de caracteres especiales si se incluyen
      List<String> specialChars = includeSpecialChars ? _specialChars : [];

      // Generar la contraseña base
      String password = '';
      for (int i = 0; i < length; i++) {
        if (includeSpecialChars && _random.nextInt(10) < 2) {
          // 20% de probabilidad de caracter especial
          password += specialChars[_random.nextInt(specialChars.length)];
        } else {
          password += chars[_random.nextInt(chars.length)];
        }
      }

      // Asegurar que la contraseña tenga al menos un carácter de cada tipo requerido
      if (includeUppercase && !password.contains(RegExp(r'[A-Z]'))) {
        final pos = _random.nextInt(password.length);
        password = password.replaceRange(pos, pos + 1, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'[_random.nextInt(26)]);
      }

      if (includeNumbers && !password.contains(RegExp(r'[0-9]'))) {
        final pos = _random.nextInt(password.length);
        password = password.replaceRange(pos, pos + 1, '0123456789'[_random.nextInt(10)]);
      }

      if (includeSpecialChars && !_specialChars.any((char) => password.contains(char))) {
        final pos = _random.nextInt(password.length);
        password = password.replaceRange(pos, pos + 1, specialChars[_random.nextInt(specialChars.length)]);
      }

      return password;
    } catch (e) {
      AppLogger.error('Error al generar contraseña', e, StackTrace.current);
      throw DataGeneratorException.randomGenerationError('Error al generar contraseña', originalError: e);
    }
  }

  /// Genera un identificador único aleatorio (UUID)
  @override
  String generateRandomUUID() {
    try {
      if (_config.shouldUseCache() && _dataCache.containsKey('uuid')) {
        return _dataCache['uuid'] as String;
      }

      final uuid = _uuid.v4();
      _dataCache['uuid'] = uuid;
      return uuid;
    } catch (e) {
      AppLogger.error('Error al generar UUID', e, StackTrace.current);
      throw DataGeneratorException.randomGenerationError('Error al generar UUID', originalError: e);
    }
  }

  /// Genera URLs aleatorias por categoría
  @override
  String generateRandomUrl({String category = 'web'}) {
    Validators.validateNotNull(category, 'category');

    try {
      final cacheKey = 'url_$category';
      if (_config.shouldUseCache() && _dataCache.containsKey(cacheKey)) {
        return _dataCache[cacheKey] as String;
      }

      String url;
      switch (category.toLowerCase()) {
        case 'image':
          final width = (100 + _random.nextInt(900)) ~/ 100 * 100; // Múltiplo de 100 entre 100 y 1000
          final height = (100 + _random.nextInt(900)) ~/ 100 * 100;
          url = 'https://picsum.photos/$width/$height';
          break;
        case 'profile':
          final id = _random.nextInt(100);
          url = 'https://randomuser.me/api/portraits/${_random.nextBool() ? 'men' : 'women'}/$id.jpg';
          break;
        case 'placeholder':
          final width = 300 + _random.nextInt(700);
          final height = 200 + _random.nextInt(600);
          final bgColor = _random.nextInt(16777215).toRadixString(16).padLeft(6, '0'); // Color aleatorio
          final textColor = _random.nextInt(16777215).toRadixString(16).padLeft(6, '0');
          url = 'https://via.placeholder.com/${width}x$height/$bgColor/$textColor';
          break;
        case 'web':
        default:
          final domainName =
              [
                'example',
                'sample',
                'test',
                'demo',
                'mysite',
                'website',
                'app',
                'service',
                'store',
                'shop',
                'blog',
                'news',
              ][_random.nextInt(12)];

          final tld = ['.com', '.org', '.net', '.io', '.app', '.dev'][_random.nextInt(6)];
          url = 'https://www.$domainName$tld';
      }

      _dataCache[cacheKey] = url;
      return url;
    } catch (e) {
      AppLogger.error('Error al generar URL', e, StackTrace.current);
      throw DataGeneratorException.randomGenerationError('Error al generar URL', originalError: e);
    }
  }

  /// Genera un párrafo de texto aleatorio (lorem ipsum)
  @override
  String generateRandomLoremIpsum({int minWords = 50, int maxWords = 200}) {
    Validators.validateNotNull(minWords, 'minWords');
    Validators.validateNotNull(maxWords, 'maxWords');
    Validators.validateRange(minWords, maxWords);

    try {
      final cacheKey = 'lorem_${minWords}_${maxWords}';
      if (_config.shouldUseCache() && _dataCache.containsKey(cacheKey)) {
        return _dataCache[cacheKey] as String;
      }

      // Determinar cuántas palabras tendrá el texto
      final wordCount = minWords + _random.nextInt(maxWords - minWords + 1);

      // Generar una lista de palabras aleatorias
      final words = List.generate(wordCount, (_) => _loremWords[_random.nextInt(_loremWords.length)]);

      // Construcción de oraciones
      final sentences = <String>[];
      int currentWordIndex = 0;

      while (currentWordIndex < wordCount) {
        // Cada oración tiene entre 5 y 15 palabras
        final sentenceLength = 5 + _random.nextInt(11);
        final endIndex = currentWordIndex + sentenceLength < wordCount ? currentWordIndex + sentenceLength : wordCount;

        // Construir la oración
        String sentence = words.sublist(currentWordIndex, endIndex).join(' ');

        // Primera letra mayúscula
        sentence = sentence.substring(0, 1).toUpperCase() + sentence.substring(1);

        // Punto final
        sentence += '.';

        sentences.add(sentence);
        currentWordIndex = endIndex;
      }

      // Unir oraciones en párrafos
      final paragraphCount = (sentences.length / 5).ceil(); // Aproximadamente 5 oraciones por párrafo
      final paragraphs = <String>[];

      for (int i = 0; i < paragraphCount; i++) {
        final startIndex = i * 5;
        final endIndex = (i + 1) * 5 < sentences.length ? (i + 1) * 5 : sentences.length;
        paragraphs.add(sentences.sublist(startIndex, endIndex).join(' '));
      }

      final loremIpsum = paragraphs.join('\n\n');
      _dataCache[cacheKey] = loremIpsum;
      return loremIpsum;
    } catch (e) {
      AppLogger.error('Error al generar texto Lorem Ipsum', e, StackTrace.current);
      throw DataGeneratorException.randomGenerationError('Error al generar texto Lorem Ipsum', originalError: e);
    }
  }

  /// Limpia la caché de datos generados
  void clearCache() {
    _dataCache.clear();
    AppLogger.debug('Caché de datos generados limpiada');
  }
}
