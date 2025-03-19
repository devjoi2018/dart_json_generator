import 'dart:convert';
import 'dart:io';

import 'package:generador_de_json/core/data_generators/data_generator_factory.dart';

void main() {
  // Obtener la instancia del generador de datos
  final dataGenerator = DataGeneratorFactory.create(GeneratorType.random);

  // Crear un mapa para almacenar los puntos generados
  final Map<String, dynamic> geoData = {'type': 'FeatureCollection', 'features': <Map<String, dynamic>>[]};

  // Generar 50 puntos aleatorios en la península ibérica (España y Portugal)
  for (int i = 0; i < 50; i++) {
    // Limpiar la caché del generador para asegurar datos diferentes en cada iteración
    (dataGenerator as dynamic).clearCache();

    // Coordenadas aproximadas de la península ibérica
    final coordinates = dataGenerator.generateRandomGeoCoordinates(
      minLat: 36.0, // Sur de España
      maxLat: 43.8, // Norte de España
      minLong: -9.5, // Oeste de Portugal
      maxLong: 3.3, // Este de España
    );

    // Generar un nombre aleatorio para el punto
    final name = dataGenerator.generateRandomFemaleOrMaleName(isFullName: true);

    // Determinar el país basado en las coordenadas
    final country = _determineCountry(coordinates);

    // Generar una dirección aleatoria
    final address = dataGenerator.generateRandomAddress(countryCode: country);

    // Generar una fecha aleatoria de "registro" del punto
    final date = dataGenerator.generateRandomDate(from: DateTime(2020, 1, 1), to: DateTime.now(), format: 'iso8601');

    // Crear un punto GeoJSON
    final feature = {
      'type': 'Feature',
      'properties': {
        'id': i + 1,
        'name': name,
        'timestamp': date,
        'address': address,
        'elevation': dataGenerator.generateRandomDouble(min: 0, max: 3000, decimals: 1), // Altitud en metros
        'category': _determineCategory(i),
        'country': country,
      },
      'geometry': {
        'type': 'Point',
        'coordinates': [coordinates['longitude'], coordinates['latitude']], // GeoJSON usa [long, lat]
      },
    };

    geoData['features'].add(feature);
  }

  // Guardar los datos en un archivo JSON
  final outputPath = 'output/geo_points.json';
  File(outputPath).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(geoData));

  print('Se han generado 50 puntos geográficos aleatorios. Archivo guardado en: $outputPath');
  print('Puedes visualizar estos puntos en https://geojson.io');
}

// Determinar categoría para el punto
String _determineCategory(int index) {
  final categories = [
    'ciudad',
    'monumento',
    'parque_natural',
    'mirador',
    'playa',
    'montaña',
    'museo',
    'restaurante',
    'hotel',
    'camping',
  ];

  return categories[index % categories.length];
}

// Determinar país basado en las coordenadas
String _determineCountry(Map<String, double> coordinates) {
  // Aproximación simple: longitud < -5 suele ser Portugal, resto España
  return coordinates['longitude']! < -5.0 ? 'PT' : 'ES';
}
