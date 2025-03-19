import 'package:generador_de_json/core/compressors/gzip_compressor.dart';
import 'package:generador_de_json/core/exceptions/exceptions.dart';
import 'package:generador_de_json/core/interfaces/compressor_interface.dart';
import 'package:generador_de_json/core/utils/logger.dart';

/// Registro de compresores disponibles en el sistema
class CompressorRegistry {
  /// Instancia singleton del registro de compresores
  static final CompressorRegistry _instance = CompressorRegistry._internal();

  /// Constructor factory para obtener la instancia singleton
  factory CompressorRegistry() => _instance;

  /// Constructor interno
  CompressorRegistry._internal() {
    _registerDefaultCompressors();
  }

  /// Mapa de compresores registrados por nombre
  final Map<String, CompressorInterface> _compressors = {};

  /// Registra los compresores predeterminados
  void _registerDefaultCompressors() {
    try {
      // Registrar el compresor GZip
      registerCompressor(GzipCompressor());
      AppLogger.debug('Compresor predeterminado registrado: GZip');
    } catch (e) {
      AppLogger.error('Error al registrar compresores predeterminados', e, StackTrace.current);
      rethrow;
    }
  }

  /// Registra un nuevo compresor
  void registerCompressor(CompressorInterface compressor) {
    final compressorName = compressor.compressorName.toLowerCase();
    _compressors[compressorName] = compressor;
    AppLogger.debug('Compresor registrado: ${compressor.compressorName}');
  }

  /// Obtiene un compresor por su nombre
  CompressorInterface getCompressor(String compressorName) {
    final lowerCaseName = compressorName.toLowerCase();
    if (!_compressors.containsKey(lowerCaseName)) {
      throw CompressionException.unsupportedFormat(
        compressorName,
        originalError: 'Formato de compresión no registrado',
      );
    }
    return _compressors[lowerCaseName]!;
  }

  /// Verifica si existe un compresor con el nombre especificado
  bool hasCompressor(String compressorName) {
    return _compressors.containsKey(compressorName.toLowerCase());
  }

  /// Obtiene la lista de nombres de compresores disponibles
  List<String> getAvailableCompressorNames() {
    return _compressors.keys.toList();
  }

  /// Obtiene la lista de extensiones soportadas
  List<String> getSupportedExtensions() {
    return _compressors.values.map((compressor) => compressor.fileExtension).toList();
  }
}
