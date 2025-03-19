/// Excepción base para todas las excepciones personalizadas del sistema
class BaseException implements Exception {
  /// Mensaje de error
  final String message;

  /// Código de error
  final String code;

  /// Error original que causó esta excepción, si existe
  final dynamic originalError;

  /// Timestamp en que ocurrió el error
  final DateTime timestamp;

  /// Constructor
  BaseException({required this.message, required this.code, this.originalError, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'Excepción [$code]: $message';
  }

  /// Retorna un mapa con la información de la excepción
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'originalError': originalError?.toString(),
    };
  }
}
