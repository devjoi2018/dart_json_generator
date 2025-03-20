import 'dart:math';
import 'package:generador_de_json/core/plugins/base_plugin.dart';
import 'package:generador_de_json/core/utils/logger.dart';

/// Plugin avanzado para generar datos geográficos
class GeoDataGeneratorPlugin extends BasePlugin {
  /// Random generator
  final Random _random = Random();

  /// Datos de países (ISO, nombre, capital, latitud, longitud)
  final List<Map<String, dynamic>> _countries = [];

  /// Prefijos de calle por país
  final Map<String, List<String>> _streetPrefixes = {};

  /// Sufijos de calle por país
  final Map<String, List<String>> _streetSuffixes = {};

  /// Coordenadas por continente (límites aproximados)
  final Map<String, Map<String, double>> _continentBounds = {};

  /// Tipos de ubicación para puntos de interés
  final List<String> _poiTypes = [];

  /// Cache de coordenadas generadas recientemente
  final List<Map<String, dynamic>> _coordinateCache = [];

  /// Tamaño máximo de la caché de coordenadas
  static const int _maxCacheSize = 100;

  @override
  String get pluginId => 'com.generador_json.plugins.geo_data';

  @override
  String get pluginName => 'Generador de Datos Geográficos';

  @override
  String get pluginDescription =>
      'Plugin avanzado para generar datos geográficos como coordenadas, direcciones, países, etc.';

  @override
  String get pluginVersion => '1.0.0';

  @override
  String get pluginAuthor => 'Dart JSON Generator';

  @override
  Map<String, dynamic> get pluginConfig => {
    'enableCoordinateCache': true,
    'maxCacheSize': _maxCacheSize,
    'defaultPrecision': 6,
    'defaultCountry': 'ES',
  };

  @override
  void initialize() {
    AppLogger.info('Inicializando plugin: $pluginName (v$pluginVersion)');

    _loadCountriesData();
    _loadStreetData();
    _setupContinentBounds();
    _loadPointsOfInterestTypes();

    AppLogger.debug(
      'Datos cargados: ${_countries.length} países, ${_streetPrefixes.length} prefijos, ${_continentBounds.length} continentes',
    );
  }

  @override
  void registerFunctionalities() {
    AppLogger.debug('Registrando funcionalidades del plugin: $pluginName');
    // En una implementación real, aquí se registrarían los generadores con el sistema principal
  }

  /// Carga la información de países
  void _loadCountriesData() {
    // Datos simplificados para el ejemplo. En una implementación real,
    // se cargarían desde un archivo JSON o una base de datos
    _countries.addAll([
      {
        'code': 'ES',
        'name': 'España',
        'capital': 'Madrid',
        'latitude': 40.4168,
        'longitude': -3.7038,
        'continent': 'Europe',
      },
      {
        'code': 'US',
        'name': 'Estados Unidos',
        'capital': 'Washington D.C.',
        'latitude': 38.8951,
        'longitude': -77.0364,
        'continent': 'North America',
      },
      {
        'code': 'BR',
        'name': 'Brasil',
        'capital': 'Brasilia',
        'latitude': -15.7801,
        'longitude': -47.9292,
        'continent': 'South America',
      },
      {
        'code': 'JP',
        'name': 'Japón',
        'capital': 'Tokio',
        'latitude': 35.6762,
        'longitude': 139.6503,
        'continent': 'Asia',
      },
      {
        'code': 'ZA',
        'name': 'Sudáfrica',
        'capital': 'Pretoria',
        'latitude': -25.7461,
        'longitude': 28.1881,
        'continent': 'Africa',
      },
      {
        'code': 'AU',
        'name': 'Australia',
        'capital': 'Canberra',
        'latitude': -35.2809,
        'longitude': 149.1300,
        'continent': 'Oceania',
      },
    ]);
  }

  /// Carga prefijos y sufijos de calles por país
  void _loadStreetData() {
    _streetPrefixes['ES'] = ['Calle', 'Avenida', 'Plaza', 'Paseo', 'Ronda', 'Vía'];
    _streetPrefixes['US'] = ['Street', 'Avenue', 'Boulevard', 'Lane', 'Drive', 'Road', 'Place'];
    _streetPrefixes['BR'] = ['Rua', 'Avenida', 'Praça', 'Alameda', 'Travessa'];
    _streetPrefixes['JP'] = ['通り', '大通り', '街道', '道'];

    _streetSuffixes['ES'] = ['Alta', 'Mayor', 'Nueva', 'del Sol', 'Real', 'de la Constitución'];
    _streetSuffixes['US'] = ['Main', 'Oak', 'Pine', 'Maple', 'Cedar', 'Washington', 'Lincoln'];
    _streetSuffixes['BR'] = ['Central', 'Principal', 'da Liberdade', 'do Comércio', 'São Paulo'];
    _streetSuffixes['JP'] = ['本町', '中央', '桜', '駅前', '商店街'];
  }

  /// Configura los límites aproximados de continentes para generar coordenadas
  void _setupContinentBounds() {
    _continentBounds['Europe'] = {'minLat': 36.0, 'maxLat': 70.0, 'minLng': -10.0, 'maxLng': 40.0};

    _continentBounds['North America'] = {'minLat': 15.0, 'maxLat': 70.0, 'minLng': -170.0, 'maxLng': -50.0};

    _continentBounds['South America'] = {'minLat': -55.0, 'maxLat': 15.0, 'minLng': -80.0, 'maxLng': -35.0};

    _continentBounds['Asia'] = {'minLat': 0.0, 'maxLat': 65.0, 'minLng': 25.0, 'maxLng': 150.0};

    _continentBounds['Africa'] = {'minLat': -35.0, 'maxLat': 37.0, 'minLng': -20.0, 'maxLng': 50.0};

    _continentBounds['Oceania'] = {'minLat': -50.0, 'maxLat': 0.0, 'minLng': 110.0, 'maxLng': 180.0};
  }

  /// Carga tipos de puntos de interés
  void _loadPointsOfInterestTypes() {
    _poiTypes.addAll([
      'restaurant',
      'cafe',
      'bar',
      'hotel',
      'museum',
      'park',
      'hospital',
      'school',
      'university',
      'library',
      'airport',
      'train_station',
      'bus_station',
      'shopping_mall',
      'supermarket',
      'pharmacy',
      'bank',
      'post_office',
      'gym',
      'cinema',
      'theatre',
      'stadium',
      'zoo',
      'beach',
      'mountain',
      'lake',
      'forest',
    ]);
  }

  /// Genera coordenadas aleatorias
  Map<String, double> generateCoordinates({String? continent, int precision = 6}) {
    // Si hay entradas en la caché y está habilitada, existe una pequeña probabilidad
    // de devolver una coordenada previamente generada
    final useCachedCoord =
        pluginConfig['enableCoordinateCache'] as bool && _coordinateCache.isNotEmpty && _random.nextDouble() < 0.2;

    if (useCachedCoord) {
      final cachedCoordinate = _coordinateCache[_random.nextInt(_coordinateCache.length)];
      return {'latitude': cachedCoordinate['latitude'] as double, 'longitude': cachedCoordinate['longitude'] as double};
    }

    double minLat = -90.0;
    double maxLat = 90.0;
    double minLng = -180.0;
    double maxLng = 180.0;

    // Si se especifica un continente, usar sus límites
    final hasContinentBounds = continent != null && _continentBounds.containsKey(continent);
    if (hasContinentBounds) {
      final bounds = _continentBounds[continent]!;
      minLat = bounds['minLat']!;
      maxLat = bounds['maxLat']!;
      minLng = bounds['minLng']!;
      maxLng = bounds['maxLng']!;
    }

    // Generar coordenadas aleatorias dentro de los límites
    final lat = _roundToPrecision(minLat + _random.nextDouble() * (maxLat - minLat), precision);
    final lng = _roundToPrecision(minLng + _random.nextDouble() * (maxLng - minLng), precision);

    // Almacenar en caché si está habilitada
    if (pluginConfig['enableCoordinateCache'] as bool) {
      _addToCoordinateCache('random', lat, lng);
    }

    return {'latitude': lat, 'longitude': lng};
  }

  /// Genera coordenadas de un país específico
  Map<String, double> generateCountryCoordinates(String countryCode, {double radius = 2.0, int precision = 6}) {
    // Buscar el país por código
    final country = _countries.firstWhere((c) => c['code'] == countryCode, orElse: () => _countries.first);

    // Obtener las coordenadas base del país
    final baseLat = country['latitude'] as double;
    final baseLng = country['longitude'] as double;

    // Generar coordenadas aleatorias alrededor del punto base
    final lat = _roundToPrecision(baseLat + (_random.nextDouble() * 2 - 1) * radius, precision);
    final lng = _roundToPrecision(baseLng + (_random.nextDouble() * 2 - 1) * radius, precision);

    // Almacenar en caché si está habilitada
    if (pluginConfig['enableCoordinateCache'] as bool) {
      _addToCoordinateCache(countryCode, lat, lng);
    }

    return {'latitude': lat, 'longitude': lng};
  }

  /// Genera información de país aleatoria
  Map<String, dynamic> generateCountry() {
    return _countries[_random.nextInt(_countries.length)];
  }

  /// Genera una dirección aleatoria
  Map<String, dynamic> generateAddress({String? countryCode}) {
    final code = countryCode ?? _countries[_random.nextInt(_countries.length)]['code'] as String;

    // Obtener prefijos y sufijos para el país
    final prefixes = _streetPrefixes[code] ?? _streetPrefixes['US']!;
    final suffixes = _streetSuffixes[code] ?? _streetSuffixes['US']!;

    // Generar la dirección
    final streetPrefix = prefixes[_random.nextInt(prefixes.length)];
    final streetSuffix = suffixes[_random.nextInt(suffixes.length)];
    final streetNumber = _random.nextInt(200) + 1;
    final postalCode = _generatePostalCode(code);

    // Generar coordenadas para la dirección
    final coordinates = generateCountryCoordinates(code);

    return {
      'street': '$streetPrefix $streetSuffix, $streetNumber',
      'postalCode': postalCode,
      'country': code,
      'coordinates': coordinates,
    };
  }

  /// Genera un punto de interés aleatorio
  Map<String, dynamic> generatePointOfInterest({String? continent, String? countryCode}) {
    final poiType = _poiTypes[_random.nextInt(_poiTypes.length)];

    Map<String, double> coordinates;
    String country;

    if (countryCode != null) {
      // Generar coordenadas para el país específico
      coordinates = generateCountryCoordinates(countryCode);
      country = countryCode;
    } else if (continent != null) {
      // Generar coordenadas para el continente específico
      coordinates = generateCoordinates(continent: continent);
      // Encontrar un país en ese continente
      final countriesInContinent = _countries.where((c) => c['continent'] == continent).toList();
      country =
          countriesInContinent.isEmpty
              ? _countries[_random.nextInt(_countries.length)]['code'] as String
              : countriesInContinent[_random.nextInt(countriesInContinent.length)]['code'] as String;
    } else {
      // Generar coordenadas completamente aleatorias
      coordinates = generateCoordinates();
      country = _countries[_random.nextInt(_countries.length)]['code'] as String;
    }

    // Nombres de establecimientos por tipo (simplificado)
    final namesByType = {
      'restaurant': ['El Rincón', 'La Bodega', 'Sabor', 'The Kitchen', 'Delicious'],
      'cafe': ['Café Central', 'The Coffee House', 'Espresso Bar', 'Brew', 'Café Paris'],
      'hotel': ['Grand Hotel', 'Plaza Inn', 'Royal Suites', 'Comfort Stay', 'The Luxury'],
      'museum': ['National Museum', 'Modern Art', 'Historical', 'Science Center', 'Natural History'],
    };

    // Generar nombre según el tipo o usar un genérico
    final hasNameType = namesByType.containsKey(poiType);
    final name =
        hasNameType
            ? namesByType[poiType]![_random.nextInt(namesByType[poiType]!.length)]
            : 'Place ${_random.nextInt(100) + 1}';

    return {
      'name': name,
      'type': poiType,
      'coordinates': coordinates,
      'country': country,
      'rating': (_random.nextInt(50) + 10) / 10, // Rating de 1.0 a 6.0
    };
  }

  /// Genera una ruta con múltiples puntos
  List<Map<String, dynamic>> generateRoute({
    int points = 5,
    String? startCountry,
    String? endCountry,
    double maxDistance = 10.0,
  }) {
    final route = <Map<String, dynamic>>[];

    // Determinar país de inicio
    final start = startCountry ?? _countries[_random.nextInt(_countries.length)]['code'] as String;

    // Generar punto inicial
    var lastCoords = generateCountryCoordinates(start);
    route.add({'point': 1, 'coordinates': lastCoords, 'name': 'Start Point', 'country': start});

    // Generar puntos intermedios
    for (int i = 2; i < points; i++) {
      // Generar un punto cercano al anterior
      final newLat = _roundToPrecision(
        lastCoords['latitude']! +
            (_random.nextDouble() * 2 - 1) * maxDistance / (111.32 * cos(lastCoords['latitude']! * pi / 180)),
        6,
      );

      final newLng = _roundToPrecision(
        lastCoords['longitude']! + (_random.nextDouble() * 2 - 1) * maxDistance / 111.32,
        6,
      );

      // Encontrar el país más cercano a estas coordenadas (simplificado)
      final country = _findClosestCountry(newLat, newLng);

      route.add({
        'point': i,
        'coordinates': {'latitude': newLat, 'longitude': newLng},
        'name': 'Waypoint ${i - 1}',
        'country': country,
      });

      lastCoords = {'latitude': newLat, 'longitude': newLng};
    }

    // Determinar país final
    final end = endCountry ?? _countries[_random.nextInt(_countries.length)]['code'] as String;

    // Generar punto final
    final endCoords = generateCountryCoordinates(end);
    route.add({'point': points, 'coordinates': endCoords, 'name': 'End Point', 'country': end});

    return route;
  }

  /// Encuentra el país más cercano a unas coordenadas
  String _findClosestCountry(double lat, double lng) {
    String closestCountry = _countries.first['code'] as String;
    double minDistance = double.maxFinite;

    for (final country in _countries) {
      final countryLat = country['latitude'] as double;
      final countryLng = country['longitude'] as double;

      // Calcular distancia usando la fórmula del haversine (simplificada)
      final dLat = (lat - countryLat) * pi / 180;
      final dLng = (lng - countryLng) * pi / 180;
      final a =
          sin(dLat / 2) * sin(dLat / 2) +
          cos(countryLat * pi / 180) * cos(lat * pi / 180) * sin(dLng / 2) * sin(dLng / 2);
      final c = 2 * atan2(sqrt(a), sqrt(1 - a));
      final distance = 6371 * c; // Radio de la Tierra en km

      final isCloser = distance < minDistance;
      if (isCloser) {
        minDistance = distance;
        closestCountry = country['code'] as String;
      }
    }

    return closestCountry;
  }

  /// Genera un código postal según el formato del país
  String _generatePostalCode(String countryCode) {
    switch (countryCode) {
      case 'ES':
        // 5 dígitos (España)
        return '${_random.nextInt(5) + 1}${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}';
      case 'US':
        // 5 dígitos o ZIP+4 (EEUU)
        final base =
            '${_random.nextInt(9) + 1}${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}';
        return _random.nextBool()
            ? base
            : '$base-${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}';
      case 'BR':
        // CEP - 8 dígitos con guión (Brasil)
        return '${_random.nextInt(9) + 1}${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}-${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}';
      case 'JP':
        // 7 dígitos con guión (Japón)
        return '${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}-${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}';
      default:
        // Formato genérico: 5 dígitos
        return '${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}${_random.nextInt(10)}';
    }
  }

  /// Añade coordenadas a la caché
  void _addToCoordinateCache(String source, double lat, double lng) {
    if (_coordinateCache.length >= (pluginConfig['maxCacheSize'] as int)) {
      _coordinateCache.removeAt(0); // Eliminar la entrada más antigua
    }

    _coordinateCache.add({
      'source': source,
      'latitude': lat,
      'longitude': lng,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Redondea un valor a la precisión especificada
  double _roundToPrecision(double value, int precision) {
    final mod = pow(10.0, precision);
    return (value * mod).round() / mod;
  }

  /// Calcula la distancia entre dos puntos (en kilómetros)
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // Radio de la Tierra en km
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;
    final a =
        sin(dLat / 2) * sin(dLat / 2) + cos(lat1 * pi / 180) * cos(lat2 * pi / 180) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  /// Limpia la caché de coordenadas
  void clearCoordinateCache() {
    _coordinateCache.clear();
    AppLogger.debug('Caché de coordenadas limpiada');
  }

  /// Obtiene estadísticas sobre los datos geográficos
  Map<String, dynamic> getStatistics() {
    return {
      'countryCount': _countries.length,
      'continentCount': _continentBounds.length,
      'poiTypesCount': _poiTypes.length,
      'cacheSize': _coordinateCache.length,
      'streetPrefixCount': _streetPrefixes.values.fold(0, (prev, curr) => prev + curr.length),
      'lastCacheTimestamp':
          _coordinateCache.isEmpty
              ? null
              : DateTime.fromMillisecondsSinceEpoch(_coordinateCache.last['timestamp'] as int).toIso8601String(),
    };
  }
}

/// Función para crear una instancia del plugin
GeoDataGeneratorPlugin createPlugin() {
  return GeoDataGeneratorPlugin();
}
