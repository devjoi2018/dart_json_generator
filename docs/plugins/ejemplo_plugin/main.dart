import 'package:generador_de_json/core/plugins/base_plugin.dart';
import 'package:generador_de_json/core/utils/logger.dart';

/// Plugin de ejemplo que proporciona funcionalidades para formatear valores monetarios
/// en diferentes divisas con opciones de configuración.
class CurrencyFormatterPlugin extends BasePlugin {
  final Map<String, String> _currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'MXN': '\$',
    'BRL': 'R\$',
    'CAD': '\$',
    'AUD': '\$',
    'CHF': 'Fr.',
  };

  final Map<String, String> _currencyNames = {
    'USD': 'Dólar estadounidense',
    'EUR': 'Euro',
    'GBP': 'Libra esterlina',
    'JPY': 'Yen japonés',
    'MXN': 'Peso mexicano',
    'BRL': 'Real brasileño',
    'CAD': 'Dólar canadiense',
    'AUD': 'Dólar australiano',
    'CHF': 'Franco suizo',
  };

  // Configuración por defecto
  bool _symbolBeforeValue = true;
  bool _includeSpace = false;
  int _defaultDecimals = 2;
  String _defaultCurrency = 'USD';

  @override
  String get pluginId => 'com.ejemplo.currency_formatter';

  @override
  String get pluginName => 'Formateador de Monedas';

  @override
  String get pluginDescription => 'Plugin para formatear valores monetarios en diferentes divisas';

  @override
  String get pluginVersion => '1.0.0';

  @override
  String get pluginAuthor => 'Tu Nombre';

  @override
  void initialize() {
    AppLogger.info('Inicializando plugin: $pluginName v$pluginVersion');
    // Aquí puedes realizar tareas de inicialización adicionales
  }

  @override
  void registerFunctionalities() {
    AppLogger.debug('Registrando funcionalidades de formateo de monedas');
    // En una implementación real, aquí registrarías el formateador con el sistema principal
  }

  /// Formatea un valor numérico como una cantidad monetaria
  ///
  /// Ejemplo: `formatCurrency(1234.56)` -> `$1,234.56`
  ///
  /// Parámetros:
  /// - `value`: El valor numérico a formatear
  /// - `currencyCode`: Código ISO de la moneda (USD, EUR, etc.)
  /// - `decimals`: Número de decimales a mostrar
  /// - `symbolBeforeValue`: Si true, coloca el símbolo antes del valor
  /// - `includeSpace`: Si true, incluye un espacio entre el símbolo y el valor
  String formatCurrency(
    double value, {
    String? currencyCode,
    int? decimals,
    bool? symbolBeforeValue,
    bool? includeSpace,
  }) {
    final currency = currencyCode ?? _defaultCurrency;
    final decimalsToUse = decimals ?? _defaultDecimals;
    final shouldPlaceSymbolBefore = symbolBeforeValue ?? _symbolBeforeValue;
    final shouldIncludeSpace = includeSpace ?? _includeSpace;

    final symbol = _currencySymbols[currency] ?? currency;
    final space = shouldIncludeSpace ? ' ' : '';

    // Formatear el valor con el número de decimales especificado
    final formattedValue = value.toStringAsFixed(decimalsToUse);

    // Separar miles con comas
    final parts = formattedValue.split('.');
    final wholePart = parts[0];
    final formattedWholePart = _formatWithThousandSeparator(wholePart);

    final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';
    final numericPart = '$formattedWholePart$decimalPart';

    if (shouldPlaceSymbolBefore) {
      return '$symbol$space$numericPart';
    } else {
      return '$numericPart$space$symbol';
    }
  }

  /// Formatea un valor con separadores de miles
  String _formatWithThousandSeparator(String value) {
    final result = StringBuffer();
    final length = value.length;

    for (int i = 0; i < length; i++) {
      if (i > 0 && (length - i) % 3 == 0) {
        result.write(',');
      }
      result.write(value[i]);
    }

    return result.toString();
  }

  /// Obtiene el símbolo para una moneda
  String getCurrencySymbol(String currencyCode) {
    return _currencySymbols[currencyCode] ?? currencyCode;
  }

  /// Obtiene el nombre completo de una moneda
  String getCurrencyName(String currencyCode) {
    return _currencyNames[currencyCode] ?? 'Moneda desconocida';
  }

  /// Obtiene la lista de códigos de moneda disponibles
  List<String> get availableCurrencies => _currencySymbols.keys.toList();

  /// Configura las opciones predeterminadas del formateador
  void configure({String? defaultCurrency, int? defaultDecimals, bool? symbolBeforeValue, bool? includeSpace}) {
    if (defaultCurrency != null) {
      _defaultCurrency = defaultCurrency;
    }

    if (defaultDecimals != null) {
      _defaultDecimals = defaultDecimals;
    }

    if (symbolBeforeValue != null) {
      _symbolBeforeValue = symbolBeforeValue;
    }

    if (includeSpace != null) {
      _includeSpace = includeSpace;
    }

    AppLogger.debug('Configuración actualizada para el formateador de monedas');
  }

  /// Registra una moneda personalizada
  void registerCurrency(String code, String symbol, String name) {
    _currencySymbols[code] = symbol;
    _currencyNames[code] = name;
    AppLogger.debug('Moneda registrada: $code ($name)');
  }
}

// Función factory que será llamada por el sistema de plugins
CurrencyFormatterPlugin createPlugin() {
  return CurrencyFormatterPlugin();
}
